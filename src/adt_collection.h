// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_collection.h
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

#ifndef ADT_COLLECTION_H
#define ADT_COLLECTION_H

#include <stdbool.h>
#include "adt_object.h"
#include "adt_iterator.h"

typedef struct adt_collection adt_collection_t;

struct adt_ownership_semantics {
	void *(*establish_ownership) (void *item);
	void  (*relenquish_ownership)(void *item);
};

extern const struct adt_ownership_semantics *adt_copy_semantics;
extern const struct adt_ownership_semantics *adt_retain_semantics;

size_t
adt_count(const void *self);

size_t
adt_add(void *self, void *object);

size_t
adt_insert(void *self, void *key, void *value);

void *
adt_retrieve(const void *self, const void *key);

void *
adt_remove(void *self, void *key);

void
adt_clear(void *self);

bool
adt_empty(const void *self);

adt_iterator_t *
adt_create_iterator(const void *self);

#endif
