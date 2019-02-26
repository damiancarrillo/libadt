// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_map.2.test.t
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
#include "adt_map.h"

static adt_map_t *mapr;
static adt_map_t *mapc;

static adt_object_t *a;
static adt_object_t *b;
static adt_object_t *c;

static adt_object_t *m;
static adt_object_t *n;
static adt_object_t *o;

void
before_test()
{
	mapr = adt_create_map(adt_retain_semantics);
	mapc = adt_create_map(adt_copy_semantics);
	a = adt_create_object();
	b = adt_create_object();
	c = adt_create_object();
	m = adt_create_object();
	n = adt_create_object();
	o = adt_create_object();
}

void
after_test()
{
	sut_assert(adt_release(mapr) == 0);
	sut_assert(adt_release(mapc) == 0);
	sut_assert(adt_release(a) == 0);
	sut_assert(adt_release(b) == 0);
	sut_assert(adt_release(c) == 0);
	sut_assert(adt_release(m) == 0);
	sut_assert(adt_release(n) == 0);
	sut_assert(adt_release(o) == 0);
}

void
test_insert_with_retain_semantics()
{
	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
	sut_assert(adt_retain_count(c) == 1);

	sut_assert(adt_retain_count(m) == 1);
	sut_assert(adt_retain_count(n) == 1);
	sut_assert(adt_retain_count(o) == 1);

	sut_assert(adt_insert(mapr, a, m) == 1);
	sut_assert(adt_insert(mapr, b, n) == 2);
	sut_assert(adt_insert(mapr, c, o) == 3);

	sut_assert(adt_retain_count(a) == 2);
	sut_assert(adt_retain_count(b) == 2);
	sut_assert(adt_retain_count(c) == 2);

	sut_assert(adt_retain_count(m) == 2);
	sut_assert(adt_retain_count(n) == 2);
	sut_assert(adt_retain_count(o) == 2);

	sut_assert(adt_retain_count(adt_retrieve(mapr, a)) == 2);
	sut_assert(adt_retain_count(adt_retrieve(mapr, b)) == 2);
	sut_assert(adt_retain_count(adt_retrieve(mapr, c)) == 2);

	sut_assert(adt_retrieve(mapr, a) == m);
	sut_assert(adt_retrieve(mapr, b) == n);
	sut_assert(adt_retrieve(mapr, c) == o);
}

void
test_insert_with_copy_semantics()
{
	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
	sut_assert(adt_retain_count(c) == 1);

	sut_assert(adt_retain_count(m) == 1);
	sut_assert(adt_retain_count(n) == 1);
	sut_assert(adt_retain_count(o) == 1);

	sut_assert(adt_insert(mapc, a, m) == 1);
	sut_assert(adt_insert(mapc, b, n) == 2);
	sut_assert(adt_insert(mapc, c, o) == 3);

// 	sut_assert(adt_retain_count(a) == 1);
// 	sut_assert(adt_retain_count(b) == 1);
// 	sut_assert(adt_retain_count(c) == 1);
//
// 	sut_assert(adt_retain_count(m) == 1);
// 	sut_assert(adt_retain_count(n) == 1);
// 	sut_assert(adt_retain_count(o) == 1);
//
// 	sut_assert(adt_retain_count(adt_retrieve(mapc, a)) == 1);
// 	sut_assert(adt_retain_count(adt_retrieve(mapc, b)) == 1);
// 	sut_assert(adt_retain_count(adt_retrieve(mapc, c)) == 1);
//
// 	sut_assert(adt_retrieve(mapc, a) != m);
// 	sut_assert(adt_retrieve(mapc, b) != n);
// 	sut_assert(adt_retrieve(mapc, c) != o);
}
