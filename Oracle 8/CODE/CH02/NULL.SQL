REM null.sql
REM Version 1.0, last updated 5/7/97
REM This block illustrates using NULL as a statement, as described in
REM Chapter 2 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_TempVar  NUMBER := 7;
BEGIN
  IF v_TempVar < 5 THEN
    INSERT INTO temp_table (char_col)
      VALUES ('Too small');
  ELSIF v_TempVar < 10 THEN
    INSERT INTO temp_table (char_col)
      VALUES ('Just right');
  ELSE
    NULL;  -- Do nothing
  END IF;
END;
/
