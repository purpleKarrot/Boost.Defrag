# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Inspect
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})

boost_add_executable(inspect
  SOURCES
    inspect.cpp
    license_check.cpp
    link_check.cpp
    path_name_check.cpp
    tab_check.cpp
    crlf_check.cpp
    end_check.cpp
    unnamed_namespace_check.cpp
    ascii_check.cpp
    copyright_check.cpp
    minmax_check.cpp
    apple_macro_check.cpp
  LINK_BOOST_LIBRARIES
    filesystem
    regex
  )
