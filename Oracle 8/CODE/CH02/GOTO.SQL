REM goto.sql
REM Version 1.0, last updated 5/7/97
REM This block illustrates using GOTO to implement a loop, as described in
REM Chapter 2 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_Counter  BINARY_INTEGER := 1;
BEGIN
  LOOP
    INSERT INTO temp_table
      VALUES (v_Counter, 'Loop count');
    v_Counter := v_Counter + 1;
    IF v_Counter > 50 THEN
      GOTO l_EndOfLoop;
    END IF;
  END LOOP;

  <<l_EndOfLoop>>
  INSERT INTO temp_table (char_col)
    VALUES ('Done!');
END;
/
