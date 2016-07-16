REM lobdml.sql
REM Version 1.0, last updated 8/8/97
REM This file demonstrates some DML operations on internal LOBs, as described
REM in Chapter 21 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_CLOBlocator CLOB;
  v_BLOBlocator BLOB;
BEGIN
  -- Initializes the clob_col to the specified string, and returns the
  -- locator into v_LOBlocator.
  INSERT INTO lobdemo (key, clob_col)
    VALUES (20, 'abcdefghijklmnopqrstuvwxyz')
    RETURNING clob_col INTO v_CLOBlocator;

  -- Modifies blob_col for the same row.
  UPDATE lobdemo
    SET blob_col = HEXTORAW('00FF00FF00FF')
    WHERE key = 20;

  -- Retrieves the locator for the newly updated value, not the value
  -- itself.
  SELECT blob_col
    INTO v_BLOBlocator
    FROM lobdemo
    WHERE key = 20;
END;
/

