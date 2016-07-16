REM vconstr.sql
REM Version 1.0, last updated 8/5/97
REM This block illustrates the use of varray constructors, as described in
REM Chapter 12 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET serveroutput on
DECLARE
  -- Define a VARRAY type.
  TYPE t_Numbers IS VARRAY(20) OF NUMBER(3);

  -- Declare a NULL varray.
  v_NullList t_Numbers;

  -- This varray has 2 elements.
  v_List1 t_Numbers := t_Numbers(1, 2);

  -- This varray has one element, which itself is NULL.
  v_List2 t_Numbers := t_Numbers(NULL);
BEGIN
  IF v_NullList IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('v_NullList is NULL');
  END IF;

  IF v_List2(1) IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('v_List2(1) is NULL');
  END IF;
END;
/

