# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(Graph
  AUTHORS
    "Jeremy Siek <jeremy.siek -at- gmail.com>"
    "Lie-Quan Lee"
    "Andrew Lumsdaine"
    "Douglas Gregor <doug.gregor -at- gmail.com>"
  DESCRIPTION
    "The BGL graph interface and graph components are generic,"
    "in the same sense as the the Standard Template Library (STL)."
  DEPENDS
    property_map
    tuple
    multi_index
    any # because of the dependency on boost/property_map/dynamic_property_map.hpp
    random
    parameter
    regex
    mpi # optional
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})

boost_add_library(graph
  SOURCES
    src/read_graphviz_new.cpp
    src/graphml.cpp
  LINK_BOOST_LIBRARIES
    regex
  # <link>shared:<define>BOOST_GRAPH_DYN_LINK=1
  # <toolset>msvc-7.1:<cxxflags>-GR-
  )
