REM return.sql
REM Version 1.0, last updated 8/8/97
REM This block demonstrates the RETURING clause, as described in
REM Chapter 11 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_ClassRef REF ClassObj;
BEGIN
  INSERT INTO CLASSES c VALUES
    (ClassObj('HIS', 101, 'History 101', 30, 0, 4, NULL))
    RETURNING REF(c) INTO v_ClassRef;
END;
/

