REM studops.sql
REM Version 1.0, last updated 4/29/97
REM This package illustrates the use of the RESTRICT_REFERENCES pragma,
REM as described in Chapter 8 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PACKAGE StudentOps AS
  FUNCTION FullName(p_StudentID IN students.ID%TYPE)
    RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES(FullName, WNDS, WNPS, RNPS);

  /* Returns the number of History majors. */
  FUNCTION NumHistoryMajors
    RETURN NUMBER;
  PRAGMA RESTRICT_REFERENCES(NumHistoryMajors, WNDS, WNPS, RNPS);
END StudentOps;
/

CREATE OR REPLACE PACKAGE BODY StudentOps AS
  -- Packaged variable to hold the number of history majors.
  v_NumHist NUMBER;

  FUNCTION FullName(p_StudentID IN students.ID%TYPE)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(100);
  BEGIN
    SELECT first_name || ' ' || last_name
      INTO v_Result
      FROM students
      WHERE ID = p_StudentID;

    RETURN v_Result;
  END FullName;

  FUNCTION NumHistoryMajors RETURN NUMBER IS
    v_Result NUMBER;
  BEGIN
    IF v_NumHist IS NULL THEN
      /* Determine the answer. */
      SELECT COUNT(*)
        INTO v_Result
        FROM students
        WHERE major = 'History';
      /* And save it for future use. */
      v_NumHist := v_Result;
    ELSE
      v_Result := v_NumHist;
    END IF;

    RETURN v_Result;
  END NumHistoryMajors;
END StudentOps;
/
