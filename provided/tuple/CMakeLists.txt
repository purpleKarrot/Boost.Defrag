# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Tuple
  AUTHORS
    "Jaakko Jarvi <jarvi -at- cs.tamu.edu>"
  DESCRIPTION
    "Ease definition of functions returning multiple values, and more."
  DEPENDS
    static_assert
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})
