// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_array.c
// Copyright (C) 2013 Damian Carrillo
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#include <math.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include "adt_array_type.h"

const static size_t INITIAL_CAPACITY = 10;
const static size_t GROWTH_FACTOR    = 2;
const static float  LOAD_FLOOR       = 0.25f;

bool
_adt_array_resize_buffer(struct adt_array *self, size_t capacity);

void *
adt_create_array(const struct adt_ownership_semantics *semantics)
{
	struct adt_array *array = malloc(sizeof *array);
	((struct adt_object *) array)->class = (struct adt_object_ifc *) adt_array_class;
	((struct adt_object *) array)->class->init(array, semantics);
	return array;
}

void *
adt_create_array_with_capacity(
	struct adt_ownership_semantics *semantics,
	size_t capacity)
{
	struct adt_array *array = adt_create_array(semantics);
	_adt_array_resize_buffer(array, capacity);
	return array;
}

void *
adt_create_array_with_list(
	const struct adt_ownership_semantics *semantics,
	const struct adt_list *list)
{
	struct adt_array *self = adt_create_array(semantics);

	if (self && list) {
		unsigned int i, count = adt_count(list);
		for (i = 0; i < count; i++) {
			adt_add(self, adt_retr(list, i));
		}
	}

	return self;
}

void
adt_array_init(void *_self, ...)
{
	va_list ap;
	va_start(ap, _self);

	adt_object_init(_self);

	struct adt_array *self = _self;
	self->semantics = va_arg(ap, struct adt_ownership_semantics *);

	if (!self->semantics) {
		self->semantics = adt_retain_semantics;
	}

	self->count = 0;
	self->capacity = 0;

	va_end(ap);
}

void
adt_array_destroy(void *_self)
{
	struct adt_array *self = _self;

	if (self->capacity > 0) {
		adt_array_clear(self);
		free(self->buffer);
	}

	adt_object_destroy(_self);
}

size_t
adt_array_count(const void *_self)
{
	const struct adt_array *self = _self;
	return self->count;
}

bool
_adt_array_resize_buffer(struct adt_array *self, size_t capacity)
{
	// Check errno for ENOMEM in the caller, it is likely that memory
	// has been exhausted

	size_t size = sizeof(struct adt_object *);

	if (self->capacity == 0) {
		self->capacity = capacity;
		self->buffer = malloc(size * self->capacity);
	} else if (self->count == self->capacity) {
		self->capacity *= GROWTH_FACTOR;
		self->buffer = realloc(self->buffer, size * self->capacity);
	} else {
		size_t threshold = (size_t) roundf(self->capacity * LOAD_FLOOR);

		if (INITIAL_CAPACITY < self->count && self->count < threshold) {
			self->capacity /= GROWTH_FACTOR;
			self->buffer = realloc(self->buffer, size * self->capacity);
		}
	}

	return self->buffer != NULL;
}

size_t
_adt_array_insert(struct adt_array *self,
                  size_t index,
                  struct adt_object *object) {
	if (!_adt_array_resize_buffer(self, INITIAL_CAPACITY)) {
		return 0;
	}

	size_t offset;

	if (index >= self->count) {
		offset = self->count;
	} else {
		void **pos = self->buffer + index;
		memmove(pos + 1, pos, sizeof(*object));
		offset = index;
	}

	*(self->buffer + offset) = self->semantics->establish_ownership(object);
	++self->count;

	return self->count;
}

size_t
adt_array_add(void *_self, void *value)
{
	struct adt_array *self = _self;
	struct adt_object *object = value;

	return _adt_array_insert(self, self->count, object);
}

size_t
adt_array_insert(void *_self, void *key, void *value)
{
	struct adt_array *self = _self;
	size_t index = (size_t) key;
	struct adt_object *object = value;

	return _adt_array_insert(self, index, object);
}

void *
adt_array_remove(void *_self, void *key)
{
	void *value = NULL;

	struct adt_array *self = _self;
	size_t index = (size_t) key;

	if (index < self->count) {
		struct adt_object *object = *(self->buffer + index);

		value = object;
		*(self->buffer + index) = NULL;

		self->semantics->relenquish_ownership(object);

		if (index < self->count - 1) {
			void **pos = self->buffer + index;
			memmove(pos, pos + 1, sizeof(*object) * (self->count - index));
		}

		--self->count;
	}

	return value;
}

void *
adt_array_retrieve(const void *_self, const void *key)
{
	const struct adt_array *self = _self;
	size_t index = (size_t) key;

	void *value = NULL;

	if (index < self->count) {
		value = *(self->buffer + index);
	}

	return value;
}

void
adt_array_clear(void *_self)
{
	struct adt_array *self = _self;

	if (self->count) {
		size_t i, count = self->count;

		for (i = 0; i < count; i++) {
			struct adt_object *object = adt_retr(self, i);
			self->semantics->relenquish_ownership(object);
		}

		self->count = 0;
		_adt_array_resize_buffer(self, INITIAL_CAPACITY);
	}
}

// adt_array -> adt_sequence -> adt_collection -> adt_object
static const struct adt_array_ifc _adt_array_class =
{
	{
		{
			{
				"adt_array_class",
				sizeof(struct adt_array),

				&adt_array_init,
				&adt_object_retain,
				&adt_object_copy,
				&adt_object_release,
				&adt_array_destroy,
				&adt_sequence_equiv,
				&adt_sequence_hash,
				&adt_sequence_print
			},

			&adt_array_count,
			&adt_array_add,
			&adt_array_insert,
			&adt_array_retrieve,
			&adt_array_remove,
			&adt_array_clear,
			NULL
		}
	}
};

const struct adt_array_ifc *adt_array_class = &_adt_array_class;
