REM bodydemo.sql
REM Version 1.0, last updated 6/24/97
REM This procedure demonstrates the use of some of the body tags available with
REM the PL/SQL web agent, as described in Chapter 19 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE BodyDemo AS
BEGIN
  HTP.htmlOpen;
  HTP.headOpen;
  HTP.title('Body tags demo');
  HTP.headClose;

  HTP.bodyOpen;
  HTP.print('This page demonstrates several of the tags ');
  HTP.print('available for formatting the text in the body ');
  HTP.print('of a web page, and for inserting additional ');
  HTP.print('tags.' || HTF.para);

  HTP.header(2, 'Links');
  HTP.print('Here are some links to check out.  These are ');
  HTP.print('generated using the HTP.anchor procedure.');
  HTP.para;
  HTP.anchor('//www.oracle.com/', 'Oracle Corporation');
  HTP.para;
  HTP.anchor('//www.osborne.com/oracle/index.htm', 'Oracle Press');
  HTP.para;
  HTP.anchor('//www.platinum.com/', 'Platinum Corporation');
  HTP.para;

  HTP.header(2, 'Formats');
  HTP.print(HTF.centerOpen || 'These lines are centered, using ');
  HTP.br;
  HTP.print('the HTF.centerOpen and HTF.centerClose functions.');
  HTP.centerClose;

  HTP.strike('Here''s some strikethrough text.');
  OWA_UTIL.signature('BodyDemo');
  HTP.bodyClose;
  HTP.htmlClose;
END BodyDemo;
/
