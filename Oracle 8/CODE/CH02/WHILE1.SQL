REM while1.sql
REM Version 1.0, last updated 5/7/97
REM This block illustrates a WHILE loop, as described in 
REM Chapter 2 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_Counter BINARY_INTEGER := 1;
BEGIN
  -- Test the loop counter before each loop iteration to
  -- insure that it is still less than 50.
  WHILE v_Counter <= 50 LOOP
    INSERT INTO temp_table
      VALUES (v_Counter, 'Loop index');
    v_Counter := v_Counter + 1;
  END LOOP;
END;
/
