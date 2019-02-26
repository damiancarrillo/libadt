// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_collection.c
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

#include "adt_collection_type.h"
#include "adt_iterator_type.h"

size_t
adt_count(const void *_self)
{
	size_t count = 0;

	if (_self) {
		const struct adt_object *self = _self;
		count = ((struct adt_collection_ifc *) self->class)->count(self);
	}

	return count;
}

bool
adt_empty(const void *self)
{
	return adt_count(self) == 0;
}

size_t
adt_add(void *_self, void *value)
{
	size_t count = 0;

	if (_self) {
		struct adt_object *self = _self;
		count = ((struct adt_collection_ifc *) self->class)->add(self, value);
	}

	return count;
}

size_t
adt_insert(void *_self, void *key, void *value)
{
	unsigned int count = 0;

	if (_self) {
		struct adt_object *self = _self;
		count = ((struct adt_collection_ifc *) self->class)->insert(self, key, value);
	}

	return count;
}

void *
adt_retrieve(const void *_self, const void *key)
{
	void *value = NULL;

	if (_self) {
		const struct adt_object *self = _self;
		value = ((struct adt_collection_ifc *) self->class)->retrieve(self, key);
	}

	return value;
}

void *
adt_remove(void *_self, void *key)
{
	void *value = NULL;

	if (_self) {
		struct adt_object *self = _self;
		value = ((struct adt_collection_ifc *) self->class)->remove(self, key);
	}

	return value;
}

void
adt_clear(void *_self)
{
	if (_self) {
		struct adt_object *self = _self;
		((struct adt_collection_ifc *) self->class)->clear(self);
	}
}

struct adt_iterator *
adt_create_iterator(const void *_self)
{
	struct adt_iterator *iterator = NULL;

	if (_self) {
		const struct adt_object *self = _self;
		iterator = ((struct adt_collection_ifc *) self->class)->create_iterator(self);
	}

	return iterator;
}

void *
adt_collection_retain_item(void *value)
{
	struct adt_object *object = value;
	adt_retain(object);
	return object;
}

void *
adt_collection_copy_item(void *item)
{
	struct adt_object *object = item;
	return adt_copy(object);
}

void
adt_collection_release_item(void *value)
{
	struct adt_object *object = value;
	adt_release(object);
}

static const struct adt_ownership_semantics _adt_retain_semantics = {
	&adt_collection_retain_item,
	&adt_collection_release_item
};

const struct adt_ownership_semantics *adt_retain_semantics = &_adt_retain_semantics;

static const struct adt_ownership_semantics _adt_copy_semantics =
{
	&adt_collection_copy_item,
	&adt_collection_release_item
};

const struct adt_ownership_semantics *adt_copy_semantics = &_adt_copy_semantics;
