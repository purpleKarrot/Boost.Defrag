# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Interprocess
  AUTHORS
    "Ion Gaztanaga <igaztanaga -at- gmail.com>"
  DESCRIPTION
    "Shared memory, memory mapped files, process-shared mutexes, condition"
    "variables, containers and allocators."
  DEPENDS
    date_time
    intrusive
    math
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})
