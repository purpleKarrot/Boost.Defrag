# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

find_package(PythonLibs REQUIRED)
include_directories(${PYTHON_INCLUDE_DIRS})

boost_add_library(${boost_mpi_name}_python
  SOURCES
    serialize.cpp
  LINK_BOOST_LIBRARIES
    ${boost_mpi_name}
    python
  LINK_LIBRARIES
    ${MPI_LIBRARIES}
  )

boost_add_python_extension(mpi
  SOURCES
    collectives.cpp
    py_communicator.cpp
    datatypes.cpp
    documentation.cpp
    py_environment.cpp
    py_nonblocking.cpp
    py_exception.cpp
    module.cpp
    py_request.cpp
    skeleton_and_content.cpp
    status.cpp
    py_timer.cpp
  LINK_BOOST_LIBRARIES
    python
    ${boost_mpi_name}_python
    ${boost_mpi_name}
  LINK_LIBRARIES
    ${MPI_LIBRARIES}
  )
