cmake_minimum_required(VERSION 3.15...3.21)

project(Scotch
  LANGUAGES C
  DESCRIPTION "Build and use Scotch (Makefile-based) from CMake projects"
  HOMEPAGE_URL https://gitlab.inria.fr/scotch/scotch)

include(CTest)

option(scotch_external "build Scotch")

set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED true)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

find_package(MPI COMPONENTS C)

if(NOT scotch_external)
  find_package(Scotch COMPONENTS ESMUMPS)
endif()

if(scotch_external OR NOT Scotch_FOUND)
  include(cmake/scotch.cmake)
endif()

# --- example user code

if(BUILD_TESTING)
  include(CheckLanguage)
  check_language(Fortran)
  if(CMAKE_Fortran_COMPILER)
    enable_language(Fortran)
  endif()

  add_subdirectory(tests)
endif()
