program hello

use, intrinsic :: iso_fortran_env, only : real64

implicit none (type, external)

INCLUDE "scotchf.h"

external :: SCOTCHFGRAPHINIT

real(real64) :: GRAFDAT(SCOTCH_GRAPHDIM)
INTEGER :: ierr

CALL SCOTCHFGRAPHINIT (GRAFDAT (1), ierr)
IF (ierr /= 0) error stop "failed to init scotch graph"

end program