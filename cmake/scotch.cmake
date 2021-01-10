# this uses a technique to avoid autotools constantly rebuilding,
# by making the ExternalProject only visible once--until the binaries are built
# then, we use the Scotch_FOUND to switch in a dummy target.
# We do the same thing with HDF5 in other projects.

set(scotch_external true CACHE BOOL "build Scotch library")

cmake_host_system_information(RESULT Ncpu QUERY NUMBER_OF_PHYSICAL_CORES)
message(STATUS "CMake ${CMAKE_VERSION} using ${Ncpu} threads")

find_program(MAKE_EXECUTABLE NAMES gmake make mingw32-make REQUIRED)

# --- help autotools based on CMake variables

include(ExternalProject)

set(Scotch_LIBRARIES)
foreach(_l esmumps scotch scotcherr scotcherrexit scotchmetis)
  list(APPEND Scotch_LIBRARIES ${PROJECT_BINARY_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${_l}${CMAKE_STATIC_LIBRARY_SUFFIX})
endforeach()

if(EXISTS ${PROJECT_BINARY_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}scotch${CMAKE_STATIC_LIBRARY_SUFFIX})
  set(Scotch_FOUND true)
endif()

if(NOT Scotch_FOUND)

  set(_src ${PROJECT_BINARY_DIR}/Scotch-prefix/src/Scotch/src/)

  if(CMAKE_C_COMPILER_ID STREQUAL GNU)
    set(scotch_cflags "-O3 -fPIC -DCOMMON_FILE_COMPRESS_GZ -DCOMMON_PTHREAD -DCOMMON_RANDOM_FIXED_SEED -DSCOTCH_RENAME -DSCOTCH_PTHREAD -Drestrict=__restrict -DIDXSIZE64")
  elseif(CMAKE_C_COMPILER_ID STREQUAL Intel)
    set(scotch_cflags "-O3 -DCOMMON_FILE_COMPRESS_GZ -DCOMMON_PTHREAD -DCOMMON_RANDOM_FIXED_SEED -DSCOTCH_RENAME -DSCOTCH_PTHREAD -restrict -DIDXSIZE64")
  else()
    message(FATAL_ERROR "Need to add compiler ${CMAKE_C_COMPILER_ID}.  Open a GitHub issue.")
  endif()

  configure_file(${CMAKE_CURRENT_LIST_DIR}/Makefile.inc Makefile.inc @ONLY)

  set(_targ scotch)

  ExternalProject_Add(Scotch
  GIT_REPOSITORY https://gitlab.inria.fr/scotch/scotch.git
  GIT_TAG v6.1.0
  GIT_SHALLOW true
  UPDATE_DISCONNECTED true
  PATCH_COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_BINARY_DIR}/Makefile.inc ${_src}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ${MAKE_EXECUTABLE} -j${Ncpu} -C ${_src} ${_targ}
  INSTALL_COMMAND ${MAKE_EXECUTABLE} -j${Ncpu} -C ${_src} install prefix=${PROJECT_BINARY_DIR}
  BUILD_BYPRODUCTS ${Scotch_LIBRARIES}
  )

  file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/include)  # avoid race condition

  ExternalProject_Add_Step(Scotch build_esmumps
  COMMAND ${MAKE_EXECUTABLE} -j${Ncpu} -C ${_src}/esmumps install
  DEPENDEES build
  DEPENDERS install
  )
endif()

add_library(Scotch::Scotch INTERFACE IMPORTED GLOBAL)
target_include_directories(Scotch::Scotch INTERFACE ${PROJECT_BINARY_DIR}/include)
target_link_libraries(Scotch::Scotch INTERFACE ${Scotch_LIBRARIES})
# set_target_properties didn't work, but target_link_libraries did work

if(NOT Scotch_FOUND)
  add_dependencies(Scotch::Scotch Scotch)
endif()
