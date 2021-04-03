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

    character(len=32) :: fname
    character(len=:), allocatable :: tname

    integer :: nstack
    integer :: rc
    logical :: tf

    integer(kind=INT64) :: ival
    real(kind=WP) :: dval

    type(TestCase) :: test

! 10  format(A)
! 20  format(A, I4)
    continue

    call test%init(name="ut_typecheck")

    !!! Test exposed functions

    l = lual_newstate()
    call lual_openlibs(l)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack at start")

    ! lua_dofile() success
    fname = 'typecheck.lua'
    rc = lual_dofile(l, trim(fname))

    call test%assertequal(rc, 0, message="Success (0) loading " // trim(fname))

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after lua_dofile()")

    ! gv1 = -12
    rc = lua_getglobal(l, 'gv1')
    call test%assertequal(rc, LUA_TNUMBER, message="gv1 is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv1) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv1) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, -12_INT64, message="lua_tointeger(gv1) == -12_INT64")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv1 test")

    ! gv2 = 0.25
    rc = lua_getglobal(l, 'gv2')
    call test%assertequal(rc, LUA_TNUMBER, message="gv2 is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2) is .true.")
    tf = lua_isinteger(l, -1)
    call test%assertfalse(tf, message="lua_isinteger(gv2) is .false.")
    dval = lua_tonumber(l, -1)
    call test%assertequal(dval, 0.25_WP, message="lua_tonumber(gv2) == 0.25_REAL64")
    ! write(unit=stdout, fmt="(A, ES18.11)") "gv2 = ", dval
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv2 test")

    ! gv3 = "parfait"
    rc = lua_getglobal(l, 'gv3')
    call test%assertequal(rc, LUA_TSTRING, message="gv3 is type LUA_TSTRING")
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message="lua_isstring(gv3) is .true.")
    tname = lual_typename(l, -1)
    call test%assertequal(tname, "string", message='gv3 typename is "string"')
    ! write(unit=stdout, fmt='(A)') "gv3 is of type " // lual_typename(l, -1)
    ! "gv3 is of type string"
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv3 test")

    ! gv4 = {}
    rc = lua_getglobal(l, 'gv4')
    call test%assertequal(rc, LUA_TTABLE, message="gv4 is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv4) is .true.")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv4 test")

    ! gv5 = function () print("parfait") end
    rc = lua_getglobal(l, 'gv5')
    call test%assertequal(rc, LUA_TFUNCTION, message="gv5 is type LUA_TFUNCTION)")
    tf = lua_isfunction(l, -1)
    call test%asserttrue(tf, message="lua_isfunction(gv5) is .true.")
    tf = lua_iscfunction(l, -1)
    call test%assertfalse(tf, message="lua_iscfunction(gv5) is .false.")

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 1, message="Expect 1 element (function, no args) before gv5 call")

    rc = lua_pcall(L=l, nargs=0, nresults=0, msgh=0)
    call test%assertequal(rc, LUA_OK, message="Successful call (status is LUA_OK)")

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv5 test")

    ! gv6 = false
    rc = lua_getglobal(l, 'gv6')
    call test%assertequal(rc, LUA_TBOOLEAN, message="gv6 is type LUA_TBOOLEAN")
    tf = lua_isboolean(l, -1)
    call test%asserttrue(tf, message="lua_isboolean(gv6) is .true.")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv6 test")

    ! gv7 = nil
    rc = lua_getglobal(l, 'gv7')
    call test%assertequal(rc, LUA_TNIL, message="gv7 is type LUA_TNIL)")
    tf = lua_isnil(l, -1)
    call test%asserttrue(tf, message="lua_isnil(gv7) is .true.")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv7 test")

    ! gv8 is not defined
    rc = lua_getglobal(l, 'gv8')
    call test%assertequal(rc, LUA_TNIL, message="Failure finding global name 'gv8' (type is LUA_TNIL)")
    tf = lua_isnil(l, -1)
    call test%asserttrue(tf, message="lua_isnil(gv8) is .true.")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv8 test")

    ! gv9 = -0.5
    rc = lua_getglobal(l, 'gv9')
    call test%assertequal(rc, LUA_TSTRING, message="gv9 is type LUA_TSTRING")
    call test%assertfalse((rc == LUA_TNUMBER), message="gv10 is not type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv9) is .true.")
    tf = lua_isinteger(l, -1)
    call test%assertfalse(tf, message="lua_isinteger(gv9) is .false.")
    dval = lua_tonumber(l, -1)
    call test%assertequal(dval, -0.5_WP, message="lua_tonumber(gv9) == -0.5_REAL64")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 0_INT64, message="lua_tointeger(gv9) == 0_INT64 (truncated)")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv9 test")

    ! gv10 = 7
    rc = lua_getglobal(l, 'gv10')
    call test%assertequal(rc, LUA_TSTRING, message="gv10 is type LUA_TSTRING")
    call test%assertfalse((rc == LUA_TNUMBER), message="gv10 is not type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv10) is .true.")
    tf = lua_isinteger(l, -1)
    call test%assertfalse(tf, message="lua_isinteger(gv10) is .false. [This is somewhat counterintuitive]")
    dval = lua_tonumber(l, -1)
    call test%assertequal(dval, 7.0_WP, message="lua_tonumber(gv10) == 7.0_REAL64")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 7_INT64, message="lua_tointeger(gv10) == 7_INT64")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv10 test")

    ! gv11 = 262.0000
    rc = lua_getglobal(l, 'gv11')
    call test%assertequal(rc, LUA_TSTRING, message="gv11 is type LUA_TSTRING")
    call test%assertfalse((rc == LUA_TNUMBER), message="gv11 is not type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv11) is .true.")
    tf = lua_isinteger(l, -1)
    call test%assertfalse(tf, message="lua_isinteger(gv11) is .false.")
    dval = lua_tonumber(l, -1)
    call test%assertequal(dval, 262.0_WP, message="lua_tonumber(gv11) == 262.0_REAL64")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 262_INT64, message="lua_tointeger(gv11) == 262_INT64")
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv11 test")

    ! gv12 = function fib(n)
    rc = lua_getglobal(l, 'gv12')
    call test%assertequal(rc, LUA_TFUNCTION, message="gv12 is type LUA_TFUNCTION)")
    tf = lua_isfunction(l, -1)
    call test%asserttrue(tf, message="lua_isfunction(gv12) is .true.")
    tf = lua_iscfunction(l, -1)
    call test%assertfalse(tf, message="lua_iscfunction(gv12) is .false.")

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 1, message="Expect one value (function) on stack before pushing argument")

    ! Push function argument (11) to stack
    call lua_pushinteger(l, 11)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 2, message="Expect two values (function + arg) before gv12 call")

    rc = lua_pcall(L=l, nargs=1, nresults=2, msgh=0)
    call test%assertequal(rc, LUA_OK, message="Successful call (status is LUA_OK)")

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 2, message="Expect two return values after gv12 call")

    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 55_INT64, message="Successfully calculated fib prev (r1 = 55)")
    ival = lua_tointeger(l, -2)
    call test%assertequal(ival, 89_INT64, message="Successfully calculated fib curr (r2 = 89)")
    call lua_pop(l, 2)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv12 test")

    ! Close the interpreter

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after all tests")

    call lua_close(l)

    ! Print summary at the end
    call printsummary(test)
    call jsonwritetofile(test, "ut_typecheck.json")

    call test%checkfailure()
end program ut_typecheck
