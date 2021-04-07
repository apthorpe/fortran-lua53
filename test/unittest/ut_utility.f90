!> @file ut_utility.f90
!! @author Bob Apthorpe
!! @copyright See LICENSE
!! @brief Test of miscellaneous Lua C API functions

!! @brief Test of miscellaneous Lua C API functions
program ut_utility
    use, intrinsic :: iso_fortran_env, only: WP => REAL64, INT64,       &
        stdout => OUTPUT_UNIT
    use, intrinsic :: iso_c_binding, only: c_ptr, c_associated,         &
        c_null_char, c_null_ptr, c_int
    use :: lua
    use :: toast
    implicit none

    ! Lua state object
    type(c_ptr) :: l

    ! character(len=32) :: fname

    integer :: i
    integer :: nstack
    ! integer :: rc
    ! logical :: tf
    ! integer(kind=INT64) :: tlength
    ! integer(kind=INT64) :: version

    type(c_ptr) :: misc_ptr
    ! integer(kind=INT64) :: ival
    ! real(kind=WP) :: dval
    character(len=:), allocatable :: cval
    character(len=:), allocatable :: waterloo
    character(len=:), allocatable :: a_
    character(len=:), allocatable :: b_
    character(len=:), allocatable :: c_
    character(len=:), allocatable :: o_

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

    a_ = 'A'
    b_ = 'B'
    c_ = 'C'
    o_ = "O"
    misc_ptr = lua_pushstring(l, a_ // c_null_char)
    misc_ptr = lua_pushstring(l, b_ // c_null_char)
    misc_ptr = lua_pushstring(l, c_ // c_null_char)

    call lua_pushvalue(l, 1_c_int)

    call lua_copy(l, 2_c_int, 3_c_int)

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 4, message="Expect four elements on stack")

    waterloo = ""
    ! if (allocated(waterloo)) then
    !     deallocate(waterloo)
    ! end if
    ! allocate(character(len=nstack) :: waterloo)
    do i = 1, nstack
        cval = lua_tostring(l, int(i, c_int))
        ! waterloo(i:i) = cval(1:1)
        waterloo = waterloo // cval
    end do

    write(unit=stdout, fmt='("Mama mia! It''s ", A, "!")') waterloo
    call test%assertequal(waterloo, "ABBA", message="Matched ABBA")

    call lua_pop(l, 1)
    misc_ptr = lua_pushstring(l, o_ // c_null_char)
    call lua_copy(l, -1_c_int, 1_c_int)
    call lua_pop(l, 1_c_int)
    call lua_rotate(l, 1_c_int, 1_c_int)

    ! write(unit=stdout, fmt='(A)') "After r(3,1)"
    ! nstack = lua_gettop(l)
    ! do i = nstack, 1, -1
    !     cval = lua_tostring(l, int(i, c_int))
    !     write(unit=stdout, fmt='("Stack(", I0, ") is: ", A)') i, cval
    ! end do

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 3, message="Expect three elements on stack")

    waterloo = ''
    do i = 1, nstack
        ! misc_ptr = lua_tolstring(l, i, c_null_ptr)
        cval = lua_tostring(l, int(i, c_int))
        waterloo = waterloo // cval
    end do

    call test%assertequal(waterloo, "BOB", message="Matched BOB - iterative")

    call lua_concat(l, 3_c_int)
    waterloo = lua_tostring(l, -1_c_int)

    write(unit=stdout, fmt='(A, ", STOP IT!")') waterloo

    call test%assertequal(waterloo, "BOB", message="Matched BOB - concat")

    nstack = lua_gettop(l)
    call test%assertequal(nstack, 1, message="Expect one element on stack")

    ! Stop this embarrassment...
    call lua_pop(l, 1)

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
