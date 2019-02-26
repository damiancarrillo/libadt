// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_object_type.h
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

#ifndef ADT_OBJECT_TYPE_H
#define ADT_OBJECT_TYPE_H

#include <stdbool.h>
#include <stdio.h>
#include "adt_object.h"

struct adt_object_ifc
{
	const char   *name;
	size_t        size;

	void          (*init)   (void *self, ...);
	unsigned int  (*retain) (void *self);
	void         *(*copy)   (const void *self);
	unsigned int  (*release)(void *self);
	void          (*destroy)(void *self);
	bool          (*equiv)  (const void *self, const void *other);
	unsigned int  (*hash)   (const void *self);
	int           (*print)  (const void *self, FILE *dest);
};

struct adt_object
{
	const struct adt_object_ifc *class;
	unsigned int                 retain_count;
};

struct adt_object *
adt_create_object();

void
adt_object_init(void *self, ...);

unsigned int
adt_object_retain(void *self);

void *
adt_object_copy(const void *self);

unsigned int
adt_object_release(void *self);

void
adt_object_destroy(void *self);

bool
adt_object_equiv(const void *self, const void *other);

unsigned int
adt_object_hash(const void *self);

int
adt_object_print(const void *self, FILE *dest);

size_t
adt_object_size(void *self);

#endif
