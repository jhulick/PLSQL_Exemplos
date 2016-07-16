/*
  $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/initvars.c,v 1.2 1995/09/12 21:32:13 mhill Exp $
*/

#include "tftpdef.h"

char command[MAXTOKEN] = {0};
int interactive  = 1;
int connected = 0;
jmp_buf jmp_mainloop = {0};
int lastsend = 0;
FILE *localfp = NULL;
int modetype = MODE_ASCII;
int nextblknum = 0;
int op_sent = 0;
int op_recv = 0;
char recvbuff[MAXBUFF] = { 0 };
char sendbuff[MAXBUFF] = { 0 };
int sendlen = 0;
char temptoken[MAXTOKEN] = { 0 };
long totnbytes = 0;
int traceflag = 0;
/*int verboseflag = 0;*/
char *pname = 0;
