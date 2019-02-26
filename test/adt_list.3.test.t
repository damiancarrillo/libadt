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
#include "adt_array.h"
#include "adt_pair.h"

static adt_list_t *root;

static adt_list_t *a;
static adt_list_t *b;
static adt_list_t *c;

static adt_object_t *a0;
static adt_object_t *a1;
static adt_object_t *a2;

static adt_object_t *b0;
static adt_object_t *b1;
static adt_object_t *b2;

static adt_object_t *c0;
static adt_object_t *c1;
static adt_object_t *c2;

void
before_test()
{
	root = adt_create_list(NULL);

	a = adt_create_list(NULL);
	b = adt_create_list(NULL);
	c = adt_create_list(NULL);

	a0 = adt_create_object();
	a1 = adt_create_object();
	a2 = adt_create_object();

	b0 = adt_create_object();
	b1 = adt_create_object();
	b2 = adt_create_object();

	c0 = adt_create_object();
	c1 = adt_create_object();
	c2 = adt_create_object();

	adt_add(root, a);
	adt_add(root, b);
	adt_add(root, c);

	adt_add(a, a0);
	adt_add(a, a1);
	adt_add(a, a2);

	adt_add(b, b0);
	adt_add(b, b1);
	adt_add(b, b2);

	adt_add(c, c0);
	adt_add(c, c1);
	adt_add(c, c2);
}

void
after_test()
{
	adt_release(c0);
	adt_release(c1);
	adt_release(c2);

	adt_release(b0);
	adt_release(b1);
	adt_release(b2);

	adt_release(a0);
	adt_release(a1);
	adt_release(a2);

	adt_release(a);
	adt_release(b);
	adt_release(c);

	adt_release(root);
}

void
test_lists_in_lists()
{
	sut_assert(adt_retain_count(root) == 1);

	sut_assert(adt_retain_count(a) == 2);
	sut_assert(adt_retain_count(b) == 2);
	sut_assert(adt_retain_count(c) == 2);

	sut_assert(adt_retain_count(a0) == 2);
	sut_assert(adt_retain_count(a1) == 2);
	sut_assert(adt_retain_count(a2) == 2);

	sut_assert(adt_retain_count(b0) == 2);
	sut_assert(adt_retain_count(b1) == 2);
	sut_assert(adt_retain_count(b2) == 2);

	sut_assert(adt_retain_count(c0) == 2);
	sut_assert(adt_retain_count(c1) == 2);
	sut_assert(adt_retain_count(c2) == 2);
}

void
test_hash()
{
	adt_list_t *z = adt_create_list(NULL);

	adt_add(z, a0);
	adt_add(z, a1);
	adt_add(z, a2);

	sut_assert(adt_hash(a) == adt_hash(z));
	sut_assert(adt_hash(a) != adt_hash(b));

	adt_release(z);
}

void
test_create_with_array()
{
	adt_array_t *array = adt_create_array(NULL);
	adt_add(array, a);
	adt_add(array, b);
	adt_add(array, c);

	sut_assert(adt_count(array) == 3);

	adt_list_t *list = adt_create_list_with_array(NULL, array);
	sut_assert(adt_count(array) == 3);
	sut_assert(adt_retr(list, 0) == a);
	sut_assert(adt_retr(list, 1) == b);
	sut_assert(adt_retr(list, 2) == c);

	adt_release(list);
	adt_release(array);
}

void
test_polymorphism_with_list_as_collection()
{
	adt_collection_t *collection = adt_create_list(NULL);

	adt_add(collection, a);
	adt_add(collection, b);
	adt_add(collection, c);

	sut_assert(adt_count(collection) == 3);
	sut_assert(adt_retrieve(collection, (void *) 0) == a);
	sut_assert(adt_retrieve(collection, (void *) 1) == b);
	sut_assert(adt_retrieve(collection, (void *) 2) == c);

	adt_release(collection);
}

void
test_polymorphism_with_list_as_sequence()
{
	adt_sequence_t *sequence = adt_create_list(NULL);

	adt_add(sequence, a);
	adt_add(sequence, b);
	adt_add(sequence, c);

	sut_assert(adt_count(sequence) == 3);
	sut_assert(adt_retr(sequence, 0) == a);
	sut_assert(adt_retr(sequence, 1) == b);
	sut_assert(adt_retr(sequence, 2) == c);

	adt_release(sequence);
}

void
test_add_with_pair()
{
	adt_object_t *k = adt_create_object(NULL);
	adt_object_t *v = adt_create_object(NULL);
	adt_pair_t *p = adt_create_pair(NULL, k, v);

	adt_sequence_t *sequence = adt_create_list(NULL);

	sut_assert(adt_add(sequence, p) == 1);
	sut_assert(adt_count(sequence) == 1);

	adt_release(k);
	adt_release(v);
	adt_release(p);
	adt_release(sequence);
}

void
test_iterator_with_pairs_with_retain_semantics()
{
	adt_list_t *list = adt_create_list(NULL);

	adt_object_t *k0 = adt_create_object(NULL);
	adt_object_t *k1 = adt_create_object(NULL);
	adt_object_t *k2 = adt_create_object(NULL);

	adt_object_t *v0 = adt_create_object(NULL);
	adt_object_t *v1 = adt_create_object(NULL);
	adt_object_t *v2 = adt_create_object(NULL);

	adt_pair_t *p0 = adt_create_pair(NULL, k0, v0);
	adt_pair_t *p1 = adt_create_pair(NULL, k1, v1);
	adt_pair_t *p2 = adt_create_pair(NULL, k2, v2);

	adt_add(list, p0);
	adt_add(list, p1);
	adt_add(list, p2);

	adt_iterator_t *itr = adt_create_iterator(list);

	sut_assert(itr != NULL);

	unsigned int i = 0;
	while (adt_has_next(itr)) {
		adt_object_t *obj = adt_next(itr);

		switch(i) {
			case 0:
				sut_assert(obj == (adt_object_t *) p0);
				break;
			case 1:
				sut_assert(obj == (adt_object_t *) p1);
				break;
			case 2:
				sut_assert(obj == (adt_object_t *) p2);
				break;
			default:
				sut_assert(false);
				break;
		}

		++i;
	}

	sut_assert(adt_release(itr) == 0);
	sut_assert(i == 3);

	adt_release(p2);
	adt_release(p1);
	adt_release(p0);
	adt_release(v2);
	adt_release(v1);
	adt_release(v0);
	adt_release(k2);
	adt_release(k1);
	adt_release(k0);
	adt_release(list);
}

void
test_iterator_with_pairs_with_copy_semantics()
{
	adt_list_t *list = adt_create_list(adt_copy_semantics);

	adt_object_t *k0 = adt_create_object(NULL);
	adt_object_t *k1 = adt_create_object(NULL);
	adt_object_t *k2 = adt_create_object(NULL);

	adt_object_t *v0 = adt_create_object(NULL);
	adt_object_t *v1 = adt_create_object(NULL);
	adt_object_t *v2 = adt_create_object(NULL);

	adt_pair_t *p0 = adt_create_pair(adt_copy_semantics, k0, v0);
	adt_pair_t *p1 = adt_create_pair(adt_copy_semantics, k1, v1);
	adt_pair_t *p2 = adt_create_pair(adt_copy_semantics, k2, v2);

	adt_add(list, p0);
	adt_add(list, p1);
	adt_add(list, p2);

	adt_iterator_t *itr = adt_create_iterator(list);
	sut_assert(itr != NULL);

	unsigned int i = 0;
	while (adt_has_next(itr)) {
		adt_object_t *obj = adt_next(itr);

		switch(i) {
			case 0:
				sut_assert(obj != (adt_object_t *) p0);
				break;
			case 1:
				sut_assert(obj != (adt_object_t *) p1);
				break;
			case 2:
				sut_assert(obj != (adt_object_t *) p2);
				break;
			default:
				sut_assert(false);
				break;
		}

		++i;
	}

	sut_assert(i == 3);
	sut_assert(adt_release(itr) == 0);

	adt_release(p2);
	adt_release(p1);
	adt_release(p0);
	adt_release(v2);
	adt_release(v1);
	adt_release(v0);
	adt_release(k2);
	adt_release(k1);
	adt_release(k0);
	adt_release(list);
}
