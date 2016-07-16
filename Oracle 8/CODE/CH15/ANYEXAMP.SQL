REM anyexamp.sql
REM Version 1.0, last updated 4/3/97
REM This file is an example of the ExecuteAny package.  It requires ExecuteAny
REM and TestPkg to have been created first.  It illustrates how to use
REM ExecuteAny, described in Chapter 15 of _Oracle8 PL/SQL Programming_
REM by Scott Urman.

SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  -- v_Params will hold the parameter list for the procedures we call.
  v_Params ExecuteAny.t_ParameterList;
BEGIN
  -- Fill in v_Params with the info for TestPkg.P1.  Note that since the first
  -- parameter is IN and the second is OUT, we only fill in a _param value
  -- for parameter 1.  ExecuteAny.RunProc will fill in any OUT parameters.
  -- We do, however, have to fill in the type information for both parameters.
  v_Params(1).actual_type := 'NUMBER';
  v_Params(1).num_param := 7;
  v_Params(2).actual_type := 'DATE';
  ExecuteAny.RunProc(2, 'TestPkg.P1', v_Params);
  DBMS_OUTPUT.PUT_LINE('After call to RunProc for P1:');
  ExecuteAny.PrintParams(v_Params, 2);
  DBMS_OUTPUT.NEW_LINE;

  -- Fill in v_Params for TestPkg.P2.  Since P2 has only one OUT parameter, we
  -- only need to fill in the type.
  v_Params(1).actual_type := 'VARCHAR2';
  ExecuteAny.RunProc(1, 'TestPkg.P2', v_Params);
  DBMS_OUTPUT.PUT_LINE('After call to RunProc for P2:');
  ExecuteAny.PrintParams(v_Params, 1);
  DBMS_OUTPUT.NEW_LINE;
  
  -- Fill in v_Params for TestPkg.P3.
  v_Params(1).actual_type := 'NUMBER';
  v_Params(1).num_param := -34;
  v_Params(2).actual_type := 'VARCHAR2';
  ExecuteAny.RunProc(2, 'TestPkg.P3', v_Params);
  DBMS_OUTPUT.PUT_LINE('After call to RunProc for P3:');
  ExecuteAny.PrintParams(v_Params, 2);
  DBMS_OUTPUT.NEW_LINE;
END;
/
