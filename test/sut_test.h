// -*- Mode: C; c-file-style: "k&r" -*-
//
// sut_test.h
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

#include <setjmp.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#ifndef SUT_TEST_H
#define SUT_TEST_H

// Types ///////////////////////////////////////////////////////////////////////

typedef struct sut_test_t        sut_test_t;
typedef struct sut_suite_t       sut_suite_t;
typedef struct sut_failure_t     sut_failure_t;
typedef struct sut_error_t       sut_error_t;
typedef struct sut_test_elem_t   sut_test_elem_t;
typedef struct sut_fork_result_t sut_fork_result_t;

typedef struct sut_formatter_t {
	FILE *out;
	void (*before_suite)(FILE *out, sut_suite_t *suite);
	void (*before_test) (FILE *out, sut_suite_t *suite, sut_test_t *test);
	void (*after_test)  (FILE *out, sut_suite_t *suite, sut_test_t *test);
	void (*after_suite) (FILE *out, sut_suite_t *suite);
} sut_formatter_t;

struct sut_failure_t {
	char *expression;
	char *file;
	int line;
};

struct sut_error_t {
	char *reason;
	char *file;
	int line;
};

struct sut_test_t {
	char *name;
	void (* function)(void);
	sut_failure_t *failure;
	sut_error_t *error;
	struct timeval *start;
	struct timeval *end;
};

struct sut_test_elem_t {
	sut_test_t *test;
	sut_test_elem_t *next;
};

struct sut_fork_result_t {
    sut_failure_t failure;
    struct timeval start;
    struct timeval end;
};

struct sut_suite_t {
	char *name;
	bool fork;
	char *filter;
	unsigned int count;
	sut_formatter_t *formatter;
	sut_test_elem_t *head;
	struct timeval start;
	struct timeval end;
	void (*before_suite)(void);
	void (*before_test)(void);
	void (*after_test)(void);
	void (*after_suite)(void);
};

// Variables ///////////////////////////////////////////////////////////////////

extern sut_failure_t *_failure;
extern jmp_buf        _test_env;

// Methods /////////////////////////////////////////////////////////////////////

#undef sut_assert
#define sut_assert(expr)                     \
	if (!(expr)) {                           \
		_failure = malloc(sizeof *_failure); \
		_failure->expression = #expr;        \
		_failure->file = __FILE__;           \
		_failure->line = __LINE__;           \
		longjmp(_test_env, 1);               \
	}

extern sut_formatter_t *sut_formatter_tap(FILE *out);

extern sut_test_t      *sut_test_new(char *name, void (*test)(void));
extern void             sut_test_free(sut_test_t *test);

extern sut_suite_t     *sut_suite_new(char *name);
extern sut_suite_t     *sut_suite_new_formatted(char *name, sut_formatter_t *formatter);
extern unsigned int     sut_suite_add_test(sut_suite_t *suite, sut_test_t *test);
extern void             sut_suite_set_fork(sut_suite_t *suite, bool fork);
extern void             sut_suite_set_before_suite(sut_suite_t *suite, void (*before_suite)(void));
extern void             sut_suite_set_before_test(sut_suite_t *suite, void (*before_test)(void));
extern void             sut_suite_set_after_test(sut_suite_t *suite, void (*after_test)(void));
extern void             sut_suite_set_after_suite(sut_suite_t *suite, void (*after_suite)(void));
extern unsigned int     sut_suite_run(sut_suite_t *suite, char *filter);
extern void             sut_suite_free(sut_suite_t *suite);

#endif /* SUT_TEST_H */
