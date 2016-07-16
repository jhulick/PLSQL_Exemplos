REM lobprint.sql
REM Version 1.0, last updated 8/8/97
REM This procedure demonstrates the DBMS_LOB.READ procedure, as described in
REM Chapter 21 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE LOBPrint(p_CLOB IN CLOB) AS
  v_Buffer VARCHAR2(80);
  v_Offset INTEGER := 1;
  v_Amount INTEGER := 80;
BEGIN
  LOOP
    -- Read and output the next 80 characters.
    DBMS_LOB.READ(p_CLOB, v_Amount, v_Offset, v_Buffer);
    DBMS_OUTPUT.PUT_LINE(v_Buffer);

    v_Offset := v_Offset + v_Amount;
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- End of loop, just return.
    NULL;
END LOBPrint;
/

