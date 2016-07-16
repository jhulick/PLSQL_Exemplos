rem 
rem $Header: utlsidxs.sql,v 1.3 1994/12/14 17:36:18 drady Exp $ idxstat.sql 
rem 
Rem Copyright (c) 1989 by Oracle Corporation
Rem  NAME
Rem    UTLSIDXS.SQL
Rem  FUNCTION
Rem    See IDXSTAT.DOC
Rem  NOTES
Rem    1. All files need to be in the same directory.
Rem    2. Needs to be modified for concatenated indexes.
Rem    3. Requires SQLPLUS 3.0.3.1 or greater
Rem  MODIFIED
Rem     drady      12/14/94 -  merge changes from branch 1.2.720.1
Rem     drady      12/12/94 -  merge changes from branch 1.1.710.1
Rem     aho        03/03/94 -  fix reference to oneidxs.sql (bg 200053)
Rem     drady      12/07/94 -  fix bug 144445
Rem     glumpkin   10/20/92 -  Renamed from IDXSTAT.SQL 
Rem   Laursen    01/01/91 - V6 to V7 merge
Rem   Aporter    09/24/89 - Creation
Rem   Porter    09/23/89 - Change filenames to 8 character lengths
Rem   Porter    04/04/89 - Commenting, cleanup
Rem   Porter    03/27/89 - Creation
Rem
Rem *** Set up variables ***
Rem
Set Heading Off
Set Verify Off
Set Feedback Off
column table_name new_value index_table_name
column column_name new_value index_column_name
SELECT upper('&1') table_name, upper('&2') column_name FROM DUAL;
Set Heading On
Set Verify On
Set Feedback On

SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK OFF
SET PAGESIZE 999
SET HEADING OFF
SPOOL idxstat.tmp
Column COL1 Format A16
Column COL2 Format A31
Column COL3 Format A31
SELECT '@utloidxs' COL1, 
       UIC.TABLE_NAME COL2, UIC.COLUMN_NAME COL3 
  FROM USER_IND_COLUMNS UIC, 
       USER_INDEXES UI 
  WHERE UIC.INDEX_NAME=UI.INDEX_NAME AND
        UI.UNIQUENESS != 'UNIQUE' AND
        UIC.COLUMN_POSITION = 1 AND
        UIC.TABLE_NAME LIKE '&INDEX_TABLE_NAME' AND
        UIC.COLUMN_NAME LIKE '&INDEX_COLUMN_NAME';
SPOOL OFF
SET HEADING ON
SET VERIFY ON
SET FEEDBACK ON

Rem
Rem Clean up
Rem
undefine 1
undefine 2
undefine index_table_name
undefine index_column_name

Rem 
Rem Now, run the file that we have created.
Rem
@idxstat.tmp
