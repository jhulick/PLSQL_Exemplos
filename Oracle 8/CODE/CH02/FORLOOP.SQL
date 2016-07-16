REM forloop.sql
REM Version 1.0, last updated 5/7/97
REM This block illustrates a numeric FOR loop, as described in
REM Chapter 2 of _Oracle8 PL/SQL Programming_ by Scott Urman.

BEGIN
  FOR v_Counter IN 1..50 LOOP
    INSERT INTO temp_table
      VALUES (v_Counter, 'Loop Index');
  END LOOP;
END;
/
