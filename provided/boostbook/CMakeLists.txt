# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(BoostBook
  AUTHORS
    "Douglas Gregor <doug.gregor -at- gmail.com>"
  DESCRIPTION
    "The BoostBook documentation format is an extension of DocBook,"
    "an SGML- or XML-based format for describing documentation."
  )

install(DIRECTORY dtd xsl
  DESTINATION share/boostbook
# CONFIGURATIONS
  COMPONENT boostbook_exe
  )

# 
set_boost_project("${BOOST_HAS_EXE_VAR}" ON)

add_subdirectory(doc)
