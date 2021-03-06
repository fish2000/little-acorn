# Author: Alexander Böhn
# © 2011.10 -- GPL, Motherfuckers
# FindSubmodule.cmake
#  -- shamelessly based on FindJeMalloc.cmake

find_path(${VIRON_SUBMODULE_UPPER}_ROOT_DIR
    NAMES src
)

find_library(${VIRON_SUBMODULE_UPPER}_LIBRARIES
    NAMES ${VIRON_SUBMODULE}
    HINTS ${${VIRON_SUBMODULE_UPPER}_ROOT_DIR}
)

SET(${VIRON_SUBMODULE_UPPER}_INCLUDE_DIR ${VIRON_SUBMODULE_UPPER}_ROOT_DIR)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${VIRON_SUBMODULE} DEFAULT_MSG
    ${VIRON_SUBMODULE_UPPER}_LIBRARIES
    ${VIRON_SUBMODULE_UPPER}_INCLUDE_DIR
)

set(${VIRON_SUBMODULE_UPPER}_LIBRARY ${VIRON_SUBMODULE_UPPER}_LIBRARIES)
set(${VIRON_SUBMODULE_UPPER}_INCLUDE_DIRS ${VIRON_SUBMODULE_UPPER}_INCLUDE_DIR)

mark_as_advanced(
    ${VIRON_SUBMODULE_UPPER}_ROOT_DIR
    ${VIRON_SUBMODULE_UPPER}_LIBRARY
    ${VIRON_SUBMODULE_UPPER}_LIBRARIES
    ${VIRON_SUBMODULE_UPPER}_INCLUDE_DIR
    ${VIRON_SUBMODULE_UPPER}_INCLUDE_DIRS
)