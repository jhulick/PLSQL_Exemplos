REM tabrec.sql
REM Version 1.0, last updated 4/30/97
REM This block illustrates a table of records, valid in PL/SQL 2.3 and
REM higher, as described in Chapter 3
REM of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET serveroutput on
DECLARE
  TYPE t_StudentTable IS TABLE OF students%ROWTYPE
    INDEX BY BINARY_INTEGER;
  /* Each element of v_Students is a record */
  v_Students t_StudentTable;
BEGIN
  /* Retrieve the record with id = 10,001 and store it into
     v_Students(10001) */
  SELECT *
    INTO v_Students(10001)
    FROM students
    WHERE id = 10001;
	
  v_Students(10001).first_name := 'Larry';
  DBMS_OUTPUT.PUT_LINE(v_Students(10001).first_name);

END;
/
