!> @file ut_fibonacci.f90
!! @author Bob Apthorpe
!! @copyright See LICENSE
!! @brief Unit test replicating the fibonacci example

!> @brief Unit test replicating the fibonacci example
program ut_fibonacci
    use, intrinsic :: iso_fortran_env, only: WP => REAL64, INT64
    use, intrinsic :: iso_c_binding, only: c_ptr
    use :: lua
    use :: toast
    implicit none

    ! Lua state object
    type(c_ptr)         :: l
    integer             :: nargs    = 1
    integer             :: nresults = 2
    integer             :: rc
    integer(kind=INT64) :: r1       = 0_INT64
    integer(kind=INT64) :: r2       = 0_INT64
    integer(kind=INT64) :: x        = 10_INT64

    character(len=32) :: fname

    logical :: is_fn

    ! real(kind=WP) :: refval
    ! integer :: i
    ! integer :: id
    type(TestCase) :: test

! 10  format(A)
! 20  format(A, I4)
    continue

    call test%init(name="ut_fibonacci")

    !!! Test exposed functions

    ! Instrumented replication of fibonacci example program

    l = lual_newstate()
    call lual_openlibs(l)

    ! lua_dofile() success
    fname = 'fibonacci.lua'
    rc = lual_dofile(l, trim(fname))

    call test%assertequal(rc, 0, message="Success (0) loading " // trim(fname))

    ! lua_getglobal() success
    rc = lua_getglobal(l, 'fib')

    call test%assertequal(rc, LUA_TFUNCTION, message="Success finding global name 'fib' (type is LUA_TFUNCTION)")

    is_fn = lua_isfunction(l, -1)
    call test%asserttrue(is_fn, message="Success from lua_isfunction - fib is a function")

    if (is_fn) then
        x = 10_INT64
        call lua_pushinteger(l, x)

        nargs = 1
        nresults = 2

        rc = lua_pcall(l, nargs, nresults, 0)
        call test%assertequal(rc, LUA_TH_OK, message="Successful call (status is LUA_TH_OK)")

        r1 = lua_tointeger(l, -1)
        call test%assertequal(r1, 34_INT64, message="Successfully calculated fib prev (r1 = 34_INT64)")

        r2 = lua_tointeger(l, -2)
        call test%assertequal(r2, 55_INT64, message="Successfully calculated fib curr (r2 = 55_INT64)")

        call lua_pop(l, 2)

        ! print '("fibonacci(", i0, ") = ", i0)', x, r2
    end if

    ! lua_dofile() failure
    fname = 'garbagepants.lua'
    rc = lual_dofile(l, trim(fname))
    call test%asserttrue((rc /= 0), message="Failure (!0) loading " // trim(fname))

    ! lua_getglobal() failure
    rc = lua_getglobal(l, 'trashpanda')
    call test%assertequal(rc, LUA_TNIL, message="Failure finding global name 'trashpanda' (type is LUA_TNIL)")

    call lua_close(l)

    ! Print summary at the end
    call printsummary(test)
    call jsonwritetofile(test, "ut_fibonacci.json")

    call test%checkfailure()
end program ut_fibonacci
