// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_collection.0.test.t
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

#include "adt_collection.h"

void
test_count_with_null_self()
{
	sut_assert(adt_count(NULL) == 0);
}

void
test_add_with_null_self()
{
	sut_assert(adt_add(NULL, NULL) == 0);
}

void
test_retrieve_with_null_self()
{
	sut_assert(adt_retrieve(NULL, (void *) 134) == NULL);
}

void
test_insert_with_null_self()
{
	sut_assert(adt_insert(NULL, (void *) 1, (void *) 1) == 0);
}

void
test_remove_with_null_self()
{
	sut_assert(adt_remove(NULL, (void *) 1) == NULL);
}

void
test_create_iterator_with_null_list()
{
	sut_assert(adt_create_iterator(NULL) == NULL);
}
