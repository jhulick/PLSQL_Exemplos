/*
  $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/cmd.c,v 1.2 1995/09/12 21:32:13 mhill Exp $
*/

/*
 * command processing function on the client side
 */
#ifndef CMD
# include "cmd.h"
#endif

int cmd_ascii()
{
  modetype = MODE_ASCII;
}

int cmd_binary()
{
  modetype = MODE_BINARY;
}

int cmd_connect()
{
  char con_string[MAXBUFF];   /* connect string */
  char *data = "";
  int datalen = 1;

/*
 * We need to check if a previous connection is open, if so, we need to
 * send a disconnect packet to the existing server process first, asking
 * it to close down the connect, before we establish a different connection
 */

  if (clitnshdl)
  {
    send_DISRQ();
    tnsclose(&clitnshdl);
  }

  if (gettoken(con_string) == NULL)
    err_cmd("incorrect connect string or alias");

  if (tnsopen(&clitnshdl, con_string) != 0)
    err_cmd("tnsopen failed");

  /* send an empty string over to establish connection */
  if (tnssend(clitnshdl, data, &datalen) != 0)
  {
    tnsclose(&clitnshdl);
    err_cmd("Failed to establish connection with the server");
  }
  else
    connected = 1;
  
}

int cmd_exit()
{
  if (clitnshdl)
  {
    send_DISRQ();
    tnsclose(&clitnshdl);
  }
  exit(0);
}

int cmd_get()
{
  char remfname[MAXFILENAME], locfname[MAXFILENAME];

  if (gettoken(remfname) == NULL)
    err_cmd("the remote filename must be specified");
  if (gettoken(locfname) == NULL)
    err_cmd("the local filename must be specified");

  do_get(remfname, locfname);
}

int cmd_help()
{
  register int i;
  
  for (i = 0; i < ncmds; i++)
    printf(" %s\n", commands[i].cmd_name);

}

int cmd_mode()
{
  if (gettoken(temptoken) == NULL)
    err_cmd("a mode type must be specified");
  else
  {
    if (strcmp(temptoken, "ascii") == 0)
      modetype = MODE_ASCII;
    else if (strcmp(temptoken, "binary") == 0)
      modetype = MODE_BINARY;
    else
      err_cmd("mode must be 'ascii' or 'binary'");
  }
}

int cmd_put()
{
  char remfname[MAXFILENAME], locfname[MAXFILENAME];

  if (gettoken(locfname) == NULL)
    err_cmd("the local filename must be specified");
  if (gettoken(remfname) == NULL)
    err_cmd("the remote filename must be specified");

  do_put(remfname, locfname);
}

int cmd_status()
{
  if (connected)
    printf("Connected\n");
  else
    printf("Not connected\n");

  printf("mode = ");
  switch(modetype)
  {
  case MODE_ASCII:
    printf("netascii");
    break;
  case MODE_BINARY:
    printf("octet (binary)");
    break;
  default:
    err_cmd("unknown modetype");
  }

/*  printf(", verbose = %s", verboseflag ? "on": "off"); */
  printf(", trace = %s\n", traceflag ? "on" : "off");

}

int cmd_trace()
{
  traceflag = !traceflag;
}

/*int cmd_verbose()
{
  verboseflag = !verboseflag;
}*/


