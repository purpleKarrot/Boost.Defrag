# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project("Smart Ptr"
  AUTHORS
    "Darin Adler"
    "Greg Colvin"
    "Beman Dawes <bdawes -at- acm.org>"
    "Peter Dimov <pdimov -at- mmltd.net>"
  DESCRIPTION
    "Five smart pointer class templates."
  DEPENDS
    utility
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})
