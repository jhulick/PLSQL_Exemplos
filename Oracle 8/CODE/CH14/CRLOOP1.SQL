REM crloop11.sql
REM Version 1.0, last updated 5/15/97
REM This is the first version of the CreditLoop procedure, as described in
REM Chapter 14 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE CreditLoop AS
  /* Inserts the student ID numbers and their current credit
     values into temp_table. */
  v_StudentID students.ID%TYPE;
  v_Credits   students.current_credits%TYPE;
  CURSOR c_Students IS
    SELECT ID
      FROM students;
BEGIN
  OPEN c_Students;
  LOOP
    FETCH c_Students INTO v_StudentID;
    v_Credits := CountCredits(v_StudentID);
    INSERT INTO temp_table (num_col, char_col)
      VALUES (v_StudentID, 'Credits = ' || TO_CHAR(v_Credits));
    EXIT WHEN c_Students%NOTFOUND;
  END LOOP;
  CLOSE c_Students;
END CreditLoop;
/
