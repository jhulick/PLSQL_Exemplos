REM prcnttyp.sql
REM Version 1.0, last updated 8/8/97
REM This block demonstrates the use of %TYPE with objects, as described in
REM Chapter 11 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  -- First declare a record type, and a variable of the record and
  -- object type.
  TYPE t_Rec IS RECORD (
    f1 NUMBER,
    f2 VARCHAR2(10));
  v_Student StudentObj;
  v_Rec     t_Rec;

  -- This declaration is legal, since %TYPE is applied to a variable.
  v_ID v_Student.ID%TYPE;
  -- This declaration raises PLS-206, since %TYPE is applied to an object
  -- type.
  v_ID2 StudentObj.ID%TYPE;

  -- This declaration is legal, since %TYPE is applied to a variable.
  v_F1 v_Rec.f1%TYPE;
  -- This declaration raises PLS-206, since %TYPE is applied to a
  -- record type.
  v_F2 t_Rec.f2%TYPE;
BEGIN
  NULL;
END;
/

