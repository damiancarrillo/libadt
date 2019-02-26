// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_collection_type.h
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

#ifndef ADT_COLLECTION_TYPE_H
#define ADT_COLLECTION_TYPE_H

#include "adt_object_type.h"
#include "adt_collection.h"

struct adt_collection_ifc {
	struct adt_object_ifc supertype;

	size_t (*count)          (const void *self);
	size_t (*add)            (void *self, void *value);
	size_t (*insert)         (void *self, void *key, void *value);
	void * (*retrieve)       (const void *self, const void *key);
	void * (*remove)         (void *self, void *key);
	void   (*clear)          (void *self);
	void * (*create_iterator)(const void *self);
};

struct adt_collection {

};

#endif
