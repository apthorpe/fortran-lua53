!> @file lua.f90
!!
!! @brief A collection of ISO C binding interfaces to Lua 5.3 for
!! Fortran 2003.
!!
!! @author Philipp Engel
!! @copyright ISC; see LICENCE


!> @brief A collection of ISO C binding interfaces to Lua 5.3 for
!! Fortran 2003.
!!
!! C API functions which are not inmplemented:
!!
!!   * lua_atpanic
!!   * lua_dump
!!   * lua_getallocf
!!   * lua_getextraspace
!!   * lua_newstate
!!   * lua_newthread
!!   * lua_newuserdata
!!   * lua_pushfstring
!!   * lua_pushliteral
!!   * lua_pushvfstring
!!   * lua_rawgetp
!!   * lua_rawsetp
!!   * lua_resume
!!   * lua_setallocf
!!   * lua_setuservalue
!!   * lua_tocfunction
!!   * lua_topointer
!!   * lua_touserdata
!!   * lua_xmove
!!   * lua_yield
!!   * lua_yieldk
!!
!! Auxiliary functions which are not inmplemented:
!!
!!  * luaL_addchar
!!  * luaL_addlstring
!!  * luaL_addsize
!!  * luaL_addstring
!!  * luaL_addvalue
!!  * luaL_argcheck
!!  * luaL_argerror
!!  * luaL_buffinit
!!  * luaL_buffinitsize
!!  * luaL_callmeta
!!  * luaL_checkany
!!  * luaL_checkinteger
!!  * luaL_checklstring
!!  * luaL_checknumber
!!  * luaL_checkoption
!!  * luaL_checkstack
!!  * luaL_checkstring
!!  * luaL_checktype
!!  * luaL_checkudata
!!  * luaL_checkversion
!!  * luaL_error
!!  * luaL_execresult
!!  * luaL_fileresult
!!  * luaL_getmetafield
!!  * luaL_getmetatable
!!  * luaL_getsubtable
!!  * luaL_gsub
!!  * luaL_loadbuffer
!!  * luaL_loadbufferx
!!  * luaL_newlib
!!  * luaL_newlibtable
!!  * luaL_newmetatable
!!  * luaL_opt
!!  * luaL_optinteger
!!  * luaL_optlstring
!!  * luaL_optnumber
!!  * luaL_optstring
!!  * luaL_prepbuffer
!!  * luaL_prepbuffsize
!!  * luaL_pushresult
!!  * luaL_pushresultsize
!!  * luaL_ref
!!  * luaL_requiref
!!  * luaL_setfuncs
!!  * luaL_setmetatable
!!  * luaL_testudata
!!  * luaL_tolstring
!!  * luaL_traceback
!!  * luaL_unref
!!  * luaL_where
!!
!! See @cite Lua53Manual for details.
module lua
    use, intrinsic :: iso_fortran_env, only: LUA_INT => INT64,          &
        LUA_FLOAT => REAL64
    use, intrinsic :: iso_c_binding
    implicit none
    private

    ! Unmplemented C API Types (* considered important)
    ! lua_Alloc
    ! lua_CFunction
    !* lua_Integer (alias to iso_fortran_env::INT64)
    ! lua_KContext
    ! lua_KFunction
    !* lua_Number (alias to iso_fortran_env::REAL64)
    ! lua_Reader
    ! lua_State
    ! lua_Unsigned
    !* lua_Writer - needed for lua_dump

    ! Unmplemented C API Functions (* considered important)
    !X lua_atpanic - demonstrate need - low-level process signalling beyond scope
    !* lua_dump
    !X lua_getallocf - demonstrate need - low-level memory management beyond scope
    !X lua_getextraspace - demonstrate need - low-level memory management beyond scope
    !o lua_newstate - use lual_newstate
    !X lua_newthread - demonstrate need - coroutines and thread mgmt beyond scope
    !X lua_newuserdata - demonstrate need - uservalue/userdata beyond scope
    !o lua_pushfstring - compose string with format() then use lua_pushstring
    !o lua_pushliteral - use lua_pushstring
    !o lua_pushvfstring - compose string with format() then use lua_pushstring
    !X lua_rawgetp - demonstrate need - uservalue/userdata beyond scope
    !X lua_rawsetp - demonstrate need - uservalue/userdata beyond scope
    !X lua_resume - demonstrate need - coroutines and thread mgmt beyond scope
    !X lua_setallocf - demonstrate need - low-level memory management beyond scope
    !X lua_setuservalue - demonstrate need - uservalue/userdata beyond scope
    !X lua_tocfunction - demonstrate need - partial support of C functions
    !X lua_topointer - demonstrate need - used mainly for hashing and debugging
    !X lua_touserdata - demonstrate need - uservalue/userdata beyond scope
    !X lua_xmove - demonstrate need - coroutines and thread mgmt beyond scope
    !X lua_yield - demonstrate need - coroutines and thread mgmt beyond scope
    !X lua_yieldk - demonstrate need - coroutines and thread mgmt beyond scope

    ! The Lua debug interface is not supported

    ! Unimplemented Auxiliary Library types
    ! luaL_Buffer
    ! luaL_Reg
    ! luaL_Stream

    ! Unimplemented Auxiliary Library functions (* considered important)
    ! luaL_addchar
    ! luaL_addlstring
    ! luaL_addsize
    ! luaL_addstring
    ! luaL_addvalue
    ! luaL_argcheck
    ! luaL_argerror
    ! luaL_buffinit
    ! luaL_buffinitsize
    ! luaL_callmeta
    ! luaL_checkany
    ! luaL_checkinteger
    ! luaL_checklstring
    ! luaL_checknumber
    ! luaL_checkoption
    ! luaL_checkstack
    ! luaL_checkstring
    ! luaL_checktype
    ! luaL_checkudata
    ! luaL_checkversion
    ! luaL_error
    ! luaL_execresult
    ! luaL_fileresult
    ! luaL_getmetafield
    ! luaL_getmetatable
    ! luaL_getsubtable
    ! luaL_gsub
    ! luaL_loadbuffer
    ! luaL_loadbufferx
    ! luaL_newlib
    ! luaL_newlibtable
    ! luaL_newmetatable
    ! luaL_opt
    ! luaL_optinteger
    ! luaL_optlstring
    ! luaL_optnumber
    ! luaL_optstring
    ! luaL_prepbuffer
    ! luaL_prepbuffsize
    ! luaL_pushresult
    ! luaL_pushresultsize
    ! luaL_ref
    ! luaL_requiref
    ! luaL_setfuncs
    ! luaL_setmetatable
    ! luaL_testudata
    ! luaL_tolstring
    ! luaL_traceback
    ! luaL_unref
    ! luaL_where

    ! Implemented C API Functions
    public :: lua_absindex
    public :: lua_arith
    ! public :: lua_atpanic - demonstrate need - low-level process signalling beyond scope
    public :: lua_call
    public :: lua_callk
    public :: lua_checkstack
    public :: lua_close
    public :: lua_compare
    public :: lua_concat
    public :: lua_copy
    public :: lua_createtable
    !* public :: lua_dump - demonstrate need; complex and requires C coding
    public :: lua_error
    public :: lua_gc
    ! public :: lua_getallocf - demonstrate need - low-level memory management beyond scope
    ! public :: lua_getextraspace - demonstrate need - low-level memory management beyond scope
    public :: lua_getfield
    public :: lua_getglobal
    public :: lua_geti
    public :: lua_getmetatable
    public :: lua_gettable
    public :: lua_gettop
    public :: lua_getuservalue
    public :: lua_insert
    public :: lua_isboolean
    public :: lua_iscfunction
    public :: lua_isfunction
    public :: lua_isinteger
    public :: lua_isnil
    public :: lua_isnone
    public :: lua_isnoneornil
    public :: lua_isnumber
    public :: lua_isstring
    public :: lua_istable
    public :: lua_isthread
    public :: lua_isuserdata
    public :: lua_isyieldable
    public :: lua_len
    public :: lua_load
    ! public :: lua_newstate - use lual_newstate
    public :: lua_newtable
    ! public :: lua_newthread - demonstrate need - coroutines and thread mgmt beyond scope
    ! public :: lua_newuserdata - demonstrate need - uservalue/userdata beyond scope
    public :: lua_next
    public :: lua_numbertointeger
    public :: lua_pcall
    public :: lua_pcallk
    public :: lua_pop
    public :: lua_pushboolean
    public :: lua_pushcclosure
    ! public :: lua_pushfstring - compose string with format() then use lua_pushstring
    public :: lua_pushglobaltable
    public :: lua_pushinteger
    public :: lua_pushlightuserdata
    ! public :: lua_pushliteral - use lua_pushstring
    public :: lua_pushlstring
    public :: lua_pushnil
    public :: lua_pushnumber
    public :: lua_pushstring
    public :: lua_pushthread
    public :: lua_pushvalue
    ! public :: lua_pushvfstring - compose string with format() then use lua_pushstring
    public :: lua_rawequal
    public :: lua_rawget
    public :: lua_rawgeti
    ! public :: lua_rawgetp - demonstrate need - uservalue/userdata beyond scope
    public :: lua_rawlen
    public :: lua_rawset
    public :: lua_rawseti
    ! public :: lua_rawsetp - demonstrate need - uservalue/userdata beyond scope
    public :: lua_register
    public :: lua_replace
    ! public :: lua_resume - demonstrate need - coroutines and thread mgmt beyond scope
    public :: lua_rotate
    ! public :: lua_setallocf - demonstrate need - low-level memory management beyond scope
    public :: lua_setfield
    public :: lua_setglobal
    public :: lua_seti
    public :: lua_setmetatable
    public :: lua_settable
    public :: lua_settop
    ! public :: lua_setuservalue - demonstrate need - uservalue/userdata beyond scope
    public :: lua_status
    public :: lua_stringtonumber
    public :: lua_toboolean
    ! public :: lua_tocfunction - demonstrate need - partial support of C functions
    public :: lua_tointeger
    public :: lua_tointegerx
    public :: lua_tonumber
    public :: lua_tonumberx
    ! public :: lua_topointer - demonstrate need - used mainly for hashing and debugging
    public :: lua_tostring
    public :: lua_type
    public :: lua_typename
    public :: lua_upvalueindex
    ! public :: lua_touserdata - demonstrate need - uservalue/userdata beyond scope
    public :: lua_version
    ! public :: lua_xmove - demonstrate need - coroutines and thread mgmt beyond scope
    ! public :: lua_yield - demonstrate need - coroutines and thread mgmt beyond scope
    ! public :: lua_yieldk - demonstrate need - coroutines and thread mgmt beyond scope

    ! Auxiliary Library functions
    ! luaL_addchar
    ! luaL_addlstring
    ! luaL_addsize
    ! luaL_addstring
    ! luaL_addvalue
    ! luaL_argcheck
    ! luaL_argerror
    ! luaL_buffinit
    ! luaL_buffinitsize
    ! luaL_callmeta
    ! luaL_checkany
    ! luaL_checkinteger
    ! luaL_checklstring
    ! luaL_checknumber
    ! luaL_checkoption
    ! luaL_checkstack
    ! luaL_checkstring
    ! luaL_checktype
    ! luaL_checkudata
    ! luaL_checkversion
    public :: lual_dofile
    public :: lual_dostring
    ! luaL_error
    ! luaL_execresult
    ! luaL_fileresult
    ! luaL_getmetafield
    ! luaL_getmetatable
    ! luaL_getsubtable
    ! luaL_gsub
    ! luaL_loadbuffer
    ! luaL_loadbufferx
    public :: lual_loadfile
    public :: lual_loadfilex
    public :: lual_loadstring
    ! luaL_newlib
    ! luaL_newlibtable
    ! luaL_newmetatable
    public :: lual_newstate
    public :: lual_openlibs
    ! luaL_opt
    ! luaL_optinteger
    ! luaL_optlstring
    ! luaL_optnumber
    ! luaL_optstring
    ! luaL_prepbuffer
    ! luaL_prepbuffsize
    ! luaL_pushresult
    ! luaL_pushresultsize
    ! luaL_ref
    ! luaL_requiref
    ! luaL_setfuncs
    ! luaL_setmetatable
    ! luaL_testudata
    ! luaL_tolstring
    ! luaL_traceback
    public :: lual_typename
    ! luaL_unref
    ! luaL_where

    !> @name Thread control options

    !!!@{
    !> Option for multiple returns in `lua_pcall()` and `lua_call()`.
    integer(kind=c_int), parameter, public :: LUA_MULTRET = -1
    !!!@}

    ! Basic types.

    !> @name Basic Lua types

    !!!@{
    !> Undefined Lua type
    integer(kind=c_int), parameter, public :: LUA_TNONE          = -1
    !> Lua `nil` type
    integer(kind=c_int), parameter, public :: LUA_TNIL           = 0
    !> Lua `boolean` type
    integer(kind=c_int), parameter, public :: LUA_TBOOLEAN       = 1
    !> Lua light `userdata` type (low-cost wrapper around a C pointer,
    !! has no metatables, and is not garbage-collected)
    integer(kind=c_int), parameter, public :: LUA_TLIGHTUSERDATA = 2
    !> Lua `number` type
    integer(kind=c_int), parameter, public :: LUA_TNUMBER        = 3
    !> Lua `string` type
    integer(kind=c_int), parameter, public :: LUA_TSTRING        = 4
    !> Lua `table` type
    integer(kind=c_int), parameter, public :: LUA_TTABLE         = 5
    !> Lua `function` type
    integer(kind=c_int), parameter, public :: LUA_TFUNCTION      = 6
    !> Lua full `userdata` type
    integer(kind=c_int), parameter, public :: LUA_TUSERDATA      = 7
    !> Lua `thread` type
    integer(kind=c_int), parameter, public :: LUA_TTHREAD        = 8
    !!!@}

    !> @name Arithmetic and bitwise operator codes

    !!!@{
    !> Lua arithmetic addition operator `+`
    integer(kind=c_int), parameter, public :: LUA_OPADD  = 0
    !> Lua arithmetic subtraction operator `-`
    integer(kind=c_int), parameter, public :: LUA_OPSUB  = 1
    !> Lua arithmetic multiplication operator `*`
    integer(kind=c_int), parameter, public :: LUA_OPMUL  = 2
    !> Lua arithmetic modulo operator `%`
    integer(kind=c_int), parameter, public :: LUA_OPMOD  = 3
    !> Lua arithmetic exponentiation operator `^`
    integer(kind=c_int), parameter, public :: LUA_OPPOW  = 4
    !> Lua arithmetic division operator `/`
    integer(kind=c_int), parameter, public :: LUA_OPDIV  = 5
    !> Lua arithmetic 'floor division' operator `//`
    integer(kind=c_int), parameter, public :: LUA_OPIDIV = 6
    !> Lua bitwise-AND operator `&`
    integer(kind=c_int), parameter, public :: LUA_OPBAND = 7
    !> Lua bitwise-OR operator `|`
    integer(kind=c_int), parameter, public :: LUA_OPBOR  = 8
    !> Lua bitwise-XOR operator '~'
    integer(kind=c_int), parameter, public :: LUA_OPBXOR = 9
    !> Lua bitwise left shift operator `<<`
    integer(kind=c_int), parameter, public :: LUA_OPSHL  = 10
    !> Lua bitwise right shift operator `>>`
    integer(kind=c_int), parameter, public :: LUA_OPSHR  = 11
    !> Lua arithmetic unary minus operator `-`
    integer(kind=c_int), parameter, public :: LUA_OPUNM  = 12
    !> Lua bitwise-NOT operator `~`
    integer(kind=c_int), parameter, public :: LUA_OPBNOT = 13
    !!!@}

    !> @name Comparison operator codes

    !!!@{
    !> Lua relational operator `==`
    integer(kind=c_int), parameter, public :: LUA_OPEQ = 0
    !> Lua relational operator `<`
    integer(kind=c_int), parameter, public :: LUA_OPLT = 1
    !> Lua relational operator `<=`
    integer(kind=c_int), parameter, public :: LUA_OPLE = 2
    !!!@}

    !> @name Garbage-collection options.

    !!!@{
    !> Garbage collection control: Stops the garbage collector
    integer(kind=c_int), parameter, public :: LUA_GCSTOP       = 0
    !> Garbage collection control: Restarts the garbage collector
    integer(kind=c_int), parameter, public :: LUA_GCRESTART    = 1
    !> Garbage collection control: Performs a full garbage-collection
    !! cycle
    integer(kind=c_int), parameter, public :: LUA_GCCOLLECT    = 2
    !> Garbage collection control: Returns the current amount of memory
    !! (in Kbytes) in use by Lua
    integer(kind=c_int), parameter, public :: LUA_GCCOUNT      = 3
    !> Garbage collection control: Returns the remainder of dividing
    !! the current amount of bytes of memory in use by Lua by 1024
    integer(kind=c_int), parameter, public :: LUA_GCCOUNTB     = 4
    !> Garbage collection control: Performs an incremental step of
    !! garbage collection
    integer(kind=c_int), parameter, public :: LUA_GCSTEP       = 5
    !> Garbage collection control: Sets data as the new value for the
    !! pause of the collector and returns the previous value of the
    !! pause
    integer(kind=c_int), parameter, public :: LUA_GCSETPAUSE   = 6
    !> Garbage collection control: Sets data as the new value for the
    !! step multiplier of the collector and returns the previous value
    !! of the step multiplier
    integer(kind=c_int), parameter, public :: LUA_GCSETSTEPMUL = 7
    !> Garbage collection control: Returns a boolean that tells whether
    !! the collector is running (i.e., not stopped)
    integer(kind=c_int), parameter, public :: LUA_GCISRUNNING  = 9
    !!!@}

    !> @name Thread status.

    !!!@{
    !> Thread status: (from `lua_pcall`) success, (from `lua_resume`)
    !! indicates the coroutine finished its execution without errors
    integer(kind=c_int), parameter, public :: LUA_OK        = 0
    !> Thread status: (from `lua_resume`) Indicates that the coroutine
    !! yields, (from `lua_status`) a thread is suspended
    integer(kind=c_int), parameter, public :: LUA_YIELD     = 1
    !> Thread status: (from `pcall`) a runtime error
    integer(kind=c_int), parameter, public :: LUA_ERRRUN    = 2
    !> Thread status: (from `lua_load`) syntax error during
    !! precompilation
    integer(kind=c_int), parameter, public :: LUA_ERRSYNTAX = 3
    !> Thread status: (from `lua_pcall`, `lua_load`) memory allocation
    !! error. For such errors resulting from `lua_pcall`, Lua does not
    !! call the message handler.
    integer(kind=c_int), parameter, public :: LUA_ERRMEM    = 4
    !> Thread status: (from `lua_pcall`) error while running a
    !! `__gc` metamethod. For such errors, Lua does not call the message
    !! handler (as this kind of error typically has no relation with the
    !! function being called).
    integer(kind=c_int), parameter, public :: LUA_ERRGCMM   = 5
    !> Thread status: (from `lua_pcall`) error while running the message
    !! handler
    integer(kind=c_int), parameter, public :: LUA_ERRERR    = 6
    !!!@}

    !> @name `libc` function interface

    !!!@{
    interface
        !> Wrapper around C `strlen` function
        function c_strlen(str) bind(c, name='strlen')
            import :: c_ptr, c_size_t
            !> Pointer to string
            type(c_ptr), intent(in), value :: str
            ! Return value, string length
            integer(c_size_t)              :: c_strlen
        end function c_strlen
    end interface
    !!!@}

    !> @name Lua 5.3 function interface

    !!!@{
    interface

        !> @brief Converts the acceptable index idx into an equivalent
        !! absolute index (that is, one that does not depend on the
        !! stack top)
        !!
        !! C signature: `int lua_absindex(lua_State *L, int idx)`
        function lua_absindex(l, idx) bind(c, name='lua_absindex')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of element to test
            integer(kind=c_int), intent(in), value :: idx
            ! Return value
            integer(kind=c_int)                    :: lua_absindex
        end function lua_absindex

        !> @brief Ensures that the stack has space for at least *n* extra
        !! slots (that is, that you can safely push up to *n* values into
        !! it).
        !!
        !! It returns false if it cannot fulfill the request, either
        !! because it would cause the stack to be larger than a fixed
        !! maximum size (typically at least several thousand elements)
        !! or because it cannot allocate memory for the extra space.
        !! This function never shrinks the stack; if the stack already
        !! has space for the extra slots, it is left unchanged.
        !!
        !! C signature: `int lua_checkstack(lua_State *L, int n)`
        function lua_checkstack(l, n) bind(c, name='lua_checkstack')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Desired number of stack entries
            integer(kind=c_int), intent(in), value :: n
            ! Return value
            integer(kind=c_int)                    :: lua_checkstack
        end function lua_checkstack

        !> @brief Compares two Lua values.
        !!
        !! Returns 1 if the value at index
        !! `index1` satisfies op when compared with the value at index
        !! `index2`, following the semantics of the corresponding Lua
        !! operator (that is, it may call metamethods). Otherwise
        !! returns 0. Also returns 0 if any of the indices is not valid.
        !!
        !! The value of op must be one of the following constants:
        !!  * `LUA_OPEQ`: compares for equality (`==`)
        !!  * `LUA_OPLT`: compares for less than (`<`)
        !!  * `LUA_OPLE`: compares for less or equal (`<=`)
        !!
        !! C signature: `int lua_compare(lua_State *L, int index1, int index2, int op)`
        function lua_compare(l, index1, index2, op) bind(c, name='lua_compare')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of first value in comparison
            integer(kind=c_int), intent(in), value :: index1
            !> Index of second value in comparison
            integer(kind=c_int), intent(in), value :: index2
            !> Comparison operator (one of `LUA_OPEQ`, `LUA_OPLT`, or `LUA_OPLE`)
            integer(kind=c_int), intent(in), value :: op
            ! Return value
            integer(kind=c_int)                    :: lua_compare
        end function lua_compare

        !> @brief Generates a Lua error, using the value at the top of
        !! the stack as the error object.
        !!
        !! This function does a long jump, and therefore never returns
        !! (see `luaL_error`)
        !!
        !! C signature: `int lua_error(lua_State *L)`
        function lua_error(l) bind(c, name='lua_error')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            ! Return value
            integer(kind=c_int)                    :: lua_error
        end function lua_error

        !> @brief Controls the garbage collector.
        !!
        !! This function performs several tasks, according to the value
        !! of the parameter `what`:
        !!
        !!    * `LUA_GCSTOP`: stops the garbage collector.
        !!    * `LUA_GCRESTART`: restarts the garbage collector.
        !!    * `LUA_GCCOLLECT`: performs a full garbage-collection cycle.
        !!    * `LUA_GCCOUNT`: returns the current amount of memory (in Kbytes) in use by Lua.
        !!    * `LUA_GCCOUNTB`: returns the remainder of dividing the current amount of bytes of memory in use by Lua by 1024.
        !!    * `LUA_GCSTEP`: performs an incremental step of garbage collection.
        !!    * `LUA_GCSETPAUSE`: sets `data` as the new value for the pause of the collector; function returns the previous value of the pause.
        !!    * `LUA_GCSETSTEPMUL`: sets `data` as the new value for the step multiplier of the collector; function returns the previous value of the step multiplier.
        !!    * `LUA_GCISRUNNING`: returns a boolean that tells whether the collector is running (i.e., not stopped).
        !!
        !! C signature: `int lua_gc(lua_State *L, int what, int data)`
        function lua_gc(l, what, data) bind(c, name='lua_gc')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Directive to send to garbage collector
            integer(kind=c_int), intent(in), value :: what
            !> Data for setting the garbage collector's step multiplier or pause interval
            integer(kind=c_int), intent(in), value :: data
            ! Return value
            integer(kind=c_int)                    :: lua_gc
        end function lua_gc

        !> @brief Pushes onto the stack the value of the global name.
        !! Returns the type of that value.
        !!
        !! This C API function is shadowed by the Fortran wrapper
        !! function `lua_getglobal()` which automatically terminates the
        !! Fortran string with `\0` for C compatibility. Do not use this
        !! function in Fortran code unless you really know what you are
        !! doing.
        !!
        !! C signature: `int lua_getglobal(lua_State *L, const char *name)`
        function lua_getglobal_(l, name) bind(c, name='lua_getglobal')
            import :: c_char, c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> Name of element to push onto the stack
            character(kind=c_char), intent(in)        :: name
            ! Return value
            integer(kind=c_int)                       :: lua_getglobal_
        end function lua_getglobal_

        ! !> @brief Returns a pointer to a raw memory area associated with
        ! !! the given Lua state.
        ! !!
        ! !! The application can use this area for any purpose; Lua does
        ! !! not use it for anything.
        ! !!
        ! !! Each new thread has this area initialized with a copy of the
        ! !! area of the main thread.
        ! !!
        ! !! By default, this area has the size of a pointer to `void`,
        ! !! but you can recompile Lua with a different size for this
        ! !! area. (See `LUA_EXTRASPACE` in `luaconf.h`.)
        ! !!
        ! !! C signature: `void *lua_getextraspace (lua_State *L)'
        ! function lua_getextraspace(l) bind(c, name='lua_getextraspace')
        !     import :: c_ptr
        !     !> Pointer to Lua interpreter state
        !     type(c_ptr), intent(in), value :: l
        !     ! Return value
        !     type(c_ptr)                    :: lua_getextraspace
        ! end function lua_getextraspace

        !> @brief Pushes onto the stack the value `t[k]`, where `t` is the
        !! value (table) at the given index. Returns the type of the pushed
        !! value (`t[k]`).
        !!
        !! As in Lua, this function may trigger a metamethod for the
        !! "index" event.
        !!
        !! This C API function is shadowed by the Fortran wrapper
        !! function `lua_getfield()` which automatically terminates the
        !! Fortran string (`name`) with `\0` for C compatibility. Do not
        !! use this function in Fortran code unless you really know what
        !! you are doing.
        !!
        !! C signature: `int lua_getfield(lua_State *L, int index, const char *name)`
        function lua_getfield_(l, idx, name) bind(c, name='lua_getfield')
            import :: c_char, c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> Index of table
            integer(kind=c_int),    intent(in), value :: idx
            !> Name of field to push onto the stack
            character(kind=c_char), intent(in)        :: name
            ! Return value
            integer(kind=c_int)                       :: lua_getfield_
        end function lua_getfield_

        !> @brief Pushes onto the stack the value of the indexed table
        !! element `t[i]`. Returns the type of that value.
        !!
        !! C signature: `int lua_geti (lua_State *L, int index, lua_Integer i)`
        function lua_geti(l, idx, i) bind(c, name='lua_geti')
            import :: c_int, c_ptr, c_int64_t
            !> Pointer to Lua interpreter state
            type(c_ptr),             intent(in), value :: l
            !> Index of table on stack
            integer(kind=c_int), intent(in), value     :: idx
            !> Index of value in table
            integer(kind=c_int64_t), intent(in), value :: i
            ! Return value
            integer(kind=c_int)                        :: lua_geti
        end function lua_geti

        !> @brief If the value at the given index has a metatable, the
        !! function pushes that metatable onto the stack and returns 1.
        !! Otherwise, the function returns 0 and pushes nothing on the
        !! stack.
        !!
        !! C signature: `int lua_getmetatable (lua_State *L, int index)`
        function lua_getmetatable(l, idx) bind(c, name='lua_getmetatable')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> Index of element from which the metatable will be extracted
            integer(kind=c_int), intent(in), value    :: idx
            ! Return value
            integer(kind=c_int)                       :: lua_getmetatable
        end function lua_getmetatable

        !> @brief Pushes onto the stack the value `t[k]`, where `t` is
        !! the value at the given index (a table) and `k` is the value
        !! at the top of the stack (key).
        !!
        !! Returns the type of the pushed value.
        !!
        !! This function pops the key from the stack, pushing the
        !! resulting value in its place. As in Lua, this function may
        !! trigger a metamethod for the "index" event.
        !!
        !! C signature: `int lua_gettable (lua_State *L, int index)`
        function lua_gettable(l, idx) bind(c, name='lua_gettable')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> Index of table on stack
            integer(kind=c_int), intent(in), value    :: idx
            ! Return value
            integer(kind=c_int)                       :: lua_gettable
        end function lua_gettable

        !> @brief Returns the index of the top element in the stack.
        !!
        !! Because indices start at 1, this result is equal to the
        !! number of elements in the stack; in particular, 0 means an
        !! empty stack.
        !!
        !! C signature: `int lua_gettop(lua_State *L)`
        function lua_gettop(l) bind(c, name='lua_gettop')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
            ! Return value
            integer(kind=c_int)            :: lua_gettop
        end function lua_gettop

        !> @brief Pushes onto the stack the Lua value associated with
        !! the full userdata at the given index.
        !!
        !! Returns the type of the pushed value.
        !!
        !! C signature: `int lua_getuservalue (lua_State *L, int index)`
        function lua_getuservalue(l, idx) bind(c, name='lua_getuservalue')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> Index of userdata on stack
            integer(kind=c_int), intent(in), value    :: idx
            ! Return value
            integer(kind=c_int)                       :: lua_getuservalue
        end function lua_getuservalue

        !> @brief Moves the top element into the given valid index,
        !! shifting up the elements above this index to open space.
        !!
        !! This function cannot be called with a pseudo-index, because
        !! a pseudo-index is not an actual stack position.
        !!
        !! C signature: `void lua_insert (lua_State *L, int index)`
        subroutine lua_insert(l, idx) bind(c, name='lua_insert')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> Index of table on stack
            integer(kind=c_int), intent(in), value    :: idx
        end subroutine lua_insert

        !> @brief Returns 1 if the value at the given index is a
        !! C function, and 0 otherwise.
        !!
        !! C signature: `int lua_iscfunction(lua_State *L, int idx)`
        function lua_iscfunction_(l, idx) bind(c, name='lua_iscfunction')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of element to test
            integer(kind=c_int), intent(in), value :: idx
            ! Return value
            integer(kind=c_int)                    :: lua_iscfunction_
        end function lua_iscfunction_

        !> @brief Returns 1 if the value at the given index is an
        !! integer (that is, the value is a number and is represented
        !! as an integer), and 0 otherwise.
        !!
        !! C signature: `int lua_isinteger(lua_State *L, int idx)`
        function lua_isinteger_(l, idx) bind(c, name='lua_isinteger')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of element to test
            integer(kind=c_int), intent(in), value :: idx
            ! Return value
            integer(kind=c_int)                    :: lua_isinteger_
        end function lua_isinteger_

        !> @brief Returns 1 if the value at the given index is a number
        !! or a string convertible to a number, and 0 otherwise.
        !!
        !! C signature: `int lua_isnumber(lua_State *L, int idx)`
        function lua_isnumber_(l, idx) bind(c, name='lua_isnumber')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of element to test
            integer(kind=c_int), intent(in), value :: idx
            ! Return value
            integer(kind=c_int)                    :: lua_isnumber_
        end function lua_isnumber_

        !> @brief Returns 1 if the value at the given index is a string
        !! or a number (which is always convertible to a string), and 0
        !! otherwise.
        !!
        !! C signature: `int lua_isstring(lua_State *L, int idx)`
        function lua_isstring_(l, idx) bind(c, name='lua_isstring')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of element to test
            integer(kind=c_int), intent(in), value :: idx
            ! Return value
            integer(kind=c_int)                    :: lua_isstring_
        end function lua_isstring_

        !> @brief Returns 1 if the value at the given index is a
        !! userdata (either full or light), and 0 otherwise.
        !!
        !! C signature: `int lua_isuserdata(lua_State *L, int idx)`
        function lua_isuserdata_(l, idx) bind(c, name='lua_isuserdata')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of element to test
            integer(kind=c_int), intent(in), value :: idx
            ! Return value
            integer(kind=c_int)                    :: lua_isuserdata_
        end function lua_isuserdata_

        !> @brief Returns 1 if the given coroutine can yield, and 0
        !! otherwise.
        !!
        !! C signature: `int lua_isyieldable(lua_State *L)`
        function lua_isyieldable_(l) bind(c, name='lua_isyieldable')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
            ! Return value
            integer(kind=c_int)            :: lua_isyieldable_
        end function lua_isyieldable_

        !> @brief Returns the length of the value at the given index.
        !!
        !! It is equivalent to the '#' operator in Lua and may trigger a
        !! metamethod for the "length" event. The result is pushed on
        !! the stack.
        !!
        !! C signature: `void lua_len (lua_State *L, int index)`
        subroutine lua_len(l, idx) bind(c, name='lua_len')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of element to test
            integer(kind=c_int), intent(in), value :: idx
        end subroutine lua_len

        !> @brief Loads a Lua chunk without running it.
        !!
        !! If there are no errors, `lua_load` pushes the compiled chunk
        !! as a Lua function on top of the stack. Otherwise, it pushes
        !! an error message.
        !!
        !! The return values of `lua_load` are:
        !!   * `LUA_OK`: no errors;
        !!   * `LUA_ERRSYNTAX`: syntax error during precompilation;
        !!   * `LUA_ERRMEM`: memory allocation (out-of-memory) error;
        !!   * `LUA_ERRGCMM`: error while running a `__gc` metamethod.
        !!     (This error has no relation with the chunk being loaded.
        !!     It is generated by the garbage collector.)
        !!
        !! The `lua_load` function uses a user-supplied reader function
        !! to read the chunk (see `lua_Reader`). The `data` argument is
        !! an opaque value passed to the reader function.
        !!
        !! The chunkname argument gives a name to the chunk, which is
        !! used for error messages and in debug information.
        !!
        !! `lua_load` automatically detects whether the chunk is text or
        !! binary and loads it accordingly (see program `luac`). The
        !! string `mode` works as in function `load`, with the addition
        !! that a `NULL` value is equivalent to the string "bt".
        !!
        !! `lua_load` uses the stack internally, so the reader function
        !! must always leave the stack unmodified when returning.
        !!
        !! If the resulting function has upvalues, its first upvalue is
        !! set to the value of the global environment stored at index
        !! `LUA_RIDX_GLOBALS` in the registry. When loading main chunks,
        !! this upvalue will be the `_ENV` variable. Other upvalues are
        !! initialized with `nil`.
        !!
        !! C signature: `int lua_load(lua_State *L, lua_Reader reader, void *data, const char *chunkname, const char *mode)`
        function lua_load(l, reader, data, chunkname, mode) bind(c, name='lua_load')
            import :: c_char, c_funptr, c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> Pointer to a user-supplied reader function to read the
            !! chunk (see `lua_Reader`)
            type(c_funptr),         intent(in), value :: reader
            !> An opaque value passed to the reader function
            type(c_ptr),            intent(in), value :: data
            !> Name for the chunk, used for error messages and in debug
            !! information
            character(kind=c_char), intent(in)        :: chunkname
            !> Binary/text chunk mode. `mode` works as in function
            !! `load`, with the addition that a `NULL` value is
            !! equivalent to the string "bt".
            character(kind=c_char), intent(in)        :: mode
            ! Return value
            integer(kind=c_int)                       :: lua_load
        end function lua_load

        !> @brief Pops a key from the stack, and pushes a key–value pair
        !! from the table at the given index (the "next" pair after the
        !! given key). If there are no more elements in the table, then
        !! `lua_next` returns 0 (and pushes nothing).
        !!
        !! A typical traversal looks like this:
        !!
        !! @code{.c}
        !! /* table is in the stack at index 't' */
        !! lua_pushnil(L);  /* first key */
        !! while (lua_next(L, t) != 0) {
        !!   /* uses 'key' (at index -2) and 'value' (at index -1) */
        !!   printf("%s - %s\n",
        !!          lua_typename(L, lua_type(L, -2)),
        !!          lua_typename(L, lua_type(L, -1)));
        !!   /* removes 'value'; keeps 'key' for next iteration */
        !!   lua_pop(L, 1);
        !! }
        !! @endcode
        !!
        !! or
        !!
        !! @code{.f90}
        !! ! Table is in the stack at index 't'
        !! ! Push nil to stack which tells lua_next() to get the first
        !! ! key-value pair
        !! call lua_pushnil(L)
        !! do while (lua_next(L, t) /= 0)
        !!   ! Uses 'key' (at index -2) and 'value' (at index -1)
        !!   write(unit=output_unit, format='(A, " - ", A)')         &
        !!          lua_typename(L, lua_type(L, -2)),                &
        !!          lua_typename(L, lua_type(L, -1)))
        !!   ! removes 'value'; keeps 'key' for next iteration
        !!   call lua_pop(L, 1)
        !! end do
        !! @endcode
        !!
        !! While traversing a table, do not call `lua_tolstring`
        !! directly on a key, unless you know that the key is actually a
        !! string. Recall that `lua_tolstring` may change the value at
        !! the given index; this confuses the next call to `lua_next`.
        !!
        !! See the Lua function `next` for the caveats of modifying the
        !! table during its traversal.
        !!
        !! C signature: `int lua_next (lua_State *L, int index)`
        function lua_next(l, idx) bind(c, name='lua_next')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of previous key extracted from table; set to `nil`
            !! to extract first key
            integer(kind=c_int), intent(in), value :: idx
            ! Return value
            integer(kind=c_int)                    :: lua_next
        end function lua_next

        !> @brief Converts a Lua float to a Lua integer.
        !!
        !! This macro assumes that `n` has an integral value. If that
        !! value is within the range of Lua integers, it is converted to
        !! an integer and assigned to `*p`. The macro results in a
        !! boolean indicating whether the conversion was successful.
        !!
        !! It is probably best to use Fortran's `int()` intrinsic
        !! instead.
        !!
        !! @note This range test can be tricky to do correctly without
        !! this macro, due to roundings.
        !!
        !! C signature: `int lua_numbertointeger (lua_Number n, lua_Integer *p)`
        function lua_numbertointeger(n, i) bind(c, name='lua_numbertointeger')
            import :: c_int, c_double, c_long_long
            !> Pointer to Lua interpreter state
            real(kind=c_double),       intent(in), value :: n
            !> Index of previous key extracted from table; set to `nil`
            !! to extract first key
            integer(kind=c_long_long), intent(in)        :: i
            ! Return value
            integer(kind=c_int)                          :: lua_numbertointeger
        end function lua_numbertointeger

        !> @brief Does the equivalent to `t[k] = v`, where `t` is the
        !! value (table) at the given index and `v` is the value at the
        !! top of the stack.
        !!
        !! This function pops the value from the stack. As in Lua, this
        !! function may trigger a metamethod for the "newindex" event
        !!
        !! This C API function is shadowed by the Fortran wrapper
        !! function `lua_setfield()` which automatically terminates the
        !! Fortran string (`name`) with `\0` for C compatibility. Do not
        !! use this function in Fortran code unless you really know what
        !! you are doing.
        !!
        !! C signature: `void lua_setfield (lua_State *L, int index, const char *k);`
        subroutine lua_setfield_(l, idx, name) bind(c, name='lua_setfield')
            import :: c_char, c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> Index of table
            integer(kind=c_int),    intent(in), value :: idx
            !> Name of field (key) to push onto the stack
            character(kind=c_char), intent(in)        :: name
        end subroutine lua_setfield_

        !> @brief Does the equivalent to `t[n] = v`, where `t` is the
        !! value at the given index and `v` is the value at the top of
        !! the stack.
        !!
        !! This function pops the value from the stack. As in Lua, this
        !! function may trigger a metamethod for the "newindex" event
        !!
        !! C signature: `void lua_seti (lua_State *L, int index, lua_Integer n)`
        subroutine lua_seti(l, idx, n) bind(c, name='lua_seti')
            import :: c_int, c_ptr, c_int64_t
            !> Pointer to Lua interpreter state
            type(c_ptr),             intent(in), value :: l
            !> Index of table on stack
            integer(kind=c_int), intent(in), value     :: idx
            !> Index of value in table
            integer(kind=c_int64_t), intent(in), value :: n
        end subroutine lua_seti

        !> @brief Pops a table from the stack and sets it as the new
        !! metatable for the value at the given index.
        !!
        !! C signature: `void lua_setmetatable (lua_State *L, int index)`
        subroutine lua_setmetatable(l, idx) bind(c, name='lua_setmetatable')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> Index of stack to associate with metatable
            integer(kind=c_int), intent(in), value    :: idx
        end subroutine lua_setmetatable

        !> @brief Does the equivalent to t[k] = v, where t is the value
        !! at the given index, v is the value at the top of the stack,
        !! and k is the value just below the top.
        !!
        !! This function pops both the key and the value from the stack.
        !! As in Lua, this function may trigger a metamethod for the
        !! "newindex" event
        !!
        !! C signature: `void lua_settable (lua_State *L, int index)`
        subroutine lua_settable(l, idx) bind(c, name='lua_settable')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> Index of table on stack
            integer(kind=c_int), intent(in), value    :: idx
        end subroutine lua_settable

        !> @brief Returns the status of the thread `L`.
        !!
        !! The status can be 0 (`LUA_OK`) for a normal thread, an error
        !! code if the thread finished the execution of a `lua_resume`
        !! with an error, or `LUA_YIELD` if the thread is suspended.
        !!
        !! You can only call functions in threads with status `LUA_OK`.
        !! You can resume threads with status `LUA_OK` (to start a new
        !! coroutine) or `LUA_YIELD` (to resume a coroutine).
        !!
        !! C signature: `int lua_status(lua_State *L)`
        function lua_status(l) bind(c, name='lua_status')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
            ! Return value
            integer(kind=c_int)            :: lua_status
        end function lua_status

        !> @brief Converts the zero-terminated string s to a number,
        !! pushes that number into the stack, and returns the total size
        !! of the string, that is, its length plus one.
        !!
        !! The conversion can result in an integer or a float, according
        !! to the lexical conventions of Lua. The string may have
        !! leading and trailing spaces and a sign. If the string is not
        !! a valid numeral, returns 0 and pushes nothing. (Note that the
        !! result can be used as a boolean, `true` if the conversion
        !! succeeds.)
        !!
        !! @note This C function wrapper returns a null-terminated
        !! C string, not a Fortran-style string. Use `lua_stringtonumber`
        !! instead.
        !!
        !! C signature: `int luaL_loadstring (lua_State *L, const char *s)`
        function lua_stringtonumber_(l, s) bind(c, name='lua_stringtonumber')
            import :: c_char, c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> String containing a Lua chunk
            character(kind=c_char), intent(in)        :: s
            ! Return value
            integer(kind=c_int)                       :: lua_stringtonumber_
        end function lua_stringtonumber_

        !> @brief Converts the Lua value at the given index to
        !! a C boolean value (0 or 1; zero is false, non-zero is true).
        !!
        !! Like all tests in Lua, `lua_toboolean_` returns `true` for any
        !! Lua value different from `false` and `nil`; otherwise it
        !! returns false. (If you want to accept only actual boolean
        !! values, use `lua_isboolean` to test the value's type.)
        !!
        !! @note This C function wrapper returns a Fortran integer, not
        !! a logical value. Use `lua_toboolean` instead.
        !!
        !! C signature: `int lua_toboolean (lua_State *L, int index)`
        function lua_toboolean_(l, idx) bind(c, name='lua_toboolean')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of entry to convert
            integer(kind=c_int), intent(in), value :: idx
            ! Return value
            integer(kind=c_int)                    :: lua_toboolean_
        end function lua_toboolean_

        !> @brief Converts the Lua value at the given index to the
        !! signed integral type `lua_Integer`.
        !!
        !! The Lua value must be an integer, or a number or string
        !! convertible to an integer; otherwise, `lua_tointegerx`
        !! returns 0.
        !!
        !! If `isnum` is not `NULL`, its referent is assigned a
        !! boolean value that indicates whether the operation succeeded.
        !!
        !! C signature: `lua_Integer lua_tointegerx(lua_State *L, int idx, int *isnum)`
        function lua_tointegerx(l, idx, isnum) bind(c, name='lua_tointegerx')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of entry to convert
            integer(kind=c_int), intent(in), value :: idx
            !> Operation success flag
            type(c_ptr),         intent(in), value :: isnum
            ! Return value
            integer(kind=c_int)                    :: lua_tointegerx
        end function lua_tointegerx

        !> @brief Converts the Lua value at the given index to the C type `lua_Number`.
        !!
        !! The Lua value must be a number or a string convertible to a
        !! number; otherwise, `lua_tonumberx` returns 0.
        !!
        !! If `isnum` is not `NULL`, its referent is assigned a boolean
        !! value that indicates whether the operation succeeded.
        !!
        !! C signature: `lua_Number lua_tonumberx (lua_State *L, int index, int *isnum);`
        function lua_tonumberx(l, idx, isnum) bind(c, name='lua_tonumberx')
            import :: c_int, c_ptr, c_double
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of entry to convert
            integer(kind=c_int), intent(in), value :: idx
            !> Operation success flag
            type(c_ptr),         intent(in), value :: isnum
            ! Return value
            real(kind=c_double)                    :: lua_tonumberx
        end function lua_tonumberx

        !> @brief Converts the Lua value at the given index to a C
        !! string.
        !!
        !! If `len` is not `NULL`, it sets `*len` with the string
        !! length. The Lua value must be a string or a number;
        !! otherwise, the function returns `NULL`. If the value is a
        !! number, then `lua_tolstring` also changes the actual value in
        !! the stack to a string. (This change confuses `lua_next` when
        !! `lua_tolstring` is applied to keys during a table traversal.)
        !!
        !! `lua_tolstring` returns a pointer to a string inside the Lua
        !! state. This string always has a zero (`'\0'`) after its last
        !! character (as in C), but can contain other zeros in its body.
        !!
        !! Because Lua has garbage collection, there is no guarantee
        !! that the pointer returned by `lua_tolstring` will be valid
        !! after the corresponding Lua value is removed from the stack.
        !!
        !! C signature: `const char *lua_tolstring(lua_State *L, int idx, size_t *len)`
        function lua_tolstring(l, idx, len) bind(c, name='lua_tolstring')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of element to convert
            integer(kind=c_int), intent(in), value :: idx
            !> String length
            type(c_ptr),         intent(in), value :: len
            ! Return value
            type(c_ptr)                            :: lua_tolstring
        end function lua_tolstring

        !> @brief Returns the type of the value in the given valid
        !! index, or `LUA_TNONE` for a non-valid (but acceptable) index.
        !!
        !! The types returned by `lua_type` are coded by the following
        !! constants defined in `lua.h`:
        !!   * `LUA_TNIL` (0),
        !!   * `LUA_TNUMBER`,
        !!   * `LUA_TBOOLEAN`,
        !!   * `LUA_TSTRING`,
        !!   * `LUA_TTABLE`,
        !!   * `LUA_TFUNCTION`,
        !!   * `LUA_TUSERDATA`,
        !!   * `LUA_TTHREAD`, and
        !!   * `LUA_TLIGHTUSERDATA`
        !!
        !! C signature: `int lua_type(lua_State *L, int idx)`
        function lua_type(l, idx) bind(c, name='lua_type')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of entry in stack
            integer(kind=c_int), intent(in), value :: idx
            ! Return value
            integer(kind=c_int)                    :: lua_type
        end function lua_type

        !> @brief Returns the name of the type encoded by the value
        !! `tp`, which must be one the values returned by `lua_type`.
        !!
        !! C signature: `const char *lua_typename(lua_State *L, int tp)`
        function lua_typename_(l, tp) bind(c, name='lua_typename')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Lua value type code
            integer(kind=c_int), intent(in), value :: tp
            ! Return value
            type(c_ptr)                            :: lua_typename_
        end function lua_typename_

        !> @brief Returns the pseudo-index that represents the `i`-th
        !! upvalue of the running function.
        !!
        !! `i` can range from 1 to 256. Upvalues refer to variables
        !! associated with C closures.
        !!
        !! C signature: `int lua_upvalueindex (int i)`
        function lua_upvalueindex(i) bind(c, name='lua_upvalueindex')
            import :: c_int
            !> Upvalue index
            integer(kind=c_int), intent(in), value :: i
            ! Return value
            integer(kind=c_int)                    :: lua_upvalueindex
        end function lua_upvalueindex

        ! Auxilliary library functions

        !> @brief Loads a file as a Lua chunk.
        !!
        !! This function uses `lua_load` to load the chunk in the file
        !! named `filename`. If `filename` is `NULL`, then it loads from
        !! the standard input. The first line in the file is ignored if
        !! it starts with a `#`.
        !!
        !! The string mode works as in function `lua_load`.
        !!
        !! This function returns the same results as `lua_load`, but it
        !! has an extra error code `LUA_ERRFILE` for file-related errors
        !! (e.g., it cannot open or read the file). That is,
        !!   * `LUA_OK`: no errors;
        !!   * `LUA_ERRSYNTAX`: syntax error during precompilation;
        !!   * `LUA_ERRMEM`: memory allocation (out-of-memory) error;
        !!   * `LUA_ERRGCMM`: error while running a `__gc` metamethod.
        !!     (This error has no relation with the chunk being loaded.
        !!     It is generated by the garbage collector.)
        !!   * `LUA_ERRFILE`: file-related errors
        !!
        !! As `lua_load`, this function only loads the chunk; it does
        !! not run it.
        !!
        !! C signature: `int luaL_loadfilex(lua_State *L, const char *filename, const char *mode)`
        function lual_loadfilex(l, filename, mode) bind(c, name='luaL_loadfilex')
            import :: c_char, c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> Name of file containing a Lua chunk
            character(kind=c_char), intent(in)        :: filename
            !> Binary, text, or mixed mode of file (`b`, `t`, or `bt`)
            type(c_ptr),            intent(in), value :: mode
            ! Return value
            integer(kind=c_int)                       :: lual_loadfilex
        end function lual_loadfilex

        !> @brief Loads a string as a Lua chunk.
        !!
        !! This function uses `lua_load` to load the chunk in the
        !! zero-terminated string `s`.
        !!
        !! This function returns the same results as `lua_load`. That is,
        !!   * `LUA_OK`: no errors;
        !!   * `LUA_ERRSYNTAX`: syntax error during precompilation;
        !!   * `LUA_ERRMEM`: memory allocation (out-of-memory) error;
        !!   * `LUA_ERRGCMM`: error while running a `__gc` metamethod.
        !!     (This error has no relation with the chunk being loaded.
        !!     It is generated by the garbage collector.)
        !!
        !! C signature: `int luaL_loadstring (lua_State *L, const char *s)`
        function lual_loadstring_(l, s) bind(c, name='luaL_loadstring')
            import :: c_char, c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> String containing a Lua chunk
            character(kind=c_char), intent(in)        :: s
            ! Return value
            integer(kind=c_int)                       :: lual_loadstring_
        end function lual_loadstring_

        !>  @brief Creates a new Lua state.
        !!
        !! It calls `lua_newstate` with an allocator based on the
        !! standard C `realloc` function and then sets a panic function
        !! that prints an error message to the standard error output in
        !! case of fatal errors.
        !!
        !! Returns the new state, or `NULL` if there is a memory
        !! allocation error.
        !!
        !! C signature: `lua_State *luaL_newstate(void)`
        function lual_newstate() bind(c, name='luaL_newstate')
            import :: c_ptr
            ! Return value, pointer to Lua interpreter state
            type(c_ptr) :: lual_newstate
        end function lual_newstate

        ! Back to Lua C API functions

        !> @brief Calls a function in protected mode with the ability to
        !! yield
        !!
        !! Both `nargs` and `nresults` have the same meaning as in
        !! `lua_call`. If there are no errors during the call,
        !! `lua_pcallk` behaves exactly like `lua_callk`. However, if
        !! there is any error, `lua_pcallk` catches it, pushes a single
        !! value on the stack (the error object), and returns an error
        !! code. Like `lua_call`, `lua_pcallk` always removes the
        !! function and its arguments from the stack.
        !!
        !! If `msgh` is 0, then the error object returned on the stack
        !! is exactly the original error object. Otherwise, `msgh` is
        !! the stack index of a message handler. (This index cannot be a
        !! pseudo-index.) In case of runtime errors, this function will
        !! be called with the error object and its return value will be
        !! the object returned on the stack by `lua_pcallk`.
        !!
        !! Typically, the message handler is used to add more debug
        !! information to the error object, such as a stack traceback.
        !! Such information cannot be gathered after the return of
        !! `lua_pcallk`, since by then the stack has unwound.
        !!
        !! The `lua_pcallk` function returns one of the following
        !! constants (defined in `lua.h`):
        !!   * `LUA_OK` (0): success.
        !!   * `LUA_ERRRUN`: a runtime error.
        !!   * `LUA_ERRMEM`: memory allocation error. For such errors,
        !!     Lua does not call the message handler.
        !!   * `LUA_ERRERR`: error while running the message handler.
        !!   * `LUA_ERRGCMM`: error while running a `__gc` metamethod.
        !!     For such errors, Lua does not call the message handler
        !!     (as this kind of error typically has no relation with the
        !!     function being called).
        !!
        !! C signature: `int lua_pcallk(lua_State *L, int nargs, int nresults, int msgh, lua_KContext ctx, lua_KFunction k)`
        function lua_pcallk(l, nargs, nresults, msgh, ctx, k) bind(c, name='lua_pcallk')
            import :: c_funptr, c_int, c_intptr_t, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),              intent(in), value :: l
            !> The number of arguments pushed onto the stack
            integer(kind=c_int),      intent(in), value :: nargs
            !> The maximum number of results to return unless
            !! `nresults` is `LUA_MULTRET`
            integer(kind=c_int),      intent(in), value :: nresults
            !> Stack index of the message handler
            integer(kind=c_int),      intent(in), value :: msgh
            !> The continuation-function context
            integer(kind=c_intptr_t), intent(in), value :: ctx
            !> Pointer to continuation-function, for handling yield cases
            type(c_funptr),           intent(in), value :: k
            ! Return value
            integer(kind=c_int)                         :: lua_pcallk
        end function lua_pcallk

        !> @brief Pushes the global environment onto the stack.
        !!
        !! C signature: `void lua_pushglobaltable (lua_State *L)`
        subroutine lua_pushglobaltable(l) bind(c, name='lua_pushglobaltable')
            import :: c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
        end subroutine lua_pushglobaltable

        !> @brief Pushes the string pointed to by `s` with size `len`
        !! onto the stack.
        !!
        !! Lua makes (or reuses) an internal copy of the given string,
        !! so the memory at `s` can be freed or reused immediately
        !! after the function returns. The string can contain any
        !! binary data, including embedded zeros.
        !!
        !! Returns a pointer to the internal copy of the string.
        !!
        !! C signature: `const char *lua_pushlstring(lua_State *L, const char *s, size_t len)`
        function lua_pushlstring(l, s, len) bind(c, name='lua_pushlstring')
            import :: c_char, c_ptr, c_size_t
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> String to push onto stack
            character(kind=c_char), intent(in)        :: s
            !> String length
            integer(kind=c_size_t), intent(in), value :: len
            ! Return value
            type(c_ptr)                               :: lua_pushlstring
        end function lua_pushlstring

        !> @brief Pushes the zero-terminated string pointed to by `s`
        !! onto the stack.
        !!
        !! Lua makes (or reuses) an internal copy of the given string,
        !! so the memory at `s` can be freed or reused immediately
        !! after the function returns.
        !!
        !! Returns a pointer to the internal copy of the string.
        !!
        !! If `s` is `NULL`, pushes `nil` and returns `NULL`.
        !!
        !! C signature: `const char *lua_pushstring(lua_State *L, const char *s)`
        function lua_pushstring(l, s) bind(c, name='lua_pushstring')
            import :: c_char, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> String to push onto stack
            character(kind=c_char), intent(in)        :: s
            ! Return value
            type(c_ptr)                               :: lua_pushstring
        end function lua_pushstring

        !> @brief Pushes the thread represented by `L` onto the stack.
        !!
        !! Returns 1 if this thread is the main thread of its state.
        !!
        !! C signature: `int lua_pushthread(lua_State *L)`
        function lua_pushthread(l) bind(c, name='lua_pushthread')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
            ! Return value
            integer(kind=c_int)            :: lua_pushthread
        end function lua_pushthread

        !> @brief Performs an arithmetic or bitwise operation over the
        !! two values (or one, in the case of negations) at the top of
        !! the stack, with the value at the top being the second
        !! operand, pops these values, and pushes the result of the
        !! operation.
        !!
        !! The function follows the semantics of the corresponding Lua
        !! operator (that is, it may call metamethods).
        !!
        !! The value of `op` must be one of the following constants:
        !!   * `LUA_OPADD`: performs addition (`+`)
        !!   * `LUA_OPSUB`: performs subtraction (`-`)
        !!   * `LUA_OPMUL`: performs multiplication (`*`)
        !!   * `LUA_OPDIV`: performs float division (`/`)
        !!   * `LUA_OPIDIV`: performs floor division (`//`)
        !!   * `LUA_OPMOD`: performs modulo (`%`)
        !!   * `LUA_OPPOW`: performs exponentiation (`^`)
        !!   * `LUA_OPUNM`: performs mathematical negation (unary `-`)
        !!   * `LUA_OPBNOT`: performs bitwise NOT (`~`)
        !!   * `LUA_OPBAND`: performs bitwise AND (`&`)
        !!   * `LUA_OPBOR`: performs bitwise OR (`|`)
        !!   * `LUA_OPBXOR`: performs bitwise exclusive OR (`~`)
        !!   * `LUA_OPSHL`: performs left shift (`<<`)
        !!   * `LUA_OPSHR`: performs right shift (`>>`)
        !!
        !! C signature: `void lua_arith(lua_State *L, int op)`
        subroutine lua_arith(l, op) bind(c, name='lua_arith')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Arithmetic or bitwise operator code
            integer(kind=c_int), intent(in), value :: op
        end subroutine lua_arith

        !> @brief Calls a function which may yield
        !!
        !! To call a function you must use the following protocol:
        !!   1) first, the function to be called is pushed onto the
        !!      stack;
        !!   2) then, the arguments to the function are pushed in
        !!      direct order; that is, the first argument is pushed
        !!      first.
        !!   3) Finally you call `lua_callk`;
        !!
        !! `nargs` is the number of arguments that you pushed onto the
        !! stack. All arguments and the function value are popped from
        !! the stack when the function is called. The function results
        !! are pushed onto the stack when the function returns. The
        !! number of results is adjusted to `nresults`, unless
        !! `nresults` is `LUA_MULTRET`. In this case, all results from
        !! the function are pushed; Lua takes care that the returned
        !! values fit into the stack space, but it does not ensure any
        !! extra space in the stack. The function results are pushed
        !! onto the stack in direct order (the first result is pushed
        !! first), so that after the call the last result is on the
        !! top of the stack.
        !!
        !! Any error inside the called function is propagated upwards
        !! (with a longjmp).
        !!
        !! C signature: `void lua_callk(lua_State *L, int nargs, int nresults, int ctx, lua_CFunction k)`
        subroutine lua_callk(l, nargs, nresults, ctx, k) bind(c, name='lua_callk')
            import :: c_funptr, c_int, c_intptr_t, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),              intent(in), value :: l
            !> Number of arguments pushed onto stack
            integer(kind=c_int),      intent(in), value :: nargs
            !> Maximum number of results
            integer(kind=c_int),      intent(in), value :: nresults
            !> The continuation-function context
            integer(kind=c_intptr_t), intent(in), value :: ctx
            !> Pointer to the continuation-function, for handling yield
            !! cases
            type(c_funptr),           intent(in), value :: k
        end subroutine lua_callk

        !> @brief Destroys all objects in the given Lua state (calling
        !! the corresponding garbage-collection metamethods, if any) and
        !! frees all dynamic memory used by this state.
        !!
        !! In several platforms, you may not need to call this function,
        !! because all resources are naturally released when the host
        !! program ends. On the other hand, long-running programs that
        !! create multiple states, such as daemons or web servers, will
        !! probably need to close states as soon as they are not needed.
        !!
        !! C signature: `void lua_close(lua_State *L)`
        subroutine lua_close(l) bind(c, name='lua_close')
            import :: c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
        end subroutine lua_close

        !> @brief Concatenates the `n` values at the top of the stack,
        !! pops them, and leaves the result at the top.
        !!
        !! If `n` is 1, the result is the single value on the stack
        !! (that is, the function does nothing); if `n` is 0, the result
        !! is the empty string. Concatenation is performed following the
        !! usual semantics of Lua
        !!
        !! C signature: `void lua_concat(lua_State *L, int n)`
        subroutine lua_concat(l, n) bind(c, name='lua_concat')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Number of stack values to concatenate
            integer(kind=c_int), intent(in), value :: n
        end subroutine lua_concat

        !> @brief Copies the element at index `fromidx` into the valid
        !! index `toidx`, replacing the value at that position.
        !!
        !! Values at other positions are not affected.
        !!
        !! C signature: `void lua_copy(lua_State *L, int fromidx, int toidx)`
        subroutine lua_copy(l, fromidx, toidx) bind(c, name='lua_copy')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Source element index
            integer(kind=c_int), intent(in), value :: fromidx
            !> Destination element index
            integer(kind=c_int), intent(in), value :: toidx
        end subroutine lua_copy

        !> @brief Creates a new empty table and pushes it onto the
        !! stack, with hints to preallocate size.
        !!
        !! Parameter `narr` is a hint for how many elements the table
        !! will have as a sequence; parameter `nrec` is a hint for how
        !! many other elements the table will have. Lua may use these
        !! hints to preallocate memory for the new table. This
        !! preallocation is useful for performance when you know in
        !! advance how many elements the table will have. Otherwise you
        !! can use the function `lua_newtable`.
        !!
        !! C signature: `void lua_createtable(lua_State *L, int narr, int nrec)`
        subroutine lua_createtable(l, narr, nrec) bind(c, name='lua_creatable')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Hint of number of elements in the table as a sequence
            !! (with implied numeric index; array-like)
            integer(kind=c_int), intent(in), value :: narr
            !> Hint of number of other elements in the table
            !! (with explicit key; dict-like)
            integer(kind=c_int), intent(in), value :: nrec
        end subroutine lua_createtable

        !> @brief Creates a new empty table and pushes it onto the stack.
        !!
        !! `lua_newtable(L)` is equivalent to `lua_createtable(L, 0, 0)`.
        !!
        !! C signature: `void lua_newtable(lua_State *L)`
        subroutine lua_newtable(l) bind(c, name='lua_newtable')
            import :: c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
        end subroutine lua_newtable

        !> @brief Pushes a boolean value with value `b` onto the stack.
        !!
        !! C signature: `void lua_pushboolean(lua_State *L, int b)`
        subroutine lua_pushboolean(l, b) bind(c, name='lua_pushboolean')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Boolean value to push onto the stack
            integer(kind=c_int), intent(in), value :: b
        end subroutine lua_pushboolean

        !> @brief Pushes a new C closure onto the stack.
        !!
        !! When a C function is created, it is possible to associate
        !! some values with it, thus creating a C closure; these values
        !! are then accessible to the function whenever it is called.
        !! To associate values with a C function, first these values
        !! must be pushed onto the stack (when there are multiple
        !! values, the first value is pushed first). Then
        !! `lua_pushcclosure` is called to create and push the C
        !! function onto the stack, with the argument `n` telling how
        !! many values will be associated with the function.
        !! `lua_pushcclosure` also pops these values from the stack.
        !!
        !! C signature: `void lua_pushcclosure(lua_State *L, lua_CFunction fn, int n)`
        subroutine lua_pushcclosure(l, fn, n) bind(c, name='lua_pushcclosure')
            import :: c_funptr, c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Pointer to C closure function
            type(c_funptr),      intent(in), value :: fn
            !> Number of values associated with the closure
            integer(kind=c_int), intent(in), value :: n
        end subroutine lua_pushcclosure

        !> @brief Pushes an integer with value `n` onto the stack.
        !!
        !! C signature: `void lua_pushinteger(lua_State *L, lua_Integer n)`
        subroutine lua_pushinteger(l, n) bind(c, name='lua_pushinteger')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Integer value to push onto the stack
            integer(kind=c_int), intent(in), value :: n
        end subroutine lua_pushinteger

        !> @brief Pushes a light userdata onto the stack.
        !!
        !! Userdata represent C values in Lua. A light userdata
        !! represents a pointer, a `void*`. It is a value (like a
        !! number): you do not create it, it has no individual
        !! metatable, and it is not collected (as it was never created).
        !! A light userdata is equal to "any" light userdata with the
        !! same C address.
        !!
        !! C signature: `void  lua_pushlightuserdata(lua_State *L, void *p)`
        subroutine lua_pushlightuserdata(l, p) bind(c, name='lua_pushlightuserdata')
            import :: c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
            !> Pointer representing a light userdata
            type(c_ptr), intent(in), value :: p
        end subroutine lua_pushlightuserdata

        !> @brief Pushes a `nil` value onto the stack.
        !!
        !! C signature: `void lua_pushnil(lua_State *L)`
        subroutine lua_pushnil(l) bind(c, name='lua_pushnil')
            import :: c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
        end subroutine lua_pushnil

        !> @brief Pushes a float with value `n` onto the stack.
        !!
        !! C signature: `void lua_pushnumber(lua_State *L, lua_Number n)`
        subroutine lua_pushnumber(l, n) bind(c, name='lua_pushnumber')
            import :: c_float, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),        intent(in), value :: l
            !> Float to push onto the stack
            real(kind=c_float), intent(in), value :: n
        end subroutine lua_pushnumber

        !> @brief Pushes a copy of the element at the given index onto the stack.
        !!
        !! C signature: `void  lua_pushvalue(lua_State *L, int idx)`
        subroutine lua_pushvalue(l, idx) bind(c, name='lua_pushvalue')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of element to copy and push onto stack
            integer(kind=c_int), intent(in), value :: idx
        end subroutine lua_pushvalue

        !> @brief Returns 1 (true) if the two values in indices index1
        !! and index2 are primitively equal (that is, without calling
        !! the `__eq` metamethod).
        !!
        !! Otherwise returns 0 (false). Also returns 0 if any of the
        !! indices are not valid.
        !!
        !! C signature: `int lua_rawequal (lua_State *L, int index1, int index2)`
        function lua_rawequal(l, idx1, idx2) bind(c, name='lua_rawequal')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
            !> Stack index of first value
            integer(kind=c_int), intent(in), value :: idx1
            !> Stack index of second value
            integer(kind=c_int), intent(in), value :: idx2
            ! Return value
            integer(kind=c_int)            :: lua_rawequal
        end function lua_rawequal

        !> @brief Pushes onto the stack the value `t[k]`, where t is the
        !! value at the given index and `k` is the value at the top of
        !! the stack.
        !!
        !! This function pops the key from the stack, pushing the
        !! resulting value in its place. Unlike `lua_gettable`, this
        !! function does not trigger metamethods.
        !!
        !! Returns the type of the pushed value.
        !!
        !! C signature: `int lua_rawget (lua_State *L, int index)`
        function lua_rawget(l, idx) bind(c, name='lua_rawget')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
            !> Stack index of table
            integer(kind=c_int), intent(in), value :: idx
            ! Return value
            integer(kind=c_int)            :: lua_rawget
        end function lua_rawget

        !> @brief Pushes onto the stack the value of the indexed table
        !! element `t[n]`. Returns the type of that value.
        !!
        !! Similar to `lua_geti` but uses "raw" access and does not
        !! trigger metamethods.
        !!
        !! C signature: `int lua_rawgeti (lua_State *L, int index, lua_Integer n)`
        function lua_rawgeti(l, idx, n) bind(c, name='lua_rawgeti')
            import :: c_int, c_ptr, c_int64_t
            !> Pointer to Lua interpreter state
            type(c_ptr),             intent(in), value :: l
            !> Index of table on stack
            integer(kind=c_int), intent(in), value     :: idx
            !> Index of value in table
            integer(kind=c_int64_t), intent(in), value :: n
            ! Return value
            integer(kind=c_int)                        :: lua_rawgeti
        end function lua_rawgeti

        !> @brief Returns the raw "length" of the value at the given index.
        !!
        !! For strings, this is the string length; for tables, this is the
        !! result of the length operator ('`#`') with no metamethods; for
        !! userdata, this is the size of the block of memory allocated for
        !! the userdata; for other values, it is 0.
        !!
        !! C signature: `size_t lua_rawlen (lua_State *L, int index)`
        function lua_rawlen(l, idx) bind(c, name='lua_rawlen')
            import :: c_int, c_ptr, c_size_t
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of element to test
            integer(kind=c_int), intent(in), value :: idx
            ! Return value
            integer(kind=c_size_t)                 :: lua_rawlen
        end function lua_rawlen

        !> @brief Does the equivalent to `t[k] = v`, where `t` is the
        !! value at the given index, `v` is the value at the top of the
        !! stack, and `k` is the value just below the top.
        !!
        !! This function pops both the key and the value from the stack.
        !! Unlike `lua_settable`, this function will not trigger
        !! metamethods.
        !!
        !! C signature: `void lua_rawset (lua_State *L, int index)`
        subroutine lua_rawset(l, idx) bind(c, name='lua_rawset')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> Index of table on stack
            integer(kind=c_int), intent(in), value    :: idx
        end subroutine lua_rawset

        !> @brief Does the equivalent of `t[i] = v`, where `t` is the
        !! table at the given index and `v` is the value at the top of
        !! the stack.
        !!
        !! This function pops the value from the stack. The assignment
        !! is raw, that is, it does not invoke the `__newindex` metamethod.
        !!
        !! C signature: `void lua_rawseti (lua_State *L, int index, lua_Integer i)`
        subroutine lua_rawseti(l, idx, i) bind(c, name='lua_rawseti')
            import :: c_int, c_ptr, c_int64_t
            !> Pointer to Lua interpreter state
            type(c_ptr),             intent(in), value :: l
            !> Index of table on stack
            integer(kind=c_int), intent(in), value     :: idx
            !> Index of value in table
            integer(kind=c_int64_t), intent(in), value :: i
        end subroutine lua_rawseti

        !> @brief Moves the top element into the given valid index
        !! without shifting any element (therefore replacing the value
        !! at that given index), and then pops the top element.
        !!
        !! C signature: `void lua_replace (lua_State *L, int index)`
        subroutine lua_replace(l, idx) bind(c, name='lua_replace')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of element to replace with top stack element
            integer(kind=c_int), intent(in), value :: idx
        end subroutine lua_replace

        !> @brief Rotates the stack elements between the valid index
        !! `idx` and the top of the stack.
        !!
        !! The elements are rotated `n` positions in the direction of
        !! the top, for a positive `n`, or `-n` positions in the
        !! direction of the bottom, for a negative `n`. The absolute
        !! value of `n` must not be greater than the size of the slice
        !! being rotated. This function cannot be called with a
        !! pseudo-index, because a pseudo-index is not an actual stack
        !! position.
        !!
        !! C signature: `void lua_rotate (lua_State *L, int idx, int n)`
        subroutine lua_rotate(l, idx, n) bind(c, name='lua_rotate')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index of element acting as endpoint of rotation slice
            integer(kind=c_int), intent(in), value :: idx
            !> Positions rorated in the direction of the top of the
            !! stack
            integer(kind=c_int), intent(in), value :: n
        end subroutine lua_rotate

        !> @brief Pops a value from the stack and sets it as the new
        !! value of global `name`.
        !!
        !! C signature: `void lua_setglobal(lua_State *L, const char *name)`
        subroutine lua_setglobal(l, name) bind(c, name='lua_setglobal')
            import :: c_char, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> New name of popped element
            character(kind=c_char), intent(in)        :: name
        end subroutine lua_setglobal

        !> @brief Accepts any index, or 0, and sets the stack top to
        !! this index.
        !!
        !! If the new top is larger than the old one, then the new
        !! elements are filled with `nil`. If index is 0, then all stack
        !! elements are removed.
        !!
        !! C signature: `void lua_settop(lua_State *L, int idx)`
        subroutine lua_settop(l, idx) bind(c, name='lua_settop')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            !> Index to set as top of the stack
            integer(kind=c_int), intent(in), value :: idx
        end subroutine lua_settop

        !> @brief Returns the address of the version number (a C static
        !! variable) stored in the Lua core.
        !!
        !! When called with a valid `lua_State`, returns the address of
        !! the version used to create that state. When called with
        !! `NULL`, returns the address of the version running the call.
        !!
        !! C signature: `const lua_Number *lua_version (lua_State *L)`
        function lua_version_(l) bind(c, name='lua_version')
            import :: c_ptr, c_double
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            ! Return value
            ! real(kind=c_double)                    :: lua_version
            type(c_ptr)                            :: lua_version_
        end function lua_version_

        ! Auxilliary library function

        !> @brief Opens all standard Lua libraries into the given state.
        !!
        !! C signature: `void luaL_openlibs(lua_State *L)`
        subroutine lual_openlibs(l) bind(c, name='luaL_openlibs')
            import :: c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
        end subroutine lual_openlibs
    end interface
    !!!@}
contains
    !> @name Fortran wrapper functions

    !!!@{
    !> @brief Pushes onto the stack the value of the global name.
    !! Returns the type of that value.
    !!
    !! Wrapper for `lua_getglobal_()` that null-terminates string `name`.
    !!
    !! `int lua_getglobal(lua_State *L, const char *name)`
    function lua_getglobal(l, name)
        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        !> Name to associate with value
        character(len=*), intent(in) :: name
        ! Return value
        integer                      :: lua_getglobal
        continue

        lua_getglobal = lua_getglobal_(l, name // c_null_char)

        return
    end function lua_getglobal

    !!!@{
    !> @brief Pushes onto the stack the value `t[k]`, where `t` is the
    !! value (table) at the given index. Returns the type of the pushed
    !! value (`t[k]`).
    !!
    !! As in Lua, this function may trigger a metamethod for the
    !! "index" event.
    !!
    !! Wrapper for `lua_getfield_()` that null-terminates string `name`.
    !!
    !! C signature: `int lua_getfield(lua_State *L, int index, const char *name)`
    function lua_getfield(l, idx, name)
        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        !> Index of table
        integer,          intent(in) :: idx
        !> Name of table key
        character(len=*), intent(in) :: name
        ! Return value
        integer                      :: lua_getfield
        continue

        lua_getfield = lua_getfield_(l, idx, name // c_null_char)

        return
    end function lua_getfield

    !> @brief Macro replacement that returns whether the stack variable
    !! is boolean.
    !!
    !! C signature: `int lua_isboolean(lua_State *L, int index)`
    function lua_isboolean(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to check
        integer,     intent(in) :: idx
        ! Return value
        logical                 :: lua_isboolean
        continue

        lua_isboolean = (lua_type(l, idx) == LUA_TBOOLEAN)

        return
    end function lua_isboolean

    !> @brief Macro replacement that returns whether the stack variable
    !! is a C function.
    !!
    !! C signature: `int lua_iscfunction(lua_State *L, int idx)`
    function lua_iscfunction(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to check
        integer,     intent(in) :: idx
        ! Return value
        logical                 :: lua_iscfunction
        continue

        lua_iscfunction = (lua_iscfunction_(l, idx) == 1)

        return
    end function lua_iscfunction

    !> @brief Macro replacement that returns whether the stack variable
    !! is a function.
    !!
    !! C signature: `int lua_isfunction(lua_State *L, int index)`
    function lua_isfunction(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to check
        integer,     intent(in) :: idx
        ! Return value
        logical                 :: lua_isfunction
        continue

        lua_isfunction = (lua_type(l, idx) == LUA_TFUNCTION)

        return
    end function lua_isfunction

    !> @brief Macro replacement that returns whether the stack variable
    !! is an integer.
    !!
    !! C signature: `int lua_isinteger(lua_State *L, int idx)`
    function lua_isinteger(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to check
        integer,     intent(in) :: idx
        ! Return value
        logical                 :: lua_isinteger
        continue

        lua_isinteger = (lua_isinteger_(l, idx) == 1)

        return
    end function lua_isinteger

    !> @brief Macro replacement that returns whether the stack variable
    !! is a light userdata
    !!
    !! C signature: `int lua_islightuserdata(lua_State *L, int index)`
    function lua_islightuserdata(l, idx)
        !! Macro replacement that returns whether the stack variable is
        !! light user data.

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to check
        integer,     intent(in) :: idx
        ! Return value
        logical                 :: lua_islightuserdata
        continue

        lua_islightuserdata = (lua_type(l, idx) == LUA_TLIGHTUSERDATA)

        return
    end function lua_islightuserdata

    !> @brief Macro replacement that returns whether the stack variable
    !! is `nil`.
    !!
    !! C signature: `int lua_isnil(lua_State *L, int index)`
    function lua_isnil(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to check
        integer,     intent(in) :: idx
        ! Return value
        logical                 :: lua_isnil
        continue

        lua_isnil = (lua_type(l, idx) == LUA_TNIL)

        return
    end function lua_isnil

    !> @brief Macro replacement that returns whether the stack variable
    !! is `none`.
    !!
    !! C signature: `int lua_isnone(lua_State *L, int index)`
    function lua_isnone(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to check
        integer,     intent(in) :: idx
        ! Return value
        logical                 :: lua_isnone
        continue

        lua_isnone = (lua_type(l, idx) == LUA_TNONE)

        return
    end function lua_isnone

    !> @brief Macro replacement that returns whether the stack variable
    !! is `none` or `nil`.
    !!
    !! C signature: `int lua_isnoneornil(lua_State *L, int index)`
    function lua_isnoneornil(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to check
        integer,     intent(in) :: idx

        ! Return value
        logical                 :: lua_isnoneornil
        continue

        lua_isnoneornil = (lua_type(l, idx) <= 0)

        return
    end function lua_isnoneornil

    !> @brief Macro replacement that returns whether the stack variable
    !! is a number.
    !!
    !! C signature: `int lua_isnumber(lua_State *L, int idx)`
    function lua_isnumber(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to check
        integer,     intent(in) :: idx
        ! Return value
        logical                 :: lua_isnumber
        continue

        lua_isnumber = (lua_isnumber_(l, idx) == 1)

        return
    end function lua_isnumber

    !> @brief Macro replacement that returns whether the stack variable
    !! is a string.
    !!
    !! C signature: `int lua_isstring(lua_State *L, int idx)`
    function lua_isstring(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to check
        integer,     intent(in) :: idx
        ! Return value
        logical                 :: lua_isstring
        continue

        lua_isstring = (lua_isstring_(l, idx) == 1)

        return
    end function lua_isstring

    !> @brief Macro replacement that returns whether the stack variable
    !! is a table.
    !!
    !! C signature: `int lua_istable(lua_State *L, int index)`
    function lua_istable(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to check
        integer,     intent(in) :: idx

        ! Return value
        logical                 :: lua_istable
        continue

        lua_istable = (lua_type(l, idx) == LUA_TTABLE)

        return
    end function lua_istable

    !> @brief Macro replacement that returns whether the stack variable
    !! is a thread.
    !!
    !! C signature: `int lua_isthread(lua_State *L, int index)`
    function lua_isthread(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to check
        integer,     intent(in) :: idx

        ! Return value
        logical                 :: lua_isthread
        continue

        lua_isthread = (lua_type(l, idx) == LUA_TTHREAD)

        return
    end function lua_isthread

    !> @brief Macro replacement that returns whether the stack variable
    !! is a userdata.
    !!
    !! C signature: `int lua_isuserdata(lua_State *L, int idx)`
    function lua_isuserdata(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to check
        integer,     intent(in) :: idx
        ! Return value
        logical                 :: lua_isuserdata
        continue

        lua_isuserdata = (lua_isuserdata_(l, idx) == 1)

        return
    end function lua_isuserdata

    !> @brief Macro replacement that returns whether the given coroutine
    !! can yield.
    !!
    !! C signature: `int lua_isyieldable(lua_State *L)`
    function lua_isyieldable(l)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        ! Return value
        logical                 :: lua_isyieldable
        continue

        lua_isyieldable = (lua_isyieldable_(l) == 1)

        return
    end function lua_isyieldable

    !> @brief Macro replacement that calls `lua_pcallk()`.
    !!
    !! C signature: `int lua_pcall(lua_State *L, int nargs, int nresults, int msgh)`
    !!
    !! @note Continuation-function context is hard-coded to `0_INT64`
    !! (64-bit integer) which may cause problems if `LUA_INTEGER` is
    !! defined to anything other than `__int64` in `luaconf.h`
    function lua_pcall(l, nargs, nresults, msgh)
        use, intrinsic :: iso_fortran_env, only: INT64

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Number of arguments
        integer,     intent(in) :: nargs
        !> Maximum number of results to return
        integer,     intent(in) :: nresults
        !> Pointer to message handler
        integer,     intent(in) :: msgh

        ! Return value
        integer                 :: lua_pcall
        continue

        ! lua_pcall = lua_pcallk(l, nargs, nresults, msgh, int(0, kind=8), c_null_ptr)
        lua_pcall = lua_pcallk(l, nargs, nresults, msgh, 0_INT64, c_null_ptr)

        return
    end function lua_pcall

    !> @brief Converts the Fortran string `s` to a number, pushes that
    !! number into the stack, and returns the total size of the string,
    !! that is, its length plus one.
    !!
    !! The conversion can result in an integer or a float, according to
    !! the lexical conventions of Lua. The string may have leading and
    !! trailing spaces and a sign. If the string is not a valid numeral,
    !! returns 0 and pushes nothing. (Note that the result can be used
    !! as a boolean, true if the conversion succeeds.)
    !!
    !! @note This wraps the original C function, available at
    !!  `lua_stringtonumber_`. That function takes a null-terminated C
    !!  string instead of a Fortran string.
    !!
    !! C signature: `size_t lua_stringtonumber (lua_State *L, const char *s)`
    function lua_stringtonumber(l, s)
        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        !> String to convert to a number and push to stack
        character(len=*), intent(in) :: s

        ! Return value
        integer(kind=c_size_t)       :: lua_stringtonumber

        continue

        lua_stringtonumber = lua_stringtonumber_(l, s // c_null_char)

        return
    end function lua_stringtonumber

    !> @brief Converts the Lua value at the given index to a Fortran logical
    !! value. Zero is `false` in C, non-zero is `true`
    !!
    !! C signature: `int lua_toboolean (lua_State *L, int index)`
    !!
    !! @note Fortran wrapper around `lua_toboolean_()` in Lua C API
    function lua_toboolean(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to convert
        integer,     intent(in) :: idx

        ! Return value
        logical                 :: lua_toboolean
        continue

        lua_toboolean = (lua_toboolean_(l, idx) /= 0)

        return
    end function lua_toboolean

    !> @brief Converts the Lua value at the given index to the signed
    !! integral type `lua_Integer`.
    !!
    !! The Lua value must be an integer, or a number or string
    !! convertible to an integer; otherwise, `lua_tointeger` returns 0
    !!
    !! C signature: `lua_Integer lua_tointeger(lua_State *l, int idx)`
    !!
    !! @note Fortran wrapper around `lua_tointegerx()` in Lua C API
    function lua_tointeger(l, idx)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to convert
        integer,     intent(in) :: idx

        ! Return value
        integer                 :: lua_tointeger
        continue

        lua_tointeger = lua_tointegerx(l, idx, c_null_ptr)

        return
    end function lua_tointeger

    !> @brief Converts the Lua value at the given index to the signed
    !! real type `lua_Number`.
    !!
    !! The Lua value must be an number or a string convertible to a
    !! number; otherwise, `lua_tonumber` returns 0
    !!
    !! C signature: `lua_Number lua_tonumber (lua_State *L, int index)`
    !!
    !! @note Fortran wrapper around `lua_tonumberx()` in Lua C API
    function lua_tonumber(l, idx)
        use, intrinsic :: iso_fortran_env, only: REAL64
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Index of element to convert
        integer,     intent(in) :: idx

        ! Return value
        real(kind=REAL64)                 :: lua_tonumber
        continue

        lua_tonumber = real(lua_tonumberx(l, idx, c_null_ptr), kind=REAL64)

        return
    end function lua_tonumber

    !> @brief Wrapper that calls `lua_tolstring()` and converts the returned C
    !! pointer to a Fortran string.
    !!
    !! C signature: `const char *lua_tostring(lua_State *L, int index)`
    function lua_tostring(l, idx)
        ! use, intrinsic :: iso_fortran_env, only: INT64

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in)       :: l
        !> Index of stack element to convert
        integer,     intent(in)       :: idx

        ! Return value
        character(len=:), allocatable :: lua_tostring

        type(c_ptr)                   :: ptr
        integer(kind=LUA_INT)         :: size
        continue

        ptr = lua_tolstring(l, idx, c_null_ptr)
        if (.not. c_associated(ptr)) return

        size = c_strlen(ptr)
        allocate (character(len=size) :: lua_tostring)
        call c_f_string_ptr(ptr, lua_tostring)

        return
    end function lua_tostring

    !> @brief Wrapper that calls `lua_typename_()` and converts the
    !! returned C pointer to Fortran string.
    !!
    !! C signature: `const char *lua_typename(lua_State *L, int tp)`
    function lua_typename(l, tp)
        use, intrinsic :: iso_fortran_env, only: INT64
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in)       :: l
        !> Lua value type code
        integer,     intent(in)       :: tp

        ! Return value
        character(len=:), allocatable :: lua_typename

        type(c_ptr)                   :: ptr
        integer(kind=INT64)           :: size
        continue

        ptr = lua_typename_(l, tp)
        if (.not. c_associated(ptr)) return

        size = c_strlen(ptr)
        allocate (character(len=size) :: lua_typename)
        call c_f_string_ptr(ptr, lua_typename)

        return
    end function lua_typename

    !> @brief Converts the Lua value at the given index to the signed
    !! real type `lua_Number`.
    !!
    !! The Lua value must be an number or a string convertible to a
    !! number; otherwise, `lua_tonumber` returns 0
    !!
    !! C signature: `lua_Number lua_tonumber (lua_State *L, int index)`
    !!
    !! @note Fortran wrapper around `lua_tonumberx()` in Lua C API
    function lua_version(l)
        use, intrinsic :: iso_fortran_env, only: REAL64
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        ! Return value
        integer                 :: lua_version

        real(kind=REAL64)       :: tmp_version
        continue

        call c_f_real_ptr(lua_version_(l), tmp_version)
        lua_version = int(tmp_version)

        return
    end function lua_version

    !> @brief Loads and runs the given file.
    !!
    !! Macro replacement that calls `lual_loadfile()` and `lua_pcall()`.
    !!
    !! C signature: `int luaL_dofile(lua_State *L, const char *filename)`
    function lual_dofile(l, fn)
        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        !> File name of Lua chunk
        character(len=*), intent(in) :: fn
        ! Return value
        integer                      :: lual_dofile
        continue

        lual_dofile = lual_loadfile(l, fn)

        if (lual_dofile == 0) then
            lual_dofile = lua_pcall(l, 0, LUA_MULTRET, 0)
        end if

        return
    end function lual_dofile

    !> @brief Loads and runs the given file.
    !!
    !! Macro replacement that calls `lual_loadstring()` and `lua_pcall()`.
    !!
    !! C signature: `int luaL_dostring (lua_State *L, const char *str)`
    function lual_dostring(l, s)
        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        !> String to load as a Lua chunk
        character(len=*), intent(in) :: s
        ! Return value
        integer                      :: lual_dostring

        continue

        lual_dostring = luaL_loadstring(l, s)
        if (lual_dostring == 0) then
            lual_dostring = lua_pcall(l, 0, LUA_MULTRET, 0)
        end if

        return
    end function lual_dostring

    !> @brief Macro replacement that calls `lual_loadfilex()`.
    !!
    !! C signature: `int luaL_loadfile(lua_State *L, const char *filename)`
    function lual_loadfile(l, fn)
        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        !> File name of Lua chunk
        character(len=*), intent(in) :: fn
        ! Return value
        integer                      :: lual_loadfile
        continue

        lual_loadfile = lual_loadfilex(l, fn // c_null_char, c_null_ptr)

        return
    end function lual_loadfile

    !> Wrapper for `lual_loadstring()` that null-terminates the given
    !! string.
    !!
    !! C signature: `int luaL_loadstring(lua_State *L, const char *s)`
    function lual_loadstring(l, s)
        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        !> String to load as a Lua chunk
        character(len=*), intent(in) :: s
        ! Return value
        integer                      :: lual_loadstring
        continue

        lual_loadstring = lual_loadstring_(l, s // c_null_char)

        return
    end function lual_loadstring

    !> @brief Returns the name of the type of the value at the given index.
    !!
    !! C signature: `const char *luaL_typename (lua_State *L, int index)`
    function lual_typename(l, idx)
        use, intrinsic :: iso_fortran_env, only: INT64
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in)       :: l
        !> Stack index
        integer,     intent(in)       :: idx

        ! Lua value type code
        integer                       :: tp

        ! Return value
        character(len=:), allocatable :: lual_typename

        type(c_ptr)                   :: ptr
        integer(kind=INT64)           :: size
        continue

        tp = lua_type(l, idx)
        ptr = lua_typename_(l, tp)
        if (.not. c_associated(ptr)) return

        size = c_strlen(ptr)
        allocate (character(len=size) :: lual_typename)
        call c_f_string_ptr(ptr, lual_typename)

        return
    end function lual_typename

    !> @brief Calls a function. Fortran wrapper around `lua_callk`
    !!
    !! C signature: `void lua_call(lua_State *L, int nargs, int nresults)`
    !!
    !! @note Continuation-function context is hard-coded to `0_INT64`
    !! (64-bit integer) which may cause problems if `LUA_INTEGER` is
    !! defined to anything other than `__int64` in `luaconf.h`
    subroutine lua_call(l, nargs, nresults)
        use, intrinsic :: iso_fortran_env, only: INT64
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Number of arguments
        integer,     intent(in) :: nargs
        !> Maximum number of results
        integer,     intent(in) :: nresults
        continue

        ! call lua_callk(l, nargs, nresults, int(0, kind=8), c_null_ptr)
        call lua_callk(l, nargs, nresults, 0_INT64, c_null_ptr)

        return
    end subroutine lua_call

    !> @brief Pops `n` elements from the stack.
    !!
    !! @note Fortran wrapper around `lua_settop`
    !!
    !! C signature: `void lua_pop(lua_State *l, int n)
    subroutine lua_pop(l, n)
        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        !> Number of stack elements to pop
        integer,     intent(in) :: n
        continue

        call lua_settop(l, -n - 1)

        return
    end subroutine lua_pop

    !> @brief Pushes a C function onto the stack.
    !!
    !! This function receives a pointer to a C function and pushes onto
    !! the stack a Lua value of type function that, when called, invokes
    !! the corresponding C function.
    !!
    !! Any function to be callable by Lua must follow the correct
    !! protocol to receive its parameters and return its results
    !! (see lua_CFunction).
    !!
    !! @note Fortran wrapper around `lua_pushcclosure`
    !!
    !! C signature: `void lua_pushcfunction(lua_State *L, lua_CFunction f)`
    subroutine lua_pushcfunction(l, f)
        !> Pointer to Lua interpreter state
        type(c_ptr),    intent(in) :: l
        !> Pointer to C function
        type(c_funptr), intent(in) :: f
        continue

        call lua_pushcclosure(l, f, 0)

        return
    end subroutine lua_pushcfunction

    !> @brief Sets the C function f as the new value of global `name`.
    !!
    !! C signature: `void lua_register(lua_State *L, const char *name, lua_CFunction f)`
    subroutine lua_register(l, n, f)
        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        !> Name for registering function `f`
        character(len=*), intent(in) :: n
        !> Pointer to function
        type(c_funptr),   intent(in) :: f
        continue

        call lua_pushcfunction(l, f)
        call lua_setglobal(l, n // c_null_char)

        return
    end subroutine lua_register

    !> @brief Does the equivalent to `t[k] = v`, where `t` is the
    !! value (table) at the given index and `v` is the value at the
    !! top of the stack.
    !!
    !! This function pops the value from the stack. As in Lua, this
    !! function may trigger a metamethod for the "newindex" event
    !!
    !! @note This is a wrapper around `lua_setfield_()`
    !!
    !! C signature: `void lua_setfield (lua_State *L, int index, const char *k);`
    subroutine lua_setfield(l, idx, name)
        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        !> Index of table
        integer,          intent(in) :: idx
        !> Name of table key
        character(len=*), intent(in) :: name
        continue

        call lua_setfield_(l, idx, name // c_null_char)

        return
    end subroutine lua_setfield
    !!!@}

    !> @name C/Fortran convenience functions

    !!!@{
    !> @brief Utility routine that copies a C string, passed as
    !! a C pointer, to a Fortran string.
    subroutine c_f_string_ptr(c_string, f_string)
        !> Pointer to C string
        type(c_ptr),      intent(in)           :: c_string
        !> Fortran string
        character(len=*), intent(out)          :: f_string

        character(kind=c_char, len=1), pointer :: char_ptrs(:)
        integer                                :: i
        continue

        if (.not. c_associated(c_string)) then
            f_string = ' '
        else
            call c_f_pointer(c_string, char_ptrs, [huge(0)])

            i = 1

            do while (char_ptrs(i) /= c_null_char .and. i <= len(f_string))
                f_string(i:i) = char_ptrs(i)
                i = i + 1
            end do

            if (i < len(f_string)) &
                f_string(i:) = ' '
        end if

        return
    end subroutine c_f_string_ptr

    !> @brief Utility routine that copies a Lua_Number, passed as
    !! a C pointer, to a Fortran real(double).
    subroutine c_f_real_ptr(c_real, f_real)
        use, intrinsic :: iso_fortran_env, only: REAL64
        !> Pointer to C double (Lua_Number)
        type(c_ptr),      intent(in)           :: c_real
        !> Fortran string
        real(kind=REAL64), intent(out)         :: f_real

        real(kind=c_double), pointer           :: ptr_to_real
        continue

        f_real = 0.0_REAL64
        if (c_associated(c_real)) then
            call c_f_pointer(c_real, ptr_to_real)
            f_real = real(ptr_to_real, kind=REAL64)
        end if

        return
    end subroutine c_f_real_ptr
    !!!@}
end module lua
