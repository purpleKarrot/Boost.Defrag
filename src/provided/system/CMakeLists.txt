# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

include(BoostProject)

boost_project(System
  DEPENDS
    utility
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})

boost_add_library(system
  SOURCES
    src/error_code.cpp
    src/local_free_on_destruction.hpp
#  SHARED_DEFINITION "BOOST_SYSTEM_DYN_LINK=1"
  )
