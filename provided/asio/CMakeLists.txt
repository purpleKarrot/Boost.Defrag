# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

include(BoostProject)
include(BoostTesting)

boost_project(Asio
  AUTHORS
    "Chris Kohlhoff <chris -at- kohlhoff.com>"
  DESCRIPTION
    "Portable networking, including sockets, timers, hostname resolution and socket iostreams."
  DEPENDS
    config
    date_time
    exception
    system
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})

add_subdirectory(doc)
