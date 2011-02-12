
# cvs -d:pserver:anonymous@asio.cvs.sourceforge.net:/cvsroot/asio login
# cvs -z3 -d:pserver:anonymous@asio.cvs.sourceforge.net:/cvsroot/asio co -P modulename

find_package(CVS REQUIRED)

function(boost_get_module_cvs name url rev)
  message(STATUS "TODO: cvs checkout module")
endfunction(boost_get_module_cvs)

# download
set(cmd ${CVS_EXECUTABLE} -d ${url} -q co ${cvs_tag} -d ${src_name} ${cvs_module})

# update
set(cmd ${CVS_EXECUTABLE} -d ${url} -q up -dP ${cvs_tag})
