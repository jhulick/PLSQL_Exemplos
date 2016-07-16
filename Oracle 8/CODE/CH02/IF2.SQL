REM if2.sql
REM Version 1.0, last updated 5/7/97
REM This block illustrates an IF statement with multiple procedural statements within
REM it, as described in Chapter 2 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_NumberSeats rooms.number_seats%TYPE;
  v_Comment VARCHAR2(35);
BEGIN
  /* Retrieve the number of seats in the room identified by ID 99999.
     Store the result in v_NumberSeats. */
  SELECT number_seats
    INTO v_NumberSeats
    FROM rooms
    WHERE room_id = 99999;
  IF v_NumberSeats < 50 THEN
    v_Comment := 'Fairly small';
    INSERT INTO temp_table (char_col)
      VALUES ('Nice and cozy');
  ELSIF v_NumberSeats < 100 THEN
    v_Comment := 'A little bigger';
    INSERT INTO temp_table (char_col)
      VALUES ('Some breathing room');
  ELSE
    v_Comment := 'Lots of room';
  END IF;
END;
/
