/*
   testeph - program to interpolate positions and velocieties
             from a binary ephemeris file, and compare results
             with test data from JPL.
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "ephcom.h"


main(int argc, char *argv[]) {

struct ephcom_Header header1;
struct ephcom_Coords coords;
double *datablock;  /* Will hold coefficients from a data block */
int datablocknum;
int i;
/*
   Test parameter variables.
*/
char testline[EPHCOM_MAXLINE+1]; /* To read line from TEST file */
int testnumde; /* ephemeris number; make sure it matches ephemeris */
char testdate[16]; /* To hold "yyyy.mm.dd" with possible negative year */
double testjd; /* Test Julian Day */
int testntarg, testnctr; /* Target body and center body */
int testncoord; /* Coordinate number in testr to compare */
double testxi; /* Pre-calculated value to compare with testr */
int outline; /* Line we've read in so far */
double testr[6]; /* To hold x, xdot, y, ydot, z, zdot for all bodies */
double testdel; /* Difference between TEST file result and calculation */
double start_time, end_time; /* time from argv */
double step, t_step, numbers, tmp;  
int target_body, central_body, counter, k;
/*
   Output file parameters.
*/
FILE *infp, *outfp, *testfp, *fopen();

if (argc < 7) {
   fprintf(stderr,
      "\nFormat:\n\n         %s ephemeris-file start_time end_time step target_point center_point\n\n",
           argv[0]);
   exit(1);
   }

if (strcmp(argv[1], "-") == 0) {
   fprintf(stderr,"\nERROR: Can't open ephemeris file on stdin.\n\n");
   exit(1);
   }
if ((infp = fopen(argv[1],"r")) == NULL) {
   fprintf(stderr,"\nERROR: Can't open ephemeris file %s for input.\n\n", argv[1]);
   exit(1);
   }

outfp = stdout;    

ephcom_readbinary_header(infp, &header1);
// ephcom_writeascii_header(outfp, &header1);
/*
   Done with header.  Now we'll read and write data blocks.
*/
datablock = (double *)malloc(header1.ncoeff * sizeof(double));
datablocknum = 0;
coords.km = 0;        /* Use AU, not kilometers */
coords.seconds = 0;   /* Timescale is days, not seconds */
coords.bary = 1;      /* Center is Solar System Barycenter */
coords.coordtype=0;   /* No correction for light travel time or
                         relativistic effects from Sun */

testjd = header1.ss[0]; /* Initialize to be within range */
outline = 0;

start_time = atof(argv[2]);
end_time   = atof(argv[3]);
step       = atof(argv[4]);
target_body = atoi(argv[5]);
central_body = atoi(argv[6]);
  
tmp = 0.0;
numbers = 0.0;
numbers = (end_time - start_time) / step;
counter = (int)numbers;
k = 0;
while (k <= counter)
{                 
  coords.et2[0] = start_time + tmp;
  coords.et2[1] = 0.0;  
  if (ephcom_get_coords(infp, &header1, &coords, datablock) == 0)
  {
    ephcom_pleph(&coords, target_body, central_body, testr);
    fprintf(outfp, "%.12lf;%.12lf;%.12lf;%.12lf;%.12lf;%.12lf\n", testr[0],testr[1],testr[2],testr[3],testr[4],testr[5]);
  }
  tmp += step;
  k++;             
}
exit(1);

fclose(infp);
fclose(testfp);
if (outfp != stdout) fclose(outfp);

exit(0);
}

