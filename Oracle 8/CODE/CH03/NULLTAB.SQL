REM nulltab.sql
REM Version 1.0, last updated 4/30/97
REM This block illustrates deleting all the rows in a table by assigning
REM a NULL table to it, as described in Chapter 3 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  TYPE t_NameTable IS TABLE OF students.first_name%TYPE
    INDEX BY BINARY_INTEGER;
  v_Names t_NameTable;
  v_EmptyTable t_NameTable;
BEGIN
  /* Assign some rows to v_Names. */
  v_Names(1) := 'Scott';
  v_Names(2) := 'Lefty';
  v_Names(3) := 'Susan';
  /* Delete everything in v_Names */
  v_Names := v_EmptyTable;
END;
/
