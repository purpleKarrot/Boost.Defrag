# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(thread
  DEPENDS
    date_time
    bind
    optional
    range
  )

find_package(Threads REQUIRED)

if(CMAKE_USE_WIN32_THREADS_INIT)
  set(sources
    src/win32/thread.cpp
    src/win32/tss_dll.cpp
    src/win32/tss_pe.cpp
    )
else()
  set(sources
    src/pthread/thread.cpp
    src/pthread/once.cpp
    )
endif()

boost_add_library(thread
  SOURCES
    ${sources}
#  SHARED_DEFINITION
#    "BOOST_THREAD_BUILD_DLL=1" # "BOOST_THREAD_USE_DLL=1"
#  STATIC_DEFINITION
#    "BOOST_THREAD_BUILD_LIB=1" # "BOOST_THREAD_USE_LIB=1"
  LINK_LIBRARIES
    ${CMAKE_THREAD_LIBS_INIT}
  )
