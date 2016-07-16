REM cursor2.sql
REM Version 1.0, last updated 4/7/97
REM The ShowCursorVariable procedure illustrates the use of cursor variables
REM with PL/SQL 2.3 and higher, as described in Chapter 6 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE ShowCursorVariable
  /* Demonstrates the use of a cursor variable on the server.
     If p_Table is 'classes', then information from the classes
     table is inserted into temp_table.  If p_Table is 'rooms'
     then information from rooms is inserted. */
  (p_Table IN VARCHAR2) AS

  /* Define the cursor variable type */
  TYPE t_ClassesRooms IS REF CURSOR;

  /* and the variable itself. */
  v_CursorVar t_ClassesRooms;

  /* Variables to hold the output. */
  v_Department  classes.department%TYPE;
  v_Course      classes.course%TYPE;
  v_RoomID      rooms.room_id%TYPE;
  v_Description rooms.description%TYPE;
BEGIN
  -- Based on the input parameter, open the cursor variable.
  IF p_Table = 'classes' THEN
    OPEN v_CursorVar FOR
      SELECT department, course
        FROM classes;
  ELSIF p_table = 'rooms' THEN
    OPEN v_CursorVar FOR
      SELECT room_id, description
        FROM rooms;
  ELSE
    /* Wrong value passed as input - raise an error */
    RAISE_APPLICATION_ERROR(-20000,
      'Input must be ''classes'' or ''rooms''');
  END IF;

  /* Fetch loop.  Note the EXIT WHEN clause after the FETCH -
     with PL/SQL 2.3 we can use cursor attributes with cursor
     variables. */
  LOOP
    IF p_Table = 'classes' THEN
      FETCH v_CursorVar INTO
        v_Department, v_Course;
      EXIT WHEN v_CursorVar%NOTFOUND;

      INSERT INTO temp_table (num_col, char_col)
        VALUES (v_Course, v_Department);
    ELSE
      FETCH v_CursorVar INTO
        v_RoomID, v_Description;
      EXIT WHEN v_CursorVAR%NOTFOUND;

      INSERT INTO temp_table (num_col, char_col)
        VALUES (v_RoomID, SUBSTR(v_Description, 1, 60));
    END IF;
  END LOOP;

  /* Close the cursor. */
  CLOSE v_CursorVar;

  COMMIT;
END ShowCursorVariable;
/
