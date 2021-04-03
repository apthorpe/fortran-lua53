!> @file ut_tablecheck.f90
!! @author Bob Apthorpe
!! @copyright See LICENSE
!! @brief Table operation unit test

!! @brief Table operation unit test
program ut_tablecheck
    use, intrinsic :: iso_fortran_env, only: WP => REAL64, INT64,       &
        stdout => OUTPUT_UNIT
    use, intrinsic :: iso_c_binding, only: c_ptr
    use :: lua
    use :: toast
    implicit none

    ! Lua state object
    type(c_ptr) :: l

    character(len=32) :: fname

    integer :: nstack
    integer :: rc
    logical :: tf

    integer(kind=INT64) :: ival
    real(kind=WP) :: dval

    type(TestCase) :: test

! 10  format(A)
! 20  format(A, I4)
    continue

    call test%init(name="ut_tablecheck")

    !!! Test exposed functions

    l = lual_newstate()
    call lual_openlibs(l)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack at start")

    ! lua_dofile() success
    fname = 'tablecheck.lua'
    rc = lual_dofile(l, trim(fname))

    call test%assertequal(rc, 0, message="Success (0) loading " // trim(fname))

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after lua_dofile()")

    ! gv1 = {}; empty table
    rc = lua_getglobal(l, 'gv1')
    call test%assertequal(rc, LUA_TTABLE, message="gv1 is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv1) is .true.")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv1 test")

    ! -- gv2a is an integer array
    ! gv2a = { 5, 4, 3, 2, 1 }
    rc = lua_getglobal(l, 'gv2a')
    call test%assertequal(rc, LUA_TTABLE, message="gv2a is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv2a) is .true.")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv2a test")

    ! -- gv2b is an integer array identical to gv2a
    ! gv2b = { 5; 4; 3; 2; 1 }
    rc = lua_getglobal(l, 'gv2b')
    call test%assertequal(rc, LUA_TTABLE, message="gv2b is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv2b) is .true.")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv2b test")

    ! -- gv2c is an integer array identical to gv2a
    ! gv2c = { 5, 4; 3; 2, 1; }
    rc = lua_getglobal(l, 'gv2c')
    call test%assertequal(rc, LUA_TTABLE, message="gv2c is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv2c) is .true.")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv2c test")

    ! -- gv2d is an integer array identical to gv2a
    ! gv2d = { 5; 4; 3, 2, 1, }
    rc = lua_getglobal(l, 'gv2d')
    call test%assertequal(rc, LUA_TTABLE, message="gv2d is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv2d) is .true.")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv2d test")

    ! -- gv3a is a dict
    ! gv3a = { ["a"] = 5, ["b"] = 4, ["b"] = 3, ["d"] = 2, ["e"] = 1 }
    rc = lua_getglobal(l, 'gv3a')
    call test%assertequal(rc, LUA_TTABLE, message="gv3a is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv3a) is .true.")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv3a test")

    ! -- gv3b is a dict identical to gv3a
    ! gv3b = { a = 5, b = 4, b = 3, d = 2, e = 1 }
    rc = lua_getglobal(l, 'gv3b')
    call test%assertequal(rc, LUA_TTABLE, message="gv3b is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv3b) is .true.")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv3b test")

    ! ! -- gv3c is a dict identical to gv3a
    ! ! gv3c = { ["a"] = 5, b = 4; "c" = 3, d = 2; ["e"] = 1; }
    ! rc = lua_getglobal(l, 'gv3c')
    ! call test%assertequal(rc, LUA_TTABLE, message="gv3c is type LUA_TTABLE")
    ! tf = lua_istable(l, -1)
    ! call test%asserttrue(tf, message="lua_istable(gv3c) is .true.")
    ! call lua_pop(l, 1)

    ! nstack = lua_gettop(l)
    ! call test%assertequal(nstack, 0, message="Expect empty stack after gv3c test")

    ! Close the interpreter

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after all tests")

    call lua_close(l)

    ! Print summary at the end
    call printsummary(test)
    call jsonwritetofile(test, "ut_tablecheck.json")

    call test%checkfailure()
end program ut_tablecheck
