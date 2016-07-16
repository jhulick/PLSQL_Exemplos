rem 
rem $Header: cat716.sql,v 1.1 1993/07/06 11:53:30 wbridge Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      cat716.sql - Migrate 7.0.15 to 7.0.16
Rem    DESCRIPTION
Rem      RIGHT AFTER A 7.0.15 DATABASE IS STARTED UP USING 7.0.16
Rem      FOR THE FIRST TIME, RUN THIS SCRIPT ONCE AS INTERNAL.
Rem      A 7.0.15 database is a database that has been created using
Rem      7.0.15 release or upgraded to use 7.0.15 release.
Rem    MODIFIED   (MM/DD/YY)
Rem     wbridge    07/02/93 -  Creation
 
create or replace view v_$controlfile as select * from v$controlfile;
drop public synonym v$controlfile;
create public synonym v$controlfile for v_$controlfile;

