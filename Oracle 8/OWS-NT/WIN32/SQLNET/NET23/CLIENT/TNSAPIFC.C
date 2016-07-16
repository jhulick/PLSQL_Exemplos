/*
   $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/tnsapifc.c,v 1.2 1995/09/11 21:49:17 mhill Exp $
*/

/* Copyright (c) 1995 by Oracle Corporation.  All rights reserved. */

/*
NAME
  tnsapifc - SQL*Net Open - finger client demo
*/

/* This demo shows how the typical BSD "finger" program could be 
   converted to work with the SQL*Net Open API.  This client program has
   been tested on Solaris and Windows NT, and is probably portable to 
   other platforms as well.

   This is meant to be used with tnsapifd, the finger server ("daemon") */


#include <stdio.h>
#include <string.h>
#include <tnsapi.h>

static int help_wanted();
static char *build_arg_string();
static void free_arg_string();

int main(argc, argv)
int argc;
char **argv;
{
    void *handle = (void *)0;
    const char *name;
    int rc = 0;
    char *command;
    int length, sent, rcvd;
    char reply[256];
    char *work;
    
    if (help_wanted(argc, argv))
    {
        (void) printf("sfinger - SQL*Net Open/finger client\n");
	(void) printf("usage: sfinger <name> <args>...\n");
	(void) printf("       <name> is the TNS service name of the finger ");
	(void) printf("daemon\n");
	(void) printf("       <args> are additional arguments to send to ");
	(void) printf("the remote finger command\n");
	exit(1);
    }
    else
    {
	/* argv[1] must be the name of the finger daemon */
	name = argv[1];
	
	rc = tnsopen(&handle, name);
	if (rc) goto error;

	/* primitive marshalling of arguments.  cram all the arguments
	   separated by spaces into a long string, and send it to the 
	   other side.  First two bytes of the string will be the number
	   1, followed by the number of bytes in the string */
	command = build_arg_string(argc, argv);

	length = strlen(command + 4) + 4 + 1; /* writing the null */
	work = command;
	
	while(length)
	{
	    sent = length;
	    rc = tnssend(handle, (void *)work, &sent);
	    if (rc) goto error;
	    
	    length -= sent;
	    work += sent;
	}
	
	free_arg_string(command);
	
	/* now read until end of file, and write whatever I get to output.
	   Note that if the finger program on the server side sends output
	   that has, for instance, only newlines, where my client expects
	   carriage returns also, this will look weird (but this is only an 
	   example.) */
	
	length = sizeof(reply);
	
	while(!rc)
	{
	    rcvd = length;
	    rc = tnsrecv(handle, (void *)reply, &rcvd);
	    write(1, reply, rcvd);
	}

	if (rc == RECVFAIL_TNSAPIE) /* receive failed - presumably eof */
	{
	    rc = tnsclose(&handle);
	    if (!rc) exit(0);
	}
	    
      error:
	printf("error code %d\n", rc);
	rc = 0;
	
	rc = tnsclose(&handle);
	if (rc)
	{
	    printf("error on tnsclose is %d\n", rc);
	}
	
	exit(0);
    }
}


/* This function returns 0 if no help is wanted, 1 otherwise - judging from 
   the contents of the argument list (user either provided -? or /? as 
   one of the arguments, or didn't provide any arguments) */
static int help_wanted(hargc, hargv)
int hargc;
char **hargv;
{
    int a = hargc;
    
    if (hargc < 2) return(1);
    
    for (; a > 1; a--)		/* ignore the first argument (program name) */
    {
	if (!strcmp(hargv[a-1], "/?") || !strcmp(hargv[a-1], "-?")) return(1);
    }
    
    return(0);
}

/* build an argument string in the following format:
   2 bytes - local representation of the number 1
   2 bytes - number of bytes in the argument string
   remaining bytes - argument list separated by spaces
   start with whatever is in argv[2] (beginning of "additional arguments") */
static char *build_arg_string(bargc, bargv)
int bargc;
char **bargv;
{
    short alloc_size = 0;
    char *result;
    short one = 1;
    char *work;
    int i;
    
    /* calculate size of buffer to allocate */
    if (bargc > 2)
    {
	i = bargc;
	for (; i > 2; i--)
	{
	    /* size of argument plus a space (or null for the end) */
	    alloc_size += (strlen(bargv[i-1]) + 1);
	}
    }
    else
    {
	alloc_size = 1;		/* space for null */
    }
    
    result = (char *)malloc(alloc_size + 4);
    
    memcpy(result, &one, 2);
    memcpy(result + 2, &alloc_size, 2);
    
    if (alloc_size == 1) 
    {
	*(result + 4) = '\0';
	return(result); /* no arguments, just return */
    }
    
    /* now copy in the arguments */
    work = result + 4;
    
    for (i = 2; i < bargc; i++)
    {
	int copied;
	
	copied = strlen(bargv[i]);
	memcpy(work, bargv[i], copied);
	*(work + copied) = ' ';
	work += (copied + 1);
    }
    
    /* last time through, convert the previous space to a null */
    *(--work) = '\0';
    return(result);
}

static void free_arg_string(string)
char *string;
{
    free(string);
    return;
}

    
