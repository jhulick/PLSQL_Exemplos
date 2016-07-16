REM lobtrim.sql
REM Version 1.0, last updated 8/8/97
REM This script demonstrates the use of DBMS_LOB.TRIM, as described in
REM Chapter 21 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET SERVEROUTPUT on
DECLARE
  v_BLOB BLOB;
BEGIN
  SELECT blob_col
    INTO v_BLOB
    FROM lobdemo
    WHERE key = 1
    FOR UPDATE;

  DBMS_OUTPUT.PUT_LINE('Before trim, length = ' || DBMS_LOB.GETLENGTH(v_BLOB));
  DBMS_LOB.TRIM(v_BLOB, 5);
  DBMS_OUTPUT.PUT_LINE('After trim, length = ' || DBMS_LOB.GETLENGTH(v_BLOB));

  -- Raises ORA-22926, since the length is now 5.
  DBMS_LOB.TRIM(v_BLOB, 10);
END;
/

