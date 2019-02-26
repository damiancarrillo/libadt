// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_list.1.test.t
// Copyright (C) 2013 Damian Carrillo
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.	 If not, see <http://www.gnu.org/licenses/>.
//

#include "adt_list.h"

static adt_list_t   *list;
static adt_object_t *a;
static adt_object_t *b;
static adt_object_t *c;

void
before_test()
{
	list = adt_create_list(NULL);
	a = adt_create_object();
	b = adt_create_object();
	c = adt_create_object();
}

void
after_test()
{
	sut_assert(adt_release(list) == 0);
	sut_assert(adt_release(a) == 0);
	sut_assert(adt_release(b) == 0);
	sut_assert(adt_release(c) == 0);
}

void
test_count_when_empty()
{
	unsigned int count = adt_count(list);
	sut_assert(count == 0);
}

void
test_empty_when_empty()
{
	sut_assert(adt_empty(list));
}

void
test_empty_when_not_empty()
{
	adt_add(list, a);
	sut_assert(!adt_empty(list));
}

void
test_add_with_a_couple_of_items()
{
	sut_assert(adt_add(list, a) == 1);
	sut_assert(adt_count(list) == 1);

	sut_assert(adt_add(list, b) == 2);
	sut_assert(adt_count(list) == 2);
}

void
test_retrieve_with_a_couple_of_items()
{
	adt_add(list, a);
	adt_add(list, b);

	adt_object_t *c = adt_retrieve(list, (void *) 0);
	sut_assert(c == a);

	adt_object_t *d = adt_retrieve(list, (void *) 1);
	sut_assert(d == b);
}

void
test_retrieve_with_index_out_of_bounds()
{
	adt_object_t *a = adt_create_object();
	adt_object_t *b = adt_create_object();

	sut_assert(adt_add(list, a) == 1);
	sut_assert(adt_add(list, b) == 2);

	sut_assert(adt_count(list) == 2);
	sut_assert(adt_retrieve(list, (void *) 2) == NULL);
}

void
test_insert_with_a_few_items()
{
	sut_assert(adt_add(list, a) == 1);
	sut_assert(adt_add(list, c) == 2);
	sut_assert(adt_insert(list, (void *) 1, b) == 3);

	sut_assert(adt_retrieve(list, (void *) 0) == a);
	sut_assert(adt_retrieve(list, (void *) 1) == b);
	sut_assert(adt_retrieve(list, (void *) 2) == c);
}

void
test_ins_with_a_few_items()
{
	sut_assert(adt_add(list, a) == 1);
	sut_assert(adt_add(list, c) == 2);
	sut_assert(adt_ins(list, 1, b) == 3);

	sut_assert(adt_retrieve(list, (void *) 0) == a);
	sut_assert(adt_retrieve(list, (void *) 1) == b);
	sut_assert(adt_retrieve(list, (void *) 2) == c);
}

void
test_ins_beyond_tail()
{
	sut_assert(adt_ins(list, 0, a) == 1);
	sut_assert(adt_ins(list, 1, b) == 2);
	sut_assert(adt_ins(list, 2, c) == 3);
}

void
test_retr_with_a_few_items()
{
	sut_assert(adt_add(list, a) == 1);
	sut_assert(adt_add(list, c) == 2);
	sut_assert(adt_ins(list, 1, b) == 3);

	sut_assert(adt_retr(list, 0) == a);
	sut_assert(adt_retr(list, 1) == b);
	sut_assert(adt_retr(list, 2) == c);
}

void
test_remove_with_a_few_items()
{
	sut_assert(adt_add(list, a) == 1);
	sut_assert(adt_add(list, b) == 2);
	sut_assert(adt_add(list, c) == 3);

	sut_assert(adt_remove(list, (void *) 1) == b);
	sut_assert(adt_count(list) == 2);
	sut_assert(adt_retr(list, 0) == a);
	sut_assert(adt_retr(list, 1) == c);
}

void
test_remove_last_element()
{
	sut_assert(adt_add(list, a) == 1);
	sut_assert(adt_add(list, b) == 2);
	sut_assert(adt_add(list, c) == 3);
	sut_assert(adt_remove(list, 0) == a);
	sut_assert(adt_remove(list, 0) == b);
	sut_assert(adt_remove(list, 0) == c);
}

void
test_rem_with_a_few_items()
{
	sut_assert(adt_add(list, a) == 1);
	sut_assert(adt_add(list, b) == 2);
	sut_assert(adt_add(list, c) == 3);

	sut_assert(adt_rem(list, 1) == b);
	sut_assert(adt_count(list) == 2);
	sut_assert(adt_retr(list, 0) == a);
	sut_assert(adt_retr(list, 1) == c);
}

void
test_rem_head()
{
	sut_assert(adt_add(list, a) == 1);
	sut_assert(adt_add(list, b) == 2);
	sut_assert(adt_add(list, c) == 3);

	sut_assert(adt_rem(list, 0) == a);
	sut_assert(adt_count(list) == 2);
	sut_assert(adt_retr(list, 0) == b);
	sut_assert(adt_retr(list, 1) == c);
}

void
test_rem_tail()
{
	sut_assert(adt_add(list, a) == 1);
	sut_assert(adt_add(list, b) == 2);
	sut_assert(adt_add(list, c) == 3);

	sut_assert(adt_rem(list, 2) == c);
	sut_assert(adt_count(list) == 2);
	sut_assert(adt_retr(list, 0) == a);
	sut_assert(adt_retr(list, 1) == b);
}

void
test_clear_with_a_few_items()
{
	sut_assert(adt_add(list, a) == 1);
	sut_assert(adt_add(list, b) == 2);
	sut_assert(adt_add(list, c) == 3);

	adt_clear(list);
	sut_assert(adt_count(list) == 0);

	sut_assert(adt_add(list, b) == 1);
	sut_assert(adt_add(list, a) == 2);

	sut_assert(adt_retr(list, 0) == b);
	sut_assert(adt_retr(list, 1) == a);
}

void
test_clear_with_empty_list()
{
	adt_clear(list);
	sut_assert(adt_count(list) == 0);
}

void
test_class_with_list()
{
	sut_assert(adt_class(list) == adt_list_class);
}

void
test_list_iterator_has_next_when_empty()
{
	adt_iterator_t *itr = adt_create_iterator(list);
	sut_assert(!adt_has_next(itr));

	adt_release(itr);
}

void
test_list_iterator_has_next_when_not_empty()
{
	adt_add(list, a);
	adt_add(list, b);
	adt_add(list, c);

	adt_iterator_t *itr = adt_create_iterator(list);
	sut_assert(adt_has_next(itr));

	adt_release(itr);
}

void
test_list_iterator_next_when_empty()
{
	adt_iterator_t *itr = adt_create_iterator(list);
	sut_assert(adt_next(itr) == NULL);

	adt_release(itr);
}

void
test_list_iterator_next_when_not_empty()
{
	adt_add(list, a);
	adt_add(list, b);
	adt_add(list, c);

	sut_assert(adt_count(list) == 3);

	adt_iterator_t *itr = adt_create_iterator(list);

	sut_assert(adt_next(itr) == a);
	sut_assert(adt_next(itr) == b);
	sut_assert(adt_next(itr) == c);

	adt_release(itr);
}

void
test_list_iterator_next_beyond_tail()
{
	adt_add(list, a);
	adt_add(list, b);
	adt_add(list, c);

	sut_assert(adt_count(list) == 3);

	adt_iterator_t *itr = adt_create_iterator(list);

	sut_assert(adt_next(itr) == a);
	sut_assert(adt_next(itr) == b);
	sut_assert(adt_next(itr) == c);

	sut_assert(adt_next(itr) == NULL);
	sut_assert(adt_next(itr) == NULL);

	adt_release(itr);
}

void
test_list_iterator_has_next_at_tail()
{
	adt_add(list, a);
	adt_add(list, b);
	adt_add(list, c);

	sut_assert(adt_count(list) == 3);

	adt_iterator_t *itr = adt_create_iterator(list);

	adt_next(itr);
	adt_next(itr);
	adt_next(itr);

	sut_assert(!adt_has_next(itr));

	adt_release(itr);
}
