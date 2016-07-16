REM local.sql
REM Version 1.0, last updated 5/6/97
REM This block contains a local function, as described in
REM Chapter 7 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  CURSOR c_AllStudents IS
    SELECT first_name, last_name
      FROM students;

  v_FormattedName VARCHAR2(50);

  /* Function which will return the first and last name
     concatenated together, separated by a space. */
  FUNCTION FormatName(p_FirstName IN VARCHAR2,
                      p_LastName IN VARCHAR2)
    RETURN VARCHAR2 IS
  BEGIN
    RETURN p_FirstName || ' ' || p_LastName;
  END FormatName;

-- Begin main block.
BEGIN
  FOR v_StudentRecord IN c_AllStudents LOOP
    v_FormattedName := 
      FormatName(v_StudentRecord.first_name, 
                 v_StudentRecord.last_name);  
    INSERT INTO temp_table (char_col)
      VALUES (v_FormattedName);
  END LOOP;

  COMMIT;
END;
/
