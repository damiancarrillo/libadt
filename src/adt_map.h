// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_map.h
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

#ifndef ADT_DICTIONARY_H
#define ADT_DICTIONARY_H

#include <stdio.h>
#include "adt_pair.h"

extern const struct adt_map_ifc *adt_map_class;

typedef struct adt_map adt_map_t;

void *
adt_create_map(const struct adt_ownership_semantics *semantics);

#endif
