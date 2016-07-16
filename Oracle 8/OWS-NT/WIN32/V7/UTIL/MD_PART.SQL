REM
REM $Header$
REM

REM Copyright (c) Oracle Corporation Canada Inc. 1992,1994 All Right Reser

REM
REM NAME:
REM    mdpart - MultiDimension PARTtition operations
REM DESCRIPTION:
REM    This package contains routines to manipulate partitions that are part
REM    an Oracle MultiDimension table.
REM PRIVATE FUNCTIONS:
REM PUBLIC FUNCTIONS:
REM    get_partition_name
REM    truncate_partition
REM    drop_partition
REM    move_partition
REM    subdivide_partition
REM    create_inferred_partition
REM    archive_partition
REM    restore_partition
REM
REM NOTES:
REM
REM MODIFIED     (DD-MON-YY)  DESCRIPTION
REM Vretanos      18-SEP-95   Modify CREATE_INFERRED_PARTITION to return
REM                           partition name.
REM Vretanos      21-DEC-94   Rolled in subdivide_partition 
REM                           and create_inferred_partition
REM                           writted by mgalluch
REM Vretanos      01-DEC-94   Creation
REM

create or replace package md_part as

   /*
   --
   --  Package constants denoting the possible partition statuses:
   --  
   --  ONLINE   = partition online and ready for DML operation
   --  OFFLINE  = partition if offline and must be RESTORED before
   --             any DML can occur
   --  NOTEXIST = partition is infered but does not actually exist
   --             must be created before and DML
   --
   */
   ONLINE   CONSTANT integer := mdsys.mdexec.PART_ONLINE;    /* 0 */
   OFFLINE  CONSTANT integer := mdsys.mdexec.PART_OFFLINE;   /* 1 */
   NOTEXIST CONSTANT integer := mdsys.mdexec.PART_NOTEXIST;  /* 2 */

   /*
   --
   --  NAME:
   --     get_partition_name
   --  DESCRITPION:
   --     Given any hhcode and and MD table name, this function will
   --     determine which partition table the hhcode must belonh in and
   --     will also lock the partition and MD3 row in anticipation of a
   --     DML operation.
   --  ARGUMENTS:
   --     sn   - Schema Name
   --     mdtn - MD Table Name
   --     hcc  - HHCode of point of interest
   --     ptn  - Partition Table Name
   --  RETURNS:
   --     MD_PART_ONLINE
   --     MD_PART_OFFLINE
   --     MD_PART_NOTEXIST
   --
   */
   function get_partition_name ( mdtn varchar2, hhc raw, ptn out varchar2 )
                                 return integer;
   function get_partition_name ( sn varchar2, mdtn varchar2, hhc raw,
                                 ptn out varchar2 ) return integer;
   function get_partition_name ( mdtn varchar2, hhc raw, lckf boolean, 
                                 ptn out varchar2 ) return integer;
   function get_partition_name ( sn varchar2, mdtn varchar2, hhc raw,
                                 lckf boolean,ptn out varchar2) return integer;

   /*
   --
   --  NAME:
   --     truncate_partition
   --  DESCRITPION:
   --     Truncate the contents of any MD partition (and updates the MD3).
   --  ARGUMENTS:
   --     sn    - Schema Name
   --     ptn   - Partition Table Name
   --     reuse - REUSE storage (TRUE=reuse, FALSE=not)
   --
   */
   procedure truncate_partition ( ptn varchar2 );
   procedure truncate_partition ( ptn varchar2, reuse boolean );
   procedure truncate_partition ( sn varchar2, ptn varchar2 );
   procedure truncate_partition (sn varchar2,ptn varchar2,reuse boolean);

   /*
   --
   --  NAME:
   --     drop_partition
   --  DESCRIPTION:
   --     Drops a partition from an MD tables.  Intended mostly to
   --     drop empty partitions.
   --  ARGUEMENTS:
   --     sn  - Schema Name
   --     ptn - Partition Table Name
   --  
   */
   procedure drop_partition ( ptn varchar2 );
   procedure drop_partition ( sn varchar2, ptn varchar2 );

   /*
   --
   --  NAME:
   --     move_partition
   --  DESCRIPTION:
   --     Moves an MD partition table from its existing tablespace
   --     to a target tablespace.  It is assumed that the user
   --     has quota on the target.
   --  ARGUEMENTS:
   --     sn   - Schema Name
   --     ptn  - Partition Table Name
   --     tsnm - TableSpace NaMe
   --
   */
   procedure move_partition ( ptn varchar2, tsnm varchar2 );
   procedure move_partition ( sn varchar2, ptn varchar2, tsnm varchar2 );

   /*
   --
   --  NAME:
   --     archive_partition
   --  DESCRIPTION:
   --     Allows users to archive a partition from the server.
   --  ARGUMENTS:
   --     sn  - Schema Name
   --     pn  - Partition Table Name
   --     tmo - Timeout
   --     lp  - listen pipe
   --  NOTES:
   --     The MD*POD daemon must be running to use these functions.
   --     The default listen pipe is MD$MDD.
   */
   procedure archive_partition ( sn varchar2, pn varchar2 );
   procedure archive_partition ( sn varchar2, pn varchar2, tmo integer );
   procedure archive_partition ( sn varchar2, pn varchar2, lp varchar2 );
   procedure archive_partition ( sn varchar2, pn varchar2,
				 lp varchar2, tmo integer );

   /*
   --
   --  NAME:
   --     restore_partition
   --  DESCRIPTION:
   --     Allows users to restore a partition from the server.
   --  ARGUMENTS:
   --     sn  - Schema Name
   --     pn  - Partition Table Name
   --     tmo - Timeout
   --     lp  - listen pipe
   --  NOTES:
   --     The MD*POD daemon must be running to use these functions.
   --     The default listen pipe is MD$MDD.
   */
   procedure restore_partition ( sn varchar2, pn varchar2 );
   procedure restore_partition ( sn varchar2, pn varchar2, tmo integer );
   procedure restore_partition ( sn varchar2, pn varchar2, lp varchar2 );
   procedure restore_partition ( sn varchar2, pn varchar2,
                                 lp varchar2, tmo integer );

   /*
   --
   --  NAME:
   --     subdivide_partition
   --  DESCRIPTION:
   --     Subdivides a parent partition into 2^N child partitions.
   --  ARGUMENTS:
   --     sn  - Schema Name
   --     ptn - Partition Table Name
   --  NOTES:
   --     The parent partition is dropped after the children have
   --     been created.
   */
   procedure subdivide_partition ( sn varchar2, ptn varchar2 );
   procedure subdivide_partition ( ptn varchar2 );

   /*
   --
   --  NAME:
   --     create_inferred_partition
   --  DESCRIPTION:
   --     Given an hhcode value, this function will create a partition
   --     to hold the point.
   --  ARGUMENTS:
   --     sn    - Schema Name
   --     mdtn  - MultiDimension Table Name
   --     hhc   - HHCode value
   --  RETURN:
   --     name of partition created.
   --
   */
   function create_inferred_partition ( sn varchar2, mdtn varchar2, hhc raw )
   return varchar2;
   function create_inferred_partition ( mdtn varchar2, hhc raw )
   return varchar2;

   procedure clear_exception_tables;

end md_part;
/

grant execute on mdsys.md_part to public;
drop public synonym md_part;
create public synonym md_part for mdsys.md_part;
