REM
REM $Header$
REM

REM Copyright (c) Oracle Corporation Canada Inc. 1992. All Rights Reserved.

REM
REM NAME:
REM    md3view.sql
REM
REM DESCRIPTION:
REM    This script should be run as MDSYS.
REM
REM    Creates the following public views that provide basic info about
REM    multidimensional tables
REM
REM       ALL_MD_TABLES         - all spatial tables user has access to
REM       ALL_MD_TABLESPACES    - all tablespaces allocated to spatial tables
REM       ALL_MD_PARTITIONS     - all partition tables user has access to
REM       ALL_MD_COLUMNS        - all spatial columns user has access to
REM       ALL_MD_DIMENSIONS     - all dimension definitions for all spatial
REM                               columns user has access to
REM       ALL_MD_EXCEPTIONS     - all table that are exceptions 
REM       ALL_MD_LOADER_ERRORS  - loader errors for all tables
REM
REM       USER_MD_TABLES        - spatial tables user owns
REM       USER_MD_TABLESPACES   - tablespaces allocated to user spatial tables
REM       USER_MD_PARTITIONS    - partiton tables user owns
REM       USER_MD_COLUMNS       - spatial columns user owns
REM       USER_MD_DIMENSIONS    - dimension definitions for spatial columns
REM                               user owns
REM       USER_MD_EXCEPTIONS    - exceptions for this user
REM       USER_MD_LOADER_ERRORS - loader exceptions table for tables owned
REM                               by user 
REM       MDTAB                 - name and class of MD tables owned by user
REM
REM
REM MODIFIED     (DD-MON-YY)     DESCRIPTION
REM Vretanos      13-NOV-95      Patch bug 303986.
REM Vretanos      10-OCT-95      Patch PK bug in DBA_MD_COLUMNS
REM Vretanos      21-SEP-95      Update for V1.3.?
REM Vretanos      28-AUG-93      Creation.
REM

prompt Creating view ALL_MD_TABLES.
drop   view all_md_tables;
create view all_md_tables
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
  from md$tab
 where owner = user
    or mdtname in ( select table_name
		      from all_tab_privs
                     where grantee = user );

grant select on all_md_tables to public;
drop public synonym all_md_tables;
create public synonym all_md_tables for mdsys.all_md_tables;


prompt Creating view USER_MD_TABLES.
drop   view user_md_tables;
create view user_md_tables
(
   MD_TABLE_NAME,
   CLASS,
   PTAB_SEQ,
   HIGH_WATER_MARK,
   OFFLINE_PATH,
   COUNT_MODE
)
as
select mdtname,decode(class,0,'NON-PARTITIONED',1,'PARTITIONED'),
       ptseq,hwm,oflp,decode(cm,0,'ESTIMATE',1,'EXACT')
  from md$tab
 where owner = user;

grant select on user_md_tables to public;
drop public synonym user_md_tables;
create public synonym user_md_tables for mdsys.user_md_tables;

prompt Creating view MDTAB.
drop view mdtab;
create view mdtab
(
   NAME,
   CLASS
)
as
select mdtname,decode(class,0,'NON-PARTITIONED',1,'PARTITIONED','UNKNOWN')
  from md$tab
 where owner = user;

grant select on mdtab to public;
drop public synonym mdtab;
create public synonym mdtab for mdsys.mdtab;

prompt Creating view ALL_MD_TABLESPACES.
drop view all_md_tablespaces;
create view all_md_tablespaces
(
   OWNER,
   MD_TABLE_NAME,
   TABLESPACE_NAME,
   SEQUENCE,
   STATUS
)
as
select owner,mdtname,tsname,seq,decode(status,0,'IN-ACTIVE',1,'ACTIVE')
  from md$pts
 where owner = user
    or mdtname in ( select table_name
                      from all_tab_privs
                     where grantee = user );

grant select on all_md_tablespaces to public;
drop public synonym all_md_tablespaces;
create public synonym all_md_tablespaces for mdsys.all_md_tablespaces;

prompt Creating view USER_MD_TABLESPACES.
drop view user_md_tablespaces;
create view user_md_tablespaces
(
   MD_TABLE_NAME,
   TABLESPACE_NAME,
   SEQUENCE,
   STATUS
)
as
select mdtname,tsname,seq,decode(status,0,'IN-ACTIVE',1,'ACTIVE')
  from md$pts
 where owner = user;

grant select on user_md_tablespaces to public;
drop public synonym user_md_tablespaces;
create public synonym user_md_tablespaces for mdsys.user_md_tablespaces;

prompt Creating view ALL_MD_PARTITIONS.
drop view all_md_partitions;
create view all_md_partitions
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
       cclv,cchh,decode(olst,1,'ONLINE','OFFLINE'),archd
  from md$ptab
 where owner = user
    or mdtname in ( select table_name
		      from all_tab_privs
                     where grantee = user );

grant select on all_md_partitions to public;
drop public synonym all_md_partitions;
create public synonym all_md_partitions for mdsys.all_md_partitions;

prompt Creating view USER_MD_PARTITIONS.
drop view user_md_partitions;
create view user_md_partitions
(
   MD_TABLE_NAME,
   PARTITION_TABLE_NAME,
   CLASS,
   COMMON_LEVEL,
   COMMON_HHCODE,
   OFFLINE_STATUS,
   ARCHIVE_DATE
)
as
select mdtname,pname,decode(class,0,'LEAF',1,'NODE',2,'PERSISTENT NODE'),
       cclv,cchh,decode(olst,1,'ONLINE','OFFLINE'),archd
  from md$ptab
 where owner = user;

grant select on user_md_partitions to public;
drop public synonym user_md_partitions;
create public synonym user_md_partitions for mdsys.user_md_partitions;

prompt Creating view ALL_MD_COLUMNS.
drop view all_md_columns;
create view all_md_columns
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
       num_distinct,
       low_value,
       high_value
  from all_tab_columns
 where owner = user
   and table_name in ( select mdtname
                         from md$tab
                        where owner = user
                           or mdtname in ( select table_name
                                             from all_tab_privs
                                            where grantee = user ) )
   and column_name not in ( select cname
                              from md$col
                             where owner = user
                                or mdtname in ( select table_name
                                                  from all_tab_privs
                                                 where grantee = user ) )
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
       nullable,
       decode(b.pk,0,'N',1,'Y'),
       column_id,
       default_length,
       num_distinct,
       low_value,
       high_value
  from all_tab_columns a, md$col b
 where a.owner = user
   and a.owner = b.owner 
   and a.table_name = b.mdtname
   and a.column_name = b.cname
   and a.table_name in ( select mdtname
                           from md$tab
                          where owner = user
                             or mdtname in ( select table_name
                                               from all_tab_privs
                                              where grantee = user ) )
   and a.column_name in ( select cname
                            from md$col
                           where owner = user
                              or mdtname in ( select table_name
                                                from all_tab_privs
                                               where grantee = user ) );

grant select on all_md_columns to public;
drop public synonym all_md_columns;
create public synonym all_md_columns for mdsys.all_md_columns;

prompt Creating view USER_MD_COLUMNS.
drop view user_md_columns;
create view user_md_columns
(
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
   NUM_DISTINCT,
   LOW_VALUE, 
   HIGH_VALUE
)
as
select 
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
       num_distinct,
       low_value,
       high_value
  from all_tab_columns
 where owner = user
   and table_name in ( select mdtname
			 from md$tab
                        where owner = user )
   and column_name not in ( select cname
			      from md$col
                             where owner = user )
union all
select 
       table_name,
       column_name,
       'HHCODE',
       data_length,
       data_precision,
       data_scale,
       b.ndim,
       b.mxl,
       nullable,
       decode(b.pk,0,'N',1,'Y'),
       column_id,
       default_length,
       num_distinct,
       low_value,
       high_value
  from all_tab_columns a, md$col b
 where a.owner = user
   and a.owner = b.owner 
   and a.table_name = b.mdtname
   and a.column_name = b.cname
   and table_name in ( select mdtname
			 from md$tab
                        where owner = user )
   and column_name in ( select cname
			  from md$col
                         where owner = user );

grant select on user_md_columns to public;
drop public synonym user_md_columns;
create public synonym user_md_columns for mdsys.user_md_columns;

prompt Creating view ALL_MD_DIMENSIONS.
drop view all_md_dimensions;
create view all_md_dimensions
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
  from md$dim
 where owner = user
    or mdtname in ( select table_name
		      from all_tab_privs
                     where grantee = user );

grant select on all_md_dimensions to public;
drop public synonym all_md_dimensions;
create public synonym all_md_dimensions for mdsys.all_md_dimensions;

prompt Creating view USER_MD_DIMENSIONS.
drop view user_md_dimensions;
create view user_md_dimensions
(
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
select mdtname,cname,name,dim#,lb,ub,scale,lev
  from md$dim
 where owner = user;

grant select on user_md_dimensions to public;
drop public synonym user_md_dimensions;
create public synonym user_md_dimensions for mdsys.user_md_dimensions;

prompt Creating view ALL_MD_LOADER_ERRORS.
drop view all_md_loader_errors;
create view all_md_loader_errors
(
   OWNER,
   MD_TABLE_NAME,
   FILENAME,
   ROWS_LOADED
)
as
select owner,mdtname,filename,nrows
  from md$ler
 where owner = user
    or mdtname in ( select table_name
		      from all_tab_privs
                     where grantee = user );
 
grant select on all_md_loader_errors to public;
drop public synonym all_md_loader_errors;
create public synonym all_md_loader_errors for mdsys.all_md_loader_errors;
REM for backward compatibility: keep the md_loader_errors as a synonym
drop public synonym md_loader_errors;
create public synonym md_loader_errors for mdsys.all_md_loader_errors;

prompt Creating view USER_MD_LOADER_ERRORS.
drop view user_md_loader_errors;
create view user_md_loader_errors
(
   MD_TABLE_NAME,
   FILENAME,
   ROWS_LOADED
)
as
select mdtname,filename,nrows
  from md$ler
 where owner = user;
 
grant select on user_md_loader_errors to public;
drop public synonym user_md_loader_errors;
create public synonym user_md_loader_errors for mdsys.user_md_loader_errors;

prompt Creating view ALL_MD_EXCEPTIONS
drop   view all_md_exceptions;
create view all_md_exceptions
(
   OWNER,
   NAME,
   OPERATION,
   CCHH
)
as
select owner,name,op,cchh
  from md$exc
 where owner = user
    or name in ( select table_name
		      from all_tab_privs
                     where grantee = user );

grant select on all_md_exceptions to public;
drop public synonym all_md_exceptions;
create public synonym all_md_exceptions for mdsys.all_md_exceptions;

prompt Creating view USER_MD_EXCEPTIONS
drop   view user_md_exceptions;
create view user_md_exceptions
(
   NAME,
   OPERATION,
   CCHH
)
as
select name,op,cchh
  from md$exc
 where owner = user;

grant select on user_md_exceptions to public;
drop public synonym user_md_exceptions;
create public synonym user_md_exceptions for mdsys.user_md_exceptions;

REM
REM End of File MD3VIEW.SQL
REM
