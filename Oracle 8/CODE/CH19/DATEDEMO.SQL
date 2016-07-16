REM datedemo.sql
REM Version 1.0, last updated 7/21/97
REM This package illustrates teh date utilities in OWA_UTIL, as described in
REM Chapter 19 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DROP TABLE calendar;

CREATE TABLE calendar (
  today        DATE,
  description  VARCHAR2(25),
  link         VARCHAR2(20)
  );

INSERT INTO calendar (today, description, link)
  VALUES (SYSDATE - 5, 'Hello!', '//www.oracle.com');
INSERT INTO calendar (today, description, link)
  VALUES (SYSDATE - 4, 'Getting there...', '//www.oracle.com');
INSERT INTO calendar (today, description, link)
  VALUES (SYSDATE - 3, 'How''s it going?', '//www.oracle.com');
INSERT INTO calendar (today, description, link)
  VALUES (SYSDATE - 2, 'Soon...', '//www.oracle.com');
INSERT INTO calendar (today, description, link)
  VALUES (SYSDATE - 1, 'Tomorrow, tomorrow', '//www.oracle.com');
INSERT INTO calendar (today, description, link)
  VALUES (SYSDATE, 'Made it!', '//www.oracle.com');
INSERT INTO calendar (today, description, link)
  VALUES (SYSDATE + 1, 'Did you miss it?', '//www.oracle.com');
INSERT INTO calendar (today, description, link)
  VALUES (SYSDATE + 2, 'Sure hope not...', '//www.oracle.com');
INSERT INTO calendar (today, description, link)
  VALUES (SYSDATE + 3, 'It was pretty cool', '//www.oracle.com');
INSERT INTO calendar (today, description, link)
  VALUES (SYSDATE + 4, 'Better luck next year', '//www.oracle.com');
INSERT INTO calendar (today, description, link)
  VALUES (SYSDATE + 5, 'Goodbye!', '//www.oracle.com');
COMMIT;

CREATE OR REPLACE PACKAGE DateDemo AS
  PROCEDURE Go;
  PROCEDURE Process(p_DateVal IN OWA_UTIL.dateType);
END DateDemo;
/

CREATE OR REPLACE PACKAGE BODY DateDemo AS
  -- Set c_OWAPath to the virtual path (including the DCD) where
  -- the Oracle Web Agent is installed.
  c_OWAPath CONSTANT VARCHAR2(50) := '/example/owa/';

  -- Receives the date selected.
  PROCEDURE Process(p_DateVal IN OWA_UTIL.dateType) IS
  BEGIN
    HTP.htmlOpen;
    HTP.headOpen;
    HTP.title('Results');
    HTP.headClose;
    HTP.bodyOpen;
    HTP.p('You picked ');
    HTP.p(TO_CHAR(OWA_UTIL.todate(p_DateVal)));
    HTP.nl;
    OWA_UTIL.signature('DateDemo.Process');
    HTP.bodyClose;
    HTP.htmlClose;
  END Process;

  -- Main entry procedure.
  PROCEDURE Go IS
  BEGIN
    HTP.htmlOpen;
    HTP.headOpen;
    HTP.title('OWA_UTIL Date Utilities');
    HTP.headClose;

    HTP.bodyOpen;
    HTP.p('Welcome to the Date demo.  Here''s a calendar, created ');
    HTP.p('with ' || HTF.bold('OWA_UTIL.calendarprint'));
    HTP.p(':' || HTF.nl);
    OWA_UTIL.calendarprint('SELECT * FROM calendar ORDER BY today');

    HTP.para;
    HTP.p('Enter a year, month, and day below, and then press submit:');
    HTP.nl;
    HTP.formOpen(curl => c_OWAPath || 'DateDemo.Process');
    OWA_UTIL.choose_date(p_name => 'p_DateVal');
    HTP.formSubmit;
    HTP.formClose;
    OWA_UTIL.signature('DateDemo.Go');
    HTP.bodyClose;
    HTP.htmlClose;
  END Go;
END DateDemo;
/
