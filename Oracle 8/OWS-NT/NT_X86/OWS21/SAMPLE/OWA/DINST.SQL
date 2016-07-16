Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
Rem    NAME
Rem      dinst.sql
Rem    DESCRIPTION
Rem      
Rem    RETURNS
Rem 
Rem    NOTES
Rem      
Rem    MODIFIED   (MM/DD/YY)
Rem     mfreedma      09/11/96 -  Added Banner 

drop procedure sample1;
drop procedure sample2_form;
drop procedure sample2_result;
drop procedure cookiejar;

-- Drop OWA_EXTENSION_DEMO procedures

drop procedure oext_ogtg_html_begin;
drop procedure oext_ogtg_html_end;

drop procedure owaext_demo_table1;
drop procedure owaext_demo_table2;

drop package owaext_demo_list1;

drop procedure owaext_demo_choose_date;
drop procedure owaext_demo_cal;

-- Drop OWA_OPT_LOCK_DEMO procedures

drop procedure oolk_ogtg_html_begin;
drop procedure oolk_ogtg_html_end;
drop package owaoptlk_demo_hidden;
drop package owaoptlk_demo_pure_checksum;
drop package owaoptlk_demo_nonpure_checksum;

drop table owaoptlk_demo;

