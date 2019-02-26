// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_object_test.t
// Copyright (C) 2013 Damian Carrillo
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.	 If not, see <http://www.gnu.org/licenses/>.
//

#include <string.h>
#include "adt_object.h"

void
test_create()
{
	adt_object_t *object = adt_create_object();
	sut_assert(object);
}

void
test_retain()
{
	adt_object_t *object = adt_create_object();

	unsigned int retain_count;

	retain_count = adt_retain(object);
	sut_assert(retain_count == 2);

	retain_count = adt_retain(object);
	sut_assert(retain_count == 3);
}

void
test_retain_with_null()
{
	sut_assert(adt_retain(NULL) == 0);
}

void
test_copy()
{
	adt_object_t *a = adt_create_object();
	adt_object_t *b = adt_copy(a);
	size_t size = sizeof(adt_object_t *);

	sut_assert(memcmp(a, b, size) == 0);
	sut_assert(&a != &b);
}

void
test_release()
{
	adt_object_t *object = adt_create_object();
	adt_retain(object);

	unsigned int retain_count;

	retain_count = adt_release(object);
	sut_assert(retain_count == 1);

	retain_count = adt_release(object);
	sut_assert(retain_count == 0);
}

void
test_release_with_null()
{
	sut_assert(adt_release(NULL) == 0);
}
