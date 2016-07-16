REM
REM $Header$
REM

REM Copyright (c) Oracle Corporation Canada Inc. 1992,1994 All Right Reserved.


REM
REM NAME:
REM    md_ddl - MultiDimension DDL
REM DESCRIPTION:
REM    DDL operations on MultiDimension tables.
REM PUBLIC FUNCTIONS:
REM    register_md_table
REM    add_hhcode_column
REM    drop_md_table
REM    alter_md_table_hwm
REM    alter_md_table_olp
REM    allocate_tablespace
REM    activate_tablespace
REM    deactivate_tablespace
REM NOTES:
REM MODIFIED     (DD-MON-YY)  DESCRIPTION
REM Vretanos      22-NOV-94   Creation
REM
 

create or replace package md_ddl as

   /*
   --
   --  NAME:
   --     register_md_table
   --  DESCRIPTION:
   --     Registers a pre-created Oracle table as an MD table in the MD3.
   --  ARGUMENTS:
   --     sn   - Schema Name
   --     mdtn - MultiDimension Table Name
   --     hwmk - HighWater MarK
   --     op   - Offline Path
   --  NOTES:
   --     The table to be registered must be pre-created WITHOUT any
   --     hhcode columns specififed.  
   */
   procedure register_md_table ( mdtn varchar2 );
   procedure register_md_table ( mdtn varchar2, hwmk number );
   procedure register_md_table ( mdtn varchar2, hwmk number, op varchar2 );
   procedure register_md_table ( mdtn varchar2, hwmk number, op varchar2,
				 stat varchar2 );
   procedure register_md_table ( sn varchar2, mdtn varchar2 );
   procedure register_md_table ( sn varchar2, mdtn varchar2, hwmk number );
   procedure register_md_table ( sn varchar2, mdtn varchar2, hwmk number,
                                                             op varchar2 );
   procedure register_md_table ( sn varchar2, mdtn varchar2, hwmk number,
                                              op varchar2, stat varchar2 );

   /*
   --
   --  NAME:
   --     add_hhcode_column
   --  DESCRIPTION:
   --     Adds a column on type HHCODE to the specified MultiDimension Table.
   --  ARGUMENTS:
   --     sn   - Schema Name
   --     mdtn - MultiDimension Name
   --     cn   - Column Name
   --     pk   - is Partition Key
   --     dN   - name of Dimension N
   --     lN   - Lower boundary for dimension N
   --     uN   - Upper boundary for dimension N
   --     pN   - Precision of dimension N
   --
   */
   procedure add_hhcode_column
   ( mdtn varchar2, cn varchar2, pk boolean, nn boolean,
     d01 varchar2:=null,l01 number:=null,u01 number:=null,p01 number:= null,
     d02 varchar2:=null,l02 number:=null,u02 number:=null,p02 number:= null,
     d03 varchar2:=null,l03 number:=null,u03 number:=null,p03 number:= null,
     d04 varchar2:=null,l04 number:=null,u04 number:=null,p04 number:= null,
     d05 varchar2:=null,l05 number:=null,u05 number:=null,p05 number:= null,
     d06 varchar2:=null,l06 number:=null,u06 number:=null,p06 number:= null,
     d07 varchar2:=null,l07 number:=null,u07 number:=null,p07 number:= null,
     d08 varchar2:=null,l08 number:=null,u08 number:=null,p08 number:= null,
     d09 varchar2:=null,l09 number:=null,u09 number:=null,p09 number:= null,
     d10 varchar2:=null,l10 number:=null,u10 number:=null,p10 number:= null,
     d11 varchar2:=null,l11 number:=null,u11 number:=null,p11 number:= null,
     d12 varchar2:=null,l12 number:=null,u12 number:=null,p12 number:= null,
     d13 varchar2:=null,l13 number:=null,u13 number:=null,p13 number:= null,
     d14 varchar2:=null,l14 number:=null,u14 number:=null,p14 number:= null,
     d15 varchar2:=null,l15 number:=null,u15 number:=null,p15 number:= null,
     d16 varchar2:=null,l16 number:=null,u16 number:=null,p16 number:= null,
     d17 varchar2:=null,l17 number:=null,u17 number:=null,p17 number:= null,
     d18 varchar2:=null,l18 number:=null,u18 number:=null,p18 number:= null,
     d19 varchar2:=null,l19 number:=null,u19 number:=null,p19 number:= null,
     d20 varchar2:=null,l20 number:=null,u20 number:=null,p20 number:= null,
     d21 varchar2:=null,l21 number:=null,u21 number:=null,p21 number:= null,
     d22 varchar2:=null,l22 number:=null,u22 number:=null,p22 number:= null,
     d23 varchar2:=null,l23 number:=null,u23 number:=null,p23 number:= null,
     d24 varchar2:=null,l24 number:=null,u24 number:=null,p24 number:= null,
     d25 varchar2:=null,l25 number:=null,u25 number:=null,p25 number:= null,
     d26 varchar2:=null,l26 number:=null,u26 number:=null,p26 number:= null,
     d27 varchar2:=null,l27 number:=null,u27 number:=null,p27 number:= null,
     d28 varchar2:=null,l28 number:=null,u28 number:=null,p28 number:= null,
     d29 varchar2:=null,l29 number:=null,u29 number:=null,p29 number:= null,
     d30 varchar2:=null,l30 number:=null,u30 number:=null,p30 number:= null,
     d31 varchar2:=null,l31 number:=null,u31 number:=null,p31 number:= null,
     d32 varchar2:=null,l32 number:=null,u32 number:=null,p32 number:= null);

   procedure add_hhcode_column
   ( sn varchar2, mdtn varchar2, cn varchar2, pk boolean, nn boolean,
     d01 varchar2:=null,l01 number:=null,u01 number:=null,p01 number:= null,
     d02 varchar2:=null,l02 number:=null,u02 number:=null,p02 number:= null,
     d03 varchar2:=null,l03 number:=null,u03 number:=null,p03 number:= null,
     d04 varchar2:=null,l04 number:=null,u04 number:=null,p04 number:= null,
     d05 varchar2:=null,l05 number:=null,u05 number:=null,p05 number:= null,
     d06 varchar2:=null,l06 number:=null,u06 number:=null,p06 number:= null,
     d07 varchar2:=null,l07 number:=null,u07 number:=null,p07 number:= null,
     d08 varchar2:=null,l08 number:=null,u08 number:=null,p08 number:= null,
     d09 varchar2:=null,l09 number:=null,u09 number:=null,p09 number:= null,
     d10 varchar2:=null,l10 number:=null,u10 number:=null,p10 number:= null,
     d11 varchar2:=null,l11 number:=null,u11 number:=null,p11 number:= null,
     d12 varchar2:=null,l12 number:=null,u12 number:=null,p12 number:= null,
     d13 varchar2:=null,l13 number:=null,u13 number:=null,p13 number:= null,
     d14 varchar2:=null,l14 number:=null,u14 number:=null,p14 number:= null,
     d15 varchar2:=null,l15 number:=null,u15 number:=null,p15 number:= null,
     d16 varchar2:=null,l16 number:=null,u16 number:=null,p16 number:= null,
     d17 varchar2:=null,l17 number:=null,u17 number:=null,p17 number:= null,
     d18 varchar2:=null,l18 number:=null,u18 number:=null,p18 number:= null,
     d19 varchar2:=null,l19 number:=null,u19 number:=null,p19 number:= null,
     d20 varchar2:=null,l20 number:=null,u20 number:=null,p20 number:= null,
     d21 varchar2:=null,l21 number:=null,u21 number:=null,p21 number:= null,
     d22 varchar2:=null,l22 number:=null,u22 number:=null,p22 number:= null,
     d23 varchar2:=null,l23 number:=null,u23 number:=null,p23 number:= null,
     d24 varchar2:=null,l24 number:=null,u24 number:=null,p24 number:= null,
     d25 varchar2:=null,l25 number:=null,u25 number:=null,p25 number:= null,
     d26 varchar2:=null,l26 number:=null,u26 number:=null,p26 number:= null,
     d27 varchar2:=null,l27 number:=null,u27 number:=null,p27 number:= null,
     d28 varchar2:=null,l28 number:=null,u28 number:=null,p28 number:= null,
     d29 varchar2:=null,l29 number:=null,u29 number:=null,p29 number:= null,
     d30 varchar2:=null,l30 number:=null,u30 number:=null,p30 number:= null,
     d31 varchar2:=null,l31 number:=null,u31 number:=null,p31 number:= null,
     d32 varchar2:=null,l32 number:=null,u32 number:=null,p32 number:= null);

   procedure add_hhcode_column
   ( mdtn varchar2, cn varchar2, pk boolean, 
     d01 varchar2:=null,l01 number:=null,u01 number:=null,p01 number:= null,
     d02 varchar2:=null,l02 number:=null,u02 number:=null,p02 number:= null,
     d03 varchar2:=null,l03 number:=null,u03 number:=null,p03 number:= null,
     d04 varchar2:=null,l04 number:=null,u04 number:=null,p04 number:= null,
     d05 varchar2:=null,l05 number:=null,u05 number:=null,p05 number:= null,
     d06 varchar2:=null,l06 number:=null,u06 number:=null,p06 number:= null,
     d07 varchar2:=null,l07 number:=null,u07 number:=null,p07 number:= null,
     d08 varchar2:=null,l08 number:=null,u08 number:=null,p08 number:= null,
     d09 varchar2:=null,l09 number:=null,u09 number:=null,p09 number:= null,
     d10 varchar2:=null,l10 number:=null,u10 number:=null,p10 number:= null,
     d11 varchar2:=null,l11 number:=null,u11 number:=null,p11 number:= null,
     d12 varchar2:=null,l12 number:=null,u12 number:=null,p12 number:= null,
     d13 varchar2:=null,l13 number:=null,u13 number:=null,p13 number:= null,
     d14 varchar2:=null,l14 number:=null,u14 number:=null,p14 number:= null,
     d15 varchar2:=null,l15 number:=null,u15 number:=null,p15 number:= null,
     d16 varchar2:=null,l16 number:=null,u16 number:=null,p16 number:= null,
     d17 varchar2:=null,l17 number:=null,u17 number:=null,p17 number:= null,
     d18 varchar2:=null,l18 number:=null,u18 number:=null,p18 number:= null,
     d19 varchar2:=null,l19 number:=null,u19 number:=null,p19 number:= null,
     d20 varchar2:=null,l20 number:=null,u20 number:=null,p20 number:= null,
     d21 varchar2:=null,l21 number:=null,u21 number:=null,p21 number:= null,
     d22 varchar2:=null,l22 number:=null,u22 number:=null,p22 number:= null,
     d23 varchar2:=null,l23 number:=null,u23 number:=null,p23 number:= null,
     d24 varchar2:=null,l24 number:=null,u24 number:=null,p24 number:= null,
     d25 varchar2:=null,l25 number:=null,u25 number:=null,p25 number:= null,
     d26 varchar2:=null,l26 number:=null,u26 number:=null,p26 number:= null,
     d27 varchar2:=null,l27 number:=null,u27 number:=null,p27 number:= null,
     d28 varchar2:=null,l28 number:=null,u28 number:=null,p28 number:= null,
     d29 varchar2:=null,l29 number:=null,u29 number:=null,p29 number:= null,
     d30 varchar2:=null,l30 number:=null,u30 number:=null,p30 number:= null,
     d31 varchar2:=null,l31 number:=null,u31 number:=null,p31 number:= null,
     d32 varchar2:=null,l32 number:=null,u32 number:=null,p32 number:= null);

   procedure add_hhcode_column
   ( sn varchar2, mdtn varchar2, cn varchar2, pk boolean, 
     d01 varchar2:=null,l01 number:=null,u01 number:=null,p01 number:= null,
     d02 varchar2:=null,l02 number:=null,u02 number:=null,p02 number:= null,
     d03 varchar2:=null,l03 number:=null,u03 number:=null,p03 number:= null,
     d04 varchar2:=null,l04 number:=null,u04 number:=null,p04 number:= null,
     d05 varchar2:=null,l05 number:=null,u05 number:=null,p05 number:= null,
     d06 varchar2:=null,l06 number:=null,u06 number:=null,p06 number:= null,
     d07 varchar2:=null,l07 number:=null,u07 number:=null,p07 number:= null,
     d08 varchar2:=null,l08 number:=null,u08 number:=null,p08 number:= null,
     d09 varchar2:=null,l09 number:=null,u09 number:=null,p09 number:= null,
     d10 varchar2:=null,l10 number:=null,u10 number:=null,p10 number:= null,
     d11 varchar2:=null,l11 number:=null,u11 number:=null,p11 number:= null,
     d12 varchar2:=null,l12 number:=null,u12 number:=null,p12 number:= null,
     d13 varchar2:=null,l13 number:=null,u13 number:=null,p13 number:= null,
     d14 varchar2:=null,l14 number:=null,u14 number:=null,p14 number:= null,
     d15 varchar2:=null,l15 number:=null,u15 number:=null,p15 number:= null,
     d16 varchar2:=null,l16 number:=null,u16 number:=null,p16 number:= null,
     d17 varchar2:=null,l17 number:=null,u17 number:=null,p17 number:= null,
     d18 varchar2:=null,l18 number:=null,u18 number:=null,p18 number:= null,
     d19 varchar2:=null,l19 number:=null,u19 number:=null,p19 number:= null,
     d20 varchar2:=null,l20 number:=null,u20 number:=null,p20 number:= null,
     d21 varchar2:=null,l21 number:=null,u21 number:=null,p21 number:= null,
     d22 varchar2:=null,l22 number:=null,u22 number:=null,p22 number:= null,
     d23 varchar2:=null,l23 number:=null,u23 number:=null,p23 number:= null,
     d24 varchar2:=null,l24 number:=null,u24 number:=null,p24 number:= null,
     d25 varchar2:=null,l25 number:=null,u25 number:=null,p25 number:= null,
     d26 varchar2:=null,l26 number:=null,u26 number:=null,p26 number:= null,
     d27 varchar2:=null,l27 number:=null,u27 number:=null,p27 number:= null,
     d28 varchar2:=null,l28 number:=null,u28 number:=null,p28 number:= null,
     d29 varchar2:=null,l29 number:=null,u29 number:=null,p29 number:= null,
     d30 varchar2:=null,l30 number:=null,u30 number:=null,p30 number:= null,
     d31 varchar2:=null,l31 number:=null,u31 number:=null,p31 number:= null,
     d32 varchar2:=null,l32 number:=null,u32 number:=null,p32 number:= null);

   /*
   --
   --  NAME:
   --     drop_md_table
   --  DESCRIPTION:
   --     Drops a MultiDimension Table.
   --  ARGUMENTS:
   --     sn   - Schema Name
   --     mdtn - MultiDimension Table Name
   --  NOTE:
   --     If the MD table is partitioned, then drop_md_table drops all 
   --     partitions that are online.  It is the user's responsibility to 
   --     delete offline partitions.
   --
   */
   procedure drop_md_table ( mdtn varchar2 );
   procedure drop_md_table ( sn varchar2, mdtn varchar2 );

   /*
   --
   --  NAME:
   --     alter_md_table
   --  DESCRIPTION:
   --     Alters the HWM of a partitioned MD table.
   --  ARGUMENTS:
   --     sn   - Schema Name
   --     mdtn - MultiDimension Table Name
   --     hwm  - HighWater Mark
   -- 
   */
   procedure alter_md_table ( mdtn     varchar2,
                              template varchar2,
                              oec      boolean := TRUE );
   procedure alter_md_table ( sn       varchar2,
                              mdtn     varchar2,
                              template varchar2,
                              oec      boolean := TRUE );

   /*
   --
   --  NAME:
   --     alter_md_table_hwm
   --  DESCRIPTION:
   --     Alters the HWM of a partitioned MD table.
   --  ARGUMENTS:
   --     sn   - Schema Name
   --     mdtn - MultiDimension Table Name
   --     hwm  - HighWater Mark
   -- 
   */
   procedure alter_md_table_hwm ( mdtn varchar2, hwm number );
   procedure alter_md_table_hwm ( sn varchar2, mdtn varchar2, hwm number );

   /*
   --
   --  NAME:
   --     alter_md_table_olp
   --  DESCRIPTION:
   --     Alters the offline path of a partitioned MD table.
   --  ARGUMENTS:
   --     sn   - Schema Name
   --     mdtn - MultiDimension Table Name
   --     oflp - HighWater Mark
   --
   */
   procedure alter_md_table_olp ( mdtn varchar2, oflp varchar2 );
   procedure alter_md_table_olp ( sn varchar2, mdtn varchar2, oflp varchar2 );

   /*
   --
   --  NAME:
   --     alter_md_table_cm
   --  DESCRIPTION:
   --     Alters the count mode of a partitioned MD table.
   --  ARGUMENTS:
   --     sn   - Schema Name
   --     mdtn - MultiDimension Table Name
   --     cm   - Count Mode
   --
   */
   procedure alter_md_table_cm ( mdtn varchar2, cm varchar2 );
   procedure alter_md_table_cm ( sn varchar2, mdtn varchar2, cm varchar2 );

   /*
   --
   --  NAME:
   --     allocate_tablespace
   --  DESCRIPTION:
   --     Allocates a tablespace to a partitioned MD table where 
   --     partitions can be created.  This is allows users to 
   --     spread the partitions over a number of tablespaces and 
   --     thus balance I/O.  The function does not actually create 
   --     the tablespace - it must already be part of the database.
   --  ARGUMENTS:
   --     sn   - Schema Name
   --     mdtn - MultiDimension Table Name
   --     tsnm - Tablespace Name
   --  NOTES:
   --
   */
   procedure allocate_tablespace ( mdtn varchar2, tsnm varchar2 );
   procedure allocate_tablespace ( sn varchar2, mdtn varchar2, tsnm varchar2 );

   /*
   --
   --  NAME:
   --     active_tablespace
   --  DESCRIPTION:
   --     Tablespaces that are alloaced to MD tables can either
   --     be active or inactive.  Active means that the tablespace
   --     is ready to accept new partitions created for an MD table.
   --     In-active mean that the tablespace has partitions in it but
   --     it is not available for the addition of any more partitions.
   --     This procedure activates an inactive tablespaces.
   --  ARGUMENTS:
   --     sn   - Schema Name
   --     mdtn - MultiDimension Table Name
   --     tsnm - Tablespace Name
   --
   */
   procedure activate_tablespace ( mdtn varchar2, tsnm varchar2 );
   procedure activate_tablespace ( sn varchar2, mdtn varchar2, tsnm varchar2 );

   /*
   --
   --  NAME:
   --     deactive_tablespace
   --  DESCRIPTION:
   --     Deactivates a tablespace allocated to an MD table. This means
   --     that additional partitions will not be created in the tablespace.
   --     However, the tablespace will remain in the list of active tablespaces
   --     to indicate that partitions of an MD table still exist there.
   --  ARGUMENTS:
   --     sn   - Schema Name
   --     mdtn - MultiDimension Table Name
   --     tsnm - Tablespace Name
   --
   */
   procedure deactivate_tablespace ( mdtn varchar2, tsnm varchar2 );
   procedure deactivate_tablespace ( sn varchar2,mdtn varchar2,tsnm varchar2 );

end md_ddl;
/

grant execute on mdsys.md_ddl to public;
drop public synonym md_ddl;
create public synonym md_ddl for mdsys.md_ddl;
