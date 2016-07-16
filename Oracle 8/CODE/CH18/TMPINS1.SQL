REM tmpins1.sql
REM Version 1.0, last updated 5/18/97
REM This version of TempInsert will remove itself from the job queue if
REM the sequence number is more than 15, as described in
REM Chapter 18 of _Oracle8 PL/SQL Programming_ by Scott Urman.

PROMPT Creating procedure...
CREATE OR REPLACE PROCEDURE TempInsert
  (p_NextDate IN OUT DATE) AS
  v_SeqNum   NUMBER;
  v_StartNum NUMBER;
  v_SQLCode NUMBER;
  v_Errmsg  VARCHAR2(60);
BEGIN
  SELECT temp_seq.nextval
    INTO v_SeqNum
    FROM dual;
  -- See if this is the first time we're called
  BEGIN
    SELECT num_col
      INTO v_StartNum
      FROM temp_table
      WHERE char_col = 'TempInsert Start';

    -- We've been called before, so insert a new value
    INSERT INTO temp_table (num_col, char_col)
      VALUES (v_SeqNum, TO_CHAR(SYSDATE, 'DD-MON-YY HH24:MI:SS'));
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- First time we're called, so insert
      INSERT INTO temp_table (num_col, char_col)
        VALUES (v_SeqNum, 'TempInsert Start');
  END;

  -- If we've been called more than 15 times, exit.
  IF v_SeqNum - V_StartNum > 15 THEN
    p_NextDate := NULL;
  END IF;

  COMMIT;
END TempInsert;
/

PROMPT Submitting to job queue...
VARIABLE v_JobNum

BEGIN
  DBMS_JOB.SUBMIT(:v_JobNum, 'TempInsert(next_date);', SYSDATE,
                  'SYSDATE + (5/(24*60*60))');
END;
/

PRINT v_JobNum
