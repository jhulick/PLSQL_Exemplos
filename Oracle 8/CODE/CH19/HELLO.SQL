REM hello.sql
REM Version 1.0, last updated 6/23/97
REM This procedure is a simple example which can be called by the PL/SQL Web
REM agent, as described in Chapter 19 of _Oracle8 PL/SQL Programming_
REM by Scott Urman.

CREATE OR REPLACE PROCEDURE hello(p_Greeting IN VARCHAR2) AS
BEGIN
  HTP.htmlOpen;
  HTP.headOpen;
  HTP.Title('Hello World!');
  HTP.headClose;
  HTP.bodyOpen;
  HTP.print(p_Greeting);
  HTP.bodyClose;
  HTP.htmlClose;
END hello;
/
