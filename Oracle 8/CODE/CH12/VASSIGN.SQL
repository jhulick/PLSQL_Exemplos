REM vassign.sql
REM Version 1.0, last updated 8/5/97
REM This block illustrates the behavior of assigning to varray elements, as
REM described in Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  TYPE t_Strings IS VARRAY(5) OF VARCHAR2(10);

  -- Declare a varray with three elements.  The maximum size of this
  -- type is five elements.
  v_List t_Strings := t_Strings('Scott', 'David', 'Urman');
BEGIN
  -- Subscript between 1 and 3, so this is a legal assignment.
  v_List(2) := 'DAVID';

  -- Subscript out of range, raises ORA-6533.
  v_List(4) := '!!!';
END;
/

