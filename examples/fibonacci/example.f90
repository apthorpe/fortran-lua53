! example.f90
!
! Example program that calls the recursive Lua routine `fib()` in file
! `fibonacci.lua` and outputs the result.
program main
    use, intrinsic :: iso_fortran_env, only: INT64
    use, intrinsic :: iso_c_binding, only: c_ptr
    use :: lua
    implicit none
    type(c_ptr)         :: l
    integer             :: nargs    = 1
    integer             :: nresults = 2
    integer             :: rc
    integer(kind=INT64) :: r1       = 0_INT64
    integer(kind=INT64) :: r2       = 0_INT64
    integer(kind=INT64) :: x        = 10_INT64

    l = lual_newstate()
    call lual_openlibs(l)
    rc = lual_dofile(l, 'fibonacci.lua')
    rc = lua_getglobal(l, 'fib')

    if (lua_isfunction(l, -1)) then
        call lua_pushinteger(l, x)
        rc = lua_pcall(l, nargs, nresults, 0)

        r1 = lua_tointeger(l, -1)
        r2 = lua_tointeger(l, -2)

        call lua_pop(l, 2)

        print '("fibonacci(", i0, ") = ", i0)', x, r2
    end if

    call lua_close(l)
end program main
