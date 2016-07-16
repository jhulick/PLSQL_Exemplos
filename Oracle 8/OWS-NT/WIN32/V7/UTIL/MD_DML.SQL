REM
REM $Header$                                                                 *
REM

REM Copyright (c) Oracle Corporation Canada Inc. 1992,1994 All Right Reserved.

REM
REM NAME:
REM    md_dml - MultiDimension DML procedures/functions
REM DESCRIPTION:
REM    This package contains procedures/function required to perform DML
REM    operations on MD tables.
REM PRIVATE FUNCTIONS:
REM PUBLIC FUNCTIONS:
REM    lock_md_table
REM    move_record
REM
REM NOTES:
REM
REM MODIFIED     (DD-MON-YY)  DESCRIPTION
REM Vretanos      29-OCT-94   Creation
REM


create or replace package md_dml as 

   LOCK_WAIT    CONSTANT boolean := TRUE;
   LOCK_NOWAIT  CONSTANT boolean := FALSE;

   /*
   --
   --  NAME:
   --     lock_md_table
   --  DESCRIPTION:
   --     Locks an MD table's partition and all its records in the MD3.
   --  ARGUMENTS:
   --     sn    - Schema Name
   --     mdtn  - MD Table Name
   --     lmode - Lock MODE
   --     wmode - Wait MODE (TRUE = wait, FALSE = no-wait)
   --
   */
   procedure lock_md_table ( mdtn varchar2, lmode varchar2 );
   procedure lock_md_table ( mdtn varchar2, lmode varchar2, wmode boolean );
   procedure lock_md_table ( sn varchar2, mdtn varchar2, lmode varchar2 );
   procedure lock_md_table ( sn varchar2, mdtn varchar2, lmode varchar2,
                                                          wmode boolean );

   /*
   --
   --  NAME:
   --     move_record
   --  DESCRIPTION:
   --     Will update the PK value in a partition table from oldhh to newhh
   --     taking into account the fact that the pk might move.
   --  ARGUMENTS:
   --     sn   - Schema Name
   --     mdtn - MultiDimension Table Name
   --     oldhh - OLD HHcode value
   --     newhh - NEW HHcode value
   --
   */
   procedure move_record ( mdtn varchar2, oldhh raw, newhh raw,
			   nswc varchar2 := null );
   procedure move_record ( sn varchar2, mdtn varchar2, oldhh raw, newhh raw,
			   nswc varchar2 := null );

   /*
   --
   --  NAME:
   --     genhhcode
   --  DESCRIPTION:
   --     This function generates an hhcode using a table definition
   --     from the MD3.
   --  ARGUMENTS:
   --     sn   - Schema Name
   --     mdtn - MultiDimension Table Name
   --     cn   - column name
   --     v01  - value of dimensions 1
   --      .
   --      .
   --     v0N  - value of dimension N
   --
   */
   function genhhcode( sn varchar2, mdtn varchar2, cn varchar2,
                       v01 number := null, v02 number := null,
                       v03 number := null, v04 number := null,
                       v05 number := null, v06 number := null,
                       v07 number := null, v08 number := null,
                       v09 number := null, v10 number := null,
                       v11 number := null, v12 number := null,
                       v13 number := null, v14 number := null,
                       v15 number := null, v16 number := null,
                       v17 number := null, v18 number := null,
                       v19 number := null, v20 number := null,
                       v21 number := null, v22 number := null,
                       v23 number := null, v24 number := null,
                       v25 number := null, v26 number := null,
                       v27 number := null, v28 number := null,
                       v29 number := null, v30 number := null,
                       v31 number := null, v32 number := null) return raw;

   function genhhcode( mdtn varchar2, cn varchar2,
                       v01 number := null, v02 number := null,
                       v03 number := null, v04 number := null,
                       v05 number := null, v06 number := null,
                       v07 number := null, v08 number := null,
                       v09 number := null, v10 number := null,
                       v11 number := null, v12 number := null,
                       v13 number := null, v14 number := null,
                       v15 number := null, v16 number := null,
                       v17 number := null, v18 number := null,
                       v19 number := null, v20 number := null,
                       v21 number := null, v22 number := null,
                       v23 number := null, v24 number := null,
                       v25 number := null, v26 number := null,
                       v27 number := null, v28 number := null,
                       v29 number := null, v30 number := null,
                       v31 number := null, v32 number := null) return raw;

   function genhhcode( mdtn varchar2,
                       v01 number := null, v02 number := null,
                       v03 number := null, v04 number := null,
                       v05 number := null, v06 number := null,
                       v07 number := null, v08 number := null,
                       v09 number := null, v10 number := null,
                       v11 number := null, v12 number := null,
                       v13 number := null, v14 number := null,
                       v15 number := null, v16 number := null,
                       v17 number := null, v18 number := null,
                       v19 number := null, v20 number := null,
                       v21 number := null, v22 number := null,
                       v23 number := null, v24 number := null,
                       v25 number := null, v26 number := null,
                       v27 number := null, v28 number := null,
                       v29 number := null, v30 number := null,
                       v31 number := null, v32 number := null) return raw;

end md_dml;
/

grant execute on mdsys.md_dml to public;
drop public synonym md_dml;
create public synonym md_dml for mdsys.md_dml;
