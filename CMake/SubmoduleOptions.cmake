
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
    message("__________________________________________________")
    message("SUBPROJECT_SOURCE_DIR: ${SUBPROJECT_SOURCE_DIR}")
    message("__________________________________________________")
    
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
    
    foreach(FLAG ${COMMON_LINK_FLAGS})
        
        set_source_files_properties(
            ${SUBPROJECT_C_FILES}
            PROPERTIES LINK_FLAGS ${FLAG})
        
        set_source_files_properties(
            ${SUBPROJECT_M_FILES}
            PROPERTIES LINK_FLAGS ${FLAG})
        
        set_source_files_properties(
            ${SUBPROJECT_CC_FILES}
            PROPERTIES LINK_FLAGS ${FLAG})
        
        set_source_files_properties(
            ${SUBPROJECT_MM_FILES}
            PROPERTIES LINK_FLAGS ${FLAG})
        
    endforeach()
    
    foreach(OPT ${COMMON_OPTIONS})
        
        set_source_files_properties(
            ${SUBPROJECT_C_FILES}
            PROPERTIES COMPILE_OPTIONS ${OPT})
        
        set_source_files_properties(
            ${SUBPROJECT_M_FILES}
            PROPERTIES COMPILE_OPTIONS ${OPT})
        
        set_source_files_properties(
            ${SUBPROJECT_CC_FILES}
            PROPERTIES COMPILE_OPTIONS ${OPT})
        
        set_source_files_properties(
            ${SUBPROJECT_MM_FILES}
            PROPERTIES COMPILE_OPTIONS ${OPT})
        
    endforeach()
    
    foreach(OPT ${C_OPTIONS})
        set_source_files_properties(
            ${SUBPROJECT_C_FILES}
            PROPERTIES COMPILE_OPTIONS ${OPT})
    endforeach()
    
    foreach(OPT ${CXX_OPTIONS})
        set_source_files_properties(
            ${SUBPROJECT_CC_FILES}
            PROPERTIES COMPILE_OPTIONS ${OPT})
    endforeach()
    
    foreach(OPT ${OBJC_OPTIONS})
        set_source_files_properties(
            ${SUBPROJECT_M_FILES}
            PROPERTIES COMPILE_OPTIONS ${OPT})
    endforeach()
    
    foreach(OPT ${OBJCXX_OPTIONS})
        set_source_files_properties(
            ${SUBPROJECT_MM_FILES}
            PROPERTIES COMPILE_OPTIONS ${OPT})
    endforeach()
    
    set_source_files_properties(
        ${SUBPROJECT_C_FILES}
        PROPERTIES COMPILE_OPTIONS "-include-pch prelude.c.pc -Winvalid-pch")
    set_source_files_properties(
        ${SUBPROJECT_CC_FILES}
        PROPERTIES COMPILE_OPTIONS "-include-pch prelude.cc.pch -Winvalid-pch")
    set_source_files_properties(
        ${SUBPROJECT_M_FILES}
        PROPERTIES COMPILE_OPTIONS "-include-pch prelude.m.pch -Winvalid-pch")
    set_source_files_properties(
        ${SUBPROJECT_MM_FILES}
        PROPERTIES COMPILE_OPTIONS "-include-pch prelude.mm.pch -Winvalid-pch")
    
    
    
ENDIF()