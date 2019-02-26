// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_array.2.test.t
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

#include <string.h>
#include "sut_test.h"
#include "adt_array.h"

static adt_array_t  *arrayc;
static adt_array_t  *arrayr;
static adt_object_t *a;
static adt_object_t *b;
static adt_object_t *c;

void
before_test()
{
	arrayc = adt_create_array(adt_copy_semantics);
	arrayr = adt_create_array(adt_retain_semantics);
	a = adt_create_object();
	b = adt_create_object();
	c = adt_create_object();
}

void
after_test()
{
	sut_assert(adt_release(arrayc) == 0);
	sut_assert(adt_release(arrayr) == 0);
	sut_assert(adt_release(a) == 0);
	sut_assert(adt_release(b) == 0);
	sut_assert(adt_release(c) == 0);
}

void
test_add_with_copy_semantics()
{
	sut_assert(adt_add(arrayc, a) == 1);
	sut_assert(adt_add(arrayc, b) == 2);
	sut_assert(adt_add(arrayc, c) == 3);
	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
	sut_assert(adt_retain_count(c) == 1);
	sut_assert(adt_retain_count(adt_retr(arrayc, 0)) == 1);
	sut_assert(adt_retain_count(adt_retr(arrayc, 1)) == 1);
	sut_assert(adt_retain_count(adt_retr(arrayc, 2)) == 1);

	size_t size = sizeof(adt_object_t *);

	sut_assert(memcmp(a, adt_retr(arrayc, 0), size) == 0);
	sut_assert(memcmp(b, adt_retr(arrayc, 1), size) == 0);
	sut_assert(memcmp(c, adt_retr(arrayc, 2), size) == 0);
	sut_assert(a != adt_retr(arrayc, 0));
	sut_assert(b != adt_retr(arrayc, 1));
	sut_assert(c != adt_retr(arrayc, 2));
}

void
test_add_with_retain_semantics()
{
	sut_assert(adt_add(arrayr, a) == 1);
	sut_assert(adt_add(arrayr, b) == 2);
	sut_assert(adt_add(arrayr, c) == 3);
	sut_assert(adt_retain_count(a) == 2);
	sut_assert(adt_retain_count(b) == 2);
	sut_assert(adt_retain_count(c) == 2);
	sut_assert(adt_retain_count(adt_retr(arrayr, 0)) == 2);
	sut_assert(adt_retain_count(adt_retr(arrayr, 1)) == 2);
	sut_assert(adt_retain_count(adt_retr(arrayr, 2)) == 2);

	size_t size = sizeof(adt_object_t *);

	sut_assert(memcmp(a, adt_retr(arrayr, 0), size) == 0);
	sut_assert(memcmp(b, adt_retr(arrayr, 1), size) == 0);
	sut_assert(memcmp(c, adt_retr(arrayr, 2), size) == 0);
	sut_assert(a == adt_retr(arrayr, 0));
	sut_assert(b == adt_retr(arrayr, 1));
	sut_assert(c == adt_retr(arrayr, 2));
}

void
test_remove_with_copy_semantics()
{
	sut_assert(adt_add(arrayc, a) == 1);
	sut_assert(adt_add(arrayc, b) == 2);
	sut_assert(adt_add(arrayc, c) == 3);

	adt_rem(arrayc, 0);
	adt_rem(arrayc, 0);
	adt_rem(arrayc, 0);

	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
	sut_assert(adt_retain_count(c) == 1);
}

void
test_remove_with_retain_semantics()
{
	adt_add(arrayr, a);
	adt_add(arrayr, b);
	adt_add(arrayr, c);

	sut_assert(adt_retain_count(a) == 2);
	sut_assert(adt_retain_count(b) == 2);
	sut_assert(adt_retain_count(c) == 2);

	adt_object_t *obj;

	size_t size = sizeof(adt_object_t *);

	obj = adt_rem(arrayr, 0);
	sut_assert(memcmp(a, obj, size) == 0);
	sut_assert(a == obj);

	obj = adt_rem(arrayr, 0);
	sut_assert(memcmp(b, obj, size) == 0);
	sut_assert(b == obj);

	obj = adt_rem(arrayr, 0);
	sut_assert(memcmp(c, obj, size) == 0);
	sut_assert(c == obj);

	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
	sut_assert(adt_retain_count(c) == 1);
}

void
test_clear_with_retain_semantics()
{
	adt_add(arrayr, a);
	adt_add(arrayr, b);
	adt_add(arrayr, c);

	sut_assert(adt_count(arrayr) == 3);

	adt_clear(arrayr);

	sut_assert(adt_count(arrayr) == 0);
}

void
test_clear_with_copy_semantics()
{
	adt_add(arrayr, a);
	adt_add(arrayr, b);
	adt_add(arrayr, c);

	sut_assert(adt_count(arrayr) == 3);

	adt_clear(arrayr);

	sut_assert(adt_count(arrayr) == 0);
}

void
test_equiv()
{
	adt_array_t *l0 = arrayr;
	adt_array_t *l1 = adt_create_array(NULL);

	adt_add(l0, a);
	sut_assert(!adt_equiv(l0, l1));

 	adt_add(l1, a);
 	sut_assert(adt_equiv(l0, l1));

 	adt_add(l0, b);
 	sut_assert(!adt_equiv(l0, l1));

 	adt_add(l1, b);
 	sut_assert(adt_equiv(l0, l1));

 	adt_add(l0, c);
 	sut_assert(!adt_equiv(l0, l1));

 	adt_add(l1, c);
 	sut_assert(adt_equiv(l0, l1));

 	adt_clear(l0);
 	adt_clear(l1);

	sut_assert(adt_equiv(l0, l1));

 	adt_release(l1);
}

void
test_print_objects()
{
	adt_add(arrayr, a);
	adt_add(arrayr, a);
	adt_add(arrayr, a);

	FILE *dest = fopen("/dev/null", "r+");

	int char_cnt = adt_print(arrayr, dest);
	sut_assert(char_cnt > strlen("[<0x0>, <0x0>, <0x0>]"));

	fclose(dest);
}

