REM refop.sql
REM Version 1.0, last updated 8/8/97
REM This block demonstrates the REF and DEREF operators, as described in
REM Chapter 11 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_RoomRef REF RoomObj;
  v_Room    RoomObj;
BEGIN
  -- Select a reference to the room, not the room itself.
  SELECT REF(r)
    INTO v_RoomRef
    FROM rooms r
    WHERE ID = 99993;

  -- Dereference v_RoomRef to get an object, and update it.
  -- This will return a local object, which is not the same
  -- as the object stored in the rooms table.
  SELECT DEREF(v_RoomRef)
    INTO v_Room
    FROM dual;

  -- This updates the local object.
  v_Room.room_number := 201;
END;
/

