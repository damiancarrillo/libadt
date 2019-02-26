// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_sequence.c
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
#include "adt_sequence_type.h"

size_t
adt_ins(void *self, size_t index, void *value)
{
	return adt_insert(self, (void *) index, value);
}

void *
adt_retr(const void *self, size_t index)
{
	return adt_retrieve(self, (void *) index);
}

void *
adt_rem(void *self, size_t index)
{
	return adt_remove(self, (void *) index);
}

bool
adt_sequence_equiv(const void *self, const void *other)
{
	bool equiv = true;

	if (!other) {
		equiv = false;
	} else if (self != other) {
		if (adt_count(self) != adt_count(other)) {
			equiv = false;
		} else {
			size_t i, count = adt_count(self);
			for (i = 0; i < count; i++) {
				const struct adt_object *a = adt_retr(self, i);
				const struct adt_object *b = adt_retr(other, i);

				if (!adt_equiv(a, b)) {
					equiv = false;
					break;
				}
			}
		}
	}

	return equiv;
}

unsigned int
adt_sequence_hash(const void *self)
{
	unsigned int hash = 1;
	const struct adt_object *object;
	size_t i, count = adt_count(self);

	for (i = 0; i < count; i++) {
		object = adt_retr(self, i);
		hash = 31 * hash + adt_hash(object);
	}

	return hash;
}

int
adt_sequence_print(const void *self, FILE *dest)
{
	int cs = fprintf(dest, "[");
	const struct adt_object *object;

	size_t i, count = adt_count(self);
	for (i = 0; i < count; i++) {
		object = adt_retr(self, i);
		cs += adt_print(object, dest);

		if (i < count - 1) {
			cs += fprintf(dest, ", ");
		}
	}

	cs += fprintf(dest, "]");

	return cs;
}

