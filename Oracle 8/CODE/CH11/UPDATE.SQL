REM update.sql
REM Version 1.0, last updated 8/8/97
REM This script demonstrates using UPDATE with object types, as described in
REM Chapter 11 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_NewRoom RoomObj :=
    RoomObj(99990, 'Building 7', 200, 50, 'Discussion Room F');
  v_RoomRef REF RoomObj;
BEGIN
  -- The RETURNING clause on this statement puts a reference to the
  -- newly inserted room into v_RoomRef.
  INSERT INTO rooms r VALUES (v_NewRoom)
    RETURNING REF(r) INTO  v_RoomRef;

  UPDATE classes
    SET room = v_RoomRef
    WHERE department = 'NUT' and course = 307;
END;
/
