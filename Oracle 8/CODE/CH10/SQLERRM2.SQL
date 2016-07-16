REM sqlerrm2.sql
REM Version 1.0, last updated date
REM This example illustrates different uses of the SQLERRM function, as
REM described in Chapter 10 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_ErrorText   log_table.message%TYPE;  -- Variable to hold error message text
BEGIN
  /* SQLERRM(0) */
  v_ErrorText := SUBSTR(SQLERRM(0), 1, 200);
  INSERT INTO log_table (code, message, info)
    VALUES (0, v_ErrorText, 'SQLERRM(0)');

  /* SQLERRM(100) */
  v_ErrorText := SUBSTR(SQLERRM(100), 1, 200);
  INSERT INTO log_table (code, message, info)
    VALUES (100, v_ErrorText, 'SQLERRM(100)');

  /* SQLERRM(10) */
  v_ErrorText := SUBSTR(SQLERRM(10), 1, 200);
  INSERT INTO log_table (code, message, info)
    VALUES (10, v_ErrorText, 'SQLERRM(10)');

  /* SQLERRM with no argument */
  v_ErrorText := SUBSTR(SQLERRM, 1, 200);
  INSERT INTO log_table (code, message, info)
    VALUES (NULL, v_ErrorText, 'SQLERRM with no argument');

  /* SQLERRM(-1) */
  v_ErrorText := SUBSTR(SQLERRM(-1), 1, 200);
  INSERT INTO log_table (code, message, info)
    VALUES (-1, v_ErrorText, 'SQLERRM(-1)');

  /* SQLERRM(-54) */
  v_ErrorText := SUBSTR(SQLERRM(-54), 1, 200);
  INSERT INTO log_table (code, message, info)
    VALUES (-54, v_ErrorText, 'SQLERRM(-54)');

END; 
/
