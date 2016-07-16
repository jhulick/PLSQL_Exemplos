/*
  $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/filep.c,v 1.3 1995/09/13 06:52:58 yzheng Exp $
*/

/*
 * Routines to open/close/read/write local file
 * For binary transmission, we use the UNIX open/read/write system calls
 * For ascii transmission, we use the UNIX standard i/o routine 
 * fopen/getc/putc
 */

#ifndef TFTPDEF
# include "tftpdef.h"
#endif

static int lastcr = 0;  /* 1 if last char was a carriage-return */
static int nextchar = 0;
 
FILE *file_open(fname, mode, initblknum)
char *fname;
char *mode;
int initblknum;
{
  register FILE *fp;

  if (strcmp(fname, "-") == 0)
    fp  = stdout;
  else if ((fp = fopen(fname, mode)) == NULL)
           return ((FILE *)0);

  nextblknum = initblknum;  /* for first data or ACK packet */
  lastcr  = 0;              /* for file_write()             */
  nextchar = -1;            /* for file_read()              */

  DEBUG2("file_open: opened %s, mode = %s", fname, mode);
  return(fp);
}

void file_close(fp)
FILE *fp;
{
  if (lastcr)
    err_dump("final character was a CR");
  if (nextchar >= 0)
    err_dump("nextchar >= 0");

  if (fp  == stdout)
    return;
  else if (fclose(fp) == EOF)
    err_dump("fclose error");
}


/*
 * Read data from local file.
 * Here we handle any conversion between the file's mode on the local system
 * and the network mode
 *
 * Return the number of bytes read (between 1 and maxnbytes, inclusive) 
 * or 0 on EOF
 */
int file_read(fp, ptr, maxnbytes, mode)
FILE *fp;
char *ptr;
int maxnbytes;
int mode;
{
  register int c, count;

  if (mode == MODE_BINARY) {
#ifndef WIN32
    count = read(fileno(fp), ptr, maxnbytes);
#else
    count = _read(fileno(fp), ptr, maxnbytes);
#endif
    if (count < 0)
      err_dump("read error from local file");
    return (count);
  }
  else if (mode == MODE_ASCII)
  {
    /*
     * For files that are transferred in netascii, we must perform the reverse
     * conversions that file_write() does. Note that we have to use the
     * global "nextchar" to remember if the next character to output is a 
     * linefeed or a null, since the second byte of a 2-byte sequence may not 
     * fit in the current buffer, and may have to go as the first byte of 
     * the next buffer (i.e., we have to remember this fact from one call
     * to the next)
     */
    for (count = 0; count < maxnbytes; count++)
    {
      if (nextchar >=0 )
      {
        *ptr++ = nextchar;
        nextchar = -1; 
        continue;
      }
      c = getc(fp);

      if (c == EOF) /* EOF return means eof or error */
      {
        if (ferror(fp))
          err_dump("read error from getc on local file");
        return(count);
      }
      else if (c == '\n')
      {
        c = '\r';        /* newline -> CR, LF */
        nextchar = '\n';
      }
      else if (c == '\r')
      {
        nextchar = '\0';         /* CR -> CR, NULL */
      }
      else
        nextchar = -1;
      
      *ptr++ = c;
    }
    return(count);
  }
  else 
    err_dump("unknown Mode value");
}


/*
 * Write data to the local file.
 * Here we handle any conversion between the mode of the file on the network
 * and the local system's conversion.
 */
void file_write(fp, ptr, nbytes, mode)
FILE *fp;
char *ptr;
int nbytes;
int mode;
{
  register int c, i;

  if (mode == MODE_BINARY)
  {
#ifndef WIN32
    i = write(fileno(fp), ptr, nbytes);
#else
    i = _write(fileno(fp), ptr, nbytes);
#endif
    if (i != nbytes)
      err_dump("write error to local file, i = %d", i);

  }
  else if (mode == MODE_ASCII)
  {
    /*
     * For files that are transferred in netascii, we must perform the 
     * following conversion
     * CR, LF   -> newline = '\n'
     * CR, NULL -> CR      = '\r'
     * CR, anything else -> undefined
     *
     * Note that we have to use the global "lastcr" to remember if the last
     * character was a CR, LF or not, since if the last character of a buffer
     * is a CR, we have to remember that when we are called for the next 
     * buffer.
     */

    for (i = 0; i < nbytes; i++)
    {
      c = *ptr++;
      if (lastcr)
      {
        if (c == '\n')
          c = '\n';
        else if ( c == '\0')
          c = '\r';
        else 
          err_dump("CR followed by 0x%02x", c);
        lastcr = 0;
      }
      else if ( c == '\r')
      {
        lastcr = 1;
        continue;      /* get next char */
      }
      if (putc(c, fp) == EOF)
        err_dump("write error to local file");
    }
  }
  else
    err_dump("Unknown MODE value");
}
