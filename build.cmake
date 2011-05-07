#!/usr/bin/cmake -P

##########################################################################
# Copyright (C) 2011 Daniel Pfeifer <daniel@pfeifer-mail.de>             #
#                                                                        #
# Distributed under the Boost Software License, Version 1.0.             #
# See accompanying file LICENSE_1_0.txt or copy at                       #
#   http://www.boost.org/LICENSE_1_0.txt                                 #
##########################################################################

# cmake -DBUILDDIR=/path -DBUILDSTEP=configure -P build.cmake

if(NOT DEFINED BUILDDIR)
  set(BUILDDIR "${CMAKE_CURRENT_LIST_DIR}/build")
endif(NOT DEFINED BUILDDIR)

set(TOOLSET_NAME default)
if(EXISTS "${BUILDDIR}/toolchain.cmake")
  include("${BUILDDIR}/toolchain.cmake")
  set(TOOLCHAIN_PARAM "-DCMAKE_TOOLCHAIN_FILE=${BUILDDIR}/toolchain.cmake")
elseif(CMAKE_HOST_WIN32)
  if(EXISTS "$ENV{VS100COMNTOOLS}vsvars32.bat")
    set(TOOLSET_NAME vs10)
  elseif(EXISTS "$ENV{VS90COMNTOOLS}vsvars32.bat")
    set(TOOLSET_NAME vs9)
  elseif(EXISTS "$ENV{VS80COMNTOOLS}vsvars32.bat")
    set(TOOLSET_NAME vs8)
  elseif(EXISTS "$ENV{VS71COMNTOOLS}vsvars32.bat")
    set(TOOLSET_NAME vs71)
  endif()
endif(EXISTS "${BUILDDIR}/toolchain.cmake")


if(CMAKE_HOST_WIN32)
  if(TOOLSET_NAME STREQUAL "vs10")
    set(VSVARS_BAT "%VS100COMNTOOLS%vsvars32.bat")
  elseif(TOOLSET_NAME STREQUAL "vs9")
    set(VSVARS_BAT "%VS90COMNTOOLS%vsvars32.bat")
  elseif(TOOLSET_NAME STREQUAL "vs8")
    set(VSVARS_BAT "%VS80COMNTOOLS%vsvars32.bat")
  elseif(TOOLSET_NAME STREQUAL "vs71")
    set(VSVARS_BAT "%VS71COMNTOOLS%vsvars32.bat")
  endif()
  if(DEFINED VSVARS_BAT)
    file(WRITE "${BUILDDIR}/vsvars.bat"
      "@call \"${VSVARS_BAT}\"\n"
      "@> vsvars.cmake echo set(ENV{PATH} \"%PATH:\\=\\\\%\")\n"
      "@>>vsvars.cmake echo set(ENV{INCLUDE} \"%INCLUDE:\\=\\\\%\")\n"
      "@>>vsvars.cmake echo set(ENV{LIB} \"%LIB:\\=\\\\%\")\n"
      "@>>vsvars.cmake echo set(ENV{LIBPATH} \"%LIBPATH:\\=\\\\%\")\n"
      )
    execute_process(COMMAND "${BUILDDIR}/vsvars.bat"
      WORKING_DIRECTORY "${BUILDDIR}"
      )
    include("${BUILDDIR}/vsvars.cmake")
  endif(DEFINED VSVARS_BAT)
endif(CMAKE_HOST_WIN32)


if(NOT DEFINED GENERATOR)
  if(CMAKE_HOST_WIN32)
    set(GENERATOR "NMake Makefiles")
  else(CMAKE_HOST_WIN32)
    set(GENERATOR "Unix Makefiles")
  endif(CMAKE_HOST_WIN32)
endif(NOT DEFINED GENERATOR)


if(CMAKE_HOST_WIN32)
  set(MAKE_COMMAND nmake)
else(CMAKE_HOST_WIN32)
  set(MAKE_COMMAND make)
endif(CMAKE_HOST_WIN32)


set(debug_dir "${BUILDDIR}/debug")
set(release_dir "${BUILDDIR}/release")
set(package_dir "${BUILDDIR}/package")


if(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "aggregate")
  file(MAKE_DIRECTORY "${debug_dir}")
  file(MAKE_DIRECTORY "${release_dir}")
  # TODO: dont aggregate sources during configure
endif(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "aggregate")


if(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "configure")
  execute_process(COMMAND "${CMAKE_COMMAND}" "-G${GENERATOR}"
    -DBOOST_UPDATE_SOURCE=1 # TODO: move to aggregate step
    "${TOOLCHAIN_PARAM}" -DCMAKE_BUILD_TYPE=Debug 
    "${CMAKE_CURRENT_LIST_DIR}"
    WORKING_DIRECTORY "${debug_dir}"
    )
  execute_process(COMMAND "${CMAKE_COMMAND}" "-G${GENERATOR}"
    "${TOOLCHAIN_PARAM}" -DCMAKE_BUILD_TYPE=Release
    "${debug_dir}/monolithic"
    WORKING_DIRECTORY "${release_dir}"
    )
endif(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "configure")


if(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "build")
  execute_process(COMMAND ${MAKE_COMMAND}
    WORKING_DIRECTORY "${debug_dir}"
    )
  execute_process(COMMAND ${MAKE_COMMAND}
    WORKING_DIRECTORY "${release_dir}"
    )
endif(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "build")


if(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "test")
  execute_process(COMMAND ${MAKE_COMMAND} test
    WORKING_DIRECTORY "${debug_dir}"
    )
  execute_process(COMMAND ${MAKE_COMMAND} test
    WORKING_DIRECTORY "${release_dir}"
    )
endif(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "test")


if(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "documentation")
  execute_process(COMMAND ${MAKE_COMMAND} documentation
    WORKING_DIRECTORY "${release_dir}"
    )
endif(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "documentation")


if(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "package")
  file(WRITE "${BUILDDIR}/CPackConfig.cmake"
    "include(\"${release_dir}/CPackConfig.cmake\")\n"
    "set(CPACK_INSTALL_CMAKE_PROJECTS\n"
    "  \"${debug_dir};Boost;ALL;/\"\n"
    "  \"${release_dir};Boost;ALL;/\"\n"
    "  )\n"
    )
  execute_process(COMMAND cpack
    WORKING_DIRECTORY "${BUILDDIR}"
    )
endif(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "package")

