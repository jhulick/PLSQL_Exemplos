/*
  $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/nettns.c,v 1.3 1995/09/12 21:52:50 yzheng Exp $
*/

#include "tftpdef.h"

extern int traceflag;   

/*
 * Send a record to the other side. Used by both client and server.
 * With a stream interface, we have to preface each record with its
 * length, since TFTP does not have arecord length as part of each
 * record. We encode the length as a 2-byte interger in network
 * byte order
 */

void net_send(buff, len)
char *buff;
int len;
{
  void *tnshdl;
  short recordlen;
  size_t sizeshort = sizeof(short);

  DEBUG1("net_send: sent %d bytes", len);
 
#ifdef SERVER
  tnshdl = svrtnshdl;
#endif

#ifdef CLIENT
  tnshdl = clitnshdl;
#endif

  recordlen = htons(len);
  if (tnssend(tnshdl, (char *)&recordlen, &sizeshort) != 0)
    err_dump("written error of length prefix");

  if (tnssend(tnshdl, buff, &len) != 0)
    err_dump("write error");

}

/*
 * receive a record from the other end
 */
int net_recv(buff, maxlen)
char *buff;
int maxlen;
{
  void *tnshdl=0;
  register int nbytes;
  short recordlen = sizeof(short);
  size_t sizeshort = sizeof(short);
  size_t datalen = maxlen;

#ifdef SERVER
  tnshdl = svrtnshdl;
#endif

#ifdef CLIENT
  tnshdl = clitnshdl;
#endif

 again1:
  if (tnsrecv(tnshdl, &recordlen, &sizeshort) != 0)
  {
    /*
     * Do we handle ctrl-C, not now!
     */
    err_dump("tnsrecv failed in reading record length");
  }
  
  if (sizeshort != sizeof(short))
  {
    err_dump("tnsrecv read error, reading unexpected bytes");
  }

  recordlen = ntohs(recordlen);
  if (recordlen > maxlen)
    err_dump("record length too large");

  if (tnsrecv(tnshdl, buff, &datalen) != 0)
    err_dump("tnsrecv failed in reading record data");   

  if (datalen != recordlen)
    err_dump("tnsrecv read data failed, unexpected bytes");
 
  DEBUG1("net_recv: got %d bytes", datalen);
  return(datalen);
}
