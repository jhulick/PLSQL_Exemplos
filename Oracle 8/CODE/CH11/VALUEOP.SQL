REM valueop.sql
REM Version 1.0, last updated 8/8/97
REM This block demonstrates the VALUE operator, as described in
REM Chapter 11 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_RoomID      rooms.id%TYPE;
  v_Building    rooms.building%TYPE;
  v_RoomNumber  rooms.room_number%TYPE;
  v_NumberSeats rooms.number_seats%TYPE;
  v_Description rooms.description%TYPE;
  v_RoomObj     RoomObj;
BEGIN
  -- SELECT without using VALUE.  This is just like a relational
  -- query.
  SELECT *
    INTO v_RoomID, v_Building, v_RoomNumber, v_NumberSeats, v_Description
    FROM rooms r
    WHERE ID = 99993;

  -- SELECT using VALUE.  In this case, we retrieve a RoomObj.
  SELECT VALUE(r)
    INTO v_RoomObj
    FROM rooms r
    WHERE ID = 99993;
END;
/

