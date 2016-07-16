REM local2.sql
REM Version 1.0, last updated 5/6/97
REM This script illustrates the illegal location of a local subprogram, as
REM described in Chapter 7 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  /* Declare FormatName first. This will generate a compile
     error, since all other declarations have to be before
     any local subprograms. */
  FUNCTION FormatName(p_FirstName IN VARCHAR2,
                      p_LastName IN VARCHAR2)
    RETURN VARCHAR2 IS
  BEGIN
    RETURN p_FirstName || ' ' || p_LastName;
  END FormatName;

  CURSOR c_AllStudents IS
    SELECT first_name, last_name
      FROM students;

  v_FormattedName VARCHAR2(50);
-- Begin main block
BEGIN
  NULL;
END;
/
