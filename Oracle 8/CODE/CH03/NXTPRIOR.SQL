REM nxtprior.sql
REM Version 1.0, last updated 4/30/97
REM This block illustrates the use of the NEXT and PRIOR table attributes,
REM as described in Chapter 3 of _Oracle8 PL/SQL Programming_
REM by Scott Urman.

DECLARE
  TYPE t_MajorTable IS TABLE OF students.major%TYPE
    INDEX BY BINARY_INTEGER;
  v_Majors t_MajorTable;
  v_Index  BINARY_INTEGER;
BEGIN
  -- Insert values into the table.
  v_Majors(-7) := 'Computer Science';
  v_Majors(4) := 'History';
  v_Majors(5) := 'Economics';

  -- Loop over all the rows in the table, and insert them into
  -- temp_table.
  v_Index := v_Majors.FIRST;
  LOOP
    INSERT INTO temp_table (num_col, char_col)
      VALUES (v_Index, v_Majors(v_Index));
    EXIT WHEN v_Index = v_Majors.LAST;
    v_Index := v_Majors.NEXT(v_Index);
  END LOOP;
END;
/
