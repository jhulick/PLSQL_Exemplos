REM fileexec.sql
REM Version 1.0, last updated 8/8/97
REM This procedure demonstrates many DBMS_LOB routines, including the BFILE
REM manipulation routines, as described in Chapter 21 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE FileExec(
  -- Executes the SQL statements in the file identified by
  -- p_Directory and p_FileName.  Each statement should not contain
  -- the trailing semicolon (unless it is a PL/SQL block) and should
  -- be separated by p_SeparationChar.
  p_Directory IN VARCHAR2,
  p_FileName IN VARCHAR2,
  p_SeparationChar IN CHAR) AS

  v_FileLocator BFILE;
  v_CLOBLocator CLOB;
  v_SQLCursor INTEGER;
  v_StartPoint INTEGER := 1;
  v_EndPoint INTEGER;
  v_SQLStatement VARCHAR2(32000);
  v_StatementLength INTEGER;
  v_RC INTEGER;
BEGIN
  -- Initialize the character locator for writing.  Note that we have
  -- to select a CLOB from a table FOR UPDATE.  This locks the row,
  -- and is a requirement for LOADFROMFILE.
  SELECT clob_col
    INTO v_CLOBLocator
    FROM lobdemo
    WHERE key = -1
    FOR UPDATE;

  -- Initialize the BFILE locator for reading.
  v_FileLocator := BFILENAME(p_Directory, p_FileName);
  DBMS_LOB.FILEOPEN(v_FileLocator, DBMS_LOB.FILE_READONLY);

  -- Set up the cursor.
  v_SQLCursor := DBMS_SQL.OPEN_CURSOR;

  -- Load the entire file into the character LOB.
  -- This is necessary so that we have the data in
  -- character rather than RAW variables.
  DBMS_LOB.LOADFROMFILE(v_CLOBLocator, v_FileLocator,
                        DBMS_LOB.GETLENGTH(v_FileLocator));

  -- Loop over the LOB, searching for each occurrence of
  -- the separation character.
  LOOP
    v_EndPoint := DBMS_LOB.INSTR(v_CLOBLocator, p_SeparationChar,
                                 v_StartPoint, 1);
    EXIT WHEN v_EndPoint = 0;

    -- Extract the contents between the starting and ending points.
    -- This is the SQL statement to be executed.
    v_StatementLength := v_EndPoint - v_StartPoint;
    v_SQLStatement := DBMS_LOB.SUBSTR(v_CLOBLocator,
       v_StatementLength, v_StartPoint);

    -- Echo the statement to the screen, and then execute it
    -- using DBMS_SQL.
    DBMS_OUTPUT.PUT_LINE(v_SQLStatement);
    DBMS_SQL.PARSE(v_SQLCursor, v_SQLStatement, DBMS_SQL.V7);
    v_RC := DBMS_SQL.EXECUTE(v_SQLCursor);

    -- Increment the statement pointer for the next statement.
    v_StartPoint := v_EndPoint + 1;
  END LOOP;

  -- Clean up.
  DBMS_LOB.FILECLOSE(v_FileLocator);
  DBMS_SQL.CLOSE_CURSOR(v_SQLCursor);
EXCEPTION
  WHEN OTHERS THEN
    -- Close the cursor and file, and reraise.
    DBMS_LOB.FILECLOSE(v_FileLocator);
    DBMS_SQL.CLOSE_CURSOR(v_SQLCursor);
    RAISE;
END FileExec;
/

