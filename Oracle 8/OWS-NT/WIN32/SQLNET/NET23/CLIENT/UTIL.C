/*
  $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/util.c,v 1.4 1995/09/13 06:57:30 yzheng Exp $
*/

/*
 * Error handling and reporting routines
 */

#include <stdio.h>
#include <varargs.h>
#ifndef WIN32
#include <sys/time.h>
#else
#include <time.h>
#endif

#ifdef WIN32
static time_t time_start, time_stop; /* for real time */
#else
static struct timeval time_start, time_stop; /* for real time */
#endif
static double start, stop, seconds;

char *sys_err_str();

/*
 * Fatal error. Print a message, dump core
 */

err_dump(va_alist)
va_dcl
{
  va_list args;
  char *fmt;

  va_start(args);
  fmt = va_arg(args, char *);
  vfprintf(stderr, fmt, args);
  va_end(args);

  fprintf(stderr, "%s \n", sys_err_str());

  fflush(stdout);  /* abort does not flush stdio buffers */
  fflush(stderr);
  abort();      /* dump core and terminate */
  exit(1);      /* should not get here */
}


/*
 * Fatal error related to a system call. Print a message and terminate.
 */
err_sys(va_alist)
va_dcl
{
  va_list args;
  char *fmt;

  va_start(args);
  fmt = va_arg(args, char *);
  vfprintf(stderr, fmt, args);
  va_end(args);

  fprintf(stderr, "%s \n", sys_err_str());

  exit(1);
}

/*
 * Print a message and return to caller
 */
void err_ret(va_alist)
va_dcl
{
  va_list args;
  char *fmt;

  va_start(args);
  fmt = va_arg(args, char *);
  vfprintf(stderr, fmt, args);
  va_end(args);

  fprintf(stderr, "%s \n", sys_err_str());

  fflush(stdout);
  fflush(stderr);
  return;
}

/*
 * return a string containing some additional operating-system dependent
 * information. 
 */
#ifndef WIN32
extern int errno;     /* UNIX errno number */
extern int sys_nerr;  /* # of error message strings in sys table */
extern char *sys_errlist[]; /* the system error message table */
#endif
char * sys_err_str()
{
  static char msgstr[1024];
#ifndef WIN32  
  if (errno != 0)
  {
    if (errno > 0 && errno < sys_nerr)
      sprintf(msgstr, "(%s)", sys_errlist[errno]);
    else
      sprintf(msgstr, "(errno = %d)", errno);
  }
  else
  {
    msgstr[0] = '\0';
  }
#endif
  return(msgstr);
}

/*
 * start the time,
 * save some info for the stop timer to use 
 */
void t_start()
{
#ifdef WIN32
  time_start = time(NULL) ;
#else
  if (gettimeofday(&time_start, (struct timezone *)0) < 0)
    err_sys("t_start: gettimeofday() error");
#endif
}

/* 
 * stop the timeer and save appropiate info
 */
void t_stop()
{
#ifdef WIN32
  time_stop = time(NULL) ;
#else
  if (gettimeofday(&time_stop, (struct timezone *)0) < 0)
    err_sys("t_stop: gettimeofday() error");
#endif
}

/*
 * return the real elapsed time in seconds
 */
double t_getrtime()
{
#ifdef WIN32
  seconds = (double)(time_stop - time_start)  ;
#else
  start = ((double)time_start.tv_sec)* 1000000.0 + time_start.tv_usec;
  stop =  ((double)time_stop.tv_sec) * 1000000.0 + time_stop.tv_usec;
  seconds = (stop - start) / 1000000.0;
#endif
  return (seconds);
}

   
