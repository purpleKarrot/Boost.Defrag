
include(BoostFetchDownload)

# all modules that are not yet modularized are fetched from this mirror
boost_fetch_download(monolithic ${CMAKE_BINARY_DIR}
  URL http://sourceforge.net/projects/boost/files/boost/1.45.0/boost_1_45_0.tar.gz/download
  MD5 739792c98fafb95e7a6b5da23a30062c
  )

function(boost_fetch_monolithic name destination)
  set(monolithic_dir "${CMAKE_BINARY_DIR}/monolithic")
  
  if(BOOST_${name}_TOOL)
    set(srcroot "${monolithic_dir}/tools")
  else()
    set(srcroot "${monolithic_dir}/libs")
  endif()

  file(COPY "${srcroot}/${name}" DESTINATION "${destination}")

  foreach(header ${ARGN})
    string(REGEX MATCH "(.*)[/\\]" dir "${header}")
    file(COPY "${monolithic_dir}/${header}" DESTINATION "${destination}/${name}/${dir}")
  endforeach(header)
endfunction(boost_fetch_monolithic)
