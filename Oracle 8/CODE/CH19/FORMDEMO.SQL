REM formdemo.sql
REM Version 1.0, last updated 7/15/97
REM This package demonstrates the use of HTML forms, as described in
REM Chapter 19 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PACKAGE FormDemo AS
  PROCEDURE Go;
  PROCEDURE Process(p_Checkbox IN VARCHAR2 DEFAULT 'off',
                    p_Password IN VARCHAR2 DEFAULT NULL,
                    p_Radio IN VARCHAR2 DEFAULT NULL);
END FormDemo;
/

CREATE OR REPLACE PACKAGE BODY FormDemo AS
  -- Set c_OWAPath to the virtual path (including the DCD) where
  -- the Oracle Web Agent is installed.
  c_OWAPath CONSTANT VARCHAR2(50) := '/example/owa/';

  PROCEDURE ShowForm IS
  BEGIN
    HTP.line;
    -- First open the form, specifying the Process procedure as the
    -- target URL.
    HTP.formOpen(curl => c_OWAPath || 'FormDemo.Process');

    -- Now print some text, followed by input devices.
    HTP.p('Welcome to a HTML form.  Fill out some information below, ');
    HTP.p('and press the ''Submit'' button to process it.');
    HTP.p('Press ''Reset'' to clear your entries.');
    HTP.para;

    HTP.p('Here is a checkbox: ');
    HTP.formCheckbox(cname => 'p_CheckBox');
    HTP.para;
    HTP.p('Here is a password entry: ');
    HTP.formPassword(cname => 'p_Password',
                     csize => 10);
    HTP.para;
    HTP.p('Select one of the following radio buttons:');
    HTP.nl;
    HTP.formRadio(cname => 'p_Radio', cvalue => 'One');
    HTP.p('One');
    HTP.formRadio(cname => 'p_Radio', cvalue => 'Two');
    HTP.p('Two');
    HTP.formRadio(cname => 'p_Radio', cvalue => 'Three');
    HTP.p('Three' || HTF.nl);
    HTP.formRadio(cname => 'p_Radio', cvalue => 'Four');
    HTP.p('Four');
    HTP.formRadio(cname => 'p_Radio', cvalue => 'Five');
    HTP.p('Five' || HTF.para);
    HTP.formSubmit;
    HTP.formReset;
    HTP.formClose;
  END ShowForm;

  PROCEDURE Process(p_Checkbox IN VARCHAR2 DEFAULT 'off',
                    p_Password IN VARCHAR2 DEFAULT NULL,
                    p_Radio IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    HTP.htmlOpen;
    HTP.headOpen;
    HTP.title('Form Results');
    HTP.headClose;

    HTP.bodyOpen;
    HTP.header(2, 'Form Results:');
    HTP.p('p_Checkbox = ' || p_Checkbox || HTF.nl);
    HTP.p('p_Password = ' || p_Password || HTF.nl);
    HTP.p('p_Radio = ' || p_Radio || HTF.para);
    ShowForm;
    OWA_UTIL.signature('FormDemo.Process');
    HTP.bodyClose;
    HTP.htmlClose;
  END Process;

  PROCEDURE Go IS
  BEGIN
    HTP.htmlOpen;
    HTP.headOpen;
    HTP.title('Forms Demo');
    HTP.headClose;

    HTP.bodyOpen;
    ShowForm;
    OWA_UTIL.signature('FormDemo.Go');
    HTP.bodyClose;
    HTP.htmlClose;
  END Go;
END FormDemo;
/
