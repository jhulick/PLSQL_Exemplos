REM simple.sql
REM Version 1.0, last updated 5/7/97
REM This block illustrates a simple loop, as described in 
REM Chapter 2 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_Counter BINARY_INTEGER := 1;
BEGIN
  LOOP
    -- Insert a row into temp_table with the current value of the
    -- loop counter.
    INSERT INTO temp_table
      VALUES (v_Counter, 'Loop index');
    v_Counter := v_Counter + 1;
    -- Exit condition - when the loop counter > 50 we will 
    -- break out of the loop.
    IF v_Counter > 50 THEN
      EXIT;
    END IF;
  END LOOP;
END;
/
