REM
REM $Header$
REM

REM Copyright (c) Oracle Corporation Canada Inc. 1992. All Rights Reserved.

REM
REM NAME:
REM    md3dba.sql
REM
REM DESCRIPTION:
REM    This script should be run as MDSYS.
REM
REM    Creates the following views that provide basic info about
REM    multidimensional tables
REM
REM       DBA_MD_TABLES         - all spatial tables 
REM       DBA_MD_PARTITIONS     - all partition tables 
REM       DBA_MD_COLUMNS        - all spatial columns 
REM       DBA_MD_DIMENSIONS     - all dimension definitions 
REM       DBA_MD_LOADER_ERRORS  - all loader errors
REM       DBA_MD_EXCEPTIONS     - all md exceptions
REM
REM MODIFIED     (DD-MON-YY)     DESCRIPTION
REM Vretanos      10-OCT-95      Patch PK bug in ???_MD_COLUMNS
REM Vretanos      28-SEP-95      Update for V1.3.5
REM Vretanos      28-AUG-93      Creation.
REM

prompt Creating view DBA_MD_TABLES.
drop   view dba_md_tables;
create view dba_md_tables
(
   OWNER,
   MD_TABLE_NAME,
   CLASS,
   PTAB_SEQ,
   HIGH_WATER_MARK,
   OFFLINE_PATH,
   COUNT_MODE
)
as
select owner,mdtname,decode(class,0,'NON-PARTITIONED',1,'PARTITIONED'),
       ptseq,hwm,oflp,decode(cm,0,'ESTIMATE',1,'EXACT')
  from md$tab;

grant select on dba_md_tables to public;
drop public synonym dba_md_tables;
create public synonym dba_md_tables for mdsys.dba_md_tables;

prompt Creating view DBA_MD_TABLESPACES.
drop view dba_md_tablespaces;
create view dba_md_tablespaces
(
   OWNER,
   MD_TABLE_NAME,
   TABLESPACE_NAME,
   SEQUENCE,
   STATUS
)
as
select owner,mdtname,tsname,seq,decode(status,0,'IN-ACTIVE',1,'ACTIVE')
  from md$pts;

grant select on dba_md_tablespaces to public;
drop public synonym dba_md_tablespaces;
create public synonym dba_md_tablespaces for mdsys.dba_md_tablespaces;

prompt Creating view DBA_MD_PARTITIONS.
drop view dba_md_partitions;
create view dba_md_partitions
(
   OWNER,
   MD_TABLE_NAME,
   PARTITION_TABLE_NAME,
   CLASS,
   COMMON_LEVEL,
   COMMON_HHCODE,
   OFFLINE_STATUS,
   ARCHIVE_DATE
)
as
select owner,mdtname,pname,decode(class,0,'LEAF',1,'NODE',2,'PERSISTENT NODE'),
       cclv,cchh,decode(olst,0,'OFFLINE',1,'ONLINE'),archd
  from md$ptab;

grant select on dba_md_partitions to public;
drop public synonym dba_md_partitions;
create public synonym dba_md_partitions for mdsys.dba_md_partitions;

prompt Creating view DBA_MD_COLUMNS.
drop view dba_md_columns;
create view dba_md_columns
(
   OWNER, 
   MD_TABLE_NAME,
   COLUMN_NAME, 
   DATA_TYPE,
   DATA_LENGTH,
   DATA_PRECISION,
   DATA_SCALE,
   NDIM,
   MAX_LEVEL,
   NULLABLE,
   PARTITION_KEY,
   COLUMN_ID,
   DEFAULT_LENGTH,
   DATA_DEFAULT,
   NUM_DISTINCT,
   LOW_VALUE, 
   HIGH_VALUE
)
as
select owner,
       table_name,
       column_name,
       data_type,
       data_length,
       data_precision,
       data_scale,
       0,
       0,
       nullable,
       'N',
       column_id,
       default_length,
       data_default,
       num_distinct,
       low_value,
       high_value
  from all_tab_columns
 where table_name      in ( select mdtname
			      from md$tab )
   and column_name not in ( select cname
			      from md$col )
union all
select a.owner,
       a.table_name,
       a.column_name,
       'HHCODE',
       a.data_length,
       a.data_precision,
       a.data_scale,
       b.ndim,
       b.mxl,
       a.nullable,
       decode(b.pk,0,'N',1,'Y'),
       a.column_id,
       a.default_length,
       a.data_default,
       a.num_distinct,
       a.low_value,
       a.high_value
  from all_tab_columns a, md$col b
 where a.owner = b.owner
   and a.table_name = b.mdtname
   and a.column_name = b.cname;

grant select on dba_md_columns to public;
drop public synonym dba_md_columns;
create public synonym dba_md_columns for mdsys.dba_md_columns;

prompt Creating view DBA_MD_DIMENSIONS.
drop view dba_md_dimensions;
create view dba_md_dimensions
(
    OWNER,
    MD_TABLE_NAME,
    COLUMN_NAME,
    DIMENSION_NAME,
    DIMENSION_NUMBER,
    LOWER_BOUND,
    UPPER_BOUND,
    DECIMAL_PRECISION,
    RECURSION_LEVEL
)
as
select owner,mdtname,cname,name,dim#,lb,ub,scale,lev
  from md$dim;

grant select on dba_md_dimensions to public;
drop public synonym dba_md_dimensions;
create public synonym dba_md_dimensions for mdsys.dba_md_dimensions;

prompt Creating view DBA_MD_LOADER_ERRORS.
drop view dba_md_loader_errors;
create view dba_md_loader_errors
(
   OWNER,
   MD_TABLE_NAME,
   FILENAME,
   ROWS_LOADED
)
as
select owner,mdtname,filename,nrows
  from md$ler;
 
grant select on dba_md_loader_errors to public;
drop public synonym dba_md_loader_errors;
create public synonym dba_md_loader_errors for mdsys.dba_md_loader_errors;

prompt Creating view DBA_MD_EXCEPTIONS
drop   view dba_md_exceptions;
create view dba_md_exceptions
(
   OWNER,
   NAME,
   OPERATION,
   CCHH
)
as
select owner,name,op,cchh
  from md$exc;

grant select on dba_md_exceptions to public;
drop public synonym dba_md_exceptions;
create public synonym dba_md_exceptions for mdsys.dba_md_exceptions;

REM
REM End of File MD3DBA.SQL
REM

