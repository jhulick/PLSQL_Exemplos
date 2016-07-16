REM bfiledml.sql
REM Version 1.0, last updated 8/8/97
REM This block demonstrates some DML operations on external LOBs, as
REM described in Chapter 21 of _Oracle8 PL/SQL Programming_ by Scott Urman.

BEGIN
  -- Create a row in lobdemo pointing to an external file.
  INSERT INTO lobdemo (key, bfile_col)
    VALUES (5, BFILENAME('util', 'file1'));

  -- Copy this locator into lobdemo2.
  INSERT INTO lobdemo2
    SELECT *
      FROM lobdemo
      WHERE key = 5;
END;
/

