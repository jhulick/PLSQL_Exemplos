REM frstlast.sql
REM Version 1.0, last updated 4/30/97
REM This block illustrates the use of the FIRST and LAST table attributes,
REM as described in Chapter 3 of _Oracle8 PL/SQL Programming_
REM by Scott Urman.

DECLARE
  TYPE t_LastNameTable IS TABLE OF students.last_name%TYPE
    INDEX BY BINARY_INTEGER;
  v_LastNames  t_LastNameTable;
  v_Index  BINARY_INTEGER;
BEGIN
  -- Insert rows in the table.
  v_LastNames(43) := 'Mason';
  v_LastNames(50) := 'Junebug';
  v_LastNames(47) := 'Taller';

  -- Assigns 43 to v_Index.
  v_Index := v_LastNames.FIRST;

  -- Assigns 50 to v_Index.
  v_Index := v_LastNames.LAST;
END;
/
