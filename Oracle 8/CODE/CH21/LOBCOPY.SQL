REM lobcopy.sql
REM Version 1.0, last updated 8/8/97
REM This file demonstrates the DBMS_LOB.COPY routine, as described in
REM Chapter 21 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET SERVEROUTPUT on
DECLARE
  v_Lob1 CLOB;
  v_Lob2 CLOB;
BEGIN
  -- Retrieve source lob locator.
  SELECT clob_col
    INTO v_Lob1
    FROM lobdemo
    WHERE key = 1;

  -- Retrieve destination lob locator.
  SELECT clob_col
    INTO v_Lob2
    FROM lobdemo
    WHERE key = 2;

  -- Copy all 26 characters from v_Lob1 onto the end of v_Lob2, starting
  -- at offset 50.  Since v_Lob2 isn't 50 characters long, spaces will
  -- be inserted.
  DBMS_LOB.COPY(v_Lob2, v_Lob1, 26, 50, 1);

  -- And output the result.
  LOBPrint(v_Lob2);
END;
/

