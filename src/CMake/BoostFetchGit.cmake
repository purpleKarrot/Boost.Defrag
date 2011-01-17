
find_package(Git REQUIRED)

function(boost_fetch_git name)
  cmake_parse_arguments(GIT "" "URL;TAG" "" ${ARGN})
  set(module_dir "${BOOST_MODULES_DIR}/${name}")

# # update
# execute_process(
#   COMMAND ${GIT_EXECUTABLE} fetch
#   COMMAND ${GIT_EXECUTABLE} checkout ${GIT_URL}
#   COMMAND ${GIT_EXECUTABLE} submodule update --recursive
#   )

  file(REMOVE_RECURSE "${module_dir}")

  message(STATUS "${name}: cloning git repository: '${GIT_URL}'")
  execute_process(
    COMMAND "${git_EXECUTABLE}" clone "${GIT_URL}" "${name}"
    WORKING_DIRECTORY "${BOOST_MODULES_DIR}"
    RESULT_VARIABLE error_code
    )
  if(error_code)
    message(FATAL_ERROR "Failed to clone repository: '${GIT_URL}'")
  endif()

  execute_process(
    COMMAND "${git_EXECUTABLE}" checkout "${GIT_TAG}"
    COMMAND "${git_EXECUTABLE}" submodule init
    COMMAND "${git_EXECUTABLE}" submodule update --recursive
    WORKING_DIRECTORY "${module_dir}"
    RESULT_VARIABLE error_code
    )
  if(error_code)
    message(FATAL_ERROR "Failed to checkout tag: '${GIT_TAG}'")
  endif()

endfunction(boost_fetch_git)
