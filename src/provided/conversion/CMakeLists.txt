# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Conversion
  AUTHORS
    "David Abrahams <dave -at- boost-consulting.com>"
     "Kevlin Henney"
  DESCRIPTION
    "Polymorphic and lexical casts"
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})
