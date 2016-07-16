REM select.sql
REM Version 1.0, last updated 4/9/97
REM This block illustrates two SELECT statements, as described in
REM Chapter 4 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_StudentRecord  students%ROWTYPE;
  v_Department     classes.department%TYPE;
  v_Course         classes.course%TYPE;
BEGIN
  -- Retrieve one record from the students table, and store it
  -- in v_StudentRecord. Note that the WHERE clause will only
  -- match one row in the table.
  -- Note also that the query is returning all of the fields in
  -- the students table (since we are selecting *). Thus the
  -- record into which we fetch is defined as students%ROWTYPE.
  SELECT *
    INTO v_StudentRecord
    FROM students
    WHERE id = 10000;

  -- Retrieve two fields from the classes table, and store them
  -- in v_Department and v_Course. Again, the WHERE clause will
  -- only match one row in the table.
  SELECT department, course
    INTO v_Department, v_Course
    FROM classes
    WHERE room_id = 99997;
END;
/

