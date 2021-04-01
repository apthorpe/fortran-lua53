!> @file fhello.f90
!!
!! Example functions for calling Fortran routines from Lua

!> @brief Example functions for calling Fortran routines from Lua
!!
!! The function `luaopen_fhello()` is called by Lua to register the Fortran
!! routine `hello()`. Compile this Fortran module as a shared library and run
!! `example.lua`.
module fhello
    use, intrinsic :: iso_c_binding, only: c_int, c_funloc, c_ptr
    use :: lua
    implicit none

    public :: luaopen_fhello   ! Module registration function.
    public :: hello            ! Routine callable from Lua.
contains
    !> @brief Module registration function
    !!
    !! Utility function to register the Fortran routine `hello()`.
    function luaopen_fhello(l) bind(c)
        !> Lua state object
        type(c_ptr), intent(in), value :: l
        ! Return value
        integer(kind=c_int)            :: luaopen_fhello
        continue

        call lua_register(l,               & ! Lua state object
                          'hello',         & ! Name of the Fortran routine.
                          c_funloc(hello))   ! Function pointer to the Fortran routine.
        luaopen_fhello = 1

        return
    end function luaopen_fhello

    !> @brief Example Fortran routine callable from Lua
    !!
    !! The Fortran routine callable from Lua.
    subroutine hello(l) bind(c)
        !> Lua state object
        type(c_ptr), intent(in), value :: l
        continue

        print '(a)', 'Hello from Fortran!'

        return
    end subroutine hello
end module fhello
