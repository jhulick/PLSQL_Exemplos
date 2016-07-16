REM numeric.sql
REM Version 1.0, last updated 6/3/97
REM This block illustrates a numeric FOR loop, as described in
REM Chapter 1 of _Oracle8 PL/SQL Programming_ by Scott Urman.

BEGIN
  FOR v_LoopCounter IN 1..50 LOOP
    INSERT INTO temp_table (num_col)
      VALUES (v_LoopCounter);
  END LOOP;
END;
/
