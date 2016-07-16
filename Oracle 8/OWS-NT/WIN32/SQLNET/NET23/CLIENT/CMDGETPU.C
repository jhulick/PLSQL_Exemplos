/*
  $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/cmdgetpu.c,v 1.1 1995/09/13 16:02:20 mhill Exp $
*/

#ifndef TFTPDEF
# include "tftpdef.h"
#endif

extern FILE *file_open();
extern void file_close();
extern double t_getrtime();

void do_get(remfname, locfname)
char *remfname;
char *locfname;
{
#ifdef WIN32
  if ( (localfp = file_open(locfname, (modetype == MODE_ASCII) ? "w" : "wb", 1)) == NULL)
#else
  if ( (localfp = file_open(locfname, "w", 1)) == NULL)
#endif
  {
    err_ret("can't fopen %s for writing", locfname); 
    return;
  }

  totnbytes = 0;
  
  t_start();      /* start timer for statistics collecting */
  
  send_RQ(OP_RRQ, remfname, modetype);
  fsm_loop(OP_RRQ);
  
  t_stop();       /* stop timer for statistics collecting */

  file_close(localfp);

  printf("Received %ld bytes in %.6f seconds\n", totnbytes, t_getrtime());
}

void do_put(remfname, locfname)
char *remfname;
char *locfname;
{
#ifdef WIN32
  if ( (localfp = file_open(locfname, (modetype == MODE_ASCII) ? "r" : "rb", 0)) == NULL)
#else
  if ((localfp = file_open(locfname, "r", 0)) == NULL)
#endif
  {
    err_ret("can't fopen %s for reading", locfname); 
    return;
  }

  totnbytes = 0;
  t_start();

  lastsend = MAXDATA;
  send_RQ(OP_WRQ, remfname, modetype);
  fsm_loop(OP_WRQ);

  t_stop();

  file_close(localfp);
  printf("Sent %ld bytes in %.6f seconds\n", totnbytes, t_getrtime());
}
