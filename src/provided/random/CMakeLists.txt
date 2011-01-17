# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(random
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

boost_add_library(random
  SOURCES
    src/random_device.cpp
  # <link>shared:<define>BOOST_RANDOM_DYN_LINK
  )
