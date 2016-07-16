REM dquery.sql
REM Version 1.0, last updated 5/21/97
REM This procedure illustrates using DBMS_SQL to execute queries, as
REM described in Chapter 15 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE DynamicQuery (
  /* Uses DBMS_SQL to query the students table, and puts the
     results in temp_table. The first names, last names, and
     majors are inserted for up to two majors inputted. */
  p_Major1 IN students.major%TYPE DEFAULT NULL,
  p_Major2 IN students.major%TYPE DEFAULT NULL) AS

  v_CursorID   INTEGER;
  v_SelectStmt VARCHAR2(500);
  v_FirstName  students.first_name%TYPE;
  v_LastName   students.last_name%TYPE;
  v_Major      students.major%TYPE;
  v_Dummy      INTEGER;

BEGIN
  -- Open the cursor for processing.
  v_CursorID := DBMS_SQL.OPEN_CURSOR;

  -- Create the query string.
  v_SelectStmt := 'SELECT first_name, last_name, major
                     FROM students
                     WHERE major IN (:m1, :m2)
                     ORDER BY major, last_name';

  -- Parse the query.
  DBMS_SQL.PARSE(v_CursorID, v_SelectStmt, DBMS_SQL.V7);

  -- Bind the input variables.
  DBMS_SQL.BIND_VARIABLE(v_CursorID, ':m1', p_Major1);
  DBMS_SQL.BIND_VARIABLE(v_CursorID, ':m2', p_Major2);

  -- Define the output variables.
  DBMS_SQL.DEFINE_COLUMN(v_CursorID, 1, v_FirstName, 20);
  DBMS_SQL.DEFINE_COLUMN(v_CursorID, 2, v_LastName, 20);
  DBMS_SQL.DEFINE_COLUMN(v_CursorID, 3, v_Major, 30);

  -- Execute the statement. We don't care about the return
  -- value, but we do need to declare a variable for it.
  v_Dummy := DBMS_SQL.EXECUTE(v_CursorID);

  -- This is the fetch loop.
  LOOP
    -- Fetch the rows into the buffer, and also check for the exit
    -- condition from the loop.
    IF DBMS_SQL.FETCH_ROWS(v_CursorID) = 0 THEN
      EXIT;
    END IF;

    -- Retrieve the rows from the buffer into PL/SQL variables.
    DBMS_SQL.COLUMN_VALUE(v_CursorID, 1, v_FirstName);
    DBMS_SQL.COLUMN_VALUE(v_CursorID, 2, v_LastName);
    DBMS_SQL.COLUMN_VALUE(v_CursorID, 3, v_Major);

    -- Insert the fetched data into temp_table.
    INSERT INTO temp_table (char_col)
      VALUES (v_FirstName || ' ' || v_LastName || ' is a ' ||
              v_Major || ' major.');
  END LOOP;

  -- Close the cursor.
  DBMS_SQL.CLOSE_CURSOR(v_CursorID);

  -- Commit our work.
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    -- Close the cursor, then raise the error again.
    DBMS_SQL.CLOSE_CURSOR(v_CursorID);
    RAISE;
END DynamicQuery;
/
