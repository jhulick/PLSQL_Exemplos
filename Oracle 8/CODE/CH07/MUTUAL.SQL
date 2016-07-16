REM mutual.sql
REM Version 1.0, last updated 5/6/97
REM This block contains 2 mutually referential subprograms, and is thus
REM illegal, as described in Chapter 7 of _Oracle8 PL/SQL Programming_
REM by Scott Urman.

DECLARE
  v_TempVal BINARY_INTEGER := 5;

  -- Local procedure A. Note that the code of A calls procedure B.
  PROCEDURE A(p_Counter IN OUT BINARY_INTEGER) IS
  BEGIN
    IF p_Counter > 0 THEN
      B(p_Counter);
      p_Counter := p_Counter - 1;
    END IF;
  END A;

  -- Local procedure B. Note that the code of B calls procedure A.
  PROCEDURE B(p_Counter IN OUT BINARY_INTEGER) IS
  BEGIN
    p_Counter := p_Counter - 1;
    A(p_Counter);
  END B;
BEGIN
  B(v_TempVal);
END;
/
