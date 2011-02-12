
function(boost_fetch_download name destination)
  cmake_parse_arguments(THIS "" "URL;MD5" "" ${ARGN})

  set(archive ${CMAKE_BINARY_DIR}/downloads/${name}.tgz)
  set(tempdir ${CMAKE_BINARY_DIR}/${name}-tmp)
  set(destdir ${destination}/${name})

  if(THIS_MD5)
    set(md5_args EXPECTED_MD5 ${THIS_MD5})
  else()
    set(md5_args)
  endif()

  # Download file
  message(STATUS "${name}: downloading from: '${THIS_URL}'")
  file(DOWNLOAD ${THIS_URL} ${archive} SHOW_PROGRESS ${md5_args}
    STATUS status)

  list(GET status 0 status_code)
  list(GET status 1 status_string)

  if(NOT status_code EQUAL 0)
    message(FATAL_ERROR "downloading '${remote}' failed: '${status_string}'")
  endif()

  # Extract it
  file(MAKE_DIRECTORY "${tempdir}")
  execute_process(COMMAND ${CMAKE_COMMAND} -E tar xfz ${archive}
    WORKING_DIRECTORY ${tempdir}
    RESULT_VARIABLE rv)

  if(NOT rv EQUAL 0)
    file(REMOVE_RECURSE "${tempdir}")
    message(FATAL_ERROR "error: extract of '${archive}' failed")
  endif()

  # Analyze what came out of the tar file
  file(GLOB contents "${tempdir}/*")
  list(LENGTH contents n)
  if(NOT n EQUAL 1 OR NOT IS_DIRECTORY "${contents}")
    set(contents "${tempdir}")
  endif()

  # Move "the one" directory to the final directory
  file(REMOVE_RECURSE "${destdir}")
  get_filename_component(contents "${contents}" ABSOLUTE)
  file(RENAME "${contents}" "${destdir}")

  # Clean up
  file(REMOVE_RECURSE "${tempdir}")
endfunction(boost_fetch_download)
