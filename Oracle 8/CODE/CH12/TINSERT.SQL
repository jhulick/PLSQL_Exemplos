REM tinsert.sql
REM Version 1.0, last updated 8/5/97
REM This block demonstrates using a nested table in an INSERT statement, as
REM described in Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_Books Booklist :=
    BookList(BookObj('A History of the World', 'Smith', 2001));
BEGIN
  -- INSERT using a newly constructed nested table of 3 elements.
  INSERT INTO course_material VALUES (
  'CS', 101,
    BookList(BookObj('Oracle8 PL/SQL Programming', 'Urman', 1000),
             BookObj('Oracle8: A Beginner''s Guide', 'Abbey, Corey', 1001),
             BookObj('Tuning Oracle', 'Corey, Abbey, Dechichio', 1002)));

  -- INSERT using a previously initialized nested table of 1 element.
  INSERT INTO course_material VALUES (
    'HIS', 301, v_Books);
END;
/

