# Retrieve Lua 5.3 from external source and include into project;
# see https://www.lua.org/
#
# The following output variables are set by this recipe and used
# upstream:
# LUA53_FOUND
set(LUA53_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/LUA53-source")

# https://www.sqlite.org/2021/sqlite-amalgamation-3350300.zip
# sha3_256: 58675dc390c385b204c7c75f05d21dd6c07518e1de3fa543e97189de2fda5b71
# sha256: a629d0b1cc301347109e8ad211ff46af371b6ef73c41b7698e9cf1fb37bf4b95
# sha512: a929a8f56dcbb6180726c268836b4c0547216deabdafe39642babd4d015b72b198cf11ccb13f2cf8231a984d2fbb16c69d1a2760b53fd759349f440a912e86e4
FetchContent_Declare(
    LUA53_external
    URL                    https://www.lua.org/ftp/lua-5.3.6.tar.gz
    URL_HASH               MD5=83f23dbd5230140a3770d5f54076948d
    # GIT_REPOSITORY         https://github.com/XXX/ZZZ.git
    # GIT_TAG                ZZZ

    SOURCE_DIR             "${LUA53_SOURCE_DIR}"
)

FetchContent_MakeAvailable(LUA53_external)
FetchContent_GetProperties(LUA53_external)
# FetchContent_GetProperties(LUA53_external
#     POPULATED LUA53_external_POPULATED
# )

# To use this recipe, add one of the following include() lines
# to CMakeLists.txt after project():
#     include(IncludeLua53)
# or
#     include(/path/to/IncludeLua53.cmake)

# To build the fsqlite library, add ${LUA53_SOURCE_DIR} as an include
# directory for the library target:

# target_include_directories(${FORTRANLUA53LIB_NAME} PUBLIC ${LUA53_SOURCE_DIR})

# and add the SQLite amalgamated source file to the list of sources to
# compile:

# add_library(${FORTRANLUA53LIB_NAME} ${FORTRANLUA53_SOURCES} "${LUA53_SOURCE_DIR}/sqlite3.c")

# To include the lua53.mod link the fsqlite library to the target
# MyExecutable, add the following directives after
# add_executable(MyExecutable ...):
# -----
#     target_link_libraries(MyExecutable fsqlite)
#     target_include_directories(MyExecutable PUBLIC $<TARGET_PROPERTY:fsqlite,Fortran_MODULE_DIRECTORY>)
#     add_dependencies(MyExecutable fsqlite)
# -----

# The function link_fortran_libraries() in ./cmake/FortranHelper.cmake
# combines the target_link_libraries() and target_include_directories()
# directives above

set(LUA53_FOUND "${LUA53_external_POPULATED}")
# __END__