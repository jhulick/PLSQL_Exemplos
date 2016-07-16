REM instead.sql
REM Version 1.0, last updated 5/1/97
REM This script illustrates the use of an instead-of trigger, which is
REM valid in Oracle8 and higher.  This is discussed in 
REM Chapter 9 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE VIEW room_summary AS
  SELECT building, sum(number_seats) total_seats
    FROM rooms
	GROUP BY building;
	
CREATE TRIGGER room_summary_delete
  INSTEAD OF DELETE ON room_summary
  FOR EACH ROW
BEGIN
  -- Delete all of the rows in rooms which match this single row
  -- in room_summary
  DELETE FROM rooms
    WHERE building = :old.building;
END room_summary_delete;
/
