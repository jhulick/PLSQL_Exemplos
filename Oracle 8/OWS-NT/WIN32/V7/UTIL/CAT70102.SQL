rem 
rem $Header: cat70102.sql,v 1.3 1995/05/12 16:14:49 varora Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      cat70102.sql - 7.1.1 to 7.1.2 upgrade script
Rem    DESCRIPTION
Rem      Script for upgrading from 7.1.1 to 7.1.2
Rem    NOTES
Rem      Must be run while connected as internal.
Rem    MODIFIED   (MM/DD/YY)
Rem     varora     05/10/95 -  remove v$nls_valid_values, catsvrmg
Rem     gdoherty   11/08/93 -  Add V$NLS_VALID_VALUES
Rem     gdoherty   11/08/93 -  Add Server Manager script calls
Rem     dleary     11/04/93 -  Creation
rem 
rem The following is required by the parallel query option:
create sequence ora_tq_base$
  start with 1
  increment by 1
  nominvalue
  nomaxvalue
  nocache
  noorder
  nocycle
/

