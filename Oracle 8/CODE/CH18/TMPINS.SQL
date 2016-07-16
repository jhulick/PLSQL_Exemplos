REM tmpins.sql
REM Version 1.0, last updated 5/18/97
REM This script creates the TempInsert procedure, and submits it to be
REM run every 10 seconds using DBMS_JOB, as described in
REM Chapter 18 of _Oracle8 PL/SQL Programming_ by Scott Urman.

PROMPT Creating sequence and procedure...
DROP SEQUENCE temp_seq;

CREATE SEQUENCE temp_seq
  START WITH 1
  INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE TempInsert AS
BEGIN
  INSERT INTO temp_table (num_col, char_col)
    VALUES (temp_seq.nextval, TO_CHAR(SYSDATE, 'DD-MON-YY HH24:MI:SS'));
  COMMIT;
END TempInsert;
/

PROMPT Submitting to job queue...
VARIABLE v_JobNum NUMBER
BEGIN
  DBMS_JOB.SUBMIT(:v_JobNum, 'TempInsert;', SYSDATE,
                  'SYSDATE + (10/(24*60*60))');
END;
/

PRINT v_JobNum
