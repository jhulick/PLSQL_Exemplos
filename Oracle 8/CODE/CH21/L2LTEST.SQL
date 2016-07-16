REM l2ltest.sql
REM Version 1.0, last updated 8/8/97
REM This script creates sample data for the Long2Lob procedure, as described
REM in Chapter 21 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DROP TABLE long_tab;

CREATE TABLE long_tab (
  key NUMBER,
  long_col LONG
);

INSERT INTO long_tab (key, long_col)
  VALUES (100,
'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZ');

COMMIT;

SET SERVEROUTPUT on
DECLARE
  v_Query VARCHAR2(200);
  v_NewLOB CLOB;
BEGIN
  v_Query := 'SELECT long_col FROM long_tab where key = 100';
  INSERT INTO lobdemo (key, clob_col)
    VALUES (100, EMPTY_CLOB())
    RETURNING clob_col INTO v_NewLOB;

  Long2Lob(v_Query, v_NewLOB);
  LOBPrint(v_NewLOB);
  COMMIT;
END;
/

