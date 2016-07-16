REM forloop.sql
REM Version 1.0, last updated 4/7/97
REM This block illustrates a cursor FOR loop, as described in
REM Chapter 6 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  -- Cursor to retrieve the information about History students
  CURSOR c_HistoryStudents IS
    SELECT id, first_name, last_name
      FROM students
      WHERE major = 'History';
BEGIN
  -- Begin the loop. An implicit OPEN of c_HistoryStudents
  -- is done here.
  FOR v_StudentData IN c_HistoryStudents LOOP
    -- An implicit FETCH is done here.

    -- Process the fetched rows, in this case sign up each
    -- student for History 301 by inserting them into the 
    -- registered_students table. Record the first and last
    -- names in temp_table as well.
    INSERT INTO registered_students (student_id, department, course)
      VALUES (v_StudentData.ID, 'HIS', 301);

    INSERT INTO temp_table (num_col, char_col)
      VALUES (v_StudentData.ID,
              v_StudentData.first_name || ' ' || v_StudentData.last_name);

    -- Before the loop will continue, an implicit check of
    -- c_HistoryStudents%NOTFOUND is done here.
  END LOOP;
  -- Now that the loop is finished, an implicit CLOSE of 
  -- c_HistoryStudents is done.

  -- Commit our work.
  COMMIT;
END;
/
