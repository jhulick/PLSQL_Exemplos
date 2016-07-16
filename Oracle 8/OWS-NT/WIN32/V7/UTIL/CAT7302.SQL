rem 
rem $Header: cat7302.sql,v 1.2 1996/01/04 13:28:32 cracicot Exp $ 
rem 
Rem  Copyright (c) 1995 by Oracle Corporation 
Rem    NAME
Rem      cat7302.sql - migrate Oracle RDBMS from version 7.3.1 to 7.3.2
Rem    DESCRIPTION
Rem
Rem    RETURNS
Rem 
Rem    NOTES
Rem      RIGHT AFTER A 7.3.1 DATABASE IS STARTED UP USING 7.3.2
Rem      FOR THE FIRST TIME, RUN THIS SCRIPT ONCE AS INTERNAL.
Rem      A 7.3.1 database is a database that has been created using
Rem      the 7.3.1 release or upgraded to use the 7.3.1 release.
Rem    MODIFIED   (MM/DD/YY)
Rem     cracicot   12/06/95 -  invalidate pl/sql objects on upgrade
Rem     jstamos    08/29/95 -  Creation
 
rem Increase size of error message columns
ALTER TABLE system.def$_error MODIFY(error_msg VARCHAR2(2000))
/
ALTER TABLE system.def$_destination MODIFY(last_msg VARCHAR2(2000))
/
UPDATE obj$ SET status=5 WHERE type=7 OR type=8 OR type=9 OR type=11;
