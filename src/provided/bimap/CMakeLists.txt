# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Bimap
  AUTHORS
    "Matias Capeletto <matias.capeletto -at- gmail.com>"
  DESCRIPTION
    "Bidirectional map containers"
  DEPENDS
    xpressive
    property_map
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})
