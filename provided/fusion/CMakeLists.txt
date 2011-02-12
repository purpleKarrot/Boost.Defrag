# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Fusion
  AUTHORS
    "Joel de Guzman <joel -at- boost-consulting.com>"
    "Dan Marsden <danmarsden -at- yahoo.co.uk>"
    "Tobias Schwinger <tschwinger -at- isonews2.com>"
  DESCRIPTION
    "Library for working with tuples, including various containers, algorithms, etc."
  DEPENDS
    function_types
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})
