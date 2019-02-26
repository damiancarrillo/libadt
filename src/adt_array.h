// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_array.h
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

#ifndef ADT_ARRAY_H
#define ADT_ARRAY_H

#include <stdio.h>
#include "adt_sequence.h"

extern const struct adt_array_ifc *adt_array_class;

typedef struct adt_array adt_array_t;
struct adt_list;

void *
adt_create_array(const struct adt_ownership_semantics *semantics);

void *
adt_create_array_with_capacity(
	struct adt_ownership_semantics *semantics,
	size_t capacity);

void *
adt_create_array_with_list(
	const struct adt_ownership_semantics *semantics,
	const struct adt_list *list);

#endif
