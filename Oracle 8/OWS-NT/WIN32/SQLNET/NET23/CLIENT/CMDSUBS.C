/*
  $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/cmdsubs.c,v 1.2 1995/09/12 21:32:13 mhill Exp $
*/

#ifndef CMD
#include "cmd.h"
#endif

int cmd_ascii();
int cmd_binary();
int cmd_connect();
int cmd_exit();
int cmd_get();
int cmd_put();
int cmd_help();
int cmd_mode();
int cmd_status();
int cmd_trace();
/*int cmd_verbose();*/

Cmds commands[] = {
  "?",          cmd_help,
  "ascii",      cmd_ascii,
  "binary",     cmd_binary,
  "connect",    cmd_connect,
  "exit",       cmd_exit,
  "get",        cmd_get,
  "help",       cmd_help,
  "mode",       cmd_mode,
  "put",        cmd_put,
  "quit",       cmd_exit,
  "status",     cmd_status,
  "trace",      cmd_trace
/*  "verbose",    cmd_verbose*/
};
#define NCMDS (sizeof(commands) / sizeof(Cmds))

int ncmds = NCMDS;
static char   line[MAXLINE] = { 0 };
static  char *lineptr = NULL;

/*
 * Fetch the next command line
 *
 * Return 1 if ok, else 0 on error or EOF
 */

int getline(fp)
FILE *fp;
{
  if (fgets(line, MAXLINE, fp) == NULL)
    return(0);
  lineptr = line;
  return(1);
}

/*
 * Fetch the next token from the input stream.
 * We use the line that was set up in the most recent call to
 * getline()
 *
 * Return a pointer to the token (argument), or NULL if no more exist
 */
char *gettoken(token)
char token[];
{
  register int c;
  register char *tokenptr;

  while ((c = *lineptr++) == ' ' || c == '\t')
    ;   /* skip leading white space */

  if (c == '\0' || c == '\n')
    return(NULL);

  tokenptr = token;
  *tokenptr++ = c;   /* first char of token */

  /*
   * collect everything up to the next space, tab, newline, or null
   */
  while (( c  = *lineptr++) != ' ' && c != '\t' && c != '\n' && c != '\0')
    *tokenptr++ = c;

  *tokenptr ='\0';   /* null terminate token */
  return(token);
}


/*
 * verify there is no more token left on command line
 */
void checkend()
{
  if (gettoken(temptoken) != NULL)
    err_cmd("trailing garbage");
}

/*
 * Execute a command.
 * Call the appropiate function. If all goes well, that function will
 * return, otherwise, that function may call an error handler, which
 * will call longjmp() and branch back to the main command processing
 * loop.
 */

docmd(cmdptr)
char *cmdptr;
{
  register int i;

  if  ((i = binary(cmdptr, ncmds)) < 0)
      err_cmd(cmdptr);

      (*commands[i].cmd_func)();
      
      checkend();
}

/* 
 * Perform a binary search of the command table
 * to see if a given token is a valid command
 */
int binary(word, n)
char *word;
int n;
{
  register int low, high, mid, cond;

  low = 0;
  high = n - 1;
  while (low <= high)
  {
    mid = (low + high)/2;
    if ( (cond = strcmp(word, commands[mid].cmd_name)) < 0)
      high = mid - 1;
    else if (cond > 0)
      low = mid + 1;
    else
      return(mid);
  }
  return(-1);  /* not found */
}

/*
 * User command error
 */
err_cmd(str)
char *str;
{
  fprintf(stderr, "%s: '%s' command error ", pname, command);
  if (strlen(str) > 0)
    fprintf(stderr, "%s", str);
  fprintf(stderr, "\n");
  fflush(stderr);

  longjmp(jmp_mainloop, 1);
}

