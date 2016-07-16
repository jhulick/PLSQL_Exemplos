REM tdelete.sql
REM Version 1.0, last updated 8/5/97
REM This block illustrates the use of a nested table in a DELETE statement,
REM as described in Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

BEGIN
  -- Remove the required reading for all history courses.
  DELETE FROM course_material
    WHERE department = 'HIS';
END;
/

