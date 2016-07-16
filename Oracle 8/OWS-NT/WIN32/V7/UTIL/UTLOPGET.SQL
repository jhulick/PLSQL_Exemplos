rem 
rem $Header: utlopget.sql,v 1.2 1993/07/07 15:10:45 lwillis Exp $ 
rem 
REM Copyright (c) 1993 by Oracle Corporation
REM  NAME
REM    utlopget.sql - optimizer get table information
REM  DESCRIPTION
REM    Get table information for optimizer export tables for simulator
REM  NOTES
REM    This method of exporting statistics should be used only if
REM    PL/SQL is not available.  If PL/SQL is available use the 
REM    procedures in UTLOPT.SQL.
REM
REM    To generate statistics tables 
REM      sqldba
REM      -- must connect internal to access table information
REM      connect internal
REM      -- create export tables
REM      @utlopcst.sql
REM      --  for each table in the query
REM      --  edit the script utlopget.sql substituting actual table 
REM      --  and user names for 'TNAME' and 'UNAME'
REM          @utlopget.sql
REM      exit
REM    To export the statistics tables
REM      exp user/pw file=stats.dmp tables=(sim_tab_stats, sim_col_stats, 
REM          sim_index_stats)
REM    To export the user table definitions
REM      exp user/pw file=tdef.dmp tables=(t1,...) rows=n
REM
REM    To remove the export tables
REM      sqldba
REM      connect internal
REM      @utlopdst.sql
REM      exit
REM
Rem    MODIFIED   (MM/DD/YY)
Rem     lwillis    07/07/93 -  merge changes from branch 1.1.312.1
Rem     lwillis    07/07/93 -  Creation

INSERT INTO sim_tab_stats (block_count, avg_row_length, row_count,
    table_name, user_name)
    SELECT blkcnt, avgrln, rowcnt, 'TNAME', 'UNAME'
        FROM tab$ t, obj$ o, user$ u
        WHERE o.name = 'TNAME' AND o.owner# = u.user# 
        AND u.name = 'UNAME'
        AND o.obj#=t.obj#;

INSERT INTO sim_col_stats (high_value, low_value, distinct_count, density,
    column_name, table_name, user_name )
    SELECT hival, lowval, distcnt, c.spare2, c.name, 'TNAME', 'UNAME' 
        FROM col$ c, obj$ o, user$ u
        WHERE o.name = 'TNAME' AND o.owner# = u.user# 
        AND o.obj# = c.obj# AND u.name = 'UNAME';

INSERT INTO sim_index_stats (depth, distinct_count, leaf_block_count, 
    avg_leaf_count, avg_data_count, is_unique, cluster_factor, 
    index_name, table_name, user_name)
    SELECT blevel, distkey, leafcnt, lblkkey, dblkkey, unique$, clufac,
        o.name, 'TNAME', 'UNAME'
        FROM ind$ i, obj$ o, obj$ io, user$ u
        WHERE i.bo# = io.obj# AND o.obj# = i.obj# 
        AND io.name = 'TNAME' AND io.owner# = u.user# 
        AND u.name = 'UNAME';

