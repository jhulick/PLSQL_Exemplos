REM prntdemo.sql
REM Version 1.0, last updated 6/23/97
REM This procedure demonstrates the use of HTP.print to output HTML code, as
REM described in Chapter 19 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE PrintDemo AS
BEGIN
  -- This procedure uses PRINT to output all of the HTML.
  -- The HTP and HTF packages contain utility procedures which can
  -- accomplish much of the same functionality.
  HTP.print('<HTML>');
  HTP.print('This is a demonstration of the ');
  HTP.print('<STRONG>HTP.print</STRONG> procedure.  It can be ');
  HTP.print('used to output additional tags that are not in ');
  HTP.print('HTP and HTF, such as the ');
  HTP.print('<BLINK>BLINK</BLINK> tag.');
  OWA_UTIL.signature('PrintDemo');
  HTP.print('</HTML>');
END PrintDemo;
/
