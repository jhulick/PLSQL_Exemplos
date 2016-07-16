/*
  $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/sendrecv.c,v 1.3 1995/09/12 22:43:28 yzheng Exp $
*/

#include "tftpdef.h"
#include <sys/stat.h>
#include <ctype.h>

extern FILE *file_open();
extern void file_close();
extern int file_read();
extern int file_write();

static void send_ERROR();

#ifdef CLIENT

/*
 * Send a RRQ or WRQ to the other side. 
 * These two packets are only sent by the client to the server.
 */

void send_RQ(opcode, fname, mode)
int opcode;  /* RRQ or WRQ */
char *fname;
int mode;
{
  register int len;
  char *modestr;

  DEBUG2("sending RRQ/WRQ for %s, mode =%d", fname, mode);
  
  stshort(opcode, sendbuff);
  strcpy(sendbuff+2, fname);
  len = 2 + strlen(fname) + 1;    /* 1 for null byte at the end of fname */

  switch (mode)
  {
  case MODE_ASCII:  modestr="netascii"; break;
  case MODE_BINARY: modestr="octet"; break;
  default: err_dump("unknown mode");
  }

  strcpy(sendbuff + len, modestr);
  len +=strlen(modestr) + 1;

  sendlen = len;
  net_send(sendbuff, sendlen);
  op_sent = opcode;
}

/*
 * Error packet received in response to an RRQ or WRQ.
 * Usually means the file we are asking for on the other system
 * can't be accessed for some reason. We need to print the error
 * message that is returned.
 * called by finite state machine
 */

int recv_RQERR(ptr, nbytes)
char *ptr;   /* points just past received opcode */
int nbytes;  /* does not include received opcode */
{
  register int ecode;

  ecode  = ldshort(ptr);
  ptr += 2;
  nbytes -= 2;
  ptr[nbytes] = 0;  

  DEBUG2("ERROR received, %d bytes, error code %d", nbytes, ecode);
  fflush(stdout);
  fprintf(stderr, "Error# %d: %s\n", ecode, ptr);
  fflush(stderr);
  return(-1);
}

/*
 * Send a disconnect to the other side to inform it to disconnect
 */
void send_DISRQ()
{
  stshort(OP_DISCONNECT, sendbuff);
  sendlen = 2;

  net_send(sendbuff, sendlen);
}

#endif /* CLIENT */

/* 
 * Send data to the other side
 * The data must be stored in the "sendbuff" by the caller
 * called by recv_ACK()
 */
void send_DATA(blocknum, nbytes)
int blocknum;
int nbytes;        /* #bytes of actual data to send */
{
  DEBUG2("sending %d bytes of DATA with block# %d", nbytes, blocknum);

  stshort(OP_DATA, sendbuff);
  stshort(blocknum, sendbuff+2);
  sendlen = nbytes + 4;
  
  net_send(sendbuff, sendlen);
  op_sent = OP_DATA;

}

/*
 * Send an acknowledgment packet to the other side
 * called by recv_DATA) and recv_WRQ()
 */
void send_ACK(blocknum)
int blocknum;
{
  DEBUG1("sending ACK for block # %d", blocknum);

  stshort(OP_ACK, sendbuff);
  stshort(blocknum, sendbuff+2);

  sendlen = 4;
  net_send(sendbuff, sendlen);
  op_sent = OP_ACK;
}

/* 
 * Data packet received. Send an acknowledgment.
 * called by finite state machine.
 * This fucntion is called by both client and server
 */
int recv_DATA(ptr, nbytes)
char *ptr;     /* points just past received opcode */
int nbytes;    /* does not include received opcode */
{
  register int recvblknum;

  recvblknum = ldshort(ptr);
  ptr += 2;
  nbytes -= 2;

  DEBUG2("data received, %d bytes, block# %d", nbytes, recvblknum);

  if (nbytes > MAXDATA)
  {
    err_dump("data packet received with length = %d bytes", nbytes);
  }

  if (recvblknum == nextblknum)
  {
    /*
     * The data packet is the expected one. Increase our expected-block# for
     * the next packet.
     */
    nextblknum++;
    totnbytes += nbytes;

    if (nbytes > 0)
    {
      /*
       * The final data packet can have a data length of zero, so we only
       * write the data to the local file if there is data.
       */
      file_write(localfp, ptr, nbytes, modetype);
    }

    send_ACK(recvblknum);
#ifdef SERVER
    /*
     * if the length of the data is between 0-511, this is the last data
     * block. For the server, here is where we have to close the file. 
     * For the client, the "get" command processing will close the file.
     */
    if (nbytes < MAXDATA)
    {
      file_close(localfp);
      op_sent = 0;      /* need to reset it for next operation */
    }
#endif
  }
  else
  {
    /* something is wrong */
    err_dump("data block# and ACK block# mismatch");
  }



  /*
   * If the length of the data is between 0-511, we have just received
   * the final data packet, else there is more to come 
   */
  /* 
   * For server, it has to stay in fsm_loop() to wait for new incoming
   * request, for client, it should exit fsm_loop()
   */
#ifdef SERVER
  return (0);
#else    /* client */
  return( (nbytes == MAXDATA) ? 0 : -1);
#endif
}

  
/*
 * ACK packet received. Send some more data.
 * Called by finite state machine. Also called by recv_RRQ() to start 
 * the transmission of a file to the client.
 * This function is called by both the client and the server.
 */
int recv_ACK(ptr, nbytes)
char *ptr;         /* pointer to just past received code */
int nbytes;        /* does not include received opcode */
{
  register int recvblknum;

  recvblknum = ldshort(ptr);
  if (nbytes != 2)
    err_dump("ACK packet received with length = %d bytes", nbytes + 2);

  DEBUG1("ACK received, block# %d", recvblknum);
  if (recvblknum == nextblknum)
  {
    /*
     * The received acknowledgement is for the expected data packet that
     * we sent.
     * Fill the transmit buffer with the next block of data to send.
     * If there is not more data to send, then we might be finished.
     * Note that we must send a final data packet containing 0-511 
     * bytes of data. If the length of the last packet that we sent
     * was exactly 512 bytes, there we must send a 0-length data packet.
     */

    if (( nbytes = file_read(localfp, sendbuff+4, MAXDATA, modetype)) == 0)
    {
      if (lastsend < MAXDATA)
      {
/*
 * This is the last data packet sent on the server side, server needs to 
 * close the file. Server returns 0 so it will loop in fsm_loop() to wait
 * for new incoming request.
 */
#ifdef SERVER
        file_close(localfp);
        op_sent = 0;    /* reset op_sent for server */
        return(0);
#else  /* client */
        return(-1);  /* done */
#endif
      }
    }
    lastsend = nbytes;
    nextblknum++;
    totnbytes +=nbytes;
    send_DATA(nextblknum, nbytes);
    return(0);
  }
  else if (recvblknum == (nextblknum - 1))
  {
    /*
     * We have received a duplicate ACK. This means either
     * (1) the other side never received our last data packet
     * (2) the other side's ACK got delayed somehow.
     *
     * Ignore the ACK, do NOT retransmit the data packet
     * 
     * This should not happen in a reliable transport
     */
    return(0);
  }
  else 
  {
    err_dump("data block # and ACK block # mismatch");
  }
}

        

#ifdef SERVER

/*
 * RRQ received
 */
int recv_RRQ(ptr, nbytes)
char *ptr;
int nbytes;
{
  char ackbuff[2];
  recv_xRQ(OP_RRQ, ptr, nbytes);

  /*
   * set things up so we can just call recv_ACK() and pretend we 
   * have received an ACK, so it will send the first data block to 
   * the client.
   */

  lastsend = MAXDATA;
  stshort(0, ackbuff);  /* pretend it is an ACK of block #0 */

  recv_ACK(ackbuff, 2); /* this sends data block #1 */
  return(0);            /* the state machine takes over from here */

}

/*
 * WRQ received
 */
int recv_WRQ(ptr, nbytes)
char *ptr;
int nbytes;
{
  recv_xRQ(OP_WRQ, ptr, nbytes);

  /* 
   * call send_ACK() to acknowledge block #0, which will cause the client
   * to send data block #1.
   */
  nextblknum = 1;
  send_ACK(0);
  return(0);       /* the state machine takes over from here */
}

/*
 * Process the RRQ or WRQ received 
 */
int recv_xRQ(opcode, ptr, nbytes)
int opcode;                 /* RRQ or WRQ */
register char *ptr;         /* points just past received opcode */
int nbytes;                 /* does not include received opcode */
{
  register int i;
  register char *saveptr;
  char filename[MAXFILENAME], dirname[MAXFILENAME], mode[MAXFILENAME];
  struct stat statbuff;

  /*
   * Assume the file name and mode are present and null-terminated
   */
  saveptr = ptr;    /* points to the beginning of file name */
  for (i = 0; i < nbytes; i++)
    if (*ptr++ == '\0')
      goto FileOK;
  err_dump("Invalid filename");

 FileOK:
  strcpy(filename, saveptr);
  saveptr = ptr;

  for ( ; i < nbytes; i++)
    if (*ptr++ == '\0')
      goto ModeOK;
  err_dump("Invalid Mode");

 ModeOK:
  strlccpy(mode, saveptr);

  if (strcmp(mode, "netascii") == 0)
    modetype = MODE_ASCII;
  else if (strcmp(mode, "octet") == 0)
    modetype = MODE_BINARY;
  else
    send_ERROR(ERR_BADOP, "Mode is not netascii or octet");

  /*
   * validate file name. File must have permission to be publicly accessed
   * Filename must have its full pathname specified, i.e., it must begin
   * with a slash
   */
    
#ifndef WIN32
  if (filename[0] != '/')
    send_ERROR(ERR_ACCESS, "filename must begin with a '/'");
#endif

  if (opcode == OP_RRQ)
  {
    /*
     * read request - verify that the file exists and it has world
     * read permission
     */
    if (stat(filename, &statbuff) < 0)
      send_ERROR(ERR_ACCESS, sys_err_str());
    if ((statbuff.st_mode & (S_IREAD >> 6)) == 0 )
      send_ERROR(ERR_ACCESS, "File does not allow world read permission");
  }
  else if ( opcode == OP_WRQ)
  {
    /*
     * write request - verify that the directory that the file is being
     * written to has world write permission. 
     */
    char *strrchr();

    strcpy(dirname, filename);
#ifdef WIN32
    *(strrchr(dirname, '\\') + 1) = '\0';
#else
    *(strrchr(dirname, '/') + 1) = '\0';
#endif
    if (stat(dirname, &statbuff) < 0)
      send_ERROR(ERR_ACCESS, sys_err_str());
    if((statbuff.st_mode & (S_IWRITE >> 6)) == 0)
      send_ERROR(ERR_ACCESS, "Directory does not have world write permission");
  }
  else
    err_dump("Unknown request mode");
#ifdef WIN32
  if( modetype == MODE_ASCII )
    localfp = file_open(filename, (opcode == OP_RRQ) ? "r" : "w",0);
  else
    localfp = file_open(filename, (opcode == OP_RRQ) ? "rb" : "wb",0);
#else
  localfp = file_open(filename, (opcode == OP_RRQ) ? "r" : "w",0);
#endif
  if (localfp == NULL)
    send_ERROR(ERR_NOFILE, sys_err_str());  
}

  
/*
 * Send an error packet.
 */
static void send_ERROR(ecode, string)
int ecode;             /* error code, ERR_XXX from tftpdef.h */
char *string;          /* error message */
{
  DEBUG2("sending ERROR, code = %d, string = %s", ecode, string);
  
  stshort(OP_ERROR, sendbuff);
  stshort(ecode, sendbuff+2);

  strcpy(sendbuff+4, string);
  sendlen = 4 + strlen(sendbuff+4) + 1; /* 1 for null-termination */

  net_send(sendbuff, sendlen);
}


/*
 * Copy a string and convert it to lower case
 */
strlccpy(dest, src)
register char *dest, *src;
{
  register char c;

  while ( (c = *src++) != '\0')
  {
    if (isupper(c))
      c = tolower(c);
    *dest++ = c;
  }
  *dest = '\0';
}

#endif /* SERVER */
    
