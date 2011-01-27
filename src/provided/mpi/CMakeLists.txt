# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(MPI
  DEPENDS
    graph
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})

if(MSVC)
  add_definitions(
    /wd4251 # class needs to have dll-interface to be used by clients
    /wd4275 # non dll-interface class used as base for dll-interface class
    )
endif(MSVC)

add_subdirectory(src)
