# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

include(BoostDocs)

# Accumulators docs are dependent upon
# latex dvips and ps being in your PATH.
# This is true for most Unix installs, but
# not on Win32, where you will need to install
# MkTex and Ghostscript and add these tools
# to your path.

#find gs gswin32c

# Use Doxygen to emit a tagfile with the definition of depends_on<>. That
# tagfile will be used by Doxygen below when generating the Statistics Library
# Reference. This is all so that the Doxygen-generated documentation for the
# features shows the dependency relationships between them.

set(accumulators_tagfile ${CMAKE_CURRENT_BINARY_DIR}/accumulators.tag)

boost_doxygen(tagfile
  INPUT
    ../boost/accumulators/framework/depends_on.hpp
    ../boost/accumulators/framework/extractor.hpp
  OUTPUT
    ${accumulators_tagfile}
  PARAMETERS
    "GENERATE_HTML = NO"
    "GENERATE_LATEX = NO"
    "GENERATE_XML = NO"
    "GENERATE_TAGFILE = accumulators.tag"
    "MACRO_EXPANSION = YES"
    "EXPAND_ONLY_PREDEF = YES"
    "PREDEFINED = \"BOOST_ACCUMULATORS_DOXYGEN_INVOKED=1\" \\
      \"BOOST_PP_REPEAT_FROM_TO(a,b,c,d)=\" \\
      \"BOOST_PP_ENUM_PARAMS(a,b)=b ## 1, b ## 2, ...\""
  #<dependency>latex.check
  #<dependency>dvips.check
  #<dependency>gs.check
  )

file(GLOB accdoc_headers
  "../boost/accumulators/accumulators*.hpp"
  "../boost/accumulators/framework/*.hpp"
  "../boost/accumulators/framework/parameters/*.hpp"
  "../boost/accumulators/framework/accumulators/*.hpp"
  )

boost_add_reference(accdoc ${accdoc_headers}
  DOXYFILE acc.doxyfile
  TITLE "Accumulators Framework Reference"
  #<dependency>latex.check
  #<dependency>dvips.check
  #<dependency>gs.check
  )

file(GLOB statsdoc_headers
  "../boost/accumulators/statistics*.hpp"
  "../boost/accumulators/statistics/*.hpp"
  "../boost/accumulators/statistics/variates/*.hpp"
  )

# Generate the HTML form of the stats documentation, as this
# causes Doxygen to generate .png images for the LaTeX formulas
# embedded in the doc comments.

set(statsdoc_html_dir ${CMAKE_CURRENT_BINARY_DIR}/statsdoc-html)
set(images_dir ${CMAKE_CURRENT_BINARY_DIR}/html/images)

set(copy_forms_cmake ${CMAKE_CURRENT_BINARY_DIR}/copy_forms.cmake)
file(WRITE ${copy_forms_cmake}
  "file(GLOB images \${SRCDIR}/form_*.png)\n"
  "file(COPY \${images} DESTINATION \${DSTDIR})\n"
  )

boost_add_reference(statsdoc ${statsdoc_headers}
  DOXYFILE acc.doxyfile
  DOXYGEN_PARAMETERS
    "TAGFILES = accumulators.tag"
    "GENERATE_HTML = YES"
    "HTML_OUTPUT=${statsdoc_html_dir}"
  #<xsl:param>boost.doxygen.formuladir=images/accumulators/
  TITLE "Statistics Library Reference"
  #<dependency>tagfile
  #<dependency>statsdoclatex.tag
  #<dependency>latex.check
  #<dependency>dvips.check
  #<dependency>gs.check
  DEPENDS
    accumulators.tag
  )

add_custom_command(OUTPUT formulas.copied
  COMMAND ${CMAKE_COMMAND}
          -DSRCDIR="${statsdoc_html_dir}"
          -DDSTDIR="${images_dir}"
          -P ${copy_forms_cmake}
  COMMAND ${CMAKE_COMMAND} -E touch formulas.copied
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/statsdoc-xml/index.xml
  )

file(GLOB opdoc_headers
  "../boost/accumulators/numeric/functional.hpp"
  "../boost/accumulators/numeric/functional/*.hpp"
  )

boost_add_reference(opdoc ${opdoc_headers}
  DOXYFILE op.doxyfile
  TITLE "Numeric Operators Library Reference"
  #<dependency>latex.check
  #<dependency>dvips.check
  #<dependency>gs.check
  )

boost_documentation(accumulators.qbk
  #DEPENDS
  accdoc.xml
  statsdoc.xml
  opdoc.xml
  formulas.copied
  #<xsl:param>boost.max.id.length=1024
  #<xsl:param>toc.max.depth=4
  #<xsl:param>toc.section.depth=4
  #<xsl:param>chunk.section.depth=2
  )
