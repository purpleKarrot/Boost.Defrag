##########################################################################
# Copyright (C) 2011 Daniel Pfeifer <daniel@pfeifer-mail.de>             #
#                                                                        #
# Distributed under the Boost Software License, Version 1.0.             #
# See accompanying file LICENSE_1_0.txt or copy at                       #
#   http://www.boost.org/LICENSE_1_0.txt                                 #
##########################################################################

# Find DocBook to LaTeX Publishing (http://dblatex.sourceforge.net/)

if(DBLATEX_FOUND)
  return()
endif(DBLATEX_FOUND)

if(CMAKE_HOST_WIN32)
  include(FindPythonInterp)
  find_file(dblatex_py dblatex
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.7\\InstallPath]/Scripts
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.6\\InstallPath]/Scripts
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.5\\InstallPath]/Scripts
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.4\\InstallPath]/Scripts
    )
  if(PYTHONINTERP_FOUND AND dblatex_py)
    set(DBLATEX_EXECUTABLE ${PYTHON_EXECUTABLE} ${dblatex_py}
      CACHE FILEPATH "dblatex executable"
      )
  endif(PYTHONINTERP_FOUND AND dblatex_py)
  unset(dblatex_py CACHE)
else()
  find_program(DBLATEX_EXECUTABLE dblatex)
endif()

if(DBLATEX_EXECUTABLE)
  execute_process(COMMAND ${DBLATEX_EXECUTABLE} --version
    OUTPUT_VARIABLE DBLATEX_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)
  string(REGEX REPLACE "^dblatex version (.+)$" "\\1"
    DBLATEX_VERSION "${DBLATEX_VERSION}")
endif(DBLATEX_EXECUTABLE)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(DBLATEX
  REQUIRED_VARS DBLATEX_EXECUTABLE
  VERSION_VAR DBLATEX_VERSION
  )

mark_as_advanced(DBLATEX_EXECUTABLE)
set(DBLATEX_FOUND ${DBLATEX_FOUND} CACHE INTERNAL "")
