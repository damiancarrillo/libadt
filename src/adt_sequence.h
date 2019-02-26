// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_sequence.h
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

#ifndef ADT_SEQUENCE_H
#define ADT_SEQUENCE_H

#include "adt_collection.h"

typedef struct adt_seqence adt_sequence_t;

size_t
adt_ins(void *self, size_t index, void *value);

void *
adt_retr(const void *self, size_t index);

void *
adt_rem(void *self, size_t index);

#endif
