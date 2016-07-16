REM rfclass.sql
REM Version 1.0, last updated 5/6/97
REM This procedure is used to illustrate subprogram dependencies, as 
REM described in Chapter 7 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE RecordFullClasses AS
  CURSOR c_Classes IS
    SELECT department, course
      FROM classes;
BEGIN
  FOR v_ClassRecord IN c_Classes LOOP
    -- Record all classes which don't have very much room left
    -- in temp_table.
    IF AlmostFull(v_ClassRecord.department, v_ClassRecord.course) THEN
      INSERT INTO temp_table (char_col) VALUES
        (v_ClassRecord.department || ' ' || v_ClassRecord.course ||
         ' is almost full!');
    END IF;
  END LOOP;
END RecordFullClasses;
/
