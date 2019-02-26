// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_iterator.h
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

#ifndef ADT_ITERATOR_H
#define ADT_ITERATOR_H

#include <stdbool.h>

typedef struct adt_iterator adt_iterator_t;

bool
adt_has_next(const void *self);

void *
adt_next(void *self);

#endif
