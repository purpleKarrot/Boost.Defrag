# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_module(utility
  COPY_FROM_BOOST_ROOT
    boost/utility
    boost/assert.hpp
    boost/call_traits.hpp
    boost/checked_delete.hpp
    boost/compressed_pair.hpp
    boost/current_function.hpp
    boost/operators.hpp
    boost/throw_exception.hpp
    boost/utility.hpp
    boost/cstdlib.hpp
    boost/next_prior.hpp
    boost/noncopyable.hpp
    boost/swap.hpp
    boost/shared_container_iterator.hpp
    
    # TODO: not sure about these headers
    boost/type.hpp
    boost/none.hpp
    boost/none_t.hpp
    boost/ref.hpp
    boost/memory_order.hpp
    boost/implicit_cast.hpp
    boost/aligned_storage.hpp
    boost/function_equal.hpp
    boost/get_pointer.hpp
    boost/is_placeholder.hpp
  )
