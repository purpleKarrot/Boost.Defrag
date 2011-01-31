# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

include(BoostProject)

boost_project(Accumulators
  AUTHORS
    "Eric Niebler <eric -at- boost-consulting.com>"
  DESCRIPTION
    "A framework for incremental calculation, and a collection of statistical accumulators."
  DEPENDS
    parameter
    typeof
    foreach
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})

add_subdirectory(doc)
add_subdirectory(test)
