// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_pair.1.test.t
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

void
before_test()
{
	a = adt_create_object();
	b = adt_create_object();
	c = adt_create_object();
}

void
after_test()
{
	sut_assert(adt_release(a) == 0);
	sut_assert(adt_release(b) == 0);
	sut_assert(adt_release(c) == 0);
}

void
test_create_with_copy_semantics()
{
	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);

	adt_pair_t *pair = adt_create_pair(adt_copy_semantics, a, b);

	sut_assert(pair != NULL);
	sut_assert(adt_retain_count(pair) == 1);

	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);

	sut_assert(adt_retain_count(adt_left(pair)) == 1);
	sut_assert(adt_retain_count(adt_right(pair)) == 1);
	sut_assert(adt_left(pair) != a);
	sut_assert(adt_right(pair) != b);

	adt_release(pair);

	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
}

void
test_create_with_retain_semantics()
{
	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);

	adt_pair_t *pair = adt_create_pair(adt_retain_semantics, a, b);

	sut_assert(pair != NULL);
	sut_assert(adt_retain_count(pair) == 1);

	sut_assert(adt_retain_count(a) == 2);
	sut_assert(adt_retain_count(b) == 2);

	sut_assert(adt_retain_count(adt_left(pair)) == 2);
	sut_assert(adt_retain_count(adt_right(pair)) == 2);
	sut_assert(adt_left(pair) == a);
	sut_assert(adt_right(pair) == b);

	adt_release(pair);

	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
}

void
test_copy_with_retain_semantics()
{
	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);

	adt_pair_t *p0 = adt_create_pair(adt_retain_semantics, a, b);

	sut_assert(adt_retain_count(a) == 2);
	sut_assert(adt_retain_count(b) == 2);

	adt_pair_t *p1 = adt_copy(p0);

	sut_assert(adt_retain_count(a) == 2);
	sut_assert(adt_retain_count(b) == 2);

	adt_release(p0);
	adt_release(p1);

	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
}

void
test_copy_with_copy_semantics()
{
	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);

	adt_pair_t *p0 = adt_create_pair(adt_copy_semantics, a, b);

	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);

	adt_pair_t *p1 = adt_copy(p0);

	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);

	adt_release(p0);
	adt_release(p1);

	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
}

