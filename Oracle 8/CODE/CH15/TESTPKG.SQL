REM testpkg.sql
REM Version 1.0, last updated 4/3/97
REM This file creates a package called TestPkg, for use in illustrating 
REM the ExecuteAny package used in Chapter 15 of _Oracle8 PL/SQL
REM Programming_ by Scott Urman.

CREATE OR REPLACE PACKAGE TestPkg AS
  -- This is a very simple package, with procedures that take
  -- different types of arguments, to better illustrate ExecuteAny.
  PROCEDURE P1(p_Num IN NUMBER, p_Date OUT DATE);
  PROCEDURE P2(p_String OUT VARCHAR2);
  PROCEDURE P3(p_Num IN OUT NUMBER, p_String OUT VARCHAR2);
END TestPkg;
/
show errors

CREATE OR REPLACE PACKAGE BODY TestPkg AS
  PROCEDURE P1(p_Num IN NUMBER, p_Date OUT DATE) IS
  BEGIN
    p_Date := SYSDATE;
  END P1;
  
  PROCEDURE P2(p_String OUT VARCHAR2) IS
  BEGIN
    p_String := 'Hello World!';
  END P2;

  PROCEDURE P3(p_Num IN OUT NUMBER, p_String OUT VARCHAR2) IS
  BEGIN
    p_String := 'Original value was ' || TO_NUMBER(p_Num);
    p_Num := p_Num + 25;
  END P3;
END TestPkg; 
/
show errors


