REM tconstr.sql
REM Version 1.0, last updated 8/5/97
REM This block illustrates nested table constructors, as described in
REM Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  TYPE t_NumbersTab IS TABLE OF NUMBER;

  -- Create a table with one element.
  v_Tab1 t_NumbersTab := t_NumbersTab(-1);

  -- Create a table with five elements.
  v_Primes t_NumbersTab := t_NumbersTab(1, 2, 3, 5, 7);

  -- Create a table with one element, which itself is NULL.
  v_Tab2 t_NumbersTab := t_NumbersTab();
BEGIN
  -- Assign to v_Tab1(1).  This will replace the value already
  -- in v_Tab(1), which was initialized to -1.
  v_Tab1(1) := 12345;
END;
/

