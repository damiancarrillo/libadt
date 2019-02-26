// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_pair.h
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

#ifndef ADT_PAIR_H
#define ADT_PAIR_H

#include "adt_collection.h"

extern const struct adt_pair_ifc *adt_pair_class;

typedef struct adt_pair adt_pair_t;

struct adt_object;

adt_pair_t *
adt_create_pair(
	const struct adt_ownership_semantics *semantics,
	void *left,
	void *right);

void *
adt_left(const void *self);

void *
adt_right(const void *self);

#endif
