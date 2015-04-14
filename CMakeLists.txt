CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
PROJECT(LITTLE_ACORN
    LANGUAGES C CXX)

SET(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    ${CMAKE_CURRENT_SOURCE_DIR}/CMake
    ${CMAKE_BINARY_DIR}/generated)

include(SetIfUndefined)
include(CompilePCH)
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/Shared
    ${CMAKE_CURRENT_SOURCE_DIR}/Shared/PCH
    ${CMAKE_CURRENT_BINARY_DIR}/Shared/PCH
    ${CMAKE_CURRENT_SOURCE_DIR}/Shared/include)

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

compile_pch("Shared/PCH/prelude.c"
    Onigmo crash text regexp cf io)
compile_pch("Shared/PCH/prelude.cc"
    Onigmo crash text regexp cf io)
compile_pch("Shared/PCH/prelude.m"
    Onigmo crash text regexp cf io)
compile_pch("Shared/PCH/prelude.mm"
    Onigmo crash text regexp cf io)
