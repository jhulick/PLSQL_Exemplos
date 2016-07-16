REM update.sql
REM Version 1.0, last updated 4/9/97
REM This block illustrates an UPDATE statement, as described in
REM Chapter 4 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_Major           students.major%TYPE;
  v_CreditIncrease  NUMBER := 3;
BEGIN
  -- This UPDATE statement will add 3 to the current_credits
  -- field of all students who are majoring in History.
  v_Major := 'History';
  UPDATE students
    SET current_credits = current_credits + v_CreditIncrease
    WHERE major = V_Major;
END;
/
