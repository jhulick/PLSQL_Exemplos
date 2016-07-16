REM callme.sql
REM Version 1.0, last updated 5/6/97
REM This script illustrates positional and named notation, as described in
REM Chapter 7 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE CallMe (
  p_ParameterA VARCHAR2,
  p_ParameterB NUMBER,
  p_ParameterC BOOLEAN,
  p_ParameterD DATE) AS
BEGIN
  NULL;
END CallMe;
/

DECLARE
  v_Variable1 VARCHAR2(10);
  v_Variable2 NUMBER(7,6);
  v_Variable3 BOOLEAN;
  v_Variable4 DATE;
BEGIN
  CallMe(v_Variable1, v_Variable2, v_Variable3, v_Variable4);
END;
/

DECLARE
  v_Variable1 VARCHAR2(10);
  v_Variable2 NUMBER(7,6);
  v_Variable3 BOOLEAN;
  v_Variable4 DATE;
BEGIN
  CallMe(p_ParameterA => v_Variable1, 
         p_ParameterB => v_Variable2,
         p_ParameterC => v_Variable3,
         p_ParameterD => v_Variable4);
END;
/

DECLARE
  v_Variable1 VARCHAR2(10);
  v_Variable2 NUMBER(7,6);
  v_Variable3 BOOLEAN;
  v_Variable4 DATE;
BEGIN
  CallMe(p_ParameterB => v_Variable2, 
         p_ParameterC => v_Variable3,
         p_ParameterD => v_Variable4,
         p_ParameterA => v_Variable1);
END;
/

DECLARE
  v_Variable1 VARCHAR2(10);
  v_Variable2 NUMBER(7,6);
  v_Variable3 BOOLEAN;
  v_Variable4 DATE;
BEGIN
  -- First 2 parameters passed by position, the second 2 are
  -- passed by name.
  CallMe(v_Variable1, v_Variable2, 
         p_ParameterC => v_Variable3,
         p_ParameterD => v_Variable4);
END;
/
