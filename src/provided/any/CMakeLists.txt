# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

include(BoostProject)
include(BoostDocs)
include(BoostTesting)

boost_project(Any
  AUTHORS
    "Kevlin Henney"
  MAINTAINERS
    "Alexander Nasonov <alexander.nasonov -at- gmail.com>"
  DESCRIPTION
    "Safe, generic container for single values of different value types."
  DEPENDS
    utility
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})

boost_documentation(doc/any.xml)

boost_add_test(any_test)
boost_add_test(any_cast_cv_failed COMPILE FAIL test/any_cast_cv_failed.cpp)

#boost_test_suite(
#  RUN
#    any_test.cpp
#  COMPILE_FAIL
#    test/any_cast_cv_failed.cpp
#  )
