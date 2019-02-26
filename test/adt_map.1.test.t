// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_map.1.test.t
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
#include "adt_map.h"

static adt_map_t *map;

static adt_object_t *a;
static adt_object_t *b;
static adt_object_t *c;

static adt_object_t *m;
static adt_object_t *n;
static adt_object_t *o;

void
before_test()
{
	map = adt_create_map(NULL);
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
	sut_assert(adt_release(map) == 0);
	sut_assert(adt_release(a) == 0);
	sut_assert(adt_release(b) == 0);
	sut_assert(adt_release(c) == 0);
	sut_assert(adt_release(m) == 0);
	sut_assert(adt_release(n) == 0);
	sut_assert(adt_release(o) == 0);
}

void
test_count_when_empty()
{
	unsigned int count = adt_count(map);
	sut_assert(count == 0);
}

void
test_empty_when_empty()
{
	sut_assert(adt_empty(map));
}

void
test_add_with_null_self()
{
	adt_pair_t *p0 = adt_create_pair(NULL, a, m);

	sut_assert(adt_add(NULL, p0) == 0);

	adt_release(p0);
}

void
test_add_with_valid_pair()
{
	adt_pair_t *p0 = adt_create_pair(NULL, a, m);
	adt_pair_t *p1 = adt_create_pair(NULL, b, n);
	adt_pair_t *p2 = adt_create_pair(NULL, c, o);

	sut_assert(adt_add(map, p0) == 1);
	sut_assert(adt_add(map, p1) == 2);
	sut_assert(adt_add(map, p2) == 3);
	sut_assert(adt_count(map) == 3);

	adt_release(p0);
	adt_release(p1);
	adt_release(p2);
}

void
test_add_with_invalid_pair()
{
	adt_pair_t *p = adt_create_pair(NULL, NULL, m);
	sut_assert(adt_add(map, p) == 0);
	sut_assert(adt_count(map) == 0);

	adt_release(p);
}

void
test_add_with_null_key()
{
	sut_assert(adt_add(map, NULL) == 0);
	sut_assert(adt_count(map) == 0);
}

void
test_insert_with_null_self()
{
	sut_assert(adt_insert(NULL, a, m) == 0);
}

void
test_insert_with_valid_key()
{
	sut_assert(adt_insert(map, a, m) == 1);
	sut_assert(adt_insert(map, b, n) == 2);
	sut_assert(adt_insert(map, c, o) == 3);
	sut_assert(adt_count(map) == 3);
}

void
test_insert_with_null_key()
{
	sut_assert(adt_insert(map, NULL, m) == 0);
	sut_assert(adt_count(map) == 0);
}

void
test_retrieve_with_null_self()
{
	sut_assert(adt_retrieve(NULL, a) == NULL);
}

void
test_retrieve_with_null_key()
{
	sut_assert(adt_retrieve(map, NULL) == NULL);
}

void
test_retrieve_with_valid_key()
{
	sut_assert(adt_insert(map, a, m) == 1);
	sut_assert(adt_insert(map, b, n) == 2);
	sut_assert(adt_insert(map, c, o) == 3);

	sut_assert(adt_retrieve(map, a) == m);
	sut_assert(adt_retrieve(map, b) == n);
	sut_assert(adt_retrieve(map, c) == o);
}

void
test_retrieve_with_key_not_in_map()
{
	sut_assert(adt_insert(map, a, m) == 1);
	sut_assert(adt_retrieve(map, b) == NULL);
}

void
test_remove_with_null_self()
{
	sut_assert(adt_remove(NULL, a) == NULL);
}

void
test_remove_with_null_key()
{
	sut_assert(adt_remove(map, NULL) == NULL);
}

void
test_remove_with_valid_key()
{
	sut_assert(adt_insert(map, a, m) == 1);
	sut_assert(adt_insert(map, b, n) == 2);
	sut_assert(adt_insert(map, c, o) == 3);

	sut_assert(adt_count(map) == 3);

	adt_object_t *obj;

	obj = adt_remove(map, a);
	sut_assert(adt_equiv(obj, m));
	sut_assert(adt_count(map) == 2);

	obj = adt_remove(map, b);
	sut_assert(adt_equiv(obj, n));
	sut_assert(adt_count(map) == 1);

	obj = adt_remove(map, c);
	sut_assert(adt_equiv(obj, o));
}

void
test_remove_with_key_not_in_map()
{
	sut_assert(adt_insert(map, a, m) == 1);
	sut_assert(adt_count(map) == 1);

	sut_assert(adt_remove(map, b) == NULL);
	sut_assert(adt_count(map) == 1);
}

void
test_clear_with_populated_map()
{
	sut_assert(adt_insert(map, a, m) == 1);
	sut_assert(adt_insert(map, b, n) == 2);
	sut_assert(adt_insert(map, c, o) == 3);

	sut_assert(adt_count(map) == 3);

	adt_clear(map);
	sut_assert(adt_count(map) == 0);
}

void
test_equiv_with_equivalent_maps()
{
	adt_map_t *m0 = adt_create_map(NULL);
	adt_map_t *m1 = adt_create_map(NULL);

	sut_assert(adt_insert(m0, a, m) == 1);
	sut_assert(adt_insert(m0, b, n) == 2);
	sut_assert(adt_insert(m0, c, o) == 3);

	sut_assert(adt_insert(m1, a, m) == 1);
	sut_assert(adt_insert(m1, b, n) == 2);
	sut_assert(adt_insert(m1, c, o) == 3);

	sut_assert(adt_equiv(m0, m1));

	adt_release(m0);
	adt_release(m1);
}

void
test_equiv_with_unequivalent_maps()
{
	adt_map_t *m0 = adt_create_map(NULL);
	adt_map_t *m1 = adt_create_map(NULL);

	sut_assert(adt_insert(m0, a, m) == 1);
	sut_assert(adt_insert(m0, b, NULL) == 2);
	sut_assert(adt_insert(m0, c, o) == 3);

	sut_assert(adt_insert(m1, a, m) == 1);
	sut_assert(adt_insert(m1, b, n) == 2);
	sut_assert(adt_insert(m1, c, o) == 3);

	sut_assert(!adt_equiv(m0, m1));

	adt_release(m0);
	adt_release(m1);
}

void
test_equiv_with_null_self_and_non_null_other()
{
	adt_map_t *m0 = adt_create_map(NULL);

	sut_assert(adt_insert(m0, a, m) == 1);
	sut_assert(adt_insert(m0, b, n) == 2);
	sut_assert(adt_insert(m0, c, o) == 3);

	sut_assert(!adt_equiv(NULL, m0));

	adt_release(m0);
}

void
test_equiv_with_non_null_self_and_null_other()
{
	adt_map_t *m0 = adt_create_map(NULL);

	sut_assert(adt_insert(m0, a, m) == 1);
	sut_assert(adt_insert(m0, b, n) == 2);
	sut_assert(adt_insert(m0, c, o) == 3);

	sut_assert(!adt_equiv(m0, NULL));

	adt_release(m0);
}

void
test_hash_with_empty_map()
{
	adt_map_t *m0 = adt_create_map(NULL);
	adt_map_t *m1 = adt_create_map(NULL);

	sut_assert(adt_hash(m0) == adt_hash(m1));
}

void
test_hash_with_equivalent_maps()
{
	adt_map_t *m0 = adt_create_map(NULL);
	adt_map_t *m1 = adt_create_map(NULL);

	sut_assert(adt_insert(m0, a, m) == 1);
	sut_assert(adt_insert(m0, b, n) == 2);
	sut_assert(adt_insert(m0, c, o) == 3);

	sut_assert(adt_insert(m1, a, m) == 1);
	sut_assert(adt_insert(m1, b, n) == 2);
	sut_assert(adt_insert(m1, c, o) == 3);

	sut_assert(adt_hash(m0) == adt_hash(m1));

	adt_release(m0);
	adt_release(m1);
}

void
test_hash_with_unequivalent_maps()
{
	adt_map_t *m0 = adt_create_map(NULL);
	adt_map_t *m1 = adt_create_map(NULL);

	sut_assert(adt_insert(m0, a, m) == 1);
	sut_assert(adt_insert(m0, b, NULL) == 2);
	sut_assert(adt_insert(m0, c, o) == 3);

	sut_assert(adt_insert(m1, a, m) == 1);
	sut_assert(adt_insert(m1, b, n) == 2);
	sut_assert(adt_insert(m1, c, o) == 3);

	sut_assert(adt_hash(m0) != adt_hash(m1));

	adt_release(m0);
	adt_release(m1);
}

void
test_class_with_item()
{
	sut_assert(adt_class(map) == adt_map_class);
}

void
adt_map_insert_duplicate()
{
	adt_insert(map, a, m);
	adt_insert(map, b, n);

	sut_assert(adt_count(map) == 2);

	sut_assert(adt_insert(map, a, m) == 0);
	sut_assert(adt_insert(map, b, n) == 0);

	adt_insert(map, c, o);

	sut_assert(adt_insert(map, c, o) == 0);
	sut_assert(adt_count(map) == 3);
}
