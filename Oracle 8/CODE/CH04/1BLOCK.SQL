REM 1block.sql
REM Version 1.0, last updated 4/27/97
REM This block contains many transactions, as described in
REM Chapter 4 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_NumIterations   NUMBER;
BEGIN
  -- Loop from 1 to 500, inserting these values into temp_table.
  -- Commit every 50 rows.
  FOR v_LoopCounter IN 1..500 LOOP
    INSERT INTO temp_table (num_col) VALUES (v_LoopCounter);
    v_NumIterations := v_NumIterations + 1;
    IF v_NumIterations = 50 THEN
      COMMIT;
      v_NumIterations := 0;
    END IF;
  END LOOP;
END;
/
