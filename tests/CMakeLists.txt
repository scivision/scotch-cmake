add_executable(hello_c hello.c)
target_link_libraries(hello_c PRIVATE Scotch::Scotch)
add_test(NAME ScotchC COMMAND $<TARGET_FILE:hello_c>)

include(CheckLanguage)
check_language(Fortran)
if(NOT CMAKE_Fortran_COMPILER)
  return()
endif()
enable_language(Fortran)

add_executable(hello_f hello.f90)
target_link_libraries(hello_f PRIVATE Scotch::Scotch)
add_test(NAME ScotchFortran COMMAND $<TARGET_FILE:hello_f>)
