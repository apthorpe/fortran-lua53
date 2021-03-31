# cmake_minimum_required(VERSION 3.6) #maybe ok?
cmake_minimum_required(VERSION 3.17)

# Needed since 3.19.4; not sure why...
cmake_policy(SET CMP0053 NEW)

# Append local CMake module directory
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Set package metadata
set(CPACK_PACKAGE_NAME "fortran-lua53")
set(CPACK_PACKAGE_VERSION_MAJOR "0")
set(CPACK_PACKAGE_VERSION_MINOR "0")
set(CPACK_PACKAGE_VERSION_PATCH "0")
set(CPACK_PACKAGE_VERSION_TWEAK "1")
set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}.${CPACK_PACKAGE_VERSION_TWEAK}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "A collection of ISO C binding interfaces to Lua 5.3 for Fortran 2003, to call Lua from Fortran and vice versa.")
set(CPACK_PACKAGE_VENDOR "Acorvid Technical Services Corporation")
set(CPACK_PACKAGE_CONTACT "Bob Apthorpe <bob.apthorpe@gmail.com>")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
set(CPACK_PACKAGE_HOMEPAGE_URL "https://github.com/apthorpe/fortran-lua53")
# See https://spdx.org/licenses/
set(SPDX_LICENSE_TAG "ISC")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
# Note: This should not change for the life of the product
# Generated from guidgen.exe
set(CPACK_WIX_UPGRADE_GUID "EBA204F8-8EDE-4AD0-96C1-672E9B525428")
# RAA: What is this? Base installation directory for NSIS installer?
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_PACKAGE_NAME}_${CPACK_PACKAGE_VERSION}")
#? set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_PACKAGE_NAME}")
# set(CPACK_SET_DESTDIR true)
# set(CPACK_INSTALL_PREFIX /opt/${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION})
string(TIMESTAMP BUILD_TIMESTAMP UTC)

# Show your work...
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set project name and language
project(FORTRANLUA53
        LANGUAGES Fortran C
        VERSION "${CPACK_PACKAGE_VERSION}")

###############################################################################
## Options ####################################################################
###############################################################################

# Set fortran compiler with environment variable FC or CMake option
# -D CMAKE_Fortran_COMPILER

# Set C compiler with environment variable CC or CMake option
# -D CMAKE_C_COMPILER

# Set C++ compiler with environment variable CXX or CMake option
# -D CMAKE_CXX_COMPILER

# Test coverage analysis with gcov/lcov is disabled by default; enable with
# CMake option -D ENABLE_COVERAGE:BOOL=ON
# The following is defined in Findcodecov.cmake:
option(ENABLE_COVERAGE "Enable coverage build." OFF)

# Unit tests are disabled by default; enable with CMake option
# -D ENABLE_UNIT_TESTS:BOOL=ON
option(ENABLE_UNIT_TESTS "Enable unit tests." ON)

# TOAST library search directories
set(TOAST_ROOT "" CACHE PATH "Installation root of TOAST library")
set(TOAST_MODULE_PATH "" CACHE PATH "Directory containing TOAST Fortran module (.mod) files")

# Documentation creation is enabled by default; disable with CMake option
# -D ENABLE_DOCUMENTATION:BOOL=OFF
option(ENABLE_DOCUMENTATION "Create documentation." ON)

# WiX installer search directories (root and binary directories)
# Note the quotes around the entire combination of option, type specifier, and value
# -D "WIX_BINARY_DIR:PATH=/Program Files (x86)/WiX Toolset v3.11/bin"
# Only one of these options is necessary; "/bin" is appended to WIX_ROOT_DIR for detecting WiX binaries
# If possible, just set WIX_BINARY_DIR to the directory containing candle.exe and light.exe
set(WIX_BINARY_DIR "/Program Files (x86)/WiX Toolset v3.11/bin" CACHE PATH "Path to WiX binaries")
set(WIX_ROOT_DIR "/Program Files (x86)/WiX Toolset v3.11" CACHE PATH "Path to WiX installation")

###############################################################################
## Dependencies and CMake Modules  ############################################
###############################################################################

if(ENABLE_DOCUMENTATION)
    # Version 1.8.18 or later is suggested
    find_package(Doxygen REQUIRED COMPONENTS dot)
    # find_package(Gnuplot)
    find_package(LATEX COMPONENTS PDFLATEX MAKEINDEX BIBTEX)
endif()

# Defined cmake_parse_arguments(). Needed only for CMake 3.4 and earlier
include(CMakeParseArguments)

# Set default installation paths; should be invoked after setting project language(s)
include(GNUInstallDirs)

# Allow external projects to be imported
# (Needed for unit testing framework and logging module)
include(ExternalProject)
include(FetchContent)

# CTest setup
# Needed for valgrind (usually only enable_testing() is needed)
include(CTest)
enable_testing()

# Enable code coverage
find_package(codecov)

# Look for local installation of git
find_package(Git)

# Enable unit testing with TOAST
if(ENABLE_UNIT_TESTS)
    # Detect local installation of TOAST, if any. This requires
    # TOAST_ROOT is set as an argument to CMake
    find_package(TOAST)
    if (TOAST_FOUND)
        include(TOASThelper)
    else()
        # Needed for retrieving TOAST
        # Move out of this structure if git is needed elsewhere;
        # attempting to remove it completely as a dependency
        if(Git_FOUND)
            # Retrieve and build TOAST from network
            # include(BuildTOAST) # This works but is rather convoluted
            include(IncludeTOAST)
            include(TOASThelper)
        else()
            # Disable unit tests if TOAST not found locally or
            # built from remote sources
            message(STATUS "WTF? TOAST SHOULD BE AVAILABLE!")
            set(ENABLE_UNIT_TESTS OFF)
        endif()
    endif()
endif()

# Manage Fortran compiler options, library linking and .mod file inclusion
include(FortranHelper)

# Manage C compiler options
include(CHelper)

# Note: Doxygen detection and setup is performed in the Documentation section

# Retrieve and build Lua 5.3(.6) - not working yet
# include(BuildLua53)
# Retrieve and unpack Lua 5.3(.6) sources
include(IncludeLua53)

# # Find threading library (not needed for Windows, needed for Linux)
# set(THREADS_PREFER_PTHREAD_FLAG TRUE)
# include(FindThreads)

###############################################################################
## Build ######################################################################
###############################################################################

unset(CCOPTS)

list(APPEND CCOPTS
    ${CCOPT_WALL}
    ${CCOPT_DEBUG}
)

message(STATUS "C compiler options for Fortran-Lua53 set to ${FCOPTS}")

unset(FCOPTS)

list(APPEND FCOPTS
    ${FCOPT_WALL}
    ${FCOPT_FCHECKALL}
    ${FCOPT_DEBUG}
    ${FCOPT_BACKTRACE}
)

# Set recent language standard if available
if(${FC_ALLOWS_STD_F2018})
    list(APPEND FCOPTS ${FCOPT_STD_F2018})
elseif(${FC_ALLOWS_STD_F2008})
    list(APPEND FCOPTS ${FCOPT_STD_F2008})
endif()

# Set optimizations which do not interfere with debugging
# if(${FC_ALLOWS_DEBUG_OPTIMIZATION})
#     list(APPEND FCOPTS ${FCOPT_DEBUG_OPTIMIZATION})
# elseif(${FC_ALLOWS_NO_OPTIMIZATION})
#     list(APPEND FCOPTS ${FCOPT_NO_OPTIMIZATION})
# endif()

if(${FC_ALLOWS_NO_OPTIMIZATION})
    list(APPEND FCOPTS ${FCOPT_NO_OPTIMIZATION})
endif()

message(STATUS "Fortran compiler options for fortran-lua53 set to ${FCOPTS}")

#=======================================================================
# Build Lua from retrieved sources (static library liblua)
#=======================================================================

set(LIBLUA53_NAME lua53)

# Target liblua53: Lua 5.3 sources
set(LIBLUA53_SOURCE_DIR "${LUA53_SOURCE_DIR}/src")

set(LIBLUA53_CORE_SOURCES
  "${LIBLUA53_SOURCE_DIR}/lapi.c"
  "${LIBLUA53_SOURCE_DIR}/lcode.c"
  "${LIBLUA53_SOURCE_DIR}/lctype.c"
  "${LIBLUA53_SOURCE_DIR}/ldebug.c"
  "${LIBLUA53_SOURCE_DIR}/ldo.c"
  "${LIBLUA53_SOURCE_DIR}/ldump.c"
  "${LIBLUA53_SOURCE_DIR}/lfunc.c"
  "${LIBLUA53_SOURCE_DIR}/lgc.c"
  "${LIBLUA53_SOURCE_DIR}/llex.c"
  "${LIBLUA53_SOURCE_DIR}/lmem.c"
  "${LIBLUA53_SOURCE_DIR}/lobject.c"
  "${LIBLUA53_SOURCE_DIR}/lopcodes.c"
  "${LIBLUA53_SOURCE_DIR}/lparser.c"
  "${LIBLUA53_SOURCE_DIR}/lstate.c"
  "${LIBLUA53_SOURCE_DIR}/lstring.c"
  "${LIBLUA53_SOURCE_DIR}/ltable.c"
  "${LIBLUA53_SOURCE_DIR}/ltm.c"
  "${LIBLUA53_SOURCE_DIR}/lundump.c"
  "${LIBLUA53_SOURCE_DIR}/lvm.c"
  "${LIBLUA53_SOURCE_DIR}/lzio.c"
)

set(LIBLUA53_LIB_SOURCES
  "${LIBLUA53_SOURCE_DIR}/lauxlib.c"
  "${LIBLUA53_SOURCE_DIR}/lbaselib.c"
  "${LIBLUA53_SOURCE_DIR}/lbitlib.c"
  "${LIBLUA53_SOURCE_DIR}/lcorolib.c"
  "${LIBLUA53_SOURCE_DIR}/ldblib.c"
  "${LIBLUA53_SOURCE_DIR}/liolib.c"
  "${LIBLUA53_SOURCE_DIR}/lmathlib.c"
  "${LIBLUA53_SOURCE_DIR}/loslib.c"
  "${LIBLUA53_SOURCE_DIR}/lstrlib.c"
  "${LIBLUA53_SOURCE_DIR}/ltablib.c"
  "${LIBLUA53_SOURCE_DIR}/lutf8lib.c"
  "${LIBLUA53_SOURCE_DIR}/loadlib.c"
  "${LIBLUA53_SOURCE_DIR}/linit.c"
)

add_library(${LIBLUA53_NAME}
    ${LIBLUA53_CORE_SOURCES}
    ${LIBLUA53_LIB_SOURCES}
)

target_compile_options(${LIBLUA53_NAME} PUBLIC ${CCOPTS})
target_link_libraries(${LIBLUA53_NAME} PUBLIC m)

set_target_properties(${LIBLUA53_NAME}
    PROPERTIES
    # OUTPUT_NAME lua53
    DEPENDS LUA53_external
)

install(TARGETS ${LIBLUA53_NAME})

#=======================================================================
# Build lua53 compiler
#=======================================================================

set(LUAC53_NAME luac53)

set(LUAC53_SOURCES
  "${LIBLUA53_SOURCE_DIR}/luac.c"
)

add_executable(${LUAC53_NAME}
    ${LUAC53_SOURCES}
)

target_compile_options(${LIBLUA53_NAME} PUBLIC ${CCOPTS})
target_include_directories(${LUAC53_NAME} PUBLIC ${LIBLUA53_SOURCE_DIR})
target_link_libraries(${LUAC53_NAME} PUBLIC ${LIBLUA53_NAME})

set_target_properties(${LUAC53_NAME}
    PROPERTIES
    # OUTPUT_NAME luac53
    DEPENDS ${LIBLUA53_NAME}
)

install(TARGETS ${LUAC53_NAME})

#=======================================================================
# Build lua53 interpreter
#=======================================================================

set(LUATERP53_NAME ilua53)

set(LUATERP53_SOURCES
  "${LIBLUA53_SOURCE_DIR}/lua.c"
)

add_executable(${LUATERP53_NAME}
    ${LUATERP53_SOURCES}
)

target_compile_options(${LIBLUA53_NAME} PUBLIC ${CCOPTS})
target_include_directories(${LUATERP53_NAME} PUBLIC ${LIBLUA53_SOURCE_DIR})
target_link_libraries(${LUATERP53_NAME} PUBLIC ${LIBLUA53_NAME})

set_target_properties(${LUATERP53_NAME}
    PROPERTIES
    OUTPUT_NAME lua53
    DEPENDS ${LIBLUA53_NAME}
)

install(TARGETS ${LUATERP53_NAME})

#=======================================================================
# Build fortran-lua53 as a static library
#=======================================================================

# Set target name FORTRANLUA53_NAME to fortranlua53
set(FORTRANLUA53LIB_NAME fortranlua53)


# Target fortran-lua53: fortran-lua53 library sources
set(FORTRANLUA53_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")

# set(FORTRANLUA53_GENERATED_DIR "${CMAKE_CURRENT_BINARY_DIR}/fortran-lua53_generated_src")
# file(MAKE_DIRECTORY "${FORTRANLUA53_GENERATED_DIR}")

# set(FORTRANLUA53_VERSION_TEMPLATE "${FORTRANLUA53_SOURCE_DIR}/fortran-lua53_version.f90.in")
# set(FORTRANLUA53_VERSION_FILE "${FORTRANLUA53_GENERATED_DIR}/fortran-lua53_version.f90")
# configure_file("${FORTRANLUA53_VERSION_TEMPLATE}"
#     "${FORTRANLUA53_VERSION_FILE}" @ONLY)

# Define Fortran sources for fortran-lua53 library
set(FORTRANLUA53_SOURCES
    "${FORTRANLUA53_SOURCE_DIR}/lua.f90"
)

# # Apply FCOPTS only to Fortran source files
# set_source_files_properties(
#     ${FORTRANLUA53_SOURCES}
#     PROPERTIES
#     COMPILE_OPTIONS "${FCOPTS}"
# )

# # Define C sources for fortran-lua53 library
# set(FORTRANLUA53_DEP_C_SOURCES
#     "${FORTRANLUA53_SOURCE_DIR}/csqlite.c"
#     "${SQLITE3_SOURCE_DIR}/sqlite3.c"
# )

# # Apply CCOPTS only to C source files
# set_source_files_properties(
#     ${FORTRANLUA53_DEP_C_SOURCES}
#     PROPERTIES
#     COMPILE_OPTIONS "${CCOPTS}"
# )

# Define FORTRANLUA53 library artifact
set(FORTRANLUA53LIB_FORTRAN_MODULE_DIR "${CMAKE_CURRENT_BINARY_DIR}/${FORTRANLUA53LIB_NAME}_include")
file(MAKE_DIRECTORY "${FORTRANLUA53LIB_FORTRAN_MODULE_DIR}")

add_library(${FORTRANLUA53LIB_NAME} ${FORTRANLUA53_SOURCES})
target_compile_options(${FORTRANLUA53LIB_NAME} PUBLIC ${FCOPTS})
target_include_directories(${FORTRANLUA53LIB_NAME} PUBLIC ${FORTRANLUA53_SOURCE_DIR})
target_link_libraries(${FORTRANLUA53LIB_NAME} PUBLIC ${LIBLUA53_NAME})

set_target_properties(
    ${FORTRANLUA53LIB_NAME}
    PROPERTIES
    Fortran_MODULE_DIRECTORY ${FORTRANLUA53LIB_FORTRAN_MODULE_DIR}
    DEPENDS ${LIBLUA53_NAME}
)

# add_coverage(${FORTRANLUA53LIB_NAME})

# This is needed on Linux but not on Windows
# target_link_libraries(${FORTRANLUA53LIB_NAME} Threads::Threads ${CMAKE_DL_LIBS})
# Options are set on a per-source-file basis now so Fortran options
# are only applied to Fortran code, etc.
# target_compile_options(${FORTRANLUA53LIB_NAME} PUBLIC ${FCOPTS})

install(TARGETS ${FORTRANLUA53LIB_NAME})

install(DIRECTORY "${FORTRANLUA53LIB_FORTRAN_MODULE_DIR}/"
    DESTINATION include
    FILES_MATCHING
    PATTERN *.mod
)

#=======================================================================
# Create test applications
#=======================================================================

set(EXAMPLE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/examples")

#=======================================================================
# Create test application: fibonacci
#=======================================================================

set(FIBONACCI_NAME fibonacci)
# Define sources for fibonacci test executable
set(FIBONACCI_SOURCES
    "${EXAMPLE_SOURCE_DIR}/fibonacci/example.f90"
)

add_executable(${FIBONACCI_NAME} ${FIBONACCI_SOURCES})
target_compile_options(${FIBONACCI_NAME} PUBLIC ${FCOPTS})
target_link_libraries(${FIBONACCI_NAME} ${LIBLUA53_NAME})
link_fortran_libraries(${FIBONACCI_NAME} ${FORTRANLUA53LIB_NAME})

target_compile_options(${FIBONACCI_NAME} PUBLIC ${FCOPTS})

install(TARGETS ${FIBONACCI_NAME})

#=======================================================================
# Create test Fortran library callable from Lua: fhello
#=======================================================================

# TODO: FIX THIS ON WINDOWS 10

# set(FHELLOLIB_NAME fhello)
# # Define sources for Fortran library containing Lua-visible hello() routine
# set(FHELLOLIB_SOURCES
#     "${EXAMPLE_SOURCE_DIR}/library/fortran.f90"
# )

# set(FORTRANLUA53LIB_FORTRAN_MODULE_DIR "${CMAKE_CURRENT_BINARY_DIR}/${FHELLOLIB_NAME}_include")
# file(MAKE_DIRECTORY "${FHELLOLIB_FORTRAN_MODULE_DIR}")
# add_library(${FHELLOLIB_NAME} SHARED ${FHELLOLIB_SOURCES})
# target_link_libraries(${FHELLOLIB_NAME} ${LIBLUA53_NAME})
# link_fortran_libraries(${FHELLOLIB_NAME} ${FORTRANLUA53LIB_NAME})

# target_compile_options(${FHELLOLIB_NAME} PUBLIC ${FCOPTS})

# install(TARGETS ${FHELLOLIB_NAME})

#=======================================================================
# Create test application: string
#=======================================================================

set(XSTRING_NAME string)
# Define sources for fibonacci test executable
set(XSTRING_SOURCES
    "${EXAMPLE_SOURCE_DIR}/string/string.f90"
)

add_executable(${XSTRING_NAME} ${XSTRING_SOURCES})
target_compile_options(${FIBONACCI_NAME} PUBLIC ${FCOPTS})
target_link_libraries(${XSTRING_NAME} ${LIBLUA53_NAME})
link_fortran_libraries(${XSTRING_NAME} ${FORTRANLUA53LIB_NAME})

target_compile_options(${XSTRING_NAME} PUBLIC ${FCOPTS})

install(TARGETS ${XSTRING_NAME})

# ###############################################################################
# ## Testing ####################################################################
# ###############################################################################

set(TEST_BASE_DIR "${CMAKE_CURRENT_BINARY_DIR}/test")

# ***** Pre-Test File and Directory Generation *****

# Create test output as separate target folded into `make all`
add_custom_target(fortran-lua53_test_setup
    ALL
    DEPENDS ${FORTRANLUA53LIB_NAME}
    COMMAND ${CMAKE_COMMAND} -E echo "Copying test"
    COMMAND ${CMAKE_COMMAND} -E copy_directory "${CMAKE_CURRENT_SOURCE_DIR}/test" "${TEST_BASE_DIR}"
    VERBATIM
    USES_TERMINAL
)

# Create fibonacci test output as separate target folded into `make all`
set(EXAMPLE_DIR "${TEST_BASE_DIR}/fibonacci")
add_custom_target(run_fibonacci
    ALL
    DEPENDS fortran-lua53_test_setup
    COMMAND ${CMAKE_COMMAND} -E echo "Running test fibonacci; output is in fibonacci.out"
    COMMAND $<TARGET_FILE:fibonacci> > fibonacci.out
    BYPRODUCTS fibonacci.out
    WORKING_DIRECTORY "${EXAMPLE_DIR}"
    VERBATIM
    USES_TERMINAL
)

# Create string test output as separate target folded into `make all`
set(EXAMPLE_DIR "${TEST_BASE_DIR}/string")
add_custom_target(run_string
    ALL
    DEPENDS fortran-lua53_test_setup
    COMMAND ${CMAKE_COMMAND} -E echo "Running test string; output is in string.out"
    COMMAND $<TARGET_FILE:string> > string.out
    BYPRODUCTS string.out
    WORKING_DIRECTORY "${EXAMPLE_DIR}"
    VERBATIM
    USES_TERMINAL
)

# ***** Integral Tests *****

# Tests using CMake's simple built-in "compare_files" command
# Compare output with reference data

# fibonacci
set(EXAMPLE_DIR "${TEST_BASE_DIR}/fibonacci")
add_test(NAME fibonacci_output
    COMMAND ${CMAKE_COMMAND} -E compare_files --ignore-eol fibonacci.out fibonacci.ref
    WORKING_DIRECTORY "${EXAMPLE_DIR}"
    CONFIGURATIONS Debug Release ""
)

# string
set(EXAMPLE_DIR "${TEST_BASE_DIR}/string")
add_test(NAME string_output
    COMMAND ${CMAKE_COMMAND} -E compare_files --ignore-eol string.out string.ref
    WORKING_DIRECTORY "${EXAMPLE_DIR}"
    CONFIGURATIONS Debug Release ""
)

# Set shared properties on tests
set_tests_properties(
    fibonacci_output
    string_output
    PROPERTIES
    DEPENDS ${FORTRANLUA53LIB_NAME}
    DEPENDS fortran-lua53_test_setup
    DEPENDS run_fibonacci
    DEPENDS run_string
    TIMEOUT 30
)

# ***** Unit Tests *****

# Unit test executables - source directory
set(TEST_SRC_BASE "${CMAKE_CURRENT_SOURCE_DIR}/test")
set(UNITTEST_SRC_BASE "${TEST_SRC_BASE}/unittest")

if(ENABLE_UNIT_TESTS)

    # TOAST null test
    set(EXAMPLE_DIR "${TEST_BASE_DIR}/unittest")
    list(APPEND TEST_SOURCES
        "${UNITTEST_SRC_BASE}/ut_null.f90"
        "${EXTRAN_DEP_SOURCES}")
    add_toast_unit_test(
        TARGET ut_null
        SOURCES ${TEST_SOURCES}
        DEPENDENCIES fortran-lua53_test_setup ${FORTRANLUA53LIB_NAME}
        RUN_DIRECTORY ${EXAMPLE_DIR}
        DEBUG
    )
    link_fortran_libraries(ut_null ${FORTRANLUA53LIB_NAME})
    unset(TEST_SOURCES)
    unset(EXAMPLE_DIR)
endif()

###############################################################################
## Analysis ###################################################################
###############################################################################

# If valgrind or equivalent is available, memory leak/access tests can be run
# with:
# ctest -T memcheck
#
# Manual memory checks:
# valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all <command [opts] [args]>
# "c:\Program Files (x86)\Dr. Memory\bin64\drmemory.exe" -ignore_kernel <command [opts] [args]>

###############################################################################
## Documentation ##############################################################
###############################################################################

if(ENABLE_DOCUMENTATION)

    # Set up Doxygen and custom LaTeX content and templates
    set(USERDOC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/userdoc")
    list(APPEND L_DOXYGEN_CITE_BIB_FILES ${USERDOC_DIR}/fortran-lua53.bib)
    list(REMOVE_DUPLICATES L_DOXYGEN_CITE_BIB_FILES)

    list(APPEND L_DOXYGEN_LATEX_EXTRA_FILES
        ${USERDOC_DIR}/siunitx_custom_units.tex
        ${USERDOC_DIR}/manual_metadata.tex
        ${USERDOC_DIR}/overview.tex
        ${USERDOC_DIR}/build.tex
        ${L_DOXYGEN_CITE_BIB_FILES}
    )
    list(REMOVE_DUPLICATES L_DOXYGEN_LATEX_EXTRA_FILES)

    include(SetupDoxygen)
else()
    # Use placeholder documentation to satisfy installer if documentation isn't
    # generated
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E copy
        "${CMAKE_CURRENT_SOURCE_DIR}/doxygen/Fortran_Lua53_Users_Guide_placeholder.pdf"
        "${CMAKE_CURRENT_BINARY_DIR}/Fortran_Lua53_Users_Guide.pdf"
    )
endif()

###############################################################################
## Packaging ##################################################################
###############################################################################

# # Property data files
# install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/data/"
#     DESTINATION data
#     FILES_MATCHING
#     PATTERN *.txt)

# Documentation files
install(FILES LICENSE README.md # CODE_OF_CONDUCT.md
    DESTINATION doc)

# Test files
install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/examples/"
    DESTINATION examples
)

list(APPEND CPACK_GENERATOR ZIP)

if(WIN32)
    # Set up NSIS
    find_package(NSIS)
    if(NSIS_FOUND)
        # set(CPACK_NSIS_DISPLAY_NAME "${GRAPHVIZ_VERSION_FULL}")
        # set(CPACK_NSIS_PACKAGE_NAME "${GRAPHVIZ_VERSION_FULL}")
        set(CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_SOURCE_DIR}/img/fortran_lua53_icon.ico")
        set(CPACK_NSIS_MUI_UNIICON "${CMAKE_CURRENT_SOURCE_DIR}/img/fortran_lua53_icon.ico")
        set(CPACK_NSIS_INSTALLED_ICON_NAME "Uninstall.exe")
        set(CPACK_NSIS_HELP_LINK "${CPACK_PACKAGE_HOMEPAGE_URL}")
        set(CPACK_NSIS_URL_INFO_ABOUT "${CPACK_PACKAGE_HOMEPAGE_URL}")
        set(CPACK_NSIS_MODIFY_PATH ON)
        set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)

        list(APPEND CPACK_GENERATOR NSIS)
    endif()

    # NuGet
    # TODO: Find a more robust means of detecting whether NuGet is available
    find_program(NUGET_EXECUTABLE nuget)
    if(NUGET_EXECUTABLE)
        # message(STATUS "NuGet found at ${NUGET_EXECUTABLE}; needs configuration")

        # Not sure this helps if NuGet package is created via CPack
        # set(NUGET_COMMAND "${NUGET_EXECUTABLE}")
        # include(NuGetTools)

        install(FILES LICENSE
            RENAME LICENSE.txt
            DESTINATION doc)

        install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/img/fortran_lua53_icon_128.png"
            DESTINATION img)

        # set(CPACK_NUGET_COMPONENT_INSTALL OFF)
        set(CPACK_NUGET_PACKAGE_NAME "ATSC-${CPACK_PACKAGE_NAME}")
        set(CPACK_NUGET_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION}")
        set(CPACK_NUGET_PACKAGE_DESCRIPTION
        "A collection of ISO C binding interfaces to Lua 5.3 for Fortran 2003, to call Lua from Fortran and vice versa.")
        set(CPACK_NUGET_PACKAGE_AUTHORS apthorpe)
        set(CPACK_NUGET_PACKAGE_TITLE "${CPACK_PACKAGE_NAME}")
        set(CPACK_NUGET_PACKAGE_OWNERS apthorpe)
        set(CPACK_NUGET_PACKAGE_HOMEPAGE_URL "${CPACK_PACKAGE_HOMEPAGE_URL}")
        # LicenseURL is deprecated; how to set License with CMake/CPack?
        set(CPACK_NUGET_PACKAGE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
        # set(CPACK_NUGET_PACKAGE_LICENSEURL "https://gitlab.com/apthorpe/fsqlite/-/blob/master/LICENSE")
        set(CPACK_NUGET_PACKAGE_LICENSE_EXPRESSION "${SPDX_LICENSE_TAG}")
        # set(CPACK_NUGET_PACKAGE_LICENSE_FILE_NAME "doc/LICENSE.txt")
        #    A URL for a 128x128 image with transparency background to use as the icon for the package in UI display.
        # set(CPACK_NUGET_PACKAGE_ICONURL "https://gitlab.com/apthorpe/fsqlite/-/blob/master/img/fsqlite_icon_128.png")
        set(CPACK_NUGET_PACKAGE_ICON "img/fortran_lua53_icon_128.png")
        set(CPACK_NUGET_PACKAGE_DESCRIPTION_SUMMARY "${CPACK_PACKAGE_DESCRIPTION_SUMMARY}")
        set(CPACK_NUGET_PACKAGE_RELEASE_NOTES "Experimental version for testing NuGet packaging. For information only.")
        set(CPACK_NUGET_PACKAGE_COPYRIGHT "Copyright 2021, Bob Apthorpe <bob.apthorpe@gmail.com>")
        set(CPACK_NUGET_PACKAGE_LANGUAGE "en_US")
        #    A space-delimited list of tags and keywords that describe the package and aid discoverability of packages through search and filtering.
        set(CPACK_NUGET_PACKAGE_TAGS "Fortran" "sqlite")
# 	# Repository info
# 	set(CPACK_NUGET_PACKAGE_REPOSITORY_TYPE "git")
# 	set(CPACK_NUGET_PACKAGE_REPOSITORY_URL "https://gitlab.com/apthorpe/fsqlite.git")
# 	set(CPACK_NUGET_PACKAGE_REPOSITORY_BRANCH "42-improve-unit-test-integration")
# 	set(CPACK_NUGET_PACKAGE_REPOSITORY_COMMIT "77a50e78c525dcfb347a66367bba3bd655b4400b")
        #    A list of package dependencies.
        # set(CPACK_NUGET_PACKAGE_DEPENDENCIES TBD)
        #    A version specification for the particular dependency, where <dependency> is an item of the dependency list (see above) transformed with MAKE_C_IDENTIFIER function of string() command.
        # CPACK_NUGET_PACKAGE_DEPENDENCIES_<dependency>_VERSION
        #
        set(CPACK_NUGET_PACKAGE_DEBUG OFF)

        list(APPEND CPACK_GENERATOR NuGet)
    endif()

    # Set up WIX
    # These config variables are set at the top of CMakeLists.txt
    # set(WIX_BINARY_DIR "/Program Files (x86)/WiX Toolset v3.11/bin" CACHE PATH "Path to WiX binaries")
    # set(WIX_ROOT_DIR "/Program Files (x86)/WiX Toolset v3.11" CACHE PATH "Path to WiX installation")
    find_package(WIX)
    if(WIX_FOUND)
        message(STATUS "WIX was found: WIX_FOUND = ${WIX_FOUND}")
        # Manually tell CPack where find_package() found WIX...
        set(CPACK_WIX_ROOT "${WIX_ROOT}")
        # Manually convert LICENSE to RTF format because WIX/CPack is stupid
        set(WIX_LICENSE_FILE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.rtf")
        set(CPACK_WIX_LICENSE_RTF "${WIX_LICENSE_FILE}")
        install(FILES "${WIX_LICENSE_FILE}" DESTINATION doc)
        set(CPACK_WIX_PRODUCT_ICON "${CMAKE_CURRENT_SOURCE_DIR}/img/fortran_lua53_icon.ico")

        list(APPEND CPACK_GENERATOR WIX)
    else()
        message(STATUS "WIX was not found: WIX_FOUND = ${WIX_FOUND}")
    endif()
else()
    list(APPEND CPACK_GENERATOR TGZ TBZ2)
    if(APPLE)
        # Set up DRAGNDROP
        # Add DragNDrop properties
        set(CPACK_DMG_VOLUME_NAME "${CPACK_PACKAGE_NAME} v${CPACK_PACKAGE_VERSION}")
#        set(CPACK_DMG_FORMAT "UDZO")
        set(CPACK_DMG_FORMAT "UDBZ")
#*       CPACK_DMG_DS_STORE
#*       CPACK_DMG_DS_STORE_SETUP_SCRIPT
#*       CPACK_DMG_BACKGROUND_IMAGE
#        CPACK_DMG_DISABLE_APPLICATIONS_SYMLINK
#        CPACK_DMG_SLA_DIR
#        CPACK_DMG_SLA_LANGUAGES
#        CPACK_DMG_<component>_FILE_NAME
#        CPACK_COMMAND_HDIUTIL
#        CPACK_COMMAND_SETFILE
#        CPACK_COMMAND_REZ
        list(APPEND CPACK_GENERATOR DragNDrop)
    else()
        # Set up DEB
        # TODO: Find a more robust means of detecting whether debian packaging should be enabled
        # Note that readelf is not strictly necessary but platform is assumed
        # Debian-ish if it's present
        find_program(READELF_EXECUTABLE readelf)
        if(READELF_EXECUTABLE)
            set(CPACK_DEBIAN_PACKAGE_DESCRIPTION
"${CPACK_PACKAGE_DESCRIPTION_SUMMARY}")
            # set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "any")
            # Auto-detect dependencies
            set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
            # Hack to find internal libraries - see https://gitlab.kitware.com/cmake/cmake/-/issues/17447
            # list(APPEND CMAKE_INSTALL_RPATH
            #     "$ORIGIN/../lib/graphviz"
            # )
            # A better solution is to set LD_LIBRARY_PATH when running CPack or `make package`
            # Exanple: LD_LIBRARY_PATH=./_CPack_Packages/Linux/DEB/Graphviz-2.45.0-Linux/usr/lib/graphviz:${LD_LIBRARY_PATH} make package
            # Exanple: LD_LIBRARY_PATH=./_CPack_Packages/Linux/DEB/Graphviz-2.45.0-Linux/usr/lib/graphviz:${LD_LIBRARY_PATH} cpack -G DEB
            # Build multiple packages
            set(CPACK_DEB_COMPONENT_INSTALL ON)
            set(CPACK_DEBIAN_ENABLE_COMPONENT_DEPENDS ON)
            # set(CPACK_DEBIAN_PACKAGE_DEBUG ON)
            # Turn off for executable-only; only needed for packaging libraries
            set(CPACK_DEBIAN_PACKAGE_GENERATE_SHLIBS OFF)

            list(APPEND CPACK_GENERATOR DEB)
        endif()

        # Set up RPM
        # TODO: Find a more robust means of detecting whether RPM generator is available
        find_program(RPMBUILD_EXECUTABLE rpmbuild)
        if(RPMBUILD_EXECUTABLE)
            # message(STATUS "rpmbuild found at ${RPMBUILD_EXECUTABLE}; needs configuration")

            # Needs additional work (maybe?)
            set(CPACK_RPM_PACKAGE_LICENSE "${SPDX_LICENSE_TAG}")
            set(CPACK_RPM_FILE_NAME RPM-DEFAULT)
            list(APPEND CPACK_GENERATOR RPM)
        endif()
    endif()
endif()

# This must be last
include(CPack)
