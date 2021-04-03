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
    character(len=:), allocatable :: cval

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

    ! gv2a[5] == 1
    rc = lua_geti(l, -1, 5_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2a[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2a[5]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2a[5]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 1_INT64, message="lua_tointeger(gv2a[5]) == 1_INT64")
    call lua_pop(l, 1)

    ! gv2a[4] == 2
    rc = lua_geti(l, -1, 4_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2a[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2a[4]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2a[4]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 2_INT64, message="lua_tointeger(gv2a[4]) == 2_INT64")
    call lua_pop(l, 1)

    ! gv2a[3] == 3
    rc = lua_geti(l, -1, 3_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2a[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2a[3]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2a[3]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 3_INT64, message="lua_tointeger(gv2a[3]) == 3_INT64")
    call lua_pop(l, 1)

    ! gv2a[2] == 4
    rc = lua_geti(l, -1, 2_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2a[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2a[2]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2a[2]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 4_INT64, message="lua_tointeger(gv2a[2]) == 4_INT64")
    call lua_pop(l, 1)

    ! gv2a[1] == 5
    rc = lua_geti(l, -1, 1_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2a[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2a[1]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2a[1]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 5_INT64, message="lua_tointeger(gv2a[1]) == 5_INT64")
    call lua_pop(l, 1)

    ! gv2a[6] == nil
    rc = lua_geti(l, -1, 6_INT64)
    call test%assertequal(rc, LUA_TNIL, message="gv2a[6] is type LUA_TNIL")
    tf = lua_isnil(l, -1)
    call test%asserttrue(tf, message="lua_isnil(gv2a[6]) is .true.")
    tf = lua_isnumber(l, -1)
    call test%assertfalse(tf, message="lua_isnumber(gv2a[6]) is .false.")
    call lua_pop(l, 1)

    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv2a test")

    ! -- gv2b is an integer array identical to gv2a
    ! gv2b = { 5; 4; 3; 2; 1 }
    rc = lua_getglobal(l, 'gv2b')
    call test%assertequal(rc, LUA_TTABLE, message="gv2b is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv2b) is .true.")

    ! gv2b[5] == 1
    rc = lua_geti(l, -1, 5_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2b[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2b[5]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2b[5]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 1_INT64, message="lua_tointeger(gv2b[5]) == 1_INT64")
    call lua_pop(l, 1)

    ! gv2b[4] == 2
    rc = lua_geti(l, -1, 4_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2b[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2b[4]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2b[4]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 2_INT64, message="lua_tointeger(gv2b[4]) == 2_INT64")
    call lua_pop(l, 1)

    ! gv2b[3] == 3
    rc = lua_geti(l, -1, 3_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2b[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2b[3]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2b[3]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 3_INT64, message="lua_tointeger(gv2b[3]) == 3_INT64")
    call lua_pop(l, 1)

    ! gv2b[2] == 4
    rc = lua_geti(l, -1, 2_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2b[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2b[2]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2b[2]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 4_INT64, message="lua_tointeger(gv2b[2]) == 4_INT64")
    call lua_pop(l, 1)

    ! gv2b[1] == 5
    rc = lua_geti(l, -1, 1_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2b[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2b[1]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2b[1]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 5_INT64, message="lua_tointeger(gv2b[1]) == 5_INT64")
    call lua_pop(l, 1)

    ! gv2b[6] == nil
    rc = lua_geti(l, -1, 6_INT64)
    call test%assertequal(rc, LUA_TNIL, message="gv2b[6] is type LUA_TNIL")
    tf = lua_isnil(l, -1)
    call test%asserttrue(tf, message="lua_isnil(gv2b[6]) is .true.")
    tf = lua_isnumber(l, -1)
    call test%assertfalse(tf, message="lua_isnumber(gv2b[6]) is .false.")
    call lua_pop(l, 1)

    ! Remove table gv2b from stack
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv2b test")

    ! -- gv2c is an integer array identical to gv2a
    ! gv2c = { 5, 4; 3; 2, 1; }
    rc = lua_getglobal(l, 'gv2c')
    call test%assertequal(rc, LUA_TTABLE, message="gv2c is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv2c) is .true.")

    ! gv2c[5] == 1
    rc = lua_geti(l, -1, 5_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2c[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2c[5]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2c[5]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 1_INT64, message="lua_tointeger(gv2c[5]) == 1_INT64")
    call lua_pop(l, 1)

    ! gv2c[4] == 2
    rc = lua_geti(l, -1, 4_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2c[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2c[4]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2c[4]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 2_INT64, message="lua_tointeger(gv2c[4]) == 2_INT64")
    call lua_pop(l, 1)

    ! gv2c[3] == 3
    rc = lua_geti(l, -1, 3_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2c[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2c[3]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2c[3]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 3_INT64, message="lua_tointeger(gv2c[3]) == 3_INT64")
    call lua_pop(l, 1)

    ! gv2c[2] == 4
    rc = lua_geti(l, -1, 2_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2c[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2c[2]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2c[2]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 4_INT64, message="lua_tointeger(gv2c[2]) == 4_INT64")
    call lua_pop(l, 1)

    ! gv2c[1] == 5
    rc = lua_geti(l, -1, 1_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2c[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2c[1]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2c[1]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 5_INT64, message="lua_tointeger(gv2c[1]) == 5_INT64")
    call lua_pop(l, 1)

    ! gv2c[6] == nil
    rc = lua_geti(l, -1, 6_INT64)
    call test%assertequal(rc, LUA_TNIL, message="gv2c[6] is type LUA_TNIL")
    tf = lua_isnil(l, -1)
    call test%asserttrue(tf, message="lua_isnil(gv2c[6]) is .true.")
    tf = lua_isnumber(l, -1)
    call test%assertfalse(tf, message="lua_isnumber(gv2c[6]) is .false.")
    call lua_pop(l, 1)

    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv2c test")

    ! -- gv2d is an integer array identical to gv2a
    ! gv2d = { 5; 4; 3, 2, 1, }
    rc = lua_getglobal(l, 'gv2d')
    call test%assertequal(rc, LUA_TTABLE, message="gv2d is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv2d) is .true.")

    ! gv2d[5] == 1
    rc = lua_geti(l, -1, 5_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2d[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2d[5]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2d[5]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 1_INT64, message="lua_tointeger(gv2d[5]) == 1_INT64")
    call lua_pop(l, 1)

    ! gv2d[4] == 2
    rc = lua_geti(l, -1, 4_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2d[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2d[4]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2d[4]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 2_INT64, message="lua_tointeger(gv2d[4]) == 2_INT64")
    call lua_pop(l, 1)

    ! gv2d[3] == 3
    rc = lua_geti(l, -1, 3_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2d[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2d[3]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2d[3]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 3_INT64, message="lua_tointeger(gv2d[3]) == 3_INT64")
    call lua_pop(l, 1)

    ! gv2d[2] == 4
    rc = lua_geti(l, -1, 2_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2d[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2d[2]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2d[2]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 4_INT64, message="lua_tointeger(gv2d[2]) == 4_INT64")
    call lua_pop(l, 1)

    ! gv2d[1] == 5
    rc = lua_geti(l, -1, 1_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv2d[5] is type LUA_TNUMBER")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv2d[1]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message="lua_isinteger(gv2d[1]) is .true.")
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 5_INT64, message="lua_tointeger(gv2d[1]) == 5_INT64")
    call lua_pop(l, 1)

    ! gv2d[6] == nil
    rc = lua_geti(l, -1, 6_INT64)
    call test%assertequal(rc, LUA_TNIL, message="gv2d[6] is type LUA_TNIL")
    tf = lua_isnil(l, -1)
    call test%asserttrue(tf, message="lua_isnil(gv2d[6]) is .true.")
    tf = lua_isnumber(l, -1)
    call test%assertfalse(tf, message="lua_isnumber(gv2d[6]) is .false.")
    call lua_pop(l, 1)

    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv2d test")

    ! -- gv3a is a dict
    ! gv3a = { ["a"] = 5, ["b"] = 4, ["b"] = 3, ["d"] = 2, ["e"] = 1 }
    rc = lua_getglobal(l, 'gv3a')
    call test%assertequal(rc, LUA_TTABLE, message="gv3a is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv3a) is .true.")

    ! gv3a["a"] == 5
    rc = lua_getfield(l, -1, "a")
    call test%assertequal(rc, LUA_TNUMBER, message='gv3a["a"] is type LUA_TNUMBER')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv3a["a"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv3a["a"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 5_INT64, message='lua_tointeger(gv3a["a"]) == 5_INT64')
    call lua_pop(l, 1)

    ! gv3a["d"] == 2
    rc = lua_getfield(l, -1, "d")
    call test%assertequal(rc, LUA_TNUMBER, message='gv3a["d"] is type LUA_TNUMBER')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv3a["d"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv3a["d"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 2_INT64, message='lua_tointeger(gv3a["d"]) == 2_INT64')
    call lua_pop(l, 1)

    ! gv3a["b"] == 4
    rc = lua_getfield(l, -1, "b")
    call test%assertequal(rc, LUA_TNUMBER, message='gv3a["b"] is type LUA_TNUMBER')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv3a["b"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv3a["b"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 4_INT64, message='lua_tointeger(gv3a["b"]) == 4_INT64')
    call lua_pop(l, 1)

    ! gv3a["e"] == 1
    rc = lua_getfield(l, -1, "e")
    call test%assertequal(rc, LUA_TNUMBER, message='gv3a["e"] is type LUA_TNUMBER')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv3a["e"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv3a["e"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 1_INT64, message='lua_tointeger(gv3a["e"]) == 1_INT64')
    call lua_pop(l, 1)

    ! gv3a["underpants gnomes"] == 1
    rc = lua_getfield(l, -1, "underpants gnomes")
    call test%assertequal(rc, LUA_TNIL, message='gv3a["underpants gnomes"] is type LUA_TNIL')
    tf = lua_isnil(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv3a["underpants gnomes"]) is .true.')
    tf = lua_isnumber(l, -1)
    call test%assertfalse(tf, message='lua_isnumber(gv3a["underpants gnomes"]) is .false.')
    call lua_pop(l, 1)

    ! gv3a["c"] == 3
    rc = lua_getfield(l, -1, "c")
    call test%assertequal(rc, LUA_TNUMBER, message='gv3a["c"] is type LUA_TNUMBER')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv3a["c"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv3a["c"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 3_INT64, message='lua_tointeger(gv3a["c"]) == 3_INT64')
    call lua_pop(l, 1)

    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv3a test")

    ! -- gv3b is a dict identical to gv3a
    ! gv3b = { a = 5, b = 4, b = 3, d = 2, e = 1 }
    rc = lua_getglobal(l, 'gv3b')
    call test%assertequal(rc, LUA_TTABLE, message="gv3b is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv3b) is .true.")

    ! gv3b["a"] == 5
    rc = lua_getfield(l, -1, "a")
    call test%assertequal(rc, LUA_TNUMBER, message='gv3b["a"] is type LUA_TNUMBER')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv3b["a"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv3b["a"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 5_INT64, message='lua_tointeger(gv3b["a"]) == 5_INT64')
    call lua_pop(l, 1)

    ! gv3b["d"] == 2
    rc = lua_getfield(l, -1, "d")
    call test%assertequal(rc, LUA_TNUMBER, message='gv3b["d"] is type LUA_TNUMBER')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv3b["d"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv3b["d"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 2_INT64, message='lua_tointeger(gv3b["d"]) == 2_INT64')
    call lua_pop(l, 1)

    ! gv3b["b"] == 4
    rc = lua_getfield(l, -1, "b")
    call test%assertequal(rc, LUA_TNUMBER, message='gv3b["b"] is type LUA_TNUMBER')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv3b["b"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv3b["b"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 4_INT64, message='lua_tointeger(gv3b["b"]) == 4_INT64')
    call lua_pop(l, 1)

    ! gv3b["e"] == 1
    rc = lua_getfield(l, -1, "e")
    call test%assertequal(rc, LUA_TNUMBER, message='gv3b["e"] is type LUA_TNUMBER')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv3b["e"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv3b["e"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 1_INT64, message='lua_tointeger(gv3b["e"]) == 1_INT64')
    call lua_pop(l, 1)

    ! gv3b['"'] == 1
    rc = lua_getfield(l, -1, '"')
    call test%assertequal(rc, LUA_TNIL, message='gv3b["underpants gnomes"] is type LUA_TNIL')
    tf = lua_isnil(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv3b["underpants gnomes"]) is .true.')
    tf = lua_isnumber(l, -1)
    call test%assertfalse(tf, message='lua_isnumber(gv3b["underpants gnomes"]) is .false.')
    call lua_pop(l, 1)

    ! gv3b["c"] == 3
    rc = lua_getfield(l, -1, "c")
    call test%assertequal(rc, LUA_TNUMBER, message='gv3b["c"] is type LUA_TNUMBER')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv3b["c"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv3b["c"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(ival, 3_INT64, message='lua_tointeger(gv3b["c"]) == 3_INT64')
    call lua_pop(l, 1)

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

    ! -- gv4a is a mixed array
    ! gv4a = { "Hydraulic pump", 124.95, -2, "Backordered" }

    rc = lua_getglobal(l, 'gv4a')
    call test%assertequal(rc, LUA_TTABLE, message="gv4a is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv4a) is .true.")

    ! gv4a[4] == "Backordered"
    rc = lua_geti(l, -1, 4_INT64)
    call test%assertequal(rc, LUA_TSTRING, message="gv4a[4] is type LUA_TSTRING")
    tf = lua_isnumber(l, -1)
    call test%assertfalse(tf, message="lua_isnumber(gv4a[4]) is .false.")
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message="lua_isstring(gv4a[4]) is .true.")
    cval = lua_tostring(l, -1)
    call test%assertequal("Backordered", cval, message='lua_string(gv4a[4]) == "Backordered"')
    call lua_pop(l, 1)

    ! gv2d[1] == "Hydraulic pump"
    rc = lua_geti(l, -1, 1_INT64)
    call test%assertequal(rc, LUA_TSTRING, message="gv4a[1] is type LUA_TSTRING")
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message="lua_isstring(gv4a[1]) is .true.")
    cval = lua_tostring(l, -1)
    call test%assertequal("Hydraulic pump", cval, message='lua_tostring(gv4a[1]) == "Hydraulic pump"')
    call lua_pop(l, 1)

    ! gv4a[2] == 124.95
    rc = lua_geti(l, -1, 2_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv4a[2] is type LUA_TNUMBER")
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message="lua_isstring(gv4a[2]) is .true. (Lua-ism: numbers can be converted to strings)")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv4a[2]) is .true.")
    dval = lua_tonumber(l, -1)
    call test%assertequal(124.95_WP, dval, message='lua_tonumber(gv4a[2]) == 124.95')
    call lua_pop(l, 1)

    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv4a test")

    ! Close the interpreter

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after all tests")

    call lua_close(l)

    ! Print summary at the end
    call printsummary(test)
    call jsonwritetofile(test, "ut_tablecheck.json")

    call test%checkfailure()
end program ut_tablecheck
