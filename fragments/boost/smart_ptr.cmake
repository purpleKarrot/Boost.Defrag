# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_module(smart_ptr
  COPY_FROM_PRISTINE_BOOST
    boost/smart_ptr
    boost/smart_ptr.hpp
    boost/make_shared.hpp
    boost/enable_shared_from_this.hpp
    boost/pointer_cast.hpp
    boost/scoped_array.hpp
    boost/scoped_ptr.hpp
    boost/shared_array.hpp
    boost/shared_ptr.hpp
    boost/weak_ptr.hpp
    boost/pointer_to_other.hpp
  )
