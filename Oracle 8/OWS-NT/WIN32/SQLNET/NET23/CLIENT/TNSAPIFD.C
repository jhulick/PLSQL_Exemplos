/*
   $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/tnsapifd.c,v 1.2 1995/09/11 21:49:37 mhill Exp $
*/

/* Copyright (c) 1995 by Oracle Corporation.  All rights reserved. */

/*
NAME
  tnsapifd - SQL*Net Open - finger server ("daemon") demo
*/

/* This demo implements a simple "finger" server to work with the finger
   client program in tnsapifc.c, using the SQL*Net Open API.

   This server is implemented for Unix and was tested on Solaris - it 
   simply invokes the finger program.   If you're not on Unix, you may want
   to implement something analogous to this using this program as a
   template. */

#ifdef WIN32
#include <windows.h>
#endif

#include <tnsapi.h>

/* For non-Solaris operating systems you may need to change this pathname */
#define TNSAPIFD_FINGER_PROGRAM "finger.exe"

static short get_string_length();
char **build_arg_array();
static void free_arg_array();

#ifdef WIN32
int main(argc, argv)
int argc;
char **argv;
{
    void *handle = 0;		/* connection handle I get from tnslsnr */
    char reply[256];		/* work buffer */
    char *work;			/* pointer into work buffer */
    int rc = 0;
    int length, rcvd, sent = 0;
    HANDLE hPipeRead, hPipeWrite ; /* read/write handle for pipe */

    SECURITY_ATTRIBUTES stSecAttrib ;

    /* pick up connection from tnslsnr (service name is null because we're
       on server side */
    rc = tnsopen(&handle, (const char *)0);
    if (rc) goto error;

    /* set security attributes for pipe */
    stSecAttrib.nLength = sizeof(SECURITY_ATTRIBUTES) ;
    stSecAttrib.bInheritHandle = TRUE ;
    stSecAttrib.lpSecurityDescriptor = NULL ;
    

    /* read and process the argument string.

       we get this in two pieces.  first read four bytes, which gives
       us enough information to get the length of the argument list - then
       read the argument list */
    length = 4;
    work = reply;
    
    while(length)
    {
	rcvd = length;
	rc = tnsrecv(handle, work, &rcvd);
	if (rc) goto error;
	length -= rcvd;
	work += rcvd;
    }

    length = (int)get_string_length(reply);

    memset(reply, 0, sizeof(reply)) ;
    work = reply;
    
    /* now read the argument string into the reply buffer */
    while(length)
    {
	rcvd = length;
	rc = tnsrecv(handle, work, &rcvd);
	if (rc) goto error;
	length -= rcvd;
	work += rcvd;
    }


    /* create a pipe to communicate with child process */
    if(! CreatePipe(&hPipeRead, &hPipeWrite, &stSecAttrib, 0) )
	goto error ;

    /* start the child process - finger.exe */
    if(! SpawnChild(reply, hPipeWrite))
	goto error ;

    Sleep(1000) ;

    /* close write handle */
    if(! CloseHandle(hPipeWrite))
	goto error ;

    /* read from child through pipe */
    memset(reply, 0, sizeof(reply)) ;
    while (TRUE)
    {
	if(! ReadFile(hPipeRead, reply, sizeof(reply), &rcvd, NULL))
	{
		rc = GetLastError() ;
		break ;
	}

	if(!rcvd)
		break ;

	while (rcvd)
	{
		sent = rcvd;
		rc = tnssend(handle, reply, &sent);
		if (rc) goto error;
		rcvd -= sent;
	}
    }



    rc = tnsclose(&handle);
    if (rc) goto error;

    /* done */
    return(0) ;



  error:
    if (rc)
    {
	if (rc != RECVFAIL_TNSAPIE) (void) printf("error code %d\n", rc);
    }
    else
    {
	perror("sfingerd");
    }
    exit(1);
}

BOOL SpawnChild(char *args, HANDLE hPipeWrite)
{
  PROCESS_INFORMATION	stProcInfo ;
  STARTUPINFO		stStartInfo ;
  char			szCmd[256] ;

  stStartInfo.cb		= sizeof(STARTUPINFO) ;
  stStartInfo.lpReserved	= NULL ;
  stStartInfo.lpReserved2	= NULL ;
  stStartInfo.cbReserved2	= 0 ;
  stStartInfo.lpDesktop		= NULL ;
  stStartInfo.dwFlags		= STARTF_USESTDHANDLES ;
  stStartInfo.hStdOutput	= hPipeWrite ;
  stStartInfo.hStdError		= hPipeWrite ;


  memset(szCmd, 0, sizeof(szCmd)) ;
  sprintf(szCmd, "%s %s", TNSAPIFD_FINGER_PROGRAM, args) ;
  return CreateProcess( NULL,
			szCmd,		   	   /* command line */
			NULL,			   /* security */
			NULL,			   /* main thread security */
			TRUE,			   /* inherit handles */
			0,			   /* creation flags */
			NULL,			   /* use parent env */
			NULL,			   /* use parent current dir */
			&stStartInfo,
			&stProcInfo
			) ;
}

#else  /* WIN32 */

int main(argc, argv)
int argc;
char **argv;
{
    void *handle;		/* connection handle I get from tnslsnr */
    char reply[256];		/* work buffer */
    char *work;			/* pointer into work buffer */
    int rc = 0;
    int p[2];
    int length, rcvd, sent = 0;
    char **args;
    
    /* pick up connection from tnslsnr (service name is null because we're
       on server side */
    rc = tnsopen(&handle, (const char *)0);
    if (rc) goto error;

    if (pipe(p)) goto error;
    
    /* read and process the argument string.

       we get this in two pieces.  first read four bytes, which gives
       us enough information to get the length of the argument list - then
       read the argument list */
    length = 4;
    work = reply;
    
    while(length)
    {
	rcvd = length;
	rc = tnsrecv(handle, work, &rcvd);
	if (rc) goto error;
	length -= rcvd;
	work += rcvd;
    }

    length = (int)get_string_length(reply);

    *reply = '\0';
    work = reply;
    
    /* now read the argument string into the reply buffer */
    while(length)
    {
	rcvd = length;
	rc = tnsrecv(handle, work, &rcvd);
	if (rc) goto error;
	length -= rcvd;
	work += rcvd;
    }

    switch(fork())
    {
      case 0:
	/* this is the forked off process (actual finger program) */
	
	/* dup my stdout onto the pipe so that the parent process can 
	   read it */
	(void) close(p[0]);
	(void) dup2(p[1], 1);
	(void) close(p[1]);
	
	/* build an array of arguments out of the string we read */
	args = build_arg_array(reply);

	args[0] = TNSAPIFD_FINGER_PROGRAM;

	if (execv(TNSAPIFD_FINGER_PROGRAM, args) < 0) perror("execv");
	
	free_arg_array(args);
	
	exit(0);

      case -1:
	goto error;

      default:
	/* this is the parent process, read output from finger and send it */
	(void) close(p[1]);

	while ((rcvd = read(p[0], reply, sizeof(reply)) ) > 0 && rcvd)
	{
	    while (rcvd)
	    {
		sent = rcvd;
		rc = tnssend(handle, reply, &sent);
 		if (rc) goto error;
		rcvd -= sent;
	    }
	}

 	rc = tnsclose(&handle);
	if (rc) goto error;

	exit(0);
    }

  error:
    if (rc)
    {
	if (rc != RECVFAIL_TNSAPIE) (void) printf("error code %d\n", rc);
    }
    else
    {
	perror("sfingerd");
    }
    exit(1);
}


#endif /* WIN32 */

/* get length of the argument list to be read from first four bytes of 
   the data that was read.  This is the counterpart to build_arg_string in 
   tnsapifc.c */
static short get_string_length(buf)
char *buf;
{
    char *work = buf;
    short one;
    short result;
    char *resultb = (char *)&result;
    
    
    memcpy(&one, buf, 2);
    if (one == 1) 
    {
	/* same data representation */
	memcpy(&result, buf + 2, 2);
	return(result);
    }
    else
    {
	/* swap bytes */
	*(resultb) = *(buf + 3);
	*(resultb + 1) = *(buf + 2);
	return(result);
    }
}

char **build_arg_array(buf)
char *buf;
{
    char **array;
    char *work = buf;
    int entry = 0;
    
    /* allocate "enough" space, not actually sure how many entries we have */
#define max_arguments 10    
    array = (char **)malloc(4 * max_arguments);

    entry++;			/* reserve first slot for program name */
    if (*work)
    {
	array[entry++] = work++;	/* set up first pointer */
    }
    else
    {
	array[entry] = (char *)0;
	return(array);
    }
    
    for (; *work; )
    {
	if (*work == ' ')
	{
	    *work++ = '\0';
	    array[entry++] = work;
	}
	else
	{
	    work++;
	}
    }

    array[entry] = (char *)0;
    return(array);
}

void free_arg_array(args)
char **args;
{
    free(args);
    return;
}



