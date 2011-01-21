# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(MPI
  DEPENDS
    graph
  )

file(GLOB_RECURSE headers ${CMAKE_CURRENT_SOURCE_DIR}/boost/*.?pp)
boost_add_headers("" ${headers})

find_package(MPI)

if(NOT MPI_FOUND)
  return()
endif()

include_directories(${MPI_INCLUDE_PATH})

find_package(PythonLibs REQUIRED)
include_directories(${PYTHON_INCLUDE_DIRS})

boost_add_library(mpi
  SOURCES
    src/broadcast.cpp
    src/communicator.cpp
    src/computation_tree.cpp
    src/content_oarchive.cpp
    src/environment.cpp
    src/exception.cpp
    src/graph_communicator.cpp
    src/group.cpp
    src/intercommunicator.cpp
    src/mpi_datatype_cache.cpp
    src/mpi_datatype_oarchive.cpp
    src/packed_iarchive.cpp
    src/packed_oarchive.cpp
    src/packed_skeleton_iarchive.cpp
    src/packed_skeleton_oarchive.cpp
    src/point_to_point.cpp
    src/request.cpp
    src/text_skeleton_oarchive.cpp
    src/timer.cpp
  LINK_BOOST_LIBRARIES
    serialization
  LINK_LIBRARIES
    ${MPI_LIBRARIES}
  # <define>BOOST_MPI_SOURCE=1
  # <link>shared:<define>BOOST_MPI_DYN_LINK=1
  )

boost_add_library(mpi_python
  SOURCES
    src/python/serialize.cpp
  LINK_BOOST_LIBRARIES
    mpi
    python
  LINK_LIBRARIES
    ${MPI_LIBRARIES}
  # <link>shared:<define>BOOST_MPI_DYN_LINK=1
  # <link>shared:<define>BOOST_MPI_PYTHON_DYN_LINK=1
  # <link>shared:<define>BOOST_PYTHON_DYN_LINK=1        
  # <define>BOOST_MPI_PYTHON_SOURCE=1
  )

boost_add_python_extension(mpi
  SOURCES
    src/python/collectives.cpp
    src/python/py_communicator.cpp
    src/python/datatypes.cpp
    src/python/documentation.cpp
    src/python/py_environment.cpp
    src/python/py_nonblocking.cpp
    src/python/py_exception.cpp
    src/python/module.cpp
    src/python/py_request.cpp
    src/python/skeleton_and_content.cpp
    src/python/status.cpp
    src/python/py_timer.cpp
  LINK_BOOST_LIBRARIES
    python
    mpi_python
    mpi
  LINK_LIBRARIES
    ${MPI_LIBRARIES}
  # <link>shared:<define>BOOST_MPI_DYN_LINK=1    
  # <link>shared:<define>BOOST_MPI_PYTHON_DYN_LINK=1        
  # <link>shared:<define>BOOST_PYTHON_DYN_LINK=1    
  # <link>shared <runtime-link>shared
  )
