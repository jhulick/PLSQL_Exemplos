REM long2lob.sql
REM Version 1.0, last updated 8/8/97
REM This procedure copies LONG data into a CLOB, as described in
REM Chapter 21 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE Long2Lob(
  -- Uses DBMS_SQL to select a LONG column identified by p_LongQuery, and
  -- returns it in p_CLob.
  p_LongQuery IN VARCHAR2,
  p_CLob IN OUT CLOB) AS

  c_ChunkSize CONSTANT INTEGER := 100;

  v_CursorID INTEGER;
  v_RC INTEGER;
  v_Chunk VARCHAR2(100);
  v_ChunkLength INTEGER;
  v_Offset INTEGER := 0;
BEGIN
  -- Open the cursor, define, execute, and fetch.
  v_CursorID := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(v_CursorID, p_LongQuery, DBMS_SQL.V7);
  DBMS_SQL.DEFINE_COLUMN_LONG(v_CursorID, 1);
  v_RC := DBMS_SQL.EXECUTE_AND_FETCH(v_CursorID);

  -- Loop over the LONG, fetching c_ChunkSize characters at a time from
  -- the LONG and adding them to the LOB.
  LOOP
    DBMS_SQL.COLUMN_VALUE_LONG(v_CursorID, 1, c_ChunkSize, v_Offset,
                          v_Chunk, v_ChunkLength);
    DBMS_LOB.WRITE(p_CLob, v_ChunkLength, v_Offset + 1, v_Chunk);
    IF v_ChunkLength < c_ChunkSize THEN
      EXIT;
    ELSE
      v_Offset := v_Offset + v_ChunkLength;
    END IF;
  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_CursorID);
EXCEPTION
  WHEN OTHERS THEN
    -- Clean up, and reraise the error.
    DBMS_SQL.CLOSE_CURSOR(v_CursorID);
    RAISE;
END Long2Lob;
/
