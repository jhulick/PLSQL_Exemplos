REM while2.sql
REM Version 1.0, last updated 5/7/97
REM This block illustrates a WHILE loop with a condition that evaluates to
REM NULL, as described in Chapter 2 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_Counter BINARY_INTEGER;
BEGIN
  -- This condition will evaluate to NULL, since v_Counter
  -- is initialized to NULL by default.
  WHILE v_Counter <= 50 LOOP
    INSERT INTO temp_table
      VALUES (v_Counter, 'Loop index');
    v_Counter := v_Counter + 1;
  END LOOP;
END;
/
