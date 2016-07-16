REM nomatch1.sql
REM Version 1.0, last updated 4/7/97
REM This block demonstrates using SQL%NOTFOUND to test if an UPDATE
REM statement matched any rows, as described in Chapter 6 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

BEGIN
  UPDATE rooms
    SET number_seats = 100
    WHERE room_id = 99980;
  -- If the previous UPDATE statement didn't match any rows, 
  -- insert a new row into the rooms table.
  IF SQL%NOTFOUND THEN
    INSERT INTO rooms (room_id, number_seats)
      VALUES (99980, 100);
  END IF;
END;
/
