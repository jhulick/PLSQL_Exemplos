REM simple.sql
REM Version 1.0, last updated 6/3/97
REM This block illustrates a simple loop, as described in
REM Chapter 1 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_LoopCounter BINARY_INTEGER := 1;
BEGIN
  LOOP
    INSERT INTO temp_table (num_col)
      VALUES (v_LoopCounter);
    v_LoopCounter := v_LoopCounter + 1;
    EXIT WHEN v_LoopCounter > 50;
  END LOOP;
END;
/
