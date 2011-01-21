# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(QuickBook
  AUTHORS
    "Joel de Guzman <joel -at- boost-consulting.com>"
    "Eric Niebler <eric -at- boost-consulting.com>"
  DESCRIPTION
    "A WikiWiki style documentation tool geared towards C++ documentation"
  DEPENDS
    filesystem
    program_options 
  )

add_definitions(-DBOOST_ALL_DYN_LINK=1)

if(MSVC)
  add_definitions(-D_SCL_SECURE_NO_WARNINGS -D_CRT_SECURE_NO_WARNINGS
    /wd4244 /wd4267 /wd4355 /wd4511 /wd4512 /wd4701 /wd4702 /wd4800)
endif()

boost_add_executable(quickbook MULTI_THREADED
  SOURCES
    src/quickbook.cpp
    src/actions.cpp
    src/doc_info_actions.cpp
    src/actions_class.cpp
    src/utils.cpp
    src/input_path.cpp
    src/post_process.cpp
    src/collector.cpp
    src/template_stack.cpp
    src/code_snippet.cpp
    src/markups.cpp
    src/syntax_highlight.cpp
    src/block_grammar.cpp
    src/phrase_grammar.cpp
    src/doc_info_grammar.cpp
  LINK_BOOST_LIBRARIES
    filesystem
    program_options
    system
  )

boost_documentation(doc/quickbook.qbk
#  IMAGES
#    doc/html/images
  )
