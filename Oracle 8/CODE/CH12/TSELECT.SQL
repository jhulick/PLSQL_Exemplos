REM tselect.sql
REM Version 1.0, last updated 8/5/97
REM This block illustrates the use of nested tables in a SELECT statement, as
REM described in Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET serveroutput on FORMAT truncate

DECLARE
  v_Books course_material.required_reading%TYPE;
  v_Course course_material.course%TYPE;
  v_Department course_material.department%TYPE;

  CURSOR c_AllBooks IS
    SELECT required_reading, course, department
      FROM course_material;
BEGIN
  -- Loop over all the courses, and print out (using DBMS_OUTPUT)
  -- the required book titles.
  OPEN c_AllBooks;

  LOOP
    -- Fetch all the columns in this row, including the entire
    -- nested table stored in required_reading.
    FETCH c_AllBooks INTO v_Books, v_Course, v_Department;
    EXIT WHEN c_AllBooks%NOTFOUND;

    DBMS_OUTPUT.PUT('Required reading for ' || v_Department || ' ');
    DBMS_OUTPUT.PUT_LINE(v_Course || ':');

    -- Loop over the entire selected table, printing out each row.
    FOR v_Index IN 1..v_Books.COUNT LOOP
      DBMS_OUTPUT.PUT_LINE('  ' || v_Books(v_Index).title);
    END LOOP;
  END LOOP;

  CLOSE c_AllBooks;
END;
/

