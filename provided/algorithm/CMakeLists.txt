# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

cmake_minimum_required(VERSION 2.8)

find_package(Boost 1.45 NO_MODULE)
include("${Boost_DEV_FILE}")

boost_project(Algorithm
  AUTHORS
    "Pavol Droba <droba -at- topmail.sk>"
    "Herve Bronnimann <hbr -at- poly.edu>"
  DESCRIPTION
    "A library of various algorithms."
  DEPENDS
    concept_check
    range
    regex
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})
