// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_array.1.test.t
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
#include "adt_array.h"

static adt_array_t  *array;
static adt_object_t *a;
static adt_object_t *b;
static adt_object_t *c;

void
before_test()
{
	array = adt_create_array(NULL);
	a = adt_create_object();
	b = adt_create_object();
	c = adt_create_object();
}

void
after_test()
{
	sut_assert(adt_release(array) == 0);
	sut_assert(adt_release(a) == 0);
	sut_assert(adt_release(b) == 0);
	sut_assert(adt_release(c) == 0);
}

void
test_count_when_empty()
{
	unsigned int count = adt_count(array);
	sut_assert(count == 0);
}

void
test_empty_when_empty()
{
	sut_assert(adt_empty(array));
}

void
test_empty_when_not_empty()
{
	adt_add(array, a);
	sut_assert(!adt_empty(array));
}

void
test_add_without_growing_buffer()
{
	sut_assert(adt_add(array, a) == 1);
	sut_assert(adt_count(array) == 1);

	sut_assert(adt_add(array, b) == 2);
	sut_assert(adt_count(array) == 2);

	sut_assert(adt_add(array, c) == 3);
	sut_assert(adt_count(array) == 3);
}

void
test_add_until_buffer_grows()
{
	unsigned int i, count = 100;

	for (i = 0; i < count; i++) {
		adt_object_t *object = adt_create_object();
		adt_add(array, object);
	}

	sut_assert(adt_count(array) == count);
}

void
test_add_null_entry()
{
	adt_add(array, NULL);
	sut_assert(adt_count(array) == 1);
}

void
test_retrieve_from_middle()
{
	adt_add(array, a);
	adt_add(array, b);
	adt_add(array, c);

	adt_object_t *d = adt_retrieve(array, (void *) 1);
	sut_assert(adt_equiv(d, b));
	sut_assert(d == b);
}

void
test_retrieve_from_head()
{
	adt_add(array, a);
	adt_add(array, b);
	adt_add(array, c);

	adt_object_t *d = adt_retrieve(array, (void *) 0);
	sut_assert(adt_equiv(d, a));
	sut_assert(d == a);
}

void
test_retrieve_from_tail()
{
	adt_add(array, a);
	adt_add(array, b);
	adt_add(array, c);

	adt_object_t *d = adt_retrieve(array, (void *) 2);
	sut_assert(adt_equiv(d, c));
	sut_assert(d == c);
}

void
test_retrieve_null_item()
{
	adt_add(array, a);
	adt_add(array, NULL);
	adt_add(array, b);
	adt_add(array, c);

	sut_assert(adt_retrieve(array, (void *) 0) == a);
	sut_assert(adt_retrieve(array, (void *) 1) == NULL);
	sut_assert(adt_retrieve(array, (void *) 2) == b);
	sut_assert(adt_retrieve(array, (void *) 3) == c);
}

void
test_retrieve_beyond_tail()
{
	adt_add(array, a);
	adt_add(array, b);

	sut_assert(adt_retrieve(array, (void *) 2) == NULL);
}

void
test_retrieve_when_empty()
{
	sut_assert(adt_retrieve(array, (void *) 4) == NULL);
}

void
test_retr_without_grown_buffer()
{
	adt_add(array, a);
	adt_add(array, b);

	sut_assert(adt_retr(array, 0) == a);
	sut_assert(adt_retr(array, 1) == b);
	sut_assert(adt_retr(array, 2) == NULL);
}

void
test_retr_after_buffer_grows()
{
	size_t i, count = 100;
	adt_object_t *objects[count];

	for (i = 0; i < count; i++) {
		adt_object_t *object = adt_create_object();
		objects[i] = object;
		adt_add(array, object);
	}

	sut_assert(adt_count(array) == count);

	for (i = 0; i < count; i++) {
		adt_object_t *a = objects[i];
		adt_object_t *b = adt_retr(array, i);

		sut_assert(adt_equiv(a, b));
		sut_assert(a == b);
	}
}

void
test_retr_with_null_item()
{
	adt_add(array, a);
	adt_add(array, NULL);
	adt_add(array, b);
	adt_add(array, c);

	sut_assert(adt_retr(array, 0) == a);
	sut_assert(adt_retr(array, 1) == NULL);
	sut_assert(adt_retr(array, 2) == b);
	sut_assert(adt_retr(array, 3) == c);
}

void
test_equiv_when_empty()
{
	adt_array_t *a0 = array;
	adt_array_t *a1 = adt_create_array(NULL);

	sut_assert(adt_equiv(a0, a1));

	adt_release(a1);
}

void
test_equiv_when_other_is_null()
{
	adt_array_t *a0 = array;
	adt_array_t *a1 = NULL;

	sut_assert(!adt_equiv(a0, a1));
}

void
test_equiv_with_different_counts()
{
	adt_array_t *a0 = array;
	adt_array_t *a1 = adt_create_array(NULL);

	adt_add(a0, a);
	sut_assert(!adt_equiv(a0, a1));

	adt_add(a1, a);
	adt_add(a0, b);
	sut_assert(!adt_equiv(a0, a1));

	adt_add(a1, b);
	adt_add(a0, c);
	sut_assert(!adt_equiv(a0, a1));

	adt_release(a1);
}

void
test_equiv_with_same_count()
{
	adt_array_t *a0 = array;
	adt_array_t *a1 = adt_create_array(NULL);

	adt_add(a0, a);
	adt_add(a1, a);
	sut_assert(adt_equiv(a0, a1));

	adt_add(a0, b);
	adt_add(a1, b);
	sut_assert(adt_equiv(a0, a1));

	adt_add(a0, c);
	adt_add(a1, c);
	sut_assert(adt_equiv(a0, a1));

	adt_release(a1);
}

void
test_equiv_with_same_array()
{
	adt_array_t *same = array;
	sut_assert(adt_equiv(array, same));
}

void
test_equiv_with_null_items()
{
	adt_array_t *a0 = array;
	adt_array_t *a1 = adt_create_array(NULL);

	adt_add(a0, a);
	adt_add(a1, a);
	adt_add(a0, NULL);
	adt_add(a1, NULL);
	adt_add(a0, b);
	adt_add(a1, b);
	adt_add(a0, c);
	adt_add(a1, c);

	sut_assert(adt_equiv(a0, a1));

	adt_release(a1);
}

void
test_insert_middle()
{
	adt_add(array, a);
	adt_add(array, c);

	sut_assert(adt_insert(array, (void *) 1, b) == 3);

	sut_assert(adt_retr(array, 0) == a);
	sut_assert(adt_retr(array, 1) == b);
	sut_assert(adt_retr(array, 2) == c);
	sut_assert(adt_count(array) == 3);
}

void
test_insert_at_head()
{
	adt_add(array, b);
	adt_add(array, c);

	sut_assert(adt_insert(array, (void *) 0, a) == 3);

	sut_assert(adt_retr(array, 0) == a);
	sut_assert(adt_retr(array, 1) == b);
	sut_assert(adt_retr(array, 2) == c);
	sut_assert(adt_count(array) == 3);
}

void
test_insert_at_tail()
{
	adt_add(array, a);
	adt_add(array, b);

	sut_assert(adt_insert(array, (void *) 2, c) == 3);

	sut_assert(adt_retr(array, 0) == a);
	sut_assert(adt_retr(array, 1) == b);
	sut_assert(adt_retr(array, 2) == c);
	sut_assert(adt_count(array) == 3);
}

void
test_insert_beyond_tail()
{
	adt_add(array, a);
	adt_add(array, b);

	sut_assert(adt_insert(array, (void *) 10, c) == 3);

	sut_assert(adt_retr(array, 0) == a);
	sut_assert(adt_retr(array, 1) == b);
	sut_assert(adt_retr(array, 2) == c);
	sut_assert(adt_count(array) == 3);
}

void
test_insert_with_null()
{
	adt_add(array, a);
	adt_add(array, b);

	sut_assert(adt_insert(array, (void *) 2, NULL) == 3);

	sut_assert(adt_retr(array, 0) == a);
	sut_assert(adt_retr(array, 1) == b);
	sut_assert(adt_retr(array, 2) == NULL);
	sut_assert(adt_count(array) == 3);
}

void
test_remove_from_middle()
{
	adt_add(array, a);
	adt_add(array, b);
	adt_add(array, c);

	sut_assert(adt_count(array) == 3);

	adt_object_t *object = adt_remove(array, (void *) 1);
	sut_assert(object == b);

	sut_assert(adt_count(array) == 2);
	sut_assert(adt_retr(array, 0) == a);
	sut_assert(adt_retr(array, 1) == c);
}

void
test_remove_from_head()
{
	adt_add(array, a);
	adt_add(array, b);
	adt_add(array, c);

	sut_assert(adt_count(array) == 3);

	adt_object_t *object = adt_remove(array, (void *) 0);
	sut_assert(object == a);

	sut_assert(adt_count(array) == 2);
	sut_assert(adt_retr(array, 0) == b);
	sut_assert(adt_retr(array, 1) == c);
}

void
test_remove_from_tail()
{
	adt_add(array, a);
	adt_add(array, b);
	adt_add(array, c);

	sut_assert(adt_count(array) == 3);

	adt_object_t *object = adt_remove(array, (void *) 2);
	sut_assert(object == c);

	sut_assert(adt_count(array) == 2);
	sut_assert(adt_retr(array, 0) == a);
	sut_assert(adt_retr(array, 1) == b);
}

void
test_remove_beyond_tail()
{
	adt_add(array, a);
	adt_add(array, b);
	adt_add(array, c);

	sut_assert(adt_count(array) == 3);

	adt_object_t *object = adt_remove(array, (void *) 3);
	sut_assert(object == NULL);

	sut_assert(adt_count(array) == 3);
}

void
test_remove_null_item()
{
	adt_add(array, a);
	adt_add(array, NULL);
	adt_add(array, c);

	sut_assert(adt_count(array) == 3);

	adt_object_t *object = adt_remove(array, (void *) 1);
	sut_assert(object == NULL);

	sut_assert(adt_count(array) == 2);
	sut_assert(adt_retr(array, 0) == a);
	sut_assert(adt_retr(array, 1) == c);
}

void
test_clear_with_items()
{
	adt_add(array, a);
	adt_add(array, b);
	adt_add(array, c);

	sut_assert(adt_retain_count(a) == 2);
	sut_assert(adt_retain_count(b) == 2);
	sut_assert(adt_retain_count(c) == 2);
	sut_assert(adt_count(array) == 3);

	adt_clear(array);

	sut_assert(adt_retain_count(a) == 1);
	sut_assert(adt_retain_count(b) == 1);
	sut_assert(adt_retain_count(c) == 1);
	sut_assert(adt_count(array) == 0);
}

void
test_clear_then_add()
{
	adt_add(array, a);
	adt_add(array, b);
	adt_add(array, c);

	adt_clear(array);

	adt_add(array, c);
	adt_add(array, b);
	adt_add(array, a);

	sut_assert(adt_retr(array, 0) == c);
	sut_assert(adt_retr(array, 1) == b);
	sut_assert(adt_retr(array, 2) == a);
	sut_assert(adt_count(array) == 3);
}

void
test_clear_when_empty()
{
	adt_clear(array);
	sut_assert(adt_count(array) == 0);
}

void
test_clear_with_null_entries()
{
	adt_add(array, a);
	adt_add(array, NULL);
	adt_add(array, NULL);
	adt_add(array, c);

	sut_assert(adt_count(array) == 4);

	adt_clear(array);

	sut_assert(adt_count(array) == 0);
	sut_assert(array != NULL);
}

void
test_print_when_empty()
{
	FILE *dest = fopen("/dev/null", "r+");

	int char_cnt = adt_print(array, dest);
	sut_assert(char_cnt == strlen("[]"));

	fclose(dest);
}

void
test_print_objects()
{
	adt_add(array, a);
	adt_add(array, a);
	adt_add(array, a);

	FILE *dest = fopen("/dev/null", "r+");

	int char_cnt = adt_print(array, dest);
	sut_assert(char_cnt > strlen("[<0x0>, <0x0>, <0x0>]"));

	fclose(dest);
}

void
test_class_with_item()
{
	sut_assert(adt_class(array) == adt_array_class);
}
