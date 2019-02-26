#! /usr/bin/env sh -e
# ------------------------------------------------------------------------------
# testgen.sh
# Copyright (C) 2013 Damian Carrillo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.	If not, see <http://www.gnu.org/licenses/>.
# ------------------------------------------------------------------------------
#
# Usage
#
# ./testgen.sh component_test.c component_test_runner.c
#
# Description
#
# In order to minimize the amount of work involved when writing unit tests, this
# script generates test runners for every file supplied as an argument in such
# a way that you, as a developer, only need to define the test cases and any
# hook functions.
#
# This generator lends itself to the xUnit approach to testing, but diverges in
# nature for setup and teardown functions. This script detects hook functions
# with the following names:
#
#	void before_suite() { ... } // Run before a test suite starts
#	void before_test() { ... }	// Run before every test case in the suite
#	void after_test() { ... }	// Run after every test case in the suite
#	void after_suite() { ... }	// Run after the test suite ends
#
# and test functions with names like the following (where the important part is
# the "test" prefix):
#
#	void test_something() { ... }	// Run a test
#	void test_something_else { ... } // Run another test
#
# A test suite is an aggregation of test cases. This script will generate a
# test suite per supplied C module (where a module is passed to this script as
# an argument).
# ------------------------------------------------------------------------------

function printHeader {
declare module=${1}
declare testSuiteName=${2}

cat <<EOF
#include <stdlib.h>
#include <getopt.h>
#include "sut_test.h"
#include "${module}"

int
main(int argc, char *argv[])
{
	sut_suite_t *suite;
	int ch;
	char *filter = NULL;

	suite = sut_suite_new("${testSuiteName}");


	// Interpreting arguments

	struct option longopts[] = {
		{ "nofork", no_argument,       NULL, 'n' },
		{ "filter", required_argument, NULL, 'f' },
		{ NULL,     0,                 NULL,  0  }
	};

	while ((ch = getopt_long(argc, (char *const *) argv, "nf:", longopts, NULL)) != -1) {
		switch (ch) {
			case 'n':
				sut_suite_set_fork(suite, false);
				break;
			case 'f':
				filter = optarg;
				break;
			default:
				break;
		}
	}

	argc -= optind;
	argv += optind;

	// Preparing and running tests

EOF
}

function printBeforeTestSuite {
cat <<EOF
	sut_suite_set_before_suite(suite, &before_suite);
EOF
}

function printBeforeTestCase {
cat <<EOF
	sut_suite_set_before_test(suite, &before_test);
EOF
}

function printAfterTestCase {
cat <<EOF
	sut_suite_set_after_test(suite, &after_test);
EOF
}

function printAfterTestSuite {
cat <<EOF
	sut_suite_set_after_suite(suite, &after_suite);
EOF
}

function printTestCase {
declare testCase=${1}

cat <<EOF
	sut_suite_add_test(suite, sut_test_new("${testCase}", &${testCase}));
EOF
}

function printFooter {
cat <<EOF
	sut_suite_run(suite, filter);
	sut_suite_free(suite);

	return 0;
}
EOF
}

declare module=$1
declare outputFile=$2

if [[ -z ${outputFile} ]]; then
	outputFile="${module%%.*}_runner.c"
fi

declare testSuiteName="${module%%.*}"
declare beforeTestSuiteWasFound=
declare beforeTestCaseWasFound=
declare afterTestCaseWasFound=
declare afterTestSuiteWasFound=
declare testCases=

declare functionNames=$(awk '
	/before_suite\((void)?\)/ {
		print "before_suite"
	}

	/before_test\((void)?\)/ {
		print "before_test"
	}

	/after_test\((void)?\)/ {
		print "after_test"
	}

	/after_suite\((void)?\)/ {
		print "after_suite"
	}

	/test.*\((void)?\)/ && !/before_test\((void)?\)/ && !/after_test\((void)?\)/ {
		start = index($0, "test")
		end = index($0, "(") - start
		print substr($0, start, end)
	}
' < ${module})

for functionName in ${functionNames}; do
	if [[ ${functionName} = "before_suite" ]]; then
		beforeTestSuiteWasFound="YES"
	elif [[ ${functionName} = "before_test" ]]; then
		beforeTestCaseWasFound="YES"
	elif [[ ${functionName} = "after_test" ]]; then
		afterTestCaseWasFound="YES"
	elif [[ ${functionName} = "after_suite" ]]; then
		afterTestSuiteWasFound="YES"
	else
		testCases="${testCases} ${functionName}"
	fi
done

printHeader "${module}" "${testSuiteName}" > "${outputFile}"

if [[ ! -z ${beforeTestSuiteWasFound} ]]; then
	printBeforeTestSuite >> "${outputFile}"
fi

if [[ ! -z ${beforeTestCaseWasFound} ]]; then
	printBeforeTestCase >> "${outputFile}"
fi

if [[ ! -z ${afterTestCaseWasFound} ]]; then
	printAfterTestCase >> "${outputFile}"
fi

if [[ ! -z ${afterTestSuiteWasFound} ]]; then
	printAfterTestSuite >> "${outputFile}"
fi

if [[ ! -z ${testCases} ]]; then
	for testCase in ${testCases}; do
		printTestCase "${testCase}" >> "${outputFile}"
	done
fi

printFooter >> "${outputFile}"
