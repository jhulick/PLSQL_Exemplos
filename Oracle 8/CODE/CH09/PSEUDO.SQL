REM pseudo.sql
REM Version 1.0, last updated 5/1/97
REM This trigger illustrates that :old and :new are not truly records, as
REM described in Chapter 9 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE TRIGGER TempDelete
BEFORE DELETE ON temp_table
FOR EACH ROW
DECLARE
  v_TempRec temp_table%ROWTYPE;
BEGIN
  /* This is not a legal assignment, since :old is not truly
     a record. */
  v_TempRec := :old;

  /* We can accomplish the same thing, however, by assigning
    the fields individually. */
  v_TempRec.char_col := :old.char_col;
  v_TempRec.num_col := :old.num_col;
END TempDelete;
/
