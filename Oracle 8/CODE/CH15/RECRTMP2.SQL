REM recrtmp2.sql
REM Version 1.0, last updated 5/21/97
REM This version of RecreateTempTable illustrates using DBMS_SQL to execute
REM DDL commands, as described in Chapter 15 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE RecreateTempTable (
  /* Drops temp_table and recreates it. The table description
     is passed in with p_Description, and should be the contents
     of the CREATE TABLE statement, after the table name. For
     example, the following is a legal call:

     RecreateTempTable('(num_col NUMBER, char_col VARCHAR2(2000))');
 */
  p_Description IN VARCHAR2) IS

  v_Cursor        NUMBER;
  v_CreateString  VARCHAR2(100);
  v_DropString    VARCHAR2(100);
BEGIN
  /* Open the cursor for processing. */
  v_Cursor := DBMS_SQL.OPEN_CURSOR;

  /* Drop the table first. */
  v_DropString := 'DROP TABLE temp_table';

  /* Parse the 'DROP TABLE' command, which also executes it. Trap the
     ORA-942 error in case the table doesn't yet exist. */
  BEGIN
    -- DBMS_SQL.V7 is a constant defined in the package header.
    DBMS_SQL.PARSE(v_Cursor, v_DropString, DBMS_SQL.V7);
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
        RAISE;
      END IF;
  END;
  /* Now recreate it. We need to create the CREATE TABLE
     string first, then parse it to run the statement. */
  v_CreateString := 'CREATE TABLE temp_table ' || p_Description;
  DBMS_SQL.PARSE(v_Cursor, v_CreateString, DBMS_SQL.V7);

  /* Close the cursor, now that we are finished. */
  DBMS_SQL.CLOSE_CURSOR(v_Cursor);
EXCEPTION
  WHEN OTHERS THEN
    /* Close the cursor first, then reraise the error so it is
       propagated out. */
    DBMS_SQL.CLOSE_CURSOR(v_Cursor);
    RAISE;
END RecreateTempTable;
/
