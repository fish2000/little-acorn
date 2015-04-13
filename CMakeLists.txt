CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
PROJECT(LITTLE_ACORN)

set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} CMake)
include_directories(Shared Shared/PCH Shared/include)

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
