REM cursor.sql
REM Version 1.0, last updated 6/3/97
REM This block illustrates a cursor FOR loop, as described in
REM Chapter 1 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_FirstName VARCHAR2(20);
  v_LastName  VARCHAR2(20);
  -- Cursor declaration.  This defines the SQL statement to
  -- return the rows.
  CURSOR c_Students IS
    SELECT first_name, last_name
      FROM students;
BEGIN
  -- Begin cursor processing.
  OPEN c_Students;
  LOOP
    -- Retreive one row.
    FETCH c_Students INTO v_FirstName, v_LastName;
    -- Exit the loop after all rows have been retreived.
    EXIT WHEN c_Students%NOTFOUND;
    /* Process data here */
  END LOOP;
  -- End processing.
  CLOSE c_Students;
END;
/
