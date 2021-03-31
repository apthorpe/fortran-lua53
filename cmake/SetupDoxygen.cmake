### Doxygen congfiguration
# Doxygen is recommended but not required

# Convert a CMake list into a string consisting of space-separated
# (possibly quoted) list elements suitable for inclusion in Doxyfile
# Note that dstr and clist take CMake variable names and the contents
# of the variable named dstr are modified by this function.
# That is, if L_DOXYGEN_LATEX_EXTRA_FILES is a variable containing a list
# of file names
#
#     to_doxylist(DOXYGEN_LATEX_EXTRA_FILES L_DOXYGEN_LATEX_EXTRA_FILES)
#
# will set DOXYGEN_LATEX_EXTRA_FILES to contain a string containing the
# filenames separated by spaces
function(to_doxylist dstr clist)
  set(tmpstr "")
  foreach(fn IN LISTS ${clist})
    set(wfn ${fn})
    string(FIND wfn " " EMBEDDED_SPACE)
    if(EMBEDDED_SPACE GREATER_EQUAL 0)
      # Quote if embedded space is found
      set(wfn "\"${fn}\"")
    endif()
    string(APPEND tmpstr "${wfn} ")
  endforeach()
  string(STRIP ${tmpstr} tmpstr)
  set(${dstr} ${tmpstr} PARENT_SCOPE)
endfunction()

# Build human-formatted date elements from timestamp values
# These are substituted into doxygen/doxygen_header.tex.in
string(TIMESTAMP DOCUMENT_YYYY "%Y" UTC)
string(TIMESTAMP DOCUMENT_MONTH "%B" UTC)
string(TIMESTAMP DOCUMENT_DD "%d" UTC)
string(REGEX REPLACE "^[ ]*0(.*)" "\\1" DOCUMENT_DAY "${DOCUMENT_DD}")

# message(STATUS "Documentation will be generated for ${DOCUMENT_MONTH} ${DOCUMENT_DAY}, ${DOCUMENT_YYYY}")

# Add a target to generate API documentation with Doxygen
set(FAKE_PDF_MANUAL "${CMAKE_CURRENT_SOURCE_DIR}/doxygen/Fortran_Lua53_Users_Guide_placeholder.pdf")
set(PDF_MANUAL "${CMAKE_CURRENT_BINARY_DIR}/Fortran_Lua53_Users_Guide.pdf")

# This should not be necessary - copy placeholder file which should be
# paved over if the real PDF file is generated
execute_process(COMMAND ${CMAKE_COMMAND} -E copy "${FAKE_PDF_MANUAL}" "${PDF_MANUAL}")

if(${DOXYGEN_FOUND})
  message(STATUS "Found Doxygen: setting up configuration files")

  if(${LATEX_FOUND})
    set(DOXYGEN_GENERATE_LATEX "YES")
    set(DOXYGEN_USE_PDFLATEX "YES")
    set(DOXYGEN_LATEX_CMD_NAME "${XELATEX_COMPILER}")
    set(DOXYGEN_LATEX_BATCHMODE "YES")
    set(DOXYGEN_PAPER_TYPE "letter")
    set(DOXYGEN_MAKEINDEX_CMD_NAME "${MAKEINDEX_COMPILER}")
    set(DOXYGEN_LATEX_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/doc/latex")
    set(DOXYGEN_LATEX_SOURCE_CODE "YES")
  else()
    set(DOXYGEN_GENERATE_LATEX "NO")
    set(DOXYGEN_LATEX_OUTPUT "latex")
    set(DOXYGEN_LATEX_SOURCE_CODE "NO")
  endif()

  # This is true by definition - dot is required for doxygen
  set(DOXYGEN_HAVE_DOT "YES")

  # FYI: CMake variables to be substituted into Doxyfile.in
  # CPACK_PACKAGE_NAME
  # CPACK_PACKAGE_VERSION
  # CPACK_PACKAGE_DESCRIPTION_SUMMARY

  # Quote elements and convert lists to space-separated strings
  to_doxylist(DOXYGEN_CITE_BIB_FILES L_DOXYGEN_CITE_BIB_FILES)
  to_doxylist(DOXYGEN_LATEX_EXTRA_FILES L_DOXYGEN_LATEX_EXTRA_FILES)

  # Set input and output files

  # Create DoxygenLayout.xml by substituting CMake vars into template
  set(DOXYLAYOUT_IN  ${CMAKE_CURRENT_SOURCE_DIR}/doxygen/DoxygenLayout.xml.in)
  set(DOXYGEN_LAYOUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/DoxygenLayout.xml)
  configure_file(${DOXYLAYOUT_IN} ${DOXYGEN_LAYOUT_FILE} @ONLY)

  # Create DoxygenLayout.xml by substituting CMake vars into template
  set(DOXYEXTENSIONS_IN  ${CMAKE_CURRENT_SOURCE_DIR}/doxygen/Doxygen_Extensions.cfg.in)
  set(DOXYGEN_RTF_EXTENSIONS_FILE ${CMAKE_CURRENT_BINARY_DIR}/Doxygen_Extensions.cfg)
  configure_file(${DOXYEXTENSIONS_IN} ${DOXYGEN_RTF_EXTENSIONS_FILE} @ONLY)

  # Create doxygen_header.tex by substituting CMake vars into template
  set(DOXYLATEXHEADER_IN  ${CMAKE_CURRENT_SOURCE_DIR}/doxygen/doxygen_header.tex.in)
  set(DOXYGEN_LATEX_HEADER ${CMAKE_CURRENT_BINARY_DIR}/doxygen_header.tex)
  configure_file(${DOXYLATEXHEADER_IN} ${DOXYGEN_LATEX_HEADER} @ONLY)

  # Create doxygen_footer.tex by substituting CMake vars into template
  set(DOXYLATEXFOOTER_IN  ${CMAKE_CURRENT_SOURCE_DIR}/doxygen/doxygen_footer.tex.in)
  set(DOXYGEN_LATEX_FOOTER ${CMAKE_CURRENT_BINARY_DIR}/doxygen_footer.tex)
  configure_file(${DOXYLATEXFOOTER_IN} ${DOXYGEN_LATEX_FOOTER} @ONLY)

  # Create doxygen_header.tex by substituting CMake vars into template
  set(DOXYLATEXSTYLE_IN  ${CMAKE_CURRENT_SOURCE_DIR}/doxygen/doxygen.sty.in)
  set(DOXYGEN_LATEX_EXTRA_STYLESHEET ${CMAKE_CURRENT_BINARY_DIR}/doxygen.sty)
  configure_file(${DOXYLATEXSTYLE_IN} ${DOXYGEN_LATEX_EXTRA_STYLESHEET} @ONLY)

  # Generate Doxyfile last since it relies on template location variables to be set

  # Create Doxyfile by substituting CMake vars into template
  set(DOXYFILE_IN  ${CMAKE_CURRENT_SOURCE_DIR}/doxygen/Doxyfile.in)
  set(DOXYFILE_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
  configure_file(${DOXYFILE_IN} ${DOXYFILE_OUT} @ONLY)

  add_custom_target(
    docs
    # ALL
    COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYFILE_OUT}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Generating API documentation with Doxygen" VERBATIM
  )

  # # This would be nice to use but it's not clear how CMake is doing its
  # # configuration and I don't have enough control for this to be effective :(
  # doxygen_add_docs(
  #   docs
  #   ${DOXYGEN_LAYOUT_FILE}
  #   ${DOXYGEN_RTF_EXTENSIONS_FILE}
  #   ${DOXYGEN_LATEX_HEADER}
  #   ${DOXYGEN_LATEX_FOOTER}
  #   ${DOXYGEN_LATEX_EXTRA_STYLESHEET}
  #   # ALL
  #   COMMENT "Generating API documentation with Doxygen - new"
  # )

  find_package(Perl)
  if(WIN32)
    if(Perl_FOUND)
      get_filename_component(LOCAL_PERL_PATH ${PERL_EXECUTABLE} DIRECTORY)
      message(STATUS "Ensure ${LOCAL_PERL_PATH} is in PATH because Doxygen runs perl bare")
      # Add perl path to ENV{PATH} for target docs - doesn't work as well as setting PATH manually :/
      # add_custom_command(TARGET docs PRE_BUILD
      #   COMMAND ${CMAKE_COMMAND} -E env "PATH=$ENV{PATH};${LOCAL_PERL_PATH}"
      # )
    else()
      message(STATUS "Cannot find perl; bibtex may not run properly")
    endif()
  endif()

  # Create PDF developers guide as post-build action of docs target
  if(LATEX_FOUND)

    # if(GNUPLOT_FOUND)
    #   set(C1_TEST_DIR "${CMAKE_CURRENT_BINARY_DIR}/test/sofire2_1c")
    #   message(STATUS "Gnuplot found; adding C1 comparison dependencies to latex report build directory")
    #   add_custom_command(TARGET docs POST_BUILD
    #     COMMAND "${GNUPLOT_EXECUTABLE}" C1_comparison.gp
    #     COMMAND ${CMAKE_COMMAND} -E copy C1_comparison.tex "${DOXYGEN_LATEX_OUTPUT}"
    #     COMMAND ${CMAKE_COMMAND} -E copy C1.INP "${DOXYGEN_LATEX_OUTPUT}"
    #     COMMAND ${CMAKE_COMMAND} -E copy C1_comparison_1.pdf "${DOXYGEN_LATEX_OUTPUT}"
    #     COMMAND ${CMAKE_COMMAND} -E copy C1_comparison_2.pdf "${DOXYGEN_LATEX_OUTPUT}"
    #     COMMAND ${CMAKE_COMMAND} -E copy C1_comparison_3.pdf "${DOXYGEN_LATEX_OUTPUT}"
    #     COMMAND ${CMAKE_COMMAND} -E copy C1_comparison_4.pdf "${DOXYGEN_LATEX_OUTPUT}"
    #     COMMAND ${CMAKE_COMMAND} -E copy C1_comparison_5.pdf "${DOXYGEN_LATEX_OUTPUT}"
    #     COMMAND ${CMAKE_COMMAND} -E copy C1_comparison_6.pdf "${DOXYGEN_LATEX_OUTPUT}"
    #     COMMAND ${CMAKE_COMMAND} -E copy C1_comparison_7.pdf "${DOXYGEN_LATEX_OUTPUT}"
    #     COMMAND ${CMAKE_COMMAND} -E copy C1_comparison_8.pdf "${DOXYGEN_LATEX_OUTPUT}"
    #     WORKING_DIRECTORY "${C1_TEST_DIR}"
    #   )
    # else()
    #   message(STATUS "Gnuplot not found; adding C1 comparison placeholder to latex report build directory")
    #   add_custom_command(TARGET docs POST_BUILD
    #     COMMAND ${CMAKE_COMMAND} -E touch C1_comparison.tex
    #     WORKING_DIRECTORY "${DOXYGEN_LATEX_OUTPUT}"
    #   )
    # endif()

    if(WIN32)
      set(DOXYGEN_LATEX_MAKE "make.bat")
    else()
      set(DOXYGEN_LATEX_MAKE "make")
    endif()

    # This makes one preliminary pass of pdflatex against refman to create the
    # nomenclature support files that will be needed by the main make(.bat)
    # command used to build the PDF
    add_custom_command(TARGET docs POST_BUILD
      # COMMAND "$<TARGET_FILE:Doxygen::dot>" -oc1_heat_flow.pdf -Tpdf c1_heat_flow.dot
      # COMMAND "$<TARGET_FILE:Doxygen::dot>" -oc1_na_mass_flow.pdf -Tpdf c1_na_mass_flow.dot
      # COMMAND "$<TARGET_FILE:Doxygen::dot>" -oc1_o_mass_flow.pdf -Tpdf c1_o_mass_flow.dot
      COMMAND "${DOXYGEN_LATEX_CMD_NAME}" refman
      COMMAND "${DOXYGEN_MAKEINDEX_CMD_NAME}" refman.nlo -s nomencl.ist -o refman.nls -t refman.nlg
      COMMAND "${DOXYGEN_LATEX_MAKE}"
      COMMAND ${CMAKE_COMMAND} -E copy refman.pdf "${PDF_MANUAL}"
      WORKING_DIRECTORY "${DOXYGEN_LATEX_OUTPUT}"
    )
    # Should only be needed here
    install(FILES "${PDF_MANUAL}" DESTINATION doc)
  else()
    message(STATUS "Cannot find LaTeX - skipping PDF developer manual creation")
    # This should not be necessary
    # add_custom_command(TARGET docs POST_BUILD
    #     COMMAND ${CMAKE_COMMAND} -E copy "${FAKE_PDF_MANUAL}" "${PDF_MANUAL}"
    # )
  endif()

else()
  message(STATUS "!! Cannot find doxygen - skipping documentation production")
endif()