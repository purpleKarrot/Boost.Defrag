# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Python
  AUTHORS
    "David Abrahams <dave -at- boostpro.com>"
  DESCRIPTION
    "A framework for interfacing Python and C++. It allows you to quickly and"
    "seamlessly expose C++ classes functions and objects to Python, and vice-versa,"
    "using no special tools -- just your C++ compiler."
  DEPENDS
    graph
    numeric # because of boost/cast.hpp from libs/python/src/errors.cpp:11
  )

find_package(PythonLibs)

if(NOT PYTHONLIBS_FOUND)
  return()
endif()

include_directories(${PYTHON_INCLUDE_DIRS})


boost_add_library(python
  SOURCES
    src/numeric.cpp
    src/list.cpp
    src/long.cpp
    src/dict.cpp
    src/tuple.cpp
    src/str.cpp
    src/slice.cpp
    src/converter/from_python.cpp
    src/converter/registry.cpp
    src/converter/type_id.cpp
    src/object/enum.cpp
    src/object/class.cpp
    src/object/function.cpp
    src/object/inheritance.cpp
    src/object/life_support.cpp
    src/object/pickle_support.cpp
    src/errors.cpp
    src/module.cpp
    src/converter/builtin_converters.cpp
    src/converter/arg_to_python_base.cpp
    src/object/iterator.cpp
    src/object/stl_iterator.cpp
    src/object_protocol.cpp
    src/object_operators.cpp
    src/wrapper.cpp
    src/import.cpp
    src/exec.cpp
    src/object/function_doc_signature.cpp
#  STATIC_DEFINITION
#    "BOOST_PYTHON_STATIC_LIB=1"
  LINK_LIBRARIES
    ${PYTHON_LIBRARIES}
  )
