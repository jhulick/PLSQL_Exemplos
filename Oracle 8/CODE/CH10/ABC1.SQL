REM abc1.sql
REM Version 1.0, last updated 4/7/97
REM These three procedures illustrate the "PL/SQL at Work" example from
REM Chapter 10 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE C AS
  v_CallStack VARCHAR2(2000);
BEGIN
    v_CallStack := DBMS_UTILITY.FORMAT_CALL_STACK;
    INSERT INTO temp_table (char_col) VALUES (v_CallStack);
    INSERT INTO temp_table (num_col)
      VALUES (-1);
END C;
/

CREATE OR REPLACE PROCEDURE B AS
BEGIN
  C;
END B;
/

CREATE OR REPLACE PROCEDURE A AS
BEGIN
  B;
END A;
/