# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(GIL
  AUTHORS
    "Lubomir Bourdev <lbourdev -at- adobe.com>"
    "Hailin Jin <hljin -at- adobe.com>"
  DESCRIPTION
    "Generic Image Library"
  DEPENDS
    type_traits
    mpl
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})
