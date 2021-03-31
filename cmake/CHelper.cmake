# Distributed under the OSI-approved MIT License.  See accompanying
# file LICENSE for details.

#[=======================================================================[.rst:
CHelper
---------

Interrogate the C compiler to see if it supports specific options.

The module defines the following function:

``set_ccopt(ccopt_allowed ccopt_name cc_flag)``
  If ``cc_flag`` is accepted by the C compiler, ``ccopt_allowed`` is set
  to "True" and ``ccopt_name`` is set to ``cc_flag``. Otherwise
  ``ccopt_allowed`` is set to "False" and ``ccopt_name`` is empty.

The module defines the following variables:

``CC_ALLOWS_NO_OPTIMIZATION``
  "True" if the C compiler supports a no optimization flag such as ``-O0``

``CCOPT_NO_OPTIMIZATION``
  The C compiler's no optimization flag or empty if not supported

``CC_ALLOWS_DEBUG_OPTIMIZATION``
  "True" if the C compiler supports a debug optimization flag such as ``-Og``

``CCOPT_DEBUG_OPTIMIZATION``
  The C compiler's debug optimization flag or empty if not supported

``CC_ALLOWS_WALL ``
  "True" if the C compiler supports a warn=all flag such as ``-Wall``

``CCOPT_WALL``
  The C compiler's warn=all flag or empty if not supported

``CC_ALLOWS_DEBUG``
  "True" if the C compiler supports a debug flag such as ``-g``

``CCOPT_DEBUG``
  The C compiler's debug flag or empty if not supported

``CC_ALLOWS_COVERAGE``
  "True" if the C compiler supports a coverage flag such as ``-coverage``

``CCOPT_COVERAGE``
  The C compiler's coverage flag or empty if not supported

``CC_ALLOWS_PROFILE_ARCS``
  "True" if the C compiler supports a profile arcs flag such as ``-fprofile-arcs``

``CCOPT_PROFILE_ARCS``
  The C compiler's profile arcs flag or empty if not supported

``CC_ALLOWS_TEST_COVERAGE``
  "True" if the C compiler supports a test coverage flag such as ``-ftest-coverage``

``CCOPT_TEST_COVERAGE``
  The C compiler's test coverage flag or empty if not supported

Example usage:

.. code-block:: cmake

  include(CHelper)
#]=======================================================================]

# Detect available C compiler options
include(CheckCCompilerFlag)

# Set variable name fcopt_name to $fc_flag and fcopt_allowed to 1 (True)
# if $fc_flag is a legal, quiet option to the C compiler
function(set_ccopt ccopt_allowed ccopt_name cc_flag)
    check_c_compiler_flag("${cc_flag}" ${ccopt_allowed})
    if(${${ccopt_allowed}})
        set(${ccopt_name} "${cc_flag}" PARENT_SCOPE)
    else()
        set(${ccopt_name} "" PARENT_SCOPE)
    endif()
endfunction()

# Note: These are all biased toward gcc. Avoid explicit compiler
# detection and prefer capability detection.

# Set option flag visibility and values
set_fcopt(CC_ALLOWS_NO_OPTIMIZATION CCOPT_NO_OPTIMIZATION "-O0")
set_fcopt(CC_ALLOWS_DEBUG_OPTIMIZATION CCOPT_DEBUG_OPTIMIZATION "-Og")
set_fcopt(CC_ALLOWS_WALL CCOPT_WALL "-Wall")
# set_fcopt(CC_ALLOWS_BACKTRACE CCOPT_BACKTRACE "-fbacktrace")
set_fcopt(CC_ALLOWS_DEBUG CCOPT_DEBUG "-g")

# Code coverage options - experimental
set_CCopt(CC_ALLOWS_COVERAGE CCOPT_COVERAGE "--coverage")
set_CCopt(CC_ALLOWS_PROFILE_ARCS CCOPT_PROFILE_ARCS "-fprofile-arcs")
set_CCopt(CC_ALLOWS_TEST_COVERAGE CCOPT_TEST_COVERAGE "-ftest-coverage")

