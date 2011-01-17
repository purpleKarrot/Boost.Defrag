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

#TODO: Finish this documentation
# Defines dependencies and origin of a boost module. Use as:
#
#   boost_module(libname
#     DOWNLOAD
#       URL http://host.tld/libname-01.tgz
#       MD5 d41d8cd98f00b204e9800998ecf8427e
#     DEPENDS
#       config
#     )
#
function(boost_module name)
  set(options    "PROPOSED;TOOL")
  set(parameters "STABLE;UNSTABLE")
  cmake_parse_arguments(MODULE "${options}" "" "${parameters}" ${ARGN})

  if(NOT MODULE_STABLE)
    set(MODULE_STABLE ${MODULE_UNPARSED_ARGUMENTS})
  endif()

  if(NOT MODULE_TESTING)
    set(MODULE_TESTING ${MODULE_UNPARSED_ARGUMENTS})
  endif()

  foreach(param ${options} ${parameters})
    set(BOOST_${name}_${param} ${MODULE_${param}} PARENT_SCOPE)
  endforeach(param)

  set(BOOST_MODULE_LIST ${BOOST_MODULE_LIST} ${name} PARENT_SCOPE)
endfunction(boost_module)
