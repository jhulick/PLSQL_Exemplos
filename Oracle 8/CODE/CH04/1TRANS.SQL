REM 1trans.sql
REM Version 1.0, last updated 4/27/97
REM This script illustrates 1 transaction spanning over a 
REM PL/SQL block, as described in Chapter 4 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

INSERT INTO classes
   (department, course, description, max_students, 
    current_students, num_credits, room_id) 
  VALUES ('CS', 101, 'Computer Science 101', 50, 10, 4, 99998);
BEGIN
  UPDATE rooms
    SET room_id = room_id - 1000;
  ROLLBACK WORK;
END;
/
