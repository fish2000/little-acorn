
add_definitions(
    -DNDEBUG
    -DNULL_STR=\\uFFFF
    -DREST_API=\"http://api.textmate.org\")

SET(COMMON_LINK_FLAGS
    -m64 -mmacosx-version-min=10.9
    -fobjc-link-runtime
    -Wl,-dead_strip -Wl,-dead_strip_dylibs
    -rpath @executable_path/../Frameworks)

IF(DEFINED ${SUBPROJECT_SOURCE_DIR})
    
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
    
ENDIF()

set(COMMON_OPTIONS
    -c -pipe -fPIC -gdwarf-2 -Os
    -m64 -mmacosx-version-min=10.9
    -funsigned-char -fcolor-diagnostics
    -Wall -Wwrite-strings -Wformat
    -Winit-self -Wmissing-include-dirs
    -Wno-parentheses -Wno-sign-compare
    -Wno-switch -fcolor-diagnostics)

IF(DEFINED ${SUBPROJECT_SOURCE_DIR})
    
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
    
ENDIF()

SET(C_OPTIONS
    -std=c99 -Wno-incompatible-pointer-types -Wno-char-subscripts)

SET(CXX_OPTIONS
    -std=c++1y -stdlib=libc++)

SET(OBJC_OPTIONS
    -fobjc-abi-version=3 -fobjc-arc -std=c99)

SET(OBJCXX_OPTIONS
    -fobjc-abi-version=3 -std=c++1y -stdlib=libc++
              -fobjc-arc -fobjc-call-cxx-cdtors)

IF(DEFINED ${SUBPROJECT_SOURCE_DIR})
    
    foreach(OPT ${C_OPTIONS})
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
    
ENDIF()