################################################################################
# Copyright (C) 2011 Daniel Pfeifer <daniel@pfeifer-mail.de>                   #
#                                                                              #
# Distributed under the Boost Software License, Version 1.0.                   #
# See accompanying file LICENSE_1_0.txt or copy at                             #
#   http://www.boost.org/LICENSE_1_0.txt                                       #
################################################################################


function(boost_fetch_svn name destination)
  cmake_parse_arguments(SVN "" "URL;REV" "" ${ARGN})

  find_package(Subversion REQUIRED)
  set(svn_command ${Subversion_SVN_EXECUTABLE} --quiet)

  if(SVN_REV)
    set(rev -r ${SVN_REV})
  else()
    set(rev)
  endif()

  if(EXISTS "${destination}/${name}/.svn")
    # TODO: check if url is correct
    execute_process(
      COMMAND ${svn_command} up ${rev}
      WORKING_DIRECTORY "${destination}/${name}"
      RESULT_VARIABLE error_code
      )
  else()
    file(REMOVE_RECURSE "${destination}/${name}")
    execute_process(
      COMMAND ${svn_command} co ${SVN_URL} ${rev} ${name}
      WORKING_DIRECTORY "${destination}"
      RESULT_VARIABLE error_code
      )
  endif()
  if(error_code)
    message(FATAL_ERROR "Failed to fetch from repository: '${SVN_URL}'")
  endif()
endfunction(boost_fetch_svn)
