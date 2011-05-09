#!/usr/bin/cmake -P

##########################################################################
# Copyright (C) 2011 Daniel Pfeifer <daniel@pfeifer-mail.de>             #
#                                                                        #
# Distributed under the Boost Software License, Version 1.0.             #
# See accompanying file LICENSE_1_0.txt or copy at                       #
#   http://www.boost.org/LICENSE_1_0.txt                                 #
##########################################################################

# cmake -DBUILDDIR=../build -DTOOLCHAIN=vs9 -DBUILDSTEP=configure -P build.cmake


set(MAKE_COMMAND make)
set(GENERATOR "Unix Makefiles")


if(NOT DEFINED BUILDDIR)
  set(BUILDDIR "${CMAKE_CURRENT_LIST_DIR}/build")
elseif(NOT IS_ABSOLUTE "${BUILDDIR}")
  set(BUILDDIR "${CMAKE_CURRENT_LIST_DIR}/${BUILDDIR}")
endif()


if(CMAKE_HOST_WIN32 AND NOT DEFINED TOOLCHAIN)
  if(EXISTS "$ENV{VS100COMNTOOLS}vsvars32.bat")
    set(TOOLCHAIN vs10)
  elseif(EXISTS "$ENV{VS90COMNTOOLS}vsvars32.bat")
    set(TOOLCHAIN vs9)
  elseif(EXISTS "$ENV{VS80COMNTOOLS}vsvars32.bat")
    set(TOOLCHAIN vs8)
  elseif(EXISTS "$ENV{VS71COMNTOOLS}vsvars32.bat")
    set(TOOLCHAIN vs71)
  endif()
endif(CMAKE_HOST_WIN32 AND NOT DEFINED TOOLCHAIN)


if(DEFINED TOOLCHAIN)
  set(toolchain_file "${CMAKE_CURRENT_LIST_DIR}/toolchains/${TOOLCHAIN}.cmake")
  if(EXISTS "${toolchain_file}")
    include("${toolchain_file}")
    set(toolchain_param "-DCMAKE_TOOLCHAIN_FILE=${toolchain_file}")
  endif(EXISTS "${toolchain_file}")
endif(DEFINED TOOLCHAIN)


if(CMAKE_HOST_WIN32)
  if(TOOLCHAIN STREQUAL "vs10")
    set(VSVARS_BAT "%VS100COMNTOOLS%vsvars32.bat")
  elseif(TOOLCHAIN STREQUAL "vs9")
    set(VSVARS_BAT "%VS90COMNTOOLS%vsvars32.bat")
  elseif(TOOLCHAIN STREQUAL "vs8")
    set(VSVARS_BAT "%VS80COMNTOOLS%vsvars32.bat")
  elseif(TOOLCHAIN STREQUAL "vs71")
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
      OUTPUT_QUIET
      )
    include("${BUILDDIR}/vsvars.cmake")
    set(GENERATOR "NMake Makefiles")
    set(MAKE_COMMAND nmake)
  endif(DEFINED VSVARS_BAT)
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
    "${toolchain_param}" -DCMAKE_BUILD_TYPE=Debug 
    "${CMAKE_CURRENT_LIST_DIR}"
    WORKING_DIRECTORY "${debug_dir}"
    RESULT_VARIABLE debug_result
    )
  execute_process(COMMAND "${CMAKE_COMMAND}" "-G${GENERATOR}"
    "${toolchain_param}" -DCMAKE_BUILD_TYPE=Release
    "${debug_dir}/monolithic"
    WORKING_DIRECTORY "${release_dir}"
    RESULT_VARIABLE release_result
    )
  if(NOT debug_result EQUAL 0 OR NOT release_result EQUAL 0)
    message(FATAL_ERROR "Configuring failed.")
  endif(NOT debug_result EQUAL 0 OR NOT release_result EQUAL 0)
endif(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "configure")


if(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "build")
  execute_process(COMMAND ${MAKE_COMMAND}
    WORKING_DIRECTORY "${debug_dir}"
    RESULT_VARIABLE debug_result
    )
  execute_process(COMMAND ${MAKE_COMMAND}
    WORKING_DIRECTORY "${release_dir}"
    RESULT_VARIABLE release_result
    )
  if(NOT debug_result EQUAL 0 OR NOT release_result EQUAL 0)
    message(FATAL_ERROR "Building failed.")
  endif(NOT debug_result EQUAL 0 OR NOT release_result EQUAL 0)
endif(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "build")


if(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "test")
  execute_process(COMMAND ${MAKE_COMMAND} test
    WORKING_DIRECTORY "${debug_dir}"
    RESULT_VARIABLE debug_result
    )
  execute_process(COMMAND ${MAKE_COMMAND} test
    WORKING_DIRECTORY "${release_dir}"
    RESULT_VARIABLE release_result
    )
  if(NOT debug_result EQUAL 0 OR NOT release_result EQUAL 0)
    message(FATAL_ERROR "Testing failed.")
  endif(NOT debug_result EQUAL 0 OR NOT release_result EQUAL 0)
endif(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "test")


if(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "documentation")
  execute_process(COMMAND ${MAKE_COMMAND} documentation
    WORKING_DIRECTORY "${release_dir}"
    RESULT_VARIABLE result
    )
  if(NOT result EQUAL 0)
    message(FATAL_ERROR "Generating of documentation failed.")
  endif(NOT result EQUAL 0)
endif(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "documentation")


if(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "package")
  file(WRITE "${package_dir}/CPackConfig.cmake"
    "include(\"${release_dir}/CPackConfig.cmake\")\n"
    "set(CPACK_INSTALL_CMAKE_PROJECTS\n"
    "  \"${debug_dir};Boost;ALL;/\"\n"
    "  \"${release_dir};Boost;ALL;/\"\n"
    "  )\n"
    )
  execute_process(COMMAND cpack
    WORKING_DIRECTORY "${package_dir}"
    RESULT_VARIABLE result
    )
  if(NOT result EQUAL 0)
    message(FATAL_ERROR "Packaging failed.")
  endif(NOT result EQUAL 0)
endif(NOT DEFINED BUILDSTEP OR BUILDSTEP STREQUAL "package")

