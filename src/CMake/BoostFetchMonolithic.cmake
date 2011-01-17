
# all modules that are not yet modularized are fetched from this mirror
set(boost_root_url http://sourceforge.net/projects/boost/files/boost/1.45.0/boost_1_45_0.tar.gz/download)
set(boost_root_md5_sum 739792c98fafb95e7a6b5da23a30062c)

set(boost_root_tgz ${Boost_BINARY_DIR}/downloads/boost_root.tgz)
set(boost_root_md5 ${Boost_BINARY_DIR}/downloads/boost_root.md5)

if(EXISTS ${boost_root_md5})
  file(READ ${boost_root_md5} boost_root_old_md5_sum)
  if("${boost_root_md5_sum}" MATCHES "${boost_root_old_md5_sum}")
    set(boost_root_ok ON)
  endif()
endif()
  
if(NOT boost_root_ok)
  message(STATUS "Downloading ${boost_root_url}")
  file(DOWNLOAD ${boost_root_url} ${boost_root_tgz}
    EXPECTED_MD5 ${boost_root_md5_sum} SHOW_PROGRESS)
  execute_process(COMMAND ${CMAKE_COMMAND} -E tar xzf ${boost_root_tgz}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    RESULT_VARIABLE extract_result
    )
  if(extract_result EQUAL 0)
    file(WRITE ${boost_root_md5} "${boost_root_md5_sum}")
  endif()
endif()

function(boost_get_module_boost_root name)
  set(module_dir "${BOOST_MODULES_DIR}/${name}")
  set(boost_root_dir "${CMAKE_CURRENT_BINARY_DIR}/boost_1_45_0")

  if(BOOST_${name}_TOOL)
    set(srcroot "${boost_root_dir}/tools")
  else()
    set(srcroot "${boost_root_dir}/libs")
  endif()

  file(COPY "${srcroot}/${name}" DESTINATION "${BOOST_MODULES_DIR}")

  foreach(header ${ARGN})
    string(REGEX MATCH "(.*)[/\\]" dir "${header}")
    file(COPY "${boost_root_dir}/${header}" DESTINATION "${module_dir}/${dir}")
  endforeach(header)
endfunction(boost_get_module_boost_root)
