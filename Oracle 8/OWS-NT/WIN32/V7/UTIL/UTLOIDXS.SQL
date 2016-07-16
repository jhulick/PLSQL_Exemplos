rem 
rem $Header: utloidxs.sql,v 1.1 1992/12/19 23:56:43 GLUMPKIN Exp $ oneidxs.sql 
rem 
Rem Copyright (c) 1989 by Oracle Corporation
Rem NAME
REM    UTLOIDXS.SQL
Rem  FUNCTION
Rem    See below
Rem  NOTES
Rem    See below
Rem  MODIFIED
Rem     glumpkin   10/20/92 -  Renamed from ONEIDXS.SQL 
Rem     rlim       04/29/91 -         change char to varchar2 
Rem   Laursen    01/01/91 - V6 to V7 merge
Rem   Porter    09/23/89 - Change to 8-character filenames
Rem   Porter    04/04/89 - Commenting, cleanup
Rem   Porter    03/27/89 - Creation
Rem
Rem-------------------------------------------------------------------   
Rem                           ONEIDXS.SQL 
Rem
Rem    Use this procedure to find out information about how 
Rem    selective columns are. Use it to:
Rem
Rem      1. Identify prospective columns for new indexes
Rem      2. Determine how selective a current index is
Rem      3. Determine whether a current index is useful or not
Rem
Rem    SQL> START ONE_INDEX_STATS TABLE_NAME COLUMN_NAME
Rem
Rem    NOTE: This procedure requires SQLPLUS version 3.0.3.1 or greater,
Rem          in order for the NEW_VALUE statement to be implemented 
Rem          correctly.
Rem-------------------------------------------------------------------

Rem 
Rem *** Set up variables ***
Rem
Set Heading Off
Set Verify Off                     
Set Feedback Off
column table_name new_value one_table_name
column column_name new_value one_column_name
SELECT upper('&1') table_name, upper('&2') column_name FROM DUAL;
Set Heading On
Set Verify On
Set Feedback On

SET TERMOUT OFF

Rem
Rem     Table statistics:
Rem
Rem     If an indexed column has nulls in it, then care must be used
Rem     in analyzing performance of that index:
Rem       1. A query for a null value will do a table-scan, and
Rem          will never use an index.
Rem       2. A query for a non-null value will only have to search
Rem          an index that has no null entries in it.  Thus, no 
Rem          performance will be lost between a table with 100 not-null
Rem          entries and 100 not-null and 1000 null entries, as long
Rem          as queries for not-null values are made.
Rem


Rem 
Rem *** Create user statistics tables, if not already created ***
Rem
CREATE TABLE INDEX$INDEX_STATS (
  TABLE_NAME        VARCHAR2(30) NOT NULL,
  COLUMN_NAME       VARCHAR2(30) NOT NULL,
  STAT_NAME         VARCHAR2(30) NOT NULL,
  STAT_VALUE        NUMBER   NOT NULL);

create table INDEX$BADNESS_STATS
  (table_name            varchar2(30) not null,
   column_name           varchar2(30) not null,
   badness_factor        number(9),
   keys_with_badness     number(9),
   row_percent           number(9,3),
   row_blk_fail          number(9),
   row_blk_succ          number(9),
   key_percent           number(9,3));

Rem
Rem *** Get rid of any current lines in the tables ***
Rem
delete from index$index_stats
  where table_name = '&one_table_name' and column_name = '&one_column_name';
delete from index$badness_stats
  where table_name = '&one_table_name' and column_name = '&one_column_name';

Rem
Rem *** GET STATISTICS ***
Rem

COLUMN RECORDS NEW_VALUE TOT_ROWS;
SELECT COUNT(*) RECORDS 
  FROM &one_table_name;
INSERT INTO INDEX$INDEX_STATS VALUES('&one_table_name','&one_column_name',
                                     'Rows - Total',
                                     &tot_rows);

COLUMN NULLS NEW_VALUE TOT_NULLS;
SELECT COUNT(*) NULLS 
  FROM &one_table_name 
  WHERE &one_column_name IS NULL;
INSERT INTO INDEX$INDEX_STATS VALUES('&one_table_name','&one_column_name',
                                     'Rows - Null',
                                     &tot_nulls);

COLUMN DISTINCT_KEYS NEW_VALUE TOT_DISTINCT_KEYS
SELECT COUNT(DISTINCT &one_column_name) DISTINCT_KEYS 
  FROM &one_table_name 
  WHERE &one_column_name IS NOT NULL;
INSERT INTO INDEX$INDEX_STATS VALUES('&one_table_name','&one_column_name',
                                     'Total Distinct Keys',
                                     &TOT_DISTINCT_KEYS);

COLUMN NOT_NULLS NEW_VALUE TOT_NOT_NULLS;
SELECT &TOT_ROWS - &TOT_NULLS NOT_NULLS 
  FROM DUAL;
INSERT INTO INDEX$INDEX_STATS ('&one_table_name','&one_column_name',
                               'Rows - Not null',
                               &TOT_NOT_NULLS);

Rem
Rem     Following are statistics for the distribution of the keys,
Rem     without null values, since null values can perturb the
Rem     statistics, and indexes don't use nulls.
Rem
Rem     Of particular interest here is the average number of 
Rem     rows per key, since this is a general measure of the
Rem     selectivity of the column.
Rem

column average  new_value average
column minimum  new_value minimum
column maximum  new_value maximum 
column std_dev  new_value std_dev
SELECT nvl(avg(COUNT(*)),0)      AVERAGE,
       nvl(min(COUNT(*)),0)      MINIMUM,
       nvl(max(COUNT(*)),0)      MAXIMUM ,
       nvl(stddev(count(*)),0)   STD_DEV
  FROM &one_table_name
  WHERE &one_column_name IS NOT NULL
  GROUP BY &one_column_name;
INSERT INTO INDEX$INDEX_STATS VALUES('&one_table_name','&one_column_name',
                                     'Rows per key - avg',&average);
INSERT INTO INDEX$INDEX_STATS VALUES('&one_table_name','&one_column_name',
                                     'Rows per key - min',&minimum);
INSERT INTO INDEX$INDEX_STATS VALUES('&one_table_name','&one_column_name',
                                     'Rows per key - max',&maximum);
INSERT INTO INDEX$INDEX_STATS VALUES('&one_table_name','&one_column_name',
                                     'Rows per key - dev',&std_dev);

Rem
Rem      The following table is a histogram of key selectivity in the
Rem      column.  This can be used to determine what the overall 
Rem      'badness' (a technical term) of the column is. NOTE: This
Rem      key selectivity is measured WITHOUT NULLS, since nulls don't
Rem      use indexes.
Rem 
Rem      The 'badness_factor' column tells how many times a key was 
Rem      repeated.
Rem      The 'keys_with_badness' column tells how many keys were
Rem      repeated 'badness_factor' times.
Rem 
Rem      Higher badness factors are detrimental to the selectivity
Rem      of the column.
Rem
Rem      This table takes on different meanings depending upon 
Rem      which access method is assumed:
Rem      1. Access distributed equally across rows
Rem         In this case, the user should look at the 'ROW_PERC' 
Rem         column to determine what percentage of the queries will
Rem         have high badness factors. 
Rem      2. Access distributed equally across key values
Rem         In this case, the user should look at the 'KEY_PERC' 
Rem         column to determine what percentage of the queries will
Rem         have high badness factors.
Rem  

drop view index$badness;
create view index$badness as
   (select count(&one_column_name) repeat_count  
   from &one_table_name 
   group by &one_column_name);

insert into index$badness_stats (table_name,column_name,
    badness_factor, keys_with_badness, row_percent, 
    row_blk_fail, row_blk_succ, key_percent)
  select '&one_table_name' table_name,'&one_column_name' column_name,
    repeat_count badness_factor,
    count(repeat_count) keys_with_badness,
    (count(repeat_count)*repeat_count/&tot_not_nulls)*100 row_percent,
    (count(repeat_count)*repeat_count*repeat_count) row_blk_fail,
    (count(repeat_count)*repeat_count*ceil(repeat_count/2)) row_blk_succ,
    (count(repeat_count)/&tot_distinct_keys)*100 key_percent
  from index$badness
  where repeat_count <> 0
  group by repeat_count;

Rem
Rem     The following two statistics attempt to determine
Rem     how expensive it is to access keys in this table.
Rem     A 'miss' will have to scan all the rows for a key value,
Rem     and a 1-row hit will, on the average, only have to scan
Rem     half of them.
Rem   
Rem     These gets are the the gets to read data from the table.
Rem     Gets needed to access branch and leaf nodes of the index
Rem     are not counted here.
Rem

column gets_per_miss_by_row new_value miss_gets
column gets_per_1_row_hit_by_row new_value hit_gets
select nvl((sum(row_blk_fail)/&tot_not_nulls),0) gets_per_miss_by_row,
       nvl((sum(row_blk_succ)/&tot_not_nulls),0) gets_per_1_row_hit_by_row
  from index$badness_stats
  where table_name like '&one_table_name' AND
        column_name like '&one_column_name';  
INSERT INTO INDEX$INDEX_STATS VALUES('&one_table_name','&one_column_name',
                                     'db_gets_per_key_miss',&miss_gets);
INSERT INTO INDEX$INDEX_STATS VALUES('&one_table_name','&one_column_name',
                                     'db_gets_per_key_hit',&hit_gets);

drop view index$badness;
SET TERMOUT ON

Rem
Rem Clean up
Rem 
undefine 1
undefine 2
undefine one_table_name
undefine one_column_name
