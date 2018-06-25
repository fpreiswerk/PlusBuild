# Find the NIScope 17.12 libraries
# This module defines
# NIScopeAPI_LIBRARY - libraries to link to in order to use NDI api 
# NIScopeAPI_FOUND, if false, do not try to link 
# NIScopeAPI_INCLUDE_DIR, where to find the headers
#
# To pass your own install, set NIScopeAPI_ROOT_HINT to the folder containing the Oapi-3.0.0.66 folder

#IF(NOT WIN32)
# MESSAGE(FATAL_ERROR "NI Scope is currently only supported on Windows. Cannot continue.")
#ENDIF()

SET(NISCOPE_PATH_HINTS
	"$ENV{PROGRAMFILES}/IVI Foundation/"
	"$ENV{PROGRAMW6432}/IVI Foundation/"
	"C:/Program Files (x86)/IVI Foundation/"
	"C:/Program Files/IVI Foundation/"
	"../../PLTools/NationalInstruments/"
	"../trunk/PLTools/NationalInstruments/"
	"${CMAKE_CURRENT_BINARY_DIR}/PLTools/NationalInstruments/"
  )

# Libraries
SET(SHARED_LIB_DIR "Lib")
SET(SHARED_LIB_DIR "Lib_x64") # JUST FOR TESTING ON MAC. DELETE AFTER.
MESSAGE(DEBUG "Using debug Lib_x64 location for Mac, remove me")

SET(LIB_SUFFIX "")
IF (CMAKE_CL_64 )
	SET(SHARED_LIB_DIR "Lib_x64")
	SET(LIB_SUFFIX "_64")
ENDIF (CMAKE_CL_64 )

FIND_PATH(NIScope_INCLUDE_DIR niScope.h 
	PATH_SUFFIXES Include
	DOC "NI Scope include directory (contains niScope.h)"
	PATHS ${NISCOPE_PATH_HINTS} 
  )

FIND_LIBRARY(NIScope_LIBRARY_DIR
	NAMES niScope${CMAKE_STATIC_LIBRARY_SUFFIX}
	PATH_SUFFIXES ${SHARED_LIB_DIR}/msc
	DOC "Path to NI Scope import library (.lib) (niScope${CMAKE_STATIC_LIBRARY_SUFFIX})"
	PATHS ${NISCOPE_PATH_HINTS} 
  )

FIND_PATH(NIScope_BINARY_DIR 
	niscope${LIB_SUFFIX}${CMAKE_SHARED_LIBRARY_SUFFIX}
  PATH_SUFFIXES 
    Bin
	PATHS ${NISCOPE_PATH_HINTS} 
	DOC "Path to NI Scope shared library (niscope${LIB_SUFFIX}${CMAKE_SHARED_LIBRARY_SUFFIX})"
  NO_DEFAULT_PATH # avoid finding installed DLLs in the system folders
  )

# handle the QUIETLY and REQUIRED arguments and set NIScope_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(NIScope DEFAULT_MSG 
	NIScope_INCLUDE_DIR
	NIScope_LIBRARY_DIR
	NIScope_BINARY_DIR
  )

IF(NIScope_FOUND)
	SET( NIScope_LIBRARIES ${NIScope_LIBRARY_DIR} )
	#SET( NIScopeAPI_INCLUDE_DIRS ${NIScope_INCLUDE_DIR} )
ENDIF()

#IF(NISCOPE_FOUND)
#	SET( NISCOPE_LIBRARY_DIR ${NIScope_LIBRARY_DIR} )
#	SET( NISCOPE_INCLUDE_DIR ${NIScope_INCLUDE_DIR} )
#	SET( NISCOPE_BINARY_DIR ${NIScope_BINARY_DIR} )
#ENDIF()

# Wrap everything in a CMake target
ADD_LIBRARY(NIScope SHARED IMPORTED)
SET_TARGET_PROPERTIES(NIScope PROPERTIES
	IMPORTED_IMPLIB ${NIScope_LIBRARY_DIR}
	IMPORTED_LOCATION ${NIScope_BINARY_DIR}/niscope${LIB_SUFFIX}${CMAKE_SHARED_LIBRARY_SUFFIX}
	INTERFACE_INCLUDE_DIRECTORIES ${NIScope_INCLUDE_DIR}
  )
