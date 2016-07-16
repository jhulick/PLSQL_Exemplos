/*
  $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/cmd.h,v 1.2 1995/09/12 21:32:13 mhill Exp $
*/

/* 
 * Header file for user command processing functions
 */

#ifndef CMD
#define CMD

#include "tftpdef.h"

extern char temptoken[];   /* temporary token to be used by anyone */

typedef struct Cmds {
  char *cmd_name;          /* command string */
  int (*cmd_func)();       /* comamnd function */
}Cmds;

extern Cmds commands[];
extern int ncmds;

#endif

