# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(asio
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
