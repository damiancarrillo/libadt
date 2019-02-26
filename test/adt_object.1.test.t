// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_object.1.test.t
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
#include "adt_object.h"

static adt_object_t *a;
static adt_object_t *b;
static adt_object_t *c;

void
before_test()
{
	a = adt_create_object();
	b = a;
	c = adt_create_object();
}

void
after_test()
{
	sut_assert(adt_release(a) == 0);
	sut_assert(adt_release(c) == 0);
}

void
test_retain_count_after_creation()
{
	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
	sut_assert(adt_retain_count(c) == 1);
}

void
test_retain_count_with_null()
{
	sut_assert(adt_retain_count(NULL) == 0);
}

void
test_equiv_with_equivalent_items()
{
	sut_assert(adt_equiv(a, b));
}

void
test_equiv_with_unequivalent_items()
{
	sut_assert(!adt_equiv(a, c));
}

void
test_equiv_with_null()
{
	sut_assert(adt_equiv(NULL, NULL));
}

void
test_equiv_with_null_self()
{
	sut_assert(!adt_equiv(NULL, a));
}

void
test_equiv_with_null_other()
{
	sut_assert(!adt_equiv(a, NULL));
}

void
test_hash_with_items()
{
	sut_assert(adt_hash(a) == adt_hash(a));
	sut_assert(adt_hash(a) == adt_hash(b));
	sut_assert(adt_hash(b) == adt_hash(a));
	sut_assert(adt_hash(a) != adt_hash(c));
}

void
test_hash_with_null()
{
	sut_assert(adt_hash(NULL) == 0);
}

void
test_print_with_item()
{
	FILE *dest = fopen("/dev/null", "r+");

	int char_cnt = adt_print(a, dest);
	sut_assert(char_cnt > strlen("<0x0>"));

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
	sut_assert(adt_class(a) == adt_object_class);
}

void
test_class_with_null()
{
	sut_assert(adt_class(NULL) == NULL);
}
