
include(BoostFetchDownload)

# all modules that are not yet modularized are fetched from this mirror
boost_fetch_download(pristine_boost ${CMAKE_BINARY_DIR}
  URL http://sourceforge.net/projects/boost/files/boost/1.45.0/boost_1_45_0.tar.gz/download
  MD5 739792c98fafb95e7a6b5da23a30062c
  )

function(boost_fetch_pristine_boost name destination)
  set(pristine_boost_dir "${CMAKE_BINARY_DIR}/pristine_boost")
  
  if(BOOST_${name}_TOOL)
    set(srcroot "${pristine_boost_dir}/tools")
  else()
    set(srcroot "${pristine_boost_dir}/libs")
  endif()

  file(COPY "${srcroot}/${name}" DESTINATION "${destination}")

  foreach(header ${ARGN})
    string(REGEX MATCH "(.*)[/\\]" dir "${header}")
    file(COPY "${pristine_boost_dir}/${header}" DESTINATION "${destination}/${name}/${dir}")
  endforeach(header)
endfunction(boost_fetch_pristine_boost)
