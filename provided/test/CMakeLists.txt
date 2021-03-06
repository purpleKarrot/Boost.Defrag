# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

cmake_minimum_required(VERSION 2.8)

find_package(Boost 1.45 NO_MODULE)
include("${Boost_DEV_FILE}")

boost_project(Test
  AUTHORS
    "Gennadiy Rozental <gennadiy.rozental -at- gmail.com>"
  DESCRIPTION
    "Support for simple program testing, full unit testing, and for program execution monitoring."
  DEPENDS
    smart_ptr
    timer
    io
    bind
    numeric
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})

if(MSVC)
  add_definitions(/EHa) # specify the asynchronous exception handling model
endif(MSVC)

boost_add_library(prg_exec_monitor
  SOURCES
    src/execution_monitor.cpp
    src/debug.cpp
    src/cpp_main.cpp
#  SHARED_DEFINITION BOOST_TEST_DYN_LINK=1
  )

boost_add_library(test_exec_monitor STATIC
  src/compiler_log_formatter.cpp
  src/debug.cpp
  src/execution_monitor.cpp
  src/framework.cpp
  src/plain_report_formatter.cpp
  src/progress_monitor.cpp
  src/results_collector.cpp
  src/results_reporter.cpp
  src/test_main.cpp
  src/test_tools.cpp
  src/unit_test_log.cpp
  src/unit_test_main.cpp
  src/unit_test_monitor.cpp
  src/unit_test_parameters.cpp
  src/unit_test_suite.cpp
  src/xml_log_formatter.cpp
  src/xml_report_formatter.cpp
  )

boost_add_library(unit_test_framework
  SOURCES
    src/compiler_log_formatter.cpp
    src/debug.cpp
    src/exception_safety.cpp
    src/execution_monitor.cpp
    src/framework.cpp
    src/interaction_based.cpp
    src/logged_expectations.cpp
    src/plain_report_formatter.cpp
    src/progress_monitor.cpp
    src/results_collector.cpp
    src/results_reporter.cpp
    src/test_tools.cpp
    src/unit_test_log.cpp
    src/unit_test_main.cpp
    src/unit_test_monitor.cpp
    src/unit_test_parameters.cpp
    src/unit_test_suite.cpp
    src/xml_log_formatter.cpp
    src/xml_report_formatter.cpp
#  SHARED_DEFINITION BOOST_TEST_DYN_LINK=1
  )
