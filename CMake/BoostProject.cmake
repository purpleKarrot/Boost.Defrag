##########################################################################
# Copyright (C) 2007-2009 Douglas Gregor <doug.gregor@gmail.com>         #
# Copyright (C) 2007-2009 Troy Straszheim <troy@resophonic.com>          #
# Copyright (C) 2010-2011 Daniel Pfeifer <daniel@pfeifer-mail.de>        #
#                                                                        #
# Distributed under the Boost Software License, Version 1.0.             #
# See accompanying file LICENSE_1_0.txt or copy at                       #
#   http://www.boost.org/LICENSE_1_0.txt                                 #
##########################################################################

include(CMakeParseArguments)

# use this function as a replacement for 'project' in boost projects.
function(boost_project name)
  cmake_parse_arguments(PROJ "" "" "AUTHORS;DESCRIPTION;DEPENDS" ${ARGN})
  set(BOOST_PROJECT_NAME ${name} PARENT_SCOPE)
  project(${name})
endfunction(boost_project)

# this function is like 'target_link_libraries, except only for boost libs
function(boost_link_libraries target)
  cmake_parse_arguments(LIBS "SHARED;STATIC" "" "" ${ARGN})
  set(link_libs)

  foreach(lib ${LIBS_UNPARSED_ARGUMENTS})
    if(LIBS_STATIC)
      list(APPEND link_libs "${lib}-static")
    else()
      list(APPEND link_libs "${lib}-shared")
    endif()
  endforeach(lib)

  target_link_libraries(${target} ${link_libs})
endfunction(boost_link_libraries)

# Creates a Boost library target that generates a compiled library
# (.a, .lib, .dll, .so, etc) from source files.
#
#   boost_add_library(name [SHARED|STATIC]
#     SOURCES
#       source1
#       source2
#       ...
#     LINK_BOOST_LIBRARIES
#       system
#     LINK_LIBRARIES
#       ...
#     )
#
# where "name" is the name of library (e.g. "regex", not "boost_regex")
# and source1, source2, etc. are the source files used
# to build the library, e.g., cregex.cpp.
#
# This macro has a variety of options that affect its behavior. In
# several cases, we use the placeholder "feature" in the option name
# to indicate that there are actually several different kinds of
# options, each referring to a different build feature, e.g., shared
# libraries, multi-threaded, debug build, etc. For a complete listing
# of these features, please refer to the CMakeLists.txt file in the
# root of the Boost distribution, which defines the set of features
# that will be used to build Boost libraries by default.
#
# The options that affect this macro's behavior are:
#
#   LINK_LIBS: Provides additional libraries against which each of the
#   library variants will be linked. For example, one might provide
#   "expat" as options to LINK_LIBS, to state that each of the library
#   variants will link against the expat library binary. Use LINK_LIBS
#   for libraries external to Boost; for Boost libraries, use DEPENDS.
#
#   DEPENDS: States that this Boost library depends on and links
#   against another Boost library. The arguments to DEPENDS should be
#   the unversioned name of the Boost library, such as
#   "boost_filesystem". Like LINK_LIBS, this option states that all
#   variants of the library being built will link against the stated
#   libraries. Unlike LINK_LIBS, however, DEPENDS takes particular
#   library variants into account, always linking the variant of one
#   Boost library against the same variant of the other Boost
#   library. For example, if the boost_mpi_python library DEPENDS on
#   boost_python, multi-threaded variants of boost_mpi_python will
#   link against multi-threaded variants of boost_python.
#
function(boost_add_library name)
  cmake_parse_arguments(LIB
    "SHARED;STATIC" #;SINGLE_THREAD;MULTI_THREAD"
    "PCH"
    "SOURCES;LINK_BOOST_LIBRARIES;LINK_LIBRARIES"
    ${ARGN}
    )

  if(NOT LIB_SOURCES)
    set(LIB_SOURCES ${LIB_UNPARSED_ARGUMENTS})
  endif(NOT LIB_SOURCES)

  if(NOT LIB_SHARED AND NOT LIB_STATIC)
    set(LIB_SHARED ON)
    set(LIB_STATIC ON)
  endif(NOT LIB_SHARED AND NOT LIB_STATIC)

# if(NOT LIB_SINGLE_THREAD AND NOT LIB_MULTI_THREAD)
#   set(LIB_SINGLE_THREAD ON)
#   set(LIB_MULTI_THREAD  ON)
# endif(NOT LIB_SINGLE_THREAD AND NOT LIB_MULTI_THREAD)

  if(LIB_PCH)
    # TODO: support precompiled headers
  endif(LIB_PCH)

  set(targets)
  
  if(LIB_SHARED)
    set(target ${name}-shared)
    add_library(${target} SHARED ${LIB_SOURCES})
    boost_link_libraries(${target} ${LIB_LINK_BOOST_LIBRARIES} SHARED)
    target_link_libraries(${target} ${LIB_LINK_LIBRARIES})
	set_property(TARGET ${name}-shared
	  APPEND PROPERTY COMPILE_DEFINITIONS "BOOST_ALL_DYN_LINK=1")
    list(APPEND targets ${target})
  endif(LIB_SHARED)

  if(LIB_STATIC)
    set(target ${name}-static)
    add_library(${name}-static STATIC ${LIB_SOURCES})
    boost_link_libraries(${target} ${LIB_LINK_BOOST_LIBRARIES} STATIC)
    target_link_libraries(${target} ${LIB_LINK_LIBRARIES})
    list(APPEND targets ${target})
  endif(LIB_STATIC)

# set_target_properties(${name} PROPERTIES
#   #DEFINE_SYMBOL "${name}_EXPORT"
#   PREFIX libboost_ # or boost_ for dlls  # TODO: can we set this globally?
#   )

  set_property(TARGET ${targets} PROPERTY FOLDER "${BOOST_PROJECT_NAME}")

  install(TARGETS ${targets}
    ARCHIVE DESTINATION lib COMPONENT ${CMAKE_PROJECT_NAME}-dev
    LIBRARY DESTINATION lib COMPONENT ${CMAKE_PROJECT_NAME}-dev
    RUNTIME DESTINATION bin COMPONENT ${CMAKE_PROJECT_NAME}-lib
    )
endfunction(boost_add_library)


# Creates a new executable from source files.
#
#   boost_add_executable(exename
#                        source1 source2 ...
#                        [LINK_LIBS linklibs]
#                        [DEPENDS libdepend1 libdepend2 ...]
#                       )
#
# where exename is the name of the executable (e.g., "wave").  source1,
# source2, etc. are the source files used to build the executable, e.g.,
# cpp.cpp. If no source files are provided, "exename.cpp" will be
# used.
#
# This macro has a variety of options that affect its behavior. In
# several cases, we use the placeholder "feature" in the option name
# to indicate that there are actually several different kinds of
# options, each referring to a different build feature, e.g., shared
# libraries, multi-threaded, debug build, etc. For a complete listing
# of these features, please refer to the CMakeLists.txt file in the
# root of the Boost distribution, which defines the set of features
# that will be used to build Boost libraries by default.
#
# The options that affect this macro's behavior are:
#
#   LINK_LIBS: Provides additional libraries against which the
#   executable will be linked. For example, one might provide "expat"
#   as options to LINK_LIBS, to state that the executable will link
#   against the expat library binary. Use LINK_LIBS for libraries
#   external to Boost; for Boost libraries, use DEPENDS.
#
#   DEPENDS: States that this executable depends on and links against
#   a Boostlibrary. The arguments to DEPENDS should be the unversioned
#   name of the Boost library, such as "boost_filesystem". Like
#   LINK_LIBS, this option states that the executable will link
#   against the stated libraries. Unlike LINK_LIBS, however, DEPENDS
#   takes particular library variants into account, always linking to
#   the appropriate variant of a Boost library. For example, if the
#   MULTI_THREADED feature was requested in the call to
#   boost_add_executable, DEPENDS will ensure that we only link
#   against multi-threaded libraries.
#
# Example:
#   boost_add_executable(wave cpp.cpp 
#     DEPENDS boost_wave boost_program_options boost_filesystem 
#             boost_serialization
#     )
function(boost_add_executable name)
  cmake_parse_arguments(EXE "" ""
    "SOURCES;LINK_BOOST_LIBRARIES;LINK_LIBRARIES" ${ARGN})

  add_executable(${name} ${EXE_SOURCES})
  boost_link_libraries(${name} ${EXE_LINK_BOOST_LIBRARIES})
  target_link_libraries(${name} ${EXE_LINK_LIBRARIES})
  set_property(TARGET ${name} PROPERTY FOLDER "${BOOST_PROJECT_NAME}")
endfunction(boost_add_executable)


#
#  Macro for building boost.python extensions
#
macro(boost_python_extension MODULE_NAME)
  parse_arguments(BPL_EXT  "" "" ${ARGN})

  if (WIN32)
    set(extlibtype SHARED)
  else()
    set(extlibtype MODULE)
  endif()

  boost_add_single_library(${MODULE_NAME}
    ${BPL_EXT_DEFAULT_ARGS}
    ${extlibtype}
    LINK_LIBS ${PYTHON_LIBRARIES}
    DEPENDS boost_python
    SHARED
    MULTI_THREADED
    )

  if(WIN32)
    set_target_properties(${VARIANT_LIBNAME} PROPERTIES
      OUTPUT_NAME "${MODULE_NAME}"
      PREFIX ""
      SUFFIX .pyd
      IMPORT_SUFFIX .pyd
      )
  else()
    set_target_properties(${VARIANT_LIBNAME} PROPERTIES
      OUTPUT_NAME "${MODULE_NAME}"
      PREFIX ""
      )
  endif()
endmacro(boost_python_extension)

function(boost_add_python_extension)
endfunction(boost_add_python_extension)
