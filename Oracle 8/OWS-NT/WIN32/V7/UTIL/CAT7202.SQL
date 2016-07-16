rem 
rem $Header: cat7202.sql,v 1.3 1995/02/07 10:44:11 hasun Exp $ 
rem 
Rem  Copyright (c) 1995 by Oracle Corporation 
Rem    NAME
Rem      cat7202.sql - Migrate  7.2.1 to 7.2.2
Rem    DESCRIPTION
Rem      RIGHT AFTER A 7.2.1 DATABASE IS STARTED UP USING 7.2.2
Rem      FOR THE FIRST TIME, RUN THIS SCRIPT ONCE AS INTERNAL.
Rem      A 7.2.1 database is a database that has been created using
Rem      7.2.1 release or upgraded to use 7.2.1 release.
Rem    RETURNS
Rem 
Rem    NOTES
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     hasun      02/07/95 -  merge changes from branch 1.1.720.2
Rem     hasun      01/31/95 -  merge changes from branch 1.1.720.1
Rem     hasun      01/31/95 -  Correct header information
Rem     hasun      01/30/95 -  Branch_for_patch
Rem     hasun      01/24/95 -  Creation
 
ALTER TABLE system.repcat$_generated ADD
(
  CONSTRAINT repcat$_repgen_primary 
    PRIMARY KEY(sname, oname, type)
)
/
