// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_object.c
// Copyright (C) 2013 Damian Carrillo
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.	 If not, see <http://www.gnu.org/licenses/>.

#include <limits.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include "adt_object_type.h"

struct adt_object *
adt_create_object()
{
	struct adt_object *object = malloc(sizeof *object);
	object->class = adt_object_class;
	object->class->init(object);
	return object;
}

void
adt_object_init(void *_self, ...)
{
	struct adt_object *self = _self;
	self->retain_count = 1;
}

unsigned int
adt_object_retain(void *_self)
{
	struct adt_object *self = _self;
	return ++self->retain_count;
}

void *
adt_object_copy(const void *_self)
{
	const struct adt_object *self = _self;

	struct adt_object *copy = malloc(self->class->size);
	memcpy(copy, self, self->class->size);
	copy->retain_count = 1;

	return copy;
}

unsigned int
adt_object_release(void *_self)
{
	struct adt_object *self = _self;
	unsigned int retain_count = --self->retain_count;

	if (retain_count == 0) {
		self->class->destroy(self);
	}

	return retain_count;
}

void
adt_object_destroy(void *_self)
{
	struct adt_object *self = _self;
	free(self);
}

bool
adt_object_equiv(const void *_self, const void *_other)
{
	const struct adt_object *self = _self;
	const struct adt_object *other = _other;
	return self == other;
}

unsigned int
adt_object_hash(const void *_self)
{
	const struct adt_object *self = _self;
	intptr_t pself = (intptr_t) self;
	return (int) (pself % UINT_MAX);
}

int
adt_object_print(const void *_self, FILE *dest)
{
	const struct adt_object *self = _self;
	uintptr_t pself = (uintptr_t) self;
	return fprintf(dest, "%s<%u>", self->class->name, (unsigned int) pself);
}

size_t
adt_object_size(void *_self)
{
	struct adt_object *self = _self;
	return self->class->size;
}

unsigned int
adt_retain(void *_self)
{
	unsigned int retain_count = 0;

	if (_self) {
		struct adt_object *self = _self;
		retain_count = self->class->retain(self);
	}

	return retain_count;
}

unsigned int
adt_retain_count(const void *_self)
{
	unsigned int retain_count = 0;

	if (_self) {
		const struct adt_object *self = _self;
		retain_count = self->retain_count;
	}

	return retain_count;
}

void *
adt_copy(const void *_self)
{
	void *copy = NULL;

	if (_self) {
		const struct adt_object *self = _self;
		copy = self->class->copy(self);
	}

	return copy;
}

unsigned int
adt_release(void *_self)
{
	unsigned int retain_count = 0;

	if (_self) {
		struct adt_object *self = _self;
		retain_count = self->class->release(self);
	}

	return retain_count;
}

bool
adt_equiv(const void *_self, const void *other)
{
	bool equiv = false;

	if (_self) {
		const struct adt_object *self = _self;
		equiv = self->class->equiv(self, other);
	} else {
		equiv = !other;
	}

	return equiv;
}

unsigned int
adt_hash(const void *_self)
{
	unsigned int hash = 0;

	if (_self) {
		const struct adt_object *self = _self;
		hash = self->class->hash(self);
	}

	return hash;
}

int
adt_print(const void *_self, FILE *dest)
{
	int result = 0;

	if (dest) {
		if (_self) {
			const struct adt_object *self = _self;
			result = self->class->print(self, dest);
		} else {
			fprintf(dest, "NULL");
		}
	}

	return result;
}

const void *
adt_class(const void *_self)
{
	const void *class = NULL;

	if (_self) {
		const struct adt_object *self = _self;
		class = self->class;
	}

	return class;
}

static const struct adt_object_ifc _adt_object_class =
{
	"adt_object_class",
	sizeof(struct adt_object),

	&adt_object_init,
	&adt_object_retain,
	&adt_object_copy,
	&adt_object_release,
	&adt_object_destroy,
	&adt_object_equiv,
	&adt_object_hash,
	&adt_object_print
};

const struct adt_object_ifc *adt_object_class = &_adt_object_class;
