REM bindvar.sql
REM Version 1.0, last updated 4/9/97
REM This block illustrates a bind variable, as described in 
REM Chapter 4 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_NumCredits  classes.num_credits%TYPE;
BEGIN
  /* Assign to v_NumCredits */
  v_NumCredits := 3;
  UPDATE CLASSES
    SET num_credits = v_NumCredits
    WHERE department = 'HIS'
    AND course = 101;
END;
/
