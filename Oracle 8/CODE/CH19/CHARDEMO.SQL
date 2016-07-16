REM chardemo.sql
REM Version 1.0, last updated 7/15/97
REM This procedure illustrates some character formatting tags, as described
REM in Chapter 19 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE CharDemo AS
BEGIN
  HTP.htmlOpen;
  HTP.headOpen;
  HTP.title('Character Formatting Tags');
  HTP.headClose;

  HTP.bodyOpen;
  HTP.header(2, 'This page demonstrates character formatting tags.');
  HTP.para;
  HTP.cite('This text is a citation, usually rendered as italics.');
  HTP.para;
  HTP.code('This text is code, usually rendered as a monospace font.');
  HTP.para;
  HTP.strong('This text is strong, usually rendered as bold.');
  HTP.para;

  OWA_UTIL.signature('CharDemo');
  HTP.bodyClose;
  HTP.htmlClose;
END CharDemo;
/
