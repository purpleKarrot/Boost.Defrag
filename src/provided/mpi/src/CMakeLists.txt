# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

find_package(MPI REQUIRED)
include_directories(${MPI_INCLUDE_PATH})
set(boost_mpi_name "mpi")

boost_add_library(${boost_mpi_name}
  SOURCES
    broadcast.cpp
    communicator.cpp
    computation_tree.cpp
    content_oarchive.cpp
    environment.cpp
    exception.cpp
    graph_communicator.cpp
    group.cpp
    intercommunicator.cpp
    mpi_datatype_cache.cpp
    mpi_datatype_oarchive.cpp
    packed_iarchive.cpp
    packed_oarchive.cpp
    packed_skeleton_iarchive.cpp
    packed_skeleton_oarchive.cpp
    point_to_point.cpp
    request.cpp
    text_skeleton_oarchive.cpp
    timer.cpp
  LINK_BOOST_LIBRARIES
    serialization
  LINK_LIBRARIES
    ${MPI_LIBRARIES}
  )

add_subdirectory(python)
