REM checkout.sql
REM Version 1.0, last updated 8/5/97
REM This procedure demonstrates how to use varrays in SQL statements, as
REM described in Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE CheckOut(
  p_StudentID IN NUMBER,
  p_NewBook IN BookObj) AS

  v_Books BookList2;
  v_Found BOOLEAN := FALSE;
  v_Book BookObj;
BEGIN
  -- First get the current list of books this student has checked
  -- out.
  BEGIN
    SELECT books
      INTO v_Books
      FROM checked_out
      WHERE student_id = p_StudentID;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- Student has no books checked out.
      v_Books := BookList2(NULL);
  END;

  -- Search the list to see if this student already has this book.
  FOR v_Counter IN 1..v_Books.COUNT LOOP
    v_Book := v_Books(v_Counter);

    IF v_Book.catalog_number = p_NewBook.catalog_number THEN
      RAISE_APPLICATION_ERROR(-20001, 'Book is already checked out');
    END IF;
  END LOOP;

  -- Make sure there is still room.
  IF v_Books.COUNT = v_Books.LIMIT THEN
    RAISE_APPLICATION_ERROR(-20001, 'Cannot check out any more books');
  END IF;

  -- Check out the book by adding it to the list.
  v_Books.EXTEND;
  v_Books(v_Books.COUNT) := p_NewBook;

  -- And put it back in the database.
  UPDATE checked_out
    SET books = v_Books
    WHERE student_id = p_StudentID;
  IF SQL%NOTFOUND THEN
    INSERT INTO checked_out (student_id, books)
      VALUES (p_StudentID, v_Books);
  END IF;

END CheckOut;
/

