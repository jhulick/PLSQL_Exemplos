REM nulltab.sql
REM Version 1.0, last updated 8/5/97
REM This block demonstrates the behavior of NULL nested tables, as described
REM in Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET serveroutput on
DECLARE
  TYPE t_WordsTab IS TABLE OF VARCHAR2(50);

  -- Create a NULL table.
  v_Tab1 t_WordsTab;

  -- Create a table with one element, which itself is NULL.
  v_Tab2 t_WordsTab := t_WordsTab();
BEGIN
  IF v_Tab1 IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('v_Tab1 is NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('v_Tab1 is not NULL');
  END IF;

  IF v_Tab2 IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('v_Tab2 is NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('v_Tab2 is not NULL');
  END IF;
END;
/

