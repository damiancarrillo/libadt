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
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#include "adt_list.h"

void
test_create_list()
{
	adt_list_t *list = adt_create_list(NULL);
	sut_assert(list != NULL);
}

void
test_retain_list()
{
	adt_list_t *list = adt_create_list(NULL);
	unsigned int retain_count;

	retain_count = adt_retain(list);
	sut_assert(retain_count == 2);

	retain_count = adt_retain(list);
	sut_assert(retain_count == 3);
}

void
test_release_list()
{
	adt_list_t *list = adt_create_list(NULL);
	unsigned int retain_count;

	retain_count = adt_release(list);
	sut_assert(retain_count == 0);
}
