// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_iterator.c
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

#include <stddef.h>
#include <stdlib.h>
#include "adt_iterator_type.h"

bool
adt_has_next(const void *_self)
{
	bool has_next = false;

	if (_self) {
		const struct adt_object *self = _self;
		has_next = ((struct adt_iterator_ifc *) self->class)->has_next(self);
	}

	return has_next;
}

void *
adt_next(void *_self)
{
	void *next = NULL;

	if (_self) {
		struct adt_object *self = _self;
		next = ((struct adt_iterator_ifc *) self->class)->next(self);
	}

	return next;
}
