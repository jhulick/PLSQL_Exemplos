REM extend.sql
REM Version 1.0, last updated 8/5/97
REM This block demonstrates the EXTEND collection method, as described in
REM Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET serveroutput on
DECLARE
  v_Numbers NumTab := NumTab(1, 2, 3, 4, 5);
BEGIN
  -- This assignment will raise SUBSCRIPT_BEYOND_COUNT, since
  -- v_Numbers has only 5 elements.
  v_Numbers(26) := -7;
EXCEPTION
  WHEN SUBSCRIPT_BEYOND_COUNT THEN
    DBMS_OUTPUT.PUT_LINE('ORA-6533 raised');

    -- We can fix this by adding 30 additional elements to v_Numbers.
    v_Numbers.EXTEND(30);

    -- And now do the assignment.
    v_Numbers(26) := -7;
END;
/
