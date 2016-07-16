REM trigger.sql
REM Version 1.0, last updated 5/7/97
REM This is an example of a database trigger, as described in
REM Chapter 2 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE TRIGGER OnlyPositive
  BEFORE INSERT OR UPDATE OF num_col
  ON temp_table
  FOR EACH ROW
BEGIN
  IF :new.num_col < 0 THEN
    RAISE_APPLICATION_ERROR(-20100, 'Please insert a positive value');
  END IF;
END OnlyPositive;
/
