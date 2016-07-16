REM dyndemo.sql
REM Version 1.0, last updated 7/20/97
REM This package illustrates the dynamic SQL features of OWA_UTIL, as
REM described in Chapter 19 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PACKAGE DynamicDemo AS
  PROCEDURE Go;
  PROCEDURE Process(p_Query IN VARCHAR2 DEFAULT NULL,
                    p_Type IN VARCHAR2);
  PROCEDURE ListProcess(p_Value IN VARCHAR2 DEFAULT NULL);
END DynamicDemo;
/

CREATE OR REPLACE PACKAGE BODY DynamicDemo AS
  -- Set c_OWAPath to the virtual path (including the DCD) where
  -- the Oracle Web Agent is installed.
  c_OWAPath CONSTANT VARCHAR2(50) := '/example/owa/';

  PROCEDURE ShowForm IS
  BEGIN
    HTP.line;
    HTP.p('Enter a query in the box below, and select the output ');
    HTP.p('type, then click ''Submit''.  If you choose the picklist, ');
    HTP.p('then your query should be of the following form: ');
    HTP.nl;
    HTP.p('Column 1: Result returned for this item' || HTF.nl);
    HTP.p('Column 2: String displayed for this item' || HTF.nl);
    HTP.p('Column 3: NULL or non-NULL.  If non-NULL, the current ');
    HTP.p('field will be flagged as selected.' || HTF.para);
    -- First open the form, specifying the Process procedure as the
    -- target URL.
    HTP.formOpen(curl => c_OWAPath || 'DynamicDemo.Process');
    HTP.formTextArea(cname => 'p_Query',
                     nrows => 5,
                     ncolumns => 40);
    HTP.nl;
    HTP.p('Output type: ');
    HTP.p('HTML Table');
    HTP.formRadio(cname => 'p_Type',
                  cvalue => 'table',
                  cchecked => 'CHECKED');
    HTP.p('Picklist');
    HTP.formRadio(cname => 'p_Type',
                  cvalue => 'list');
    HTP.formSubmit;
  END ShowForm;

  /* Main entry procedure. */
  PROCEDURE Go IS
  BEGIN
    HTP.htmlOpen;
    HTP.headOpen;
    HTP.title('OWA_UTIL Dynamic SQL Utilities Demo');
    HTP.headClose;

    HTP.bodyOpen;
    ShowForm;
    OWA_UTIL.signature('DynamicDemo.Go');
    HTP.bodyClose;
    HTP.htmlClose;
  END Go;

  /* Processes the main form. */
  PROCEDURE Process(p_Query IN VARCHAR2 DEFAULT NULL,
                    p_Type IN VARCHAR2) IS
    v_CursorID INTEGER;
  BEGIN
    HTP.htmlOpen;
    HTP.headOpen;
    HTP.title('Query Results');
    HTP.headClose;

    HTP.bodyOpen;
    v_CursorID := OWA_UTIL.bind_variables(p_Query);
    HTP.p('Output from query ');
    HTP.bold(p_Query);
    HTP.p(':' || HTF.para);
    IF p_Type = 'table' THEN
      HTP.tableOpen(cborder => 'BORDER=1');
      OWA_UTIL.cellsprint(v_CursorID);
      HTP.tableClose;
    ELSE
      HTP.formOpen(curl => c_OWAPath || 'DynamicDemo.ListProcess');
      OWA_UTIL.listprint(v_CursorID, 'p_Value', 10);
      HTP.formSubmit;
      HTP.formClose;
    END IF;
    ShowForm;
    OWA_UTIL.signature('DynamicDemo.Process');
    HTP.bodyClose;
    HTP.htmlClose;
  END Process;

  /* Processes the form containing the picklist. */
  PROCEDURE ListProcess(p_Value IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    HTP.htmlOpen;
    HTP.headOpen;
    HTP.title('List Results');
    HTP.headClose;

    HTP.bodyOpen;
    HTP.p('You picked ' || p_Value || '.');
    ShowForm;
    OWA_UTIL.signature('DynamicDemo.ListProcess');
    HTP.bodyClose;
    HTP.htmlClose;
  END ListProcess;
END DynamicDemo;
/
