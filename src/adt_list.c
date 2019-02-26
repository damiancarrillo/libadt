// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_list.c
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

#include <stdarg.h>
#include <stdlib.h>
#include <stdbool.h>
#include "adt_list_type.h"

void *
adt_create_list(const struct adt_ownership_semantics *semantics)
{
	struct adt_list *list = malloc(sizeof *list);
	((struct adt_object *) list)->class = (struct adt_object_ifc *) adt_list_class;
	((struct adt_object *) list)->class->init(list, semantics);
	return list;
}

void *
adt_create_list_with_array(
	const struct adt_ownership_semantics *semantics,
	const struct adt_array *array)
{
	struct adt_list *self = adt_create_list(semantics);

	if (self && array) {
		unsigned int i, count = adt_count(array);
		for (i = 0; i < count; i++) {
			adt_add(self, adt_retr(array, i));
		}
	}

	return self;
}

void
adt_list_init(void *_self, ...)
{
	va_list ap;
	va_start(ap, _self);

	adt_object_init(_self);

	struct adt_list *self = _self;
	self->semantics = va_arg(ap, struct adt_ownership_semantics *);

	if (!self->semantics) {
		self->semantics = adt_retain_semantics;
	}

	self->count = 0;
	self->head = NULL;
	self->tail = NULL;

	va_end(ap);
}

void
adt_list_destroy(void *_self)
{
	struct adt_list *self = _self;
	struct adt_list_entry *entry = self->head;

	while (entry) {
		self->semantics->relenquish_ownership(entry->value);

		struct adt_list_entry *destroyed_entry = entry;
		entry = entry->next;

		free(destroyed_entry);
	}

	adt_object_destroy(_self);
}

size_t
adt_list_count(const void *_self)
{
	const struct adt_list *self = _self;
	return self->count;
}

size_t
_adt_list_insert(struct adt_list *self, uintptr_t index, void *value) {
	struct adt_list_entry *entry = malloc(sizeof *entry);

	if (entry == NULL) {

		// Check errno for ENOMEM, it is likely that memory has been exhausted

		return 0;
	}

	entry->value = self->semantics->establish_ownership(value);

	if (index >= self->count) {

		// Add to the end of the list

		entry->prev = self->tail;
		entry->next = NULL;

		if (self->head == NULL) {
			self->head = entry;
		}

		if (self->tail != NULL) {
			self->tail->next = entry;
		}

		self->tail = entry;
	} else if (index == 0) {

		// Insert at the start of the list

		entry->prev = NULL;
		entry->next = self->head;

		if (self->head != NULL) {
			self->head->prev = entry;
		}

		if (self->tail == NULL) {
			self->tail = entry;
		}

		self->head = entry;
	} else {

		// Insert somewhere in the middle of the list

		struct adt_list_entry *cursor = self->head;

		size_t i;
		for (i = 0; i < index - 1; i++) {
		  cursor = cursor->next;
		}

		entry->prev = cursor;
		entry->next = cursor->next;
		cursor->next = entry;
		cursor->next->prev = entry;
	}

	self->count++;

	return self->count;
}

size_t
adt_list_add(void *_self, void *value)
{
	struct adt_list *self = _self;
	return _adt_list_insert(self, self->count, value);
}

size_t
adt_list_insert(void *_self, void *key, void *value)
{
	struct adt_list *self = _self;
	return _adt_list_insert(self, (uintptr_t) key, value);
}

void *
adt_list_retrieve(const void *_self, const void *key)
{
	void *value = NULL;

	const struct adt_list *self = _self;
	size_t index = (size_t) key;

	if (self && self->count > index) {
		struct adt_list_entry *entry = self->head;

		unsigned int i;
		for (i = 0; i < index; i++) {
			entry = entry->next;
		}

		value = entry->value;
	}

	return value;
}

void *
adt_list_remove(void *_self, void *key)
{
	void *value = NULL;
	struct adt_list *self = _self;
	size_t index = (size_t) key;

	if (self && self->count > index) {
		struct adt_list_entry *entry;

		if (index == 0) {
			entry = self->head;
			self->head = self->head->next;

			if (self->head) {
				self->head->prev = NULL;
			}
		} else if (index == self->count - 1) {
			entry = self->tail;
			self->tail = self->tail->prev;
			self->tail->next = NULL;
		} else {
			entry = self->head;

			size_t i;
			for (i = 0; i < index; i++) {
				entry = entry->next;
			}

			entry->prev->next = entry->next;
			if (entry->next) {
				entry->next->prev = entry->prev;
			}
		}

		value = entry->value;
		self->semantics->relenquish_ownership(value);
		free(entry);

		--self->count;
	}

	return value;
}

void
adt_list_clear(void *_self)
{
	struct adt_list *self = _self;

	if (self) {
		struct adt_list_entry *entry = self->head;

		while (entry) {
			struct adt_list_entry *removed_entry = entry;
			entry = entry->next;

			adt_release(removed_entry->value);

			free(removed_entry);
			--self->count;
		}

		self->head = NULL;
		self->tail = NULL;
	}
}

void *
adt_create_list_iterator(const void *list)
{
	struct adt_list_iterator *iterator = malloc(sizeof *iterator);
	((struct adt_object *) iterator)->class =
		(struct adt_object_ifc *) adt_list_iterator_class;
	((struct adt_object *) iterator)->class->init(iterator, list);
	return iterator;
}

void
adt_list_iterator_init(void *_self, ...)
{
	va_list ap;
	va_start(ap, _self);

	adt_object_init(_self);

	struct adt_list_iterator *self = _self;

	self->list = va_arg(ap, struct adt_list *);
	self->entry = NULL;

	adt_retain(self->list);

	va_end(ap);
}

void
adt_list_iterator_destroy(void *_self)
{
	struct adt_list_iterator *self = _self;
	adt_release(self->list);
	adt_object_destroy(_self);
}

bool
adt_list_iterator_has_next(const void *_self) {
	const struct adt_list_iterator *self = _self;
	return self->entry != self->list->tail && self->list->count > 0;
}

void *
adt_list_iterator_next(void *_self) {
	struct adt_list_iterator *self = _self;

	void *value = NULL;

	if (self->entry != self->list->tail) {
		if (!self->entry) {
			self->entry = self->list->head;
		} else {
			self->entry = self->entry->next;
		}

		value = self->entry->value;
	}

	return value;
}

// adt_list -> adt_sequence -> adt_collection -> adt_object
static const struct adt_list_ifc _adt_list_class =
{
	{
		{
			{
				"adt_list_class",
				sizeof(struct adt_list),

				&adt_list_init,
				&adt_object_retain,
				&adt_object_copy,
				&adt_object_release,
				&adt_list_destroy,
				&adt_sequence_equiv,
				&adt_sequence_hash,
				&adt_sequence_print
			},

			&adt_list_count,
			&adt_list_add,
			&adt_list_insert,
			&adt_list_retrieve,
			&adt_list_remove,
			&adt_list_clear,
			&adt_create_list_iterator
		}
	}
};

const struct adt_list_ifc *adt_list_class = &_adt_list_class;

// adt_list_iterator -> adt_iterator -> adt_object
static const struct adt_list_iterator_ifc _adt_list_iterator_class =
{
	{
		{
			"adt_object_class",
			sizeof(struct adt_object),

			&adt_list_iterator_init,
			&adt_object_retain,
			&adt_object_copy,
			&adt_object_release,
			&adt_list_iterator_destroy,
			&adt_object_equiv,
			&adt_object_hash,
			&adt_object_print
		},

		&adt_list_iterator_has_next,
		&adt_list_iterator_next
	}
};

const struct adt_list_iterator_ifc *adt_list_iterator_class = &_adt_list_iterator_class;
