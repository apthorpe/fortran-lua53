!> @file ut_null.f90
!! @author Bob Apthorpe
!! @copyright See LICENSE
!! @brief Null unit test to verify TOAST library is properly linked

!> @brief Null unit test to verify TOAST library is properly linked
program ut_null
    use, intrinsic :: iso_fortran_env, only: WP => REAL64
    use toast
    implicit none

    real(kind=WP) :: refval
    integer :: i
    integer :: id
    type(TestCase) :: test

    continue

    call test%init(name="ut_null")

    !!! Test exposed functions

    ! 1) TBD

    ! Print summary at the end
    call printsummary(test)
    call jsonwritetofile(test, "ut_null.json")

    call test%checkfailure()
end program ut_null
