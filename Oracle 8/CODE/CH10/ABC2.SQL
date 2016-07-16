REM abc2.sql
REM Version 1.0, last updated 4/8/97
REM These procedures and trigger illustrate the use of the ErrorPkg 
REM generic error handler, described in the "PL/SQL at Work" example
REM in Chapter 10 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE TRIGGER temp_insert
  BEFORE INSERT ON temp_table
BEGIN
  RAISE ZERO_DIVIDE;
END ttt_insert;
/

CREATE OR REPLACE PROCEDURE C AS
BEGIN
  INSERT INTO temp_table (num_col) VALUES (7);
EXCEPTION
  WHEN OTHERS THEN
    ErrorPkg.HandleAll(FALSE);
    RAISE;
END C;
/
show errors

CREATE OR REPLACE PROCEDURE B AS
BEGIN
  C;
EXCEPTION
  WHEN OTHERS THEN
    ErrorPkg.HandleAll(FALSE);
    RAISE;

END B;
/
show errors

CREATE OR REPLACE PROCEDURE A AS
  v_ErrorSeq NUMBER;
BEGIN
  B;
EXCEPTION
  WHEN OTHERS THEN
    ErrorPkg.HandleAll(TRUE);
    ErrorPkg.StoreStacks('Error Test', v_ErrorSeq, TRUE);
    ErrorPkg.PrintStacks('Error Test', v_ErrorSeq);
END A;
/
show errors
