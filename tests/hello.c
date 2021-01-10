#include <stdio.h>
#include <stdint.h>
#include "scotch.h"


int main(void){

SCOTCH_Graph grafdat;
FILE * fileptr;

if (SCOTCH_graphInit (&grafdat) != 0) {
return 1;
}

return 0;
}