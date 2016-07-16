REM copyRS.sql
REM Version 1.0, last updated 5/21/97
REM This procedure illustrates the array processing features of DBMS_SQL
REM available with Oracle8, described in Chapter 15
REM of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE CopyRegisteredStudents(
  p_NewName IN VARCHAR2) AS
  /* Creates a new table, with a name given by p_NewName, with the
     same structure as registered_students.  The contents of
     registered_students are then read into PL/SQL tables, and inserted
     into the new table. */

  v_BatchSize CONSTANT INTEGER := 5;
  v_IDs DBMS_SQL.NUMBER_TABLE;
  v_Departments DBMS_SQL.VARCHAR2_TABLE;
  v_Courses DBMS_SQL.NUMBER_TABLE;
  v_Grades DBMS_SQL.VARCHAR2_TABLE;

  v_Cursor1 INTEGER;
  v_Cursor2 INTEGER;
  v_ReturnCode INTEGER;
  v_NumRows INTEGER;
  v_SQLStatement VARCHAR2(200);
  v_SelectStmt VARCHAR2(200);
  v_InsertStmt VARCHAR2(200);

BEGIN
  v_Cursor1 := DBMS_SQL.OPEN_CURSOR;
  v_Cursor2 := DBMS_SQL.OPEN_CURSOR;

  -- First drop the new table.  Ignore ORA-942 (table or view does not
  -- exist) error.
  BEGIN
    v_SQLStatement := 'DROP TABLE ' || p_NewName;
    DBMS_SQL.PARSE(v_Cursor1, v_SQLStatement, DBMS_SQL.V7);
    v_ReturnCode := DBMS_SQL.EXECUTE(v_Cursor1);
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
        RAISE;
      END IF;
  END;

  -- Create the new table.
  v_SQLStatement := 'CREATE TABLE ' || p_NewName || '(';
  v_SQLStatement := v_SQLStatement || 'student_id NUMBER(5),';
  v_SQLStatement := v_SQLStatement || 'department CHAR(3),';
  v_SQLStatement := v_SQLStatement || 'course NUMBER(3),';
  v_SQLStatement := v_SQLStatement || 'grade CHAR(1))';
  DBMS_SQL.PARSE(v_Cursor1, v_SQLStatement, DBMS_SQL.V7);
  v_ReturnCode := DBMS_SQL.EXECUTE(v_Cursor1);

  -- Parse both the select and insert statements.
  v_SelectStmt := 'SELECT * FROM registered_students';
  v_InsertStmt := 'INSERT INTO ' || p_NewName || ' VALUES ';
  v_InsertStmt := v_InsertStmt || '(:ID, :department, :course, :grade)';
  DBMS_SQL.PARSE(v_Cursor1, v_SelectStmt, DBMS_SQL.V7);
  DBMS_SQL.PARSE(v_Cursor2, v_InsertStmt, DBMS_SQL.V7);

  -- Use DEFINE_ARRAY to specify the output variables for the select.
  DBMS_SQL.DEFINE_ARRAY(v_Cursor1, 1, v_IDs, v_BatchSize, 1);
  DBMS_SQL.DEFINE_ARRAY(v_Cursor1, 2, v_Departments, v_BatchSize, 1);
  DBMS_SQL.DEFINE_ARRAY(v_Cursor1, 3, v_Courses, v_BatchSize, 1);
  DBMS_SQL.DEFINE_ARRAY(v_Cursor1, 4, v_Grades, v_BatchSize, 1);

  -- Execute the select statment.
  v_ReturnCode := DBMS_SQL.EXECUTE(v_Cursor1);

  -- This is the fetch loop.  Each call to FETCH_ROWS will retreive
  -- v_BatchSize rows of data.  The loop is over when FETCH_ROWS
  -- returns a value < v_BatchSize.
  LOOP
    v_NumRows := DBMS_SQL.FETCH_ROWS(v_Cursor1);
    DBMS_SQL.COLUMN_VALUE(v_Cursor1, 1, v_IDs);
    DBMS_SQL.COLUMN_VALUE(v_Cursor1, 2, v_Departments);
    DBMS_SQL.COLUMN_VALUE(v_Cursor1, 3, v_Courses);
    DBMS_SQL.COLUMN_VALUE(v_Cursor1, 4, v_Grades);

    -- If this is the last fetch, then FETCH_ROWS will return less than
    -- v_BatchSize rows.  However, there could still be rows returned,
    -- and there are exactly v_NumRows number of them.  Thus we need to
    -- use v_NumRows instead of v_BatchSize in these binds.

    -- The special case of v_NumRows = 0 needs to be checked here.  This
    -- means that the previous fetch returned all the remaining rows
    -- and therefore we are done with the loop.
    IF v_NumRows = 0 THEN
      EXIT;
    END IF;

    -- Use BIND_ARRAY to specify the input variables for the insert.
    -- Only elements 1..v_NumRows will be used.
    DBMS_SQL.BIND_ARRAY(v_Cursor2, ':ID', v_IDs, 1, v_NumRows);
    DBMS_SQL.BIND_ARRAY(v_Cursor2, ':department', v_Departments, 1,
                        v_NumRows);
    DBMS_SQL.BIND_ARRAY(v_Cursor2, ':course', v_Courses, 1, v_NumRows);
    DBMS_SQL.BIND_ARRAY(v_Cursor2, ':grade', v_Grades, 1, v_NumRows);

    -- Execute the insert statement.
    v_ReturnCode := DBMS_SQL.EXECUTE(v_Cursor2);

    -- Exit condition for the loop.  Note that the loop processing has
    -- been done before we check this.
    EXIT WHEN v_NumRows < v_BatchSize;
  END LOOP;

  COMMIT;

  DBMS_SQL.CLOSE_CURSOR(v_Cursor1);
  DBMS_SQL.CLOSE_CURSOR(v_Cursor2);
END CopyRegisteredStudents;
/
