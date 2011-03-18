# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

cmake_minimum_required(VERSION 2.8)

find_package(Boost 1.45 NO_MODULE)
include("${Boost_DEV_FILE}")

boost_project(BoostBook TOOL
  AUTHORS
    "Douglas Gregor <doug.gregor -at- gmail.com>"
  DESCRIPTION
    "The BoostBook documentation format is an extension of DocBook,"
    "an SGML- or XML-based format for describing documentation."
  DEB_DEPENDS
    docbook-xml
    docbook-xsl
  )

add_subdirectory(doc)

if(WIN32)
  set(BOOSTBOOK_DIR "boostbook")
else(WIN32)
  set(BOOSTBOOK_DIR "share/boost/boostbook")
endif(WIN32)

install(DIRECTORY dtd xsl
  DESTINATION "${BOOSTBOOK_DIR}"
  COMPONENT "${BOOST_RUNTIME_COMPONENT}"
  )

install(FILES catalog.xml
  DESTINATION "${BOOSTBOOK_DIR}"
  COMPONENT "${BOOST_RUNTIME_COMPONENT}"
  )

file(WRITE ${BOOST_EXPORT_FILE}
  "set(BOOSTBOOK_CATALOG \"\${CMAKE_CURRENT_LIST_DIR}/../boostbook/catalog.xml\")\n"
  "set(BOOSTBOOK_XSL_DIR \"\${CMAKE_CURRENT_LIST_DIR}/../boostbook/xsl\")\n"
  )

#if(CMAKE_HOST_WIN32)
#  boost_fetch_download(docbook_xml "${CMAKE_BINARY_DIR}"
#    URL http://www.oasis-open.org/docbook/xml/4.2/docbook-xml-4.2.zip
#    MD5 73fe50dfe74ca631c1602f558ed8961f
#    )
#  boost_fetch_download(docbook_xsl "${CMAKE_BINARY_DIR}"
#    URL http://sourceforge.net/projects/docbook/files/docbook-xsl/1.75.2/docbook-xsl-1.75.2.tar.bz2/download
#    MD5 0c76a58a8e6cb5ab49f819e79917308f
#    )
#  set(DOCBOOK_DTD_DIR "${CMAKE_BINARY_DIR}/docbook_xml" CACHE FILEPATH "" FORCE)
#  set(DOCBOOK_XSL_DIR "${CMAKE_BINARY_DIR}/docbook_xsl" CACHE FILEPATH "" FORCE)
#endif(CMAKE_HOST_WIN32)

## Find the DocBook DTD (version 4.2)
#find_path(DOCBOOK_DTD_DIR docbookx.dtd PATHS
#  "/usr/share/xml/docbook/schema/dtd/4.2"
#  "/opt/local/share/xml/docbook/4.2"
#  )
#
## Find the DocBook XSL stylesheets
#find_path(DOCBOOK_XSL_DIR html/html.xsl PATHS
#  "/usr/share/xml/docbook/stylesheet/nwalsh"
#  "/opt/local/share/xsl/docbook-xsl"
#  )

# "http://www.oasis-open.org/docbook/xml/4.2/"
# "http://docbook.sourceforge.net/release/xsl/current/"
