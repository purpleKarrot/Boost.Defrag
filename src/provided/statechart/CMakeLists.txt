# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Statechart
  AUTHORS
    "Andreas Huber <ahd6974-boostorg -at- yahoo.com>"
  DESCRIPTION
    "Arbitrarily complex finite state machines can be implemented in easily readable and maintainable C++ code."
  DEPENDS
    type_traits
    mpl
    static_assert
    intrusive
    smart_ptr
    bind
    function
    numeric
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})
