// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_list_type.h
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

#ifndef ADT_LIST_TYPE_H
#define ADT_LIST_TYPE_H

#include "adt_sequence_type.h"
#include "adt_iterator_type.h"
#include "adt_list.h"

struct adt_list_ifc {
	struct adt_sequence_ifc supertype;
};

struct adt_list_entry {
	struct adt_list_entry *prev;
	void                  *value;
	struct adt_list_entry *next;
};

struct adt_list {
	struct adt_object                     super;
	const struct adt_ownership_semantics *semantics;
	size_t                                count;
	struct adt_list_entry                *head;
	struct adt_list_entry                *tail;
};

struct adt_list_iterator_ifc {
	struct adt_iterator_ifc supertype;
};

struct adt_list_iterator {
	const struct adt_object  super;
	struct adt_list         *list;
	struct adt_list_entry   *entry;
};

void
adt_list_init(void *self, ...);

void
adt_list_destroy(void *self);

size_t
adt_list_count(const void *self);

size_t
adt_list_add(void *self, void *value);

size_t
adt_list_insert(void *self, void *key, void *value);

void *
adt_list_retrieve(const void *self, const void *key);

void *
adt_list_remove(void *self, void *key);

void
adt_list_clear(void *self);

#endif
