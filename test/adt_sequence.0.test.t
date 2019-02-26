// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_sequence.0.test.t
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

#include "adt_sequence.h"

void
test_ins_with_null_self()
{
	sut_assert(adt_ins(NULL, 1, (void *) 1) == 0);
}

void
test_retr_with_null_self()
{
	sut_assert(adt_retr(NULL, 1) == 0);
}

void
test_rem_with_null_self()
{
	sut_assert(adt_rem(NULL, 1) == NULL);
}

