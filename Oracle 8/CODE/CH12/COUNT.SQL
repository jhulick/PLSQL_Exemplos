REM count.sql
REM Version 1.0, last updated 8/5/97
REM This example illustrates the COUNT collection method, as described in
REM Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET serveroutput on
DECLARE
  v_Table NumTab := NumTab(1, 2, 3);
  v_Varray NumVar := NumVar(-1, -2, -3, -4);
BEGIN
  DBMS_OUTPUT.PUT_LINE('Table Count: ' || v_Table.COUNT);
  DBMS_OUTPUT.PUT_LINE('Varray Count: ' || v_Varray.COUNT);
END;
/

