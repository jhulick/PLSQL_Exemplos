REM proc.sql
REM Version 1.0, last updated 5/7/97
REM This script illustrates a stored procedure, as described in
REM Chapter 2 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE InsertIntoTemp AS
  /* Declare variables to be used in this block. */
  v_Num1      NUMBER := 5;
  v_Num2      NUMBER := 6;
  v_String1   VARCHAR2(50) := 'Hello World!';
  v_String2   VARCHAR2(50) := '-- This message brought to you by PL/SQL!';
  v_OutputStr VARCHAR2(50);
BEGIN
  /* First, insert two rows into temp_table, using the values of the 
     variables. */
  INSERT INTO temp_table (num_col, char_col)
    VALUES (v_Num1, v_String1);
  INSERT INTO temp_table (num_col, char_col)
    VALUES (v_Num2, v_String2);
	
  /* Now query temp_table for the two rows we just inserted, and output
     them to the screen using the DBMS_OUTPUT package. */
  SELECT char_col
    INTO v_OutputStr
	FROM temp_table
	WHERE num_col = v_Num1;
  DBMS_OUTPUT.PUT_LINE(v_OutputStr);
  
  SELECT char_col
    INTO v_OutputStr
	FROM temp_table
	WHERE num_col = v_Num2;
  DBMS_OUTPUT.PUT_LINE(v_OutputStr);
END InsertIntoTemp;
/
