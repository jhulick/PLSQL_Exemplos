REM loadstud.sql
REM Version 1.0, last updated 7/13/97
REM The LoadStudents procedure uses UTL_FILE to load the students table from
REM an operating system file, as described in Chapter 18 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE LoadStudents (
  /* Loads the students table by reading a comma-delimited file.
     The file should have lines that look like:

     first_name,last_name,major

     The student ID is generated from student_sequence.
     The total number of rows inserted is returned by
     p_TotalInserted. */
  p_FileDir  IN VARCHAR2,
  p_FileName IN VARCHAR2,
  p_TotalInserted IN OUT NUMBER) AS

  v_FileHandle UTL_FILE.FILE_TYPE;
  v_NewLine  VARCHAR2(100);  -- Input line
  v_FirstName students.first_name%TYPE;
  v_LastName students.last_name%TYPE;
  v_Major students.major%TYPE;
  /* Positions of commas within input line. */
  v_FirstComma NUMBER;
  v_SecondComma NUMBER;

BEGIN
  -- Open the specified file for reading.
  v_FileHandle := UTL_FILE.FOPEN(p_FileDir, p_FileName, 'r');

  -- Initialize the output number of students.
  p_TotalInserted := 0;

  -- Loop over the file, reading in each line.  GET_LINE will
  -- raise NO_DATA_FOUND when it is done, so we use that as the
  -- exit condition for the loop.
  LOOP
    BEGIN
      UTL_FILE.GET_LINE(v_FileHandle, v_NewLine);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        EXIT;
    END;

    -- Each field in the input record is delimited by commas.  We
    -- need to find the locations of the two commas in the line
    -- and use these locations to get the fields from v_NewLine.
    -- Use INSTR to find the locations of the commas.
    v_FirstComma := INSTR(v_NewLine, ',', 1, 1);
    v_SecondComma := INSTR(v_NewLine, ',', 1, 2);

    -- Now we can use SUBSTR to extract the fields.
    v_FirstName := SUBSTR(v_NewLine, 1, v_FirstComma - 1);
    v_LastName := SUBSTR(v_NewLine, v_FirstComma + 1,
                         v_SecondComma - v_FirstComma - 1);
    v_Major := SUBSTR(v_NewLine, v_SecondComma + 1);

    -- Insert the new record into students.
    INSERT INTO students (ID, first_name, last_name, major)
      VALUES (student_sequence.nextval, v_FirstName,
              v_LastName, v_Major);

    p_TotalInserted := p_TotalInserted + 1;
  END LOOP;

  -- Close the file.
  UTL_FILE.FCLOSE(v_FileHandle);

  COMMIT;
EXCEPTION
  -- Handle the UTL_FILE exceptions meaningfully, and make sure
  -- that the file is properly closed.
  WHEN UTL_FILE.INVALID_OPERATION THEN
    UTL_FILE.FCLOSE(v_FileHandle);
    RAISE_APPLICATION_ERROR(-20051,
                            'LoadStudents: Invalid Operation');
  WHEN UTL_FILE.INVALID_FILEHANDLE THEN
    UTL_FILE.FCLOSE(v_FileHandle);
    RAISE_APPLICATION_ERROR(-20052,
                            'LoadStudents: Invalid File Handle');
  WHEN UTL_FILE.READ_ERROR THEN
    UTL_FILE.FCLOSE(v_FileHandle);
    RAISE_APPLICATION_ERROR(-20053,
                            'LoadStudents: Read Error');
  WHEN OTHERS THEN
    UTL_FILE.FCLOSE(v_FileHandle);
    RAISE;
END LoadStudents;
/
