// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_pair_type.h
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

#ifndef ADT_PAIR_TYPE_H
#define ADT_PAIR_TYPE_H

#include "adt_sequence_type.h"
#include "adt_pair.h"

struct adt_pair_ifc {
	struct adt_object_ifc supertype;
	void *(*left) (const void *self);
	void *(*right)(const void *self);
};

struct adt_pair {
	struct adt_object                     super;
	const struct adt_ownership_semantics *semantics;
	struct adt_object                    *left;
	struct adt_object                    *right;
};

void
adt_pair_init(void *self, ...);

void *
adt_pair_left(const void *self);

void *
adt_pair_right(const void *self);

bool
adt_pair_equiv(const void *_self, const void *_other);

unsigned int
adt_pair_hash(const void *self);

int
adt_pair_print(const void *self, FILE *dest);

#endif
