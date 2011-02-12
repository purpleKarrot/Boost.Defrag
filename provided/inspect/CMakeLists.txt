# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Inspect
  )

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
