// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_pair.0.test.t
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
#include "adt_pair.h"

static adt_object_t *a;
static adt_object_t *b;
static adt_object_t *c;

static adt_pair_t *p0;
static adt_pair_t *p1;
static adt_pair_t *p2;

void
before_test()
{
	a = adt_create_object();
	b = adt_create_object();
	c = adt_create_object();

	p0 = adt_create_pair(NULL, a, b);
	p1 = adt_create_pair(NULL, a, b);
	p2 = adt_create_pair(NULL, a, c);
}

void
after_test()
{
	adt_release(p0);
	adt_release(p1);
	adt_release(a);
	adt_release(b);
	adt_release(c);
}

void
test_create()
{
	sut_assert(p0 != NULL);
	sut_assert(p1 != NULL);
	sut_assert(adt_retain_count(p0) == 1);
	sut_assert(adt_retain_count(p1) == 1);
	sut_assert(adt_retain_count(p2) == 1);
	sut_assert(adt_retain_count(a) == 4);
	sut_assert(adt_retain_count(b) == 3);
	sut_assert(adt_retain_count(c) == 2);
}

void
test_left_with_null()
{
	sut_assert(adt_left(NULL) == NULL);
}

void
test_left_with_value()
{
	sut_assert(adt_left(p0) == a);
	sut_assert(adt_left(p1) == a);
}

void
test_right_with_null()
{
	sut_assert(adt_right(NULL) == NULL);
}

void
test_right_with_value()
{
	sut_assert(adt_right(p0) == b);
	sut_assert(adt_right(p1) == b);
}

void
test_equiv_with_equivalent_pairs()
{
	sut_assert(adt_equiv(p0, p1));
	sut_assert(adt_equiv(p1, p0));
}

void
test_equiv_with_unequivalent_pairs()
{
	sut_assert(!adt_equiv(p0, p2));
	sut_assert(!adt_equiv(p2, p1));
}

void
test_equiv_with_null_other()
{
	sut_assert(!adt_equiv(p0, NULL));
}

void
test_hash_with_equivalent_pairs()
{
	sut_assert(adt_hash(p0) == adt_hash(p1));
}

void
test_hash_with_unequivalent_pairs()
{
	sut_assert(adt_hash(p0) != adt_hash(p2));
}

void
test_print_with_item()
{
	FILE *dest = fopen("/dev/null", "r+");

	int char_cnt = adt_print(p0, dest);
	sut_assert(char_cnt > strlen("(<0x0>, <0x0>)"));

	fclose(dest);
}

void
test_print_with_null_self()
{
	FILE *dest = fopen("/dev/null", "r+");
	sut_assert(adt_print(NULL, dest) == 0);
	fclose(dest);
}

void
test_print_with_null_dest()
{
	sut_assert(adt_print(a, NULL) == 0);
}

void
test_class_with_item()
{
	sut_assert(adt_class(p0) == adt_pair_class);
}
