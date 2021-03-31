# Retrieve, build, and install Lua 5.3 from https://www.lua.org/
set(LUA53_LIBNAME lua53)
set(LUA53_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/LUA53-source")

set(LUA53_LOCAL_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/LUA53-artifacts")
set(LUA53_INCLUDE_DIR "${LUA53_LOCAL_INSTALL_DIR}/jsonfortran-gnu-8.2.1/lib") #???
set(LUA53_LIBFILE ${LUA53_INCLUDE_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}${LUA53_LIBNAME}${CMAKE_STATIC_LIBRARY_SUFFIX}) #???

# Note: "<INSTALL_DIR>" is interpolated within ExternalProject_Add to
# LUA53_LOCAL_INSTALL_DIR
# list(APPEND LUA53_CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>")
# list(APPEND LUA53_CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=${LUA53_LOCAL_INSTALL_DIR}"
#                              "-DSKIP_DOC_GEN:BOOL=TRUE")

ExternalProject_Add(
    LUA53_external
    # Note: Use URL and URL_HASH [SHA512|SHA256|MD5]=4A54C0DE... to
    # download and checksum an archive. Note that URL may refer to a
    # local file, allowing this to work without net access.
    URL                    https://www.lua.org/ftp/lua-5.3.6.tar.gz
    # URL_HASH               SHA256=f27d20d6c81292149bc4308525a9d6733c224fa5
    URL_HASH               MD5=83f23dbd5230140a3770d5f54076948d
    # GIT_REPOSITORY         https://github.com/XXX/ZZZ.git
    # GIT_TAG                ZZZ
    SOURCE_DIR             ${LUA53_SOURCE_DIR}
    INSTALL_DIR            ${LUA53_LOCAL_INSTALL_DIR}
#    CMAKE_ARGS             ${LUA53_CMAKE_ARGS}
    # Skip configure, build, and installation; just download and unpack
    CONFIGURE_COMMAND      echo "Skipping configure step for LUA53"
    BUILD_COMMAND          make generic
    BUILD_ALWAYS           true
    # BUILD_COMMAND          echo "Skipping build step for LUA53"
    INSTALL_COMMAND        echo "Skipping install step for LUA53"
    BUILD_BYPRODUCTS       ${LUA53_LIBFILE}
    LOG_BUILD              YES
    USES_TERMINAL_DOWNLOAD YES
    USES_TERMINAL_UPDATE   YES
)

# From fortran-csv-module/CMakeLists.txt:
# ...
# # Set default installation paths; should be invoked after setting project language(s)
# include(GNUInstallDirs)
# ...
# # Fortran module files
# install(FILES "${LIBLUA53_FORTRAN_MODULE_DIR}/csv_module.mod"
#        DESTINATION finclude)
# ...

# Create ${LUA53_LOCAL_INSTALL_DIR}/finclude based on the module install location
# set in fortran-csv-module/CMakeLists.txt. Creating this directory avoids a race
# condition - see https://www.scivision.dev/cmake-fetchcontent-vs-external-project/
file(MAKE_DIRECTORY ${LUA53_INCLUDE_DIR})

# Make the jsonfortran library available to the current project as an import
add_library(${LUA53_LIBNAME} STATIC IMPORTED GLOBAL)

# Set properties on jsonfortran target to point at the installed library location and
# the module directory created above. LUA53 uses `include(GNUInstallDirs)` which
# typically installs libraries to ./lib which is why the IMPORTED_LOCATION below
# uses the path ${LUA53_LOCAL_INSTALL_DIR}/lib
set_target_properties(${LUA53_LIBNAME}
    PROPERTIES
#    IMPORTED_LOCATION ${LUA53_LOCAL_INSTALL_DIR}/jsonfortran-gnu-8.2.1/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${LUA53_LIBNAME}${CMAKE_STATIC_LIBRARY_SUFFIX}
    IMPORTED_LOCATION ${LUA53_LIBFILE}
    INTERFACE_INCLUDE_DIRECTORIES ${LUA53_INCLUDE_DIR}
)

# To use this recipe, add one of the following fragments
# to CMakeLists.txt after project():
#     find_package(Git)
#     include(BuildLUA53)
# or
#     find_package(Git)
#     include(/path/to/BuildLUA53.cmake)

# To include the csv_module.mod link the jsonfortran library to the target
# MyExecutable, add the following directives after
# add_executable(MyExecutable ...):
# -----
#     target_link_libraries(MyExecutable jsonfortran)
#     target_include_directories(MyExecutable PUBLIC $<TARGET_PROPERTY:jsonfortran,Fortran_MODULE_DIRECTORY>)
#     add_dependencies(MyExecutable LUA53_external)
# -----

set(LUA53_FOUND ON)
# __END__