REM populate.sql
REM Version 1.0, last updated 5/15/97
REM This script will load the source table, used in
REM Chapter 14 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_RandomKey source.key%TYPE;
BEGIN
  -- First fill up the source table with legal values.
  FOR v_Key IN 1..500 LOOP
    INSERT INTO source (key, value)
      VALUES (v_Key, TO_CHAR(v_Key));
  END LOOP;

  -- Now, pick a random number between 1 and 500, and update that
  -- row to an illegal value.
  v_RandomKey := Random.RandMax(500);
  UPDATE source
    SET value = 'Oops, not a number!'
    WHERE key = v_RandomKey;

  COMMIT;
END;
/
