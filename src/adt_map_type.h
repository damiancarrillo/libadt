// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_map_type.h
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

#ifndef ADT_DICTIONARY_TYPE_H
#define ADT_DICTIONARY_TYPE_H

#include "adt_collection_type.h"
#include "adt_sequence_type.h"
#include "adt_map.h"

struct adt_map_ifc {
	struct adt_collection_ifc supertype;
};

struct adt_map {
	struct adt_object                     super;
	const struct adt_ownership_semantics *semantics;
	struct adt_array                     *buckets;
	size_t                                bucket_count;
	size_t                                count;
};

void
adt_map_init(void *self, ...);

void
adt_map_destroy(void *self);

void *
adt_create_map(const struct adt_ownership_semantics *semantics);

size_t
adt_map_count(const void *self);

size_t
adt_map_add(void *self, void *pair);

size_t
adt_map_insert(void *self, void *key, void *value);

void *
adt_map_retrieve(const void *self, const void *key);

void *
adt_map_remove(void *self, void *key);

void
adt_map_clear(void *self);

bool
adt_map_equiv(const void *self, const void *other);

unsigned int
adt_map_hash(const void *self);

int
adt_map_print(const void *self, FILE *dest);

#endif
