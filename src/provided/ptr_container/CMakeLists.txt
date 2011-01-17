# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(ptr_container
  AUTHORS
    "Thorsten Ottosen <nesotto -at- cs.auc.dk>"
  DESCRIPTION
    "Containers for storing heap-allocated polymorphic objects to ease OO-programming."
  DEPENDS
    circular_buffer
    range
  )
