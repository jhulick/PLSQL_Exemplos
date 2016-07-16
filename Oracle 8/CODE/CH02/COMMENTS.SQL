REM comments.sql
REM Version 1.0, last updated 5/7/97
REM This file contains PL/SQL blocks with different types of comments, as 
REM described in Chapter 2 of _Oracle8 PL/SQL Programming_ by Scott Urman.

REM No comments...
DECLARE
  v_Department  CHAR(3);
  v_Course      NUMBER;
BEGIN
  INSERT INTO classes (department, course)
    VALUES (v_Department, v_Course);
END;
/

REM Single line comments...
DECLARE
  v_Department  CHAR(3);  -- Variable to hold the 3 character
                          -- department code
  v_Course      NUMBER;   -- Variable to hold the course number
BEGIN
  -- Insert the course identified by v_Department and v_Course
  -- into the classes table in the database.
  INSERT INTO classes (department, course)
    VALUES (v_Department, v_Course);
END;
/

REM Multiline comments...
DECLARE
  v_Department  CHAR(3);  /* Variable to hold the 3 character
                             department name */
  v_Course      NUMBER;   /* Variable to hold the course number */
BEGIN
  /* Insert the course identified by v_Department and v_Course
     into the classes table in the database. */
  INSERT INTO classes (department, course)
    VALUES (v_Department, v_Course);
END;
/

REM Illegal comments...
BEGIN
  /* We are now inside a comment. If we were to begin another
     comment such as /* this */ it would be illegal. */
  NULL;
END;
/
