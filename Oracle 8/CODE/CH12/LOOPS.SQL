REM loops.sql
REM Version 1.0, last updated 8/5/97
REM This block illustrates the FIRST, LAST, NEXT, and PRIOR collection
REM methods, as described in Chapter 12 of _Oracle8 PL/SQL Programming_
REM by Scott Urman.

SET serveroutput on
DECLARE
  TYPE t_CharTab IS TABLE OF CHAR(1);
  v_Characters t_CharTab := t_CharTab('M', 'a', 'd', 'a', 'm', ',', ' ',
    'I', '''', 'm', ' ', 'A', 'd', 'a', 'm');

  v_Index INTEGER;
BEGIN
  -- Loop forwards over the table.
  v_Index := v_Characters.FIRST;
  WHILE v_Index <= v_Characters.LAST LOOP
    DBMS_OUTPUT.PUT(v_Characters(v_Index));
    v_Index := v_Characters.NEXT(v_Index);
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;

  -- Loop backwards over the table.
  v_Index := v_Characters.LAST;
  WHILE v_Index >= v_Characters.FIRST LOOP
    DBMS_OUTPUT.PUT(v_Characters(v_Index));
    v_Index := v_Characters.PRIOR(v_Index);
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
END;
/

