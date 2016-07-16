/*
  $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/maincli.c,v 1.4 1995/09/13 07:03:40 yzheng Exp $
*/

/*
 * main function of the client. parse the command line argument, 
 * set up the option flag like trace, call underlying 
 * routine to process the file. 
 */
 
#include "tftpdef.h"
#include <stdio.h>

char *prompt = "tftp> ";
void *clitnshdl = 0;

main(argc, argv)
int argc;
char **argv;
{
  register int i;
  register char *s;
  register FILE *fp;

  pname = argv[0];

  /*
   * parse the command line argument, e.g.
   * tftp -t     - trace
   */

  /*
   * take command line argument, process the command. Standard
   * input is processed by default 
   */

  fp = stdin;

  mainloop(fp);
    
  exit(0);
}

/*
 * Main loop. Read a command and execute it.
 * This loop is terminated by a "quit" command, or an end-of-file
 * on the command stream
 */ 
mainloop(fp)
FILE *fp;
{
  void sig_intr();

  if (signal(SIGINT, SIG_IGN) != SIG_IGN)
    signal(SIGINT, sig_intr);

  if (setjmp(jmp_mainloop) < 0)
    err_ret("Timeout");

  /*
   * print the prompt for interactive 
   */
  if (interactive)
    printf("%s", prompt);
  
  while (getline(fp))
  {
    if (gettoken(command) != NULL)
      docmd(command);
    
    if (interactive)
      printf("%s", prompt);

    command[0] = '\0';
  }
}

/* 
 * INTR signal handler. Just return to the main loop.
 * In case we were waiting for a read to complete, turn off any 
 * possible alarm clock interrupts.
 *
 * Note that with TFTP, if the client aborts a file transfer (such as
 * with the interrupt signal), the server is not notified. The protocol
 * counts on the server eventually timing out and exiting.
 * 
 */
void sig_intr()
{
#ifndef WIN32
  signal(SIGALRM, SIG_IGN);
  alarm(0);
#endif

  longjmp(jmp_mainloop, 1);
}

