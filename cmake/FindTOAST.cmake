# Distributed under the OSI-approved MIT License.  See accompanying
# file LICENSE for details.

#[=======================================================================[.rst:
FindTOAST
---------

Find ``TOAST`` unit testing library for Fortran.

The module defines the following variables:

``TOAST_LIB_NAME``
  ``TOAST`` library base name ('toast')

``TOAST_LIBRARY``
  path to the ``TOAST`` library

``TOAST_LIBRARY_DIR``
  path to the ``TOAST`` library directory

``TOAST_MODULE_FILE``
  path to the ``TOAST`` Fortran module (.mod) file

``TOAST_MODULE_DIR``
  path to the ``TOAST`` Fortran module directory

``TOAST_FOUND``
  "True" if the ``TOAST`` library and module files were found

Example usage:

.. code-block:: cmake

  find_package(TOAST)
#]=======================================================================]

set(TOAST_LIB_NAME toast)
set(TOAST_FOUND OFF)

# Set TOAST_ROOT and TOAST_MODULE_PATH on the command line:
# The following are defined in the root CMakeLists.txt file
# set(TOAST_ROOT "" CACHE PATH "Installation root of TOAST library")
# set(TOAST_MODULE_PATH "" CACHE PATH "Directory containing TOAST Fortran module (.mod) files")

# BuildTOAST.cmake sets TOAST_ROOT to
# <project_root>\build\TOAST_external-prefix\src\TOAST_external-build

if(IS_DIRECTORY "${TOAST_ROOT}")
    set(SEARCH_TOAST_LIB ${TOAST_ROOT}/lib)
    set(SEARCH_TOAST_MOD ${TOAST_ROOT}/include ${TOAST_ROOT}/module
        ${TOAST_ROOT}/finclude ${TOAST_ROOT}/finclude/toast)
endif()

if(IS_DIRECTORY "${TOAST_MODULE_PATH}")
    list(APPEND SEARCH_TOAST_MOD "${TOAST_MODULE_PATH}")
endif()

find_library(TOAST_LIBRARY
    NAMES "${TOAST_LIB_NAME}"
    PATHS ${SEARCH_TOAST_LIB}
)

# message(STATUS "Debug: SEARCH_TOAST_MOD=${SEARCH_TOAST_MOD}")
find_file(TOAST_MODULE_FILE
    NAMES "${TOAST_LIB_NAME}.mod"
    PATHS ${SEARCH_TOAST_MOD}
)

# Set TOAST_FOUND if both TOAST_LIBRARY and TOAST_MODULE_FILE are found
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TOAST DEFAULT_MSG
    TOAST_LIBRARY TOAST_MODULE_FILE)

if(TOAST_FOUND)
    ##### Set Output Variables #####

    # Set the following:
    # - TOAST_LIB_NAME (at top; "toast")
    # - TOAST_LIBRARY_DIR
    # - TOAST_MODULE_DIR
    # - TOAST_MODULE_FILE (from find_file())
    get_filename_component(TOAST_LIBRARY_DIR "${TOAST_LIBRARY}" DIRECTORY)
    get_filename_component(TOAST_MODULE_DIR "${TOAST_MODULE_FILE}" DIRECTORY)
    message(STATUS "Found TOAST library under ${TOAST_LIBRARY_DIR}")
else()
    message(STATUS "Cannot find TOAST (is TOAST_ROOT set? '${TOAST_ROOT}')")
endif()

# These variables are set to be compatible with the naming scheme used
# in original TOAST example CMake setup; see
# build/TOAST-source/examples/example1/CMakeLists.txt
# - TOAST_LIB_NAME (= "toast")
# - TOAST_LIBRARY_DIR
# - TOAST_MODULE_DIR

# Note: This needs to be manually added to the list of source files
# required for unit tests
# - TOAST_MODULE_FILE
