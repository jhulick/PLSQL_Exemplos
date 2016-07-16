REM order.sql
REM Version 1.0, last updated 5/1/97
REM This script illustrates the order in which triggers are fired, as
REM described in Chapter 9 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DROP SEQUENCE trigger_seq;

CREATE SEQUENCE trigger_seq
  START WITH 1
  INCREMENT BY 1;

CREATE OR REPLACE TRIGGER classes_BStatement
  BEFORE UPDATE ON classes 
BEGIN
  INSERT INTO temp_table (num_col, char_col)
    VALUES (trigger_seq.NEXTVAL, 'Before Statement trigger');
END classes_BStatement;
/

CREATE OR REPLACE TRIGGER classes_AStatement
  AFTER UPDATE ON classes
BEGIN
  INSERT INTO temp_table (num_col, char_col)
    VALUES (trigger_seq.NEXTVAL, 'After Statement trigger');
END classes_AStatement;
/

CREATE OR REPLACE TRIGGER classes_BRow
  BEFORE UPDATE ON classes
  FOR EACH ROW
BEGIN
  INSERT INTO temp_table (num_col, char_col)
    VALUES (trigger_seq.NEXTVAL, 'Before Row trigger');
END classes_BRow;
/

CREATE OR REPLACE TRIGGER classes_ARow
  AFTER UPDATE ON classes
  FOR EACH ROW
BEGIN
  INSERT INTO temp_table (num_col, char_col)
    VALUES (trigger_seq.NEXTVAL, 'After Row trigger');
END classes_ARow;
/

UPDATE classes
  SET num_credits = 4
  WHERE department IN ('HIS', 'CS');

SELECT *
  FROM temp_table
  ORDER BY num_col;
