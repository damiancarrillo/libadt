// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_array.3.test.t
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
#include "adt_list.h"

static adt_array_t *root;

static adt_array_t *a;
static adt_array_t *b;
static adt_array_t *c;

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
	root = adt_create_array(NULL);

	a = adt_create_array(NULL);
	b = adt_create_array(NULL);
	c = adt_create_array(NULL);

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
test_arrays_in_arrays()
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

	adt_print(root, stderr);
}

void
test_hash()
{
	adt_array_t *z = adt_create_array(NULL);

	adt_add(z, a0);
	adt_add(z, a1);
	adt_add(z, a2);

	sut_assert(adt_hash(a) == adt_hash(z));
	sut_assert(adt_hash(a) != adt_hash(b));

	adt_release(z);
}

void
test_create_with_list()
{
	adt_list_t *list = adt_create_list(NULL);
	adt_add(list, a);
	adt_add(list, b);
	adt_add(list, c);

	sut_assert(adt_count(list) == 3);

	adt_array_t *array = adt_create_array_with_list(NULL, list);
	sut_assert(adt_count(list) == 3);
	sut_assert(adt_retr(array, 0) == a);
	sut_assert(adt_retr(array, 1) == b);
	sut_assert(adt_retr(array, 2) == c);

	adt_release(array);
	adt_release(list);
}

void
test_polymorphism_with_array()
{
	adt_collection_t *collection = adt_create_array(NULL);

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
test_polymorphism_with_array_as_sequence()
{
	adt_sequence_t *sequence = adt_create_array(NULL);

	adt_add(sequence, a);
	adt_add(sequence, b);
	adt_add(sequence, c);

	sut_assert(adt_count(sequence) == 3);
	sut_assert(adt_retr(sequence, 0) == a);
	sut_assert(adt_retr(sequence, 1) == b);
	sut_assert(adt_retr(sequence, 2) == c);

	adt_release(sequence);
}
