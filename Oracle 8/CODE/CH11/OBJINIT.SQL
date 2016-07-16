REM objinit.sql
REM Version 1.0, last updated 8/8/97
REM This block demonstrates how to initialize objects, as described in
REM Chapter 11 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  -- Creates the object instance, with the attributes set.
  v_Student StudentObj :=
    StudentObj(10020, 'Chuck', 'Choltry', NULL, 0);
BEGIN
  -- Modifies the major attribute to 'Music'.  Note the use of dot
  -- notation to refer to the attribute.
  v_Student.major := 'Music';
END;
/

