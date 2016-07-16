REM co.sql
REM Version 1.0, last updated 8/5/97
REM This block illustrates one way of calling the CheckOut procedure, as
REM described in Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_RequiredBooks BookList;
  v_Book BookObj;

BEGIN
  SELECT required_reading
    INTO v_RequiredBooks
    FROM course_material
    WHERE department = 'CS'
    AND course = 101;

  FOR v_Counter IN 1..v_RequiredBooks.COUNT LOOP
    v_Book := v_RequiredBooks(v_Counter);
    CheckOut(1005, v_Book);
  END LOOP;
END;
/

