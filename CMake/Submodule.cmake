CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

GET_FILENAME_COMPONENT(
    SUBPROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
GET_FILENAME_COMPONENT(
    PARENT_DIR ${CMAKE_CURRENT_SOURCE_DIR} DIRECTORY)

SET(SUBPROJECT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
PROJECT(${SUBPROJECT_NAME})

SET(CMAKE_PREFIX_PATH
    ${CMAKE_PREFIX_PATH}
    ${PARENT_DIR}/CMake)

## set include path and project sources
SET(CMAKE_FRAMEWORK_PATH
    /System/Library/Frameworks
    /usr/local/Frameworks)

## set include path and project sources
SET(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH}
    /usr/local/bin)
SET(CMAKE_LIBRARY_PATH ${CMAKE_INCLUDE_PATH}
    /usr/local/include)

# FIND_PACKAGE(Capnp REQUIRED)
find_package(PkgConfig)
pkg_check_modules(CAPNP capnp)


SET(CMAKE_FIND_FRAMEWORK "LAST")
FIND_LIBRARY(CORE_SERVICES_FRAMEWORK CoreServices)
FIND_LIBRARY(CORE_FOUNDATION_FRAMEWORK CoreFoundation)
FIND_LIBRARY(APPLICATION_SERVICES_FRAMEWORK ApplicationServices)

MARK_AS_ADVANCED(
    CORE_SERVICES_FRAMEWORK
    CORE_FOUNDATION_FRAMEWORK
    APPLICATION_SERVICES_FRAMEWORK)

SET(FRAMEWORKS
    ${COCOA_LIBRARY}
    ${FOUNDATION_LIBRARY}
    ${COREFOUNDATION_LIBRARY})

INCLUDE_DIRECTORIES(
    ${CAPNP_INCLUDE_DIR}
    ${PARENT_DIR}/Shared
    ${PARENT_DIR}/Shared/PCH
    ${PARENT_DIR}/Shared/include
    ${SUBPROJECT_SOURCE_DIR}/src)

FILE(GLOB_RECURSE SUBPROJECT_SRCS
    ${SUBPROJECT_SOURCE_DIR}/src/*.cpp)
FILE(GLOB_RECURSE SUBPROJECT_HDRS
    ${SUBPROJECT_SOURCE_DIR}/src/*.h)

add_definitions(
    -DNDEBUG
    -D'NULL_STR="\uFFFF"'
    -DREST_API='"$rest_api"')

set_target_properties(
    ${SUBPROJECT_SRCS} PROPERTIES LINK_FLAGS
    -m64 -mmacosx-version-min=10.9
    -fvisibility=hidden
    -Wl,-dead_strip -Wl,-dead_strip_dylibs
    -rpath @executable_path/../Frameworks)

set(COMMON_OPTIONS
    -c -pipe -fPIC -gdwarf-2 -Os
    -m64 -mmacosx-version-min=10.9
    -funsigned-char -fcolor-diagnostics
    -Wall -Wwrite-strings -Wformat
    -Winit-self -Wmissing-include-dirs
    -Wno-parentheses -Wno-sign-compare
    -Wno-switch -fcolor-diagnostics)

set_source_files_properties(
    GLOB_RECURSE "./*.c" PROPERTIES COMPILE_OPTIONS
    -fobjc-abi-version=3 -fobjc-arc -std=c99
    ${COMMON_FLAGS})

set_source_files_properties(
    GLOB_RECURSE "./*.m" PROPERTIES COMPILE_OPTIONS
    -fobjc-abi-version=3 -fobjc-arc -std=c99 -ObjC
    ${COMMON_FLAGS})

set_source_files_properties(
    GLOB_RECURSE "./*.cpp" PROPERTIES COMPILE_OPTIONS
    -std=c++1y -stdlib=libc++
    ${COMMON_FLAGS})

set_source_files_properties(
    GLOB_RECURSE "./*.mm" PROPERTIES COMPILE_OPTIONS
    -fobjc-abi-version=3 -std=c++1y -stdlib=libc++ -ObjC++
    -fobjc-link-runtime  -fobjc-arc -fobjc-call-cxx-cdtors
    ${COMMON_FLAGS})

ADD_LIBRARY(lib${SUBPROJECT_NAME} STATIC ${SUBPROJECT_SRCS})
ADD_LIBRARY(${SUBPROJECT_NAME} SHARED ${SUBPROJECT_SRCS})

set_target_properties(lib${SUBPROJECT_NAME}
    PROPERTIES LIBRARY_OUTPUT_NAME
    "${PROJECT_NAME}.a")

set_target_properties(${SUBPROJECT_NAME}
    PROPERTIES LIBRARY_OUTPUT_NAME
    "${PROJECT_NAME}.dylib")

set_target_properties(lib${SUBPROJECT_NAME}
    PROPERTIES LIBRARY_OUTPUT_DIRECTORY
    ${CMAKE_CURRENT_SOURCE_DIR})

set_target_properties(${SUBPROJECT_NAME}
    PROPERTIES LIBRARY_OUTPUT_DIRECTORY
    ${CMAKE_CURRENT_SOURCE_DIR})

TARGET_LINK_LIBRARIES(lib${SUBPROJECT_NAME} ${FRAMEWORKS})
TARGET_LINK_LIBRARIES(${SUBPROJECT_NAME} ${FRAMEWORKS})
