rem 
rem $Header: utlopdst.sql,v 1.2 1993/07/07 15:07:37 lwillis Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      utlopdst.sql - drop optimizer simulator tables
Rem    DESCRIPTION
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     lwillis    07/07/93 -  merge changes from branch 1.1.312.1
Rem     lwillis    07/07/93 -  Creation

DROP TABLE sim_col_stats;
DROP TABLE sim_index_stats;
DROP TABLE sim_tab_stats;
