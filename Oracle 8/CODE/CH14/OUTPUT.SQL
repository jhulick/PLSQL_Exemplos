REM output.sql
REM Version 1.0, last updated 5/15/97
REM This script demonstrates DBMS_OUTPUT.PUT_LINE and DBMS_OUTPUT.GET_LINES,
REM as described in Chapter 14 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  /* Demonstrates using PUT_LINE and GET_LINE. */
  v_Data      DBMS_OUTPUT.CHARARR;
  v_NumLines  NUMBER;
BEGIN
  -- Enable the buffer first.
  DBMS_OUTPUT.ENABLE(1000000);

  -- Put some data in the buffer first, so GET_LINES will
  -- retrieve something.
  DBMS_OUTPUT.PUT_LINE('Line One');
  DBMS_OUTPUT.PUT_LINE('Line Two');
  DBMS_OUTPUT.PUT_LINE('Line Three');

  -- Set the maximum number of lines which we want to retrieve.
  v_NumLines := 3;

  /* Get the contents of the buffer back. Note that v_Data is
     declared of type DBMS_OUTPUT.CHARARR, so that it matches
     the declaration of DBMS_OUTPUT.GET_LINES. */
  DBMS_OUTPUT.GET_LINES(v_Data, v_NumLines);

  /* Loop through the returned buffer, and insert the contents
     into temp_table. */
  FOR v_Counter IN 1..v_NumLines LOOP
    INSERT INTO temp_table (char_col)
      VALUES (v_Data(v_Counter));
  END LOOP;
END;
/
