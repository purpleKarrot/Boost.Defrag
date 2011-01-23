# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project("Program Options"
  AUTHORS
    "Vladimir Prus <ghost -at- cs.msu.su>"
  DESCRIPTION
    "Access to configuration data given on command line, in config files and other sources."
  DEPENDS
    any
    bind
    smart_ptr
    test
    tokenizer
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})

boost_add_library(program_options
  SOURCES
    src/cmdline
    src/config_file
    src/options_description
    src/parsers
    src/variables_map
    src/value_semantic
    src/positional_options
    src/utf8_codecvt_facet
    src/convert
    src/winmain
    src/split
#  SHARED_DEFINITION "BOOST_PROGRAM_OPTIONS_DYN_LINK=1"
  )
