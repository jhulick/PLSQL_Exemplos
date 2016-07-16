REM cookie.sql
REM Version 1.0, last updated 6/25/97
REM This package demonstrates the use of HTTP cookies, as described in
REM Chapter 19 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE CookieDemo(p_NewVal IN NUMBER DEFAULT NULL) AS
  -- Set c_OWAPath to the virtual path (including the DCD) where
  -- the Oracle Web Agent is installed.
  c_OWAPath CONSTANT VARCHAR2(50) := '/example/owa/';

  v_Cookie OWA_COOKIE.COOKIE;

BEGIN
  -- Retrieve the current value of the cookie, and send the new value
  -- based on the parameters.
  v_Cookie := OWA_COOKIE.GET('Count');
  OWA_UTIL.MIME_HEADER('text/html', FALSE);
  IF p_NewVal IS NOT NULL THEN
    OWA_COOKIE.SEND('Count', p_NewVal + 1);
  ELSIF (v_Cookie.num_vals = 0) THEN
    OWA_COOKIE.SEND('Count', 0);
  ELSE
    OWA_COOKIE.SEND('Count', v_Cookie.vals(1) + 1);
  END IF;
  OWA_UTIL.HTTP_HEADER_CLOSE;

  HTP.htmlOpen;
  HTP.headOpen;
  HTP.title('Cookie Demo');
  HTP.headClose;

  HTP.bodyOpen;
  HTP.print('Welcome to the cookie demo, using the OWA_COOKIE ');
  HTP.print('package.' || HTF.para);
  IF p_NewVal IS NOT NULL THEN
    HTP.print('The cookie value has been reset to ');
    HTP.bold(p_NewVal);
    HTP.print('.' || HTF.para);
  ELSIF v_Cookie.num_vals > 0 THEN
    HTP.print('The cookie value is now ');
    HTP.bold(v_Cookie.vals(1));
    HTP.print('.' || HTF.para);
  ELSE
    HTP.print('The cookie value has been set to zero.');
  END IF;
  HTP.para;
  HTP.print('Click ');
  HTP.anchor(c_OWAPath || 'CookieDemo', 'here');
  HTP.print(' to increment the value, or enter a new value in the box');
  HTP.print(' below and click Submit to reset it.' || HTF.para);

  HTP.formOpen(curl => c_OWAPath || 'CookieDemo');
  HTP.formText(cname => 'p_NewVal',
               csize => 10);
  HTP.formSubmit;
  HTP.formClose;

  OWA_UTIL.signature('CookieDemo');
  HTP.bodyClose;
  HTP.htmlClose;
END CookieDemo;
/

