REM exitwhen.sql
REM Version 1.0, last updated 4/7/97
REM This block illustrates an incorrect usage of the EXIT WHEN statement,
REM as described in Chapter 6 of _Oracle8 PL/SQL Programming_
REM by Scott Urman.

DECLARE
  -- Declare variables to hold information about the students
  -- majoring in History.
  v_StudentID   students.id%TYPE;
  v_FirstName   students.first_name%TYPE;
  v_LastName    students.last_name%TYPE;

  -- Cursor to retrieve the information about History students
  CURSOR c_HistoryStudents IS
    SELECT id, first_name, last_name
      FROM students
      WHERE major = 'History';
BEGIN
  -- Open the cursor and initialize the active set
  OPEN c_HistoryStudents;
  LOOP
    -- Retrieve information for the next student
    FETCH c_HistoryStudents INTO v_StudentID, v_FirstName, v_LastName;

    -- Process the fetched rows, in this case sign up each
    -- student for History 301 by inserting them into the 
    -- registered_students table. Record the first and last
    -- names in temp_table as well.
    INSERT INTO registered_students (student_id, department, course)
      VALUES (v_StudentID, 'HIS', 301);

    INSERT INTO temp_table (num_col, char_col)
      VALUES (v_StudentID, v_FirstName || ' ' || v_LastName);

    -- Exit loop when there are no more rows to fetch
    EXIT WHEN c_HistoryStudents%NOTFOUND;

  END LOOP;

  -- Free resources used by the cursor
  CLOSE c_HistoryStudents;

  -- Commit our work
  COMMIT;
END;
/
