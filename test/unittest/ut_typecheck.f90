!> @file ut_typecheck.f90
!! @author Bob Apthorpe
!! @copyright See LICENSE
!! @brief Type detection unit test

!! @brief Type detection unit test
program ut_typecheck
    use, intrinsic :: iso_fortran_env, only: WP => REAL64, INT64,       &
        stdout => OUTPUT_UNIT
    use, intrinsic :: iso_c_binding, only: c_ptr
    use :: lua
    use :: toast
    implicit none

    ! Lua state object
    type(c_ptr) :: l
    integer     :: nargs    = 1
    integer     :: nresults = 2
    integer     :: rc
    integer     :: r1, r2   = 0
    integer     :: x        = 10

    character(len=32) :: fname

    logical :: tf
    logical :: is_fn

    integer(kind=INT64) :: igv1
    real(kind=WP) :: dgv2
    ! integer :: id
    type(TestCase) :: test

! 10  format(A)
! 20  format(A, I4)
    continue

    call test%init(name="ut_typecheck")

    !!! Test exposed functions

    l = lual_newstate()
    call lual_openlibs(l)

    ! lua_dofile() success
    fname = 'typecheck.lua'
    rc = lual_dofile(l, trim(fname))

    call test%assertequal(rc, 0, message="Success (0) loading " // trim(fname))

    ! gv1 = -12
    rc = lua_getglobal(l, 'gv1')
    call test%assertequal(rc, LUA_TNUMBER, message="gv1 is type LUA_TNUMBER")
    rc = lua_isnumber(l, -1)
    call test%assertequal(rc, 1, message="lua_isnumber(gv1) is 1")
    rc = lua_isinteger(l, -1)
    call test%assertequal(rc, 1, message="lua_isinteger(gv1) is 1")
    igv1 = lua_tointeger(l, -1)
    call test%assertequal(igv1, -12_INT64, message="lua_tointeger(gv1) == -12_INT64")

    ! gv2 = 0.25
    rc = lua_getglobal(l, 'gv2')
    call test%assertequal(rc, LUA_TNUMBER, message="gv2 is type LUA_TNUMBER")
    rc = lua_isnumber(l, -1)
    call test%assertequal(rc, 1, message="lua_isnumber(gv2) is 1")
    rc = lua_isinteger(l, -1)
    call test%assertequal(rc, 0, message="lua_isinteger(gv2) is 0")
    dgv2 = lua_tonumber(l, -1)
    call test%assertequal(dgv2, 0.25_WP, message="lua_tonumber(gv2) == 0.25_REAL64")
    ! write(unit=stdout, fmt="(A, ES18.11)") "gv2 = ", dgv2

    ! gv3 = "parfait"
    rc = lua_getglobal(l, 'gv3')
    call test%assertequal(rc, LUA_TSTRING, message="gv3 is type LUA_TSTRING")

    ! gv4 = {}
    rc = lua_getglobal(l, 'gv4')
    call test%assertequal(rc, LUA_TTABLE, message="gv4 is type LUA_TTABLE")

    ! gv5 = function () print("parfait") end
    rc = lua_getglobal(l, 'gv5')
    call test%assertequal(rc, LUA_TFUNCTION, message="gv5 is type LUA_TFUNCTION)")
    tf = lua_isfunction(l, -1)
    call test%asserttrue(tf, message="lua_isfunction(gv5) is .true.")
    rc = lua_iscfunction(l, -1)
    call test%assertequal(rc, 0, message="lua_iscfunction(gv5) is 0")

    ! gv6 = false
    rc = lua_getglobal(l, 'gv6')
    call test%assertequal(rc, LUA_TBOOLEAN, message="gv6 is type LUA_TBOOLEAN")
    tf = lua_isboolean(l, -1)
    call test%asserttrue(tf, message="lua_boolean(gv6) is .true.")

    ! gv7 = nil
    rc = lua_getglobal(l, 'gv7')
    call test%assertequal(rc, LUA_TNIL, message="gv7 is type LUA_TNIL)")

    ! gv8 is not defined
    rc = lua_getglobal(l, 'gv8')
    call test%assertequal(rc, LUA_TNIL, message="Failure finding global name 'gv8' (type is LUA_TNIL)")

    ! is_fn = lua_isfunction(l, -1)
    ! call test%asserttrue(is_fn, message="Success from lua_isfunction - fib is a function")

    ! if (is_fn) then
    !     x = 10
    !     call lua_pushinteger(l, x)

    !     nargs = 1
    !     nresults = 2

    !     rc = lua_pcall(l, nargs, nresults, 0)
    !     call test%assertequal(rc, LUA_OK, message="Successful call (status is LUA_OK)")

    !     r1 = lua_tointeger(l, -1)
    !     call test%assertequal(r1, 34, message="Successfully calculated fib prev (r1 = 34)")

    !     r2 = lua_tointeger(l, -2)
    !     call test%assertequal(r2, 55, message="Successfully calculated fib curr (r2 = 55)")

    !     call lua_pop(l, 2)

    !     ! print '("fibonacci(", i0, ") = ", i0)', x, r2
    ! end if

    call lua_close(l)

    ! Print summary at the end
    call printsummary(test)
    call jsonwritetofile(test, "ut_typecheck.json")

    call test%checkfailure()
end program ut_typecheck
