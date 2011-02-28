##########################################################################
# Copyright (C) 2007-2008 Douglas Gregor <doug.gregor@gmail.com>         #
# Copyright (C) 2007-2009 Troy Straszheim <troy@resophonic.com>          #
# Copyright (C) 2010-2011 Daniel Pfeifer <daniel@pfeifer-mail.de>        #
#                                                                        #
# Distributed under the Boost Software License, Version 1.0.             #
# See accompanying file LICENSE_1_0.txt or copy at                       #
#   http://www.boost.org/LICENSE_1_0.txt                                 #
##########################################################################

cmake_minimum_required(VERSION 2.8.2 FATAL_ERROR)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/CMake)

# a dropdown in the CMake GUI would be really cool
if(NOT BOOST_STAGE MATCHES "^STABLE$|^UNSTABLE$")
  set(BOOST_STAGE "STABLE" CACHE STRING "Possible values are STABLE and UNSTABLE" FORCE)
endif()

option(BOOST_INCLUDE_INCUBATING "Should incubating components be included?" OFF)

option(BOOST_DEBIAN_PACKAGES "" OFF)

#
set(BOOST_MONOLITHIC_DIR ${CMAKE_BINARY_DIR}/monolithic)


if(BOOST_UPDATE_SOURCE OR NOT DEFINED BOOST_UPDATE_SOURCE)
  include(BoostModule)
  include(BoostFetchGit)
  include(BoostFetchSubversion)
  include(BoostFetchDownload)
  include(BoostFetchPristineBoost)

  set(BOOST_FRAGMENT_LIST)

  set(fragments_expression "${CMAKE_SOURCE_DIR}/fragments/boost/*.cmake")

  if(BOOST_INCLUDE_INCUBATING)
    list(APPEND fragments_expression "${CMAKE_SOURCE_DIR}/fragments/incubating/*.cmake")
  endif(BOOST_INCLUDE_INCUBATING)

  file(GLOB_RECURSE modules ${fragments_expression})
  foreach(module ${modules})
    include(${module})
  endforeach(module)

  list(SORT BOOST_FRAGMENT_LIST)
  set(BOOST_MODULE_ADD_SUBDIRECTORIES)

  foreach(fragment ${BOOST_FRAGMENT_LIST})
    set(BOOST_MODULE_ADD_SUBDIRECTORIES
      "${BOOST_MODULE_ADD_SUBDIRECTORIES}\nadd_subdirectory(${fragment})")

    # fetch the fragment
    set(source "${BOOST_${fragment}_${BOOST_STAGE}}")
    list(GET source 0 service)
    list(REMOVE_AT source 0)

    message(STATUS "fetching '${fragment}' via ${service}.")

    # prepare arguments for boost_fetch_* functions
    set(args ${fragment} "${BOOST_MONOLITHIC_DIR}" ${source})

    if(service STREQUAL "DOWNLOAD")
      boost_fetch_download(${args})
    elseif(service STREQUAL "GIT")
      boost_fetch_git(${args})
    elseif(service STREQUAL "SVN")
      boost_fetch_svn(${args})
    elseif(service STREQUAL "COPY_FROM_PRISTINE_BOOST")
      boost_fetch_pristine_boost(${args})
    else()
      message(FATAL_ERROR "no service for ${name} given!")
    endif()
  endforeach(fragment)

  configure_file(CMakeLists.txt.in
    "${BOOST_MONOLITHIC_DIR}/CMakeLists.txt" @ONLY)

  file(COPY
    BoostCPack.cmake
    CTestConfig.cmake
    LICENSE_1_0.txt
    README.txt
    DESTINATION ${BOOST_MONOLITHIC_DIR}
    )

  set(BOOST_UPDATE_SOURCE OFF CACHE BOOL "update source" FORCE)
endif(BOOST_UPDATE_SOURCE OR NOT DEFINED BOOST_UPDATE_SOURCE)

# TODO: remove this once all modules provide their own CMakeLists.txt file
execute_process(COMMAND ${CMAKE_COMMAND} -E copy_directory
  "${CMAKE_SOURCE_DIR}/provided" "${BOOST_MONOLITHIC_DIR}"
  )

if(BOOST_DEBIAN_PACKAGES)
  list(APPEND BOOST_FOOTER BoostDebian BoostRPM)
endif(BOOST_DEBIAN_PACKAGES)

add_subdirectory("${BOOST_MONOLITHIC_DIR}" "${BOOST_MONOLITHIC_DIR}-build")

# 
set(CPACK_SOURCE_INSTALLED_DIRECTORIES
  "${BOOST_MONOLITHIC_DIR};/" CACHE INTERNAL "" FORCE
  )
