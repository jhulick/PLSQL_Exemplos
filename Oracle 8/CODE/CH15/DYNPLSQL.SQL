REM dynPLSQL.sql
REM Version 1.0, last updated 5/21/97
REM This procedure demonstrates using DBMS_SQL to execute an anonymous
REM PL/SQL block, as described in Chapter 15 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE DynamicPLSQL (
  /* Executes a PL/SQL block dynamically. The block
     selects from students, and uses p_StudentID as an
     input placeholder. */
  p_StudentID IN students.ID%TYPE) IS

  v_CursorID  INTEGER;
  v_BlockStr  VARCHAR2(500);
  v_FirstName students.first_name%TYPE;
  v_LastName  students.last_name%TYPE;
  v_Dummy     INTEGER;

BEGIN
  -- Open the cursor for processing.
  v_CursorID := DBMS_SQL.OPEN_CURSOR;

  -- Create the string containing the PL/SQL block.
  -- In this string, the :first_name and :last_name
  -- placeholders are output variables, and :ID is an
  -- input variable.
  v_BlockStr :=
    'BEGIN
       SELECT first_name, last_name
         INTO :first_name, :last_name
         FROM students
         WHERE ID = :ID;
     END;';

  -- Parse the statement.
  DBMS_SQL.PARSE(v_CursorID, v_BlockStr, DBMS_SQL.V7);

  -- Bind the placeholders to the variables. Note that we
  -- do this for both the input and output variables.
  -- We pass the maximum length for :first_name and
  -- :last_name.
  DBMS_SQL.BIND_VARIABLE(v_CursorID, ':first_name', v_FirstName, 20);
  DBMS_SQL.BIND_VARIABLE(v_CursorID, ':last_name', v_LastName, 20);
  DBMS_SQL.BIND_VARIABLE(v_CursorID, ':ID', p_StudentID);

  -- Execute the statement. We don't care about the return
  -- value, but we do need to declare a variable for it.
  v_Dummy := DBMS_SQL.EXECUTE(v_CursorID);

  -- Retrieve the values for the output variables.
  DBMS_SQL.VARIABLE_VALUE(v_CursorID, ':first_name', v_FirstName);
  DBMS_SQL.VARIABLE_VALUE(v_CursorID, ':last_name', v_LastName);

  -- Insert them into temp_table.
  INSERT INTO temp_table (num_col, char_col)
    VALUES (p_StudentID, v_FirstName || ' ' || v_LastName);

  -- Close the cursor.
  DBMS_SQL.CLOSE_CURSOR(v_CursorID);

  -- Commit our work.
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    -- Close the cursor, then raise the error again.
    DBMS_SQL.CLOSE_CURSOR(v_CursorID);
    RAISE;
END DynamicPLSQL;
/
