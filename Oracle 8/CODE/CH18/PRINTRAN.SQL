REM printran.sql
REM Version 1.0, last updated 7/13/97
REM This procedure uses UTL_FILE to print student transcripts, as described in
REM Chapter 18 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE PrintTranscript (
  /* Outputs a transcript for the indicated student. The
     transcript will consist of the classes for which the
     student is currently registered and the grade received
     for each class. At the end of the transcript, the student's
     GPA is output. */
  p_StudentID IN students.ID%TYPE,
  p_FileDir IN VARCHAR2,
  p_FileName IN VARCHAR2) AS

  v_StudentGPA NUMBER;
  v_StudentRecord  students%ROWTYPE;
  v_FileHandle UTL_FILE.FILE_TYPE;
  v_NumCredits NUMBER;

  CURSOR c_CurrentClasses IS
    SELECT *
      FROM registered_students
      WHERE student_id = p_StudentID;

BEGIN
  -- Open the output file in append mode.
  v_FileHandle := UTL_FILE.FOPEN(p_FileDir, p_FileName, 'w');

  SELECT *
    INTO v_StudentRecord
    FROM students
    WHERE ID = p_StudentID;

  -- Output header information.  This consists of the current
  -- date and time, and information about this student.

  UTL_FILE.PUTF(v_FileHandle, 'Student ID: %s\n',
    v_StudentRecord.ID);
  UTL_FILE.PUTF(v_FileHandle, 'Student Name: %s %s\n',
    v_StudentRecord.first_name, v_StudentRecord.last_name);
  UTL_FILE.PUTF(v_FileHandle, 'Major: %s\n',
    v_StudentRecord.major);
  UTL_FILE.PUTF(v_FileHandle, 'Transcript Printed on: %s\n\n\n',
    TO_CHAR(SYSDATE, 'Mon DD,YYYY HH24:MI:SS'));

  UTL_FILE.PUT_LINE(v_FileHandle, 'Class   Credits Grade');
  UTL_FILE.PUT_LINE(v_FileHandle, '------- ------- -----');
  FOR v_ClassesRecord in c_CurrentClasses LOOP
    -- Determine the number of credits for this class.
    SELECT num_credits
      INTO v_NumCredits
      FROM classes
      WHERE course = v_ClassesRecord.course
      AND department = v_ClassesRecord.department;

    -- Output the info for this class.
    UTL_FILE.PUTF(v_FileHandle, '%s %s %s\n',
      RPAD(v_ClassesRecord.department || ' '  ||
           v_ClassesRecord.course, 7),
      LPAD(v_NumCredits, 7),
      LPAD(v_ClassesRecord.grade, 5));
  END LOOP;

  -- Determine the GPA.
  CalculateGPA(p_StudentID, v_StudentGPA);

  -- Output the GPA.
  UTL_FILE.PUTF(v_FileHandle, '\n\nCurrent GPA: %s\n',
    TO_CHAR(v_StudentGPA, '9.99'));

  -- Close the file.
  UTL_FILE.FCLOSE(v_FileHandle);

EXCEPTION
  -- Handle the UTL_FILE exceptions meaningfully, and make sure
  -- that the file is properly closed.
  WHEN UTL_FILE.INVALID_OPERATION THEN
    UTL_FILE.FCLOSE(v_FileHandle);
    RAISE_APPLICATION_ERROR(-20061,
                            'PrintTranscript: Invalid Operation');
  WHEN UTL_FILE.INVALID_FILEHANDLE THEN
    UTL_FILE.FCLOSE(v_FileHandle);
    RAISE_APPLICATION_ERROR(-20062,
                            'PrintTranscript: Invalid File Handle');
  WHEN UTL_FILE.WRITE_ERROR THEN
    UTL_FILE.FCLOSE(v_FileHandle);
    RAISE_APPLICATION_ERROR(-20063,
                            'PrintTranscript: Write Error');
  WHEN OTHERS THEN
    UTL_FILE.FCLOSE(v_FileHandle);
    RAISE;
END PrintTranscript;
/
