
function(boost_fetch_git name destination)
  cmake_parse_arguments(GIT "" "URL;TAG" "" ${ARGN})
  if(NOT GIT_TAG)
    set(GIT_TAG "master")
  endif(NOT GIT_TAG)

  find_package(Git REQUIRED)

  if(EXISTS "${destination}/${name}/.git")
    execute_process(
      COMMAND "${GIT_EXECUTABLE}" --quiet ${GIT_URL}
      WORKING_DIRECTORY "${destination}/${name}"
      RESULT_VARIABLE error_code
      )
  else()
    file(REMOVE_RECURSE "${destination}/${name}")
    execute_process(
      COMMAND "${GIT_EXECUTABLE}" clone --quiet ${GIT_URL} ${name}
      WORKING_DIRECTORY "${destination}"
      RESULT_VARIABLE error_code
      )
  endif()
  if(error_code)
    message(FATAL_ERROR "Failed to fetch from repository: '${GIT_URL}'")
  endif()

  execute_process(
    COMMAND "${GIT_EXECUTABLE}" checkout --quiet ${GIT_TAG}
    COMMAND "${GIT_EXECUTABLE}" submodule init
    COMMAND "${GIT_EXECUTABLE}" submodule update --recursive
    WORKING_DIRECTORY "${destination}/${name}"
    RESULT_VARIABLE error_code
    )
  if(error_code)
    message(FATAL_ERROR "Failed to checkout tag: '${GIT_TAG}'")
  endif()

endfunction(boost_fetch_git)
