# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

cmake_minimum_required(VERSION 2.8)

find_package(Boost 1.45 NO_MODULE)
include("${Boost_DEV_FILE}")

boost_project(Range
  AUTHORS
    "Thorsten Ottosen <nesotto -at- cs.auc.dk>"
  DESCRIPTION
    "A new infrastructure for generic algorithms that builds on top of the new iterator concepts."
  DEPENDS
    algorithm
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})
