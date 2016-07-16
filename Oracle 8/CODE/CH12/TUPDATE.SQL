REM tupdate.sql
REM Version 1.0, last updated 8/5/97
REM This block demonstrates the use of a nested table in an UPDATE statement,
REM as described in Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_Books Booklist :=
    BookList(BookObj('A History of the World', 'Smith', 2001),
             BookObj('Another World History', 'Jones', 2002));
BEGIN
  UPDATE course_material
    SET required_reading = v_Books
    WHERE department = 'HIS'
    AND course = 301;
END;
/


