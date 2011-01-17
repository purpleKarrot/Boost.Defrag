
function(boost_get_module_download name)
  cmake_parse_arguments(THIS "" "URL;MD5" "" ${ARGN})

  set(module_dir ${BOOST_MODULES_DIR}/${name})
  set(module_tgz ${Boost_BINARY_DIR}/downloads/${name}.tgz)
  set(module_tmp ${Boost_BINARY_DIR}/${name}-tmp)

  if(THIS_MD5)
    set(md5_args EXPECTED_MD5 ${THIS_MD5})
  else()
    set(md5_args)
  endif()

  # Download file
  message(STATUS "${name}: downloading from: '${THIS_URL}'")
  file(DOWNLOAD ${THIS_URL} ${module_tgz} SHOW_PROGRESS ${md5_args}
    STATUS status)

  list(GET status 0 status_code)
  list(GET status 1 status_string)

  if(NOT status_code EQUAL 0)
    message(FATAL_ERROR "downloading '${remote}' failed: '${status_string}'")
  endif()

  # Extract it
  file(MAKE_DIRECTORY "${module_tmp}")
  execute_process(COMMAND ${CMAKE_COMMAND} -E tar xfz ${module_tgz}
    WORKING_DIRECTORY ${module_tmp}
    RESULT_VARIABLE rv)

  if(NOT rv EQUAL 0)
    file(REMOVE_RECURSE "${module_tmp}")
    message(FATAL_ERROR "error: extract of '${module_tgz}' failed")
  endif()

  # Analyze what came out of the tar file
  file(GLOB contents "${module_tmp}/*")
  list(LENGTH contents n)
  if(NOT n EQUAL 1 OR NOT IS_DIRECTORY "${contents}")
    set(contents "${module_tmp}")
  endif()

  # Move "the one" directory to the final directory
  file(REMOVE_RECURSE ${module_dir})
  get_filename_component(contents ${contents} ABSOLUTE)
  file(RENAME ${contents} ${module_dir})

  # Clean up
  file(REMOVE_RECURSE "${module_tmp}")
endfunction(boost_get_module_download)
