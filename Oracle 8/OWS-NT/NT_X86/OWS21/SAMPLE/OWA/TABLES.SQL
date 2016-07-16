Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
Rem    NAME
Rem      tables.sql
Rem    DESCRIPTION
Rem      
Rem    RETURNS
Rem 
Rem    NOTES
Rem      
Rem    MODIFIED   (MM/DD/YY)
Rem     mfreedma      09/11/96 -  Added Banner 

CREATE OR REPLACE PROCEDURE sample2_form
  IS
BEGIN
   htp.htmlopen;
   htp.headopen;
   htp.title('Sample 2 Form');
   htp.headclose;
   htp.bodyopen;
   htp.line;
   htp.img('/ows-img/ows.gif');
   htp.header(1,'Sample 2 Form');
   htp.line;

   htp.em('Click on a few people and click "Go":');
   htp.paragraph;

   htp.formopen('sample2_result');
   htp.formhidden('COLS','dummy');
   htp.formcheckbox('COLS','Mill');
   htp.print('Mill');
   htp.nl;
   htp.formcheckbox('COLS','Hobbes');
   htp.print('Hobbes');
   htp.nl;
   htp.formcheckbox('COLS','Locke');
   htp.print('Locke');
   htp.nl;
   htp.formcheckbox('COLS','Kropotkin');
   htp.print('Kropotkin');
   htp.nl;
   htp.formcheckbox('COLS','Marx');
   htp.print('Marx');
   htp.nl;
   htp.formcheckbox('COLS','Nietzsche');
   htp.print('Nietzsche');
   htp.paragraph;
   htp.formsubmit(NULL,'Go');
   htp.formclose;
   htp.paragraph;
   htp.anchor('/sample-src/OWA/tables.sql','Show Source');
   htp.line;
   htp.address('(c)1996 Oracle Corporation');
   htp.bodyclose;
   htp.htmlclose;
END;
/
show errors
  
CREATE OR REPLACE PROCEDURE sample2_result
  (cols IN owa_util.ident_arr)
  IS
     col_counter INTEGER;
BEGIN
   htp.htmlopen;
   htp.headopen;
   htp.title('Sample 2 Results');
   htp.headclose;
   htp.bodyopen;
   htp.line;
   htp.img('/ows-img/ows.gif');
   htp.header(1, 'Sample 2 Results');
   htp.line;
   htp.paragraph;
   col_counter := 2;
   LOOP
      htp.print(cols(col_counter)|| ' has some very interesting writings.');
      htp.paragraph;
      col_counter := col_counter + 1;
   END LOOP;
EXCEPTION
   WHEN no_data_found
     THEN
      htp.paragraph;
      htp.anchor('/sample-src/OWA/tables.sql','Show Source');
      htp.line;
      htp.address('(c)1996 Oracle Corporation');
      htp.bodyclose;
      htp.htmlclose;
END;
/
show errors
  
      
  
