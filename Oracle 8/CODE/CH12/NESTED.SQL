REM nested.sql
REM Version 1.0, last updated 8/5/97
REM This block illustrates some nested table declarations, as described in
REM Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  -- Define a table type based on an object type.
  TYPE t_ClassesTab IS TABLE OF ClassObj;

  -- A type based on %ROWTYPE.
  TYPE t_StudentsTab IS TABLE OF students%ROWTYPE;

  -- Variables of the above types.
  v_ClassList t_ClassesTab;
  v_StudentList t_StudentsTab;
BEGIN
  -- This assignment will raise COLLECTION_IS_NULL because v_ClassList
  -- is atomically NULL.
  v_ClassList(1) := ClassObj('HIS', 101, 'History 101', 30, 0, 4, NULL);
END;
/

