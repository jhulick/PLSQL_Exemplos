rem 
rem $Header: utldidxs.sql,v 1.1 1992/12/19 23:50:28 GLUMPKIN Exp $ dispidxs.sql 
rem 
Rem Copyright (c) 1989 by Oracle Corporation
Rem NAME
REM    UTLDIDXS.SQL
Rem  FUNCTION
Rem    See IDXSTAT.DOC
Rem  NOTES
Rem    Requires SQLPLUS 3.0.3.1 or greater
Rem  MODIFIED
Rem     glumpkin   11/24/92 -  Creation 
Rem     glumpkin   10/20/92 -  Renamed from DISPIDXS.SQL 
Rem   Laursen    01/01/91 - V6 to V7 merge
Rem   Aporter    09/24/89 - Creation
Rem   Porter    09/23/89 - Changed to 8-character filenames
Rem   Porter    04/04/89 - Commenting, cleanup
Rem   Porter    03/27/89 - Creation
Rem
Rem This procedure is given two parameters to specify which statistics are
Rem desired out of INDEX$INDEX_STATS and INDEX$BADNESS_STATS
Rem
Rem  SQLPLUS> @dispidxs table column
Rem  
Rem  SQLPLUS> @dispidxs
Rem  Enter value for 1: table
Rem  Enter value for 2: column
Rem 

Rem 
Rem
Rem Set up display characteristics
Rem
Set Pagesize 60
Set Feedback Off
Set Verify Off

Rem *** Set up variables ***
Rem
Column tab_name format a31
Column col_name format a31
column tab_name  new_value dsp_table_name
column col_name  new_value dsp_column_name
SELECT upper('&1') tab_name, 
       upper('&2') col_name 
  FROM DUAL;

Rem
Rem Display the basic statistics
Rem
Column column_name Format A15
Column table_name  Format A15
Column stat_value  Format 9,999,990.00
Select table_name,column_name,stat_name,stat_value
  From index$index_stats
  where table_name like upper('&dsp_table_name') and
        column_name like upper('&dsp_column_name')
  order by table_name,column_name,stat_name;

Rem 
Rem Display the badness table
Rem 
column row_percent format 990.00
column key_percent format 990.00
column keys_count  format 9,999,999
column badness     format 9,999,999
Select table_name,column_name,
       badness_factor badness,keys_with_badness keys_count,
       row_percent,key_percent
   from index$badness_stats
   where table_name like upper('&dsp_table_name') and
        column_name like upper('&dsp_column_name')
   order by table_name,column_name, badness_factor desc;
Rem
Rem
Rem Clean up
Rem
undefine 1
undefine 2
undefine dsp_table_name
undefine dsp_column_name
