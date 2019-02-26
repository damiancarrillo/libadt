// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_map.0.test.t
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

#include "sut_test.h"
#include "adt_map.h"

void
test_creation()
{
	adt_map_t *map = adt_create_map(NULL);
	sut_assert(map != NULL);
}

void
test_retain()
{
	adt_map_t *map = adt_create_map(NULL);
	unsigned int retain_count;

	retain_count = adt_retain(map);
	sut_assert(retain_count == 2);

	retain_count = adt_retain(map);
	sut_assert(retain_count == 3);
}

void
test_release()
{
	adt_map_t *map = adt_create_map(NULL);
	unsigned int retain_count;

	retain_count = adt_release(map);
	sut_assert(retain_count == 0);
}
