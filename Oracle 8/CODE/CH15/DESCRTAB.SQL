REM descrtab.sql
REM Version 1.0, last updated 5/21/97
REM This procedure demonstrates the DBMS_SQL.DESCRIBE_COLUMNS procedure, as
REM described in Chapter 15 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE DescribeTable(p_Table IN VARCHAR2) AS
  v_Cursor       INTEGER;
  v_SQLStatement VARCHAR2(100);
  v_DescribeInfo DBMS_SQL.DESC_TAB;
  v_DRec         DBMS_SQL.DESC_REC;
  v_ReturnCode   INTEGER;
  v_NumColumns   INTEGER;

  FUNCTION ConvertDatatype (v_Datatype IN NUMBER)
    RETURN VARCHAR2 IS
    v_Output VARCHAR2(20);
  BEGIN
    SELECT DECODE(v_Datatype, 1, 'VARCHAR2',
                              2, 'NUMBER',
                              8, 'LONG',
                              12, 'DATE',
                              23, 'RAW',
                              24, 'LONG RAW',
                              69, 'ROWID',
                              96, 'CHAR',
                              106, 'MLSLABEL',
                              112, 'CLOB',
                              113, 'BLOB',
                              114, 'BFILE')
      INTO v_Output
      FROM dual;

    RETURN v_Output;
  END ConvertDatatype;

BEGIN
  v_Cursor := DBMS_SQL.OPEN_CURSOR;

  -- Parse a select statement for the table.
  -- We don't need to execute it.
  v_SQLStatement := 'SELECT * FROM ' || p_Table;
  DBMS_SQL.PARSE(v_Cursor, v_SQLStatement, DBMS_SQL.V7);

  -- Describe the statement, which will give us a table description.
  DBMS_SQL.DESCRIBE_COLUMNS(v_Cursor,  v_NumColumns, v_DescribeInfo);

  -- Output header info.
  DBMS_OUTPUT.PUT_LINE('Description of ' || p_Table || ':');
  DBMS_OUTPUT.PUT('Column Name     Datatype Length Precision Scale ');
  DBMS_OUTPUT.PUT_LINE('Null?');
  DBMS_OUTPUT.PUT('--------------- -------- ------ --------- ----- ');
  DBMS_OUTPUT.PUT_LINE('-----');

  -- Loop over the columns, outputting the describe info for each.
  FOR v_Col IN 1..v_NumColumns LOOP
    v_DRec := v_DescribeInfo(v_Col);
    DBMS_OUTPUT.PUT(RPAD(v_DRec.col_name, 16));
    DBMS_OUTPUT.PUT(RPAD(ConvertDatatype(v_DRec.col_type), 9));
    DBMS_OUTPUT.PUT(RPAD(v_DRec.col_max_len, 7));
    DBMS_OUTPUT.PUT(RPAD(v_DRec.col_precision, 10));
    DBMS_OUTPUT.PUT(RPAD(v_DRec.col_scale, 6));
    IF v_DescribeInfo(v_Col).col_null_ok THEN
      DBMS_OUTPUT.NEW_LINE;
    ELSE
      DBMS_OUTPUT.PUT_LINE('NOT NULL');
    END IF;
  END LOOP;

END DescribeTable;
/
