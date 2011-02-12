
function(boost_fetch_git name destination)
  cmake_parse_arguments(GIT "" "URL;TAG" "" ${ARGN})

  find_package(Git REQUIRED)

#  if(EXISTS "${destination}/${name}/.git")
#    execute_process(
#      COMMAND ${GIT_EXECUTABLE} fetch
#      COMMAND ${GIT_EXECUTABLE} checkout ${GIT_URL}
#      COMMAND ${GIT_EXECUTABLE} submodule update --recursive
#      )
#  else()

  file(REMOVE_RECURSE "${destination}/${name}")
  message(STATUS "${name}: cloning git repository: '${GIT_URL}'")
  execute_process(
    COMMAND ${GIT_EXECUTABLE} clone ${GIT_URL} ${name}
    WORKING_DIRECTORY "${destination}"
    RESULT_VARIABLE error_code
    )
  if(error_code)
    message(FATAL_ERROR "Failed to clone repository: '${GIT_URL}'")
  endif()

  execute_process(
    COMMAND "${GIT_EXECUTABLE}" checkout "${GIT_TAG}"
    COMMAND "${GIT_EXECUTABLE}" submodule init
    COMMAND "${GIT_EXECUTABLE}" submodule update --recursive
    WORKING_DIRECTORY "${destination}/${name}"
    RESULT_VARIABLE error_code
    )
  if(error_code)
    message(FATAL_ERROR "Failed to checkout tag: '${GIT_TAG}'")
  endif()

endfunction(boost_fetch_git)
