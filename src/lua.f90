!> @file lua.f90
!!
!! @brief A collection of ISO C binding interfaces to Lua 5.3 for Fortran 2003.
!!
!! @author Philipp Engel
!! @copyright ISC; see LICENCE


!> @brief A collection of ISO C binding interfaces to Lua 5.3 for Fortran 2003.
!!
!! See https://www.lua.org/manual/5.3/manual.html for details.
module lua
    use, intrinsic :: iso_c_binding
    implicit none
    private

    public :: lua_arith
    public :: lua_call
    public :: lua_callk
    public :: lua_checkstack
    public :: lua_close
    public :: lua_compare
    public :: lua_concat
    public :: lua_copy
    public :: lua_createtable
    public :: lua_gc
    public :: lua_getglobal
    public :: lua_gettop
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
    public :: lua_load
    public :: lua_newtable
    public :: lua_pcall
    public :: lua_pcallk
    public :: lua_pop
    public :: lua_pushboolean
    public :: lua_pushcclosure
    public :: lua_pushinteger
    public :: lua_pushlightuserdata
    public :: lua_pushlstring
    public :: lua_pushnil
    public :: lua_pushnumber
    public :: lua_pushstring
    public :: lua_pushthread
    public :: lua_pushvalue
    public :: lua_register
    public :: lua_setglobal
    public :: lua_settop
    public :: lua_status
    public :: lua_tointeger
    public :: lua_tointegerx
    public :: lua_tostring
    public :: lua_type
    public :: lua_typename
    public :: lual_dofile
    public :: lual_loadfile
    public :: lual_loadfilex
    public :: lual_loadstring
    public :: lual_newstate
    public :: lual_openlibs

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

    !> @name Interfaces to `libc` functions

    !!!@{
    !> Interface to C `strlen` function
    interface
        !> Wrapper around C `strlen` function
        function c_strlen(str) bind(c, name='strlen')
            import :: c_ptr, c_size_t
            !> Pointer to string
            type(c_ptr), intent(in), value :: str
            !> String length
            integer(c_size_t)              :: c_strlen
        end function c_strlen
    end interface
    !!!@}

    !> @name Interfaces to Lua 5.3 functions

    !!!@{
    !> Interfaces to `lua_*()` functions
    interface
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
        !! `int lua_checkstack(lua_State *L, int n)`
        function lua_checkstack(l, n) bind(c, name='lua_checkstack')
            import :: c_int, c_ptr
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: n
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
        !! `int lua_compare(lua_State *L, int index1, int index2, int op)`
        function lua_compare(l, index1, index2, op) bind(c, name='lua_compare')
            import :: c_int, c_ptr
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: index1
            integer(kind=c_int), intent(in), value :: index2
            integer(kind=c_int), intent(in), value :: op
            integer(kind=c_int)                    :: lua_compare
        end function lua_compare

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
        !! `int lua_gc(lua_State *L, int what, int data)`
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

        !> Pushes onto the stack the value of the global name. Returns the type of that value.
        !!
        !! `int lua_getglobal(lua_State *L, const char *name)`
        function lua_getglobal_(l, name) bind(c, name='lua_getglobal')
            import :: c_char, c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            !> Name of element to push onto the stack
            character(kind=c_char), intent(in)        :: name
            ! Return value
            integer(kind=c_int)                       :: lua_getglobal_
        end function lua_getglobal_

        ! int lua_gettop(lua_State *L)
        function lua_gettop(l) bind(c, name='lua_gettop')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
            integer(kind=c_int)            :: lua_gettop
        end function lua_gettop

        ! int lua_iscfunction(lua_State *L, int idx)
        function lua_iscfunction(l, idx) bind(c, name='lua_iscfunction')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: idx
            integer(kind=c_int)                    :: lua_iscfunction
        end function lua_iscfunction

        ! int lua_isinteger(lua_State *L, int idx)
        function lua_isinteger(l, idx) bind(c, name='lua_isinteger')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: idx
            integer(kind=c_int)                    :: lua_isinteger
        end function lua_isinteger

        ! int lua_isnumber(lua_State *L, int idx)
        function lua_isnumber(l, idx) bind(c, name='lua_isnumber')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: idx
            integer(kind=c_int)                    :: lua_isnumber
        end function lua_isnumber

        ! int lua_isstring(lua_State *L, int idx)
        function lua_isstring(l, idx) bind(c, name='lua_isstring')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: idx
            integer(kind=c_int)                    :: lua_isstring
        end function lua_isstring

        ! int lua_isuserdata(lua_State *L, int idx)
        function lua_isuserdata(l, idx) bind(c, name='lua_isuserdata')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: idx
            integer(kind=c_int)                    :: lua_isuserdata
        end function lua_isuserdata

        ! int lua_isyieldable(lua_State *L)
        function lua_isyieldable(l) bind(c, name='lua_isyielable')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
            integer(kind=c_int)            :: lua_isyieldable
        end function lua_isyieldable

        ! int lua_load(lua_State *L, lua_Reader reader, void *data, const char *chunkname, const char *mode)
        function lua_load(l, reader, data, chunkname, mode) bind(c, name='lua_load')
            import :: c_char, c_funptr, c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            type(c_funptr),         intent(in), value :: reader
            type(c_ptr),            intent(in), value :: data
            character(kind=c_char), intent(in)        :: chunkname
            character(kind=c_char), intent(in)        :: mode
            integer(kind=c_int)                       :: lua_load
        end function lua_load

        ! int lua_status(lua_State *L)
        function lua_status(l) bind(c, name='lua_status')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
            integer(kind=c_int)            :: lua_status
        end function lua_status

        ! lua_Integer lua_tointegerx(lua_State *L, int idx, int *isnum)
        function lua_tointegerx(l, idx, isnum) bind(c, name='lua_tointegerx')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: idx
            type(c_ptr),         intent(in), value :: isnum
            integer(kind=c_int)                    :: lua_tointegerx
        end function lua_tointegerx

        ! const char *lua_tolstring(lua_State *L, int idx, size_t *len)
        function lua_tolstring(l, idx, len) bind(c, name='lua_tolstring')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: idx
            type(c_ptr),         intent(in), value :: len
            type(c_ptr)                            :: lua_tolstring
        end function lua_tolstring

        ! int lua_type(lua_State *L, int idx)
        function lua_type(l, idx) bind(c, name='lua_type')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: idx
            integer(kind=c_int)                    :: lua_type
        end function lua_type

        ! const char *lua_typename(lua_State *L, int tp)
        function lua_typename_(l, tp) bind(c, name='lua_typename')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: tp
            type(c_ptr)                            :: lua_typename_
        end function lua_typename_

        ! int luaL_loadfilex(lua_State *L, const char *filename, const char *mode)
        function lual_loadfilex(l, filename, mode) bind(c, name='luaL_loadfilex')
            import :: c_char, c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            character(kind=c_char), intent(in)        :: filename
            type(c_ptr),            intent(in), value :: mode
            integer(kind=c_int)                       :: lual_loadfilex
        end function lual_loadfilex

        ! int luaL_loadstring (lua_State *L, const char *s)
        function lual_loadstring_(l, s) bind(c, name='luaL_loadstring')
            import :: c_char, c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            character(kind=c_char), intent(in)        :: s
            integer(kind=c_int)                       :: lual_loadstring_
        end function lual_loadstring_

        ! lua_State *luaL_newstate(void)
        function lual_newstate() bind(c, name='luaL_newstate')
            import :: c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr) :: lual_newstate
        end function lual_newstate

        ! int lua_pcallk(lua_State *L, int nargs, int nresults, int msgh, lua_KContext ctx, lua_KFunction k)
        function lua_pcallk(l, nargs, nresults, msgh, ctx, k) bind(c, name='lua_pcallk')
            import :: c_funptr, c_int, c_intptr_t, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),              intent(in), value :: l
            integer(kind=c_int),      intent(in), value :: nargs
            integer(kind=c_int),      intent(in), value :: nresults
            integer(kind=c_int),      intent(in), value :: msgh
            integer(kind=c_intptr_t), intent(in), value :: ctx
            type(c_funptr),           intent(in), value :: k
            integer(kind=c_int)                         :: lua_pcallk
        end function lua_pcallk

        ! const char *lua_pushlstring(lua_State *L, const char *s, size_t len)
        function lua_pushlstring(l, s, len) bind(c, name='lua_pushlstring')
            import :: c_char, c_ptr, c_size_t
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            character(kind=c_char), intent(in)        :: s
            integer(kind=c_size_t), intent(in), value :: len
            type(c_ptr)                               :: lua_pushlstring
        end function lua_pushlstring

        ! const char *lua_pushstring(lua_State *L, const char *s)
        function lua_pushstring(l, s) bind(c, name='lua_pushstring')
            import :: c_char, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            character(kind=c_char), intent(in)        :: s
            type(c_ptr)                               :: lua_pushstring
        end function lua_pushstring

        ! int lua_pushthread(lua_State *L)
        function lua_pushthread(l) bind(c, name='lua_pushthread')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
            integer(kind=c_int)            :: lua_pushthread
        end function lua_pushthread

        ! void lua_arith(lua_State *L, int op)
        subroutine lua_arith(l, op) bind(c, name='lua_arith')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: op
        end subroutine lua_arith

        ! void lua_callk(lua_State *L, int nargs, int nresults, int ctx, lua_CFunction k)
        subroutine lua_callk(l, nargs, nresults, ctx, k) bind(c, name='lua_callk')
            import :: c_funptr, c_int, c_intptr_t, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),              intent(in), value :: l
            integer(kind=c_int),      intent(in), value :: nargs
            integer(kind=c_int),      intent(in), value :: nresults
            integer(kind=c_intptr_t), intent(in), value :: ctx
            type(c_funptr),           intent(in), value :: k
        end subroutine lua_callk

        ! void lua_close(lua_State *L)
        subroutine lua_close(l) bind(c, name='lua_close')
            import :: c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
        end subroutine lua_close

        ! void lua_concat(lua_State *L, int n)
        subroutine lua_concat(l, n) bind(c, name='lua_concat')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: n
        end subroutine lua_concat

        ! void lua_copy(lua_State *L, int fromidx, int toidx)
        subroutine lua_copy(l, fromidx, toidx) bind(c, name='lua_copy')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: fromidx
            integer(kind=c_int), intent(in), value :: toidx
        end subroutine lua_copy

        ! void lua_createtable(lua_State *L, int narr, int nrec)
        subroutine lua_createtable(l, narr, nrec) bind(c, name='lua_creatable')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: narr
            integer(kind=c_int), intent(in), value :: nrec
        end subroutine lua_createtable

        ! void lua_newtable(lua_State *L)
        subroutine lua_newtable(l) bind(c, name='lua_newtable')
            import :: c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
        end subroutine lua_newtable

        ! void lua_pushboolean(lua_State *L, int b)
        subroutine lua_pushboolean(l, b) bind(c, name='lua_pushboolean')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: b
        end subroutine lua_pushboolean

        ! void lua_pushcclosure(lua_State *L, lua_CFunction fn, int n)
        subroutine lua_pushcclosure(l, fn, n) bind(c, name='lua_pushcclosure')
            import :: c_funptr, c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            type(c_funptr),      intent(in), value :: fn
            integer(kind=c_int), intent(in), value :: n
        end subroutine lua_pushcclosure

        ! void lua_pushinteger(lua_State *L, lua_Integer n)
        subroutine lua_pushinteger(l, n) bind(c, name='lua_pushinteger')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: n
        end subroutine lua_pushinteger

        ! void  lua_pushlightuserdata(lua_State *L, void *p)
        subroutine lua_pushlightuserdata(l, p) bind(c, name='lua_pushlightuserdata')
            import :: c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
            type(c_ptr), intent(in), value :: p
        end subroutine lua_pushlightuserdata

        ! void lua_pushnil(lua_State *L)
        subroutine lua_pushnil(l) bind(c, name='lua_pushnil')
            import :: c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr), intent(in), value :: l
        end subroutine lua_pushnil

        ! void lua_pushnumber(lua_State *L, lua_Number n)
        subroutine lua_pushnumber(l, n) bind(c, name='lua_pushnumber')
            import :: c_float, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),        intent(in), value :: l
            real(kind=c_float), intent(in), value :: n
        end subroutine lua_pushnumber

        ! void  lua_pushvalue(lua_State *L, int idx)
        subroutine lua_pushvalue(l, idx) bind(c, name='lua_pushvalue')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: idx
        end subroutine lua_pushvalue

        ! void lua_setglobal(lua_State *L, const char *name)
        subroutine lua_setglobal(l, name) bind(c, name='lua_setglobal')
            import :: c_char, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),            intent(in), value :: l
            character(kind=c_char), intent(in)        :: name
        end subroutine lua_setglobal

        ! void lua_settop(lua_State *L, int idx)
        subroutine lua_settop(l, idx) bind(c, name='lua_settop')
            import :: c_int, c_ptr
            !> Pointer to Lua interpreter state
            type(c_ptr),         intent(in), value :: l
            integer(kind=c_int), intent(in), value :: idx
        end subroutine lua_settop

        ! void luaL_openlibs(lua_State *L)
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
    !> @brief Wrapper for `lua_getglobal_()` that null-terminates string `name`.
    !!
    !! `int lua_getglobal(lua_State *L, const char *name)`
    function lua_getglobal(l, name)
        !! Wrapper for `lua_getglobal_()` that null-terminates string `name`.

        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        character(len=*), intent(in) :: name
        integer                      :: lua_getglobal

        lua_getglobal = lua_getglobal_(l, name // c_null_char)
    end function lua_getglobal

    ! int lua_isboolean(lua_State *L, int index)
    function lua_isboolean(l, idx)
        !! Macro replacement that returns whether the stack variable is
        !! boolean.

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        integer,     intent(in) :: idx
        logical                 :: lua_isboolean

        lua_isboolean = .false.

        if (lua_type(l, idx) == LUA_TBOOLEAN) &
            lua_isboolean= .true.
    end function lua_isboolean

    ! int lua_isfunction(lua_State *L, int index)
    function lua_isfunction(l, idx)
        !! Macro replacement that returns whether the stack variable is a
        !! function.

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        integer,     intent(in) :: idx
        logical                 :: lua_isfunction

        lua_isfunction = .false.

        if (lua_type(l, idx) == LUA_TFUNCTION) &
            lua_isfunction = .true.
    end function lua_isfunction

    ! int lua_islightuserdata(lua_State *L, int index)
    function lua_islightuserdata(l, idx)
        !! Macro replacement that returns whether the stack variable is
        !! light user data.

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        integer,     intent(in) :: idx
        logical                 :: lua_islightuserdata

        lua_islightuserdata = .false.

        if (lua_type(l, idx) == LUA_TLIGHTUSERDATA) &
            lua_islightuserdata = .true.
    end function lua_islightuserdata

    ! int lua_isnil(lua_State *L, int index)
    function lua_isnil(l, idx)
        !! Macro replacement that returns whether the stack variable is
        !! nil.

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        integer,     intent(in) :: idx
        logical                 :: lua_isnil

        lua_isnil = .false.

        if (lua_type(l, idx) == LUA_TNIL) &
            lua_isnil = .true.
    end function lua_isnil

    ! int lua_isnone(lua_State *L, int index)
    function lua_isnone(l, idx)
        !! Macro replacement that returns whether the stack variable is
        !! nil.

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        integer,     intent(in) :: idx
        logical                 :: lua_isnone

        lua_isnone = .false.

        if (lua_type(l, idx) == LUA_TNONE) &
            lua_isnone = .true.
    end function lua_isnone

    ! int lua_isnoneornil(lua_State *L, int index)
    function lua_isnoneornil(l, idx)
        !! Macro replacement that returns whether the stack variable is
        !! none or nil.

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        integer,     intent(in) :: idx
        logical                 :: lua_isnoneornil

        lua_isnoneornil = .false.

        if (lua_type(l, idx) <= 0) &
            lua_isnoneornil = .true.
    end function lua_isnoneornil

    ! int lua_istable(lua_State *L, int index)
    function lua_istable(l, idx)
        !! Macro replacement that returns whether the stack variable is a
        !! table.

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        integer,     intent(in) :: idx
        logical                 :: lua_istable

        lua_istable = .false.

        if (lua_type(l, idx) == LUA_TTABLE) &
            lua_istable = .true.
    end function lua_istable

    ! int lua_isthread(lua_State *L, int index)
    function lua_isthread(l, idx)
        !! Macro replacement that returns whether the stack variable is a
        !! thread.

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        integer,     intent(in) :: idx
        logical                 :: lua_isthread

        lua_isthread = .false.

        if (lua_type(l, idx) == LUA_TTHREAD) &
            lua_isthread = .true.
    end function lua_isthread

    ! int lua_pcall(lua_State *L, int nargs, int nresults, int msgh)
    function lua_pcall(l, nargs, nresults, msgh)
        !! Macro replacement that calls `lua_pcallk()`.

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        integer,     intent(in) :: nargs
        integer,     intent(in) :: nresults
        integer,     intent(in) :: msgh
        integer                 :: lua_pcall

        lua_pcall = lua_pcallk(l, nargs, nresults, msgh, int(0, kind=8), c_null_ptr)
    end function lua_pcall

    ! lua_Integer lua_tointeger(lua_State *l, int idx)
    function lua_tointeger(l, idx)

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        integer,     intent(in) :: idx
        integer                 :: lua_tointeger

        lua_tointeger = lua_tointegerx(l, idx, c_null_ptr)
    end function lua_tointeger

    ! const char *lua_tostring(lua_State *L, int index)
    function lua_tostring(l, i)
        !! Wrapper that calls `lua_tolstring()` and converts the returned C
        !! pointer to Fortran string.

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in)       :: l
        integer,     intent(in)       :: i
        character(len=:), allocatable :: lua_tostring
        type(c_ptr)                   :: ptr
        integer(kind=8)               :: size

        ptr = lua_tolstring(l, i, c_null_ptr)
        if (.not. c_associated(ptr)) return

        size = c_strlen(ptr)
        allocate (character(len=size) :: lua_tostring)
        call c_f_string_ptr(ptr, lua_tostring)
    end function lua_tostring

    ! const char *lua_typename(lua_State *L, int tp)
    function lua_typename(l, tp)
        !! Wrapper that calls `lua_typename_()` and converts the returned C
        !! pointer to Fortran string.

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in)       :: l
        integer,     intent(in)       :: tp
        character(len=:), allocatable :: lua_typename
        type(c_ptr)                   :: ptr
        integer(kind=8)               :: size

        ptr = lua_typename_(l, tp)
        if (.not. c_associated(ptr)) return

        size = c_strlen(ptr)
        allocate (character(len=size) :: lua_typename)
        call c_f_string_ptr(ptr, lua_typename)
    end function lua_typename

    ! int luaL_dofile(lua_State *L, const char *filename)
    function lual_dofile(l, fn)
        !! Macro replacement that calls `lual_loadfile()` and `lua_pcall()`.

        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        character(len=*), intent(in) :: fn
        integer                      :: lual_dofile

        lual_dofile = lual_loadfile(l, fn)

        if (lual_dofile == 0) &
            lual_dofile = lua_pcall(l, 0, LUA_MULTRET, 0)
    end function lual_dofile

    ! int luaL_loadfile(lua_State *L, const char *filename)
    function lual_loadfile(l, fn)
        !! Macro replacement that calls `lual_loadfilex()`.

        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        character(len=*), intent(in) :: fn
        integer                      :: lual_loadfile

        lual_loadfile = lual_loadfilex(l, fn // c_null_char, c_null_ptr)
    end function lual_loadfile

    ! int luaL_loadstring(lua_State *L, const char *s)
    function lual_loadstring(l, s)
        !! Wrapper for `lual_loadstring()` that null-terminates the given
        !! string.

        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        character(len=*), intent(in) :: s
        integer                      :: lual_loadstring

        lual_loadstring = lual_loadstring_(l, s // c_null_char)
    end function lual_loadstring

    ! void lua_call(lua_State *L, int nargs, int nresults)
    subroutine lua_call(l, nargs, nresults)

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        integer,     intent(in) :: nargs
        integer,     intent(in) :: nresults

        call lua_callk(l, nargs, nresults, int(0, kind=8), c_null_ptr)
    end subroutine lua_call

    ! void lua_pop(lua_State *l, int n)
    subroutine lua_pop(l, n)

        !> Pointer to Lua interpreter state
        type(c_ptr), intent(in) :: l
        integer,     intent(in) :: n

        call lua_settop(l, -n - 1)
    end subroutine lua_pop

    ! void lua_pushcfunction(lua_State *L, lua_CFunction f)
    subroutine lua_pushcfunction(l, f)

        !> Pointer to Lua interpreter state
        type(c_ptr),    intent(in) :: l
        type(c_funptr), intent(in) :: f

        call lua_pushcclosure(l, f, 0)
    end subroutine lua_pushcfunction

    ! void lua_register(lua_State *L, const char *name, lua_CFunction f)
    subroutine lua_register(l, n, f)

        !> Pointer to Lua interpreter state
        type(c_ptr),      intent(in) :: l
        character(len=*), intent(in) :: n
        type(c_funptr),   intent(in) :: f

        call lua_pushcfunction(l, f)
        call lua_setglobal(l, n // c_null_char)
    end subroutine lua_register
    !!!@}

    !> @name C/Fortran convenience functions

    !!!@{
    !> Utility routine that copies a C string, passed as a C pointer, to a
    !! Fortran string.
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
    end subroutine c_f_string_ptr
    !!!@}
end module lua
