REM plength.sql
REM Version 1.0, last updated 5/6/97
REM This script illustrates constraints on procedure paramenters, as
REM described in Chapter 7 of _Oracle8 PL/SQL Programming_ by Scott Urman.

PROMPT Illegal ParameterLength (parameters constrained in declaration)...
SET echo on

CREATE OR REPLACE PROCEDURE ParameterLength (
  p_Parameter1 IN OUT VARCHAR2(10),
  p_Parameter2 IN OUT NUMBER(3,2)) AS
BEGIN
  p_Parameter1 := 'abcdefghijklm';
  p_Parameter2 := 12.3;
END ParameterLength;
/
SHOW ERRORS

SET echo off
PROMPT Legal ParameterLength...
SET echo on

CREATE OR REPLACE PROCEDURE ParameterLength (
  p_Parameter1 IN OUT VARCHAR2,
  p_Parameter2 IN OUT NUMBER) AS
BEGIN
  p_Parameter1 := 'abcdefghijklmno';
  p_Parameter2 := 12.3;
END ParameterLength;
/

SET echo off
PROMPT Calling ParameterLength legally...
SET echo on

DECLARE
  v_Variable1 VARCHAR2(40);
  v_Variable2 NUMBER(3,4);
BEGIN
  ParameterLength(v_Variable1, v_Variable2);
END;
/

SET echo off
PROMPT Calling ParameterLength illegally (ORA-6502)...
SET echo on

DECLARE
  v_Variable1 VARCHAR2(10);
  v_Variable2 NUMBER(3,4);
BEGIN
  ParameterLength(v_Variable1, v_Variable2);
END;
/

SET echo off
PROMPT ParameterLength using %TYPE for the parameters...
SET echo on

CREATE OR REPLACE PROCEDURE ParameterLength (
  p_Parameter1 IN OUT VARCHAR2,
  p_Parameter2 IN OUT students.current_credits%TYPE) AS
BEGIN
  p_Parameter2 := 12345;
END ParameterLength;
/

SET echo off
PROMPT Calling ParameterLength illegally (ORA-6502)...
SET echo on

DECLARE
  v_Variable1 VARCHAR2(1);
  v_Variable2 NUMBER;  -- Declare v_Variable2 with no constraints
BEGIN
  -- Even though the actual parameter has room for 12345, the
  -- constraint on the formal parameter is taken and we get
  -- ORA-6502 on this procedure call.
  ParameterLength(v_Variable1, v_Variable2);
END;
/