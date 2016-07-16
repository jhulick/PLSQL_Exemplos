Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
Rem    NAME
Rem      cookies.sql
Rem    DESCRIPTION
Rem      
Rem    RETURNS
Rem 
Rem    NOTES
Rem      
Rem    MODIFIED   (MM/DD/YY)
Rem     mfreedma      09/11/96 -  Added Banner 



CREATE OR REPLACE PROCEDURE cookiejar
  IS
     v_names owa_cookie.vc_arr;
     v_vals owa_cookie.vc_arr;
     v_num_vals INTEGER;
     v_cookie owa_cookie.cookie;
BEGIN

   v_cookie := owa_cookie.get('COUNT');

   owa_util.mime_header('text/html', FALSE);
   IF (v_cookie.num_vals > 0) THEN
      owa_cookie.send('COUNT', v_cookie.vals(1) + 1, Sysdate + 1);
    ELSE
      owa_cookie.send('COUNT', 1, Sysdate + 1);
   END IF;
   owa_util.http_header_close;

   htp.htmlopen;
   htp.headopen;
   htp.title('C is for Cookie');
   htp.headclose;
   htp.bodyopen;

   htp.line;
   htp.img('/ows-img/ows.gif');
   htp.header(1,'C is for Cookie');
   htp.line;

   IF (v_cookie.num_vals > 0) THEN
      htp.print('You have visited this page ' || htf.strong(v_cookie.vals(1) + 1) || ' times in the last 24 hours.');
    ELSE
      htp.print('This is the first time you have visited this page in the last 24 hours.');
   END IF;

   htp.line;
   htp.em('Each time you visit the page, the count will be incremented by one, as long as you are using a cookie enabled browser.  This state is kept in the browser in the form of a cookie, rather than having the server keep track of it.');
   htp.paragraph;
   htp.anchor('/sample-src/OWA/cookies.sql','Show Source');
   htp.line;
   htp.address('(c)1996 Oracle Corporation');
   htp.bodyclose;
   htp.htmlclose;
END;
/
show errors
