REM exists.sql
REM Version 1.0, last updated 8/5/97
REM This block demonstrates the EXISTS collection method, as described in
REM Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET SERVEROUTPUT on
DECLARE
  v_Table NumTab := NumTab(-7, 14.3, 3.14159, NULL, 0);
  v_Count BINARY_INTEGER := 1;
BEGIN
  -- Loop over v_Table, and print out the elements, using EXISTS to
  -- indicate the end of the loop.
  LOOP
    IF v_Table.EXISTS(v_Count) THEN
      DBMS_OUTPUT.PUT_LINE('v_Table(' || v_Count || '): ' || v_Table(v_Count));
      v_Count := v_Count + 1;
    ELSE
      EXIT;
    END IF;
  END LOOP;
END;
/

