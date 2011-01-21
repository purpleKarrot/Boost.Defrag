# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Parameter
  AUTHORS
    "David Abrahams <dave -at- boostpro.com>"
    "Daniel Wallin <dalwan01 -at- student.umu.se>"
  DESCRIPTION
    "Write functions that accept arguments by name."
  DEPENDS
    python
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})
