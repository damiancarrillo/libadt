// -*- Mode: C; c-file-style: "k&r" -*-
//
// adt_map.c
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

#include <limits.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include "adt_array.h"
#include "adt_list.h"
#include "adt_map_type.h"
#include "adt_pair.h"

static const size_t primes[] = {
	53,
	101,
	1009,
	10007,
	50021,
	100003,
	499979,
	999983
};

void *
adt_create_map(const struct adt_ownership_semantics *semantics)
{
	struct adt_map *map = malloc(sizeof *map);
	((struct adt_object *) map)->class = (struct adt_object_ifc *) adt_map_class;
	((struct adt_object *) map)->class->init(map, semantics);
	return map;
}

void
adt_map_init(void *_self, ...)
{
	va_list ap;
	va_start(ap, _self);

	adt_object_init(_self);

	struct adt_map *self = _self;
	self->semantics = va_arg(ap, struct adt_ownership_semantics *);

	if (!self->semantics) {
		self->semantics = adt_retain_semantics;
	}

	self->count = 0;
	self->bucket_count = primes[0];
	self->buckets = adt_create_array_with_capacity((void *) self->semantics, self->bucket_count);

	size_t i;
	for (i = 0; i < self->bucket_count; i++) {
		adt_ins(self->buckets, i, NULL);
	}

	va_end(ap);
}

void
adt_map_destroy(void *_self)
{
	struct adt_map *self = _self;
	adt_release(self->buckets);
	adt_object_destroy(_self);
}

size_t
adt_map_count(const void *_self)
{
	const struct adt_map *self = _self;
	return self->count;
}

size_t
adt_map_add(void *_self, void *_pair)
{
	size_t count = 0;

	if (_pair) {
		struct adt_pair *pair = _pair;
		struct adt_object *key = adt_left(pair);

		if (key) {
			struct adt_map *self = _self;
			unsigned int index = adt_hash(key) % self->bucket_count;
			struct adt_sequence *chain = adt_retr(self->buckets, index);

			if (!chain) {
				chain = adt_create_list(self->semantics);
				adt_ins(self->buckets, index, chain);
				adt_release(chain);
			}

			bool found = false;

			// TODO: See about creating the iterator on the stack

			struct adt_iterator *itr = adt_create_iterator(chain);

			while (adt_has_next(itr)) {
				struct adt_pair *contained_pair = adt_next(itr);

				if (adt_equiv(adt_left(contained_pair), adt_left(pair))) {
					found = true;
					break;
				}
			}

			adt_release(itr);

			if (!found) {
				adt_add(chain, pair);

				++self->count;
				count = self->count;
			}
		}
	}

	return count;
}

size_t
adt_map_insert(void *_self, void *key, void *value)
{
	size_t count = 0;

	if (key) {
		struct adt_map *self = _self;
		struct adt_pair *pair = adt_create_pair(self->semantics, key, value);
		count = adt_add(self, pair);
	}

	return count;
}

void *
adt_map_retrieve(const void *_self, const void *_key)
{
	void *value = NULL;

	if (_key) {
		const struct adt_map *self = _self;
		const struct adt_object *key = _key;
		unsigned int index = adt_hash(key) % self->bucket_count;
		const struct adt_sequence *chain = adt_retr(self->buckets, index);

		if (chain) {
			size_t i, count = adt_count(chain);
			for (i = 0; i < count; i++) {
				struct adt_object *pair = adt_retr(chain, i);
				if (adt_equiv(adt_left(pair), key)) {
					value = adt_right(pair);
					break;
				}
			}
		}
	}

	return value;
}

void *
adt_map_remove(void *_self, void *_key)
{
	void *value = NULL;

	if (_key) {
		struct adt_map *self = _self;
		struct adt_object *key = _key;
		unsigned int index = adt_hash(key) % self->bucket_count;
		struct adt_sequence *chain = adt_retr(self->buckets, index);

		if (chain) {
			size_t i, count = adt_count(chain);
			for (i = 0; i < count; i++) {
				struct adt_object *pair = adt_retr(chain, i);
				if (adt_equiv(adt_left(pair), key)) {
					break;
				}
			}

			if (i < count) {
				struct adt_pair *pair = adt_rem(chain, i);
				value = adt_right(pair);

				--self->count;
			}
		}
	}

	return value;
}

void
adt_map_clear(void *_self)
{
	struct adt_map *self = _self;

	size_t i, count = adt_count(self->buckets);
	for (i = 0; i < count; i++) {
		struct adt_sequence *bucket = adt_retr(self->buckets, i);
		if (bucket) {
			adt_clear(bucket);
			adt_release(bucket);
			adt_ins(self->buckets, i, NULL);
		}
	}

	self->count = 0;
}

bool
adt_map_equiv(const void *_self, const void *_other)
{
	if (!_self && !_other) {
		return true;
	}

	if ((!_self && _other) || (_self && !_other)) {
		return false;
	}

	if (_self && _other) {
		const struct adt_map *self = _self;
		const struct adt_map *other = _other;

		size_t i, count = adt_count(self->buckets);
		size_t other_count = adt_count(other->buckets);

		if (count != other_count) {
			return false;
		}

		for (i = 0; i < count; i++) {
			struct adt_sequence *ca = adt_retr(self->buckets, i);
			struct adt_sequence *cb = adt_retr(other->buckets, i);

			if (!adt_equiv(ca, cb)) {
				return false;
			}
		}
	}

	return true;
}

unsigned int
adt_map_hash(const void *_self)
{
	unsigned int hash = 0;

	const struct adt_map *self = _self;
	size_t i, count = adt_count(self->buckets);
	for (i = 0; i < count; i++) {
		const struct adt_sequence *chain = adt_retr(self->buckets, i);
		hash = (hash + adt_hash(chain)) % UINT_MAX;
	}

	return hash;
}

int
adt_map_print(const void *_self, FILE *dest)
{
	const struct adt_map *self = _self;

	int cs = fprintf(dest, "{");
	size_t n = 0, count = adt_count(self);

	size_t i, icount = adt_count(self->buckets);
	for (i = 0; i < icount; i++) {
		const struct adt_sequence *chain = adt_retr(self->buckets, i);

		size_t j, jcount = adt_count(chain);
		for (j = 0; j < jcount; j++, n++) {
			const struct adt_pair *pair = adt_retr(chain, j);
			adt_print(pair, dest);

			if (n < count - 1) {
				fprintf(dest, ", ");
			}
		}
	}

	cs += fprintf(dest, "}");

	return cs;
}

// adt_map -> adt_collection ->adt_object
static const struct adt_map_ifc _adt_map_class =
{
	{
		{
			"adt_map_class",
			sizeof(struct adt_map),

			&adt_map_init,
			&adt_object_retain,
			&adt_object_copy,
			&adt_object_release,
			&adt_map_destroy,
			&adt_map_equiv,
			&adt_map_hash,
			&adt_map_print
		},

		&adt_map_count,
		&adt_map_add,
		&adt_map_insert,
		&adt_map_retrieve,
		&adt_map_remove,
		&adt_map_clear,
		NULL
	}
};

const struct adt_map_ifc *adt_map_class = &_adt_map_class;
