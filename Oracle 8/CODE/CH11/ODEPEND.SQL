REM odepend.sql
REM Version 1.0, last updated 8/8/97
REM This script creates dependent objects, as described in
REM Chapter 11 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE TYPE Obj1 AS OBJECT (
  f1 NUMBER,
  f2 VARCHAR2(10),
  f3 DATE
);
/

CREATE OR REPLACE TYPE Obj2 AS OBJECT (
  f1 DATE,
  f2 CHAR(1)
);
/

CREATE OR REPLACE TYPE Obj3 AS OBJECT (
  a Obj1,
  b Obj2
);
/

