// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_sequence_type.h
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

#ifndef ADT_SEQUENCE_TYPE_H
#define ADT_SEQUENCE_TYPE_H

#include "adt_collection_type.h"
#include "adt_sequence.h"

struct adt_sequence_ifc {
	struct adt_collection_ifc supertype;
};

struct adt_sequence {

};

bool
adt_sequence_equiv(const void *self, const void *other);

unsigned int
adt_sequence_hash(const void *self);

int
adt_sequence_print(const void *self, FILE *dest);

#endif
