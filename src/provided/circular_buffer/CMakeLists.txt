# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Circular_buffer
  AUTHORS
    "Jan Gaspar <jano_gaspar -at- yahoo.com>"
  DESCRIPTION
    "STL compliant container also known as ring or cyclic buffer."
  DEPENDS
    config
    thread
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})
