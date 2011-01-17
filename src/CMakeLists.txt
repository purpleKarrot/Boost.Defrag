##########################################################################
# Copyright (C) 2007-2009 Douglas Gregor <doug.gregor@gmail.com>         #
# Copyright (C) 2007-2009 Troy Straszheim <troy@resophonic.com>          #
# Copyright (C) 2010-2011 Daniel Pfeifer <daniel@pfeifer-mail.de>        #
#                                                                        #
# Distributed under the Boost Software License, Version 1.0.             #
# See accompanying file LICENSE_1_0.txt or copy at                       #
#   http://www.boost.org/LICENSE_1_0.txt                                 #
##########################################################################

if(NOT DEFINED BOOST_UPDATE_SOURCE)
  set(BOOST_UPDATE_SOURCE ON)
endif()

set(branch "stable") # or testing, unstable?

# global constants
set(BOOST_MONOLITHIC_ROOT ${Boost_BINARY_DIR}/${branch}-source)
set(BOOST_MODULES_DIR     ${BOOST_MONOLITHIC_ROOT}/src)
set(BOOST_INCLUDE_DIR     ${BOOST_MONOLITHIC_ROOT}/include)
include_directories(${BOOST_INCLUDE_DIR})

# 
set(CPACK_SOURCE_INSTALLED_DIRECTORIES
  "${BOOST_MONOLITHIC_ROOT};/"
  PARENT_SCOPE
  )

if(NOT BOOST_UPDATE_SOURCE)
  add_subdirectory(${BOOST_MODULES_DIR} ${Boost_BINARY_DIR}/build)
  return()
endif()

set(BOOST_UPDATE_SOURCE OFF CACHE BOOL "update source" FORCE)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMake)

include(BoostModule)
include(BoostFetchGit)
include(BoostFetchSubversion)
include(BoostFetchDownload)
include(BoostFetchMonolithic)

if(NOT DEFINED BOOST_UPDATE_SOURCE)
  set(BOOST_UPDATE_SOURCE ON)
endif()

file(COPY
  ${Boost_SOURCE_DIR}/CMake
  ${Boost_SOURCE_DIR}/CMakeLists.txt
  ${Boost_SOURCE_DIR}/LICENSE_1_0.txt
  ${Boost_SOURCE_DIR}/README.rst
  DESTINATION ${BOOST_MONOLITHIC_ROOT}
  )

file(MAKE_DIRECTORY "${BOOST_MODULES_DIR}")

set(BOOST_MODULE_LIST)

boost_get_module_download(docbook_xml
  URL http://www.oasis-open.org/docbook/xml/4.2/docbook-xml-4.2.zip
  MD5 73fe50dfe74ca631c1602f558ed8961f
  )

boost_get_module_download(docbook_xsl
  URL http://sourceforge.net/projects/docbook/files/docbook-xsl/1.75.2/docbook-xsl-1.75.2.tar.bz2/download
  MD5 0c76a58a8e6cb5ab49f819e79917308f
  )

file(GLOB_RECURSE modules "modules/*.cmake")
foreach(module ${modules})
  include(${module})
endforeach(module)

list(SORT BOOST_MODULE_LIST)
set(BOOST_MODULE_ADD_SUBDIRECTORIES)

foreach(module ${BOOST_MODULE_LIST})
  set(module_dir "${BOOST_MODULES_DIR}/${module}")
  set(BOOST_MODULE_ADD_SUBDIRECTORIES
    "${BOOST_MODULE_ADD_SUBDIRECTORIES}\nadd_subdirectory(${module})")

  # fetch the module
  set(stable_source "${BOOST_${module}_STABLE}")
  list(GET stable_source 0 service)
  list(REMOVE_AT stable_source 0)
  if(service MATCHES "DOWNLOAD")
    boost_get_module_download(${module} ${stable_source})
  elseif(service MATCHES "GIT")
    boost_get_module_git(${module} ${stable_source})
  elseif(service MATCHES "SVN")
    boost_get_module_svn(${module} ${stable_source})
  elseif(service MATCHES "COPY_FROM_BOOST_ROOT")
    boost_get_module_boost_root(${module} ${stable_source})
  else()
    message(FATAL_ERROR "no service for ${name} given!")
  endif()

  # create forwarding headers
  file(GLOB_RECURSE module_headers "${module_dir}/boost/*")
  foreach(header ${module_headers})
    file(RELATIVE_PATH relative ${module_dir} ${header})
    set(fwdfile "${BOOST_INCLUDE_DIR}/${relative}")
    if(NOT EXISTS ${fwdfile})
      get_filename_component(path ${relative} PATH)
      get_filename_component(fwd_absolute "${BOOST_INCLUDE_DIR}/${path}" ABSOLUTE)
      file(RELATIVE_PATH include "${fwd_absolute}" ${header})
      file(WRITE ${fwdfile} "#include \"${include}\"\n")
    endif()
  endforeach(header)
endforeach(module)

# TODO: remove this once all modules provide their own CMakeLists.txt file
execute_process(COMMAND ${CMAKE_COMMAND} -E copy_directory
  ${CMAKE_CURRENT_SOURCE_DIR}/provided ${BOOST_MODULES_DIR}
  )

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt.in
  ${BOOST_MODULES_DIR}/CMakeLists.txt @ONLY)

add_subdirectory(
  ${Boost_BINARY_DIR}/${branch}-source
  ${Boost_BINARY_DIR}/${branch}-binary
  )
