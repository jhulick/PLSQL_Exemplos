REM error.sql
REM Version 1.0, last updated 5/6/97
REM This script illustrates the behavior of procedure parameters if an
REM unhandled exception is raised, as described in Chapter 7
REM of _Oracle8 PL/SQL Programming_ by Scott Urman.

PROMPT Creating RaiseError...
CREATE OR REPLACE PROCEDURE RaiseError (
  /* Illustrates the behavior of unhandled exceptions and
     OUT variables. If p_Raise is TRUE, then an unhandled
     error is raised. If p_Raise is FALSE, the procedure
     completes successfully. */
  p_Raise IN BOOLEAN := TRUE,
  p_ParameterA OUT NUMBER) AS
BEGIN
  p_ParameterA := 7;

  IF p_Raise THEN
    /* Even though we have assigned 7 to p_ParameterA, this
       unhandled exception causes control to return immediately
       without returning 7 to the actual parameter associated 
       with p_ParameterA. */
    RAISE DUP_VAL_ON_INDEX;
  ELSE
    /* Simply return with no error. This will return 7 to the
       actual parameter. */
    RETURN;
  END IF;
END RaiseError;
/

PROMPT Calling RaiseError...
DECLARE
  v_TempVar NUMBER := 1;
BEGIN
  INSERT INTO temp_table (num_col, char_col)
    VALUES (v_TempVar, 'Initial value');
  RaiseError(FALSE, v_TempVar);

  INSERT INTO temp_table (num_col, char_col)
    VALUES (v_TempVar, 'Value after successful call');

  v_TempVar := 2;
  INSERT INTO temp_table (num_col, char_col)
    VALUES (v_TempVar, 'Value before 2nd call');
  RaiseError(TRUE, v_TempVar);
EXCEPTION
  WHEN OTHERS THEN
    INSERT INTO temp_table (num_col, char_col)
      VALUES (v_TempVar, 'Value after unsuccessful call');
END;
/

SELECT * FROM temp_table;
