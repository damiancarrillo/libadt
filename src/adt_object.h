// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_object.h
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

#ifndef ADT_OBJECT_H
#define ADT_OBJECT_H

#include <stdio.h>
#include <stdbool.h>

extern const struct adt_object_ifc *adt_object_class;

typedef struct adt_object adt_object_t;

adt_object_t *
adt_create_object();

unsigned int
adt_retain(void *self);

unsigned int
adt_release(void *self);

void *
adt_copy(const void *self);

unsigned int
adt_retain_count(const void *self);

bool
adt_equiv(const void *self, const void *other);

unsigned int
adt_hash(const void *self);

int
adt_print(const void *self, FILE *dest);

const void *
adt_class(const void *self);

#endif
