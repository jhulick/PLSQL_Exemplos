REM commit1.sql
REM Version 1.0, last updated 4/7/97
REM This block will raise "ORA-1002: fetch out of sequence" because
REM of the commit inside the SELECT..FOR UPDATE loop, as described in
REM Chapter 6 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  -- Cursor to retrieve all students, and lock the rows as well.
  CURSOR c_AllStudents IS
    SELECT *
      FROM students
      FOR UPDATE;

  -- Variable for retrieved data.
  v_StudentInfo  c_AllStudents%ROWTYPE;
BEGIN
  -- Open the cursor. This will acquire the locks.
  OPEN c_AllStudents;

  -- Retrieve the first record.
  FETCH c_AllStudents INTO v_StudentInfo;

  -- Issue a COMMIT. This will release the locks, invalidating the
  -- cursor.
  COMMIT WORK;

  -- This FETCH will raise the ORA-1002 error.
  FETCH c_AllStudents INTO v_StudentInfo;
END;
/
