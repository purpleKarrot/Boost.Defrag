# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(system
  DEPENDS
    utility
  )

include(BoostProject)

boost_add_library(system
  SOURCES
    src/error_code.cpp
    src/local_free_on_destruction.hpp
#  SHARED_DEFINITION "BOOST_SYSTEM_DYN_LINK=1"
  )
