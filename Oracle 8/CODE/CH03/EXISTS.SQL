REM exists.sql
REM Version 1.0, last updated 4/30/97
REM This block demonstrates the EXISTS table attribute, as described in
REM Chapter 3 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  TYPE t_FirstNameTable IS TABLE OF students.first_name%TYPE
    INDEX BY BINARY_INTEGER;
  FirstNames  t_FirstNameTable;
BEGIN
  -- Insert rows into the table.
  FirstNames(1) := 'Scott';
  FirstNames(3) := 'Joanne';

  -- Check to see if rows exist.
  IF FirstNames.EXISTS(1) THEN
    INSERT INTO temp_table (char_col) VALUES
      ('Row 1 exists!');
  ELSE
    INSERT INTO temp_table (char_col) VALUES
      ('Row 1 doesn''t exist!');
  END IF;
  IF FirstNames.EXISTS(2) THEN
    INSERT INTO temp_table (char_col) VALUES
      ('Row 2 exists!');
  ELSE
    INSERT INTO temp_table (char_col) VALUES
      ('Row 2 doesn''t exist!');
  END IF;
END;
/
