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
find_package(Boost REQUIRED)
find_package(PkgConfig REQUIRED)
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

# FILE(GLOB_RECURSE SUBPROJECT_SRCS
#     RELATIVE ${SUBPROJECT_SOURCE_DIR}
#     "${SUBPROJECT_SOURCE_DIR}/*.*" )
# FILE(GLOB_RECURSE SUBPROJECT_HDRS
#     RELATIVE ${SUBPROJECT_SOURCE_DIR}
#     "${SUBPROJECT_SOURCE_DIR}/*.h" )

SET(FIND_SRCS /usr/bin/find "${SUBPROJECT_SOURCE_DIR}" -regex "\".*\\.[cm]*\"" -print)
SET(FIND_HDRS /usr/bin/find "${SUBPROJECT_SOURCE_DIR}" -name "\"*.h\"" -print)

execute_process(
    COMMAND /usr/bin/find "${SUBPROJECT_SOURCE_DIR}" -regex "\".*\\.[cm]*\"" -print
    OUTPUT_VARIABLE SUBPROJECT_SRCS)
execute_process(
    COMMAND /usr/bin/find "${SUBPROJECT_SOURCE_DIR}" -name "\"*.h\"" -print
    OUTPUT_VARIABLE SUBPROJECT_HDRS)

    message("${SUBPROJECT_SOURCE_DIR}")
    
    message("${FIND_SRCS}")
    message("${SUBPROJECT_SRCS}")
    
    message("${FIND_HDRS}")
    message("${SUBPROJECT_HDRS}")

add_definitions(
    -DNDEBUG
    -D'NULL_STR="\\uFFFF"'
    -DREST_API='"http://api.textmate.org"')

SET(COMMON_LINK_FLAGS
    -m64 -mmacosx-version-min=10.9
    -fvisibility=hidden
    -Wl,-dead_strip -Wl,-dead_strip_dylibs
    -rpath @executable_path/../Frameworks)

foreach(FLAG ${COMMON_LINK_FLAGS})

    set_source_files_properties(
        GLOB_RECURSE "./*.c"
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        PROPERTIES LINK_FLAGS ${FLAG})

    set_source_files_properties(
        GLOB_RECURSE "./*.m" 
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        PROPERTIES LINK_FLAGS ${FLAG})

    set_source_files_properties(
        GLOB_RECURSE "./*.cc"
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        PROPERTIES LINK_FLAGS ${FLAG})

    set_source_files_properties(
        GLOB_RECURSE "./*.mm"
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        PROPERTIES LINK_FLAGS ${FLAG})

endforeach()

set(COMMON_OPTIONS
    -c -pipe -fPIC -gdwarf-2 -Os
    -m64 -mmacosx-version-min=10.9
    -funsigned-char -fcolor-diagnostics
    -Wall -Wwrite-strings -Wformat
    -Winit-self -Wmissing-include-dirs
    -Wno-parentheses -Wno-sign-compare
    -Wno-switch -fcolor-diagnostics)

foreach(OPT ${COMMON_OPTIONS})

    set_source_files_properties(
        GLOB_RECURSE "./*.c"
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        PROPERTIES COMPILE_OPTIONS ${OPT})

    set_source_files_properties(
        GLOB_RECURSE "./*.m" 
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        PROPERTIES COMPILE_OPTIONS ${OPT})

    set_source_files_properties(
        GLOB_RECURSE "./*.cc"
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        PROPERTIES COMPILE_OPTIONS ${OPT})

    set_source_files_properties(
        GLOB_RECURSE "./*.mm"
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        PROPERTIES COMPILE_OPTIONS ${OPT})
    
endforeach()

SET(CC_OPTIONS
    -fobjc-abi-version=3 -fobjc-arc -std=c99)

SET(CXX_OPTIONS
    -std=c++1y -stdlib=libc++)

SET(OBJC_OPTIONS
    -fobjc-abi-version=3 -fobjc-arc -std=c99 -ObjC)

SET(OBJCXX_OPTIONS
    -fobjc-abi-version=3 -std=c++1y -stdlib=libc++ -ObjC++
    -fobjc-link-runtime  -fobjc-arc -fobjc-call-cxx-cdtors)

foreach(OPT ${CC_OPTIONS})
    set_source_files_properties(
        GLOB_RECURSE "./*.c"
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        PROPERTIES COMPILE_OPTIONS ${OPT})
endforeach()

foreach(OPT ${CXX_OPTIONS})
    set_source_files_properties(
        GLOB_RECURSE "./*.cc"
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        PROPERTIES COMPILE_OPTIONS ${OPT})
endforeach()

foreach(OPT ${OBJC_OPTIONS})
    set_source_files_properties(
        GLOB_RECURSE "./*.m"
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        PROPERTIES COMPILE_OPTIONS ${OPT})
endforeach()

foreach(OPT ${OBJCXX_OPTIONS})
    set_source_files_properties(
        GLOB_RECURSE "./*.mm"
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        PROPERTIES COMPILE_OPTIONS ${OPT})
endforeach()

# set_source_files_properties(
#     GLOB_RECURSE "./*.mm" PROPERTIES COMPILE_OPTIONS
#     -fobjc-abi-version=3 -std=c++1y -stdlib=libc++ -ObjC++
#     -fobjc-link-runtime  -fobjc-arc -fobjc-call-cxx-cdtors
#     ${COMMON_FLAGS})


ADD_LIBRARY(lib${SUBPROJECT_NAME} STATIC ${SUBPROJECT_SRCS} ${SUBPROJECT_HDRS})
ADD_LIBRARY(${SUBPROJECT_NAME} SHARED ${SUBPROJECT_SRCS} ${SUBPROJECT_HDRS})

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
