// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_pair.c
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

#include <stdarg.h>
#include <stdbool.h>
#include <stdlib.h>
#include "adt_pair.h"
#include "adt_pair_type.h"

struct adt_pair *
adt_create_pair(
	const struct adt_ownership_semantics *semantics,
	void *left,
	void *right)
{
	struct adt_pair *pair = malloc(sizeof *pair);
	((struct adt_object *) pair)->class = (struct adt_object_ifc *) adt_pair_class;
	((struct adt_object *) pair)->class->init(pair, semantics, left, right);
	return pair;
}

void
adt_pair_init(void *_self, ...)
{
	adt_object_init(_self);

	va_list ap;
	va_start(ap, _self);

	struct adt_pair *self = _self;

	self->semantics = va_arg(ap, struct adt_ownership_semantics *);

	if (!self->semantics) {
		self->semantics = adt_retain_semantics;
	}

	struct adt_object *left = va_arg(ap, struct adt_object *);
	struct adt_object *right = va_arg(ap, struct adt_object *);

	self->left = self->semantics->establish_ownership(left);
	self->right = self->semantics->establish_ownership(right);

	va_end(ap);
}

void
adt_pair_destroy(void *_self)
{
	struct adt_pair *self = _self;

	if (self->left) {
		self->semantics->relenquish_ownership(self->left);
	}

	if (self->right) {
		self->semantics->relenquish_ownership(self->right);
	}

	adt_object_destroy(self);
}

void *
adt_pair_copy(const void *_self)
{
	const struct adt_pair *self = _self;
	const struct adt_object *left = adt_copy(adt_left(self));
	const struct adt_object *right = adt_copy(adt_right(self));
	struct adt_pair *copy = adt_create_pair(self->semantics, (void *) left, (void *) right);
	return copy;
}

void *
adt_left(const void *_self)
{
	void *item = NULL;

	if (_self) {
		const struct adt_object *self = _self;
		item = ((struct adt_pair_ifc *) self->class)->left(self);
	}

	return item;
}

void *
adt_right(const void *_self)
{
	void *item = NULL;

	if (_self) {
		const struct adt_object *self = _self;
		item = ((struct adt_pair_ifc *) self->class)->right(self);
	}

	return item;
}

void *
adt_pair_left(const void *_self)
{
	const struct adt_pair *self = _self;
	return self->left;
}

void *
adt_pair_right(const void *_self)
{
	const struct adt_pair *self = _self;
	return self->right;
}

bool
adt_pair_equiv(const void *_self, const void *_other)
{
	bool equiv = false;

	if (_other) {
		const struct adt_pair *self = _self;
		const struct adt_pair *other = _other;

		equiv = adt_equiv(adt_left(self), adt_left(other)) &&
		        adt_equiv(adt_right(self), adt_right(other));
	}

	return equiv;
}

unsigned int
adt_pair_hash(const void *self)
{
	unsigned int hash = 0;

	if (self) {
		hash += adt_hash(adt_left(self));
		hash += adt_hash(adt_right(self));
	}

	return hash;
}

int
adt_pair_print(const void *_self, FILE *dest)
{
	int cs = 0;

	const struct adt_pair *self = _self;
	const struct adt_object *left = adt_left(self);
	const struct adt_object *right = adt_right(self);

	cs += fprintf(dest, "(");
	cs += adt_print(left, dest);
	cs += fprintf(dest, ", ");
	cs += adt_print(right, dest);
	cs += fprintf(dest, ")");

	return cs;
}

// adt_pair -> adt_object
static const struct adt_pair_ifc _adt_pair_class =
{
	{
		"adt_pair_class",
		sizeof(struct adt_pair),

		&adt_pair_init,
		&adt_object_retain,
		&adt_pair_copy,
		&adt_object_release,
		&adt_pair_destroy,
		&adt_pair_equiv,
		&adt_pair_hash,
		&adt_pair_print
	},

	&adt_pair_left,
	&adt_pair_right
};

const struct adt_pair_ifc *adt_pair_class = &_adt_pair_class;
