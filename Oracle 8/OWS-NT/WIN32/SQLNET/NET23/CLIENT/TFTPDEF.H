/*
  $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/tftpdef.h,v 1.4 1995/09/13 06:59:35 yzheng Exp $
*/

#ifndef TFTPDEF
#define TFTPDEF

#include <stdio.h>
#include <sys/types.h>
#include <setjmp.h>
#include <signal.h>
#ifndef TNSAPI
#include <tnsapi.h>
#endif
#ifdef WIN32
#include "windows.h"
#endif
#ifdef _HPUX_SOURCE
# include <netinet/in.h>	/* HPUX */
#endif /* HPUX */
/*#include "systype.h"*/

#ifdef WIN32
#define ntohs(x)  ((0xff & (x))<<8)+((0xff00 & (x))>>8) 
#define htons(x)  ((0xff & (x))<<8)+((0xff00 & (x))>>8)
#define fileno   _fileno
#endif 

#define MAXBUFF     2048       /* transmit and receive buffer length */
#define MAXDATA     1024       /* maximum size of data per packet to send
                                  or rcv, specified by RFC           */

#define MAXFILENAME  128       /* max filename length                */

#define MAXLINE      512       /* max command line length            */
#define MAXTOKEN     128       /* max token length                   */

#ifdef SERVER
extern void *svrtnshdl;        /* the tns connection handle of server */
#else
extern void *clitnshdl;        /* the tns connection handle of client*/
#endif

extern int connected;          /* we are connected with the server */
extern FILE *localfp;          /* fp of local file to read or write */
extern int modetype;           /* the transfer mode */
extern int nextblknum;         /* next block# to send/receive */

extern char command[];         /* the command being processed */
extern int interactive;        /* true if we are running interactively */
extern jmp_buf jmp_mainloop;   /* to return to main command loop */
extern int lastsend;           /* #bytes in the last data packet */

extern char *pname;            /* the name by which we are invoked */
extern char *prompt;           /* prompt string, for interactive */

extern long totnbytes;         /* for get/put statistics printing */
extern int traceflag;          /* -t command line option, or "trace" cmd */
/*extern int verboseflag; */   /* -v command line option, or "verbose" cmd */

#define MODE_ASCII    0
#define MODE_BINARY   1

#define OP_RRQ   1             /* Read request */
#define OP_WRQ   2             /* Write request */
#define OP_DATA  3             /* Data */
#define OP_ACK   4             /* Acknowledgment */
#define OP_ERROR 5             /* Error */

/*
 * This extra opcode is added to handle disconnect.
 * When the client calls "connect" to a different address, the first
 * connection should be disconnected, and the server process should 
 * go away. The client inform the server by sending a "disconnect" opcode
 * packet. When the server receives it, it calls tnsclose() to clean up
 * the connection, and then exit.
 */
#define OP_DISCONNECT 6        /* DISCONNECT */
  
#define OP_MIN   1             /* minimum op value */
#define OP_MAX   5             /* max op value */

extern int op_sent;            /* last opcode sent */
extern int op_recv;            /* last opcode received */


#define DEBUG1(fmt, arg1)    if (traceflag) {\
                                fprintf(stderr, fmt, arg1); \
                                fputc('\n', stderr); \
                                fflush(stderr); \
                                           } else;

#define DEBUG2(fmt, arg1, arg2) if (traceflag) { \
                                fprintf(stderr, fmt, arg1, arg2); \
                                fputc('\n', stderr); \
                                fflush(stderr); \
                                           } else;                                

/* 
 * define macros to load and store 2-bytes integers, since these are used
 * in the TFTP headers for opcode, block numbers and error. These macros
 * handle the conversion between host format and network byte ordering
 */
#define ldshort(addr)      (ntohs(*(u_short *)(addr)))
#define stshort(sval, addr) ( *((u_short *)(addr)) = htons(sval))

extern char recvbuff[];
extern char sendbuff[];
extern int sendlen;        /* #bytes in sendbuff[] */

/*#define CONNECT_DATA "connect data"
#define CON_LEN 128*/

/*
 * tftp error code
 */
#define ERR_UNDEF     0          /* not defined, */
#define ERR_NOFILE    1          /* File not found */
#define ERR_ACCESS    2          /* Access violation */
#define ERR_NOSPACE   3          /* Disk full */
#define ERR_BADOP     4          /* Illegal tftp operation */
#define ERR_FILE      5          /* File already exists */
#define ERR_NOUSER    6          /* No such user */

#endif

