# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Filesystem
  AUTHORS
    "Beman Dawes <bdawes -at- acm.org>"
  DESCRIPTION
    "Provides portable facilities to query and manipulate paths, files, and directories."
  DEPENDS
    system
    smart_ptr
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})

macro(forward_file from to)
  if(NOT EXISTS ${to})
    get_filename_component(to_path ${to} PATH)
    file(RELATIVE_PATH include "${to_path}" ${from})
    file(WRITE ${to} "#include \"${include}\"\n")
  endif()
endmacro(forward_file)

forward_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/../detail/utf8_codecvt_facet.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/include/libs/detail/utf8_codecvt_facet.cpp
  )
include_directories(${CMAKE_CURRENT_BINARY_DIR}/include)


boost_add_library(filesystem
  SOURCES
    v2/src/v2_operations
    v2/src/v2_path
    v2/src/v2_portability
    v3/src/operations
    v3/src/path
    v3/src/portability
    v3/src/utf8_codecvt_facet
    v3/src/codecvt_error_category
    v3/src/path_traits
    v3/src/unique_path
    v3/src/windows_file_codecvt
  LINK_BOOST_LIBRARIES
    system
#  SHARED_DEFINITION "BOOST_FILESYSTEM_DYN_LINK=1"
  )
