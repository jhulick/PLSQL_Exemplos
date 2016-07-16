Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
Rem    NAME
Rem      simple.sql
Rem    DESCRIPTION
Rem      
Rem    RETURNS
Rem 
Rem    NOTES
Rem      
Rem    MODIFIED   (MM/DD/YY)
Rem     mfreedma      09/11/96 -  Added Banner 

CREATE OR REPLACE PROCEDURE sample1
IS
   v_date DATE;
BEGIN
   htp.htmlOpen;
   htp.headOpen;
   htp.title('Hello World!');
   htp.headClose;
   htp.bodyOpen;
   htp.line;
   htp.img('/ows-img/ows.gif');
   htp.header(1,'Hello World!');
   htp.line;

   htp.paragraph;
   htp.print(To_char(Sysdate, 'DAY') || 'is my favorite day of the week.');

   htp.paragraph;
   htp.print('You can still even use tags that are not in the HTP/HTF library by just including them <BLINK>directly</BLINK> in the text.');

   htp.paragraph;
   htp.paragraph;
   htp.anchor('/sample-src/OWA/simple.sql','Show Source');
   htp.line;

   htp.address('(c)1996 Oracle Corporation');
   
   htp.bodyClose;
   htp.htmlClose;
END;
/
show errors
