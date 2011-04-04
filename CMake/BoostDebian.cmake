################################################################################
# Copyright (C) 2010-2011 Daniel Pfeifer <daniel@pfeifer-mail.de>              #
#                                                                              #
# Distributed under the Boost Software License, Version 1.0.                   #
# See accompanying file LICENSE_1_0.txt or copy at                             #
#   http://www.boost.org/LICENSE_1_0.txt                                       #
################################################################################

# DEBIAN/control
# debian policy enforce lower case for package name
# Package: (mandatory)
IF(NOT CPACK_DEBIAN_PACKAGE_NAME)
  STRING(TOLOWER "${CPACK_PACKAGE_NAME}" CPACK_DEBIAN_PACKAGE_NAME)
ENDIF(NOT CPACK_DEBIAN_PACKAGE_NAME)

# Section: (recommended)
IF(NOT CPACK_DEBIAN_PACKAGE_SECTION)
  SET(CPACK_DEBIAN_PACKAGE_SECTION "devel")
ENDIF(NOT CPACK_DEBIAN_PACKAGE_SECTION)

# Priority: (recommended)
IF(NOT CPACK_DEBIAN_PACKAGE_PRIORITY)
  SET(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
ENDIF(NOT CPACK_DEBIAN_PACKAGE_PRIORITY)

file(STRINGS "${CPACK_PACKAGE_DESCRIPTION_FILE}" DESC_LINES)
foreach(LINE ${DESC_LINES})
  set(DEB_LONG_DESCRIPTION "${DEB_LONG_DESCRIPTION} ${LINE}\n")
endforeach(LINE)

set(debian_dir "${BOOST_MONOLITHIC_DIR}/debian")

################################################################################
# debian/control
set(debian_control ${debian_dir}/control)
list(APPEND CPACK_DEBIAN_BUILD_DEPENDS cmake)
list(REMOVE_DUPLICATES CPACK_DEBIAN_BUILD_DEPENDS)
list(SORT CPACK_DEBIAN_BUILD_DEPENDS)
string(REPLACE ";" ", " build_depends "${CPACK_DEBIAN_BUILD_DEPENDS}")
file(WRITE ${debian_control}
  "Source: ${CPACK_DEBIAN_PACKAGE_NAME}\n"
  "Section: ${CPACK_DEBIAN_PACKAGE_SECTION}\n"
  "Priority: ${CPACK_DEBIAN_PACKAGE_PRIORITY}\n"
  "Maintainer: ${CPACK_PACKAGE_CONTACT}\n"
  "Build-Depends: ${build_depends}\n"
  "Standards-Version: 3.9.1\n"
  "Homepage: ${CPACK_PACKAGE_VENDOR}\n"
# "\n"
# "Package: ${CPACK_DEBIAN_PACKAGE_NAME}\n"
# "Architecture: any\n"
# "Depends: ${CPACK_DEBIAN_PACKAGE_DEPENDS}\n"
# "Description: ${CPACK_PACKAGE_DESCRIPTION_SUMMARY}\n"
# "${DEB_LONG_DESCRIPTION}"
  )

foreach(component ${CPACK_COMPONENTS_ALL})
  string(TOUPPER "${component}" COMPONENT)
  set(display_name "${CPACK_COMPONENT_${COMPONENT}_DISPLAY_NAME}")
  set(description "${CPACK_COMPONENT_${COMPONENT}_DESCRIPTION}")

  set(deb_depends ${CPACK_COMPONENT_${COMPONENT}_DEBIAN_DEPENDS})
  foreach(dep ${CPACK_COMPONENT_${COMPONENT}_DEPENDS})
    string(TOUPPER "${dep}" DEP)
    list(APPEND deb_depends ${CPACK_COMPONENT_${DEP}_DEB_PACKAGE})
  endforeach(dep)
  string(REPLACE ";" ", " deb_depends "${deb_depends}")

  file(APPEND ${debian_control}
    "\n"
    "Package: ${CPACK_COMPONENT_${COMPONENT}_DEB_PACKAGE}\n"
    "Architecture: any\n"
    "Depends: ${deb_depends}\n"
    "Description: Boost.${display_name}\n"
    "${DEB_LONG_DESCRIPTION}"
    " .\n"
    " ${description}\n"
    )
endforeach(component)

################################################################################
# debian/copyright
set(debian_copyright ${debian_dir}/copyright)
configure_file(${CPACK_RESOURCE_FILE_LICENSE} ${debian_copyright} COPYONLY)

################################################################################
# debian/rules
set(debian_rules ${debian_dir}/rules)
file(WRITE ${debian_rules}
  "#!/usr/bin/make -f\n"
  "\n"
  "DEBUG = debug_build\n"
  "RELEASE = release_build\n"
  "CFLAGS =\n"
  "CPPFLAGS =\n"
  "CXXFLAGS =\n"
  "FFLAGS =\n"
  "LDFLAGS =\n"
  "\n"
  "build:\n"
  "	cmake -E make_directory $(DEBUG)\n"
  "	cmake -E make_directory $(RELEASE)\n"
  "	cd $(DEBUG); cmake -DCMAKE_BUILD_TYPE=Debug -DBOOST_DEBIAN_PACKAGES=TRUE ..\n"
  "	cd $(RELEASE); cmake -DCMAKE_BUILD_TYPE=Release -DBOOST_DEBIAN_PACKAGES=TRUE ..\n"
  "	$(MAKE) --no-print-directory -C $(DEBUG) preinstall\n"
  "	$(MAKE) --no-print-directory -C $(RELEASE) preinstall\n"
  "	touch build\n"
  "\n"
  "binary: binary-indep binary-arch\n"
  "\n"
  "binary-indep: build\n"
  "	$(MAKE) --no-print-directory -C $(RELEASE) documentation\n"
  )

foreach(component ${CPACK_COMPONENTS_ALL})
  string(TOUPPER "${component}" COMPONENT)
  if(CPACK_COMPONENT_${COMPONENT}_BINARY_INDEP)
    set(path debian/${component})
    file(APPEND ${debian_rules}
      "	cd $(DEBUG); cmake -DCOMPONENT=${component} -DCMAKE_INSTALL_PREFIX=../${path}/usr -P cmake_install.cmake\n"
      "	cd $(RELEASE); cmake -DCOMPONENT=${component} -DCMAKE_INSTALL_PREFIX=../${path}/usr -P cmake_install.cmake\n"
      "	cmake -E make_directory ${path}/DEBIAN\n"
      "	dpkg-gencontrol -p${CPACK_COMPONENT_${COMPONENT}_DEB_PACKAGE} -P${path}\n"
      "	dpkg --build ${path} ..\n"
      )
  endif(CPACK_COMPONENT_${COMPONENT}_BINARY_INDEP)
endforeach(component)

file(APPEND ${debian_rules}
  "\n"
  "binary-arch: build\n"
  )

foreach(component ${CPACK_COMPONENTS_ALL})
  string(TOUPPER "${component}" COMPONENT)
  if(NOT CPACK_COMPONENT_${COMPONENT}_BINARY_INDEP)
    set(path debian/${component})
    file(APPEND ${debian_rules}
      "	cd $(DEBUG); cmake -DCOMPONENT=${component} -DCMAKE_INSTALL_PREFIX=../${path}/usr -P cmake_install.cmake\n"
      "	cd $(RELEASE); cmake -DCOMPONENT=${component} -DCMAKE_INSTALL_PREFIX=../${path}/usr -P cmake_install.cmake\n"
      "	cmake -E make_directory ${path}/DEBIAN\n"
      "	dpkg-gencontrol -p${CPACK_COMPONENT_${COMPONENT}_DEB_PACKAGE} -P${path}\n"
      "	dpkg --build ${path} ..\n"
      )
  endif(NOT CPACK_COMPONENT_${COMPONENT}_BINARY_INDEP)
endforeach(component)

file(APPEND ${debian_rules}
  "\n"
  "clean:\n"
  "	rm -f build\n"
  "	rm -rf $(DEBUG)\n"
  "	rm -rf $(RELEASE)\n"
  "\n"
  ".PHONY: binary binary-arch binary-indep clean\n"
  )

execute_process(COMMAND chmod +x ${debian_rules})

################################################################################
# debian/compat
file(WRITE ${debian_dir}/compat "7")

################################################################################
# debian/source/format
file(WRITE ${debian_dir}/source/format "3.0 (native)")

################################################################################
# debian/changelog
set(debian_changelog ${debian_dir}/changelog)
execute_process(COMMAND date -R OUTPUT_VARIABLE DATE_TIME)
#execute_process(COMMAND date +"%a, %d %b %Y %H:%M:%S %z" OUTPUT_VARIABLE DATE_TIME)
execute_process(COMMAND date +%y%m%d OUTPUT_VARIABLE suffix OUTPUT_STRIP_TRAILING_WHITESPACE)
file(WRITE ${debian_changelog}
  "${CPACK_DEBIAN_PACKAGE_NAME} (${Boost_VERSION}-${suffix}) natty; urgency=low\n\n"
  "  * Package built with CMake\n\n"
  " -- ${CPACK_PACKAGE_CONTACT}  ${DATE_TIME}"
  )

##############################################################################
# upload package to PPA

find_program(DPKG_BUILDPACKAGE dpkg-buildpackage)
find_program(DPUT dput)

if(NOT DPKG_BUILDPACKAGE OR NOT DPUT)
  return()
endif()

set(changes_file
  "${CPACK_DEBIAN_PACKAGE_NAME}_${Boost_VERSION}-${suffix}_source.changes"
  )

add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/${changes_file}
  COMMAND ${DPKG_BUILDPACKAGE} -S
  WORKING_DIRECTORY ${BOOST_MONOLITHIC_DIR}
  )

add_custom_target(deploy
  ${DPUT} "ppa:purplekarrot/ppa" ${changes_file}
  DEPENDS ${CMAKE_BINARY_DIR}/${changes_file}
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )
