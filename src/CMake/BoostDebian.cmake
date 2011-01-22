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

set(debian_dir ${BOOST_MONOLITHIC_ROOT}/debian)

################################################################################
# debian/control
set(debian_control ${debian_dir}/control)
file(WRITE ${debian_control}
  "Source: ${CPACK_DEBIAN_PACKAGE_NAME}\n"
  "Section: ${CPACK_DEBIAN_PACKAGE_SECTION}\n"
  "Priority: ${CPACK_DEBIAN_PACKAGE_PRIORITY}\n"
  "Maintainer: ${CPACK_PACKAGE_CONTACT}\n"
  "Build-Depends: "
  )

foreach(DEP ${CPACK_DEBIAN_BUILD_DEPENDS})
  file(APPEND ${debian_control} "${DEP}, ")
endforeach(DEP)  

file(APPEND ${debian_control} "cmake\n"
  "Standards-Version: 3.9.1\n"
  "Homepage: ${CPACK_PACKAGE_VENDOR}\n"
  "\n"
  "Package: ${CPACK_DEBIAN_PACKAGE_NAME}\n"
  "Architecture: any\n"
  "Depends: ${CPACK_DEBIAN_PACKAGE_DEPENDS}\n"
  "Description: ${CPACK_PACKAGE_DESCRIPTION_SUMMARY}\n"
  "${DEB_LONG_DESCRIPTION}"
  )

foreach(COMPONENT ${CPACK_COMPONENTS_ALL})
  string(TOUPPER ${COMPONENT} UPPER_COMPONENT)
  file(APPEND ${debian_control} "\n"
    "Package: ${CPACK_DEBIAN_PACKAGE_NAME}-${COMPONENT}\n"
    "Architecture: any\n"
    "Description: ${CPACK_PACKAGE_DESCRIPTION_SUMMARY}"
    ": ${CPACK_COMPONENT_${UPPER_COMPONENT}_DISPLAY_NAME}\n"
    "${DEB_LONG_DESCRIPTION}"
    " .\n"
    " ${CPACK_COMPONENT_${UPPER_COMPONENT}_DESCRIPTION}\n"
    )
endforeach(COMPONENT)

################################################################################
# debian/copyright
set(debian_copyright ${debian_dir}/copyright)
execute_process(COMMAND ${CMAKE_COMMAND} -E
  copy ${CPACK_RESOURCE_FILE_LICENSE} ${debian_copyright}
  )

################################################################################
# debian/rules
set(debian_rules ${debian_dir}/rules)
file(WRITE ${debian_rules}
  "#!/usr/bin/make -f\n"
  "\n"
  "BUILDDIR = build_dir\n"
  "\n"
  "build:\n"
  "	mkdir $(BUILDDIR)\n"
  "	cd $(BUILDDIR); cmake ..\n"
  "	make -C $(BUILDDIR) preinstall\n"
  "	touch build\n"
  "\n"
  "binary: binary-indep binary-arch\n"
  "\n"
  "binary-indep: build\n"
  "\n"
  "binary-arch: build\n"
  "	cd $(BUILDDIR); cmake -DCOMPONENT=Unspecified -DCMAKE_INSTALL_PREFIX=../debian/tmp/usr -P cmake_install.cmake\n"
  "	mkdir debian/tmp/DEBIAN\n"
  "	dpkg-gencontrol -p${CPACK_DEBIAN_PACKAGE_NAME}\n"
  "	dpkg --build debian/tmp ..\n"
  )

foreach(COMPONENT ${CPACK_COMPONENTS_ALL})
  set(PATH debian/tmp_${COMPONENT})
  set(PACKAGE ${CPACK_DEBIAN_PACKAGE_NAME}-${COMPONENT})
  file(APPEND ${debian_rules}
    "	cd $(BUILDDIR); cmake -DCOMPONENT=${COMPONENT} -DCMAKE_INSTALL_PREFIX=../${PATH}/usr -P cmake_install.cmake\n"
    "	mkdir ${PATH}/DEBIAN\n"
    "	dpkg-gencontrol -p${PACKAGE} -P${PATH}\n"
    "	dpkg --build ${PATH} ..\n"
    )
endforeach(COMPONENT)

file(APPEND ${debian_rules}
  "\n"
  "clean:\n"
  "	rm -f build\n"
  "	rm -rf $(BUILDDIR)\n"
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
execute_process(COMMAND date -R  OUTPUT_VARIABLE DATE_TIME)
file(WRITE ${debian_changelog}
  "${CPACK_DEBIAN_PACKAGE_NAME} (${BOOST_VERSION}) maverick; urgency=low\n\n"
  "  * Package built with CMake\n\n"
  " -- Daniel Pfeifer <daniel@pfeifer-mail.de>  ${DATE_TIME}"
  )