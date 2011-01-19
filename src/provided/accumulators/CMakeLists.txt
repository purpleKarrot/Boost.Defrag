# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(accumulators
  AUTHORS
    "Eric Niebler <eric -at- boost-consulting.com>"
  DESCRIPTION
    "A framework for incremental calculation, and a collection of statistical accumulators."
  DEPENDS
    parameter
    typeof
    foreach
  )

add_subdirectory(doc)
add_subdirectory(test)
