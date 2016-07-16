rem 
rem $Header: utlexp6.sql,v 1.1 1992/10/20 12:09:25 GLUMPKIN Stab $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      expeob6.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     glumpkin   10/20/92 -  Renamed from EXPEOB6.SQL 
Rem     cheigham   02/28/92 -  Creation 
rem  Run this script against a V7 database.  The queries will return those
rem  objects which will NOT be exported via a SQL*Net connection to V6 Export.

rem no hash clusters exported

SELECT u$.name cluster_owner, o$.name cluster_name
FROM   sys.obj$ o$, sys.user$ u$, sys.clu$ cl$
WHERE cl$.obj# = o$.obj# 
AND cl$.hashkeys != 0
AND u$.user# = o$.owner#
/

rem no tables in hash clusters exported
rem also, no subordinate objects on these tables exported

SELECT u$.name table_owner, o$.name table_name
FROM   sys.tab$ t$, sys.obj$ o$, sys.user$ u$, sys.clu$ cl$
WHERE t$.obj# = o$.obj# 
AND t$.clu# = cl$.obj#
AND cl$.hashkeys != 0
AND u$.user# = o$.owner#
/

rem no roles exported

SELECT name role_name
FROM sys.user$
WHERE type = 0 and name not in
  ('CONNECT', 'RESOURCE', 'DBA', 'PUBLIC', '_NEXT_USER')
/

rem no triggers exported

SELECT u$.name trigger_owner, o$.name trigger_name
FROM sys.obj$ o$, sys.trigger$ t$, sys.user$ u$
WHERE o$.obj# = t$.obj# 
AND u$.user# = o$.owner#
/

rem no procedures/functions/packages/package bodies exported

SELECT u$.name object_owner, o$.name object_name,
DECODE(o$.type, 7, 'PROCEDURE', 8, 'FUNCTION', 
	9, 'PACKAGE', 11, 'PACKAGE BODY') object_type
FROM sys.obj$ o$, sys.user$ u$
WHERE (o$.type=7 OR o$.type=8 OR o$.type=9 OR o$.type=11)
AND u$.user# = o$.owner#
AND o$.owner# != 0
/

rem no profiles exported

SELECT name profile_name
        FROM sys.profname$
        WHERE profile# != 0
/

rem no snapshots exported

SELECT sowner snapshot_owner, vname snapshot_name, tname snapshot_table_name,
	mview view_on_master_table
from sys.snap$
/

rem no snapshot logs exported

SELECT mowner snapshot_log_owner, log snapshot_log_table
from sys.mlog$
/

rem No system auditing options are exported.
rem LONG, LONG RAW columns are truncated to 64K-3.
rem Database link names are truncated from 'x.y[.a.b]' to 'x'.
rem Columns of type VARCHAR2 (type 96) are mapped to type CHAR (type 1)
rem Tables with CHAR columns longer than 255 will be exported 
rem but cannot be re-imported without modification to the table CREATE
rem statement.
