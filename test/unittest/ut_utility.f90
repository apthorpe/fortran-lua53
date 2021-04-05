!> @file ut_utility.f90
!! @author Bob Apthorpe
!! @copyright See LICENSE
!! @brief Test of miscellaneous Lua C API functions

!! @brief Test of miscellaneous Lua C API functions
program ut_utility
    use, intrinsic :: iso_fortran_env, only: WP => REAL64, INT64,       &
        stdout => OUTPUT_UNIT
    use, intrinsic :: iso_c_binding, only: c_ptr, c_associated,         &
        c_null_ptr
    use :: lua
    use :: toast
    implicit none

    ! Lua state object
    type(c_ptr) :: l

    character(len=32) :: fname

    integer :: nstack
    integer :: rc
    logical :: tf
    integer(kind=INT64) :: tlength
    ! integer(kind=INT64) :: version

    type(c_ptr) :: misc_ptr
    integer(kind=INT64) :: ival
    real(kind=WP) :: dval
    character(len=:), allocatable :: cval

    type(TestCase) :: test

! 10  format(A)
! 20  format(A, I4)
    continue

    call test%init(name="ut_utility")

    !!! Test exposed functions

    l = lual_newstate()
    call test%asserttrue(c_associated(l), message="Expect pointer to Lua state")

    call lual_openlibs(l)

    ! Check that version is at least 5.3 (503)
    call test%asserttrue(lua_version(l) >= 503_INT64, message="Expect empty stack at start")

    ! Not implemented (weird macro stuff in lua.h, luaconf.h)
    ! misc_ptr = c_null_ptr
    ! misc_ptr = lua_getextraspace(l)
    ! call test%asserttrue(c_associated(misc_ptr), message="Got pointer to Lua Mystery Space")
    ! misc_ptr = c_null_ptr

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack at start")

    ! ! lua_dofile() success
    ! fname = 'utility.lua'
    ! rc = lual_dofile(l, trim(fname))

    ! call test%assertequal(rc, 0, message="Success (0) loading " // trim(fname))

    ! nstack = lua_gettop(l)
    ! call test%assertequal(nstack, 0, message="Expect empty stack after lua_dofile()")




    ! Close the interpreter

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after all tests")

    call lua_close(l)

    ! Q: Should l be c_null_ptr once it's closed?
!    call test%assertfalse(c_associated(l), message="Expect null pointer after closeing Lua state")

    ! Print summary at the end
    call printsummary(test)
    call jsonwritetofile(test, "ut_utility.json")

    call test%checkfailure()
end program ut_utility
