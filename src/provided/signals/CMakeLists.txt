# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(signals
  AUTHORS
    "Douglas Gregor <doug.gregor -at- gmail.com>"
  DESCRIPTION
    "Managed signals & slots callback implementation."
  DEPENDS
    smart_ptr
    any
    intrusive
    bind
  )

boost_add_library(signals
  SOURCES
    src/trackable.cpp
    src/connection.cpp
    src/named_slot_map.cpp
    src/signal_base.cpp
    src/slot.cpp
  # <define>BOOST_SIGNALS_NO_LIB=1
  # <link>shared:<define>BOOST_SIGNALS_DYN_LINK=1
  )
