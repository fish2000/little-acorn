
# this gives us the {CC,CXX,OBJC,OBJCXX}_OPTIONS
# and COMMON_OPTIONS as well:
include(SubmoduleOptions)

FUNCTION(COMPILE_PCH pch_source_arg)
    GET_FILENAME_COMPONENT(pch_source_file ${pch_source_arg} REALPATH)
    GET_FILENAME_COMPONENT(pch_name ${pch_source_file} NAME)
    GET_FILENAME_COMPONENT(pch_ext ${pch_source_file} EXT)
    GET_FILENAME_COMPONENT(pch_dir ${pch_source_arg} DIRECTORY)
    GET_FILENAME_COMPONENT(pch_source "${CMAKE_SOURCE_DIR}/${pch_source_file}" REALPATH)
    SET(pch_outdir "${CMAKE_BINARY_DIR}/${pch_dir}")
    MAKE_DIRECTORY(${pch_outdir})
    SET(pch_target_file "${pch_outdir}/${pch_name}.pch")
    SET(pch_target_names ${ARGN})
    LIST(LENGTH pch_target_names pch_target_count)
    
    # SEPARATE_ARGUMENTS(COMMON_OPTIONS)
    # SEPARATE_ARGUMENTS(C_OPTIONS)
    # SEPARATE_ARGUMENTS(CXX_OPTIONS)
    # SEPARATE_ARGUMENTS(OBJC_OPTIONS)
    # SEPARATE_ARGUMENTS(OBJCXX_OPTIONS)
    
    IF(pch_ext STREQUAL ".m" OR pch_ext STREQUAL ".mm")
        # Objective-C/Objective-C++
        IF(pch_ext STREQUAL ".m")
            SET(pch_flags ${CMAKE_C_FLAGS})
            FOREACH(OPT ${COMMON_OPTIONS})
                LIST(APPEND pch_flags ${OPT})
            ENDFOREACH()
            FOREACH(OPT ${OBJC_OPTIONS})
                LIST(APPEND pch_flags ${OPT})
            ENDFOREACH()
            LIST(APPEND pch_flags "-x")
            LIST(APPEND pch_flags "objective-c-header")
            SET(pch_compiler ${CMAKE_C_COMPILER})
        ELSEIF(pch_ext STREQUAL ".mm")
            SET(pch_flags ${CMAKE_CXX_FLAGS})
            FOREACH(OPT ${COMMON_OPTIONS})
                LIST(APPEND pch_flags ${OPT})
            ENDFOREACH()
            FOREACH(OPT ${OBJCXX_OPTIONS})
                LIST(APPEND pch_flags ${OPT})
            ENDFOREACH()
            LIST(APPEND pch_flags "-x")
            LIST(APPEND pch_flags "objective-c++-header")
            SET(pch_compiler ${CMAKE_CXX_COMPILER})
        ENDIF()
        SET(pch_flags_no_arc ${pch_flags})
        SET(pch_target_file_no_arc "${pch_outdir}/${pch_name}-no-arc.pch")
        LIST(APPEND pch_flags_no_arc "-fno-objc-arc")
        SEPARATE_ARGUMENTS(pch_flags)
        ADD_CUSTOM_COMMAND(
            OUTPUT ${pch_target_file}
            COMMENT "Precompiling ARC-enabled PCH prefix header ${pch_target_file}"
            COMMAND ${pch_compiler}
                    ${pch_flags}
                    -o ${pch_target_file} ${pch_source_file}
            DEPENDS ${pch_source_file})
        ADD_CUSTOM_TARGET("${pch_name}.pch" DEPENDS "${pch_target_file}")
        SEPARATE_ARGUMENTS(pch_flags_no_arc)
        ADD_CUSTOM_COMMAND(
            OUTPUT ${pch_target_file_no_arc}
            COMMENT "Precompiling ARC-disabled PCH prefix header ${pch_target_file_no_arc}"
            COMMAND ${pch_compiler}
                    ${pch_flags_no_arc}
                    -o ${pch_target_file_no_arc} ${pch_source_file}
            DEPENDS ${pch_source_file} ${pch_target_file})
        ADD_CUSTOM_TARGET("${pch_name}-no-arc.pch" DEPENDS "${pch_target_file_no_arc}")
        IF(pch_target_count GREATER 0)
            FOREACH(TN ${pch_target_names})
                ADD_DEPENDENCIES(${TN} "${pch_name}.pch")
                ADD_DEPENDENCIES(${TN} "${pch_name}-no-arc.pch")
            ENDFOREACH()
        ENDIF()
    ELSEIF(pch_ext STREQUAL ".c" OR pch_ext STREQUAL ".cc")
        # C/C++
        IF(pch_ext STREQUAL ".c")
            SET(pch_flags ${CMAKE_C_FLAGS})
            FOREACH(OPT ${COMMON_OPTIONS})
                LIST(APPEND pch_flags ${OPT})
            ENDFOREACH()
            FOREACH(OPT ${C_OPTIONS})
                LIST(APPEND pch_flags ${OPT})
            ENDFOREACH()
            LIST(APPEND pch_flags "-x")
            LIST(APPEND pch_flags "c-header")
            SET(pch_compiler ${CMAKE_C_COMPILER})
        ELSEIF(pch_ext STREQUAL ".cc")
            SET(pch_flags ${CMAKE_CXX_FLAGS})
            FOREACH(OPT ${COMMON_OPTIONS})
                LIST(APPEND pch_flags ${OPT})
            ENDFOREACH()
            FOREACH(OPT ${OBJCXX_OPTIONS})
                LIST(APPEND pch_flags ${OPT})
            ENDFOREACH()
            LIST(APPEND pch_flags "-x")
            LIST(APPEND pch_flags "c++-header")
            SET(pch_compiler ${CMAKE_CXX_COMPILER})
        ENDIF()
        SEPARATE_ARGUMENTS(pch_flags)
        ADD_CUSTOM_COMMAND(
            OUTPUT ${pch_target_file}
            COMMENT "Precompiling standard PCH prefix header ${pch_target_file}"
            COMMAND ${pch_compiler}
                    ${pch_flags}
                    -o ${pch_target_file} ${pch_source_file}
            DEPENDS ${pch_source_file})
        ADD_CUSTOM_TARGET("${pch_name}.pch" DEPENDS "${pch_target_file}")
        IF(pch_target_count GREATER 0)
            FOREACH(TN ${pch_target_names})
                ADD_DEPENDENCIES(${TN} "${pch_name}.pch")
            ENDFOREACH()
        ENDIF()
    ENDIF()
    IF(pch_target_count GREATER 0)
        FOREACH(TN ${pch_target_names})
            SET_TARGET_PROPERTIES(${TN}
                PROPERTIES COMPILE_FLAGS
                "-include ${pch_target_file} -Winvalid-pch")
        ENDFOREACH()
    ENDIF()
ENDFUNCTION()