##########################################################################
# Copyright (C) 2010-2011 Daniel Pfeifer <daniel@pfeifer-mail.de>        #
#                                                                        #
# Distributed under the Boost Software License, Version 1.0.             #
# See accompanying file LICENSE_1_0.txt or copy at                       #
#   http://www.boost.org/LICENSE_1_0.txt                                 #
##########################################################################

set(CTEST_PROJECT_NAME "Boost")
set(CTEST_NIGHTLY_START_TIME "00:00:00 EST")

set(CTEST_DROP_METHOD "http")
if(NOT CTEST_DROP_SITE)
  set(CTEST_DROP_SITE "my.cdash.org")
endif()

set(CTEST_DROP_LOCATION "/submit.php?project=BoostCMake")
set(CTEST_DROP_SITE_CDASH TRUE)
