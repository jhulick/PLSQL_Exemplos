REM modetest.sql
REM Version 1.0, last updated 5/6/97
REM This procedure illustrates the modes of procedure parameters, as
REM described in Chapter 7 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE ModeTest (
  p_InParameter    IN NUMBER,
  p_OutParameter   OUT NUMBER,
  p_InOutParameter IN OUT NUMBER) IS

  v_LocalVariable  NUMBER;
BEGIN
  /* Assign p_InParameter to v_LocalVariable. This is legal,
     since we are reading from an IN parameter and not writing
     to it. */
  v_LocalVariable := p_InParameter;  -- Legal

  /* Assign 7 to p_InParameter. This is ILLEGAL, since we
     are writing to an IN parameter. */
  p_InParameter := 7;  -- Illegal

  /* Assign 7 to p_OutParameter. This is legal, since we 
     are writing to an OUT parameter and not reading from
     it. */
  p_OutParameter := 7;  -- Legal

  /* Assign p_OutParameter to v_LocalVariable. This is
     ILLEGAL, since we are reading from an OUT parameter. */
  v_LocalVariable := p_outParameter;  -- Illegal

  /* Assign p_InOutParameter to v_LocalVariable. This is legal,
     since we are reading from an IN OUT parameter. */
  v_LocalVariable := p_InOutParameter;  -- Legal

  /* Assign 7 to p_InOutParameter. This is legal, since we
     are writing to an IN OUT parameter. */
  p_InOutParameter := 7;  -- Legal
END ModeTest;
/
