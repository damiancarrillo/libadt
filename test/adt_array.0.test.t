// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_array.0.test.t
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

#include "adt_array.h"

void
test_create()
{
	adt_array_t *array = adt_create_array(NULL);
	sut_assert(array != NULL);
}

void
test_create_with_capacity()
{
	adt_array_t *array = adt_create_array_with_capacity(NULL, 5);
	sut_assert(array != NULL);
	sut_assert(adt_retain_count(array) == 1);
}

void
test_retain()
{
	adt_array_t *array = adt_create_array(NULL);
	unsigned int retain_count;

	retain_count = adt_retain(array);
	sut_assert(retain_count == 2);

	retain_count = adt_retain(array);
	sut_assert(retain_count == 3);
}

void
test_release()
{
	adt_array_t *array = adt_create_array(NULL);
	unsigned int retain_count;

	retain_count = adt_release(array);
	sut_assert(retain_count == 0);
}
