rem 
rem $Header: catproc.sql big_dev/1 07-jun-95.11:36:36 dsdaniel Exp $ 
rem $Header: catproc.sql 7.3_CDM/0 29-sep-95.16:54:21 emendez Exp $ 
rem 
Rem  Copyright (c) 1991, 1995 by Oracle Corporation 
Rem    NAME
Rem      catproc.sql
Rem    DESCRIPTION
Rem	 Run all sql scripts for the procedural option
Rem    RETURNS
Rem 
Rem    NOTES
Rem      This script must be run while connectd as SYS or INTERNAL.
Rem    MODIFIED   (MM/DD/YY)
Rem     emendez    09/29/95 -
Rem     dposner    04/26/95 -  Adding fileio packages
Rem     dsdaniel   06/07/95 -  clean up .plb
Rem     kmuthukk   03/13/95 -  add plitblm.sql for pl/sql index-table methods
Rem     wmaimone   05/06/94 -  #184921 run as sys/internal
Rem     dsdaniel   04/07/94 -  merge changes from branch 1.5.710.5
Rem     adowning   03/29/94 -  merge changes from branch 1.5.710.[6,7]
Rem     adowning   02/23/94 -  use prvt*.sql for non-replication
Rem     adowning   02/02/94 -  incorporate public/private file splits
Rem     dsdaniel   01/31/94 -  add dbmspexp.sql for export extensions
Rem     rjenkins   01/19/94 -  merge changes from branch 1.5.710.4
Rem     dsdaniel   01/18/94 -  merge changes from branch 1.5.710.2
Rem     rjenkins   12/08/93 -  un-merging dbmssyer
Rem     rjenkins   11/17/93 -  merge changes from branch 1.5.710.3
Rem     rjenkins   12/20/93 -  creating job queue
Rem     rjenkins   11/03/93 -  do dbmssnap after dbmssql
Rem     dsdaniel   10/30/93 -  add dbmssyer.sql
Rem     dsdaniel   10/29/93 -  run catdefr instead of dbmsdfrd
Rem     rjenkins   10/20/93 -  merge changes from branch 1.5.710.1
Rem     rjenkins   10/14/93 -  calling dbmsdfrd.sql
Rem     rjenkins   10/07/93 -  run dbmsdfrd.sql
Rem     hjakobss   07/09/93 -  add dbmssql
Rem     mmoore     11/03/92 -  add dbmsdesc 
Rem     glumpkin   10/26/92 -  Change catremot catrpc 
Rem     glumpkin   10/25/92 -  Change catstdx.sql to dbmsstdx.sql 
Rem     glumpkin   10/25/92 -  Creation 

Rem basic procedural views
@@catprc
@@catjobq
@@catsnap

Rem Remote views
@@catrpc

Rem Views and tables for deferred RPC
@@catdefer

Rem Setup for pl/sql
@@standard
@@dbmsstdx
@@pipidl
@@pidian
@@diutil
@@pistub
@@plitblm
Rem packages implementing PL/SQL file data type
@@utlfile
@@prvtfile.plb

Rem pl/sql packages used for rdbms functionality
@@dbmsutil
@@prvtutil.plb
@@dbmssyer
@@prvtsyer.plb
@@dbmslock
@@prvtlock.plb
@@dbmspipe
@@prvtpipe.plb
@@dbmsalrt
@@prvtalrt.plb
@@dbmsotpt
@@prvtotpt.plb
@@dbmsdesc
@@prvtdesc.plb
@@dbmssql
@@prvtsql.plb
@@dbmspexp
@@prvtpexp.plb
@@dbmsjob
@@prvtjob.plb
Rem dbmsdfrd is replaced by dbmsdefr for the replication option
@@dbmsdfrd
@@prvtdfrd.plb
@@dbmssnap
@@prvtsnap.plb
