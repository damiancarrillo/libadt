// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_list.2.test.t
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
#include "adt_list.h"

static adt_list_t   *listc;
static adt_list_t   *listr;
static adt_object_t *a;
static adt_object_t *b;
static adt_object_t *c;

void
before_test()
{
	listc = adt_create_list(adt_copy_semantics);
	listr = adt_create_list(adt_retain_semantics);
	a = adt_create_object();
	b = adt_create_object();
	c = adt_create_object();
}

void
after_test()
{
	sut_assert(adt_release(listc) == 0);
	sut_assert(adt_release(listr) == 0);
	sut_assert(adt_release(a) == 0);
	sut_assert(adt_release(b) == 0);
	sut_assert(adt_release(c) == 0);
}

void
test_add_with_copy_semantics()
{
	sut_assert(adt_add(listc, a) == 1);
	sut_assert(adt_add(listc, b) == 2);
	sut_assert(adt_add(listc, c) == 3);
	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
	sut_assert(adt_retain_count(c) == 1);
	sut_assert(adt_retain_count(adt_retr(listc, 0)) == 1);
	sut_assert(adt_retain_count(adt_retr(listc, 1)) == 1);
	sut_assert(adt_retain_count(adt_retr(listc, 2)) == 1);

	size_t size = sizeof(adt_object_t *);

	sut_assert(memcmp(a, adt_retr(listc, 0), size) == 0);
	sut_assert(memcmp(b, adt_retr(listc, 1), size) == 0);
	sut_assert(memcmp(c, adt_retr(listc, 2), size) == 0);
	sut_assert(a != adt_retr(listc, 0));
	sut_assert(b != adt_retr(listc, 1));
	sut_assert(c != adt_retr(listc, 2));
}

void
test_add_with_retain_semantics()
{
	sut_assert(adt_add(listr, a) == 1);
	sut_assert(adt_add(listr, b) == 2);
	sut_assert(adt_add(listr, c) == 3);
	sut_assert(adt_retain_count(a) == 2);
	sut_assert(adt_retain_count(b) == 2);
	sut_assert(adt_retain_count(c) == 2);
	sut_assert(adt_retain_count(adt_retr(listr, 0)) == 2);
	sut_assert(adt_retain_count(adt_retr(listr, 1)) == 2);
	sut_assert(adt_retain_count(adt_retr(listr, 2)) == 2);

	size_t size = sizeof(adt_object_t *);

	sut_assert(memcmp(a, adt_retr(listr, 0), size) == 0);
	sut_assert(memcmp(b, adt_retr(listr, 1), size) == 0);
	sut_assert(memcmp(c, adt_retr(listr, 2), size) == 0);
	sut_assert(a == adt_retr(listr, 0));
	sut_assert(b == adt_retr(listr, 1));
	sut_assert(c == adt_retr(listr, 2));
}

void
test_remove_with_copy_semantics()
{
	sut_assert(adt_add(listc, a) == 1);
	sut_assert(adt_add(listc, b) == 2);
	sut_assert(adt_add(listc, c) == 3);

	adt_rem(listc, 0);
	adt_rem(listc, 0);
	adt_rem(listc, 0);

	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
	sut_assert(adt_retain_count(c) == 1);
}

void
test_remove_with_retain_semantics()
{
	adt_add(listr, a);
	adt_add(listr, b);
	adt_add(listr, c);

	adt_object_t *obj;

	size_t size = sizeof(adt_object_t *);

	obj = adt_rem(listr, 0);
	sut_assert(memcmp(a, obj, size) == 0);
	sut_assert(a == obj);

	obj = adt_rem(listr, 0);
	sut_assert(memcmp(b, obj, size) == 0);
	sut_assert(b == obj);

	obj = adt_rem(listr, 0);
	sut_assert(memcmp(c, obj, size) == 0);
	sut_assert(c == obj);

	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
	sut_assert(adt_retain_count(c) == 1);
}

void
test_clear_with_retain_semantics()
{
	adt_add(listr, a);
	adt_add(listr, b);
	adt_add(listr, c);

	sut_assert(adt_count(listr) == 3);

	adt_clear(listr);

	sut_assert(adt_count(listr) == 0);
}

void
test_clear_with_copy_semantics()
{
	adt_add(listr, a);
	adt_add(listr, b);
	adt_add(listr, c);

	sut_assert(adt_count(listr) == 3);

	adt_clear(listr);

	sut_assert(adt_count(listr) == 0);
}

void
test_equiv()
{
	adt_list_t *l0 = listr;
	adt_list_t *l1 = adt_create_list(NULL);

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
	adt_add(listr, a);
	adt_add(listr, a);
	adt_add(listr, a);

	FILE *dest = fopen("/dev/null", "r+");

	int char_cnt = adt_print(listr, dest);
	sut_assert(char_cnt > strlen("[<0x0>, <0x0>, <0x0>]"));

	fclose(dest);
}

void
test_create_iterator_from_list_with_retain_semantics()
{
	adt_iterator_t *itr = adt_create_iterator(listr);

	sut_assert(adt_retain_count(listr) == 2);
	sut_assert(adt_retain_count(itr) == 1);

	sut_assert(adt_release(itr) == 0);
	sut_assert(adt_retain_count(listr) == 1);
}

void
test_create_iterator_from_list_with_copy_semantics()
{
	adt_iterator_t *itr = adt_create_iterator(listc);

	sut_assert(adt_retain_count(listc) == 2);
	sut_assert(adt_retain_count(itr) == 1);

	sut_assert(adt_release(itr) == 0);
	sut_assert(adt_retain_count(listc) == 1);
}
