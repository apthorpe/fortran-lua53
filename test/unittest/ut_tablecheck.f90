!> @file ut_tablecheck.f90
!! @author Bob Apthorpe
!! @copyright See LICENSE
!! @brief Table operation unit test

!! @brief Table operation unit test
program ut_tablecheck
    use, intrinsic :: iso_fortran_env, only: WP => REAL64, INT64,       &
        stdout => OUTPUT_UNIT
    use, intrinsic :: iso_c_binding, only: c_ptr, c_null_char
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

    integer(kind=INT64) :: ival
    real(kind=WP) :: dval
    character(len=:), allocatable :: cval

    integer :: table_idx
    character(len=:), allocatable :: kk
    character(len=:), allocatable :: vv
    type(c_ptr) :: tmp_ptr

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
    call lua_len(l, -1)
    tlength = lua_tointeger(l, -1)
    call test%assertequal(tlength, 0_INT64, message="lua_len(gv1) == 0_INT64")
    ! Remove length
    call lua_pop(l, 1)

    ! Remove gv1
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv1 test")

    ! -- gv2a is an integer array
    ! gv2a = { 5, 4, 3, 2, 1 }
    rc = lua_getglobal(l, 'gv2a')
    call test%assertequal(rc, LUA_TTABLE, message="gv2a is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv2a) is .true.")

    call lua_len(l, -1)
    tlength = lua_tointeger(l, -1)
    call test%assertequal(tlength, 5_INT64, message="lua_len(gv2a) == 5_INT64")
    ! Remove length
    call lua_pop(l, 1)

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

    call lua_len(l, -1)
    tlength = lua_tointeger(l, -1)
    call test%assertequal(tlength, 5_INT64, message="lua_len(gv2b) == 5_INT64")
    ! Remove length
    call lua_pop(l, 1)

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

    call lua_len(l, -1)
    tlength = lua_tointeger(l, -1)
    call test%assertequal(tlength, 5_INT64, message="lua_len(gv2c) == 5_INT64")
    ! Remove length
    call lua_pop(l, 1)

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

    call lua_len(l, -1)
    tlength = lua_tointeger(l, -1)
    call test%assertequal(tlength, 5_INT64, message="lua_len(gv2d) == 5_INT64")
    ! Remove length
    call lua_pop(l, 1)

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

    call lua_len(l, -1)
    tlength = lua_tointeger(l, -1)
    call test%assertequal(tlength, 0_INT64, message="lua_len(gv3a) == 0_INT64 (Lua-ism: lua_len() only counts indices 1..n)")
    ! Remove length
    call lua_pop(l, 1)

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

    call lua_len(l, -1)
    tlength = lua_tointeger(l, -1)
    call test%assertequal(tlength, 0_INT64, message="lua_len(gv3b) == 0_INT64 (Lua-ism: lua_len() only counts indices 1..n)")
    ! Remove length
    call lua_pop(l, 1)

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
    ! gv4a = { "Hydraulic pump", 124.95, -2, "Backordered", { bearings = 2, seals = 8, impeller = 1 }, false }

    rc = lua_getglobal(l, 'gv4a')
    call test%assertequal(rc, LUA_TTABLE, message="gv4a is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv4a) is .true.")

    call lua_len(l, -1)
    tlength = lua_tointeger(l, -1)
    call test%assertequal(tlength, 6_INT64, message="lua_len(gv4a) == 6_INT64")
    ! Remove length
    call lua_pop(l, 1)

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

    ! gv4a[3] == -2
    rc = lua_geti(l, -1, 3_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv4a[3] is type LUA_TNUMBER")
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message="lua_isstring(gv4a[3]) is .true. (Lua-ism: numbers can be converted to strings)")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv4a[3]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv4a[3]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(-2_INT64, ival, message='lua_tointeger(gv4a[3]) == -2')
    dval = lua_tonumber(l, -1)
    call test%assertequal(-2.0_WP, dval, message='lua_tonumber(gv4a[3]) == -2.0')
    call lua_pop(l, 1)

    ! gv4a[5] == { bearings = 2, seals = 8, impeller = 1 }
    rc = lua_geti(l, -1, 5_INT64)
    call test%assertequal(rc, LUA_TTABLE, message="gv4a[5] is type LUA_TTABLE")

    call lua_len(l, -1)
    tlength = lua_tointeger(l, -1)
    call test%assertequal(tlength, 0_INT64, message="lua_len(gv4a[5]) == 0_INT64 (Lua-ism: lua_len() only counts indices 1..n)")
    ! Remove length
    call lua_pop(l, 1)

    rc = lua_getfield(l, -1, "bearings")
    call test%assertequal(rc, LUA_TNUMBER, message='gv4a[5]["bearings"] is type LUA_TNUMBER')
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message='lua_isstring(gv4a[5]["bearings"]) is .true. (Lua-ism: numbers can be converted to strings)')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv4a[5]["bearings"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv4a[5]["bearings"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(2_INT64, ival, message='lua_tointeger(gv4a[5]) == 2')
    call lua_pop(l, 1)

    rc = lua_getfield(l, -1, "seals")
    call test%assertequal(rc, LUA_TNUMBER, message='gv4a[5]["seals"] is type LUA_TNUMBER')
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message='lua_isstring(gv4a[5]["seals"]) is .true. (Lua-ism: numbers can be converted to strings)')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv4a[5]["seals"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv4a[5]["seals"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(8_INT64, ival, message='lua_tointeger(gv4a[5]["seals"]) == 8')
    call lua_pop(l, 1)

    rc = lua_getfield(l, -1, "impeller")
    call test%assertequal(rc, LUA_TNUMBER, message='gv4a[5]["impeller"] is type LUA_TNUMBER')
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message='lua_isstring(gv4a[5]["impeller"]) is .true. (Lua-ism: numbers can be converted to strings)')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv4a[5]["impeller"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv4a[5]["impeller"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(1_INT64, ival, message='lua_tointeger(gv4a[5]["impeller"]) == 1')
    call lua_pop(l, 1)

    ! key in subtable doesn't exist
    rc = lua_getfield(l, -1, "sandwich")
    call test%assertequal(rc, LUA_TNIL, message='gv4a[5]["sandwich"] is type LUA_TNIL')
    call lua_pop(l, 1)

    ! Remove subtable
    call lua_pop(l, 1)

    ! gv4a[6] == false
    rc = lua_geti(l, -1, 6_INT64)
    call test%assertequal(rc, LUA_TBOOLEAN, message="gv4a[6] is type LUA_TBOOLEAN")
    call test%asserttrue((rc /= LUA_TNIL), message="gv4a[6] is not type LUA_TNIL")
    call test%asserttrue((rc /= LUA_TNUMBER), message="gv4a[6] is not type LUA_TNUMBER")
    call test%asserttrue((rc /= LUA_TSTRING), message="gv4a[6] is not type LUA_TSTRING")
    tf = lua_isboolean(l, -1)
    call test%asserttrue(tf, message="lua_isboolean(gv4a[6]) is .true.")
    tf = lua_isstring(l, -1)
    call test%assertfalse(tf, message="lua_isstring(gv4a[6]) is .false.")
    tf = lua_isnumber(l, -1)
    call test%assertfalse(tf, message="lua_isnumber(gv4a[6]) is .false.")
    tf = lua_isinteger(l, -1)
    call test%assertfalse(tf, message='lua_isinteger(gv4a[6]) is .false.')
    tf = lua_toboolean(l, -1)
    call test%assertfalse(tf, message='lua_toboolean(gv4a[6]) == .false.')
    call lua_pop(l, 1)

    ! Remove table
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv4a test")

    ! -- gv4b is a mixed array
    ! gv4b = { "Hydraulic pump", 124.95, -2, status = "Backordered", partslist = { bearings = 2, seals = 8, impeller = 1 }, false }

    rc = lua_getglobal(l, 'gv4b')
    call test%assertequal(rc, LUA_TTABLE, message="gv4b is type LUA_TTABLE")
    tf = lua_istable(l, -1)
    call test%asserttrue(tf, message="lua_istable(gv4b) is .true.")

    call lua_len(l, -1)
    tlength = lua_tointeger(l, -1)
    call test%assertequal(tlength, 4_INT64, message="lua_len(gv4b) == 4_INT64 (Lua-ism: 4 indices; ignore the 2 keys)")
    ! Remove length
    call lua_pop(l, 1)

    ! gv4b["status"] == "Backordered"
    rc = lua_getfield(l, -1, "status")
    call test%assertequal(rc, LUA_TSTRING, message='gv4b["status"] is type LUA_TSTRING')
    tf = lua_isnumber(l, -1)
    call test%assertfalse(tf, message='lua_isnumber(gv4b["status"]) is .false.')
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message='lua_isstring(gv4b["status"]) is .true.')
    cval = lua_tostring(l, -1)
    call test%assertequal("Backordered", cval, message='lua_string(gv4b["status"]) == "Backordered"')
    call lua_pop(l, 1)

    ! gv2d[1] == "Hydraulic pump"
    rc = lua_geti(l, -1, 1_INT64)
    call test%assertequal(rc, LUA_TSTRING, message="gv4b[1] is type LUA_TSTRING")
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message="lua_isstring(gv4b[1]) is .true.")
    cval = lua_tostring(l, -1)
    call test%assertequal("Hydraulic pump", cval, message='lua_tostring(gv4b[1]) == "Hydraulic pump"')
    call lua_pop(l, 1)

    ! gv4b[2] == 124.95
    rc = lua_geti(l, -1, 2_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv4b[2] is type LUA_TNUMBER")
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message="lua_isstring(gv4b[2]) is .true. (Lua-ism: numbers can be converted to strings)")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv4b[2]) is .true.")
    dval = lua_tonumber(l, -1)
    call test%assertequal(124.95_WP, dval, message='lua_tonumber(gv4b[2]) == 124.95')
    call lua_pop(l, 1)

    ! gv4b[3] == -2
    rc = lua_geti(l, -1, 3_INT64)
    call test%assertequal(rc, LUA_TNUMBER, message="gv4b[3] is type LUA_TNUMBER")
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message="lua_isstring(gv4b[3]) is .true. (Lua-ism: numbers can be converted to strings)")
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message="lua_isnumber(gv4b[3]) is .true.")
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv4b[3]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(-2_INT64, ival, message='lua_tointeger(gv4b[3]) == -2')
    dval = lua_tonumber(l, -1)
    call test%assertequal(-2.0_WP, dval, message='lua_tonumber(gv4b[3]) == -2.0')
    call lua_pop(l, 1)

    ! gv4b["partslist"] == { bearings = 2, seals = 8, impeller = 1 }
    rc = lua_getfield(l, -1, "partslist")
    call test%assertequal(rc, LUA_TTABLE, message='gv4b["partslist"] is type LUA_TTABLE')

    call lua_len(l, -1)
    tlength = lua_tointeger(l, -1)
    call test%assertequal(tlength, 0_INT64, message='lua_len(gv4b["partslist"]) == 0_INT64 (Lua-ism:...)')
    ! Remove length
    call lua_pop(l, 1)

    rc = lua_getfield(l, -1, "bearings")
    call test%assertequal(rc, LUA_TNUMBER, message='gv4b[5]["bearings"] is type LUA_TNUMBER')
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message='lua_isstring(gv4b[5]["bearings"]) is .true. (Lua-ism: numbers can be converted to strings)')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv4b[5]["bearings"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv4b[5]["bearings"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(2_INT64, ival, message='lua_tointeger(gv4b[5]) == 2')
    call lua_pop(l, 1)

    rc = lua_getfield(l, -1, "seals")
    call test%assertequal(rc, LUA_TNUMBER, message='gv4b[5]["seals"] is type LUA_TNUMBER')
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message='lua_isstring(gv4b[5]["seals"]) is .true. (Lua-ism: numbers can be converted to strings)')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv4b[5]["seals"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv4b[5]["seals"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(8_INT64, ival, message='lua_tointeger(gv4b[5]["seals"]) == 8')
    call lua_pop(l, 1)

    rc = lua_getfield(l, -1, "impeller")
    call test%assertequal(rc, LUA_TNUMBER, message='gv4b[5]["impeller"] is type LUA_TNUMBER')
    tf = lua_isstring(l, -1)
    call test%asserttrue(tf, message='lua_isstring(gv4b[5]["impeller"]) is .true. (Lua-ism: numbers can be converted to strings)')
    tf = lua_isnumber(l, -1)
    call test%asserttrue(tf, message='lua_isnumber(gv4b[5]["impeller"]) is .true.')
    tf = lua_isinteger(l, -1)
    call test%asserttrue(tf, message='lua_isinteger(gv4b[5]["impeller"]) is .true.')
    ival = lua_tointeger(l, -1)
    call test%assertequal(1_INT64, ival, message='lua_tointeger(gv4b[5]["impeller"]) == 1')
    call lua_pop(l, 1)

    ! key in subtable doesn't exist
    rc = lua_getfield(l, -1, "sandwich")
    call test%assertequal(rc, LUA_TNIL, message='gv4b[5]["sandwich"] is type LUA_TNIL')
    call lua_pop(l, 1)

    ! Remove subtable
    call lua_pop(l, 1)

    ! gv4b[4] == false
    rc = lua_geti(l, -1, 4_INT64)
    call test%assertequal(rc, LUA_TBOOLEAN, message="gv4b[4] is type LUA_TBOOLEAN")
    call test%asserttrue((rc /= LUA_TNIL), message="gv4b[4] is not type LUA_TNIL")
    call test%asserttrue((rc /= LUA_TNUMBER), message="gv4b[4] is not type LUA_TNUMBER")
    call test%asserttrue((rc /= LUA_TSTRING), message="gv4b[4] is not type LUA_TSTRING")
    tf = lua_isboolean(l, -1)
    call test%asserttrue(tf, message="lua_isboolean(gv4b[4]) is .true.")
    tf = lua_isstring(l, -1)
    call test%assertfalse(tf, message="lua_isstring(gv4b[4]) is .false.")
    tf = lua_isnumber(l, -1)
    call test%assertfalse(tf, message="lua_isnumber(gv4b[4]) is .false.")
    tf = lua_isinteger(l, -1)
    call test%assertfalse(tf, message='lua_isinteger(gv4b[4]) is .false.')
    tf = lua_toboolean(l, -1)
    call test%assertfalse(tf, message='lua_toboolean(gv4b[4]) == .false.')
    call lua_pop(l, 1)

    ! Remove table
    call lua_pop(l, 1)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after gv4b test")

    ! Create a table

    call lua_newtable(l)

    ! Throw it away

    call lua_pop(l, 1)

    ! Create another table

    call lua_createtable(l, 0, 0)
    vv = lua_typename(l, lua_type(l, -1))
    call test%assertequal(vv, "table", message="Expect table on top of stack")

    ! Add first kv pair to stack
    tmp_ptr = lua_pushstring(l, "Gate valve" // c_null_char)
    call lua_setfield(l, -2, "Item")
    ! Second...
    call lua_pushinteger(l, 250_INT64)
    call lua_setfield(l, -2, "Weight")
    ! Third...
    call lua_pushnumber(l, 379.95_WP)
    call lua_setfield(l, -2, "Shipping")

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 1, message="Expect one element on stack (new table)")

    table_idx = nstack

    ! Walk the table
    rc = 0
    call lua_pushnil(l)
    vv = lua_typename(l, lua_type(l, -1))
    call test%assertequal(vv, "nil", message="Expect nil element on top of stack")

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 2, message="Expect two elements on stack (2->nil, 1->new table)")

    ! Absolute index of key (nil) on stack is 2 <=== TOP
    ! Absolute index of table on stack is 1

    ! lua_next consumes a key every call.
    do while (lua_next(l, table_idx) /= 0)
      rc = rc + 1
      ! Uses 'key' (at index -2) and 'value' (at index -1)
      kk = lua_typename(l, lua_type(l, -2))
      vv = lua_typename(l, lua_type(l, -1))
      write(unit=stdout, fmt="(A, ' -> ', A)") kk, vv
      ! removes 'value'; keeps 'key' for next iteration
      call lua_pop(l, 1)
    end do
    call test%assertequal(rc, 3, message="Expect to walk three pairs in new table)")

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 1, message="Expect one element on stack (new table)")

    ! Remove table
    call lua_pop(l, 1)

    ! Close the interpreter

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 0, message="Expect empty stack after all tests")

    call lua_close(l)

    ! Print summary at the end
    call printsummary(test)
    call jsonwritetofile(test, "ut_tablecheck.json")

    call test%checkfailure()
end program ut_tablecheck
