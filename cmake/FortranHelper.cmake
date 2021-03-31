# Distributed under the OSI-approved MIT License.  See accompanying
# file LICENSE for details.

#[=======================================================================[.rst:
FortranHelper
---------

Interrogate the Fortran compiler to see if it supports specific options
and add helper functions to simplify linking to Fortran libraries and
module files.

The module defines the following functions:

``set_fcopt(fcopt_allowed fcopt_name fc_flag)``
  If ``fc_flag`` is accepted by the Fortran compiler, ``fcopt_allowed``
  is set to "True" and ``fcopt_name`` is set to ``fc_flag``. Otherwise
  ``fcopt_allowed`` is set to "False" and ``fcopt_name`` is empty.

``link_fortran_libraries(my_target library_name ...)``
  For the given target, add specified libraries to
  ``target_link_libraries()`` and add each library's
 ``Fortran_MODULE_DIRECTORY`` property to
 ``target_include_directories()``

The module defines the following variables:

``FC_ALLOWS_NO_OPTIMIZATION``
  "True" if the Fortran compiler supports a no optimization flag such as ``-O0``

``FCOPT_NO_OPTIMIZATION``
  The Fortran compiler's no optimization flag or empty if not supported

``FC_ALLOWS_DEBUG_OPTIMIZATION``
  "True" if the Fortran compiler supports a debug optimization flag such as ``-Og``

``FCOPT_DEBUG_OPTIMIZATION``
  The Fortran compiler's debug optimization flag or empty if not supported

``FC_ALLOWS_STD_LEGACY``
  "True" if the Fortran compiler supports a legacy support flag such as  ``--std=legacy``

``FCOPT_STD_LEGACY``
  The Fortran compiler's legacy support flag or empty if not supported

``FC_ALLOWS_WALL``
  "True" if the Fortran compiler supports a warn=all flag such as ``-Wall``

``FCOPT_WALL``
  The Fortran compiler's warn=all flag or empty if not supported

``FC_ALLOWS_BACKTRACE``
  "True" if the Fortran compiler supports a backtrace flag such as ``-fbacktrace``

``FCOPT_BACKTRACE``
  The Fortran compiler's backtrace  flag or empty if not supported

``FC_ALLOWS_DEBUG``
  "True" if the Fortran compiler supports a debug flag such as ``-g``

``FCOPT_DEBUG``
  The Fortran compiler's debug flag or empty if not supported

``FC_ALLOWS_SAVE``
  "True" if the Fortran compiler supports a disable-SAVE-by-default flag such as ``-fno-automatic``

``FCOPT_SAVE``
  The Fortran compiler's disable-SAVE-by-default flag or empty if not supported

``FC_ALLOWS_SAVE``
  "True" if the Fortran compiler supports a disable-SAVE-by-default flag such as ``-fno-automatic``

``FCOPT_SAVE``
  The Fortran compiler's disable-SAVE-by-default flag or empty if not supported

``FC_ALLOWS_FCHECKALL``
  "True" if the Fortran compiler supports a check=all flag such as ``-fcheck=all``

``FCOPT_FCHECKALL``
  The Fortran compiler's check=all flag or empty if not supported

``FC_ALLOWS_STD_F2008``
  "True" if the Fortran compiler can enforce Fortran 2008 compliance with a flag such as ``--std=f2008``

``FCOPT_STD_F2008``
  The Fortran compiler's Fortran 2008 compliance flag or empty if not supported

``FC_ALLOWS_STD_F2018``
  "True" if the Fortran compiler can enforce Fortran 2018 compliance with a flag such as ``--std=f2018``

``FCOPT_STD_F2018``
  The Fortran compiler's Fortran 2018 compliance flag or empty if not supported

``FC_ALLOWS_COVERAGE``
  "True" if the Fortran compiler supports a coverage flag such as ``-coverage``

``FCOPT_COVERAGE``
  The Fortran compiler's coverage flag or empty if not supported

``FC_ALLOWS_PROFILE_ARCS``
  "True" if the Fortran compiler supports a profile arcs flag such as ``-fprofile-arcs``

``FCOPT_PROFILE_ARCS``
  The Fortran compiler's profile arcs flag or empty if not supported

``FC_ALLOWS_TEST_COVERAGE``
  "True" if the Fortran compiler supports a test coverage flag such as ``-ftest-coverage``

``FCOPT_TEST_COVERAGE``
  The Fortran compiler's test coverage flag or empty if not supported

Example usage:

.. code-block:: cmake

  include(FortranHelper)
#]=======================================================================]

# Detect available Fortran compiler options
include(CheckFortranCompilerFlag)

# Set variable name fcopt_name to $fc_flag and fcopt_allowed to 1 (True)
# if $fc_flag is a legal, quiet option to the Fortran compiler
function(set_fcopt fcopt_allowed fcopt_name fc_flag)
    check_fortran_compiler_flag("${fc_flag}" ${fcopt_allowed})
    if(${${fcopt_allowed}})
        set(${fcopt_name} "${fc_flag}" PARENT_SCOPE)
    else()
        set(${fcopt_name} "" PARENT_SCOPE)
    endif()
endfunction()

# Note: These are all biased toward gfortran. Avoid explicit compiler
# detection and prefer capability detection.

# Set option flag visibility and values
set_fcopt(FC_ALLOWS_NO_OPTIMIZATION FCOPT_NO_OPTIMIZATION "-O0")
set_fcopt(FC_ALLOWS_DEBUG_OPTIMIZATION FCOPT_DEBUG_OPTIMIZATION "-Og")
set_fcopt(FC_ALLOWS_STD_LEGACY FCOPT_STD_LEGACY "--std=legacy")
set_fcopt(FC_ALLOWS_WALL FCOPT_WALL "-Wall")
set_fcopt(FC_ALLOWS_BACKTRACE FCOPT_BACKTRACE "-fbacktrace")
set_fcopt(FC_ALLOWS_DEBUG FCOPT_DEBUG "-g")
set_fcopt(FC_ALLOWS_SAVE FCOPT_SAVE "-fno-automatic")
set_fcopt(FC_ALLOWS_FCHECKALL FCOPT_FCHECKALL "-fcheck=all")

set_fcopt(FC_ALLOWS_STD_F2008 FCOPT_STD_F2008 "--std=f2008")
set_fcopt(FC_ALLOWS_STD_F2018 FCOPT_STD_F2018 "--std=f2018")

# Code coverage options - experimental
set_fcopt(FC_ALLOWS_COVERAGE FCOPT_COVERAGE "--coverage")
set_fcopt(FC_ALLOWS_PROFILE_ARCS FCOPT_PROFILE_ARCS "-fprofile-arcs")
set_fcopt(FC_ALLOWS_TEST_COVERAGE FCOPT_TEST_COVERAGE "-ftest-coverage")

# Add Fortran_MODULE_DIRECTORY for each Fortran library included in a
# target
function(link_fortran_libraries my_target)
    target_link_libraries(${my_target} ${ARGN})
    foreach(f_lib IN LISTS ARGN)
        target_include_directories(${my_target} PUBLIC $<TARGET_PROPERTY:${f_lib},Fortran_MODULE_DIRECTORY>)
    endforeach()
endfunction()