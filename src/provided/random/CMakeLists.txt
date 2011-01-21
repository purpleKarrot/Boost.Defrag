# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Random
  AUTHORS
    "Jens Maurer <Jens.Maurer -at- gmx.net>"
  DESCRIPTION
    "A complete system for random number generation."
  DEPENDS
    detail
    integer
    type_traits
    static_assert
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})

boost_add_library(random
  SOURCES
    src/random_device.cpp
  # <link>shared:<define>BOOST_RANDOM_DYN_LINK
  )
