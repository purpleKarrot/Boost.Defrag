# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Flyweight
  AUTHORS
    "Joaquín M López Muñoz <fixme -at- fixme.com>"
  DESCRIPTION
    "Flyweights are small-sized handle classes granting constant access to"
    "shared common data, thus allowing for the management of large amounts"
    "of entities within reasonable memory limits. Boost.Flyweight makes it"
    "easy to use this common programming idiom by providing the class template"
    "flyweight<T>, which acts as a drop-in replacement for const T."
  DEPENDS
    mpl
    parameter
    preprocessor
    interprocess
    type_traits
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers(${headers})
