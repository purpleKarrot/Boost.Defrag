##########################################################################
# Copyright (C) 2007-2008 Douglas Gregor <doug.gregor@gmail.com>         #
# Copyright (C) 2007-2009 Troy Straszheim <troy@resophonic.com>          #
# Copyright (C) 2010-2011 Daniel Pfeifer <daniel@pfeifer-mail.de>        #
#                                                                        #
# Distributed under the Boost Software License, Version 1.0.             #
# See accompanying file LICENSE_1_0.txt or copy at                       #
#   http://www.boost.org/LICENSE_1_0.txt                                 #
##########################################################################

cmake_minimum_required(VERSION 2.8.3 FATAL_ERROR)
project(Boost)

# Boost CMake modules
list(APPEND CMAKE_MODULE_PATH ${Boost_SOURCE_DIR}/CMake)

##########################################################################
# Version and Package Information                                        #
##########################################################################

set(BOOST_VERSION_MAJOR 1)
set(BOOST_VERSION_MINOR 45)
set(BOOST_VERSION_PATCH 0)

set(BOOST_VERSION "${BOOST_VERSION_MAJOR}.${BOOST_VERSION_MINOR}")
if(BOOST_VERSION_PATCH GREATER 0)
  set(BOOST_VERSION "${BOOST_VERSION}.${BOOST_VERSION_PATCH}")
endif(BOOST_VERSION_PATCH GREATER 0)

# CPACK_PACKAGE_NAME may not contain spaces when generating rpms
set(CPACK_PACKAGE_NAME "Boost")
set(CPACK_PACKAGE_VENDOR "http://www.boost.org")
set(CPACK_PACKAGE_CONTACT "Daniel Pfeifer <daniel@pfeifer-mail.de>")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Boost ${BOOST_VERSION} prerelease")
set(CPACK_PACKAGE_FILE_NAME "boost-${BOOST_VERSION}-${BOOST_PLATFORM}-${BOOST_TOOLSET}")

if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/README.txt")
  message(STATUS "Using generic cpack package description file.")
  set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README.txt")
  set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.txt")
endif ()

set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE_1_0.txt")
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Welcome.txt")
  message(STATUS "Using generic cpack welcome file.")
  set(CPACK_RESOURCE_FILE_WELCOME "${CMAKE_CURRENT_SOURCE_DIR}/Welcome.txt")
endif()

set(CPACK_PACKAGE_VERSION_MAJOR "${BOOST_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${BOOST_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${BOOST_VERSION_PATCH}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "Boost")
#set(CPACK_PACKAGE_ICON "${CMAKE_CURRENT_SOURCE_DIR}/tools/build/CMake\\\\Boost.bmp")

set(CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_SOURCE_DIR}/src/boost.ico")
set(CPACK_NSIS_MUI_UNIICON "${CMAKE_CURRENT_SOURCE_DIR}/src/boost.ico")
set(CPACK_NSIS_INSTALLED_ICON_NAME "Uninstall.exe")
set(CPACK_NSIS_DISPLAY_NAME "Boost ${BOOST_VERSION}")
set(CPACK_NSIS_HELP_LINK "http:\\\\\\\\www.boost.org")
set(CPACK_NSIS_URL_INFO_ABOUT "http:\\\\\\\\www.boost.org")
set(CPACK_NSIS_CONTACT "boost-users@lists.boost.org")
set(CPACK_NSIS_MODIFY_PATH ON)

# Encode the compiler name in the package 
if (MSVC60)
  set(CPACK_PACKAGE_FILE_NAME "Boost-${BOOST_VERSION}-vc6")
  set(CPACK_NSIS_DISPLAY_NAME "${CPACK_NSIS_DISPLAY_NAME} for Microsoft Visual C++ 6")
elseif (MSVC70)
  set(CPACK_PACKAGE_FILE_NAME "Boost-${BOOST_VERSION}-vc7")
  set(CPACK_NSIS_DISPLAY_NAME "${CPACK_NSIS_DISPLAY_NAME} for Microsoft Visual Studio 2002")
elseif (MSVC71)
  set(CPACK_PACKAGE_FILE_NAME "Boost-${BOOST_VERSION}-vc71")
  set(CPACK_NSIS_DISPLAY_NAME "${CPACK_NSIS_DISPLAY_NAME} for Microsoft Visual Studio 2003")
elseif (MSVC80)
  set(CPACK_PACKAGE_FILE_NAME "Boost-${BOOST_VERSION}-vc8")
  set(CPACK_NSIS_DISPLAY_NAME "${CPACK_NSIS_DISPLAY_NAME} for Microsoft Visual Studio 2005")    
elseif (MSVC90)
  set(CPACK_PACKAGE_FILE_NAME "Boost-${BOOST_VERSION}-vc9")
  set(CPACK_NSIS_DISPLAY_NAME "${CPACK_NSIS_DISPLAY_NAME} for Microsoft Visual Studio 2008")
elseif (MSVC10)
  set(CPACK_PACKAGE_FILE_NAME "Boost-${BOOST_VERSION}-vc10")
  set(CPACK_NSIS_DISPLAY_NAME "${CPACK_NSIS_DISPLAY_NAME} for Microsoft Visual Studio 2010")
elseif (BORLAND)
  set(CPACK_PACKAGE_FILE_NAME "Boost-${BOOST_VERSION}-borland")  
  set(CPACK_NSIS_DISPLAY_NAME "${CPACK_NSIS_DISPLAY_NAME} for Borland C++ Builder")    
endif ()

##########################################################################
# Building and Testing                                                   #
##########################################################################

enable_testing()

# TODO?: create multiple build dirs with different configs when using makefiles
add_subdirectory(src)

##########################################################################
# Packaging                                                              #
##########################################################################

include(CPack)
#cpack_configure_downloads("http://www.purplekarrot.net/boost/${BOOST_VERSION}/" ALL ADD_REMOVE)
