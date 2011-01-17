# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(xpressive
  AUTHORS
    "Eric Niebler <eric -at- boost-consulting.com>"
  DESCRIPTION
    "Regular expressions that can be written as strings or as expression templates,"
    "and which can refer to each other and themselves recursively with the power of"
    "context-free grammars."
  DEPENDS
    fusion
    proto
    intrusive
    numeric
  )
