# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(any
  AUTHORS
    "Kevlin Henney"
  MAINTAINERS
    "Alexander Nasonov <alexander.nasonov -at- gmail.com>"
  DESCRIPTION
    "Safe, generic container for single values of different value types."
  DEPENDS
    utility
  )

boost_documentation(doc/any.xml)

boost_add_test(any_test)
boost_add_test(any_cast_cv_failed COMPILE FAIL test/any_cast_cv_failed.cpp)

#boost_test_suite(
#  RUN
#    any_test.cpp
#  COMPILE_FAIL
#    test/any_cast_cv_failed.cpp
#  )
