!> @file ut_null.f90
!! @author Bob Apthorpe
!! @copyright See LICENSE
!! @brief Null unit test to verify TOAST library is properly linked

!> @brief Null unit test to verify TOAST library is properly linked
program ut_null
    use, intrinsic :: iso_fortran_env, only: WP => REAL64,              &
        stdout=>OUTPUT_UNIT
    use, intrinsic :: iso_c_binding, only: c_null_ptr
    use :: toast
    use :: lua
    implicit none

    integer :: id
    type(TestCase) :: test

    continue

    call test%init(name="ut_null")

    !!! Test exposed functions

    id = lua_version(c_null_ptr)
    write(unit=stdout, fmt='(A, I8)') "Lua version ", id
    call test%asserttrue(id > 0, message="lua_version() > 0")

    ! Print summary at the end
    call printsummary(test)
    call jsonwritetofile(test, "ut_null.json")

    call test%checkfailure()
end program ut_null
