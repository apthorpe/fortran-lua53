# Retrieve TOAST from external source and include into project
#
# The following output variables are set by the TOAST subproject
# - TOAST_LIB_NAME
# - TOAST_LIBRARY_DIR
# - TOAST_MODULE_DIR
set(TOAST_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/TOAST-source")

FetchContent_Declare(
    TOAST_external
    GIT_REPOSITORY         https://github.com/thomasms/toast.git
    GIT_TAG                fe8a5d8e3fbc0a97d043ac6d7406f1eb7cdd1900
    SOURCE_DIR             "${TOAST_SOURCE_DIR}"
)

FetchContent_MakeAvailable(TOAST_external)
# FetchContent_GetProperties(TOAST_external)

FetchContent_GetProperties(TOAST_external
    POPULATED TOAST_external_POPULATED
)

# Brittle...
set(TOAST_MODULE_DIR "${CMAKE_CURRENT_BINARY_DIR}/include")
set(TOAST_MODULE_FILE "${TOAST_MODULE_DIR}/toast.mod")

# This may need to be lib64 on Fedora...
set(TOAST_LIBRARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/lib")
# set(TOAST_LIBRARY_DIR $<TARGET_LINKER_FILE_DIR:TOAST_external>)

set(TOAST_FOUND "${TOAST_external_POPULATED}")
# __END__