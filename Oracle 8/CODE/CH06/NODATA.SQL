REM nodata.sql
REM Version 1.0, last updated 4/7/97
REM This block illustrates the NO_DATA_FOUND exception handler, versus
REM SQL%NOTFOUND, as described in Chapter 6 of _Oracle8 PL/SQL
REM Programming_ by Scott Urman.

DECLARE
  -- Record to hold room information.
  v_RoomData   rooms%ROWTYPE;
BEGIN
  -- Retrieve information about room ID -1.
  SELECT *
    INTO v_RoomData
    FROM rooms
    WHERE room_id = -1;

  -- The following statement will never be executed, since
  -- control passes immediately to the exception handler.
  IF SQL%NOTFOUND THEN
    INSERT INTO temp_table (char_col)
      VALUES ('Not found!');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    INSERT INTO temp_table (char_col)
      VALUES ('Not found, exception handler');
END;
/
