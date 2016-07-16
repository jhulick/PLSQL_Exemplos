REM error.sql
REM Version 1.0, last updated 6/3/97
REM This block demonstrates using an exception section to record errors,
REM as described in Chapter 1 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_ErrorCode NUMBER;          -- Code for the error
  v_ErrorMsg  VARCHAR2(200);   -- Message text for the error
  v_CurrentUser VARCHAR2(8);   -- Current database user
  v_Information VARCHAR2(100); -- Information about the error
BEGIN
  /* Code which processes some data here */
  NULL;
EXCEPTION
  WHEN OTHERS THEN
    -- Assign values to the log variables, using built-in
    -- functions.
    v_ErrorCode := SQLCODE;
    v_ErrorMsg := SQLERRM;
    v_CurrentUser := USER;
    v_Information := 'Error encountered on ' ||
      TO_CHAR(SYSDATE) || ' by database user ' || v_CurrentUser;
    -- Insert the log message into log_table.
    INSERT INTO log_table (code, message, info)
      VALUES (v_ErrorCode, v_ErrorMsg, v_Information);
END;
/
