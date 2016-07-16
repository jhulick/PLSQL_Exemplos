rem 
rem $Header: utlopset.sql,v 1.2 1993/07/07 15:12:38 lwillis Exp $ 
REM
REM Copyright (c) 1993 by Oracle Corporation
REM NAME
REM    utlopset.sql - optimizer set statistics for simulator
REM  DESCRIPTION
REM    Copy information from the transfer tables exported by the 
REM    customer into the simulator.
REM  NOTES
REM    This procedure is for use with statistics exported by utlopget.sql.
REM    If PL/SQL is available to the user UTLOPT.SQL is a better choice.
REM
REM    To import statistics into simulator
REM      imp user/pw file=stats.dmp fromuser=uname
REM      imp user/pw file=tdef.dmp fromouser=uname
REM
REM      sqldba
REM      connect internal
REM      -- create procedure to set the statistics
REM      -- requires pl/sql dictionary tables
REM      @utlopset.sql
REM      -- copy data from transfer tables to query repository 
REM      -- requires user tables and indexes to have been created 
REM      -- on development system by import or other means
REM      execute set_sim_stats ('UNAME')
REM      -- drop the transfer tables
REM      @utlopdst.sql
REM      -- force update of row cache
REM      shutdown
REM      startup
REM      exit
REM
Rem    MODIFIED   (MM/DD/YY)
Rem     lwillis    07/07/93 -  merge changes from branch 1.1.312.1
Rem     lwillis    07/07/93 -  Creation


CREATE OR REPLACE PROCEDURE set_sim_tab_stats (tname VARCHAR2, uname VARCHAR2)
AS BEGIN
--  First the table
    FOR trec IN (SELECT block_count, avg_row_length, row_count FROM
        sim_tab_stats WHERE table_name = tname AND user_name = uname) LOOP
            UPDATE tab$ 
                SET blkcnt = trec.block_count,
                    rowcnt = trec.row_count,
                    avgrln = trec.avg_row_length
                WHERE obj# = (SELECT o.obj# FROM obj$ o, user$ u 
                    WHERE o.name = tname AND u.name = uname 
                    AND o.owner# = u.user#);
    END LOOP;
-- Then the columns
    FOR crec IN (SELECT high_value, low_value, distinct_count, density,
       column_name FROM
       sim_col_stats WHERE table_name = tname AND user_name = uname) LOOP
           UPDATE col$
               SET hival = crec.high_value,
                   lowval = crec.low_value,
                   distcnt = crec.distinct_count,
                   spare2 = crec.density
               WHERE name = crec.column_name  AND 
                    obj# = (SELECT o.obj# FROM obj$ o, user$ u
                    WHERE o.name = tname AND u.name = uname 
                    AND o.owner# = u.user#);
    END LOOP;                   
-- And finally the indexes
    FOR irec IN (SELECT depth, distinct_count, leaf_block_count,
        avg_leaf_count, avg_data_count, is_unique, cluster_factor,
        index_name
        FROM sim_index_stats WHERE table_name = tname AND user_name = uname)
            LOOP
            UPDATE ind$ 
                SET blevel = irec.depth,
                distkey = irec.distinct_count,
                leafcnt = irec.leaf_block_count,
                lblkkey = irec.avg_leaf_count,
                dblkkey = irec.avg_data_count,
                unique$ = irec.is_unique,
                clufac = irec.cluster_factor
                WHERE obj# = (SELECT o.obj# 
                    FROM user$ u, obj$ o, ind$ i, obj$ io
                    WHERE  io.obj# = i.bo# AND i.obj# = o.obj#
                        AND io.name = tname AND io.owner# = u.user#
                        AND u.name = uname 
                        AND o.name = irec.index_name);
    END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE set_sim_stats (uname VARCHAR2)
AS BEGIN
    FOR trec IN (SELECT table_name FROM sim_tab_stats
        WHERE user_name = uname) LOOP
            set_sim_tab_stats (trec.table_name, uname);
    END LOOP;
END set_sim_stats;
/

