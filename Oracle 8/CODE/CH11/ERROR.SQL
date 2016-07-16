REM error.sql
REM Version 1.0, last updated 8/8/97
REM This object type illustrates the behavior of exceptions with object
REM types, as described in Chapter 11 of _Oracle8 PL/SQL Programming_
REM by Scott Urman.

CREATE OR REPLACE TYPE ErrorObj AS OBJECT (
  attribute NUMBER,
  MEMBER PROCEDURE RaiseError(p_RaiseIt IN BOOLEAN,
                              p_OutParam IN OUT NUMBER),
  MEMBER PROCEDURE Print(p_Comment IN VARCHAR2 DEFAULT NULL)
);
/

CREATE OR REPLACE TYPE BODY ErrorObj AS
  MEMBER PROCEDURE RaiseError(p_RaiseIt IN BOOLEAN,
                              p_OutParam IN OUT NUMBER) IS
  BEGIN
    -- Assign the IN value to attribute, and increment it by 1
    -- for the OUT value.
    SELF.attribute := p_outParam;
    p_OutParam := p_OutParam + 1;
    IF p_RaiseIt THEN
      RAISE NO_DATA_FOUND;
    END IF;
  END RaiseError;

  MEMBER PROCEDURE Print (p_Comment IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    -- Print the comment as well as the attribute value.
    IF p_Comment IS NOT NULL THEN
      DBMS_OUTPUT.PUT(p_Comment || ', ');
    END IF;
    DBMS_OUTPUT.PUT_LINE('attribute = ' || attribute);
  END Print;
END;
/

SET SERVEROUTPUT on
DECLARE
  v_Test ErrorObj := ErrorObj(1);
  v_NumVal NUMBER := 10;
BEGIN
  -- First print the attribute and v_NumVal
  v_Test.Print('After initialization, v_NumVal = ' || v_NumVal);
  -- Call RaiseError with FALSE, so the parameter and attribute are
  -- assigned.
  v_Test.RaiseError(FALSE, v_NumVal);
  v_Test.Print('After call with no exception, v_NumVal = ' || v_NumVal);
  -- Call RaiseError with TRUE, so the parameter and attribute are
  -- not assigned.
  v_Test.RaiseError(TRUE, v_NumVal);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    v_Test.Print('After call with exception, v_NumVal = ' || v_NumVal);
END;
/

