REM forward.sql
REM Version 1.0, last updated 5/6/97
REM This block uses a forward declaration, as described in
REM Chapter 7 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_TempVal BINARY_INTEGER := 5;

  -- Forward declaration of procedure B.
  PROCEDURE B(p_Counter IN OUT BINARY_INTEGER);

  PROCEDURE A(p_Counter IN OUT BINARY_INTEGER) IS
  BEGIN
    IF p_Counter > 0 THEN
      B(p_Counter);
      p_Counter := p_Counter - 1;
    END IF;
  END A;

  PROCEDURE B(p_Counter IN OUT BINARY_INTEGER) IS
  BEGIN
    p_Counter := p_Counter - 1;
    A(p_Counter);
  END B;
BEGIN
  B(v_TempVal);
END;
/
