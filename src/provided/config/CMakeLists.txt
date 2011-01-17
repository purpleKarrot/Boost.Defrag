# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

boost_project(config
  AUTHORS
    "John Maddock <john -at- johnmaddock.co.uk>"
  DESCRIPTION
    "Helps Boost library developers adapt to compiler idiosyncrasies; not intended for library users."
  )

boost_documentation(doc/config.qbk
  doc/configuring_boost.qbk
  doc/macro_reference.qbk
  doc/guidelines.qbk
  doc/rationale.qbk
  doc/acknowledgements.qbk
  )
