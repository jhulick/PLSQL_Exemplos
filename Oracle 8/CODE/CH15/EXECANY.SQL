REM execany.sql
REM Version 1.0, last updated 4/3/97
REM This script creates the ExecuteAny package for Chapter 15 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.
REM See testpkg.sql and anyexamp.sql for examples of its use.

REM Note: This package requires PL/SQL 2.3 or higher since it uses a 
REM table of records.

CREATE OR REPLACE PACKAGE ExecuteAny AS 
  -- Generic parameter for a stored procedure or function
  TYPE t_Parameter IS RECORD (
    actual_type   VARCHAR2(8),  -- One of 'NUMBER', 'VARCHAR2', 'DATE', 'CHAR'
    actual_length INTEGER,
    name          VARCHAR2(50),
    num_param     NUMBER,
    vchar_param   VARCHAR2(500),
	char_param    CHAR(500),
    date_param    DATE);

  -- Generic parameter list
  TYPE t_ParameterList IS TABLE OF t_Parameter
    INDEX BY BINARY_INTEGER;

  -- Runs an arbitrary procedure.  All of the IN parameters in 
  -- p_Parameters must have at least the _param and actual_type fields
  -- filled in, and all OUT parameters must have the actual_type field
  -- populated.  On output, the name field is populated.
  PROCEDURE RunProc(p_NumParams IN NUMBER,
                    p_ProcName IN VARCHAR2,
                    p_Parameters IN OUT t_ParameterList);

  -- Populates the internal data structures with description about the
  -- procedure given by p_ProcName.  If p_Print is TRUE, this information
  -- is output using DBMS_OUTPUT.
  PROCEDURE DescribeProc(p_ProcName IN VARCHAR2,
                         p_Print IN BOOLEAN);

  -- Displays, using DBMS_OUTPUT, the parameters in p_Parameters.
  PROCEDURE Printparams(p_Parameters IN t_ParameterList,
                        p_NumParams IN NUMBER);

END ExecuteAny; 
/ 
show errors
 
CREATE OR REPLACE PACKAGE BODY ExecuteAny AS 
  -- internal DBMS_DESCRIBE.DESCRIBE_PROCEDURE variables
  v_Overload     DBMS_DESCRIBE.NUMBER_TABLE; 
  v_Position     DBMS_DESCRIBE.NUMBER_TABLE; 
  v_Level        DBMS_DESCRIBE.NUMBER_TABLE; 
  v_ArgumentName DBMS_DESCRIBE.VARCHAR2_TABLE; 
  v_Datatype     DBMS_DESCRIBE.NUMBER_TABLE; 
  v_DefaultValue DBMS_DESCRIBE.NUMBER_TABLE; 
  v_InOut        DBMS_DESCRIBE.NUMBER_TABLE;
  v_Length       DBMS_DESCRIBE.NUMBER_TABLE; 
  v_Precision    DBMS_DESCRIBE.NUMBER_TABLE; 
  v_Scale        DBMS_DESCRIBE.NUMBER_TABLE; 
  v_Radix        DBMS_DESCRIBE.NUMBER_TABLE; 
  v_Spare        DBMS_DESCRIBE.NUMBER_TABLE; 

  -- Local function to convert datatype codes to strings.
  FUNCTION ConvertDatatype(p_Code IN NUMBER)
    RETURN VARCHAR2 IS
    v_Output VARCHAR2(20);
  BEGIN
    SELECT DECODE(p_Code, 0, ' ',
                          1, 'VARCHAR2',
                          2, 'NUMBER',
                          3, 'BINARY_INTEGER',
                          8, 'LONG',
                          11, 'ROWID',
                          12, 'DATE',
                          23, 'RAW',
                          24, 'LONG RAW',
                          96, 'CHAR',
                          106, 'MLSLABEL',
                          250, 'RECORD',
                          251, 'TABLE',
                          252, 'BOOLEAN')
    INTO v_Output
    FROM dual;

    RETURN v_Output;
  END ConvertDatatype;

  -- Local function to convert parameter modes to strings.
  FUNCTION ConvertMode(p_Code IN NUMBER)
    RETURN VARCHAR2 IS
    v_Output VARCHAR2(10);
  BEGIN
    SELECT DECODE(p_Code, 0, 'IN',
                          1, 'IN OUT',
                          2, 'OUT')
      INTO v_Output
      FROM dual;

    RETURN v_Output;
  END ConvertMode;

  PROCEDURE DescribeProc(p_ProcName IN VARCHAR2,
                         p_Print IN BOOLEAN) IS
    v_ArgCounter NUMBER := 1;
  BEGIN
    -- First call DESCRIBE_PROCEDURE to populate the internal variables
	-- about the procedure.
    DBMS_DESCRIBE.DESCRIBE_PROCEDURE( 
      p_ProcName, 
      null, 
      null, 
      v_Overload, 
      v_Position, 
      v_Level, 
      v_ArgumentName, 
      v_Datatype, 
      v_DefaultValue, 
      v_InOut, 
      v_Length, 
      v_Precision, 
      v_Scale, 
      v_Radix, 
      v_Spare);  

    IF NOT p_Print THEN
      RETURN;
    END IF;

    -- Output titles.
    DBMS_OUTPUT.PUT_LINE('Description of ' || p_ProcName || ':');
    DBMS_OUTPUT.PUT('Overload Position Argument Name Level Datatype       ');
    DBMS_OUTPUT.PUT('Mode   Length Precision Scale');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT('-------- -------- ------------- ----- -------------- ');
    DBMS_OUTPUT.PUT('------ ------ --------- -----');
    DBMS_OUTPUT.NEW_LINE;
	
	-- Output information about the parameters.
    LOOP
      BEGIN
        DBMS_OUTPUT.PUT(RPAD(TO_CHAR(v_Overload(v_ArgCounter)), 9));
        DBMS_OUTPUT.PUT(RPAD(TO_CHAR(v_Position(v_ArgCounter)), 9));
        DBMS_OUTPUT.PUT(RPAD(v_ArgumentName(v_ArgCounter), 14));
        DBMS_OUTPUT.PUT(RPAD(TO_CHAR(v_Level(v_ArgCounter)), 6));
        DBMS_OUTPUT.PUT(RPAD(ConvertDatatype(v_Datatype(v_ArgCounter)), 15));
        DBMS_OUTPUT.PUT(RPAD(ConvertMode(v_InOut(v_ArgCounter)), 7));
        DBMS_OUTPUT.PUT(RPAD(TO_CHAR(v_Length(v_ArgCounter)), 7));
        DBMS_OUTPUT.PUT(RPAD(TO_CHAR(v_Precision(v_ArgCounter)), 10));
        DBMS_OUTPUT.PUT(RPAD(TO_CHAR(v_Scale(v_ArgCounter)), 5));
        DBMS_OUTPUT.NEW_LINE;
        v_ArgCounter := v_ArgCounter + 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          EXIT;
      END;
    END LOOP;

  END DescribeProc;

  PROCEDURE RunProc(p_NumParams IN NUMBER,
                    p_ProcName IN VARCHAR2,
                    p_Parameters IN OUT t_ParameterList) IS

    -- DBMS_SQL variables
    v_Cursor  NUMBER; 
    v_NumRows NUMBER; 

    v_ProcCall VARCHAR2(500);
    v_FirstParam BOOLEAN := TRUE;
  BEGIN 

    -- First describe the procedure.
    DescribeProc(p_ProcName, TRUE);

    -- Now we need to create the procedure call string.  This consists of
	-- 'BEGIN <procedure_name>(:p1, :p2, ...); END;'
    v_ProcCall := 'BEGIN ' || p_ProcName || '(';

    FOR v_Counter IN 1..p_NumParams LOOP
      IF v_FirstParam THEN
        v_ProcCall := v_ProcCall || ':' || v_ArgumentName(v_Counter);
        v_FirstParam := FALSE;
      ELSE
        v_ProcCall := v_ProcCall || ', :' || v_ArgumentName(v_Counter);
      END IF;
    END LOOP;

    v_ProcCall := v_ProcCall || '); END;';

    -- Open the cursor and parse the statement.
    v_Cursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_Cursor, v_ProcCall, DBMS_SQL.V7);

    -- Bind the procedure parameters.
    FOR v_Counter IN 1..p_NumParams LOOP
	
      -- First set the parameter name.
      p_Parameters(v_Counter).name := v_ArgumentName(v_Counter);

      -- Bind based on the parameter type.
      IF p_Parameters(v_Counter).actual_type = 'NUMBER' THEN
        DBMS_SQL.BIND_VARIABLE(v_Cursor, p_Parameters(v_Counter).name,
                               p_Parameters(v_Counter).num_param);
      ELSIF p_Parameters(v_Counter).actual_type = 'VARCHAR2' THEN
        DBMS_SQL.BIND_VARIABLE(v_Cursor, p_Parameters(v_Counter).name,
                               p_Parameters(v_Counter).vchar_param, 500);
      ELSIF p_Parameters(v_Counter).actual_type = 'DATE' THEN
        DBMS_SQL.BIND_VARIABLE(v_Cursor, p_Parameters(v_Counter).name,
                               p_Parameters(v_Counter).date_param);
      ELSIF p_Parameters(v_Counter).actual_type = 'CHAR' THEN
        DBMS_SQL.BIND_VARIABLE_CHAR(v_Cursor, p_Parameters(v_Counter).name,
                               p_Parameters(v_Counter).char_param, 500);
      ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Invalid type');
      END IF;
    END LOOP;

    -- Execute the procedure.
    v_NumRows := DBMS_SQL.EXECUTE(v_Cursor);

    -- Call VARIABLE_VALUE for any OUT or IN OUT parameters.
    FOR v_Counter IN 1..p_NumParams LOOP
      IF v_InOut(v_Counter) = 1 OR v_InOut(v_Counter) = 2 THEN
        IF p_Parameters(v_Counter).actual_type = 'NUMBER' THEN
          DBMS_SQL.VARIABLE_VALUE(v_Cursor, ':' || p_Parameters(v_Counter).name,
                                p_Parameters(v_Counter).num_param);
        ELSIF p_Parameters(v_Counter).actual_type = 'VARCHAR2' THEN
          DBMS_SQL.VARIABLE_VALUE(v_Cursor, ':' || p_Parameters(v_Counter).name,
                                p_Parameters(v_Counter).vchar_param);
        ELSIF p_Parameters(v_Counter).actual_type = 'DATE' THEN
          DBMS_SQL.VARIABLE_VALUE(v_Cursor, ':' || p_Parameters(v_Counter).name,
                                p_Parameters(v_Counter).date_param);
        ELSIF p_Parameters(v_Counter).actual_type = 'CHAR' THEN
          DBMS_SQL.VARIABLE_VALUE_CHAR(v_Cursor, ':' || p_Parameters(v_Counter).name,
                                p_Parameters(v_Counter).char_param);
        ELSE
          RAISE_APPLICATION_ERROR(-20001, 'Invalid type');
        END IF;
      END IF;
    END LOOP;

  END RunProc;

  PROCEDURE Printparams(p_Parameters IN t_ParameterList,
                        p_NumParams IN NUMBER) IS
  BEGIN
    -- Loop over the parameters, and print the name, type, and value.
    FOR v_Counter IN 1..p_NumParams LOOP
      DBMS_OUTPUT.PUT('Parameter ' || v_Counter || ': Name = ');
      DBMS_OUTPUT.PUT(p_Parameters(v_Counter).name || ', Type = ');
      DBMS_OUTPUT.PUT(p_Parameters(v_Counter).actual_type || ', Value = ');
      IF p_Parameters(v_Counter).actual_type = 'NUMBER' THEN
        DBMS_OUTPUT.PUT_LINE(p_Parameters(v_Counter).num_param);
      ELSIF p_Parameters(v_Counter).actual_type = 'VARCHAR2' THEN
        DBMS_OUTPUT.PUT_LINE(p_Parameters(v_Counter).vchar_param);
      ELSIF p_Parameters(v_Counter).actual_type = 'DATE' THEN
        DBMS_OUTPUT.PUT_LINE(p_Parameters(v_Counter).date_param);
      ELSE
        DBMS_OUTPUT.PUT_LINE(p_Parameters(v_Counter).char_param);
      END IF;
    END LOOP;
  END PrintParams;

END ExecuteAny; 
/ 

show errors


