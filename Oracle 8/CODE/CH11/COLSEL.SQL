REM colsel.sql
REM Version 1.0, last updated 8/8/97
REM This script demonstrates the behavior of column objects in queries, as
REM described in Chapter 11 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET SERVEROUTPUT on
DECLARE
  v_Student StudentObj;
  v_Address AddressObj;

  CURSOR c_Students IS
    SELECT student, address
      FROM students;
BEGIN
  -- Print out the ID's of all students.
  OPEN c_Students;

  LOOP
    FETCH c_Students INTO v_Student, v_Address;
    EXIT WHEN c_Students%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('Student ID: ' || v_Student.ID);
  END LOOP;

  CLOSE c_Students;
END;
/

DECLARE
  v_Student StudentObj;
BEGIN
  -- Raises PLS-327
  SELECT student
    INTO v_Student
    FROM students
    WHERE students.student.ID = 10009;
END;
/

DECLARE
  v_Student StudentObj;
BEGIN
  -- Succeeds, because of the table alias
  SELECT student
    INTO v_Student
    FROM students s
    WHERE s.student.ID = 10009;
END;
/

