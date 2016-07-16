/*
  $Header: /netrcs/RCS/oracle/network/tns/tnsapi/RCS/fsm.c,v 1.4 1995/09/13 06:46:27 yzheng Exp $
*/


/*
 * Finite State Machines
 */
#include "tftpdef.h"

#ifdef CLIENT
int recv_ACK(), recv_DATA(), recv_RQERR();
#endif

#ifdef SERVER
int recv_RRQ(), recv_WRQ(), recv_ACK(), recv_DATA(), recv_DISRQ();
#endif

int fsm_error(), fsm_invalid();

/*
 * Finite state machine table
 * This is a 2-d array indexed by the last opcode sent and the opcode
 * just received. The result is the address of a function to call to
 * process the received opcode.
 */

int (*fsm_ptr [OP_MAX+1][OP_MAX+1] ) () = 
{
#ifdef CLIENT
  fsm_invalid,   /*  [sent = 0]             [recv = 0]                  */
  fsm_invalid,   /*  [sent = 0]             [recv = OP_RRQ]             */
  fsm_invalid,   /*  [sent = 0]             [recv = OP_WRQ]             */
  fsm_invalid,   /*  [sent = 0]             [recv = OP_DATA]            */
  fsm_invalid,   /*  [sent = 0]             [recv = OP_ACK]             */
  fsm_invalid,   /*  [sent = 0]             [recv = OP_ERROR]           */

  fsm_invalid,   /*  [sent = OP_RRQ]        [recv = 0]           */
  fsm_invalid,   /*  [sent = OP_RRQ]        [recv = OP_RRQ]      */
  fsm_invalid,   /*  [sent = OP_RRQ]        [recv = OP_WRQ]      */
recv_DATA,       /*  [sent = OP_RRQ]        [recv = OP_DATA]     */
  fsm_invalid,   /*  [sent = OP_RRQ]        [recv = OP_ACK]      */
recv_RQERR,      /*  [sent = OP_RRQ]        [recv = OP_ERROR]    */

  fsm_invalid,   /*  [sent = OP_WRQ]        [recv = 0 ]     */
  fsm_invalid,   /*  [sent = OP_WRQ]        [recv = OP_RRQ]     */
  fsm_invalid,   /*  [sent = OP_WRQ]        [recv = OP_WRQ]     */
  fsm_invalid,   /*  [sent = OP_WRQ]        [recv = OP_DATA]     */
recv_ACK,        /*  [sent = OP_WRQ]        [recv = OP_ACK]     */
recv_RQERR,   /*  [sent = OP_WRQ]        [recv = OP_ERROR]     */

  fsm_invalid,   /*  [sent = OP_DATA]        [recv = 0]     */
  fsm_invalid,   /*  [sent = OP_DATA]        [recv = OP_RRQ]     */
  fsm_invalid,   /*  [sent = OP_DATA]        [recv = OP_WRQ]     */
  fsm_invalid,   /*  [sent = OP_DATA]        [recv = OP_DATA]     */
recv_ACK,   /*  [sent = OP_DATA]        [recv = OP_ACK]     */
  fsm_error,   /*  [sent = OP_DATA]        [recv = OP_ERROR]     */

  fsm_invalid,   /*  [sent = OP_ACK]        [recv = 0]     */
  fsm_invalid,   /*  [sent = OP_ACK]        [recv = OP_RRQ]     */
  fsm_invalid,   /*  [sent = OP_ACK]        [recv = OP_WRQ]     */
recv_DATA,       /*  [sent = OP_ACK]        [recv = OP_DATA]     */
  fsm_invalid,   /*  [sent = OP_ACK]        [recv = OP_ACK]     */
  fsm_error,   /*  [sent = OP_ACK]        [recv = OP_ERROR]     */

  fsm_invalid,   /*  [sent = OP_ERROR]        [recv = 0]     */
  fsm_invalid,   /*  [sent = OP_ERROR]        [recv = OP_RRQ]     */
  fsm_invalid,   /*  [sent = OP_ERROR]        [recv = OP_WRQ]     */
  fsm_invalid,   /*  [sent = OP_ERROR]        [recv = OP_DATA]     */
  fsm_invalid,   /*  [sent = OP_ERROR]        [recv = OP_ACK]     */
  fsm_error   /*  [sent = OP_ERROR]        [recv = OP_ERROR]     */
#endif /* CLIENT */

#ifdef SERVER
  fsm_invalid,   /*  [sent = 0]        [recv = 0]     */
recv_RRQ,        /*  [sent = 0]        [recv = OP_RRQ]     */
recv_WRQ,        /*  [sent = 0]        [recv = OP_WRQ]     */
  fsm_invalid,   /*  [sent = 0]        [recv = OP_DATA]     */
  fsm_invalid,   /*  [sent = 0]        [recv = OP_ACK]     */
  fsm_invalid,   /*  [sent = 0]        [recv = OP_ERROR]     */

  fsm_invalid,   /*  [sent = OP_RRQ]        [recv = 0]     */
  fsm_invalid,   /*  [sent = OP_RRQ]        [recv = OP_RRQ]     */
  fsm_invalid,   /*  [sent = OP_RRQ]        [recv = OP_WRQ]     */
  fsm_invalid,   /*  [sent = OP_RRQ]        [recv = OP_DATA]     */
  fsm_invalid,   /*  [sent = OP_RRQ]        [recv = OP_ACK]     */
  fsm_invalid,   /*  [sent = OP_RRQ]        [recv = OP_ERROR]     */

  fsm_invalid,   /*  [sent = OP_WRQ]        [recv = 0]     */
  fsm_invalid,   /*  [sent = OP_WRQ]        [recv = OP_RRQ]     */
  fsm_invalid,   /*  [sent = OP_WRQ]        [recv = OP_WRQ]     */
  fsm_invalid,   /*  [sent = OP_WRQ]        [recv = OP_DATA]     */
  fsm_invalid,   /*  [sent = OP_WRQ]        [recv = OP_ACK]     */
  fsm_invalid,   /*  [sent = OP_WRQ]        [recv = OP_ERROR]     */

  fsm_invalid,   /*  [sent = OP_DATA]       [recv = 0]     */
  fsm_invalid,   /*  [sent = OP_DATA]       [recv = OP_RRQ]     */
  fsm_invalid,   /*  [sent = OP_DATA]       [recv = OP_WRQ]     */
  fsm_invalid,   /*  [sent = OP_DATA]       [recv = OP_DATA]     */
recv_ACK,        /*  [sent = OP_DATA]       [recv = OP_ACK]     */
  fsm_error,     /*  [sent = OP_DATA]       [recv = OP_ERROR]     */
 
  fsm_invalid,   /*  [sent = OP_ACK]       [recv = 0]     */    
  fsm_invalid,   /*  [sent = OP_ACK]       [recv = OP_RRQ]     */    
  fsm_invalid,   /*  [sent = OP_ACK]       [recv = OP_WRQ]     */    
recv_DATA,       /*  [sent = OP_ACK]       [recv = OP_DATA]     */    
  fsm_invalid,   /*  [sent = OP_ACK]       [recv = OP_ACK]     */    
  fsm_error,   /*  [sent = OP_ACK]       [recv = OP_ERROR]     */    

  fsm_invalid,   /*  [sent = OP_ERROR]       [recv = 0]     */    
  fsm_invalid,   /*  [sent = OP_ERROR]       [recv = OP_RRQ]     */    
  fsm_invalid,   /*  [sent = OP_ERROR]       [recv = OP_WRQ]     */    
  fsm_invalid,   /*  [sent = OP_ERROR]       [recv = OP_DATA]     */    
  fsm_invalid,   /*  [sent = OP_ERROR]       [recv = OP_ACK]     */    
  fsm_invalid   /*  [sent = OP_ERROR]       [recv = OP_ERROR]     */    
#endif /* SERVER */
};
    

/*
 * Main loop of finite state machine
 *
 * For the client, we are called after either a RRQ or a WRQ has been sent
 * to the other side.
 *
 * For the server, we are called after either a RRQ or a WRQ has been 
 * received from the other side. In this case, the argument will be a 0
 * (since nothing has been sent ) but the state table above handles this
 */

int fsm_loop(opcode)
int opcode;
{
  register int nbytes;

  op_sent = opcode;

  for (;;)
  {
    if ((nbytes = net_recv(recvbuff, MAXBUFF)) < 0)
      err_dump("net_recv error");

    /*
     * The shortest packet is the disconnect packet, only has two bytes
     */
    if (nbytes < 2)
      err_dump("receive length = %d bytes", nbytes);
    op_recv = ldshort(recvbuff);
    if (op_recv < OP_MIN || op_recv > OP_MAX)
    {
#ifdef SERVER
      if (op_recv == OP_DISCONNECT)
      {
        /* disconnect and exit */
        tnsclose(&svrtnshdl);
        exit(0);
      }
      else
#endif
        err_dump("invalid opcode received: %d", op_recv);
    }

    /*
     * we call the appropriate function, passing the address of the receive
     * buffer and its length. These arguments ignore the received-opcode, 
     * which we have already processed
     * we assume that the called function will send a response to the
     * other side. It is the called function's responsibility to 
     * set op_sent to the op-code that it sends to the other side
     */

    if ((*fsm_ptr[op_sent][op_recv])(recvbuff +2, nbytes -2) < 0)
    {
      /*
       * when the called function return -1, this loop is done.
       * e.g., RRQ or WRQ failed
       */
#ifndef WIN32
      signal(SIGALRM, SIG_DFL);
#endif
      return(0);
    }
  }
}

int fsm_error(ptr, nbytes)
char *ptr;
int nbytes;
{
  err_dump("error received: op_sent = %d, op_recv = %d", op_sent, op_recv);
}

int fsm_invalid(ptr, nbytes)
char *ptr;
int nbytes;
{
  err_dump("protocol error: op_sent = %d, op_recv = %d", op_sent, op_recv);
}

