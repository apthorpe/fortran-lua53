! example.f90
!
! Example program that calls the recursive Lua routine `fib()` in file
! `fibonacci.lua` and outputs the result.
program main
    use, intrinsic :: iso_fortran_env, only: stdout => OUTPUT_UNIT
    use, intrinsic :: iso_c_binding, only: c_ptr
    use :: lua
    implicit none
    type(c_ptr) :: l
    integer     :: nargs    = 1
    integer     :: nresults = 2
    integer     :: rc
    integer     :: r1, r2   = 0
    integer     :: x        = 10

10  format(A)
20  format(A, I4)
    continue

    l = lual_newstate()
    call lual_openlibs(l)
    rc = lual_dofile(l, 'fibonacci.lua')
    write(unit=stdout, fmt=20) 'lua_dofile responded with ', rc
    rc = lua_getglobal(l, 'fib')
    write(unit=stdout, fmt=20) 'lua_getglobal("fib") responded with (type) ', rc

    if (lua_isfunction(l, -1)) then
        write(unit=stdout, fmt=20) 'lua_isfunction(l, -1) is .true.'

        call lua_pushinteger(l, x)
        write(unit=stdout, fmt=10) 'integer x = 10 pushed onto stack'

        rc = lua_pcall(l, nargs, nresults, 0)
        write(unit=stdout, fmt=20) 'lua_pcall() responded with ', rc

        r1 = lua_tointeger(l, -1)
        r2 = lua_tointeger(l, -2)

        write(unit=stdout, fmt=20) 'r1 = lua_tointeger(l, -1) = ', r1
        write(unit=stdout, fmt=20) 'r2 = lua_tointeger(l, -2) = ', r2

        call lua_pop(l, 2)
        write(unit=stdout, fmt=10) 'lua_pop(l, 2) called; removed r1 an r2 from stack?'

        print '("fibonacci(", i0, ") = ", i0)', x, r2
    else
        write(unit=stdout, fmt=20) 'lua_isfunction(l, -1) is .false.'
    end if

    call lua_close(l)
end program main
