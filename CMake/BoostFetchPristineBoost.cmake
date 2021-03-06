
set(PRISTINE_BOOST "$ENV{PRISTINE_BOOST}")

# all modules that are not yet modularized are fetched from this mirror
if(NOT EXISTS "${PRISTINE_BOOST}/LICENSE_1_0.txt")
  include(BoostFetchDownload)
  boost_fetch_download(pristine_boost ${CMAKE_BINARY_DIR}
    URL http://sourceforge.net/projects/boost/files/boost/1.46.1/boost_1_46_1.tar.bz2/download
    MD5 7375679575f4c8db605d426fc721d506
    )
  set(PRISTINE_BOOST "${CMAKE_BINARY_DIR}/pristine_boost")
endif()

function(boost_fetch_pristine_boost name destination)
  foreach(component libs tools)
    set(dir "${PRISTINE_BOOST}/${component}/${name}")
    if(EXISTS "${dir}")
      file(COPY "${dir}" DESTINATION "${destination}")
    endif(EXISTS "${dir}")
  endforeach(component)

  foreach(header ${ARGN})
    string(REGEX MATCH "(.*)[/\\]" dir "${header}")
    file(COPY "${PRISTINE_BOOST}/${header}" DESTINATION "${destination}/${name}/${dir}")
  endforeach(header)
endfunction(boost_fetch_pristine_boost)
