/*
  $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/mainserv.c,v 1.2 1995/09/12 21:32:13 mhill Exp $
*/

# include "tftpdef.h"

void *svrtnshdl;

main(argc, argv)
int argc;
char **argv;
{
  int err;
  size_t conlen;
  char conbuf[MAXBUFF];

  svrtnshdl = 0;
  if ( ( err = tnsopen(&svrtnshdl, 0)) != 0)
  {
    err_ret("tnsopen failed with error %d", err);
    tnsclose(&svrtnshdl);
    exit(1);
  }
  else
  {
    if ( ( err = tnsrecv(svrtnshdl, conbuf, &conlen)) == 0)
    {
      /*
       * connection has been established, start to process request 
       */
      fsm_loop(0);
    }
    else
    {
      err_ret("server failed to accept connection, error code %d", err);
      tnsclose(&svrtnshdl);
      return;
    }
  }
}
