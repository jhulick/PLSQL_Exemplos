REM forscope.sql
REM Version 1.0, last updated 5/7/97
REM This block illustrates the scoping rules for FOR loops, as described in
REM Chapter 2 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_Counter  NUMBER := 7;
BEGIN
  -- Inserts the value 7 into temp_table.
  INSERT INTO temp_table (num_col)
    VALUES (v_Counter);
  -- This loop redeclares v_Counter as a BINARY_INTEGER, which hides
  -- the NUMBER declaration of v_Counter.
  FOR v_Counter IN 20..30 LOOP
    -- Inside the loop, v_Counter ranges from 20 to 30.
    INSERT INTO temp_table (num_col)
      VALUES (v_Counter);
  END LOOP;
  -- Inserts another 7 into temp_table.
  INSERT INTO temp_table (num_col)
    VALUES (v_Counter);
END;
/
