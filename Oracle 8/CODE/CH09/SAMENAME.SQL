REM samename.sql
REM Version 1.0, last updated 5/1/97
REM This script illustrates that it is legal to have a trigger with the
REM name as a table, but not a procedure, as described in
REM Chapter 9 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE TRIGGER major_stats
  BEFORE INSERT ON major_stats
BEGIN
  INSERT INTO temp_table (char_col)
    VALUES ('Trigger fired!');
END major_stats;
/

CREATE OR REPLACE PROCEDURE major_stats AS
BEGIN
  INSERT INTO temp_table (char_col)
    VALUES ('Procedure called!');
END major_stats;
/

