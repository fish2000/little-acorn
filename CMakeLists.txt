CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
PROJECT(LITTLE_ACORN
    LANGUAGES C CXX)

SET(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    ${CMAKE_CURRENT_SOURCE_DIR}/CMake
    ${CMAKE_BINARY_DIR}/generated)

include(SetIfUndefined)
include(CompilePCH)

# include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Shared/include)

# Onigmo crash text regexp cf io
compile_pch("Shared/PCH/prelude.c")
compile_pch("Shared/PCH/prelude.cc"
            "prelude.c.pch")
compile_pch("Shared/PCH/prelude.m"
            "prelude.c.pch" "prelude.cc.pch")
compile_pch("Shared/PCH/prelude.mm"
            "prelude.c.pch" "prelude.cc.pch" "prelude.m.pch")

execute_process(
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMAND CMake/distribute.py
    COMMENT "Distributing submodule CMake rules")

add_subdirectory(Onigmo)
add_subdirectory(crash)
add_subdirectory(text)
add_subdirectory(regexp)
add_subdirectory(cf)
add_subdirectory(io)

