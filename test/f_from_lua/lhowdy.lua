-- Set lfn to location of shared library `libfhello.dll`
local lfn = "C:\\Users\\apthorpe\\Documents\\git_projects\\fortran-lua53\\build\\test\\f_from_lua\\libfhello.dll"
-- set lfn to location of shared library `libfhello.so`
-- local lfn = "/home/apthorpe/Documents/Projects/git_proj/fortran-lua53/build/test/f_from_lua/libfhello.so"

-- Check that the registration function luaopen_fhello is visible in path
local libinit = assert(loadlib(lfn, "luaopen_fhello"))

-- Actually open the library
libinit()

-- Run the library function
hello()
