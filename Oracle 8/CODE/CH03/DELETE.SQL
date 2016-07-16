REM delete.sql
REM Version 1.0, last updated 4/30/97
REM This block illustrates the DELETE table attribute, as described in
REM Chapter 3 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET serveroutput on

DECLARE
  TYPE t_ValueTable IS TABLE OF VARCHAR2(10)
    INDEX BY BINARY_INTEGER;
  v_Values t_ValueTable;
BEGIN
  -- Insert rows into the table.
  v_Values(1) := 'One';
  v_Values(3) := 'Three';
  v_Values(-2) := 'Minus Two';
  v_Values(0) := 'Zero';
  v_Values(100) := 'Hundred';
  
  DBMS_OUTPUT.PUT_LINE('Before DELETE, COUNT=' || v_Values.COUNT);
  v_Values.DELETE(100);  -- Removes 'Hundred'
  DBMS_OUTPUT.PUT_LINE('After first DELETE, COUNT=' || v_Values.COUNT);
  v_Values.DELETE(1,3);  -- Removes 'One' and 'Three'
  DBMS_OUTPUT.PUT_LINE('After second DELETE, COUNT=' || v_Values.COUNT);
  v_Values.DELETE;       -- Removes all remaining values
  DBMS_OUTPUT.PUT_LINE('After last DELETE, COUNT=' || v_Values.COUNT);
END;
/
