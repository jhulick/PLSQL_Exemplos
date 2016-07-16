rem 
rem $Header: cat7201.sql,v 1.3 1995/05/12 16:15:55 varora Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      cat7201.sql - upgrade Oracle RDBMS from version 7.1.X to 7.2.1
Rem    DESCRIPTION
Rem
Rem    NOTES
Rem      Run this as INTERNAL.  Run it before installing catalog or pl/sql.
Rem      It is safe to run it on 7.1.2.
Rem    MODIFIED   (MM/DD/YY)
Rem     varora     05/10/95 -  remove view exu7cpo
Rem     vraghuna   08/18/94 -  bump up export compatibility
Rem     jbellemo   06/24/94 -  Creation
 
rem
rem Trusted Stored Procedures
rem
create table objpriv$                       /* privileges granted to objects */
( obj#          number not null,                            /* object number */
  privilege#    number not null)                         /* privilege number */
/

REM This will get bumped up as the views evolve. The insert is needed
REM for upgrades from 7.0 or new databases. The update is needed for 
REM databases that have older compatibility.
REM These are the releases when the compatibility was bumped:
REM    7.0.* - no compatibility - assume zero
REM    7.1.3 - set to one
REM    7.2.1 - set to two
insert into props$ 
select 'EXPORT_VIEWS_VERSION', '2', 'Export views revision #' from dual
where not exists
  (select 'x' from props$ where name = 'EXPORT_VIEWS_VERSION')
/
update props$ set value$ = 2 where name = 'EXPORT_VIEWS_VERSION'
/
commit
/
