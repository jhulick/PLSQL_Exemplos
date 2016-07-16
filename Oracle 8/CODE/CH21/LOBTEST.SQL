REM lobtest.sql
REM Version 1.0, last updated 8/8/97
REM This script populates the lobdemo table for the DBMS_LOB examples, as
REM described in Chapter 21 of _Oracle8 PL/SQL Programming_ by Scott Urman.

INSERT INTO lobdemo (key, clob_col, blob_col, bfile_col)
  VALUES (-1, EMPTY_CLOB(), EMPTY_BLOB(), NULL);

INSERT INTO lobdemo (key, clob_col, blob_col, bfile_col)
  VALUES (1, 'abcdefghijklmnopqrstuvwxyz',
             HEXTORAW('000102030405060708090A0B0C0D0E0F'),
             NULL);
INSERT INTO lobdemo (key, clob_col, blob_col, bfile_col)
  VALUES (2, 'A Quick Brown Fox Jumps Over the Lazy Dog',
             HEXTORAW('FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0'),
             NULL);
COMMIT;

