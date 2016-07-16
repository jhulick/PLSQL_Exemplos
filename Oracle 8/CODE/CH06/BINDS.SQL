REM binds.sql
REM Version 1.0, last updated 4/29/97
REM This block illustrates cursor bind variables, as described in
REM Chapter 6 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_RoomID      classes.room_id%TYPE;
  v_Building    rooms.building%TYPE;
  v_Department  classes.department%TYPE;
  v_Course      classes.course%TYPE;
  CURSOR c_Buildings IS
    SELECT building
      from rooms, classes
      where rooms.room_id = classes.room_id
      and department = v_Department
      and course = v_Course;
BEGIN
  -- Assign to bind variables before the cursor OPEN.
  v_Department := 'HIS';
  v_Course := 101;

  -- Open the cursor.
  OPEN c_Buildings;

  -- Reassign the bind variables - this has no effect,
  -- since the cursor is already open.
  v_Department := 'XXX';
  v_Course := -1;
END;
/
