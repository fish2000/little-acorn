CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

GET_FILENAME_COMPONENT(
    SUBPROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
GET_FILENAME_COMPONENT(
    PARENT_DIR ${CMAKE_CURRENT_SOURCE_DIR} DIRECTORY)

SET(SUBPROJECT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
PROJECT(${SUBPROJECT_NAME})

SET(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    ${CMAKE_BINARY_DIR}/generated
    ${PARENT_DIR}/CMake)

## Include set_if_undefined() macro
if(NOT COMMAND set_if_undefined)
    include(SetIfUndefined)
endif()

## Viron variables
SET(SUBPROJECT_DEPS ${VIRON_DEPS})
SET(SUBPROJECT_SRCS ${VIRON_SRCS})
SET(SUBPROJECT_HDRS ${VIRON_HDRS})
SET(ALL_SUBPROJECTS ${VIRON_SUBPROJECTS})
SET(SUBPROJECT_LIBS ${VIRON_LIBS})
SET(SUBPROJECT_FRAMEWORKS ${VIRON_FRAMEWORKS})
SET(CMAKE_FIND_FRAMEWORK "LAST")

## set include path and project sources
SET(CMAKE_FRAMEWORK_PATH
    ${CMAKE_FRAMEWORK_PATH}
    /System/Library/Frameworks
    /usr/local/Frameworks)

## set include path and project sources
SET(CMAKE_LIBRARY_PATH
    ${CMAKE_LIBRARY_PATH}
    /usr/local/bin)
    
find_package(Boost REQUIRED) # header-only
find_package(PkgConfig REQUIRED)
pkg_check_modules(CAPNP capnp)

IF(DEFINED SUBPROJECT_LIBS)
    foreach(L ${SUBPROJECT_LIBS})
        find_package(${L} REQUIRED)
    endforeach()
ENDIF()

# include(SubmoduleOptions)

add_definitions(
    -DNDEBUG
    -DNULL_STR=\\uFFFF
    -DREST_API=\"http://api.textmate.org\")

SET(COMMON_LINK_FLAGS
    -m64 -mmacosx-version-min=10.9
    -fobjc-link-runtime
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

SET(C_OPTIONS
    -std=c99 -Wno-incompatible-pointer-types -Wno-char-subscripts)

SET(CXX_OPTIONS
    -std=c++1y -stdlib=libc++)

SET(OBJC_OPTIONS
    -fobjc-link-runtime
    -fobjc-abi-version=3 -fobjc-arc -std=c99 -ObjC)

SET(OBJCXX_OPTIONS
    -fobjc-link-runtime
    -fobjc-abi-version=3 -std=c++1y -stdlib=libc++
    -ObjC++ -fobjc-arc -fobjc-call-cxx-cdtors)

IF(DEFINED SUBPROJECT_SOURCE_DIR)
    # message("__________________________________________________")
    # message("SUBPROJECT_SOURCE_DIR: ${SUBPROJECT_SOURCE_DIR}")
    # message("__________________________________________________")
    
    SET(SUBPROJECT_C_FILES "" PARENT_SCOPE)
    SET(SUBPROJECT_CC_FILES "" PARENT_SCOPE)
    SET(SUBPROJECT_M_FILES "" PARENT_SCOPE)
    SET(SUBPROJECT_MM_FILES "" PARENT_SCOPE)
    
    FILE(
        GLOB_RECURSE SUBPROJECT_C_FILES
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        "src/*.c")
    FILE(
        GLOB_RECURSE SUBPROJECT_CC_FILES
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        "src/*.cc")
    FILE(
        GLOB_RECURSE SUBPROJECT_M_FILES
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        "src/*.m")
    FILE(
        GLOB_RECURSE SUBPROJECT_MM_FILES
        RELATIVE ${SUBPROJECT_SOURCE_DIR}
        "src/*.mm")
        
        SEPARATE_ARGUMENTS(SUBPROJECT_C_FILES)
        SEPARATE_ARGUMENTS(SUBPROJECT_CC_FILES)
        SEPARATE_ARGUMENTS(SUBPROJECT_M_FILES)
        SEPARATE_ARGUMENTS(SUBPROJECT_MM_FILES)
    
    foreach(FLAG IN LISTS ${COMMON_LINK_FLAGS})
        
        set_source_files_properties(
            ${SUBPROJECT_C_FILES}
            PROPERTIES LINK_FLAGS ${LINK_FLAGS} ${FLAG})
        
        set_source_files_properties(
            ${SUBPROJECT_M_FILES}
            PROPERTIES LINK_FLAGS ${LINK_FLAGS} ${FLAG})
        
        set_source_files_properties(
            ${SUBPROJECT_CC_FILES}
            PROPERTIES LINK_FLAGS ${LINK_FLAGS} ${FLAG})
        
        set_source_files_properties(
            ${SUBPROJECT_MM_FILES}
            PROPERTIES LINK_FLAGS ${LINK_FLAGS} ${FLAG})
        
    endforeach()
    
    foreach(OPT IN LISTS ${COMMON_OPTIONS})
        
        set_source_files_properties(
            ${SUBPROJECT_C_FILES}
            PROPERTIES COMPILE_FLAGS ${COMPILE_FLAGS} ${OPT})
        
        set_source_files_properties(
            ${SUBPROJECT_M_FILES}
            PROPERTIES COMPILE_FLAGS ${COMPILE_FLAGS} ${OPT})
        
        set_source_files_properties(
            ${SUBPROJECT_CC_FILES}
            PROPERTIES COMPILE_FLAGS ${COMPILE_FLAGS} ${OPT})
        
        set_source_files_properties(
            ${SUBPROJECT_MM_FILES}
            PROPERTIES COMPILE_FLAGS ${COMPILE_FLAGS} ${OPT})
        
    endforeach()
    
    foreach(OPT IN LISTS ${C_OPTIONS})
        set_source_files_properties(
            ${SUBPROJECT_C_FILES}
            PROPERTIES COMPILE_FLAGS ${COMPILE_FLAGS} ${OPT})
    endforeach()
    
    foreach(OPT IN LISTS ${CXX_OPTIONS})
        set_source_files_properties(
            ${SUBPROJECT_CC_FILES}
            PROPERTIES COMPILE_FLAGS ${COMPILE_FLAGS} ${OPT})
    endforeach()
    
    foreach(OPT IN LISTS ${OBJC_OPTIONS})
        set_source_files_properties(
            ${SUBPROJECT_M_FILES}
            PROPERTIES COMPILE_FLAGS ${COMPILE_FLAGS} ${OPT})
    endforeach()
    
    foreach(OPT IN LISTS ${OBJCXX_OPTIONS})
        set_source_files_properties(
            ${SUBPROJECT_MM_FILES}
            PROPERTIES COMPILE_FLAGS ${COMPILE_FLAGS} ${OPT})
    endforeach()
    
    set_source_files_properties(
        ${SUBPROJECT_C_FILES}
        PROPERTIES COMPILE_FLAGS ${COMPILE_FLAGS} "-include-pch ${CMAKE_BINARY_DIR}/Shared/PCH/prelude.c.pch -Winvalid-pch")
    set_source_files_properties(
        ${SUBPROJECT_CC_FILES}
        PROPERTIES COMPILE_FLAGS ${COMPILE_FLAGS} "-include-pch ${CMAKE_BINARY_DIR}/Shared/PCH/prelude.cc.pch -Winvalid-pch")
    set_source_files_properties(
        ${SUBPROJECT_M_FILES}
        PROPERTIES COMPILE_FLAGS ${COMPILE_FLAGS} "-include-pch ${CMAKE_BINARY_DIR}/Shared/PCH/prelude.m.pch -Winvalid-pch")
    set_source_files_properties(
        ${SUBPROJECT_MM_FILES}
        PROPERTIES COMPILE_FLAGS ${COMPILE_FLAGS} "-include-pch ${CMAKE_BINARY_DIR}/Shared/PCH/prelude.mm.pch -Winvalid-pch")
    
    # -include $builddir/Shared/PCH/prelude.c
    # -include $builddir/Shared/PCH/prelude.cc
    # -include $builddir/Shared/PCH/prelude.m
    # -include $builddir/Shared/PCH/prelude.mm
    
    # -include $builddir/Shared/PCH/prelude.m-no-arc 
    # WHAAAAAT
    
    
ENDIF()

# message("__________________________________________________")
# message("SUBPROJECT_C_FILES: ${SUBPROJECT_C_FILES}")
# message("__________________________________________________")
#
# message("__________________________________________________")
# message("SUBPROJECT_CC_FILES: ${SUBPROJECT_CC_FILES}")
# message("__________________________________________________")
#
# message("__________________________________________________")
# message("SUBPROJECT_M_FILES: ${SUBPROJECT_M_FILES}")
# message("__________________________________________________")
#
# message("__________________________________________________")
# message("SUBPROJECT_MM_FILES: ${SUBPROJECT_MM_FILES}")
# message("__________________________________________________")


ADD_LIBRARY(lib${SUBPROJECT_NAME} STATIC
    ${SUBPROJECT_C_FILES}
    ${SUBPROJECT_CC_FILES}
    ${SUBPROJECT_M_FILES}
    ${SUBPROJECT_MM_FILES})
ADD_LIBRARY(${SUBPROJECT_NAME} SHARED
    ${SUBPROJECT_C_FILES}
    ${SUBPROJECT_CC_FILES}
    ${SUBPROJECT_M_FILES}
    ${SUBPROJECT_MM_FILES})

INCLUDE_DIRECTORIES(
    ${CMAKE_INCLUDE_PATH}
    ${CAPNP_INCLUDE_DIR}
    ${PARENT_DIR}/Shared/include
    ${SUBPROJECT_SOURCE_DIR}/src
    /usr/local/include)

IF(EXISTS ${SUBPROJECT_SOURCE_DIR}/src/vendor)
    INCLUDE_DIRECTORIES(${SUBPROJECT_SOURCE_DIR}/src)
    INCLUDE_DIRECTORIES(${SUBPROJECT_SOURCE_DIR}/src/vendor)
ENDIF()

LINK_DIRECTORIES(
    ${CMAKE_LIBRARY_PATH}
    /usr/local/lib)

set_target_properties(lib${SUBPROJECT_NAME}
    PROPERTIES ARCHIVE_OUTPUT_NAME "${PROJECT_NAME}")

set_target_properties(${SUBPROJECT_NAME}
    PROPERTIES LIBRARY_OUTPUT_NAME "${PROJECT_NAME}")

set_target_properties(lib${SUBPROJECT_NAME}
    PROPERTIES PREFIX "")

set_target_properties(${SUBPROJECT_NAME}
    PROPERTIES PREFIX "")

IF(DEFINED SUBPROJECT_DEPS)
    foreach(D ${SUBPROJECT_DEPS})
        add_dependencies(lib${SUBPROJECT_NAME} ${D})
        add_dependencies(${SUBPROJECT_NAME} ${D})
    endforeach()
ENDIF()

add_dependencies(${SUBPROJECT_NAME} "prelude.c.pch")
add_dependencies(${SUBPROJECT_NAME} "prelude.cc.pch")
add_dependencies(${SUBPROJECT_NAME} "prelude.m.pch")
add_dependencies(${SUBPROJECT_NAME} "prelude.mm.pch")


TARGET_LINK_LIBRARIES(lib${SUBPROJECT_NAME}
    ${SUBPROJECT_LIBS}
    ${SUBPROJECT_FRAMEWORKS})
TARGET_LINK_LIBRARIES(${SUBPROJECT_NAME}
    ${SUBPROJECT_LIBS}
    ${SUBPROJECT_FRAMEWORKS})
