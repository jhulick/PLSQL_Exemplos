REM alter.sql
REM Version 1.0, last updated 8/8/97
REM This script demonstrates the behavior of the ALTER TYPE statement, as
REM described in Chapter 11 of _Oracle8 PL/SQL Programming_ by Scott Urman.

/* Create a simple object type with two attributes and two methods. */
CREATE OR REPLACE TYPE DummyObj AS OBJECT (
  f1 NUMBER,
  f2 NUMBER,
  MEMBER PROCEDURE Method1(x IN VARCHAR2),
  MEMBER FUNCTION Method2 RETURN DATE
);
/

/* Create the type body. */
CREATE OR REPLACE TYPE BODY DummyObj AS
  MEMBER PROCEDURE Method1(x IN VARCHAR2) IS
  BEGIN
    NULL;
  END Method1;

  MEMBER FUNCTION Method2 RETURN DATE IS
  BEGIN
    RETURN SYSDATE;
  END Method2;
END;
/

SELECT object_name, object_type, status
  FROM user_objects
  WHERE object_name = 'DUMMYOBJ';

/* Alter the type to add a new method.  This invalidates the type body. */
ALTER TYPE DummyObj REPLACE AS OBJECT (
  f1 NUMBER,
  f2 NUMBER,
  MEMBER PROCEDURE Method1(x IN VARCHAR2),
  MEMBER FUNCTION Method2 RETURN DATE,
  MEMBER PROCEDURE Method3
);

SELECT object_name, object_type, status
  FROM user_objects
  WHERE object_name = 'DUMMYOBJ';

