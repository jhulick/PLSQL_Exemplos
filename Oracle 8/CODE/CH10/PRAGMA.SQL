REM pragma.sql
REM Version 1.0, last updated 4/8/97
REM This block illustrates the use of the EXCEPTION_INIT pragma, as 
REM described in Chapter 10 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  e_MissingNull EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_MissingNull, -1400);
BEGIN
  INSERT INTO students (id) VALUES (NULL);
EXCEPTION
  WHEN e_MissingNull then
    INSERT INTO log_table (info) VALUES ('ORA-1400 occurred');
END;
/
