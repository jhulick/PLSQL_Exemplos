rem 
rem $Header: cattrust.sql,v 1.4 1995/10/10 11:10:54 jbellemo Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      cattrust.sql - views for Trusted ORACLE
Rem    DESCRIPTION
Rem
Rem    RETURNS
Rem 
Rem    NOTES
Rem     This script must be run at DBLOW while connect as SYS or INTERNAL.
Rem    MODIFIED   (MM/DD/YY)
Rem     jbellemo   10/04/95 -  merge changes from branch 1.3.720.1
Rem     jbellemo   07/01/95 -  add public synonyms for v$ views
Rem     wmaimone   05/06/94 -  #184921 run as sys/internal
Rem     wmaimone   11/05/92 -  fix all_labels synonym 
Rem     glumpkin   10/21/92 -  Renamed from TRUSTED.SQL 
Rem     jbellemo   06/29/92 -  add rawtolab function to olab in all_label 
Rem     wmaimone   04/06/92 -  Creation 

Rem
Rem TRUSTED ORACLE fixed views
Rem
create or replace view v_$secondary as select * from v$secondary;
drop public synonym v$secondary;
create public synonym v$secondary for v_$secondary;

create or replace view v_$syslabel as select * from v$syslabel;
drop public synonym v$syslabel;
create public synonym v$syslabel for v_$syslabel;


Rem
Rem Family TRUSTED ORACLE
Rem
Rem These view are relevent only to Trusted ORACLE

create view ALL_MOUNTED_DBS 
  (NAME, DBLOW, DBHIGH, MOUNT_MODE, STATUS, MAC_MODE, TYPE)
as
select m.name,s.dblow,s.dbhigh, m.mtmode,m.status,
 decode(bitand(flags,4),4,'DBMAC','OSMAC'),'SECONDARY' type
from v$secondary m,v$syslabel s where m.mid = s.mid
union all
select d.name,s.dblow,s.dbhigh,upper(p.value),'OPEN',
decode(bitand(flags,4),4,'DBMAC','OSMAC'),'PRIMARY'
from v$database d,v$syslabel s,v$parameter p
where s.mid = 0 and p.name = 'db_mount_mode'
/
comment on table ALL_MOUNTED_DBS is 'All databases mounted by this instance'
/
comment on column ALL_MOUNTED_DBS.NAME is 'Database name'
/
comment on column ALL_MOUNTED_DBS.DBLOW is 'Active value of DBLOW'
/
comment on column ALL_MOUNTED_DBS.DBHIGH is 'Active value of DBHIGH'
/
comment on column ALL_MOUNTED_DBS.MOUNT_MODE is 
  'Mode in which this instance has the database mounted'
/
comment on column ALL_MOUNTED_DBS.STATUS is 'Database state (mounted, open)'
/
comment on column ALL_MOUNTED_DBS.MAC_MODE is 'MAC enforcement mode'
/
comment on column ALL_MOUNTED_DBS.TYPE is 'Primary or Secondary mount'
/

create view ALL_LABELS (NAME)
as select distinct(rawtolab(olab)) from sys.lab$
/
create public synonym all_labels for sys.all_labels
/
grant select on all_labels to public
/
comment on table all_labels is 'All mls labels currently in use'
/
comment on column all_labels.name is 'Label'
/

