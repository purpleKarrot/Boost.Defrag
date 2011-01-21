# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(CRC
  AUTHORS
    "Daryle Walker <darylew -at- hotmail.com>"
  DESCRIPTION
    "The Boost CRC Library provides two implementations of CRC (cyclic"
    "redundancy code) computation objects and two implementations of CRC"
    "computation functions. The implementations are template-based."
  DEPENDS
    config
    integer
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})
