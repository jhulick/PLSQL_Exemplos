REM count.sql
REM Version 1.0, last updated 4/30/97
REM This block illustrates the COUNT table attribute, as described in
REM Chapter 3 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  TYPE t_NumberTable IS TABLE OF NUMBER
    INDEX BY BINARY_INTEGER;
  v_Numbers t_NumberTable;
  v_Total NUMBER;
BEGIN
  -- Insert 50 rows into the table.
  FOR v_Counter IN 1..50 LOOP
    v_Numbers(v_Counter) := v_Counter;
  END LOOP;

  v_Total := v_Numbers.COUNT;
END;
/
