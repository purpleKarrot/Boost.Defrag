# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Wave
  AUTHORS
    "Hartmut Kaiser <hartmut.kaiser -at- gmail.com>"
  DESCRIPTION
    "A standards-conformant and highly-configurable implementation of the mandated"
    "C99/C++ preprocessor functionality packed behind an easy to use iterator interface."
  DEPENDS
    filesystem
    program_options
    spirit
    thread
    intrusive
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})

boost_add_library(wave
  SOURCES
    src/instantiate_cpp_exprgrammar.cpp
    src/instantiate_cpp_grammar.cpp
    src/instantiate_cpp_literalgrs.cpp
    src/instantiate_defined_grammar.cpp
    src/instantiate_predef_macros.cpp
    src/instantiate_re2c_lexer.cpp
    src/instantiate_re2c_lexer_str.cpp
    src/token_ids.cpp
    src/wave_config_constant.cpp
    src/cpplexer/re2clex/aq.cpp
    src/cpplexer/re2clex/cpp_re.cpp
  LINK_BOOST_LIBRARIES
    filesystem
    thread
    date_time
  )

boost_add_executable(wave
  SOURCES
    tools/wave/cpp.cpp
  LINK_BOOST_LIBRARIES
    wave
    program_options
    filesystem
    serialization
    system
    thread
    date_time
  )