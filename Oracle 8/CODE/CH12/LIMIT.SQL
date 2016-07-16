REM limit.sql
REM Version 1.0, last updated 8/5/97
REM This block illustrates the LIMIT collection method, as described in
REM Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET serveroutput on
DECLARE
  v_Table NumTab := NumTab(1, 2, 3);
  v_Varray NumVar := NumVar(1234, 4321);
BEGIN
  -- Output the limit and count for the collections.
  DBMS_OUTPUT.PUT_LINE('Varray limit: ' || v_Varray.LIMIT);
  DBMS_OUTPUT.PUT_LINE('Varray count: ' || v_Varray.COUNT);
  IF v_Table.LIMIT IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Table limit is NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Table limit: ' || v_Table.LIMIT);
  END IF;
  DBMS_OUTPUT.PUT_LINE('Table count: ' || v_Table.COUNT);
END;
/

