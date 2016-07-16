REM tassign.sql
REM Version 1.0, last updated 8/5/97
REM This block demonstrates some assignments to nested table elements, as
REM described in Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  TYPE t_NumbersTab IS TABLE OF NUMBER;
  v_Numbers t_NumbersTab := t_NumbersTab(1, 2, 3);
BEGIN
  -- v_Numbers was initialized to have 3 elements.  So the following
  -- assignments are all legal.
  v_Numbers(1) := 7;
  v_Numbers(2) := -1;

  -- However, this assignment will raise ORA-6533.
  v_Numbers(4) := 4;
END;
/

