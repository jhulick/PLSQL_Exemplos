REM delete.sql
REM Version 1.0, last updated 8/5/97
REM This block illustrates the DELETE collection method, as described in
REM Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET serveroutput on
DECLARE
  -- Initialize a table to 10 elements.
  v_Numbers NumTab := NumTab(10, 20, 30, 40, 50, 60, 70, 80, 90, 100);

  -- Local procedure to print out a table.
  PROCEDURE Print(p_Table IN NumTab) IS
    v_Index INTEGER;
  BEGIN
    v_Index := p_Table.FIRST;
    WHILE v_Index <= p_Table.LAST LOOP
      DBMS_OUTPUT.PUT('Element ' || v_Index || ': ');
      DBMS_OUTPUT.PUT_LINE(p_Table(v_Index));
      v_Index := p_Table.NEXT(v_Index);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('COUNT = ' || p_Table.COUNT);
    DBMS_OUTPUT.PUT_LINE('LAST = ' || p_Table.LAST);
  END Print;

BEGIN
  DBMS_OUTPUT.PUT_LINE('At initialization, v_Numbers contains');
  Print(v_Numbers);

  -- Delete element 6.
  DBMS_OUTPUT.PUT_LINE('After delete(6), v_Numbers contains');
  v_Numbers.DELETE(6);
  Print(v_Numbers);

  -- Delete elements 7 through 9.
  DBMS_OUTPUT.PUT_LINE('After delete(7,9), v_Numbers contains');
  v_Numbers.DELETE(7,9);
  Print(v_Numbers);
END;
/

