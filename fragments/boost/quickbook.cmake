# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_module(quickbook
  STABLE SVN
#   URL http://svn.boost.org/svn/boost/tags/release/Boost_1_46_0/tools/quickbook/
    URL http://svn.boost.org/svn/boost/trunk/tools/quickbook/
    REV 69249 # Workaround for optimization bug in 64-bit g++ 4.4.
  UNSTABLE SVN
    URL http://svn.boost.org/svn/boost/trunk/tools/quickbook/
    REV HEAD
  )
