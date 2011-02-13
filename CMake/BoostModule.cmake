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
#   boost_fragment(libname
#     DOWNLOAD
#       URL http://host.tld/libname-01.tgz
#       MD5 d41d8cd98f00b204e9800998ecf8427e
#     DEPENDS
#       config
#     )
#
function(boost_fragment name)
  set(stages "STABLE;UNSTABLE")
  cmake_parse_arguments(FRAG "" "" "${stages}" ${ARGN})

  foreach(stage ${stages})
    set(variable BOOST_${name}_${stage})
    if(FRAG_${stage})
      set(${variable} ${FRAG_${stage}} PARENT_SCOPE)
    else()
      set(${variable} ${FRAG_UNPARSED_ARGUMENTS} PARENT_SCOPE)
    endif()
  endforeach(stage)

  set(BOOST_FRAGMENT_LIST ${BOOST_FRAGMENT_LIST} ${name} PARENT_SCOPE)
endfunction(boost_fragment)

## backwards compatibility
macro(boost_module)
  boost_fragment(${ARGN})
endmacro(boost_module)
