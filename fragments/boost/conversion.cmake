# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_module(conversion
  COPY_FROM_PRISTINE_BOOST
 #    TODO: which headers belong to conversion?
    boost/cast.hpp
    boost/lexical_cast.hpp
  )
