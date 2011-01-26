# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Iostreams
  AUTHORS
    "Jonathan Turkanis <turkanis -at- coderage.com>"
  DESCRIPTION
    "Framework for defining streams, stream buffers and i/o filters"
  DEPENDS
    range
    random
  )

add_definitions(-DBOOST_IOSTREAMS_USE_DEPRECATED)

if(MSVC)
  add_definitions(/wd4005) # 'BOOST_IOSTREAMS_SOURCE': macro redefinition
endif(MSVC)

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})

set(sources src/file_descriptor.cpp src/mapped_file.cpp)
set(link_libraries)

find_package(ZLIB)
if(ZLIB_FOUND)
  include_directories(${ZLIB_INCLUDE_DIRS})
  list(APPEND sources src/zlib.cpp src/gzip.cpp)
  list(APPEND link_libraries ${ZLIB_LIBRARIES})
endif(ZLIB_FOUND)

find_package(BZip2)
if(BZIP2_FOUND)
  include_directories(${BZIP2_INCLUDE_DIR})
  list(APPEND sources src/bzip2.cpp)
  list(APPEND link_libraries ${BZIP2_LIBRARIES})
endif(BZIP2_FOUND)

boost_add_library(iostreams
  SOURCES
    ${sources}
  LINK_LIBRARIES
    ${link_libraries}
  )
