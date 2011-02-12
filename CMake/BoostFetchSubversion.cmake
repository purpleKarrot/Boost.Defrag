
function(boost_get_module_svn name url rev)
  message(STATUS "TODO: svn checkout module")
endfunction(boost_get_module_svn)

function(boost_get_module_svn2 name url rev)

  find_package(Subversion REQUIRED)
  
  set(svn_user_pw_args "")
  if(svn_username)
    set(svn_user_pw_args ${svn_user_pw_args} "--username=${svn_username}")
  endif()
  if(svn_password)
    set(svn_user_pw_args ${svn_user_pw_args} "--password=${svn_password}")
  endif()

  set(cmd ${Subversion_SVN_EXECUTABLE} co ${url} ${rev}
    ${svn_user_pw_args} ${name})

endfunction(boost_get_module_svn2)

# update
set(cmd ${Subversion_SVN_EXECUTABLE} up ${rev} ${svn_user_pw_args})
