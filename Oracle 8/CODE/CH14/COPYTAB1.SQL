REM copytab1.sql
REM Version 1.0, last updated 5/15/97
REM This procedure will copy all the records from the source to the
REM destination table, as described in Chapter 14 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE CopyTables AS
  v_Key   source.key%TYPE;
  v_Value source.value%TYPE;

  CURSOR c_AllData IS
    SELECT *
      FROM source;
BEGIN
  OPEN c_AllData;

  LOOP
    FETCH c_AllData INTO v_Key, v_Value;
    EXIT WHEN c_AllData%NOTFOUND;

    INSERT INTO destination (key, value)
      VALUES (v_Key, TO_NUMBER(v_Value));
  END LOOP;

  CLOSE c_AllData;
END CopyTables;
/
