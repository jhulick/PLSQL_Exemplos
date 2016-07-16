
REM $Header$
REM

REM Copyright (c) Oracle Corporation Canada Inc. 1992,1994 All Right Reserved.

REM
REM NAME:
REM    mdd - MultiDimension partition operation Daemon
REM DESCRIPTION:
REM     PL/SQL functions/procedures used by the MD*POD executable
REM     to read messages from the listen pipe and send messages
REM     down the reply pipe.
REM PUBLIC FUNCTIONS:
REM    getrequest
REM    sendreply
REM NOTES:
REM MODIFIED     (DD-MON-YY)  DESCRIPTION
REM Vretanos      22-NOV-94   Creation
REM

create or replace package mdd as

   procedure terminate;
   procedure terminate( lp varchar2 );

   procedure initialize;
   procedure initialize( lp varchar2 );


   -- --------------------------------------------------------------------- --
   --  PRIVATE FUNCTIONS - DO NOT EXECUTE                                   --
   -- --------------------------------------------------------------------- --

   /*
   --
   --  NAME:
   --     getrequest
   --  DESCRIPTION:
   --     Reads and unpacks a request from the listen pipe. 
   --  ARGUMENTS:
   --     lp  - Listen Pipe
   --     cid - Command ID
   --     un  - User Name output buffer
   --     pn  - Partition Name output buffer
   --     rp  - Reply Pipe output buffer
   --  RETURNS:
   --     0 - Success
   --     1 - Timed out (either because can't get lock on pipe or pipe stays 
   --         too full)
   --     2 - Record in pipe too big for buffer (should not happen).
   --     3 - Interrupted
   --
   */
   function getrequest ( lp varchar2, cid out integer,
                                      un  out varchar2,
                                      pn  out varchar2,
                                      rp  out varchar2) return integer;

   /*
   --
   --  NAME:
   --     sendreply
   --  DESCRIPTION:
   --     Send a SUCCESS or FAILURE message down the specififed pipe
   --  ARGUMENTS:
   --     pipe - reply PIPE
   --     succ - SUCCess flag (TRUE = success, FALSE = failure)
   --  
   */
   procedure sendreply( pipe varchar2, succ boolean );

   /*
   --
   --  NAME:
   --     sendack
   --  DESCRIPTION:
   --     Send an acknowledgement. 
   --  ARGUMENTS:
   --     pipe - reply PIPE
   --     succ - SUCCess flag (TRUE = success, FALSE = failure)
   --  
   */
   procedure sendack( rp varchar2 );


end mdd;
/
