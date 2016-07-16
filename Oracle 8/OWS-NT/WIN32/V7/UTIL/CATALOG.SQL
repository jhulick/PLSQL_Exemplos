rem 
rem $Header: catalog.sql,v 1.211 1995/12/13 16:09:53 rdbmsint Exp $ catalog.sql
rem 
Rem Copyright (c) 1988 by Oracle Corporation
Rem
Rem NAME
Rem   CATALOG.SQL
Rem FUNCTION
Rem   Creates data dictionary views.
Rem NOTES
Rem   Must be run when connected to SYS or INTERNAL.
Rem
Rem   Do not create DBA synonyms in this file, they should be
Rem   added to the file dba_syn.sql
Rem
Rem Please make sure that the following 3 lines are at the end of this file:
Rem ---------------------------------------------------------------------------
Rem THIS IS THE END OF THIS FILE - IF I AM NOT HERE THEN RCS HAS TRUNCATED FILE
Rem ---------------------------------------------------------------------------
Rem MODIFIED
Rem     rdbmsint   12/13/95 -  add v_system_parameter
Rem     msimon     11/21/95 -  Fix suntax error on USER_CLUSTER_HASH_EXPRESSIONS
Rem     lwillis    11/16/95 -  Change *_histograms.bucket_number
Rem     hjakobss   10/19/95 -  bitmap indexes in index views
Rem     rtaranto   11/09/95 -  Add synonym for v$sql_shared_memory
Rem     rtaranto   11/03/95 -  Add new bind fixed views
Rem     wmaimone   08/11/95 -  merge changes from branch 1.182.720.6
Rem     jbellemo   09/25/95 -  #284791: fix security in ALL_OBJECTS
Rem     arhee      07/06/95 -  add v$active_instances
Rem     amozes     06/23/95 -  add v$pq_tqstat for table queue statistics
Rem     ssamu      06/15/95 -  change views on tab$
Rem     schatter   03/21/95 -  add v$latch_misses for latch tracking
Rem     gngai      03/07/95 -  Added v$locked_object
Rem     atsukerm   02/20/95 -  Sort Segment - Temporary Tablespace Support
Rem     jcchou     03/06/95 -  #258792, fixed view TABLE_PRIVILEGES
Rem     glumpkin   02/10/95 -  fix histogram views
Rem     aho        02/02/95 -  merge changes from branch 1.182.720.5 (95.02.02)
Rem     jbellemo   01/25/95 -  merge changes from branch 1.182.720.3
Rem     glumpkin   01/10/95 -  add sample_size to tab_columns
Rem     jbellemo   01/06/95 -  #211270: speed up table_privileges view
Rem     bhimatsi   01/05/95 -  Add view(s) : DBA_FREE_SPACE_COALESCED
Rem     glumpkin   12/29/94 -  add histogram views
Rem     bhirano    12/29/94 -  merge changes from branch 1.182.720.2
Rem     ksriniva   12/22/94 -  add more latch views
Rem     ksriniva   11/16/94 -  merge changes from branch 1.182.720.1
Rem     gpongrac   10/21/94 -  media recovery views
Rem     glumpkin   10/01/94 -  Histograms
Rem     achaudhr   09/19/94 -  UJV: Add UPDATABLE_COLUMNS
Rem     aho        02/02/95 -  merge changes from branch 1.163.710.14 (95.01.03)
Rem     wmaimone   07/17/95 -  add all_arguments views
Rem     aho        02/02/95 -  merge changes from branch 1.163.710.14
Rem     ksriniva   01/27/95 -  merge of hier. latch stuff from 7.3
Rem     jbellemo   01/13/95 -  #259639: fix security for pack bodies in all_obj
Rem     bhirano    12/28/94 -  bug 257956: add synonym for shared_pool_reserved
Rem     ksriniva   09/17/94 -  bug 236209: add synonyms for v$execution and
Rem                            v$session_connect_info
Rem     aho        07/08/94 -  freelist groups for indexes
Rem     ajasuja    07/07/94 -  add v
Rem     agupta     07/05/94 -  224310 - add comments for freelists
Rem     nmichael   06/21/94 -  Hash expressions for clusters & ALL_CLUSTERS vie
Rem     jloaiza    06/20/94 -  fix all_tables
Rem     jloaiza    06/16/94 -  add disable dml locks
Rem     ksriniva   06/15/94 -  bug 219066: add V$EVENT_NAME
Rem     wmaimone   05/06/94 -  #158950,156147 fix DICTIONARY; 186155 dba_ syns
Rem     jloaiza    05/23/94 -  add new fixed views
Rem     wmaimone   04/07/94 -  merge changes from branch 1.163.710.11
Rem     jcohen     04/07/94 -  merge changes from branch 1.163.710.5
Rem     agupta     03/28/94 -  merge changes from branch 1.163.710.6
Rem     thayes     03/22/94 -  merge changes from branch 1.163.710.12
Rem     ltung      03/02/94 -  merge changes from branch 1.163.710.10
Rem     aho        01/03/95 -  add synonym for v$instance, v$mystat,
Rem                            v$sqltext, and v$shared_pool_reserved
Rem     jbellemo   09/02/94 -  add synonym for v$pwfile_users
Rem     thayes     03/02/94 -  Add compatibility views
Rem     wmaimone   03/02/94 -  add view and public synonym for v$sess_io
Rem     ltung      02/20/94 -  yet another parallel/cache semantic change
Rem     ltung      01/23/94 -  add v$pq_sysstat
Rem     ltung      01/19/94 -  add v$pq_sesstat and v$pq_slave
Rem     ltung      01/15/94 -  new parallel/cache/partitions semantics
Rem     hrizvi     01/03/94 -  bug191476 - omit invalid RSs from 
Rem                            dba_rollback_segs
Rem     agupta     01/05/94 -  192948 - change units for *_extents in *_segment
Rem     jcohen     01/04/94 - #(192450) add v$option table
Rem     jcohen     12/20/93 - #(191673) fix number fmt for user_tables,cluster
Rem     jbellemo   12/17/93 -  merge changes from branch 1.163.710.3
Rem     agupta     11/29/93 -  92383 - make seg$ freelist info visible
Rem     jbellemo   11/09/93 -  #170173: change uid to userenv('schemaid')
Rem     gdoherty   11/01/93 -  add call to catsvrmg for Server Manager
Rem     gdoherty   10/20/93 -  add v$nls_valid_values
Rem     hkodaval   11/05/93 -  merge changes from branch 1.163.710.1
Rem     hkodaval   10/14/93 -  merge changes from branch 1.151.312.7
Rem     wbridge    07/02/93 -  add v$controlfile fixed table
Rem     ltung      06/25/93 -  merge changes from branch 1.151.312.4
Rem     jcohen     06/22/93 - #(165117) new view product_component_version
Rem     vraghuna   06/17/93 -  bug 166480 - move resource_map into sql.bsq
Rem     ltung      05/28/93 -  parallel/cache in table/cluster views
Rem     wmaimone   05/20/93 -  merge changes from branch 1.151.312.3 
Rem     wmaimone   05/20/93 -  merge changes from branch 1.151.312.1 
Rem     jcohen     05/18/93 - #(163749) passwords visible in SYS.DBA_DB_LINKS
Rem     wmaimone   05/18/93 -  fix width of all_indexes 
Rem     ltung      05/14/93 - #(157449) add v$dblink 
Rem     hkodaval   04/30/93 -  Bug 162360: free lists/groups should show > 0 
Rem                             in views user_segments and dba_segments
Rem     rnakhwa    04/12/93 -  merge changes from branch 1.151.312.2 
Rem     wbridge    04/02/93 -  read-only tablespaces 
Rem     agupta     01/10/93 -  141957 - remove divide by 0 window 
Rem     wmaimone   05/07/93 -  #(161964) use system privs for all_* 
Rem     rnakhwa    04/12/93 -  Embedded comments are not allowd within SQL stat
Rem     wmaimone   04/02/93 -  #(158143) grant select on nls_parameters 
Rem     wmaimone   04/02/93 -  #(158143) grant select on nls_parameters 
Rem     ksriniva   11/30/92 -  add synonyms for v$session_event, v$system_event
Rem     tpystyne   11/27/92 -  add nls_* views 
Rem     ghallmar   11/20/92 -  fix DBA_2PC_PENDING.GLOBAL_TRAN_ID 
Rem     amendels   11/19/92 -  fix 139681, 140003: modify *_constraints 
Rem     ksriniva   11/13/92 -  add public synonym for v$session_wait 
Rem     pritto     11/09/92 -  add synonym for V$MTS 
Rem     tpystyne   11/06/92 -  use create or replace view 
Rem     jklein     09/29/92 -  histogram support 
Rem     vraghuna   10/29/92 -  bug 130560 - move map tables in sql.bsq 
Rem     jloaiza    10/28/92 -  add v$db_object_cache and v$open_cursor 
Rem     glumpkin   10/20/92 -  Adjust for new .sql filenames 
Rem     ltan       10/20/92 -  rename DBA_ROLLBACK_SEGS status 
Rem     mmoore     10/15/92 - #(134232) show more privs in all_tab_privs
Rem     mmoore     10/15/92 - #(133927) speed up table_privileges view 
Rem     dsdaniel   10/13/92 -  bug 112376 112374 125947 alter/create profile 
Rem     amendels   10/08/92 -  132726: fix *_constraints to show DELETE CASCADE
Rem     mmoore     10/08/92 - #(132956) remove _next_objects from dba_objects
Rem     jwijaya    10/07/92 -  add v$*cursor_cache 
Rem     ltan       10/07/92 -  fix undefined status for dba_rollback_segs
Rem     mmoore     10/02/92 -  fix role_privs views 
Rem     ltan       09/11/92 -  decode new status for rollback segment 
Rem     jbellemo   09/24/92 -  merge changes from branch 1.124.311.2 
Rem     jbellemo   09/18/92 -  #126685: show datatype 106 as MLSLABEL in *_TAB_
Rem     mmoore     09/23/92 -  fix comment on dba_role_privs 
Rem     aho        09/23/92 -  change view text to upper case & make shorter
Rem     pritto     09/04/92 -  rename dispatcher view synonyms 
Rem     jwijaya    09/09/92 -  add v$fixed_table 
Rem     aho        08/31/92 -  merge forward status column in *_indexes from v6
Rem                         -  bug 126268
Rem     mmoore     08/28/92 - #(124859) add default role information to role vi
Rem     mmoore     08/10/92 - #(121120) remove create index from system_priv_ma
Rem     rjenkins   07/24/92 -  removing drop & alter snapshot 
Rem     hrizvi     07/16/92 -  add v$license
Rem     mmoore     07/13/92 - #(104081) change alter resource priv name -> add 
Rem     agupta     06/26/92 -  115032 - add lists,groups to *_segments 
Rem     wbridge    06/25/92 -  fixed tables for file headers 
Rem     jwijaya    06/25/92 -  MODIFIED -> LAST_DDL_TIME per marketing 
Rem     epeeler    06/23/92 -  accomodate new type 7 in cdef$ 
Rem     jwijaya    06/15/92 -  v$plsarea is obsolete 
Rem     jbellemo   06/12/92 -  add mapping for MLSLABEL to *_TAB_COLUMNS 
Rem     jwijaya    06/04/92 -  fix a typo 
Rem     mmoore     06/04/92 - #(112281) add execute to table_privs 
Rem     agupta     06/01/92 -  111558 - user_tablespaces view wrong 
Rem     mmoore     06/01/92 - #(111110) fix dba_role_privs
Rem     rlim       05/29/92 -  #110883 - add missing views in dictionary 
Rem     jwijaya    05/26/92 -  fix bug 110884 - don't grant on v$sga
Rem     jwijaya    05/19/92 -  add v$type_size 
Rem     rlim       05/15/92 -  fix bug 101589 - correct spelling mistakes 
Rem     epeeler    05/06/92 -  fix NULL columns - bug 103146 
Rem     mmoore     05/01/92 - #(107592) fix all_views to look at enabled roles 
Rem     jwijaya    04/23/92 -  status for _NEXT_OBJECT is N/A
Rem     agupta     04/16/92 -  add columns to dba_segments 
Rem     mmoore     04/13/92 -  merge changes from branch 1.101.300.1 
Rem     mmoore     03/03/92 -  change grant view names
Rem     rnakhwa    03/10/92 -  + synonyms 4 views-v$thread, v$datafile, v$log
Rem     thayes     03/24/92 -  Define v$rollname in catalog.sql instead of kqfv
Rem     wmaimone   02/24/92 -  add v$mls_parameters 
Rem     mmoore     02/19/92 -  remove more v$osroles 
Rem     mmoore     02/19/92 -  remove v$enabledroles and v$osroles 
Rem     jwijaya    02/06/92 -  add v$librarycache 
Rem     mmoore     01/31/92 -  fix the user_free_space view 
Rem     rkooi      01/23/92 -  drop global naming views before creating them 
Rem     rkooi      01/23/92 -  use @@ command for subscripts 
Rem     rkooi      01/18/92 -  add synonym 
Rem     rkooi      01/18/92 -  add object_sizes views 
Rem     rkooi      01/10/92 -  fix up trigger views 
Rem     ajasuja    12/31/91 -  fix dba_audit_trail view 
Rem     ajasuja    12/30/91 -  audit EXISTS 
Rem     amendels   12/23/91 -  simplify *_clusters as clu$.hashkeys cannot be n
Rem     amendels   12/23/91 -  fix *_clusters views for hashing 
Rem     agupta     12/23/91 -  89036 - dba_ts_quotas 
Rem     rkooi      12/15/91 -  change 'triggering_statement' to 'trigger_body' 
Rem     ajasuja    11/27/91 -  add system privilege auditing 
Rem     amendels   11/26/91 -  modify user/dba_clusters for hash cluster 
Rem     ghallmar   11/08/91 -  add GLOBAL_NAME view 
Rem     rjenkins   11/07/91 -  commenting snapshots 
Rem     ltan       12/02/91 -  add inst# to undo$ 
Rem     mroberts   10/30/91 -  apply error view changes (for views) to IMRG 
Rem     rkooi      10/20/91 -  add public_dependency, fix priv checking
Rem                            on all_objects
Rem     smcadams   10/19/91 -  tweak audit_action table 
Rem                            add execute obj audit option to audit views
Rem                            add new_owner to dba_audit_trail
Rem     mroberts   10/14/91 -  add v$nls_parameters view 
Rem     mroberts   10/11/91 -  put VIEW changes in the mainline 
Rem     jcleland   10/11/91 -  add mac privileges to sys_priv_map 
Rem     epeeler    10/10/91 -  add enabled status columns to constraint views 
Rem     cheigham   10/03/91 -  remove extra ;'s 
Rem     mmoore     09/18/91 - #(74112) add dba_roles view to show all roles 
Rem     agupta     09/03/91 -  add sequence# to tabauth$ 
Rem     mmoore     09/03/91 -  change trigger view column names again 
Rem     ghallmar   08/12/91 -  global naming 
Rem     amendels   08/29/91 -  fix dict_columns: 'ALL$' -> 'ALL%'
Rem     rlim       08/22/91 -  add comments regarding dba synonyms 
Rem     mmoore     08/17/91 - #77458  change trigger views 
Rem     mmoore     08/01/91 -  merge changes from branch 1.59.100.1 
Rem     mmoore     08/01/91 -  move column_privileges back  
Rem     rlim       07/31/91 -  added remarks column to syscatalog & catalog
Rem     rlim       07/30/91 -  moved dba synonyms to dba_synonyms.sql 
Rem     mmoore     07/22/91 - #65139  fix bug in user_tablespaces 
Rem     jwijaya    07/14/91 -  remove unnecessary LINKNAME IS NULL
Rem   mmoore     07/08/91 - change trigger view column names 
Rem   amendels   07/02/91 - remove change to *_constraints.constraint_type
Rem   mmoore     06/28/91 - move table_privileges back in 
Rem   ltan       06/24/91 - bug 65188,add comment on DBA_ROLLBACK_SEGS.BLOCK_ID
Rem   mmoore     06/24/91 - move table and column_privileges to catalog6
Rem   ghallmar   06/11/91 -         new improved 2PC views 
Rem   amendels   06/10/91 - move obsolete sql2 views to catalog6.sql;
Rem                       - remove decodes for type 97;
Rem                       - union -> union all;
Rem                       - improve *_constraints.constraint_type (66063)
Rem   mmoore     06/10/91 - add grantable column to privilege views
Rem   smcadams   06/09/91 - add actions to audit_actions
Rem   mmoore     06/03/91 - change user$ column names 
Rem   agupta     06/07/91 - syntax error in exp_objects view 
Rem   rkooi      10/22/91 - deleted lots of comments (co truncate bug)
Rem   Grayson    03/21/88 - Creation

remark
remark	FAMILY "FIXED (VIRTUAL) VIEWS"
remark               

create or replace view v_$controlfile as select * from v$controlfile;
drop public synonym v$controlfile;
create public synonym v$controlfile for v_$controlfile;

create or replace view v_$datafile as select * from v$datafile;
drop public synonym v$datafile;
create public synonym v$datafile for v_$datafile;

create or replace view v_$log as select * from v$log;
drop public synonym v$log;
create public synonym v$log for v_$log;

create or replace view v_$thread as select * from v$thread;
drop public synonym v$thread;
create public synonym v$thread for v_$thread;

create or replace view v_$process as select * from v$process;
drop public synonym v$process;
create public synonym v$process for v_$process;

create or replace view v_$bgprocess as select * from v$bgprocess;
drop public synonym v$bgprocess;
create public synonym v$bgprocess for v_$bgprocess;

create or replace view v_$session as select * from v$session;
drop public synonym v$session;
create public synonym v$session for v_$session;

create or replace view v_$license as select * from v$license;
drop public synonym v$license;
create public synonym v$license for v_$license;

create or replace view v_$transaction as select * from v$transaction;
drop public synonym v$transaction;
create public synonym v$transaction for v_$transaction;

create or replace view v_$locked_object as select * from v$locked_object;
drop public synonym v$locked_object;
create public synonym v$locked_object for v_$locked_object;

create or replace view v_$latch as select * from v$latch;
drop public synonym v$latch;
create public synonym v$latch for v_$latch;

create or replace view v_$latch_children as select * from v$latch_children;
drop public synonym v$latch_children;
create public synonym v$latch_children for v_$latch_children;

create or replace view v_$latch_parent as select * from v$latch_parent;
drop public synonym v$latch_parent;
create public synonym v$latch_parent for v_$latch_parent;

create or replace view v_$latchname as select * from v$latchname;
drop public synonym v$latchname;
create public synonym v$latchname for v_$latchname;

create or replace view v_$latchholder as select * from v$latchholder;
drop public synonym v$latchholder;
create public synonym v$latchholder for v_$latchholder;

create or replace view v_$latch_misses as select * from v$latch_misses;
drop public synonym v$latch_misses;
create public synonym v$latch_misses for v_$latch_misses;

create or replace view v_$resource as select * from v$resource;
drop public synonym v$resource;
create public synonym v$resource for v_$resource;

create or replace view v_$_lock as select * from v$_lock;
drop public synonym v$_lock;
create public synonym v$_lock for v_$_lock;

create or replace view v_$lock as select * from v$lock;
drop public synonym v$lock;
create public synonym v$lock for v_$lock;

create or replace view v_$sesstat as select * from v$sesstat;
drop public synonym v$sesstat;
create public synonym v$sesstat for v_$sesstat;

create or replace view v_$mystat as select * from v$mystat;
drop public synonym v$mystat;
create public synonym v$mystat for v_$mystat;

create or replace view v_$sysstat as select * from v$sysstat;
drop public synonym v$sysstat;
create public synonym v$sysstat for v_$sysstat;

create or replace view v_$statname as select * from v$statname;
drop public synonym v$statname;
create public synonym v$statname for v_$statname;

create or replace view v_$access as select * from v$access;
drop public synonym v$access;
create public synonym v$access for v_$access;

create or replace view v_$object_dependency as 
  select * from v$object_dependency;
drop public synonym v$object_dependency;
create public synonym v$object_dependency for v_$object_dependency;

create or replace view v_$dbfile as select * from v$dbfile;
drop public synonym v$dbfile;
create public synonym v$dbfile for v_$dbfile;

create or replace view v_$filestat as select * from v$filestat;
drop public synonym v$filestat;
create public synonym v$filestat for v_$filestat;

create or replace view v_$logfile as select * from v$logfile;
drop public synonym v$logfile;
create public synonym v$logfile for v_$logfile;

create or replace view v_$rollname as select x$kturd.kturdusn usn,undo$.name
   from x$kturd, undo$
   where x$kturd.kturdusn=undo$.us# and x$kturd.kturdsiz!=0;
drop public synonym v$rollname;
create public synonym v$rollname for v_$rollname;

create or replace view v_$rollstat as select * from v$rollstat;
drop public synonym v$rollstat;
create public synonym v$rollstat for v_$rollstat;

create or replace view v_$sga as select * from v$sga;
drop public synonym v$sga;
create public synonym v$sga for v_$sga;

create or replace view v_$parameter as select * from v$parameter;
drop public synonym v$parameter;
create public synonym v$parameter for v_$parameter;

create or replace view v_$system_parameter as select * from v$system_parameter;
drop public synonym v$system_parameter;
create public synonym v$system_parameter for v_$system_parameter;

create or replace view v_$rowcache as select * from v$rowcache;
drop public synonym v$rowcache;
create public synonym v$rowcache for v_$rowcache;

create or replace view v_$enabledprivs as select * from v$enabledprivs;
drop public synonym v$enabledprivs;
create public synonym v$enabledprivs for v_$enabledprivs;

create or replace view v_$nls_parameters as select * from v$nls_parameters;
drop public synonym v$nls_parameters;
create public synonym v$nls_parameters for v_$nls_parameters;
grant select on v_$nls_parameters to public;

create or replace view v_$nls_valid_values as
select * from v$nls_valid_values;
drop public synonym v$nls_valid_values;
create public synonym v$nls_valid_values for v_$nls_valid_values;
grant select on v_$nls_valid_values to public;

create or replace view v_$mls_parameters as select * from v$parameter
where name like 'mls%';
drop public synonym v$mls_parameters;
create public synonym v$mls_parameters for v_$mls_parameters;
grant select on v_$mls_parameters to public;

create or replace view v_$librarycache as select * from v$librarycache;
drop public synonym v$librarycache;
create public synonym v$librarycache for v_$librarycache;

create or replace view v_$type_size as select * from v$type_size;
drop public synonym v$type_size;
create public synonym v$type_size for v_$type_size;

create or replace view v_$archive as select * from v$archive;
drop public synonym v$archive;
create public synonym v$archive for v_$archive;

create or replace view v_$circuit as select * from v$circuit;
drop public synonym v$circuit;
create public synonym v$circuit for v_$circuit;

create or replace view v_$database as select * from v$database;
drop public synonym v$database;
create public synonym v$database for v_$database;

create or replace view v_$instance as select * from v$instance;
drop public synonym v$instance;
create public synonym v$instance for v_$instance;

create or replace view v_$dispatcher as select * from v$dispatcher;
drop public synonym v$dispatcher;
create public synonym v$dispatcher for v_$dispatcher;

create or replace view v_$loghist as select * from v$loghist;
drop public synonym v$loghist;
create public synonym v$loghist for v_$loghist;

REM create or replace view v_$plsarea as select * from v$plsarea;
drop public synonym v$plsarea;
REM create public synonym v$plsarea for v_$plsarea;

create or replace view v_$sqlarea as select * from v$sqlarea;
drop public synonym v$sqlarea;
create public synonym v$sqlarea for v_$sqlarea;

create or replace view v_$sqltext as select * from v$sqltext;
drop public synonym v$sqltext;
create public synonym v$sqltext for v_$sqltext;

create or replace view v_$sqltext_with_newlines as 
      select * from v$sqltext_with_newlines;
drop public synonym v$sqltext_with_newlines;
create public synonym v$sqltext_with_newlines for v_$sqltext_with_newlines;

create or replace view v_$sql as select * from v$sql;
drop public synonym v$sql;
create public synonym v$sql for v_$sql;

create or replace view v_$db_pipes as select * from v$db_pipes;
drop public synonym v$db_pipes;
create public synonym v$db_pipes for v_$db_pipes;

create or replace view v_$db_object_cache as select * from v$db_object_cache;
drop public synonym v$db_object_cache;
create public synonym v$db_object_cache for v_$db_object_cache;

create or replace view v_$open_cursor as select * from v$open_cursor;
drop public synonym v$open_cursor;
create public synonym v$open_cursor for v_$open_cursor;

create or replace view v_$option as select * from v$option;
drop public synonym v$option;
create public synonym v$option for v_$option;
grant select on v_$option to public;

create or replace view v_$version as select * from v$version;
drop public synonym v$version;
create public synonym v$version for v_$version;
grant select on v_$version to public;

create or replace view v_$pq_sesstat as select * from v$pq_sesstat;
drop public synonym v$pq_sesstat;
create public synonym v$pq_sesstat for v_$pq_sesstat;
grant select on v_$pq_sesstat to public;

create or replace view v_$pq_sysstat as select * from v$pq_sysstat;
drop public synonym v$pq_sysstat;
create public synonym v$pq_sysstat for v_$pq_sysstat;

create or replace view v_$pq_slave as select * from v$pq_slave;
drop public synonym v$pq_slave;
create public synonym v$pq_slave for v_$pq_slave;

create or replace view v_$queue as select * from v$queue;
drop public synonym v$queue;
create public synonym v$queue for v_$queue;

create or replace view v_$mts as select * from v$mts;
drop public synonym v$mts;
create public synonym v$mts for v_$mts;

create or replace view v_$dblink as select * from v$dblink;
drop public synonym v$dblink;
create public synonym v$dblink for v_$dblink;

create or replace view v_$pwfile_users as select * from v$pwfile_users;
drop public synonym v$pwfile_users;
create public synonym v$pwfile_users for v_$pwfile_users;

create or replace view v_$reqdist as select * from v$reqdist;
drop public synonym v$reqdist;
create public synonym v$reqdist for v_$reqdist;

create or replace view v_$sgastat as select * from v$sgastat;
drop public synonym v$sgastat;
create public synonym v$sgastat for v_$sgastat;

create or replace view v_$waitstat as select * from v$waitstat;
drop public synonym v$waitstat;
create public synonym v$waitstat for v_$waitstat;

create or replace view v_$shared_server as select * from v$shared_server;
drop public synonym v$shared_server;
create public synonym v$shared_server for v_$shared_server;

create or replace view v_$timer as select * from v$timer;
drop public synonym v$timer;
create public synonym v$timer for v_$timer;

create or replace view v_$recover_file as select * from v$recover_file;
drop public synonym v$recover_file;
create public synonym v$recover_file for v_$recover_file;

create or replace view v_$backup as select * from v$backup;
drop public synonym v$backup;
create public synonym v$backup for v_$backup;

create or replace view v_$log_history as select * from v$log_history;
drop public synonym v$log_history;
create public synonym v$log_history for v_$log_history;

create or replace view v_$recovery_log as select * from v$recovery_log;
drop public synonym v$recovery_log;
create public synonym v$recovery_log for v_$recovery_log;

create or replace view v_$fixed_table as select * from v$fixed_table;
drop public synonym v$fixed_table;
create public synonym v$fixed_table for v_$fixed_table;

create or replace view v_$fixed_view_definition as 
   select * from v$fixed_view_definition;
drop public synonym v$fixed_view_definition;
create public synonym v$fixed_view_definition for v_$fixed_view_definition;

create or replace view v_$indexed_fixed_column as 
  select * from v$indexed_fixed_column;
drop public synonym v$indexed_fixed_column;
create public synonym v$indexed_fixed_column for v_$indexed_fixed_column;

create or replace view v_$session_cursor_cache as 
  select * from v$session_cursor_cache;
drop public synonym v$session_cursor_cache;
create public synonym v$session_cursor_cache for v_$session_cursor_cache;

create or replace view v_$session_wait as 
  select * from v$session_wait;
drop public synonym v$session_wait;
create public synonym v$session_wait for v_$session_wait;

create or replace view v_$session_event as 
  select * from v$session_event;
drop public synonym v$session_event;
create public synonym v$session_event for v_$session_event;

create or replace view v_$session_connect_info as 
  select * from v$session_connect_info;
drop public synonym v$session_connect_info;
create public synonym v$session_connect_info for v_$session_connect_info;

create or replace view v_$system_event as 
  select * from v$system_event;
drop public synonym v$system_event;
create public synonym v$system_event for v_$system_event;

create or replace view v_$event_name as 
  select * from v$event_name;
drop public synonym v$event_name;
create public synonym v$event_name for v_$event_name;

create or replace view v_$execution as 
  select * from v$execution;
drop public synonym v$execution;
create public synonym v$execution for v_$execution;

create or replace view v_$system_cursor_cache as 
  select * from v$system_cursor_cache;
drop public synonym v$system_cursor_cache;
create public synonym v$system_cursor_cache for v_$system_cursor_cache;

create or replace view v_$sess_io as
  select * from v$sess_io;
drop public synonym v$sess_io;
create public synonym v$sess_io for v_$sess_io;

create or replace view v_$compatibility as
  select * from v$compatibility;
drop public synonym v$compatibility;
create public synonym v$compatibility for v_$compatibility;

create or replace view v_$compatseg as
  select * from v$compatseg;
drop public synonym v$compatseg;
create public synonym v$compatseg for v_$compatseg;

create or replace view v_$recovery_status as
  select * from v$recovery_status;
drop public synonym v$recovery_status;
create public synonym v$recovery_status for v_$recovery_status;

create or replace view v_$recovery_file_status as
  select * from v$recovery_file_status;
drop public synonym v$recovery_file_status;
create public synonym v$recovery_file_status for v_$recovery_file_status;

create or replace view v_$shared_pool_reserved as
  select * from v$shared_pool_reserved;
drop public synonym v$shared_pool_reserved;
create public synonym v$shared_pool_reserved for v_$shared_pool_reserved;

create or replace view v_$sort_segment as select * from v$sort_segment;
drop public synonym v$sort_segment;
create public synonym v$sort_segment for v_$sort_segment;

create or replace view v_$pq_tqstat as select * from v$pq_tqstat;
drop public synonym v$pq_tqstat;
create public synonym v$pq_tqstat for v_$pq_tqstat;
grant select on v_$pq_tqstat to public;

create or replace view v_$active_instances as select * from v$active_instances;
drop public synonym v$active_instances;
create public synonym v$active_instances for v_$active_instances;
grant select on v_$active_instances to public;

create or replace view v_$sql_cursor as select * from v$sql_cursor;
drop public synonym v$sql_cursor;
create public synonym v$sql_cursor for v_$sql_cursor;

create or replace view v_$sql_bind_metadata as
  select * from v$sql_bind_metadata;
drop public synonym v$sql_bind_metadata;
create public synonym v$sql_bind_metadata for v_$sql_bind_metadata;

create or replace view v_$sql_bind_data as select * from v$sql_bind_data;
drop public synonym v$sql_bind_data;
create public synonym v$sql_bind_data for v_$sql_bind_data;

create or replace view v_$sql_shared_memory
  as select * from v$sql_shared_memory;
drop public synonym v$sql_shared_memory;
create public synonym v$sql_shared_memory for v_$sql_shared_memory;

remark
remark  FAMILY "PRIVILEGE MAP"
remark  Tables for mapping privilege numbers to privilege names.
remark
remark  SYSTEM_PRIVILEGE_MAP now in sql.bsq
remark
remark  TABLE_PRIVILEGE_MAP now in sql.bsq
remark
remark
remark  FAMILY "PRIVS"
remark

create or replace view SESSION_PRIVS
    (PRIVILEGE)
as
select spm.name
from sys.v$enabledprivs ep, system_privilege_map spm
where spm.privilege = ep.priv_number
/
comment on table SESSION_PRIVS is
'Privileges which the user currently has set'
/
comment on column SESSION_PRIVS.PRIVILEGE is
'Privilege Name'
/
drop public synonym SESSION_PRIVS
/
create public synonym SESSION_PRIVS for SESSION_PRIVS
/
grant select on SESSION_PRIVS to PUBLIC with grant option
/

remark
remark  FAMILY "ROLES"
remark
create or replace view SESSION_ROLES
    (ROLE)
as
select u.name
from x$kzsro,user$ u
where kzsrorol!=userenv('SCHEMAID') and kzsrorol!=1 and u.user#=kzsrorol
/
comment on table SESSION_ROLES is
'Roles which the user currently has enabled.'
/
comment on column SESSION_ROLES.ROLE is
'Role name'
/
drop public synonym SESSION_ROLES
/
create public synonym SESSION_ROLES for SESSION_ROLES
/
grant select on SESSION_ROLES to PUBLIC with grant option
/
create or replace view ROLE_SYS_PRIVS
    (ROLE, PRIVILEGE, ADMIN_OPTION)
as
select u.name,spm.name,decode(min(option$),1,'YES','NO')
from  sys.user$ u, sys.system_privilege_map spm, sys.sysauth$ sa
where grantee# in 
   (select distinct(privilege#)
    from sys.sysauth$ sa
    where privilege# > 0 
    connect by prior sa.privilege# = sa.grantee#
    start with grantee#=userenv('SCHEMAID') or grantee#=1 or grantee# in
      (select kzdosrol from x$kzdos))
  and u.user#=sa.grantee# and sa.privilege#=spm.privilege
group by u.name, spm.name
/
comment on table ROLE_SYS_PRIVS is
'System privileges granted to roles'
/
comment on column ROLE_SYS_PRIVS.ROLE is
'Role name'
/
comment on column ROLE_SYS_PRIVS.PRIVILEGE is
'System Privilege'
/
comment on column ROLE_SYS_PRIVS.ADMIN_OPTION is
'Grant was with the ADMIN option'
/
drop public synonym ROLE_SYS_PRIVS
/
create public synonym ROLE_SYS_PRIVS for ROLE_SYS_PRIVS
/
grant select on ROLE_SYS_PRIVS to PUBLIC with grant option
/
create or replace view ROLE_TAB_PRIVS
    (ROLE, OWNER, TABLE_NAME, COLUMN_NAME, PRIVILEGE, GRANTABLE)
as
select u1.name,u2.name,o.name,col$.name,tpm.name, 
       decode(max(oa.option$), 1, 'YES', 'NO')
from  sys.user$ u1,sys.user$ u2,sys.table_privilege_map tpm,
      sys.objauth$ oa,sys.obj$ o,sys.col$
where grantee# in        
   (select distinct(privilege#)
    from sys.sysauth$ sa
    where privilege# > 0 
    connect by prior sa.privilege# = sa.grantee#
    start with grantee#=userenv('SCHEMAID') or grantee#=1 or grantee# in
      (select kzdosrol from x$kzdos))
   and u1.user#=oa.grantee# and oa.privilege#=tpm.privilege
   and oa.obj#=o.obj# and oa.obj#=col$.obj#(+) and oa.col#=col$.col#(+)
   and u2.user#=o.owner#
group by u1.name,u2.name,o.name,col$.name,tpm.name
/
comment on table ROLE_TAB_PRIVS is
'Table privileges granted to roles'
/
comment on column ROLE_TAB_PRIVS.ROLE is
'Role Name'
/
comment on column ROLE_TAB_PRIVS.TABLE_NAME is
'Table Name or Sequence Name'
/
comment on column ROLE_TAB_PRIVS.COLUMN_NAME is
'Column Name if applicable'
/
comment on column ROLE_TAB_PRIVS.PRIVILEGE is
'Table Privilege'
/
drop public synonym ROLE_TAB_PRIVS
/
create public synonym ROLE_TAB_PRIVS for ROLE_TAB_PRIVS
/
grant select on ROLE_TAB_PRIVS to PUBLIC with grant option
/
create or replace view ROLE_ROLE_PRIVS
    (ROLE, GRANTED_ROLE, ADMIN_OPTION)
as
select u1.name,u2.name,decode(min(option$),1,'YES','NO')
from  sys.user$ u1, sys.user$ u2, sys.sysauth$ sa
where grantee# in 
   (select distinct(privilege#)
    from sys.sysauth$ sa
    where privilege# > 0 
    connect by prior sa.privilege# = sa.grantee#
    start with grantee#=userenv('SCHEMAID') or grantee#=1 or grantee# in
      (select kzdosrol from x$kzdos))
   and u1.user#=sa.grantee# and u2.user#=sa.privilege#
group by u1.name,u2.name
/
comment on table ROLE_ROLE_PRIVS is
'Roles which are granted to roles'
/
comment on column ROLE_ROLE_PRIVS.ROLE is
'Role Name'
/
comment on column ROLE_ROLE_PRIVS.GRANTED_ROLE is
'Role which was granted'
/
comment on column ROLE_ROLE_PRIVS.ADMIN_OPTION is
'Grant was with the ADMIN option'
/
drop public synonym ROLE_ROLE_PRIVS
/
create public synonym ROLE_ROLE_PRIVS for ROLE_ROLE_PRIVS
/
grant select on ROLE_ROLE_PRIVS to PUBLIC with grant option
/
create or replace view DBA_ROLES (ROLE, PASSWORD_REQUIRED)
as
select name, decode(password, null, 'NO', 'EXTERNAL', 'EXTERNAL', 'YES')
from  user$
where type = 0 and name not in ('PUBLIC', '_NEXT_USER')
/
drop public synonym DBA_ROLES
/
create public synonym DBA_ROLES for DBA_ROLES
/
comment on table DBA_ROLES is
'All Roles which exist in the database'
/
comment on column DBA_ROLES.ROLE is
'Role Name'
/
comment on column DBA_ROLES.PASSWORD_REQUIRED is
'Indicates if the role requires a password to be enabled'
/
remark
remark These are table that actually enables the user to see his or her 
remark limits
remark
create or replace view DBA_PROFILES
    (PROFILE, RESOURCE_NAME, LIMIT)
as select n.name, m.name,
	  decode (u.limit, 0, 'DEFAULT', 2147483647, 'UNLIMITED', 
			   u.limit)
  from sys.profile$ u, sys.profname$ n, sys.resource_map m
  where u.resource# = m.resource#
  and u.type=0
  and n.profile# = u.profile#
/
drop public synonym DBA_PROFILES
/
create public synonym DBA_PROFILES for DBA_PROFILES
/
comment on table DBA_PROFILES is
'Display all profiles and their limits'
/
comment on column DBA_PROFILES.PROFILE is
'Profile name'
/
comment on column DBA_PROFILES.RESOURCE_NAME is
'Resource name'
/
comment on column DBA_PROFILES.LIMIT is
'Limit placed on this resource for this profile'
/

REM
REM  This view enables the user to see his own profile limits
REM
create or replace view USER_RESOURCE_LIMITS
    (RESOURCE_NAME, LIMIT)
as select m.name,
	  decode (u.limit, 2147483647, 'UNLIMITED', 
			   0, decode (p.limit, 2147483647, 'UNLIMITED',
					       p.limit),
			   u.limit)
  from sys.profile$ u, sys.profile$ p,
       sys.resource_map m, user$ s
  where u.resource# = m.resource#
  and p.profile# = 0 
  and p.resource# = u.resource#
  and u.type =0
  and s.resource$ = u.profile#
  and s.user# = userenv('SCHEMAID')
/
comment on table USER_RESOURCE_LIMITS is
'Display resource limit of the user'
/
comment on column USER_RESOURCE_LIMITS.RESOURCE_NAME is
'Resource name'
/
comment on column USER_RESOURCE_LIMITS.LIMIT is
'Limit placed on this resource'
/
drop public synonym USER_RESOURCE_LIMITS
/
create public synonym USER_RESOURCE_LIMITS for USER_RESOURCE_LIMITS
/
grant select on USER_RESOURCE_LIMITS to PUBLIC with grant option
/

REM
REM  This view shows the resource cost of the system
REM
create or replace view RESOURCE_COST
    (RESOURCE_NAME, UNIT_COST)
as select m.name,c.cost
  from sys.resource_cost$ c, sys.resource_map m where 
  c.resource# = m.resource#
  and c.resource# in (2, 4, 7, 8)
/
comment on table RESOURCE_COST is
'Cost for each resource'
/
comment on column RESOURCE_COST.RESOURCE_NAME is
'Name of resource'
/
comment on column RESOURCE_COST.UNIT_COST is
'Cost for resource'
/
drop public synonym RESOURCE_COST
/
create public synonym RESOURCE_COST for RESOURCE_COST
/
grant select on RESOURCE_COST to PUBLIC
/

remark
remark  FAMILY "CATALOG"
remark  Objects which may be used as tables in SQL statements: 
remark  Tables, Views, Synonyms.
remark               

create or replace view USER_CATALOG
    (TABLE_NAME,
     TABLE_TYPE)
as
select o.name,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 'UNDEFINED')
from sys.obj$ o
where o.owner# = userenv('SCHEMAID')
  and o.type in (2, 4, 5, 6)
  and o.linkname is null
/
comment on table USER_CATALOG is
'Tables, Views, Synonyms and Sequences owned by the user'
/
comment on column USER_CATALOG.TABLE_NAME is
'Name of the object'
/
comment on column USER_CATALOG.TABLE_TYPE is
'Type of the object'
/
drop public synonym USER_CATALOG
/
create public synonym USER_CATALOG for USER_CATALOG
/
drop public synonym CAT
/
create public synonym CAT for USER_CATALOG
/
grant select on USER_CATALOG to PUBLIC with grant option
/
remark
remark  This view shows all tables, views, synonyms, and sequences owned by the
remark  user and those tables, views, synonyms, and sequences that PUBLIC
remark  has been granted access.
remark
create or replace view ALL_CATALOG
    (OWNER, TABLE_NAME,
     TABLE_TYPE)
as
select u.name, o.name,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 'UNDEFINED')
from sys.user$ u, sys.obj$ o
where o.owner# = u.user#
  and o.type in (2, 4, 5, 6)
  and o.linkname is null
  and (o.owner# in (userenv('SCHEMAID'), 1)   /* public objects */
       or
       obj# in ( select obj#  /* directly granted privileges */
                 from sys.objauth$
                 where grantee# in ( select kzsrorol
                                      from x$kzsro
                                    )
                )
       or
       (
	  o.type in (7, 8, 9) /* prc, fcn, pkg */
	  and
	  exists (select null from v$enabledprivs
		  where priv_number = -144 /* EXECUTE ANY PROCEDURE */)
        )
       or
       (
	  o.type in (2, 4, 5) /* table, view, synonym */
	  and
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */))
       )
       or
       ( o.type = 6 /* sequence */
	 and
	 exists (select null from v$enabledprivs
		 where priv_number = -109 /* SELECT ANY SEQUENCE */)))
/
comment on table ALL_CATALOG is
'All tables, views, synonyms, sequences accessible to the user'
/
comment on column ALL_CATALOG.OWNER is
'Owner of the object'
/
comment on column ALL_CATALOG.TABLE_NAME is
'Name of the object'
/
comment on column ALL_CATALOG.TABLE_TYPE is
'Type of the object'
/
drop public synonym ALL_CATALOG
/
create public synonym ALL_CATALOG for ALL_CATALOG
/
grant select on ALL_CATALOG to PUBLIC with grant option
/
create or replace view DBA_CATALOG
    (OWNER, TABLE_NAME,
     TABLE_TYPE)
as
select u.name, o.name,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 'UNDEFINED')
from sys.user$ u, sys.obj$ o
where o.owner# = u.user#
  and o.linkname is null
  and o.type in (2, 4, 5, 6)
/
drop public synonym DBA_CATALOG
/
create public synonym DBA_CATALOG for DBA_CATALOG
/
comment on table DBA_CATALOG is
'All database Tables, Views, Synonyms, Sequences'
/
comment on column DBA_CATALOG.OWNER is
'Owner of the object'
/
comment on column DBA_CATALOG.TABLE_NAME is
'Name of the object'
/
comment on column DBA_CATALOG.TABLE_TYPE is
'Type of the object'
/
remark
remark  FAMILY "CLUSTERS"
remark  CREATE CLUSTER parameters.
remark  This family has no "ALL" member.
remark
create or replace view USER_CLUSTERS
    (CLUSTER_NAME, TABLESPACE_NAME,
     PCT_FREE, PCT_USED, KEY_SIZE,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE, 
     FREELISTS, FREELIST_GROUPS,
     AVG_BLOCKS_PER_KEY,
     CLUSTER_TYPE, FUNCTION, HASHKEYS,
     DEGREE, INSTANCES, CACHE)
as select o.name, ts.name,
          mod(c.pctfree$, 100), c.pctused$, c.size$,c.initrans,c.maxtrans,
          s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
          s.minexts, s.maxexts, s.extpct,
	  decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups),
          c.spare4, decode(c.hashkeys, 0, 'INDEX', 'HASH'),
          decode(c.hashkeys, 0, NULL,
                 decode(c.func, 0, 'COLUMN', 1, 'DEFAULT', 
                                2, 'HASH EXPRESSION', 3, 'DEFAULT2', NULL)),
          c.hashkeys,
          lpad(decode(c.spare5, 0, '1', 1, 'DEFAULT', to_char(c.spare5)), 10),
          lpad(decode(mod(c.spare6, 65536), 0, '1', 1, 'DEFAULT',
          to_char(mod(c.spare6, 65536))), 10),
          lpad(decode(floor(c.spare6 / 65536), 0, 'N', 1, 'Y', '?'), 5)
from sys.ts$ ts, sys.seg$ s, sys.clu$ c, sys.obj$ o
where o.owner# = userenv('SCHEMAID')
  and o.obj# = c.obj#
  and c.ts# = ts.ts# 
  and c.ts# = s.ts#
  and c.file# = s.file#
  and c.block# = s.block#
/
comment on table USER_CLUSTERS is
'Descriptions of user''s own clusters'
/
comment on column USER_CLUSTERS.CLUSTER_NAME is
'Name of the cluster'
/
comment on column USER_CLUSTERS.TABLESPACE_NAME is
'Name of the tablespace containing the cluster'
/
comment on column USER_CLUSTERS.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column USER_CLUSTERS.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column USER_CLUSTERS.KEY_SIZE is
'Estimated size of cluster key plus associated rows'
/
comment on column USER_CLUSTERS.INI_TRANS is
'Initial number of transactions'
/
comment on column USER_CLUSTERS.MAX_TRANS is
'Maximum number of transactions'
/
comment on column USER_CLUSTERS.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column USER_CLUSTERS.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column USER_CLUSTERS.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column USER_CLUSTERS.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column USER_CLUSTERS.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column USER_CLUSTERS.FREELISTS is
'Number of process freelists allocated in this segment'
/
comment on column USER_CLUSTERS.FREELIST_GROUPS is
'Number of freelist groups allocated in this segment'
/
comment on column USER_CLUSTERS.AVG_BLOCKS_PER_KEY is
'Average number of blocks containing rows with a given cluster key'
/
comment on column USER_CLUSTERS.CLUSTER_TYPE is
'Type of cluster: b-tree index or hash'
/
comment on column USER_CLUSTERS.FUNCTION is
'If a hash cluster, the hash function'
/
comment on column USER_CLUSTERS.HASHKEYS is
'If a hash cluster, the number of hash keys (hash buckets)'
/
comment on column USER_CLUSTERS.DEGREE is
'The number of threads per instance for scanning the cluster'
/
comment on column USER_CLUSTERS.INSTANCES is
'The number of instances across which the cluster is to be scanned'
/
comment on column USER_CLUSTERS.CACHE is
'Whether the cluster is to be cached in the buffer cache'
/
drop public synonym USER_CLUSTERS
/
create public synonym USER_CLUSTERS for USER_CLUSTERS
/
drop public synonym CLU
/
create public synonym CLU for USER_CLUSTERS
/
grant select on USER_CLUSTERS to PUBLIC with grant option
/
create or replace view ALL_CLUSTERS
    (OWNER, CLUSTER_NAME, TABLESPACE_NAME,
     PCT_FREE, PCT_USED, KEY_SIZE,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     FREELISTS, FREELIST_GROUPS,
     AVG_BLOCKS_PER_KEY,
     CLUSTER_TYPE, FUNCTION, HASHKEYS,
     DEGREE, INSTANCES, CACHE)
as select u.name, o.name, ts.name,
          mod(c.pctfree$, 100), c.pctused$, c.size$,c.initrans,c.maxtrans,
          s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
          s.minexts, s.maxexts, s.extpct,
          decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups),
          c.spare4, decode(c.hashkeys, 0, 'INDEX', 'HASH'),
          decode(c.hashkeys, 0, NULL,
                 decode(c.func, 0, 'COLUMN', 1, 'DEFAULT',
                                2, 'HASH EXPRESSION', 3, 'DEFAULT2', NULL)),
          c.hashkeys,
          lpad(decode(c.spare5, 0, '1', 1, 'DEFAULT', to_char(c.spare5)), 10),
          lpad(decode(mod(c.spare6, 65536), 0, '1', 1, 'DEFAULT',
          to_char(mod(c.spare6, 65536))), 10),
          lpad(decode(floor(c.spare6 / 65536), 0, 'N', 1, 'Y', '?'), 5)
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.clu$ c, sys.obj$ o
where o.owner# = u.user#
  and o.obj#   = c.obj#
  and c.ts#    = ts.ts#
  and c.ts#    = s.ts#
  and c.file#  = s.file#
  and c.block# = s.block#
  and (o.owner# = userenv('SCHEMAID')
       or  /* user has system privilages */
         exists (select null from v$enabledprivs
                 where priv_number in (-61 /* CREATE ANY CLUSTER */,
                                       -62 /* ALTER ANY CLUSTER */,
                                       -63 /* DROP ANY CLUSTER */ )
                )
      )
/
drop public synonym ALL_CLUSTERS
/
create public synonym ALL_CLUSTERS for ALL_CLUSTERS
/
grant select on ALL_CLUSTERS to PUBLIC with grant option
/
comment on table ALL_CLUSTERS is
'Description of clusters accessible to the user'
/
comment on column ALL_CLUSTERS.OWNER is
'Owner of the cluster'
/
comment on column ALL_CLUSTERS.CLUSTER_NAME is
'Name of the cluster'
/
comment on column ALL_CLUSTERS.TABLESPACE_NAME is
'Name of the tablespace containing the cluster'
/
comment on column ALL_CLUSTERS.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column ALL_CLUSTERS.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column ALL_CLUSTERS.KEY_SIZE is
'Estimated size of cluster key plus associated rows'
/
comment on column ALL_CLUSTERS.INI_TRANS is
'Initial number of transactions'
/
comment on column ALL_CLUSTERS.MAX_TRANS is
'Maximum number of transactions'
/
comment on column ALL_CLUSTERS.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column ALL_CLUSTERS.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column ALL_CLUSTERS.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column ALL_CLUSTERS.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column ALL_CLUSTERS.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column ALL_CLUSTERS.FREELISTS is
'Number of process freelists allocated in this segment'
/
comment on column ALL_CLUSTERS.FREELIST_GROUPS is
'Number of freelist groups allocated in this segment'
/
comment on column ALL_CLUSTERS.AVG_BLOCKS_PER_KEY is
'Average number of blocks containing rows with a given cluster key'
/
comment on column ALL_CLUSTERS.CLUSTER_TYPE is
'Type of cluster: b-tree index or hash'
/
comment on column ALL_CLUSTERS.FUNCTION is
'If a hash cluster, the hash function'
/
comment on column ALL_CLUSTERS.HASHKEYS is
'If a hash cluster, the number of hash keys (hash buckets)'
/
comment on column ALL_CLUSTERS.DEGREE is
'The number of threads per instance for scanning the cluster'
/
comment on column ALL_CLUSTERS.INSTANCES is
'The number of instances across which the cluster is to be scanned'
/
comment on column ALL_CLUSTERS.CACHE is
'Whether the cluster is to be cached in the buffer cache'
/

create or replace view DBA_CLUSTERS
    (OWNER, CLUSTER_NAME, TABLESPACE_NAME,
     PCT_FREE, PCT_USED, KEY_SIZE,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE, 
     FREELISTS, FREELIST_GROUPS,
     AVG_BLOCKS_PER_KEY,
     CLUSTER_TYPE, FUNCTION, HASHKEYS,
     DEGREE, INSTANCES, CACHE)
as select u.name, o.name, ts.name,
          mod(c.pctfree$, 100), c.pctused$, c.size$,c.initrans,c.maxtrans,
          s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
          s.minexts, s.maxexts, s.extpct,
	  decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups),
          c.spare4, decode(c.hashkeys, 0, 'INDEX', 'HASH'),
          decode(c.hashkeys, 0, NULL,
                 decode(c.func, 0, 'COLUMN', 1, 'DEFAULT',
                                2, 'HASH EXPRESSION', 3, 'DEFAULT2', NULL)),
          c.hashkeys,
          lpad(decode(c.spare5, 0, '1', 1, 'DEFAULT', to_char(c.spare5)), 10),
          lpad(decode(mod(c.spare6, 65536), 0, '1', 1, 'DEFAULT',
          to_char(mod(c.spare6, 65536))), 10),
          lpad(decode(floor(c.spare6 / 65536), 0, 'N', 1, 'Y', '?'), 5)
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.clu$ c, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = c.obj#
  and c.ts# = ts.ts#
  and c.ts# = s.ts#
  and c.file# = s.file#
  and c.block# = s.block#
/
drop public synonym DBA_CLUSTERS
/
create public synonym DBA_CLUSTERS for DBA_CLUSTERS
/
comment on table DBA_CLUSTERS is
'Description of all clusters in the database'
/
comment on column DBA_CLUSTERS.OWNER is
'Owner of the cluster'
/
comment on column DBA_CLUSTERS.CLUSTER_NAME is
'Name of the cluster'
/
comment on column DBA_CLUSTERS.TABLESPACE_NAME is
'Name of the tablespace containing the cluster'
/
comment on column DBA_CLUSTERS.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column DBA_CLUSTERS.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column DBA_CLUSTERS.KEY_SIZE is
'Estimated size of cluster key plus associated rows'
/
comment on column DBA_CLUSTERS.INI_TRANS is
'Initial number of transactions'
/
comment on column DBA_CLUSTERS.MAX_TRANS is
'Maximum number of transactions'
/
comment on column DBA_CLUSTERS.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column DBA_CLUSTERS.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column DBA_CLUSTERS.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column DBA_CLUSTERS.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column DBA_CLUSTERS.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column DBA_CLUSTERS.FREELISTS is
'Number of process freelists allocated in this segment'
/
comment on column DBA_CLUSTERS.FREELIST_GROUPS is
'Number of freelist groups allocated in this segment'
/
comment on column DBA_CLUSTERS.AVG_BLOCKS_PER_KEY is
'Average number of blocks containing rows with a given cluster key'
/
comment on column DBA_CLUSTERS.CLUSTER_TYPE is
'Type of cluster: b-tree index or hash'
/
comment on column DBA_CLUSTERS.FUNCTION is
'If a hash cluster, the hash function'
/
comment on column DBA_CLUSTERS.HASHKEYS is
'If a hash cluster, the number of hash keys (hash buckets)'
/
comment on column DBA_CLUSTERS.DEGREE is
'The number of threads per instance for scanning the cluster'
/
comment on column DBA_CLUSTERS.INSTANCES is
'The number of instances across which the cluster is to be scanned'
/
comment on column DBA_CLUSTERS.CACHE is
'Whether the cluster is to be cached in the buffer cache'
/
remark
remark  FAMILY "CLU_COLUMNS"
remark  Mapping of cluster columns to table columns.
remark  This family has no ALL member.
remark
create or replace view USER_CLU_COLUMNS
    (CLUSTER_NAME, CLU_COLUMN_NAME, TABLE_NAME, TAB_COLUMN_NAME)
as
select oc.name, cc.name, ot.name, tc.name
from sys.obj$ oc, sys.col$ cc, sys.obj$ ot, sys.col$ tc, sys.tab$ t
where oc.obj#    = cc.obj#
  and t.clu#     = oc.obj#
  and t.obj#     = tc.obj#
  and tc.segcol# = cc.segcol#
  and t.obj#     = ot.obj#
  and oc.type    = 3
  and oc.owner#  = userenv('SCHEMAID')
/
comment on table USER_CLU_COLUMNS is
'Mapping of table columns to cluster columns'
/
comment on column USER_CLU_COLUMNS.CLUSTER_NAME is
'Cluster name'
/
comment on column USER_CLU_COLUMNS.CLU_COLUMN_NAME is
'Key column in the cluster'
/
comment on column USER_CLU_COLUMNS.TABLE_NAME is
'Clustered table name'
/
comment on column USER_CLU_COLUMNS.TAB_COLUMN_NAME is
'Key column in the table'
/
drop public synonym USER_CLU_COLUMNS
/
create public synonym USER_CLU_COLUMNS for USER_CLU_COLUMNS
/
grant select on USER_CLU_COLUMNS to PUBLIC with grant option
/
create or replace view DBA_CLU_COLUMNS
    (OWNER, CLUSTER_NAME, CLU_COLUMN_NAME, TABLE_NAME, TAB_COLUMN_NAME)
as
select u.name, oc.name, cc.name, ot.name, tc.name
from sys.user$ u, sys.obj$ oc, sys.col$ cc, sys.obj$ ot, sys.col$ tc,
     sys.tab$ t
where oc.owner#  = u.user#
  and oc.obj#    = cc.obj#
  and t.clu#     = oc.obj#
  and t.obj#     = tc.obj#
  and tc.segcol# = cc.segcol#
  and t.obj#     = ot.obj#
  and oc.type    = 3
/
drop public synonym DBA_CLU_COLUMNS
/
create public synonym DBA_CLU_COLUMNS for DBA_CLU_COLUMNS
/
comment on table DBA_CLU_COLUMNS is
'Mapping of table columns to cluster columns'
/
comment on column DBA_CLU_COLUMNS.OWNER is
'Owner of the cluster'
/
comment on column DBA_CLU_COLUMNS.CLUSTER_NAME is
'Cluster name'
/
comment on column DBA_CLU_COLUMNS.CLU_COLUMN_NAME is
'Key column in the cluster'
/
comment on column DBA_CLU_COLUMNS.TABLE_NAME is
'Clustered table name'
/
comment on column DBA_CLU_COLUMNS.TAB_COLUMN_NAME is
'Key column in the table'
/
remark
remark  FAMILY "COL_COMMENTS"
remark  Comments on columns of tables and views.
remark
create or replace view USER_COL_COMMENTS
    (TABLE_NAME, COLUMN_NAME, COMMENTS)
as
select o.name, c.name, co.comment$
from sys.obj$ o, sys.col$ c, sys.com$ co
where o.owner# = userenv('SCHEMAID')
  and o.type in (2, 4)
  and o.obj# = c.obj#
  and c.obj# = co.obj#(+)
  and c.col# = co.col#(+)
/
comment on table USER_COL_COMMENTS is
'Comments on columns of user''s tables and views'
/
comment on column USER_COL_COMMENTS.TABLE_NAME is
'Object name'
/
comment on column USER_COL_COMMENTS.COLUMN_NAME is
'Column name'
/
comment on column USER_COL_COMMENTS.COMMENTS is
'Comment on the column'
/
drop public synonym USER_COL_COMMENTS
/
create public synonym USER_COL_COMMENTS for USER_COL_COMMENTS
/
grant select on USER_COL_COMMENTS to PUBLIC with grant option
/
create or replace view ALL_COL_COMMENTS
    (OWNER, TABLE_NAME, COLUMN_NAME, COMMENTS)
as
select u.name, o.name, c.name, co.comment$
from sys.obj$ o, sys.col$ c, sys.user$ u, sys.com$ co
where o.owner# = u.user#
  and o.type in (2, 4, 5)
  and o.obj# = c.obj#
  and c.obj# = co.obj#(+)
  and c.col# = co.col#(+)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
         (select obj#
          from sys.objauth$
          where grantee# in ( select kzsrorol
                              from x$kzsro
                            )
          )
       or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */))
      )
/
comment on table ALL_COL_COMMENTS is
'Comments on columns of accessible tables and views'
/
comment on column ALL_COL_COMMENTS.OWNER is
'Owner of the object'
/
comment on column ALL_COL_COMMENTS.TABLE_NAME is
'Name of the object'
/
comment on column ALL_COL_COMMENTS.COLUMN_NAME is
'Name of the column'
/
comment on column ALL_COL_COMMENTS.COMMENTS is
'Comment on the column'
/
drop public synonym ALL_COL_COMMENTS
/
create public synonym ALL_COL_COMMENTS for ALL_COL_COMMENTS
/
grant select on ALL_COL_COMMENTS to PUBLIC with grant option
/
create or replace view DBA_COL_COMMENTS
    (OWNER, TABLE_NAME, COLUMN_NAME, COMMENTS)
as
select u.name, o.name, c.name, co.comment$
from sys.obj$ o, sys.col$ c, sys.user$ u, sys.com$ co
where o.owner# = u.user#
  and o.type in (2, 4)
  and o.obj# = c.obj#
  and c.obj# = co.obj#(+)
  and c.col# = co.col#(+)
/
drop public synonym DBA_COL_COMMENTS
/
create public synonym DBA_COL_COMMENTS for DBA_COL_COMMENTS
/
comment on table DBA_COL_COMMENTS is
'Comments on columns of all tables and views'
/
comment on column DBA_COL_COMMENTS.OWNER is
'Name of the owner of the object'
/
comment on column DBA_COL_COMMENTS.TABLE_NAME is
'Name of the object'
/
comment on column DBA_COL_COMMENTS.COLUMN_NAME is
'Name of the column'
/
comment on column DBA_COL_COMMENTS.COMMENTS is
'Comment on the object'
/
remark
remark  FAMILY "COL_PRIVS"
remark  Grants on columns.
remark
create or replace view USER_COL_PRIVS
      (GRANTEE, OWNER, TABLE_NAME, COLUMN_NAME, GRANTOR, PRIVILEGE, GRANTABLE)
as
select ue.name, u.name, o.name, c.name, ur.name, tpm.name, 
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     sys.col$ c, table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and oa.col# is not null
  and oa.privilege# = tpm.privilege
  and userenv('SCHEMAID') in (oa.grantor#, oa.grantee#, o.owner#)
/
comment on table USER_COL_PRIVS is
'Grants on columns for which the user is the owner, grantor or grantee'
/
comment on column USER_COL_PRIVS.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column USER_COL_PRIVS.OWNER is
'Username of the owner of the object'
/
comment on column USER_COL_PRIVS.TABLE_NAME is
'Name of the object'
/
comment on column USER_COL_PRIVS.COLUMN_NAME is
'Name of the column'
/
comment on column USER_COL_PRIVS.GRANTOR is
'Name of the user who performed the grant'
/
comment on column USER_COL_PRIVS.PRIVILEGE is
'Column Privilege'
/
comment on column USER_COL_PRIVS.GRANTABLE is
'Privilege is grantable'
/
drop public synonym USER_COL_PRIVS
/
create public synonym USER_COL_PRIVS for USER_COL_PRIVS
/
grant select on USER_COL_PRIVS to PUBLIC with grant option
/
create or replace view ALL_COL_PRIVS
      (GRANTOR, GRANTEE, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME,
       PRIVILEGE, GRANTABLE)
as
select ur.name, ue.name, u.name, o.name, c.name, tpm.name, 
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     sys.col$ c, table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and oa.col# is not null
  and oa.privilege# = tpm.privilege
  and (oa.grantor# = userenv('SCHEMAID') or
       oa.grantee# in (select kzsrorol from x$kzsro) or
       o.owner# = userenv('SCHEMAID'))
/
comment on table ALL_COL_PRIVS is
'Grants on columns for which the user is the grantor, grantee, owner, 
 or an enabled role or PUBLIC is the grantee'
/
comment on column ALL_COL_PRIVS.GRANTOR is
'Name of the user who performed the grant'
/
comment on column ALL_COL_PRIVS.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column ALL_COL_PRIVS.TABLE_SCHEMA is
'Schema of the object'
/
comment on column ALL_COL_PRIVS.TABLE_NAME is
'Name of the object'
/
comment on column ALL_COL_PRIVS.COLUMN_NAME is
'Name of the column'
/
comment on column ALL_COL_PRIVS.PRIVILEGE is
'Column Privilege'
/
comment on column ALL_COL_PRIVS.GRANTABLE is
'Privilege is grantable'
/
drop public synonym ALL_COL_PRIVS
/
create public synonym ALL_COL_PRIVS for ALL_COL_PRIVS
/
grant select on ALL_COL_PRIVS to PUBLIC with grant option
/
create or replace view DBA_COL_PRIVS
      (GRANTEE, OWNER, TABLE_NAME, COLUMN_NAME, GRANTOR, PRIVILEGE, GRANTABLE)
as
select ue.name, u.name, o.name, c.name, ur.name, tpm.name, 
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     sys.col$ c, table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and oa.col# is not null
  and oa.privilege# = tpm.privilege
  and u.user# = o.owner#
/
drop public synonym DBA_COL_PRIVS
/
create public synonym DBA_COL_PRIVS for DBA_COL_PRIVS
/
comment on table DBA_COL_PRIVS is
'All grants on columns in the database'
/
comment on column DBA_COL_PRIVS.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column DBA_COL_PRIVS.OWNER is
'Username of the owner of the object'
/
comment on column DBA_COL_PRIVS.TABLE_NAME is
'Name of the object'
/
comment on column DBA_COL_PRIVS.COLUMN_NAME is
'Name of the column'
/
comment on column DBA_COL_PRIVS.GRANTOR is
'Name of the user who performed the grant'
/
comment on column DBA_COL_PRIVS.PRIVILEGE is
'Column Privilege'
/
comment on column DBA_COL_PRIVS.GRANTABLE is
'Privilege is grantable'
/
remark
remark  FAMILY "COL_PRIVS_MADE"
remark  Grants on columns made by the user.
remark  This family has no DBA member.
remark
create or replace view USER_COL_PRIVS_MADE
      (GRANTEE, TABLE_NAME, COLUMN_NAME, GRANTOR, PRIVILEGE, GRANTABLE)
as
select ue.name, o.name, c.name, ur.name, tpm.name, 
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ ue, sys.user$ ur,
     sys.col$ c, table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and oa.col# is not null
  and oa.privilege# = tpm.privilege
  and o.owner# = userenv('SCHEMAID')
/
comment on table USER_COL_PRIVS_MADE is
'All grants on columns of objects owned by the user'
/
comment on column USER_COL_PRIVS_MADE.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column USER_COL_PRIVS_MADE.TABLE_NAME is
'Name of the object'
/
comment on column USER_COL_PRIVS_MADE.COLUMN_NAME is
'Name of the column'
/
comment on column USER_COL_PRIVS_MADE.GRANTOR is
'Name of the user who performed the grant'
/
comment on column USER_COL_PRIVS_MADE.PRIVILEGE is
'Column Privilege'
/
comment on column USER_COL_PRIVS_MADE.GRANTABLE is
'Privilege is grantable'
/
drop public synonym USER_COL_PRIVS_MADE
/
create public synonym USER_COL_PRIVS_MADE for USER_COL_PRIVS_MADE
/
grant select on USER_COL_PRIVS_MADE to PUBLIC with grant option
/
create or replace view ALL_COL_PRIVS_MADE
      (GRANTEE, OWNER, TABLE_NAME, COLUMN_NAME, GRANTOR, PRIVILEGE, GRANTABLE)
as
select ue.name, u.name, o.name, c.name, ur.name, tpm.name, 
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     sys.col$ c, table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and oa.col# is not null
  and oa.privilege# = tpm.privilege
  and userenv('SCHEMAID') in (o.owner#, oa.grantor#)
/
comment on table ALL_COL_PRIVS_MADE is
'Grants on columns for which the user is owner or grantor'
/
comment on column ALL_COL_PRIVS_MADE.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column ALL_COL_PRIVS_MADE.OWNER is
'Username of the owner of the object'
/
comment on column ALL_COL_PRIVS_MADE.TABLE_NAME is
'Name of the object'
/
comment on column ALL_COL_PRIVS_MADE.COLUMN_NAME is
'Name of the column'
/
comment on column ALL_COL_PRIVS_MADE.GRANTOR is
'Name of the user who performed the grant'
/
comment on column ALL_COL_PRIVS_MADE.PRIVILEGE is
'Column Privilege'
/
comment on column ALL_COL_PRIVS_MADE.GRANTABLE is
'Privilege is grantable'
/
drop public synonym ALL_COL_PRIVS_MADE
/
create public synonym ALL_COL_PRIVS_MADE for ALL_COL_PRIVS_MADE
/
grant select on ALL_COL_PRIVS_MADE to PUBLIC with grant option
/
remark
remark  FAMILY "COL_PRIVS_RECD"
remark  Received grants on columns
remark
create or replace view USER_COL_PRIVS_RECD
      (OWNER, TABLE_NAME, COLUMN_NAME, GRANTOR, PRIVILEGE, GRANTABLE)
as
select u.name, o.name, c.name, ur.name, tpm.name, 
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur,
     sys.col$ c, table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and u.user# = o.owner#
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and oa.col# is not null
  and oa.privilege# = tpm.privilege
  and oa.grantee# = userenv('SCHEMAID')
/
comment on table USER_COL_PRIVS_RECD is
'Grants on columns for which the user is the grantee'
/
comment on column USER_COL_PRIVS_RECD.OWNER is
'Username of the owner of the object'
/
comment on column USER_COL_PRIVS_RECD.TABLE_NAME is
'Name of the object'
/
comment on column USER_COL_PRIVS_RECD.COLUMN_NAME is
'Name of the column'
/
comment on column USER_COL_PRIVS_RECD.GRANTOR is
'Name of the user who performed the grant'
/
comment on column USER_COL_PRIVS_RECD.PRIVILEGE is
'Column Privilege'
/
comment on column USER_COL_PRIVS_RECD.GRANTABLE is
'Privilege is grantable'
/
drop public synonym USER_COL_PRIVS_RECD
/
create public synonym USER_COL_PRIVS_RECD for USER_COL_PRIVS_RECD
/
grant select on USER_COL_PRIVS_RECD to PUBLIC with grant option
/
create or replace view ALL_COL_PRIVS_RECD
      (GRANTEE, OWNER, TABLE_NAME, COLUMN_NAME, GRANTOR, PRIVILEGE, GRANTABLE)
as
select ue.name, u.name, o.name, c.name, ur.name, tpm.name, 
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     sys.col$ c, table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and oa.col# is not null
  and oa.privilege# = tpm.privilege
  and oa.grantee# in (select kzsrorol from x$kzsro)
/
comment on table ALL_COL_PRIVS_RECD is
'Grants on columns for which the user, PUBLIC or enabled role is the grantee'
/
comment on column ALL_COL_PRIVS_RECD.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column ALL_COL_PRIVS_RECD.OWNER is
'Username of the owner of the object'
/
comment on column ALL_COL_PRIVS_RECD.TABLE_NAME is
'Name of the object'
/
comment on column ALL_COL_PRIVS_RECD.COLUMN_NAME is
'Name of the column'
/
comment on column ALL_COL_PRIVS_RECD.GRANTOR is
'Name of the user who performed the grant'
/
comment on column ALL_COL_PRIVS_RECD.PRIVILEGE is
'Column privilege'
/
comment on column ALL_COL_PRIVS_RECD.GRANTABLE is
'Privilege is grantable'
/
drop public synonym ALL_COL_PRIVS_RECD
/
create public synonym ALL_COL_PRIVS_RECD for ALL_COL_PRIVS_RECD
/
grant select on ALL_COL_PRIVS_RECD to PUBLIC with grant option
/

remark
remark  FAMILY "DATA_FILES"
remark  Information about database files.
remark  This family has a DBA member only.
remark
create or replace view DBA_DATA_FILES
    (FILE_NAME, FILE_ID, TABLESPACE_NAME, 
     BYTES, BLOCKS, 
     STATUS)
as
select v.name, f.file#, ts.name, 
       ts.blocksize * f.blocks, f.blocks, 
       decode(f.status$, 1, 'INVALID', 2, 'AVAILABLE', 'UNDEFINED')
from sys.file$ f, sys.ts$ ts, sys.v$dbfile v
where v.file# = f.file# (+)
  and f.ts# = ts.ts# (+)
/
drop public synonym DBA_DATA_FILES
/
create public synonym DBA_DATA_FILES for DBA_DATA_FILES
/
comment on table DBA_DATA_FILES is
'Information about database files'
/
comment on column DBA_DATA_FILES.FILE_NAME is
'Name of the database file'
/
comment on column DBA_DATA_FILES.FILE_ID is
'ID of the database file'
/
comment on column DBA_DATA_FILES.TABLESPACE_NAME is
'Name of the tablespace to which the file belongs'
/
comment on column DBA_DATA_FILES.BYTES is
'Size of the file in bytes'
/
comment on column DBA_DATA_FILES.BLOCKS is
'Size of the file in ORACLE blocks'
/
comment on column DBA_DATA_FILES.STATUS is
'File status:  "INVALID" or "AVAILABLE"'
/
remark
remark  FAMILY "DB_LINKS"
remark  All relevant information about database links.
remark
create or replace view USER_DB_LINKS
    (DB_LINK, USERNAME, PASSWORD, HOST, CREATED)
as
select l.name, l.userid, l.password, l.host, l.ctime
from sys.link$ l
where l.owner# = userenv('SCHEMAID')
/
comment on table USER_DB_LINKS is
'Database links owned by the user'
/
comment on column USER_DB_LINKS.DB_LINK is
'Name of the database link'
/
comment on column USER_DB_LINKS.USERNAME is
'Name of user to log on as'
/
comment on column USER_DB_LINKS.PASSWORD is
'Password for logon'
/
comment on column USER_DB_LINKS.HOST is
'SQL*Net string for connect'
/
comment on column USER_DB_LINKS.CREATED is
'Creation time of the database link'
/
drop public synonym USER_DB_LINKS
/
create public synonym USER_DB_LINKS for USER_DB_LINKS
/
grant select on USER_DB_LINKS to PUBLIC with grant option
/
create or replace view ALL_DB_LINKS
    (OWNER, DB_LINK, USERNAME, HOST, CREATED)
as
select u.name, l.name, l.userid, l.host, l.ctime
from sys.link$ l, sys.user$ u
where l.owner# in ( select kzsrorol from x$kzsro )
  and l.owner# = u.user#
/
comment on table ALL_DB_LINKS is
'Database links accessible to the user'
/
comment on column ALL_DB_LINKS.DB_LINK is
'Name of the database link'
/
comment on column ALL_DB_LINKS.USERNAME is
'Name of user to log on as'
/
comment on column ALL_DB_LINKS.HOST is
'SQL*Net string for connect'
/
comment on column ALL_DB_LINKS.CREATED is
'Creation time of the database link'
/
drop public synonym ALL_DB_LINKS
/
create public synonym ALL_DB_LINKS for ALL_DB_LINKS
/
grant select on ALL_DB_LINKS to PUBLIC with grant option
/
create or replace view DBA_DB_LINKS
    (OWNER, DB_LINK, USERNAME, HOST, CREATED)
as
select u.name, l.name, l.userid, l.host, l.ctime
from sys.link$ l, sys.user$ u
where l.owner# = u.user#
/
drop public synonym DBA_DB_LINKS
/
create public synonym DBA_DB_LINKS for DBA_DB_LINKS
/
comment on table DBA_DB_LINKS is
'All database links in the database'
/
comment on column DBA_DB_LINKS.DB_LINK is
'Name of the database link'
/
comment on column DBA_DB_LINKS.USERNAME is
'Name of user to log on as'
/
comment on column DBA_DB_LINKS.HOST is
'SQL*Net string for connect'
/
comment on column DBA_DB_LINKS.CREATED is
'Creation time of the database link'
/
remark
remark  VIEW "DICTIONARY"
remark  Online documentation for data dictionary tables and views.
remark  This view exists outside of the family schema.
remark
/* Find the names of public synonyms for views owned by SYS that
have names different from the synonym name.  This allows the user
to see the short-hand synonyms we have created.
*/
create or replace view DICTIONARY
    (TABLE_NAME, COMMENTS)
as
select o.name, c.comment$
from sys.obj$ o, sys.com$ c
where o.obj# = c.obj#(+)
  and c.col# is null
  and o.owner# = 0
  and o.type = 4
  and (o.name like 'USER%'
       or o.name like 'ALL%'
       or (o.name like 'DBA%'
           and exists
                   (select null
                    from sys.v$enabledprivs
                    where priv_number = -47 /* SELECT ANY TABLE */)
           )
      )
union all
select o.name, c.comment$
from sys.obj$ o, sys.com$ c
where o.obj# = c.obj#(+)
  and o.owner# = 0
  and o.name in ('AUDIT_ACTIONS', 'COLUMN_PRIVILEGES', 'DICTIONARY',
        'DICT_COLUMNS', 'DUAL', 'GLOBAL_NAME', 'INDEX_HISTOGRAM',
        'INDEX_STATS', 'RESOURCE_COST', 'ROLE_ROLE_PRIVS', 'ROLE_SYS_PRIVS',
        'ROLE_TAB_PRIVS', 'SESSION_PRIVS', 'SESSION_ROLES',
        'TABLE_PRIVILEGES','NLS_SESSION_PARAMETERS','NLS_INSTANCE_PARAMETERS',
        'NLS_DATABASE_PARAMETERS')
  and c.col# is null
union all
select so.name, 'Synonym for ' || sy.name
from sys.obj$ ro, sys.syn$ sy, sys.obj$ so
where so.type = 5
  and ro.linkname is null
  and so.owner# = 1
  and so.obj# = sy.obj#
  and so.name <> sy.name
  and sy.owner = 'SYS'
  and sy.name = ro.name
  and ro.owner# = 0
  and ro.type = 4
  and (ro.owner# = userenv('SCHEMAID')
       or ro.obj# in
	   (select oa.obj#
	    from sys.objauth$ oa
	    where grantee# in (select kzsrorol from x$kzsro))
       or exists (select null from v$enabledprivs
	          where priv_number in (-45 /* LOCK ANY TABLE */,
			 	        -47 /* SELECT ANY TABLE */,
				        -48 /* INSERT ANY TABLE */,
				        -49 /* UPDATE ANY TABLE */,
				        -50 /* DELETE ANY TABLE */)
                  ))
/
comment on table DICTIONARY is
'Description of data dictionary tables and views'
/
comment on column DICTIONARY.TABLE_NAME is
'Name of the object'
/
comment on column DICTIONARY.COMMENTS is
'Text comment on the object'
/
drop public synonym DICTIONARY
/
create public synonym DICTIONARY for DICTIONARY
/
drop public synonym DICT
/
create public synonym DICT for DICTIONARY
/
grant select on DICTIONARY to PUBLIC with grant option
/
remark
remark  VIEW "DICT_COLUMNS"
remark  Online documentation for columns in data dictionary tables and views.
remark  This view exists outside of the family schema.
remark
/* Find the column comments for public synonyms for views owned by SYS that
have names different from the synonym name.  This allows the user
to see the columns of the short-hand synonyms we have created.
*/
create or replace view DICT_COLUMNS
    (TABLE_NAME, COLUMN_NAME, COMMENTS)
as
select o.name, c.name, co.comment$
from sys.com$ co, sys.col$ c, sys.obj$ o
where o.owner# = 0
  and o.type = 4
  and (o.name like 'USER%'
       or o.name like 'ALL%'
       or (o.name like 'DBA%'
           and exists
                   (select null
                    from sys.v$enabledprivs
                    where priv_number = -47 /* SELECT ANY TABLE */)
           )
      )
  and o.obj# = c.obj#
  and c.obj# = co.obj#(+)
  and c.col# = co.col#(+)
union all
select o.name, c.name, co.comment$
from sys.com$ co, sys.col$ c, sys.obj$ o
where o.owner# = 0
  and o.name in ('AUDIT_ACTIONS','DUAL','DICTIONARY', 'DICT_COLUMNS')
  and o.obj# = c.obj#
  and c.obj# = co.obj#(+)
  and c.col# = co.col#(+)
union all
select so.name, c.name, co.comment$
from sys.com$ co,sys.col$ c, sys.obj$ ro, sys.syn$ sy, sys.obj$ so
where so.type = 5
  and so.owner# = 1
  and so.obj# = sy.obj#
  and so.name <> sy.name
  and sy.owner = 'SYS'
  and sy.name = ro.name
  and ro.owner# = 0
  and ro.type = 4
  and ro.obj# = c.obj#
  and c.col# = co.col#(+)  
  and c.obj# = co.obj#(+)
/
comment on table DICT_COLUMNS is
'Description of columns in data dictionary tables and views'
/
comment on column DICT_COLUMNS.TABLE_NAME is
'Name of the object that contains the column'
/
comment on column DICT_COLUMNS.COLUMN_NAME is
'Name of the column'
/
comment on column DICT_COLUMNS.COMMENTS is
'Text comment on the object'
/
drop public synonym DICT_COLUMNS
/
create public synonym DICT_COLUMNS for DICT_COLUMNS
/
grant select on DICT_COLUMNS to PUBLIC with grant option
/
remark
remark  FAMILY "EXP_OBJECTS"
remark  Objects that have been incrementally exported.
remark  This family has a DBA member only.
remark
create or replace view DBA_EXP_OBJECTS
    (OWNER, OBJECT_NAME, OBJECT_TYPE, CUMULATIVE, INCREMENTAL, EXPORT_VERSION)
as
select u.name, o.name, 
       decode(o.type, 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE',
                      8, 'FUNCTION', 9, 'PACKAGE', 11, 'PACKAGE BODY', 
		      12, 'TRIGGER', 'UNDEFINED'),
       o.ctime, o.itime, o.expid
from sys.incexp o, sys.user$ u
where o.owner# = u.user#
/
drop public synonym DBA_EXP_OBJECTS
/
create public synonym DBA_EXP_OBJECTS for DBA_EXP_OBJECTS
/
comment on table DBA_EXP_OBJECTS is
'Objects that have been incrementally exported'
/
comment on column DBA_EXP_OBJECTS.OWNER is
'Owner of exported object'
/ 
comment on column DBA_EXP_OBJECTS.OBJECT_NAME is
'Name of exported object'
/ 
comment on column DBA_EXP_OBJECTS.OBJECT_TYPE is
'Type of exported object'
/ 
comment on column DBA_EXP_OBJECTS.CUMULATIVE is
'Timestamp of last cumulative export'
/ 
comment on column DBA_EXP_OBJECTS.INCREMENTAL is
'Timestamp of last incremental export'
/ 
comment on column DBA_EXP_OBJECTS.EXPORT_VERSION is
'The id of the export session'
/ 
remark
remark  FAMILY "EXP_VERSION"
remark  Version number of last incremental export
remark  This family has a DBA member only.
remark
create or replace view DBA_EXP_VERSION 
    (EXP_VERSION)
as
select o.expid 
from sys.incvid o
/
drop public synonym DBA_EXP_VERSION
/
create public synonym DBA_EXP_VERSION for DBA_EXP_VERSION
/
comment on table DBA_EXP_VERSION is
'Version number of the last export session'
/
comment on column DBA_EXP_VERSION.EXP_VERSION is
'Version number of the last export session'
/
remark
remark  FAMILY "EXP_FILES"
remark  Files created by incremental exports.
remark  This family has a DBA member only.
remark
create or replace view DBA_EXP_FILES 
     (EXP_VERSION, EXP_TYPE, FILE_NAME, USER_NAME, TIMESTAMP)
as
select o.expid, decode(o.exptype, 'X', 'COMPLETE', 'C', 'CUMULATIVE',
                                  'I', 'INCREMENTAL', 'UNDEFINED'),
       o.expfile, o.expuser, o.expdate
from sys.incfil o
/
drop public synonym DBA_EXP_FILES
/
create public synonym DBA_EXP_FILES for DBA_EXP_FILES
/
comment on table DBA_EXP_FILES is
'Description of export files'
/
comment on column DBA_EXP_FILES.EXP_VERSION is
'Version number of the export session'
/
comment on column DBA_EXP_FILES.FILE_NAME is
'Name of the export file'
/
comment on column DBA_EXP_FILES.USER_NAME is
'Name of user who executed export'
/
comment on column DBA_EXP_FILES.TIMESTAMP is
'Timestamp of the export session'
/
remark
remark  FAMILY "FREE_SPACE"
remark  Free extents.
remark  This family has no ALL member.
remark
create or replace view USER_FREE_SPACE
    (TABLESPACE_NAME, FILE_ID, BLOCK_ID,
     BYTES, BLOCKS)
as
select ts.name, f.file#, f.block#,
       f.length * ts.blocksize, f.length
from sys.fet$ f, sys.ts$ ts
where f.ts# = ts.ts#
  and (ts.ts# in
         (select tsq.ts#
          from sys.tsq$ tsq
          where tsq.user# = userenv('SCHEMAID') and tsq.maxblocks != 0)
       or exists
          (select null
           from sys.v$enabledprivs
           where priv_number = -15 /* UNLIMITED TABLESPACE */)
      )
/
comment on table USER_FREE_SPACE is
'Free extents in tablespaces accessible to the user'
/
comment on column USER_FREE_SPACE.TABLESPACE_NAME is
'Name of the tablespace containing the extent'
/
comment on column USER_FREE_SPACE.FILE_ID is
'ID number of the file containing the extent'
/
comment on column USER_FREE_SPACE.BLOCK_ID is
'Starting block number of the extent'
/
comment on column USER_FREE_SPACE.BYTES is
'Size of the extent in bytes'
/
comment on column USER_FREE_SPACE.BLOCKS is
'Size of the extent in ORACLE blocks'
/
drop public synonym USER_FREE_SPACE
/
create public synonym USER_FREE_SPACE for USER_FREE_SPACE
/
grant select on USER_FREE_SPACE to PUBLIC with grant option
/
create or replace view DBA_FREE_SPACE
    (TABLESPACE_NAME, FILE_ID, BLOCK_ID,
     BYTES, BLOCKS)
as
select ts.name, f.file#, f.block#,
       f.length * ts.blocksize, f.length
from sys.fet$ f, sys.ts$ ts
where f.ts# = ts.ts#
/
drop public synonym DBA_FREE_SPACE
/
create public synonym DBA_FREE_SPACE for DBA_FREE_SPACE
/
comment on table DBA_FREE_SPACE is
'Free extents in all tablespaces'
/
comment on column DBA_FREE_SPACE.TABLESPACE_NAME is
'Name of the tablespace containing the extent'
/
comment on column DBA_FREE_SPACE.FILE_ID is
'ID number of the file containing the extent'
/
comment on column DBA_FREE_SPACE.BLOCK_ID is
'Starting block number of the extent'
/
comment on column DBA_FREE_SPACE.BYTES is
'Size of the extent in bytes'
/
comment on column DBA_FREE_SPACE.BLOCKS is
'Size of the extent in ORACLE blocks'
/
remark
remark  FAMILY "FREE_SPACE_COALESCED"
remark  Free extents which are Coalesced
remark  This family has only DBA member
remark
remark the following view is just used for constructing the main view 
remark
create or replace view DBA_FREE_SPACE_COALESCED_TMP1 as
select ts#, count(*) extents_coalesced, sum(length) blocks_coalesced
from sys.fet$ a 
where not exists (
  select * from sys.fet$ b 
  where b.ts#=a.ts# and
	b.file#=a.file# and
	a.block#=b.block#+b.length)
group by ts#
/
comment on table DBA_FREE_SPACE_COALESCED_TMP1 is
'Coalesced Free Extents for all Tablespaces'
/
comment on column DBA_FREE_SPACE_COALESCED_TMP1.ts# is
'Number of Tablespace'
/
comment on column DBA_FREE_SPACE_COALESCED_TMP1.extents_coalesced is
'Number of Coalesced Free Extents in Tablespace'
/
comment on column DBA_FREE_SPACE_COALESCED_TMP1.blocks_coalesced is
'Total Coalesced Free Oracle Blocks in Tablespace'
/
remark
remark this view is just used for constructing the main view 
remark
create or replace view DBA_FREE_SPACE_COALESCED_TMP2 as
select ts#, count(*) total_extents, sum(length) total_blocks
from sys.fet$ 
group by ts#
/
comment on table DBA_FREE_SPACE_COALESCED_TMP2 is
'Free Extents in Tablespaces'
/
comment on column DBA_FREE_SPACE_COALESCED_TMP2.ts# is
'Number of Tablespace'
/
comment on column DBA_FREE_SPACE_COALESCED_TMP2.total_extents is
'Number of Free Extents in Tablespace'
/
comment on column DBA_FREE_SPACE_COALESCED_TMP2.total_blocks is
'Total Free Blocks in Tablespace'
/
remark
remark MAIN VIEW for this family
remark Free extents which do not have any other free extents before them are
remark considered coalesced. This implies that if there is contiguous free
remark space represented as 5 free extents, then we consider the first of
remark these to be coalesced and the rest 4 to be non coalesced.
remark
create or replace view DBA_FREE_SPACE_COALESCED
    (TABLESPACE_NAME, TOTAL_EXTENTS, EXTENTS_COALESCED, PERCENT_EXTENTS_COALESCED, TOTAL_BYTES, BYTES_COALESCED, TOTAL_BLOCKS, BLOCKS_COALESCED, PERCENT_BLOCKS_COALESCED)
as
select name,total_extents, extents_coalesced, 
       extents_coalesced/total_extents*100,total_blocks*c.blocksize, 
       blocks_coalesced*c.blocksize, total_blocks, blocks_coalesced,
       blocks_coalesced/total_blocks*100
from DBA_FREE_SPACE_COALESCED_TMP1 a, DBA_FREE_SPACE_COALESCED_TMP2 b, sys.ts$ c 
	where a.ts#=b.ts# and a.ts#=c.ts#
/
drop public synonym DBA_FREE_SPACE_COALESCED
/
create public synonym DBA_FREE_SPACE_COALESCED for DBA_FREE_SPACE_COALESCED
/
comment on table DBA_FREE_SPACE_COALESCED is
'Statistics on Coalesced Space in Tablespaces'
/
comment on column DBA_FREE_SPACE_COALESCED.TABLESPACE_NAME is
'Name of Tablespace'
/
comment on column DBA_FREE_SPACE_COALESCED.TOTAL_EXTENTS is
'Total Number of Free Extents in Tablespace'
/
comment on column DBA_FREE_SPACE_COALESCED.EXTENTS_COALESCED is
'Total Number of Coalesced Free Extents in Tablespace'
/
comment on column DBA_FREE_SPACE_COALESCED.PERCENT_EXTENTS_COALESCED is
'Percentage of Coalesced Free Extents in Tablespace'
/
comment on column DBA_FREE_SPACE_COALESCED.TOTAL_BYTES is
'Total Number of Free Bytes in Tablespace'
/
comment on column DBA_FREE_SPACE_COALESCED.BYTES_COALESCED is
'Total Number of Coalesced Free Bytes in Tablespace'
/
comment on column DBA_FREE_SPACE_COALESCED.TOTAL_BLOCKS is
'Total Number of Free Oracle Blocks in Tablespace'
/
comment on column DBA_FREE_SPACE_COALESCED.BLOCKS_COALESCED is
'Total Number of Coalesced Free Oracle Blocks in Tablespace'
/
comment on column DBA_FREE_SPACE_COALESCED.PERCENT_BLOCKS_COALESCED is
'Percentage of Coalesced Free Oracle Blocks in Tablespace'
/
remark
remark  FAMILY "INDEXES"
remark  CREATE INDEX parameters.
remark
create or replace view USER_INDEXES
    (INDEX_NAME, TABLE_OWNER, TABLE_NAME,
     TABLE_TYPE,
     UNIQUENESS,
     TABLESPACE_NAME, INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE, 
     FREELISTS, FREELIST_GROUPS, PCT_FREE,
     BLEVEL, LEAF_BLOCKS, DISTINCT_KEYS, AVG_LEAF_BLOCKS_PER_KEY,
     AVG_DATA_BLOCKS_PER_KEY, CLUSTERING_FACTOR, STATUS)
as
select o.name, iu.name, io.name,
       decode(io.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                       4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 'UNDEFINED'),
       decode(i.unique$, 0, decode(spare8, 1, 'BITMAP', 'NONUNIQUE'),
                         1, 'UNIQUE', 'UNDEFINED'),
       ts.name, i.initrans, i.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
       s.minexts, s.maxexts, s.extpct, decode(s.lists, 0, 1, s.lists), 
       decode(s.groups, 0, 1, s.groups), i.pctfree$,
       i.blevel, i.leafcnt, i.distkey, i.lblkkey, i.dblkkey, i.clufac,
       decode(i.compress$, 2, 'DIRECT LOAD', 'VALID')
from sys.ts$ ts, sys.seg$ s, sys.user$ iu, sys.obj$ io, sys.ind$ i, sys.obj$ o
where o.owner# = userenv('SCHEMAID')
  and o.obj# = i.obj#
  and i.bo# = io.obj#
  and io.owner# = iu.user#
  and i.ts# = ts.ts#
  and i.file# = s.file#
  and i.block# = s.block#
/
comment on table USER_INDEXES is
'Description of the user''s own indexes'
/
comment on column USER_INDEXES.STATUS is
'Whether index is in Direct Load State or not'
/
comment on column USER_INDEXES.INDEX_NAME is
'Name of the index'
/
comment on column USER_INDEXES.TABLE_OWNER is
'Owner of the indexed object'
/
comment on column USER_INDEXES.TABLE_NAME is
'Name of the indexed object'
/
comment on column USER_INDEXES.TABLE_TYPE is
'Type of the indexed object'
/
comment on column USER_INDEXES.UNIQUENESS is
'Uniqueness status of the index:  "UNIQUE",  "NONUNIQUE", or "BITMAP"'
/
comment on column USER_INDEXES.TABLESPACE_NAME is
'Name of the tablespace containing the index'
/
comment on column USER_INDEXES.INI_TRANS is
'Initial number of transactions'
/
comment on column USER_INDEXES.MAX_TRANS is
'Maximum number of transactions'
/
comment on column USER_INDEXES.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column USER_INDEXES.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column USER_INDEXES.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column USER_INDEXES.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column USER_INDEXES.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column USER_INDEXES.FREELISTS is
'Number of process freelists allocated in this segment'
/
comment on column USER_INDEXES.FREELIST_GROUPS is
'Number of freelist groups allocated to this segment'
/
comment on column USER_INDEXES.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column USER_INDEXES.BLEVEL is
'B-Tree level'
/
comment on column USER_INDEXES.LEAF_BLOCKS is
'The number of leaf blocks in the index'
/
comment on column USER_INDEXES.DISTINCT_KEYS is
'The number of distinct keys in the index'
/
comment on column USER_INDEXES.AVG_LEAF_BLOCKS_PER_KEY is
'The average number of leaf blocks per key'
/
comment on column USER_INDEXES.AVG_DATA_BLOCKS_PER_KEY is
'The average number of data blocks per key'
/
comment on column USER_INDEXES.CLUSTERING_FACTOR is
'A measurement of the amount of (dis)order of the table this index is for'
/
drop public synonym USER_INDEXES
/
create public synonym USER_INDEXES for USER_INDEXES
/
drop public synonym IND
/
create public synonym IND for USER_INDEXES
/
grant select on USER_INDEXES to PUBLIC with grant option
/
remark
remark  This view does not include cluster indexes on clusters
remark  containing tables which are accessible to the user.
remark
create or replace view ALL_INDEXES
    (OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME,
     TABLE_TYPE,
     UNIQUENESS,
     TABLESPACE_NAME, INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT, MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     FREELISTS,  FREELIST_GROUPS,
     PCT_FREE, BLEVEL, LEAF_BLOCKS, DISTINCT_KEYS, AVG_LEAF_BLOCKS_PER_KEY,
     AVG_DATA_BLOCKS_PER_KEY, CLUSTERING_FACTOR, STATUS)
 as 
select u.name, o.name, iu.name, io.name, 'TABLE',
       decode(i.unique$, 0, decode(spare8, 1, 'BITMAP', 'NONUNIQUE'),
                         1, 'UNIQUE', 'UNDEFINED'),
       ts.name, i.initrans, i.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, 
       s.minexts, s.maxexts, s.extpct, decode(s.lists, 0, 1, s.lists), 
       decode(s.groups, 0, 1, s.groups), i.pctfree$,
       i.blevel, i.leafcnt, i.distkey, i.lblkkey, i.dblkkey, i.clufac,
       decode(i.compress$, 2, 'DIRECT LOAD', 'VALID')
from sys.ts$ ts, sys.seg$ s, sys.user$ iu, sys.obj$ io, 
     sys.user$ u, sys.ind$ i, sys.obj$ o
where u.user# = o.owner#
  and o.obj# = i.obj#
  and i.bo# = io.obj#
  and io.owner# = iu.user# 
  and io.type = 2 /* tables */
  and i.ts# = ts.ts# 
  and i.file# = s.file#
  and i.block# = s.block# 
  and (io.owner# = userenv('SCHEMAID')
        or
       io.obj# in ( select obj#
                    from objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
comment on table ALL_INDEXES is
'Descriptions of indexes on tables accessible to the user'
/
comment on column ALL_INDEXES.OWNER is
'Username of the owner of the index'
/
comment on column ALL_INDEXES.STATUS is
'Whether index is in Direct Load State or not'
/
comment on column ALL_INDEXES.INDEX_NAME is
'Name of the index'
/
comment on column ALL_INDEXES.TABLE_OWNER is
'Owner of the indexed object'
/
comment on column ALL_INDEXES.TABLE_NAME is
'Name of the indexed object'
/
comment on column ALL_INDEXES.TABLE_TYPE is
'Type of the indexed object'
/
comment on column ALL_INDEXES.UNIQUENESS is
'Uniqueness status of the index: "UNIQUE",  "NONUNIQUE", or "BITMAP"'
/
comment on column ALL_INDEXES.TABLESPACE_NAME is
'Name of the tablespace containing the index'
/
comment on column ALL_INDEXES.INI_TRANS is
'Initial number of transactions'
/
comment on column ALL_INDEXES.MAX_TRANS is
'Maximum number of transactions'
/
comment on column ALL_INDEXES.INITIAL_EXTENT is
'Size of the initial extent'
/
comment on column ALL_INDEXES.NEXT_EXTENT is
'Size of secondary extents'
/
comment on column ALL_INDEXES.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column ALL_INDEXES.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column ALL_INDEXES.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column ALL_INDEXES.FREELISTS is
'Number of process freelists allocated in this segment'
/
comment on column ALL_INDEXES.FREELIST_GROUPS is
'Number of freelist groups allocated to this segment'
/
comment on column ALL_INDEXES.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column ALL_INDEXES.BLEVEL is
'B-Tree level'
/
comment on column ALL_INDEXES.LEAF_BLOCKS is
'The number of leaf blocks in the index'
/
comment on column ALL_INDEXES.DISTINCT_KEYS is
'The number of distinct keys in the index'
/
comment on column ALL_INDEXES.AVG_LEAF_BLOCKS_PER_KEY is
'The average number of leaf blocks per key'
/
comment on column ALL_INDEXES.AVG_DATA_BLOCKS_PER_KEY is
'The average number of data blocks per key'
/
comment on column ALL_INDEXES.CLUSTERING_FACTOR is
'A measurement of the amount of (dis)order of the table this index is for'
/
drop public synonym ALL_INDEXES
/
create public synonym ALL_INDEXES for ALL_INDEXES
/
grant select on ALL_INDEXES to PUBLIC with grant option
/
create or replace view DBA_INDEXES
    (OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME,
     TABLE_TYPE,
     UNIQUENESS,
     TABLESPACE_NAME, INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE, 
     FREELISTS, FREELIST_GROUPS, PCT_FREE, BLEVEL,
     LEAF_BLOCKS, DISTINCT_KEYS, AVG_LEAF_BLOCKS_PER_KEY,
     AVG_DATA_BLOCKS_PER_KEY, CLUSTERING_FACTOR, STATUS)
as
select u.name, o.name, iu.name, io.name,
       decode(io.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                       4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 'UNDEFINED'),
       decode(i.unique$, 0, decode(spare8, 1, 'BITMAP', 'NONUNIQUE'),
                         1, 'UNIQUE', 'UNDEFINED'),
       ts.name, i.initrans, i.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
       s.minexts, s.maxexts, s.extpct,  decode(s.lists, 0, 1, s.lists), 
       decode(s.groups, 0, 1, s.groups), i.pctfree$,
       i.blevel, i.leafcnt, i.distkey, i.lblkkey, i.dblkkey, i.clufac,
       decode(i.compress$, 2, 'DIRECT LOAD', 'VALID')
from sys.ts$ ts, sys.seg$ s,
     sys.user$ iu, sys.obj$ io, sys.user$ u, sys.ind$ i, sys.obj$ o
where u.user# = o.owner#
  and o.obj# = i.obj#
  and i.bo# = io.obj#
  and io.owner# = iu.user#
  and i.ts# = ts.ts#
  and i.file# = s.file#
  and i.block# = s.block#
/
drop public synonym DBA_INDEXES
/
create public synonym DBA_INDEXES for DBA_INDEXES
/
comment on table DBA_INDEXES is
'Description for all indexes in the database'
/
comment on column DBA_INDEXES.STATUS is
'Whether index is in Direct Load State or not'
/
comment on column DBA_INDEXES.OWNER is
'Username of the owner of the index'
/
comment on column DBA_INDEXES.INDEX_NAME is
'Name of the index'
/
comment on column DBA_INDEXES.TABLE_OWNER is
'Owner of the indexed object'
/
comment on column DBA_INDEXES.TABLE_NAME is
'Name of the indexed object'
/
comment on column DBA_INDEXES.TABLE_TYPE is
'Type of the indexed object'
/
comment on column DBA_INDEXES.UNIQUENESS is
'Uniqueness status of the index: "UNIQUE",  "NONUNIQUE", or "BITMAP"'
/
comment on column DBA_INDEXES.TABLESPACE_NAME is
'Name of the tablespace containing the index'
/
comment on column DBA_INDEXES.INI_TRANS is
'Initial number of transactions'
/
comment on column DBA_INDEXES.MAX_TRANS is
'Maximum number of transactions'
/
comment on column DBA_INDEXES.INITIAL_EXTENT is
'Size of the initial extent'
/
comment on column DBA_INDEXES.NEXT_EXTENT is
'Size of secondary extents'
/
comment on column DBA_INDEXES.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column DBA_INDEXES.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column DBA_INDEXES.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column DBA_INDEXES.FREELISTS is
'Number of process freelists allocated in this segment'
/
comment on column DBA_INDEXES.FREELIST_GROUPS is
'Number of freelist groups allocated to this segment'
/
comment on column DBA_INDEXES.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column DBA_INDEXES.BLEVEL is
'B-Tree level'
/
comment on column DBA_INDEXES.LEAF_BLOCKS is
'The number of leaf blocks in the index'
/
comment on column DBA_INDEXES.DISTINCT_KEYS is
'The number of distinct keys in the index'
/
comment on column DBA_INDEXES.AVG_LEAF_BLOCKS_PER_KEY is
'The average number of leaf blocks per key'
/
comment on column DBA_INDEXES.AVG_DATA_BLOCKS_PER_KEY is
'The average number of data blocks per key'
/
comment on column DBA_INDEXES.CLUSTERING_FACTOR is
'A measurement of the amount of (dis)order of the table this index is for'
/
remark
remark  FAMILY "IND_COLUMNS"
remark  Displays information on which columns are contained in which
remark  indexes
remark
create or replace view USER_IND_COLUMNS
    (INDEX_NAME, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH)
as
select idx.name, base.name, 
       c.name, ic.pos#, c.length
from sys.col$ c, sys.obj$ idx, sys.obj$ base, sys.icol$ ic
where base.obj# = c.obj#
  and ic.bo# = base.obj#
  and ic.col# = c.col#
  and (base.owner# = userenv('SCHEMAID') or idx.owner# = userenv('SCHEMAID'))
  and ic.obj# = idx.obj#
/
comment on table USER_IND_COLUMNS is
'COLUMNs comprising user''s INDEXes or on user''s TABLES'
/
comment on column USER_IND_COLUMNS.INDEX_NAME is
'Index name'
/
comment on column USER_IND_COLUMNS.TABLE_NAME is
'Table or cluster name'
/
comment on column USER_IND_COLUMNS.COLUMN_NAME is
'Column name'
/
comment on column USER_IND_COLUMNS.COLUMN_POSITION is
'Position of column within index'
/
comment on column USER_IND_COLUMNS.COLUMN_LENGTH is
'Indexed length of the column'
/
drop public synonym USER_IND_COLUMNS
/
create public synonym USER_IND_COLUMNS for USER_IND_COLUMNS
/
grant select on USER_IND_COLUMNS to PUBLIC with grant option
/
create or replace view ALL_IND_COLUMNS
    (INDEX_OWNER, INDEX_NAME,
     TABLE_OWNER, TABLE_NAME,
     COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH)
as
select io.name, idx.name, bo.name, base.name, 
       c.name, ic.pos#, c.length
from sys.col$ c, sys.obj$ idx, sys.obj$ base, sys.icol$ ic,
     sys.user$ io, sys.user$ bo
where base.obj# = c.obj#
  and ic.col# = c.col#
  and ic.bo# = base.obj#
  and io.user# = idx.owner#
  and bo.user# = base.owner#
  and ic.obj# = idx.obj#
  and (idx.owner# = userenv('SCHEMAID') or
       base.owner# = userenv('SCHEMAID')
       or
       base.obj# in ( select obj#
                     from sys.objauth$
                     where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                   )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
comment on table ALL_IND_COLUMNS is
'COLUMNs comprising INDEXes on accessible TABLES'
/
comment on column ALL_IND_COLUMNS.INDEX_OWNER is
'Index owner'
/
comment on column ALL_IND_COLUMNS.INDEX_NAME is
'Index name'
/
comment on column ALL_IND_COLUMNS.TABLE_OWNER is
'Table or cluster owner'
/
comment on column ALL_IND_COLUMNS.TABLE_NAME is
'Table or cluster name'
/
comment on column ALL_IND_COLUMNS.COLUMN_NAME is
'Column name'
/
comment on column ALL_IND_COLUMNS.COLUMN_POSITION is
'Position of column within index'
/
comment on column ALL_IND_COLUMNS.COLUMN_LENGTH is
'Indexed length of the column'
/
drop public synonym ALL_IND_COLUMNS
/
create public synonym ALL_IND_COLUMNS for ALL_IND_COLUMNS
/
grant select on ALL_IND_COLUMNS to PUBLIC with grant option
/
create or replace view DBA_IND_COLUMNS
    (INDEX_OWNER, INDEX_NAME,
     TABLE_OWNER, TABLE_NAME,
     COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH)
as
select io.name, idx.name, bo.name, base.name, 
       c.name, ic.pos#, c.length
from sys.col$ c, sys.obj$ idx, sys.obj$ base, sys.icol$ ic,
     sys.user$ io, sys.user$ bo
where base.obj# = c.obj#
  and ic.col# = c.col#
  and ic.bo# = base.obj#
  and io.user# = idx.owner#
  and bo.user# = base.owner#
  and ic.obj# = idx.obj#
/
drop public synonym DBA_IND_COLUMNS
/
create public synonym DBA_IND_COLUMNS for DBA_IND_COLUMNS
/
comment on table DBA_IND_COLUMNS is
'COLUMNs comprising INDEXes on all TABLEs and CLUSTERs'
/
comment on column DBA_IND_COLUMNS.INDEX_OWNER is
'Index owner'
/
comment on column DBA_IND_COLUMNS.INDEX_NAME is
'Index name'
/
comment on column DBA_IND_COLUMNS.TABLE_OWNER is
'Table or cluster owner'
/
comment on column DBA_IND_COLUMNS.TABLE_NAME is
'Table or cluster name'
/
comment on column DBA_IND_COLUMNS.COLUMN_NAME is
'Column name'
/
comment on column DBA_IND_COLUMNS.COLUMN_POSITION is
'Position of column within index'
/
comment on column DBA_IND_COLUMNS.COLUMN_LENGTH is
'Indexed length of the column'
/
create or replace view INDEX_STATS as
 select	kdxstrot+1	height, 
	s.blocks,
	o.name,
       	kdxstlrw 	lf_rows,
	kdxstlbk	lf_blks,
	kdxstlln	lf_rows_len,
	kdxstlub	lf_blk_len,
       	kdxstbrw 	br_rows,
	kdxstbbk	br_blks,
	kdxstbln	br_rows_len,
	kdxstbub	br_blk_len,
	kdxstdrw	del_lf_rows,
	kdxstdln	del_lf_rows_len,
	kdxstdis	distinct_keys,
	kdxstmrl	most_repeated_key,
	kdxstlbk*kdxstlub+kdxstbbk*kdxstbub	btree_space,
	kdxstlln+kdxstbln			used_space,
	ceil(((kdxstlln+kdxstbln)*100)/
	(kdxstlbk*kdxstlub+kdxstbbk*kdxstbub))
						pct_used,	
	kdxstlrw/decode(kdxstdis, 0, 1, kdxstdis) rows_per_key,
	kdxstrot+1+(kdxstlrw+kdxstdis)/(decode(kdxstdis, 0, 1, kdxstdis)*2)
						blks_gets_per_access
  from obj$ o, ind$ i, seg$ s, x$kdxst
 where kdxstfil = s.file#
  and  kdxstblk = s.block#
  and  s.file#  = i.file#
  and  s.block# = i.block#
  and  i.obj#   = o.obj#
/
comment on table INDEX_STATS is
'statistics on the b-tree'
/
comment on column index_stats.height is 
'height of the b-tree'
/
comment on column index_stats.blocks is
'blocks allocated to the segment'
/
comment on column index_stats.name is
'name of the index'
/
comment on column index_stats.lf_rows is
'number of leaf rows (values in the index)'
/
comment on column index_stats.lf_blks is
'number of leaf blocks in the b-tree'
/
comment on column index_stats.lf_rows_len is
'sum of the lengths of all the leaf rows'
/
comment on column index_stats.lf_blk_len is
'useable space in a leaf block'
/
comment on column index_stats.br_rows is
'number of branch rows'
/
comment on column index_stats.br_blks is
'number of branch blocks in the b-tree'
/
comment on column index_stats.br_rows_len is
'sum of the lengths of all the branch blocks in the b-tree'
/
comment on column index_stats.br_blk_len is
'useable space in a branch block'
/
comment on column index_stats.del_lf_rows is
'number of deleted leaf rows in the index'
/
comment on column index_stats.del_lf_rows_len is
'total length of all deleted rows in the index'
/
comment on column index_stats.distinct_keys is
'number of distinct keys in the index'
/
comment on column index_stats.most_repeated_key is
'how many times the most repeated key is repeated'
/
comment on column index_stats.btree_space is
'total space currently allocated in the b-tree'
/
comment on column index_stats.used_space is
'total space that is currently being used in the b-tree'
/
comment on column index_stats.pct_used is
'percent of space allocated in the b-tree that is being used'
/
comment on column index_stats.rows_per_key is
'average number of rows per distinct key'
/
comment on column index_stats.blks_gets_per_access is
'Expected number of consistent mode block gets per row. This assumes that a row chosen at random from the table is being searched for using the index'
/
drop public synonym INDEX_STATS
/
create public synonym INDEX_STATS for INDEX_STATS
/
grant select on INDEX_STATS to public with grant option
/
create or replace view INDEX_HISTOGRAM as
 select hist.indx * power(2, stats.kdxstscl-4)	repeat_count,
	hist.kdxhsval				keys_with_repeat_count
	from  x$kdxst stats, x$kdxhs hist
/
comment on table INDEX_HISTOGRAM is
'statistics on keys with repeat count'
/
comment on column index_histogram.repeat_count is
'number of times that a key is repeated'
/
comment on column index_histogram.keys_with_repeat_count is
'number of keys that are repeated REPEAT_COUNT times'
/
drop public synonym INDEX_HISTOGRAM
/
create public synonym INDEX_HISTOGRAM for INDEX_HISTOGRAM
/
grant select on INDEX_HISTOGRAM to public with grant option
/
remark
remark  FAMILY "OBJECTS"
remark  List of objects, including creation and modify times.
remark
create or replace view USER_OBJECTS
    (OBJECT_NAME, OBJECT_ID, OBJECT_TYPE,
     CREATED, LAST_DDL_TIME, TIMESTAMP, STATUS)
as
select o.name, o.obj#,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 
                      7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                      11, 'PACKAGE BODY', 12, 'TRIGGER', 'UNDEFINED'),
       o.ctime, o.mtime,
       to_char(o.stime, 'YYYY-MM-DD:HH24:MI:SS'),
       decode(o.status, 0, 'N/A', 1, 'VALID', 'INVALID')
from sys.obj$ o
where o.owner# = userenv('SCHEMAID')
  and o.linkname is null
  and o.type != 10
union all
select l.name, to_number(null),
       'DATABASE LINK',
       l.ctime, to_date(null), NULL, 'VALID'
from sys.link$ l
where l.owner# = userenv('SCHEMAID')
/
comment on table USER_OBJECTS is
'Objects owned by the user'
/
comment on column USER_OBJECTS.OBJECT_NAME is
'Name of the object'
/
comment on column USER_OBJECTS.OBJECT_ID is
'Object number of the object'
/
comment on column USER_OBJECTS.OBJECT_TYPE is
'Type of the object'
/
comment on column USER_OBJECTS.CREATED is
'Timestamp for the creation of the object'
/
comment on column USER_OBJECTS.LAST_DDL_TIME is
'Timestamp for the last DDL change (including GRANT and REVOKE) to the object'
/
comment on column USER_OBJECTS.TIMESTAMP is
'Timestamp for the specification of the object'
/
comment on column USER_OBJECTS.STATUS is
'Status of the object'
/
drop public synonym USER_OBJECTS
/
create public synonym USER_OBJECTS for USER_OBJECTS
/
drop public synonym OBJ
/
create public synonym OBJ for USER_OBJECTS
/
grant select on USER_OBJECTS to PUBLIC with grant option
/
create or replace view ALL_OBJECTS
    (OWNER, OBJECT_NAME, OBJECT_ID, OBJECT_TYPE,
     CREATED, LAST_DDL_TIME, TIMESTAMP, STATUS)
as
select u.name, o.name, o.obj#,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 
                      7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                      11, 'PACKAGE BODY', 12, 'TRIGGER', 'UNDEFINED'),
       o.ctime, o.mtime,
       to_char(o.stime, 'YYYY-MM-DD:HH24:MI:SS'),
       decode(o.status, 0, 'N/A', 1, 'VALID', 'INVALID')
from sys.obj$ o, sys.user$ u
where o.owner# = u.user#
  and o.linkname is null
  and o.type != 10
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      o.type != 11 /* EXECUTE priv does not let user see pkg body */
      and
      o.obj# in (select obj# from sys.objauth$
                 where grantee# in (select kzsrorol from x$kzsro)
                   and privilege# in (3 /* DELETE */,   6 /* INSERT */,
                                      7 /* LOCK */,     9 /* SELECT */,
                                      10 /* UPDATE */, 12 /* EXECUTE */))
    )
    or
    (
       o.type in (7, 8, 9) /* prc, fcn, pkg */
       and
       exists (select null from v$enabledprivs
	       where priv_number in (
	                              -144 /* EXECUTE ANY PROCEDURE */,
	                              -141 /* CREATE ANY PROCEDURE */
				    )
              )
    )
    or
    (
       o.type in (12) /* trigger */
       and
       exists (select null from v$enabledprivs
	       where priv_number in (
	                              -152 /* CREATE ANY TRIGGER */
				    )
              )
    )
    or
    (
       o.type = 11 /* pkg body */
       and
       exists (select null from v$enabledprivs
	       where priv_number =   -141 /* CREATE ANY PROCEDURE */
              )
    )
    or
    (
       o.type in (1, 2, 4, 5) /* index, table, view, synonym */
       and
       exists (select null from v$enabledprivs
               where priv_number in (-45 /* LOCK ANY TABLE */,
				     -47 /* SELECT ANY TABLE */,
				     -48 /* INSERT ANY TABLE */,
				     -49 /* UPDATE ANY TABLE */,
				     -50 /* DELETE ANY TABLE */)
               )
    )
    or
    ( o.type = 6 /* sequence */
      and
      exists (select null from v$enabledprivs
              where priv_number = -109 /* SELECT ANY SEQUENCE */)
    )
  )
/
comment on table ALL_OBJECTS is
'Objects accessible to the user'
/
comment on column ALL_OBJECTS.OWNER is
'Username of the owner of the object'
/
comment on column ALL_OBJECTS.OBJECT_NAME is
'Name of the object'
/
comment on column ALL_OBJECTS.OBJECT_ID is
'Object number of the object'
/
comment on column ALL_OBJECTS.OBJECT_TYPE is
'Type of the object'
/
comment on column ALL_OBJECTS.CREATED is
'Timestamp for the creation of the object'
/
comment on column ALL_OBJECTS.LAST_DDL_TIME is
'Timestamp for the last DDL change (including GRANT and REVOKE) to the object'
/
comment on column ALL_OBJECTS.TIMESTAMP is
'Timestamp for the specification of the object'
/
comment on column ALL_OBJECTS.STATUS is
'Status of the object'
/
drop public synonym ALL_OBJECTS
/
create public synonym ALL_OBJECTS for ALL_OBJECTS
/
grant select on ALL_OBJECTS to PUBLIC with grant option
/
create or replace view DBA_OBJECTS
    (OWNER, OBJECT_NAME, OBJECT_ID, OBJECT_TYPE,
     CREATED, LAST_DDL_TIME, TIMESTAMP, STATUS)
as
select u.name, o.name, o.obj#,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 
                      7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                      11, 'PACKAGE BODY', 12, 'TRIGGER', 'UNDEFINED'),
       o.ctime, o.mtime,
       to_char(o.stime, 'YYYY-MM-DD:HH24:MI:SS'),
       decode(o.status, 0, 'N/A', 1, 'VALID', 'INVALID')
from sys.obj$ o, sys.user$ u
where o.owner# = u.user#
  and o.linkname is null
  and o.type != 10 and o.name != '_NEXT_OBJECT'
  and o.name != '_default_auditing_options_'
union all
select u.name, l.name, to_number(null),
       'DATABASE LINK',
       l.ctime, to_date(null), NULL, 'VALID'
from sys.link$ l, sys.user$ u
where l.owner# = u.user#
/
drop public synonym DBA_OBJECTS
/
create public synonym DBA_OBJECTS for DBA_OBJECTS
/
comment on table DBA_OBJECTS is
'All objects in the database'
/
comment on column DBA_OBJECTS.OWNER is
'Username of the owner of the object'
/
comment on column DBA_OBJECTS.OBJECT_NAME is
'Name of the object'
/
comment on column DBA_OBJECTS.OBJECT_ID is
'Object number of the object'
/
comment on column DBA_OBJECTS.OBJECT_TYPE is
'Type of the object'
/
comment on column DBA_OBJECTS.CREATED is
'Timestamp for the creation of the object'
/
comment on column DBA_OBJECTS.LAST_DDL_TIME is
'Timestamp for the last DDL change (including GRANT and REVOKE) to the object'
/
comment on column DBA_OBJECTS.TIMESTAMP is
'Timestamp for the specification of the object'
/
comment on column DBA_OBJECTS.STATUS is
'Status of the object'
/

remark
remark Family ARGUMENTS
remark

create or replace view ALL_ARGUMENTS
(OWNER, OBJECT_NAME, PACKAGE_NAME, OBJECT_ID, OVERLOAD, 
ARGUMENT_NAME, POSITION, SEQUENCE, 
DATA_LEVEL, DATA_TYPE, DEFAULT_VALUE, DEFAULT_LENGTH, IN_OUT, DATA_LENGTH, 
DATA_PRECISION, DATA_SCALE, RADIX)
as
select
u.name, /* OWNER */
nvl(a.procedure$,o.name), /* OBJECT_NAME */
decode(a.procedure$,null,null, o.name), /* PACKAGE_NAME */
o.obj#, /* OBJECT_ID */
decode(a.overload#,0,null,a.overload#), /* OVERLOAD */
a.argument, /* ARGUMENT_NAME */
a.position, /* POSITION */
a.sequence#, /* SEQUENCE */
a.level#, /* DATA_LEVEL */
decode(a.type,  /* DATA_TYPE */
0, null, 
1, 'VARCHAR2',
2, decode(a.scale, null, decode(a.precision, null, 'NUMBER', 'FLOAT'),'NUMBER'),
3, 'NATIVE INTEGER',
8, 'LONG', 
9, 'VARCHAR',
12, 'DATE', 
23, 'RAW', 
24, 'LONG RAW', 
29, 'BINARY_INTEGER',
69, 'ROWID',
96,'CHAR', 
102, 'REF CURSOR',
105, 'MLSLABEL',
106, 'MLSLABEL', 
250, 'PL/SQL RECORD', 
251, 'PL/SQL TABLE',
252, 'PL/SQL BOOLEAN',
'UNDEFINED'), 
default$, /* DEFAULT_VALUE */
deflength, /* DEFAULT_LENGTH */
decode(in_out,null,'IN',1,'OUT',2,'IN/OUT','Undefined'), /* IN_OUT */
length, /* DATA_LENGTH */
precision, /* DATA_PRECISION */
scale, /* DATA_SCALE */
radix /* RADIX */
from obj$ o,argument$ a,user$ u
where o.obj# = a.obj#
and o.owner# = u.user#
and (owner# = userenv('SCHEMAID')
or exists 
  (select null from v$enabledprivs where priv_number in (-144,-141))
or o.obj# in (select obj# from sys.objauth$ where grantee# in
  (select kzsrorol from x$kzsro) and privilege# = 12))
/
comment on table all_arguments is
'Arguments in object accessible to the user'
/
comment on column all_arguments.owner is
'Username of the owner of the object'
/
comment on column all_arguments.object_name is
'Procedure or function name'
/
comment on column all_arguments.overload is
'Overload unique identifier'
/
comment on column all_arguments.package_name is
'Package name'
/
comment on column all_arguments.object_id is
'Object number of the object'
/
comment on column all_arguments.argument_name is
'Argument name'
/
comment on column all_arguments.position is
'Position in argument list, or null for function return value'
/
comment on column all_arguments.sequence is
'Argument sequence, including all nesting levels'
/
comment on column all_arguments.data_level is
'Nesting depth of argument for composite types'
/
comment on column all_arguments.data_type is
'Datatype of the argument'
/
comment on column all_arguments.default_value is
'Default value for the argument'
/
comment on column all_arguments.default_length is
'Length of default value for the argument'
/
comment on column all_arguments.in_out is
'Argument direction (IN, OUT, or IN/OUT)'
/
comment on column all_arguments.data_length is
'Length of the column in bytes'
/
comment on column all_arguments.data_precision is
'Length: decimal digits (NUMBER) or binary digits (FLOAT)'
/
comment on column all_arguments.data_scale is
'Digits to right of decimal point in a number'
/
comment on column all_arguments.radix is
'Argument radix for a number'
/
drop public synonym all_arguments
/
create public synonym all_arguments for all_arguments
/
grant select on all_arguments to public with grant option
/

create or replace view USER_ARGUMENTS
(OBJECT_NAME, PACKAGE_NAME, OBJECT_ID, OVERLOAD, 
ARGUMENT_NAME, POSITION, SEQUENCE, 
DATA_LEVEL, DATA_TYPE, DEFAULT_VALUE, DEFAULT_LENGTH, IN_OUT, DATA_LENGTH, 
DATA_PRECISION, DATA_SCALE, RADIX)
as
select
nvl(a.procedure$,o.name), /* OBJECT_NAME */
decode(a.procedure$,null,null, o.name), /* PACKAGE_NAME */
o.obj#, /* OBJECT_ID */
decode(a.overload#,0,null,a.overload#), /* OVERLOAD */
a.argument, /* ARGUMENT_NAME */
a.position, /* POSITION */
a.sequence#, /* SEQUENCE */
a.level#, /* DATA_LEVEL */
decode(a.type,  /* DATA_TYPE */
0, null, 
1, 'VARCHAR2',
2, decode(a.scale, null, decode(a.precision, null, 'NUMBER', 'FLOAT'),'NUMBER'),
3, 'NATIVE INTEGER',
8, 'LONG', 
9, 'VARCHAR',
12, 'DATE', 
23, 'RAW', 
24, 'LONG RAW', 
29, 'BINARY_INTEGER',
69, 'ROWID',
96,'CHAR', 
102, 'REF CURSOR',
105, 'MLSLABEL',
106, 'MLSLABEL', 
250, 'PL/SQL RECORD', 
251, 'PL/SQL TABLE',
252, 'PL/SQL BOOLEAN',
'UNDEFINED'), 
default$, /* DEFAULT_VALUE */
deflength, /* DEFAULT_LENGTH */
decode(in_out,null,'IN',1,'OUT',2,'IN/OUT','Undefined'), /* IN_OUT */
length, /* DATA_LENGTH */
precision, /* DATA_PRECISION */
scale, /* DATA_SCALE */
radix /* RADIX */
from obj$ o,argument$ a
where o.obj# = a.obj#
and owner# = userenv('SCHEMAID')
/
comment on table user_arguments is
'Arguments in object accessible to the user'
/
comment on column user_arguments.object_name is
'Procedure or function name'
/
comment on column user_arguments.overload is
'Overload unique identifier'
/
comment on column user_arguments.package_name is
'Package name'
/
comment on column user_arguments.object_id is
'Object number of the object'
/
comment on column user_arguments.argument_name is
'Argument name'
/
comment on column user_arguments.position is
'Position in argument list, or null for function return value'
/
comment on column user_arguments.sequence is
'Argument sequence, including all nesting levels'
/
comment on column user_arguments.data_level is
'Nesting depth of argument for composite types'
/
comment on column user_arguments.data_type is
'Datatype of the argument'
/
comment on column user_arguments.default_value is
'Default value for the argument'
/
comment on column user_arguments.default_length is
'Length of default value for the argument'
/
comment on column user_arguments.in_out is
'Argument direction (IN, OUT, or IN/OUT)'
/
comment on column user_arguments.data_length is
'Length of the column in bytes'
/
comment on column user_arguments.data_precision is
'Length: decimal digits (NUMBER) or binary digits (FLOAT)'
/
comment on column user_arguments.data_scale is
'Digits to right of decimal point in a number'
/
comment on column user_arguments.radix is
'Argument radix for a number'
/
drop public synonym user_arguments
/
create public synonym user_arguments for user_arguments
/
grant select on user_arguments to public with grant option
/


remark
remark  FAMILY "ROLLBACK_SEGS"
remark  CREATE ROLLBACK SEGMENT parameters.
remark  This family has a DBA member only.
remark
create or replace view DBA_ROLLBACK_SEGS
    (SEGMENT_NAME, OWNER, TABLESPACE_NAME, SEGMENT_ID, FILE_ID, BLOCK_ID,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     STATUS, INSTANCE_NUM)
as
select un.name, decode(un.user#,1,'PUBLIC','SYS'),
       ts.name, un.us#, un.file#, un.block#,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
       s.minexts, s.maxexts, s.extpct,
       decode(un.status$, 2, 'OFFLINE', 3, 'ONLINE',
                          4, 'UNDEFINED', 5, 'NEEDS RECOVERY', 
                          6, 'PARTLY AVAILABLE', 'UNDEFINED'),
       decode(un.inst#, 0, NULL, un.inst#)
from sys.undo$ un, sys.seg$ s, sys.ts$ ts
where un.status$ != 1
  and un.file# = s.file# 
  and un.block# = s.block#
  and s.type = 1
  and s.ts# = ts.ts#
/
drop public synonym DBA_ROLLBACK_SEGS
/
create public synonym DBA_ROLLBACK_SEGS for DBA_ROLLBACK_SEGS
/
comment on table DBA_ROLLBACK_SEGS is
'Description of rollback segments'
/
comment on column DBA_ROLLBACK_SEGS.SEGMENT_NAME is
'Name of the rollback segment'
/
comment on column DBA_ROLLBACK_SEGS.OWNER is
'Owner of the rollback segment'
/
comment on column DBA_ROLLBACK_SEGS.TABLESPACE_NAME is
'Name of the tablespace containing the rollback segment'
/
comment on column DBA_ROLLBACK_SEGS.SEGMENT_ID is
'ID number of the rollback segment'
/
comment on column DBA_ROLLBACK_SEGS.FILE_ID is
'ID number of the file containing the segment header'
/
comment on column DBA_ROLLBACK_SEGS.BLOCK_ID is
'ID number of the block containing the segment header'
/
comment on column DBA_ROLLBACK_SEGS.INITIAL_EXTENT is
'Initial extent size in bytes'
/
comment on column DBA_ROLLBACK_SEGS.NEXT_EXTENT is
'Secondary extent size in bytes'
/
comment on column DBA_ROLLBACK_SEGS.MIN_EXTENTS is
'Minimum number of extents'
/
comment on column DBA_ROLLBACK_SEGS.MAX_EXTENTS is
'Maximum number of extents'
/
comment on column DBA_ROLLBACK_SEGS.PCT_INCREASE is
'Percent increase for extent size'
/
comment on column DBA_ROLLBACK_SEGS.STATUS is
'Rollback segment status'
/   
comment on column DBA_ROLLBACK_SEGS.INSTANCE_NUM is
'Rollback segment owning parallel server instance number'
/
remark
remark  FAMILY "ROLE GRANTS"
remark  
remark
create or replace view USER_ROLE_PRIVS
    (USERNAME, GRANTED_ROLE, ADMIN_OPTION, DEFAULT_ROLE, OS_GRANTED)
as
select decode(sa.grantee#, 1, 'PUBLIC', u1.name), u2.name,
       decode(min(option$), 1, 'YES', 'NO'),
       decode(min(u1.defrole), 0, 'NO', 1, 'YES', 
              2, decode(min(ud.role#),null,'NO','YES'), 
              3, decode(min(ud.role#),null,'YES','NO'), 'NO'), 'NO'
from sysauth$ sa,defrole$ ud, user$ u1, user$ u2
where sa.grantee# in (userenv('SCHEMAID'),1) and sa.grantee#=ud.user#(+)
  and sa.privilege#=ud.role#(+) and u1.user#=sa.grantee#
  and u2.user#=sa.privilege#
group by decode(sa.grantee#,1,'PUBLIC',u1.name),u2.name
union
select user,u.name,decode(kzdosadm,'A','YES','NO'), 
       decode(kzdosdef,'Y','YES','NO'), 'YES'
 from sys.user$ u,x$kzdos
where u.user#=x$kzdos.kzdosrol
/
comment on table USER_ROLE_PRIVS is
'Roles granted to current user'
/
comment on column USER_ROLE_PRIVS.USERNAME is
'User Name or PUBLIC'
/
comment on column USER_ROLE_PRIVS.GRANTED_ROLE is
'Granted role name'
/
comment on column USER_ROLE_PRIVS.ADMIN_OPTION is
'Grant was with the ADMIN option'
/
comment on column USER_ROLE_PRIVS.DEFAULT_ROLE is
'Role is designated as a DEFAULT ROLE for the user'
/
comment on column USER_ROLE_PRIVS.OS_GRANTED is
'Role is granted via the operating system (using OS_ROLES = TRUE)'
/
drop public synonym USER_ROLE_PRIVS
/
create public synonym USER_ROLE_PRIVS for USER_ROLE_PRIVS
/
grant select on USER_ROLE_PRIVS to PUBLIC with grant option
/
create or replace view DBA_ROLE_PRIVS
    (GRANTEE, GRANTED_ROLE, ADMIN_OPTION, DEFAULT_ROLE)
as
select decode(sa.grantee#, 1, 'PUBLIC', u1.name), u2.name,
       decode(min(option$), 1, 'YES', 'NO'),
       decode(min(u1.defrole), 0, 'NO', 1, 'YES', 
              2, decode(min(ud.role#),null,'NO','YES'), 
              3, decode(min(ud.role#),null,'YES','NO'), 'NO')
from sysauth$ sa,defrole$ ud, user$ u1, user$ u2
where sa.grantee#=ud.user#(+)
  and sa.privilege#=ud.role#(+) and u1.user#=sa.grantee#
  and u2.user#=sa.privilege#
group by decode(sa.grantee#,1,'PUBLIC',u1.name),u2.name
/
drop public synonym DBA_ROLE_PRIVS
/
create public synonym DBA_ROLE_PRIVS for DBA_ROLE_PRIVS
/
comment on table DBA_ROLE_PRIVS is
'Roles granted to users and roles'
/
comment on column DBA_ROLE_PRIVS.GRANTEE is
'Grantee Name, User or Role receiving the grant'
/
comment on column DBA_ROLE_PRIVS.GRANTED_ROLE is
'Granted role name'
/
comment on column DBA_ROLE_PRIVS.ADMIN_OPTION is
'Grant was with the ADMIN option'
/
comment on column DBA_ROLE_PRIVS.DEFAULT_ROLE is
'Role is designated as a DEFAULT ROLE for the user'
/
remark
remark  FAMILY "SYS GRANTS"
remark  
remark
create or replace view USER_SYS_PRIVS
    (USERNAME, PRIVILEGE, ADMIN_OPTION)
as
select decode(sa.grantee#,1,'PUBLIC',user),spm.name,
       decode(min(option$),1,'YES','NO')
from  sys.system_privilege_map spm, sys.sysauth$ sa
where (sa.grantee#=userenv('SCHEMAID') or sa.grantee#=1)
  and sa.privilege#=spm.privilege
group by decode(sa.grantee#,1,'PUBLIC',user),spm.name
/
comment on table USER_SYS_PRIVS is
'System privileges granted to current user'
/
comment on column USER_SYS_PRIVS.USERNAME is
'User Name or PUBLIC'
/
comment on column USER_SYS_PRIVS.PRIVILEGE is
'System privilege'
/
comment on column USER_SYS_PRIVS.ADMIN_OPTION is
'Grant was with the ADMIN option'
/
drop public synonym USER_SYS_PRIVS
/
create public synonym USER_SYS_PRIVS for USER_SYS_PRIVS
/
grant select on USER_SYS_PRIVS to PUBLIC with grant option
/
create or replace view DBA_SYS_PRIVS
    (GRANTEE, PRIVILEGE, ADMIN_OPTION)
as
select u.name,spm.name,decode(min(option$),1,'YES','NO')
from  sys.system_privilege_map spm, sys.sysauth$ sa, user$ u
where sa.grantee#=u.user# and sa.privilege#=spm.privilege
group by u.name,spm.name
/
drop public synonym DBA_SYS_PRIVS
/
create public synonym DBA_SYS_PRIVS for DBA_SYS_PRIVS
/
comment on table DBA_SYS_PRIVS is
'System privileges granted to users and roles'
/
comment on column DBA_SYS_PRIVS.GRANTEE is
'Grantee Name, User or Role receiving the grant'
/
comment on column DBA_SYS_PRIVS.PRIVILEGE is
'System privilege'
/
comment on column DBA_SYS_PRIVS.ADMIN_OPTION is
'Grant was with the ADMIN option'
/
remark  FAMILY "SEGMENTS"
remark  Storage for all types of segments
remark  This family has no ALL member.
remark  define SYS_OBJECTS for use by segments views
create or replace view SYS_OBJECTS
    (OBJECT_TYPE, OBJECT_TYPE_ID, SEGMENT_TYPE_ID,
     OBJECT_ID, HEADER_FILE, HEADER_BLOCK)
as
select 'TABLE', 2, 5,
       t.obj#, t.file#, t.block#
from sys.tab$ t
where t.clu# is null  /* exclude clustered tables */
union all
select 'CLUSTER', 3, 5,
       c.obj#, c.file#, c.block#
from sys.clu$ c
union all
select 'INDEX', 1, 6,
       i.obj#, i.file#, i.block#
from sys.ind$ i
/
create or replace view USER_SEGMENTS
    (SEGMENT_NAME,
     SEGMENT_TYPE,
     TABLESPACE_NAME,
     BYTES, BLOCKS, EXTENTS, 
     INITIAL_EXTENT, NEXT_EXTENT, 
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE, FREELISTS, FREELIST_GROUPS)
as
select o.name,
       so.object_type,
       ts.name,
       s.blocks * ts.blocksize, s.blocks, s.extents, 
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, s.minexts, 
       s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups)
from sys.obj$ o, sys.ts$ ts, sys.sys_objects so, sys.seg$ s
where s.file# = so.header_file
  and s.block# = so.header_block
  and s.ts# = ts.ts#
  and o.obj# = so.object_id
  and o.owner# = userenv('SCHEMAID')
  and s.type = so.segment_type_id
  and o.type = so.object_type_id
union all
select un.name,
       'ROLLBACK',
       ts.name,
       s.blocks * ts.blocksize, s.blocks, s.extents,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, s.minexts, 
       s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups)
from sys.ts$ ts, sys.undo$ un, sys.seg$ s
where s.file# = un.file#
  and s.block# = un.block#
  and s.ts# = ts.ts#
  and s.user# = userenv('SCHEMAID')
  and s.type = 1
  and un.status$ != 1  
union all
select to_char(s.file#) || '.' || to_char(s.block#),
       decode(s.type, 2, 'DEFERRED ROLLBACK', 3, 'TEMPORARY',
                      4, 'CACHE', 'UNDEFINED'),
       ts.name,
       s.blocks * ts.blocksize, s.blocks, s.extents,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, s.minexts, 
       s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups)
from sys.ts$ ts, sys.seg$ s
where s.ts# = ts.ts#
  and s.user# = userenv('SCHEMAID')
  and s.type not in (1, 5, 6)
/
comment on table USER_SEGMENTS is
'Storage allocated for all database segments'
/
comment on column USER_SEGMENTS.SEGMENT_NAME is
'Name, if any, of the segment'
/
comment on column USER_SEGMENTS.SEGMENT_TYPE is
'Type of segment:  "TABLE", "CLUSTER", "INDEX", "ROLLBACK",
"DEFERRED ROLLBACK", "TEMPORARY", or "CACHE"'
/
comment on column USER_SEGMENTS.TABLESPACE_NAME is
'Name of the tablespace containing the segment'
/
comment on column USER_SEGMENTS.BYTES is
'Size, in bytes, of the segment'
/
comment on column USER_SEGMENTS.BLOCKS is
'Size, in Oracle blocks, of the segment'
/
comment on column USER_SEGMENTS.EXTENTS is
'Number of extents allocated to the segment'
/
comment on column USER_SEGMENTS.INITIAL_EXTENT is
'Size, in bytes, of the initial extent of the segment'
/
comment on column USER_SEGMENTS.NEXT_EXTENT is
'Size, in bytes, of the next extent to be allocated to the segment' 
/
comment on column USER_SEGMENTS.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column USER_SEGMENTS.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column USER_SEGMENTS.PCT_INCREASE is
'Percent by which to increase the size of the next extent to be allocated'
/
comment on column USER_SEGMENTS.FREELISTS is
'Number of process freelists allocated to this segment'
/
comment on column USER_SEGMENTS.FREELIST_GROUPS is
'Number of freelist groups allocated to this segment'
/
drop public synonym USER_SEGMENTS
/
create public synonym USER_SEGMENTS for USER_SEGMENTS
/
grant select on USER_SEGMENTS to PUBLIC with grant option
/
create or replace view DBA_SEGMENTS
    (OWNER, SEGMENT_NAME,
     SEGMENT_TYPE,
     TABLESPACE_NAME,
     HEADER_FILE, HEADER_BLOCK,
     BYTES, BLOCKS, EXTENTS, 
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE, FREELISTS, FREELIST_GROUPS)
as
select u.name, o.name,
       so.object_type,
       ts.name,
       s.file#, s.block#,
       s.blocks * ts.blocksize, s.blocks, s.extents, 
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, s.minexts, 
       s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups)
from sys.user$ u, sys.obj$ o, sys.ts$ ts, sys.sys_objects so, sys.seg$ s
where s.file# = so.header_file
  and s.block# = so.header_block
  and s.ts# = ts.ts#
  and o.obj# = so.object_id
  and o.owner# = u.user#
  and s.type = so.segment_type_id
  and o.type = so.object_type_id
union all
select u.name, un.name,
       'ROLLBACK', ts.name, s.file#, s.block#,
       s.blocks * ts.blocksize, s.blocks, s.extents,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, s.minexts, 
       s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups)
from sys.user$ u, sys.ts$ ts, sys.undo$ un, sys.seg$ s
where s.file# = un.file#
  and s.block# = un.block#
  and s.ts# = ts.ts#
  and s.user# = u.user#
  and s.type = 1
  and un.status$ != 1
union all
select u.name, to_char(s.file#) || '.' || to_char(s.block#),
       decode(s.type, 2, 'DEFERRED ROLLBACK', 3, 'TEMPORARY',
                      4, 'CACHE', 'UNDEFINED'),
       ts.name,
       s.file#, s.block#,
       s.blocks * ts.blocksize, s.blocks, s.extents,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, s.minexts, 
       s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups)
from sys.user$ u, sys.ts$ ts, sys.seg$ s
where s.ts# = ts.ts#
  and s.user# = u.user#
  and s.type not in (1, 5, 6)
/
drop public synonym DBA_SEGMENTS
/
create public synonym DBA_SEGMENTS for DBA_SEGMENTS
/
comment on table DBA_SEGMENTS is
'Storage allocated for all database segments'
/
comment on column DBA_SEGMENTS.OWNER is
'Username of the segment owner'
/
comment on column DBA_SEGMENTS.SEGMENT_NAME is
'Name, if any, of the segment'
/
comment on column DBA_SEGMENTS.SEGMENT_TYPE is
'Type of segment:  "TABLE", "CLUSTER", "INDEX", "ROLLBACK",
"DEFERRED ROLLBACK", "TEMPORARY", or "CACHE"'
/
comment on column DBA_SEGMENTS.TABLESPACE_NAME is
'Name of the tablespace containing the segment'
/
comment on column DBA_SEGMENTS.HEADER_FILE is
'ID of the file containing the segment header'
/
comment on column DBA_SEGMENTS.HEADER_BLOCK is
'ID of the block containing the segment header'
/
comment on column DBA_SEGMENTS.BYTES is
'Size, in bytes, of the segment'
/
comment on column DBA_SEGMENTS.BLOCKS is
'Size, in Oracle blocks, of the segment'
/
comment on column DBA_SEGMENTS.EXTENTS is
'Number of extents allocated to the segment'
/
comment on column DBA_SEGMENTS.INITIAL_EXTENT is
'Size, in bytes, of the initial extent of the segment'
/
comment on column DBA_SEGMENTS.NEXT_EXTENT is
'Size, in bytes, of the next extent to be allocated to the segment' 
/
comment on column DBA_SEGMENTS.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column DBA_SEGMENTS.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column DBA_SEGMENTS.PCT_INCREASE is
'Percent by which to increase the size of the next extent to be allocated'
/
comment on column DBA_SEGMENTS.FREELISTS is
'Number of process freelists allocated in this segment'
/
comment on column DBA_SEGMENTS.FREELIST_GROUPS is
'Number of freelist groups allocated in this segment'
/
remark
remark  FAMILY "EXTENTS"
remark  Extents associated with their segments.
remark
create or replace view USER_EXTENTS
    (SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME,
     EXTENT_ID, BYTES, BLOCKS)
as
select ds.segment_name, ds.segment_type, ds.tablespace_name,
       e.ext#, e.length * ts.blocksize, e.length
from sys.uet$ e, sys.dba_segments ds, sys.ts$ ts
where e.segfile# = ds.header_file
  and e.segblock# = ds.header_block
  and ds.tablespace_name = ts.name
  and ds.owner = user
/
comment on table USER_EXTENTS is
'Extents comprising segments owned by the user'
/
comment on column USER_EXTENTS.SEGMENT_NAME is
'Name of the segment associated with the extent'
/
comment on column USER_EXTENTS.TABLESPACE_NAME is
'Name of the tablespace containing the extent'
/
comment on column USER_EXTENTS.SEGMENT_TYPE is
'Type of the segment'
/
comment on column USER_EXTENTS.EXTENT_ID is
'Extent number in the segment'
/
comment on column USER_EXTENTS.BYTES is
'Size of the extent in bytes'
/
comment on column USER_EXTENTS.BLOCKS is
'Size of the extent in ORACLE blocks'
/
drop public synonym USER_EXTENTS
/
create public synonym USER_EXTENTS for USER_EXTENTS
/
grant select on USER_EXTENTS to PUBLIC with grant option
/
create or replace view DBA_EXTENTS
    (OWNER, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME,
     EXTENT_ID, FILE_ID, BLOCK_ID,
     BYTES, BLOCKS)
as
select ds.owner, ds.segment_name, ds.segment_type, ds.tablespace_name,
       e.ext#, e.file#, e.block#, e.length * ts.blocksize, e.length
from sys.uet$ e, sys.dba_segments ds, sys.ts$ ts
where e.segfile# = ds.header_file
  and e.segblock# = ds.header_block
  and ds.tablespace_name = ts.name
/
drop public synonym DBA_EXTENTS
/
create public synonym DBA_EXTENTS for DBA_EXTENTS
/
comment on table DBA_EXTENTS is
'Extents comprising all segments in the database'
/
comment on column DBA_EXTENTS.OWNER is
'Owner of the segment associated with the extent'
/
comment on column DBA_EXTENTS.SEGMENT_NAME is
'Name of the segment associated with the extent'
/
comment on column DBA_EXTENTS.TABLESPACE_NAME is
'Name of the tablespace containing the extent'
/
comment on column DBA_EXTENTS.SEGMENT_TYPE is
'Type of the segment'
/
comment on column DBA_EXTENTS.FILE_ID is
'Name of the file containing the extent'
/
comment on column DBA_EXTENTS.BLOCK_ID is
'Starting block number of the extent'
/
comment on column DBA_EXTENTS.EXTENT_ID is
'Extent number in the segment'
/
comment on column DBA_EXTENTS.BYTES is
'Size of the extent in bytes'
/
comment on column DBA_EXTENTS.BLOCKS is
'Size of the extent in ORACLE blocks'
/
remark
remark  FAMILY "SEQUENCES"
remark  CREATE SEQUENCE information.
remark
create or replace view USER_SEQUENCES
  (SEQUENCE_NAME, MIN_VALUE, MAX_VALUE, INCREMENT_BY,
                  CYCLE_FLAG, ORDER_FLAG, CACHE_SIZE, LAST_NUMBER)
as select o.name,
      s.minvalue, s.maxvalue, s.increment$,
      decode (s.cycle, 0, 'N', 1, 'Y'),
      decode (s.order$, 0, 'N', 1, 'Y'),
      s.cache, s.highwater
from sys.seq$ s, sys.obj$ o
where o.owner# = userenv('SCHEMAID')
  and o.obj# = s.obj#
/
comment on table USER_SEQUENCES is
'Description of the user''s own SEQUENCEs'
/
comment on column USER_SEQUENCES.SEQUENCE_NAME is
'SEQUENCE name'
/
comment on column USER_SEQUENCES.INCREMENT_BY is
'Value by which sequence is incremented'
/
comment on column USER_SEQUENCES.MIN_VALUE is
'Minimum value of the sequence'
/
comment on column USER_SEQUENCES.MAX_VALUE is
'Maximum value of the sequence'
/
comment on column USER_SEQUENCES.CYCLE_FLAG is
'Does sequence wrap around on reaching limit?'
/
comment on column USER_SEQUENCES.ORDER_FLAG is
'Are sequence numbers generated in order?'
/
comment on column USER_SEQUENCES.CACHE_SIZE is
'Number of sequence numbers to cache'
/
comment on column USER_SEQUENCES.LAST_NUMBER is
'Last sequence number written to disk'
/
drop public synonym USER_SEQUENCES
/
create public synonym USER_SEQUENCES for USER_SEQUENCES
/
drop public synonym SEQ
/
create public synonym SEQ for USER_SEQUENCES
/
grant select on USER_SEQUENCES to PUBLIC with grant option
/
create or replace view ALL_SEQUENCES
  (SEQUENCE_OWNER, SEQUENCE_NAME, 
                  MIN_VALUE, MAX_VALUE, INCREMENT_BY,
                  CYCLE_FLAG, ORDER_FLAG, CACHE_SIZE, LAST_NUMBER)
as select u.name, o.name,
      s.minvalue, s.maxvalue, s.increment$, 
      decode (s.cycle, 0, 'N', 1, 'Y'),
      decode (s.order$, 0, 'N', 1, 'Y'),
      s.cache, s.highwater
from sys.seq$ s, sys.obj$ o, sys.user$ u
where u.user# = o.owner#
  and o.obj# = s.obj#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or
	 exists (select null from v$enabledprivs
	         where priv_number = -109 /* SELECT ANY SEQUENCE */
                 )
      )
/
comment on table ALL_SEQUENCES is
'Description of SEQUENCEs accessible to the user'
/
comment on column ALL_SEQUENCES.SEQUENCE_OWNER is
'Name of the owner of the sequence'
/
comment on column ALL_SEQUENCES.SEQUENCE_NAME is
'SEQUENCE name'
/
comment on column ALL_SEQUENCES.INCREMENT_BY is
'Value by which sequence is incremented'
/
comment on column ALL_SEQUENCES.MIN_VALUE is
'Minimum value of the sequence'
/
comment on column ALL_SEQUENCES.MAX_VALUE is
'Maximum value of the sequence'
/
comment on column ALL_SEQUENCES.CYCLE_FLAG is
'Does sequence wrap around on reaching limit?'
/
comment on column ALL_SEQUENCES.ORDER_FLAG is
'Are sequence numbers generated in order?'
/
comment on column ALL_SEQUENCES.CACHE_SIZE is
'Number of sequence numbers to cache'
/
comment on column ALL_SEQUENCES.LAST_NUMBER is
'Last sequence number written to disk'
/
drop public synonym ALL_SEQUENCES
/
create public synonym ALL_SEQUENCES for ALL_SEQUENCES
/
grant select on ALL_SEQUENCES to PUBLIC with grant option
/
create or replace view DBA_SEQUENCES
  (SEQUENCE_OWNER, SEQUENCE_NAME, 
                  MIN_VALUE, MAX_VALUE, INCREMENT_BY,
                  CYCLE_FLAG, ORDER_FLAG, CACHE_SIZE, LAST_NUMBER)
as select u.name, o.name,
      s.minvalue, s.maxvalue, s.increment$, 
      decode (s.cycle, 0, 'N', 1, 'Y'),
      decode (s.order$, 0, 'N', 1, 'Y'),
      s.cache, s.highwater
from sys.seq$ s, sys.obj$ o, sys.user$ u
where u.user# = o.owner#
  and o.obj# = s.obj#
/
drop public synonym DBA_SEQUENCES
/
create public synonym DBA_SEQUENCES for DBA_SEQUENCES
/
comment on table DBA_SEQUENCES is
'Description of all SEQUENCEs in the database'
/
comment on column DBA_SEQUENCES.SEQUENCE_OWNER is
'Name of the owner of the sequence'
/
comment on column DBA_SEQUENCES.SEQUENCE_NAME is
'SEQUENCE name'
/
comment on column DBA_SEQUENCES.INCREMENT_BY is
'Value by which sequence is incremented'
/
comment on column DBA_SEQUENCES.MIN_VALUE is
'Minimum value of the sequence'
/
comment on column DBA_SEQUENCES.MAX_VALUE is
'Maximum value of the sequence'
/
comment on column DBA_SEQUENCES.CYCLE_FLAG is
'Does sequence wrap around on reaching limit?'
/
comment on column DBA_SEQUENCES.ORDER_FLAG is
'Are sequence numbers generated in order?'
/
comment on column DBA_SEQUENCES.CACHE_SIZE is
'Number of sequence numbers to cache'
/
comment on column DBA_SEQUENCES.LAST_NUMBER is
'Last sequence number written to disk'
/
remark
remark  FAMILY "SYNONYMS"
remark  CREATE SYNONYM information.
remark
create or replace view USER_SYNONYMS
    (SYNONYM_NAME, TABLE_OWNER, TABLE_NAME, DB_LINK)
as select o.name, s.owner, s.name, s.node
from sys.syn$ s, sys.obj$ o
where o.obj# = s.obj#
  and o.type = 5
  and o.owner# = userenv('SCHEMAID')
/
comment on table USER_SYNONYMS is
'The user''s private synonyms'
/
comment on column USER_SYNONYMS.SYNONYM_NAME is
'Name of the synonym'
/
comment on column USER_SYNONYMS.TABLE_OWNER is
'Owner of the object referenced by the synonym'
/
comment on column USER_SYNONYMS.TABLE_NAME is
'Name of the object referenced by the synonym'
/
comment on column USER_SYNONYMS.DB_LINK is
'Database link referenced in a remote synonym'
/
drop public synonym SYN
/
create public synonym SYN for USER_SYNONYMS
/
drop public synonym USER_SYNONYMS
/
create public synonym USER_SYNONYMS for USER_SYNONYMS
/
grant select on USER_SYNONYMS to PUBLIC with grant option
/
remark
remark  This view shows all synonyms owned by the user (private synonyms),
remark  plus all public synonyms.
remark
create or replace view ALL_SYNONYMS
    (OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME, DB_LINK)
as
select u.name, o.name, s.owner, s.name, s.node
from sys.user$ u, sys.syn$ s, sys.obj$ o
where o.obj# = s.obj#
  and o.type = 5
  and o.owner# = u.user#
  and (
       o.owner# in (USERENV('SCHEMAID'), 1 /* PUBLIC */)  /* user's private, any public */
       or /* user has any privs on base object */
	exists
        (select null from sys.objauth$ ba, sys.obj$ bo, sys.user$ bu
         where bu.name = s.owner
           and bo.name = s.name
           and bu.user# = bo.owner#
           and ba.obj# = bo.obj#
           and ba.grantee# in (select kzsrorol from x$kzsro))
        or /* user has system privileges */
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
comment on table ALL_SYNONYMS is
'All synonyms accessible to the user'
/
comment on column ALL_SYNONYMS.OWNER is
'Owner of the synonym'
/
comment on column ALL_SYNONYMS.SYNONYM_NAME is
'Name of the synonym'
/
comment on column ALL_SYNONYMS.TABLE_OWNER is
'Owner of the object referenced by the synonym'
/
comment on column ALL_SYNONYMS.TABLE_NAME is
'Name of the object referenced by the synonym'
/
comment on column ALL_SYNONYMS.DB_LINK is
'Name of the database link referenced in a remote synonym'
/
drop public synonym ALL_SYNONYMS
/
create public synonym ALL_SYNONYMS for ALL_SYNONYMS
/
grant select on ALL_SYNONYMS to PUBLIC with grant option
/
create or replace view DBA_SYNONYMS
    (OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME, DB_LINK)
as select u.name, o.name, s.owner, s.name, s.node
from sys.user$ u, sys.syn$ s, sys.obj$ o
where o.obj# = s.obj#
  and o.type = 5
  and o.owner# = u.user#
/
drop public synonym DBA_SYNONYMS
/
create public synonym DBA_SYNONYMS for DBA_SYNONYMS
/
comment on table DBA_SYNONYMS is
'All synonyms in the database'
/
comment on column DBA_SYNONYMS.OWNER is
'Username of the owner of the synonym'
/
comment on column DBA_SYNONYMS.SYNONYM_NAME is
'Name of the synonym'
/
comment on column DBA_SYNONYMS.TABLE_OWNER is
'Owner of the object referenced by the synonym'
/
comment on column DBA_SYNONYMS.TABLE_NAME is
'Name of the object referenced by the synonym'
/
comment on column DBA_SYNONYMS.DB_LINK is
'Name of the database link referenced in a remote synonym'
/
remark
remark  FAMILY "TABLES"
remark  CREATE TABLE parameters.
remark
create or replace view USER_TABLES
    (TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME,
     PCT_FREE, PCT_USED,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     FREELISTS, FREELIST_GROUPS,
     BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
     AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN,
     DEGREE, INSTANCES, CACHE, TABLE_LOCK)
as
select o.name, ts.name, co.name,
       mod(t.pctfree$, 100), t.pctused$,
       t.initrans, t.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
       s.minexts, s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups),
       decode(bitand(t.modified,1), 0, 'Y', 1, 'N', '?'),
       t.rowcnt, t.blkcnt, t.empcnt, t.avgspc, t.chncnt, t.avgrln,
       lpad(decode(t.spare1, 0, '1', 1, 'DEFAULT', to_char(t.spare1)), 10),
       lpad(decode(mod(t.spare2, 65536), 0, '1', 1, 'DEFAULT',
       to_char(mod(t.spare2, 65536))), 10),
       lpad(decode(floor(t.spare2 / 65536), 0, 'N', 1, 'Y', '?'), 5),
       decode(bitand(t.modified, 6), 0, 'ENABLED', 'DISABLED')       
from sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o
where o.owner# = userenv('SCHEMAID')
  and o.obj# = t.obj#
  and t.clu# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
/
comment on table USER_TABLES is
'Description of the user''s own tables'
/
comment on column USER_TABLES.TABLE_NAME is
'Name of the table'
/
comment on column USER_TABLES.TABLESPACE_NAME is
'Name of the tablespace containing the table'
/
comment on column USER_TABLES.CLUSTER_NAME is
'Name of the cluster, if any, to which the table belongs'
/
comment on column USER_TABLES.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column USER_TABLES.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column USER_TABLES.INI_TRANS is
'Initial number of transactions'
/
comment on column USER_TABLES.MAX_TRANS is
'Maximum number of transactions'
/
comment on column USER_TABLES.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column USER_TABLES.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column USER_TABLES.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column USER_TABLES.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column USER_TABLES.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column USER_TABLES.FREELISTS is
'Number of process freelists allocated in this segment'
/
comment on column USER_TABLES.FREELIST_GROUPS is
'Number of freelist groups allocated in this segment'
/
comment on column USER_TABLES.BACKED_UP is
'Has table been backed up since last modification?'
/
comment on column USER_TABLES.NUM_ROWS is
'The number of rows in the table'
/
comment on column USER_TABLES.BLOCKS is
'The number of used blocks in the table'
/
comment on column USER_TABLES.EMPTY_BLOCKS is
'The number of empty (never used) blocks in the table'
/
comment on column USER_TABLES.AVG_SPACE is
'The average available free space in the table'
/
comment on column USER_TABLES.CHAIN_CNT is
'The number of chained rows in the table'
/
comment on column USER_TABLES.AVG_ROW_LEN is
'The average row length, including row overhead'
/
comment on column USER_TABLES.DEGREE is
'The number of threads per instance for scanning the table'
/
comment on column USER_TABLES.INSTANCES is
'The number of instances across which the table is to be scanned'
/
comment on column USER_TABLES.CACHE is
'Whether the table is to be cached in the buffer cache'
/
comment on column USER_TABLES.TABLE_LOCK is
'Whether table locking is enabled or disabled'
/
drop public synonym USER_TABLES
/
create public synonym USER_TABLES for USER_TABLES
/
drop public synonym TABS
/
create public synonym TABS for USER_TABLES
/
grant select on USER_TABLES to PUBLIC with grant option
/
create or replace view ALL_TABLES
    (OWNER, TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME,
     PCT_FREE, PCT_USED,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     FREELISTS, FREELIST_GROUPS,
     BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
     AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN,
     DEGREE, INSTANCES, CACHE, TABLE_LOCK)
as
select u.name, o.name, ts.name, co.name,
       mod(t.pctfree$, 100), t.pctused$,
       t.initrans, t.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
       s.minexts, s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups),
       decode(bitand(t.modified,1), 0, 'Y', 1, 'N', '?'),
       t.rowcnt, t.blkcnt, t.empcnt, t.avgspc, t.chncnt, t.avgrln,
       lpad(decode(t.spare1, 0, '1', 1, 'DEFAULT', to_char(t.spare1)), 10),
       lpad(decode(mod(t.spare2, 65536), 0, '1', 1, 'DEFAULT',
       to_char(mod(t.spare2, 65536))), 10),
       lpad(decode(floor(t.spare2 / 65536), 0, 'N', 1, 'Y', '?'), 5),
       decode(bitand(t.modified, 6), 0, 'ENABLED', 'DISABLED')
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = t.obj#
  and t.clu# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               ) 
            )
       or /* user has system privileges */
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
      )
/
comment on table ALL_TABLES is
'Description of tables accessible to the user'
/
comment on column ALL_TABLES.OWNER is
'Owner of the table'
/
comment on column ALL_TABLES.TABLE_NAME is
'Name of the table'
/
comment on column ALL_TABLES.TABLESPACE_NAME is
'Name of the tablespace containing the table'
/
comment on column ALL_TABLES.CLUSTER_NAME is
'Name of the cluster, if any, to which the table belongs'
/
comment on column ALL_TABLES.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column ALL_TABLES.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column ALL_TABLES.INI_TRANS is
'Initial number of transactions'
/
comment on column ALL_TABLES.MAX_TRANS is
'Maximum number of transactions'
/
comment on column ALL_TABLES.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column ALL_TABLES.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column ALL_TABLES.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column ALL_TABLES.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column ALL_TABLES.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column ALL_TABLES.FREELISTS is
'Number of process freelists allocated in this segment'
/
comment on column ALL_TABLES.FREELIST_GROUPS is
'Number of freelist groups allocated in this segment'
/
comment on column ALL_TABLES.BACKED_UP is
'Has table been backed up since last modification?'
/
comment on column ALL_TABLES.NUM_ROWS is
'The number of rows in the table'
/
comment on column ALL_TABLES.BLOCKS is
'The number of used blocks in the table'
/
comment on column ALL_TABLES.EMPTY_BLOCKS is
'The number of empty (never used) blocks in the table'
/
comment on column ALL_TABLES.AVG_SPACE is
'The average available free space in the table'
/
comment on column ALL_TABLES.CHAIN_CNT is
'The number of chained rows in the table'
/
comment on column ALL_TABLES.AVG_ROW_LEN is
'The average row length, including row overhead'
/
comment on column ALL_TABLES.DEGREE is
'The number of threads per instance for scanning the table'
/
comment on column ALL_TABLES.INSTANCES is
'The number of instances across which the table is to be scanned'
/
comment on column ALL_TABLES.CACHE is
'Whether the table is to be cached in the buffer cache'
/
comment on column ALL_TABLES.TABLE_LOCK is
'Whether table locking is enabled or disabled'
/
drop public synonym ALL_TABLES
/
create public synonym ALL_TABLES for ALL_TABLES
/
grant select on ALL_TABLES to PUBLIC with grant option
/
create or replace view DBA_TABLES
    (OWNER, TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME,
     PCT_FREE, PCT_USED,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     FREELISTS, FREELIST_GROUPS,
     BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
     AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN,
     DEGREE, INSTANCES, CACHE, TABLE_LOCK)
as
select u.name, o.name, ts.name, co.name,
       mod(t.pctfree$, 100), t.pctused$,
       t.initrans, t.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
       s.minexts, s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups),
       decode(bitand(t.modified,1), 0, 'Y', 1, 'N', '?'),
       t.rowcnt, t.blkcnt, t.empcnt, t.avgspc, t.chncnt, t.avgrln,
       lpad(decode(t.spare1, 0, '1', 1, 'DEFAULT', to_char(t.spare1)), 10),
       lpad(decode(mod(t.spare2, 65536), 0, '1', 1, 'DEFAULT',
       to_char(mod(t.spare2, 65536))), 10),
       lpad(decode(floor(t.spare2 / 65536), 0, 'N', 1, 'Y', '?'), 5),
       decode(bitand(t.modified, 6), 0, 'ENABLED', 'DISABLED')
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = t.obj#
  and t.clu# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
/
drop public synonym DBA_TABLES
/
create public synonym DBA_TABLES for DBA_TABLES
/
comment on table DBA_TABLES is
'Description of all tables in the database'
/
comment on column DBA_TABLES.OWNER is
'Owner of the table'
/
comment on column DBA_TABLES.TABLE_NAME is
'Name of the table'
/
comment on column DBA_TABLES.TABLESPACE_NAME is
'Name of the tablespace containing the table'
/
comment on column DBA_TABLES.CLUSTER_NAME is
'Name of the cluster, if any, to which the table belongs'
/
comment on column DBA_TABLES.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column DBA_TABLES.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column DBA_TABLES.INI_TRANS is
'Initial number of transactions'
/
comment on column DBA_TABLES.MAX_TRANS is
'Maximum number of transactions'
/
comment on column DBA_TABLES.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column DBA_TABLES.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column DBA_TABLES.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column DBA_TABLES.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column DBA_TABLES.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column DBA_TABLES.FREELISTS is
'Number of process freelists allocated in this segment'
/
comment on column DBA_TABLES.FREELIST_GROUPS is
'Number of freelist groups allocated in this segment'
/
comment on column DBA_TABLES.BACKED_UP is
'Has table been backed up since last modification?'
/
comment on column DBA_TABLES.NUM_ROWS is
'The number of rows in the table'
/
comment on column DBA_TABLES.BLOCKS is
'The number of used blocks in the table'
/
comment on column DBA_TABLES.EMPTY_BLOCKS is
'The number of empty (never used) blocks in the table'
/
comment on column DBA_TABLES.AVG_SPACE is
'The average available free space in the table'
/
comment on column DBA_TABLES.CHAIN_CNT is
'The number of chained rows in the table'
/
comment on column DBA_TABLES.AVG_ROW_LEN is
'The average row length, including row overhead'
/
comment on column DBA_TABLES.DEGREE is
'The number of threads per instance for scanning the table'
/
comment on column DBA_TABLES.INSTANCES is
'The number of instances across which the table is to be scanned'
/
comment on column DBA_TABLES.CACHE is
'Whether the table is to be cached in the buffer cache'
/
comment on column DBA_TABLES.TABLE_LOCK is
'Whether table locking is enabled or disabled'
/
remark
remark  FAMILY "TABLESPACES"
remark  CREATE TABLESPACE parameters, except datafiles.
remark  This family has no ALL member.
remark
create or replace view USER_TABLESPACES
    (TABLESPACE_NAME, INITIAL_EXTENT, NEXT_EXTENT, MIN_EXTENTS,
     MAX_EXTENTS, PCT_INCREASE,
     STATUS, CONTENTS)
as select ts.name, ts.blocksize * ts.dflinit,
                   ts.blocksize * ts.dflincr,
                   ts.dflminext, ts.dflmaxext, ts.dflextpct,
          decode(mod(ts.online$, 65536), 1, 'ONLINE', 2, 'OFFLINE',
                 3, 'INVALID', 4, 'READ ONLY', 'UNDEFINED'),
          decode(floor(ts.online$ / 65536), 0, 'PERMANENT', 1, 'TEMPORARY')
from sys.ts$ ts
where exists (select null from sys.tsq$ tsq
              where tsq.ts# = ts.ts#
                and tsq.user# = userenv('SCHEMAID') and 
                (tsq.blocks > 0 or tsq.maxblocks != 0))
       or exists
          (select null
           from sys.v$enabledprivs
           where priv_number = -15 /* UNLIMITED TABLESPACE */)
/
comment on table USER_TABLESPACES is
'Description of accessible tablespaces'
/
comment on column USER_TABLESPACES.TABLESPACE_NAME is
'Tablespace name'
/
comment on column USER_TABLESPACES.INITIAL_EXTENT is
'Default initial extent size'
/
comment on column USER_TABLESPACES.NEXT_EXTENT is
'Default incremental extent size'
/
comment on column USER_TABLESPACES.MIN_EXTENTS is
'Default minimum number of extents'
/
comment on column USER_TABLESPACES.MAX_EXTENTS is
'Default maximum number of extents'
/
comment on column USER_TABLESPACES.PCT_INCREASE is
'Default percent increase for extent size'
/
comment on column USER_TABLESPACES.STATUS is
'Tablespace status: "ONLINE", "OFFLINE", or "READ ONLY"'
/
comment on column USER_TABLESPACES.CONTENTS is
'Tablespace contents: "PERMANENT", or "TEMPORARY"'
/
drop public synonym USER_TABLESPACES
/
create public synonym USER_TABLESPACES for USER_TABLESPACES
/
grant select on USER_TABLESPACES to PUBLIC with grant option
/
create or replace view DBA_TABLESPACES
    (TABLESPACE_NAME, INITIAL_EXTENT, NEXT_EXTENT, MIN_EXTENTS,
     MAX_EXTENTS, PCT_INCREASE,
     STATUS, CONTENTS)
as select ts.name, ts.blocksize * ts.dflinit,
          ts.blocksize * ts.dflincr, ts.dflminext,
          ts.dflmaxext, ts.dflextpct,
          decode(mod(ts.online$, 65536), 1, 'ONLINE', 2, 'OFFLINE',
                 4, 'READ ONLY', 'UNDEFINED'),
          decode(floor(ts.online$ / 65536), 0, 'PERMANENT', 1, 'TEMPORARY')
from sys.ts$ ts
where mod(ts.online$, 65536) != 3
/
drop public synonym DBA_TABLESPACES
/
create public synonym DBA_TABLESPACES for DBA_TABLESPACES
/
comment on table DBA_TABLESPACES is
'Description of all tablespaces'
/
comment on column DBA_TABLESPACES.TABLESPACE_NAME is
'Tablespace name'
/
comment on column DBA_TABLESPACES.INITIAL_EXTENT is
'Default initial extent size'
/
comment on column DBA_TABLESPACES.NEXT_EXTENT is
'Default incremental extent size'
/
comment on column DBA_TABLESPACES.MIN_EXTENTS is
'Default minimum number of extents'
/
comment on column DBA_TABLESPACES.MAX_EXTENTS is
'Default maximum number of extents'
/
comment on column DBA_TABLESPACES.PCT_INCREASE is
'Default percent increase for extent size'
/
comment on column DBA_TABLESPACES.STATUS is
'Tablespace status: "ONLINE", "OFFLINE", or "READ ONLY"'
/
comment on column DBA_TABLESPACES.CONTENTS is
'Tablespace contents: "PERMANENT", or "TEMPORARY"'
/
remark
remark  FAMILY "TAB_COLUMNS"
remark  The columns that make up objects:  Tables, Views, Clusters
remark  Includes information specified or implied by user in 
remark  CREATE/ALTER TABLE/VIEW/CLUSTER.
remark
create or replace view USER_TAB_COLUMNS
    (TABLE_NAME,
     COLUMN_NAME, DATA_TYPE,
     DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID,
     DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE,
     DENSITY, NUM_NULLS, NUM_BUCKETS, LAST_ANALYZED, SAMPLE_SIZE)
as
select o.name,
       c.name,
       decode(c.type#, 1, 'VARCHAR2',
                       2, decode(c.scale, null,
                                 decode(c.precision, null, 'NUMBER', 'FLOAT'),
                                 'NUMBER'),
                       8, 'LONG', 9, 'VARCHAR',
                       12, 'DATE', 23, 'RAW', 24, 'LONG RAW', 
                       69, 'ROWID',96,'CHAR', 105, 'MLSLABEL',
                       106, 'MLSLABEL', 'UNDEFINED'),
       c.length, c.precision, c.scale,
       decode(sign(c.null$),-1,'D', 0, 'Y', 'N'), c.col#, c.deflength, 
       c.default$, c.distcnt, c.lowval, c.hival, c.spare2, h.null_cnt,
       decode(h.row_cnt, 0, 1, 1, 1, h.row_cnt-1), h.timestamp, h.sample_size
from sys.col$ c, sys.obj$ o, sys.hist_head$ h
where o.obj# = c.obj#
  and o.owner# = userenv('SCHEMAID')
  and c.obj# = h.obj#(+) and c.col# = h.col#(+)
  and o.type in (2, 3, 4)
/
comment on table USER_TAB_COLUMNS is
'Columns of user''s tables, views and clusters'
/
comment on column USER_TAB_COLUMNS.TABLE_NAME is
'Table, view or cluster name'
/
comment on column USER_TAB_COLUMNS.COLUMN_NAME is
'Column name'
/
comment on column USER_TAB_COLUMNS.DATA_LENGTH is
'Length of the column in bytes'
/
comment on column USER_TAB_COLUMNS.DATA_TYPE is
'Datatype of the column'
/
comment on column USER_TAB_COLUMNS.DATA_PRECISION is
'Length: decimal digits (NUMBER) or binary digits (FLOAT)'
/
comment on column USER_TAB_COLUMNS.DATA_SCALE is
'Digits to right of decimal point in a number'
/
comment on column USER_TAB_COLUMNS.NULLABLE is
'Does column allow NULL values?'
/
comment on column USER_TAB_COLUMNS.COLUMN_ID is
'Sequence number of the column as created'
/
comment on column USER_TAB_COLUMNS.DEFAULT_LENGTH is
'Length of default value for the column'
/
comment on column USER_TAB_COLUMNS.DATA_DEFAULT is
'Default value for the column'
/
comment on column USER_TAB_COLUMNS.NUM_DISTINCT is
'The number of distinct values in the column'
/
comment on column USER_TAB_COLUMNS.LOW_VALUE is
'The low value in the column'
/
comment on column USER_TAB_COLUMNS.HIGH_VALUE is
'The high value in the column'
/
comment on column USER_TAB_COLUMNS.DENSITY is
'The density of the column'
/
comment on column USER_TAB_COLUMNS.NUM_NULLS is
'The number of nulls in the column'
/
comment on column USER_TAB_COLUMNS.NUM_BUCKETS is
'The number of buckets in histogram for the column'
/
comment on column USER_TAB_COLUMNS.LAST_ANALYZED is
'The date of the most recent time this column was analyzed'
/
comment on column USER_TAB_COLUMNS.SAMPLE_SIZE is
'The sample size used in analyzing this column'
/
drop public synonym USER_TAB_COLUMNS
/
create public synonym USER_TAB_COLUMNS for USER_TAB_COLUMNS
/
drop public synonym COLS
/
create public synonym COLS for USER_TAB_COLUMNS
/
grant select on USER_TAB_COLUMNS to PUBLIC with grant option
/
create or replace view ALL_TAB_COLUMNS
    (OWNER, TABLE_NAME,
     COLUMN_NAME, DATA_TYPE,
     DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID,
     DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE,
     DENSITY, NUM_NULLS, NUM_BUCKETS, LAST_ANALYZED, SAMPLE_SIZE)
as
select u.name, o.name,
       c.name,
       decode(c.type#, 1, 'VARCHAR2',
                       2, decode(c.scale, null,
                                 decode(c.precision, null, 'NUMBER', 'FLOAT'),
                                 'NUMBER'),
                       8, 'LONG', 9, 'VARCHAR',
                       12, 'DATE', 23, 'RAW', 24, 'LONG RAW',
                       69, 'ROWID',96,'CHAR', 105, 'MLSLABEL',
                       106, 'MLSLABEL', 'UNDEFINED'),
       c.length, c.precision, c.scale,
       decode(sign(c.null$),-1,'D', 0, 'Y', 'N'), c.col#, c.deflength, 
       c.default$, c.distcnt, c.lowval, c.hival, c.spare2, h.null_cnt,
       decode(h.row_cnt, 0, 1, 1, 1, h.row_cnt-1), h.timestamp, h.sample_size
from sys.col$ c, sys.obj$ o, sys.hist_head$ h, sys.user$ u
where o.obj# = c.obj#
  and o.owner# = u.user#
  and c.obj# = h.obj#(+) and c.col# = h.col#(+)
  and o.type in (2, 3, 4)
  and (o.owner# = userenv('SCHEMAID')
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
	or /* user has system privileges */
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
       )
/
comment on table ALL_TAB_COLUMNS is
'Columns of user''s tables, views and clusters'
/
comment on column ALL_TAB_COLUMNS.TABLE_NAME is
'Table, view or cluster name'
/
comment on column ALL_TAB_COLUMNS.COLUMN_NAME is
'Column name'
/
comment on column ALL_TAB_COLUMNS.DATA_LENGTH is
'Length of the column in bytes'
/
comment on column ALL_TAB_COLUMNS.DATA_TYPE is
'Datatype of the column'
/
comment on column ALL_TAB_COLUMNS.DATA_PRECISION is
'Length: decimal digits (NUMBER) or binary digits (FLOAT)'
/
comment on column ALL_TAB_COLUMNS.DATA_SCALE is
'Digits to right of decimal point in a number'
/
comment on column ALL_TAB_COLUMNS.NULLABLE is
'Does column allow NULL values?'
/
comment on column ALL_TAB_COLUMNS.COLUMN_ID is
'Sequence number of the column as created'
/
comment on column ALL_TAB_COLUMNS.DEFAULT_LENGTH is
'Length of default value for the column'
/
comment on column ALL_TAB_COLUMNS.DATA_DEFAULT is
'Default value for the column'
/
comment on column ALL_TAB_COLUMNS.NUM_DISTINCT is
'The number of distinct values in the column'
/
comment on column ALL_TAB_COLUMNS.LOW_VALUE is
'The low value in the column'
/
comment on column ALL_TAB_COLUMNS.HIGH_VALUE is
'The high value in the column'
/
comment on column ALL_TAB_COLUMNS.DENSITY is
'The density of the column'
/
comment on column ALL_TAB_COLUMNS.NUM_NULLS is
'The number of nulls in the column'
/
comment on column ALL_TAB_COLUMNS.NUM_BUCKETS is
'The number of buckets in histogram for the column'
/
comment on column ALL_TAB_COLUMNS.LAST_ANALYZED is
'The date of the most recent time this column was analyzed'
/
comment on column ALL_TAB_COLUMNS.SAMPLE_SIZE is
'The sample size used in analyzing this column'
/
drop public synonym ALL_TAB_COLUMNS
/
create public synonym ALL_TAB_COLUMNS for ALL_TAB_COLUMNS
/
grant select on ALL_TAB_COLUMNS to PUBLIC with grant option
/
create or replace view DBA_TAB_COLUMNS
    (OWNER, TABLE_NAME,
     COLUMN_NAME, DATA_TYPE,
     DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID,
     DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE,
     DENSITY, NUM_NULLS, NUM_BUCKETS, LAST_ANALYZED, SAMPLE_SIZE)
as
select u.name, o.name,
       c.name,
       decode(c.type#, 1, 'VARCHAR2',
                       2, decode(c.scale, null,
                                 decode(c.precision, null, 'NUMBER', 'FLOAT'),
                                 'NUMBER'),
                       8, 'LONG', 9, 'VARCHAR',
                       12, 'DATE', 23, 'RAW', 24, 'LONG RAW', 
                       69, 'ROWID',96,'CHAR', 105, 'MLSLABEL',
                       106, 'MLSLABEL', 'UNDEFINED'),
       c.length, c.precision, c.scale,
       decode(sign(c.null$),-1,'D', 0, 'Y', 'N'), c.col#, c.deflength, 
       c.default$, c.distcnt, c.lowval, c.hival, c.spare2, h.null_cnt,
       decode(h.row_cnt, 0, 1, 1, 1, h.row_cnt-1), h.timestamp, h.sample_size
from sys.col$ c, sys.obj$ o, sys.hist_head$ h, sys.user$ u
where o.obj# = c.obj#
  and o.owner# = u.user#
  and c.obj# = h.obj#(+) and c.col# = h.col#(+)
  and o.type in (2, 3, 4)
/
comment on table DBA_TAB_COLUMNS is
'Columns of user''s tables, views and clusters'
/
comment on column DBA_TAB_COLUMNS.TABLE_NAME is
'Table, view or cluster name'
/
comment on column DBA_TAB_COLUMNS.COLUMN_NAME is
'Column name'
/
comment on column DBA_TAB_COLUMNS.DATA_LENGTH is
'Length of the column in bytes'
/
comment on column DBA_TAB_COLUMNS.DATA_TYPE is
'Datatype of the column'
/
comment on column DBA_TAB_COLUMNS.DATA_PRECISION is
'Length: decimal digits (NUMBER) or binary digits (FLOAT)'
/
comment on column DBA_TAB_COLUMNS.DATA_SCALE is
'Digits to right of decimal point in a number'
/
comment on column DBA_TAB_COLUMNS.NULLABLE is
'Does column allow NULL values?'
/
comment on column DBA_TAB_COLUMNS.COLUMN_ID is
'Sequence number of the column as created'
/
comment on column DBA_TAB_COLUMNS.DEFAULT_LENGTH is
'Length of default value for the column'
/
comment on column DBA_TAB_COLUMNS.DATA_DEFAULT is
'Default value for the column'
/
comment on column DBA_TAB_COLUMNS.NUM_DISTINCT is
'The number of distinct values in the column'
/
comment on column DBA_TAB_COLUMNS.LOW_VALUE is
'The low value in the column'
/
comment on column DBA_TAB_COLUMNS.HIGH_VALUE is
'The high value in the column'
/
comment on column DBA_TAB_COLUMNS.DENSITY is
'The density of the column'
/
comment on column DBA_TAB_COLUMNS.NUM_NULLS is
'The number of nulls in the column'
/
comment on column DBA_TAB_COLUMNS.NUM_BUCKETS is
'The number of buckets in histogram for the column'
/
comment on column DBA_TAB_COLUMNS.LAST_ANALYZED is
'The date of the most recent time this column was analyzed'
/
comment on column DBA_TAB_COLUMNS.SAMPLE_SIZE is
'The sample size used in analyzing this column'
/
drop public synonym DBA_TAB_COLUMNS
/
create public synonym DBA_TAB_COLUMNS for DBA_TAB_COLUMNS
/
remark
remark  FAMILY "HISTOGRAMS"
remark  The histograms (part of the statistics used by the cost-based
remark    optimizer) on columns.
remark  The TAB_COLUMNS contain general information about 
remark    each histogram, including the number of buckets.
remark  These views contains that actual histogram data.
remark
create or replace view USER_HISTOGRAMS
    (TABLE_NAME, COLUMN_NAME, ENDPOINT_NUMBER, ENDPOINT_VALUE)
as
select o.name,
       c.name,
       h.bucket,
       h.endpoint
from sys.col$ c, sys.obj$ o, sys.histgrm$ h
where o.obj# = c.obj#
  and o.owner# = userenv('SCHEMAID')
  and c.obj# = h.obj# and c.col# = h.col#
  and o.type in (2, 3, 4)
union
select o.name,
       c.name,
       0,
       h.minimum
from sys.col$ c, sys.obj$ o, sys.hist_head$ h
where o.obj# = c.obj#
  and o.owner# = userenv('SCHEMAID')
  and c.obj# = h.obj# and c.col# = h.col#
  and o.type in (2, 3, 4)
  and h.bucket_cnt = 1
union
select o.name,
       c.name,
       1,
       h.maximum
from sys.col$ c, sys.obj$ o, sys.hist_head$ h
where o.obj# = c.obj#
  and o.owner# = userenv('SCHEMAID')
  and c.obj# = h.obj# and c.col# = h.col#
  and o.type in (2, 3, 4)
  and h.bucket_cnt = 1
/
comment on table USER_HISTOGRAMS is
'Histograms on columns of user''s tables'
/
comment on column USER_HISTOGRAMS.TABLE_NAME is
'Table name'
/
comment on column USER_HISTOGRAMS.COLUMN_NAME is
'Column name'
/
comment on column USER_HISTOGRAMS.ENDPOINT_NUMBER is
'Endpoint number'
/
comment on column USER_HISTOGRAMS.ENDPOINT_VALUE is
'Normalized endpoint value'
/
drop public synonym USER_HISTOGRAMS
/
create public synonym USER_HISTOGRAMS for USER_HISTOGRAMS
/
grant select on USER_HISTOGRAMS to PUBLIC with grant option
/
create or replace view ALL_HISTOGRAMS
    (OWNER, TABLE_NAME, COLUMN_NAME, ENDPOINT_NUMBER, ENDPOINT_VALUE)
as
select u.name,
       o.name,
       c.name,
       h.bucket,
       h.endpoint
from sys.col$ c, sys.obj$ o, sys.histgrm$ h, sys.user$ u
where o.obj# = c.obj#
  and (o.owner# = userenv('SCHEMAID')
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
	or /* user has system privileges */
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
       )
  and o.owner# = u.user#
  and c.obj# = h.obj# and c.col# = h.col#
  and o.type in (2, 3, 4)
union
select u.name,
       o.name,
       c.name,
       0,
       h.minimum
from sys.col$ c, sys.obj$ o, sys.hist_head$ h, sys.user$ u
where o.obj# = c.obj#
  and (o.owner# = userenv('SCHEMAID')
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
	or /* user has system privileges */
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
       )
  and o.owner# = u.user#
  and c.obj# = h.obj# and c.col# = h.col#
  and o.type in (2, 3, 4)
  and h.bucket_cnt = 1
union
select u.name,
       o.name,
       c.name,
       1,
       h.maximum
from sys.col$ c, sys.obj$ o, sys.hist_head$ h, sys.user$ u
where o.obj# = c.obj#
  and (o.owner# = userenv('SCHEMAID')
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
	or /* user has system privileges */
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
       )
  and o.owner# = u.user#
  and c.obj# = h.obj# and c.col# = h.col#
  and o.type in (2, 3, 4)
  and h.bucket_cnt = 1
/
comment on table ALL_HISTOGRAMS is
'Histograms on columns of all tables visible to user'
/
comment on column ALL_HISTOGRAMS.OWNER is
'Owner of table'
/
comment on column ALL_HISTOGRAMS.TABLE_NAME is
'Table name'
/
comment on column ALL_HISTOGRAMS.COLUMN_NAME is
'Column name'
/
comment on column ALL_HISTOGRAMS.ENDPOINT_NUMBER is
'Endpoint number'
/
comment on column ALL_HISTOGRAMS.ENDPOINT_VALUE is
'Normalized endpoint value'
/
drop public synonym ALL_HISTOGRAMS
/
create public synonym ALL_HISTOGRAMS for ALL_HISTOGRAMS
/
grant select on ALL_HISTOGRAMS to PUBLIC with grant option
/
create or replace view DBA_HISTOGRAMS
    (OWNER, TABLE_NAME, COLUMN_NAME, ENDPOINT_NUMBER, ENDPOINT_VALUE)
as
select u.name,
       o.name,
       c.name,
       h.bucket,
       h.endpoint
from sys.col$ c, sys.obj$ o, sys.histgrm$ h, sys.user$ u
where o.obj# = c.obj#
  and o.owner# = u.user#
  and c.obj# = h.obj# and c.col# = h.col#
  and o.type in (2, 3, 4)
union
select u.name,
       o.name,
       c.name,
       0,
       h.minimum
from sys.col$ c, sys.obj$ o, sys.hist_head$ h, sys.user$ u
where o.obj# = c.obj#
  and o.owner# = u.user#
  and c.obj# = h.obj# and c.col# = h.col#
  and o.type in (2, 3, 4)
  and h.bucket_cnt = 1
union
select u.name,
       o.name,
       c.name,
       1,
       h.maximum
from sys.col$ c, sys.obj$ o, sys.hist_head$ h, sys.user$ u
where o.obj# = c.obj#
  and o.owner# = u.user#
  and c.obj# = h.obj# and c.col# = h.col#
  and o.type in (2, 3, 4)
  and h.bucket_cnt = 1
/
comment on table DBA_HISTOGRAMS is
'Histograms on columns of all tables'
/
comment on column DBA_HISTOGRAMS.OWNER is
'Owner of table'
/
comment on column DBA_HISTOGRAMS.TABLE_NAME is
'Table name'
/
comment on column DBA_HISTOGRAMS.COLUMN_NAME is
'Column name'
/
comment on column DBA_HISTOGRAMS.ENDPOINT_NUMBER is
'Endpoint number'
/
comment on column DBA_HISTOGRAMS.ENDPOINT_VALUE is
'Normalized endpoint value'
/
drop public synonym DBA_HISTOGRAMS
/
create public synonym DBA_HISTOGRAMS for DBA_HISTOGRAMS
/
remark
remark  FAMILY "TAB_COMMENTS"
remark  Comments on objects.
remark
create or replace view USER_TAB_COMMENTS
    (TABLE_NAME,
     TABLE_TYPE,
     COMMENTS)
as
select o.name,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 'UNDEFINED'),
       c.comment$
from sys.obj$ o, sys.com$ c
where o.owner# = userenv('SCHEMAID')
  and o.type in (2, 4)
  and o.obj# = c.obj#(+)
  and c.col#(+) is null
/
comment on table USER_TAB_COMMENTS is
'Comments on the tables and views owned by the user'
/
comment on column USER_TAB_COMMENTS.TABLE_NAME is
'Name of the object'
/
comment on column USER_TAB_COMMENTS.TABLE_TYPE is
'Type of the object:  "TABLE" or "VIEW"'
/
comment on column USER_TAB_COMMENTS.COMMENTS is
'Comment on the object'
/
drop public synonym USER_TAB_COMMENTS
/
create public synonym USER_TAB_COMMENTS for USER_TAB_COMMENTS
/
grant select on USER_TAB_COMMENTS to PUBLIC with grant option
/
create or replace view ALL_TAB_COMMENTS
    (OWNER, TABLE_NAME,
     TABLE_TYPE,
     COMMENTS)
as
select u.name, o.name,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 'UNDEFINED'),
       c.comment$
from sys.obj$ o, sys.user$ u, sys.com$ c
where o.owner# = u.user#
  and o.obj# = c.obj#(+)
  and c.col#(+) is null
  and o.type in (2, 4)
  and (o.owner# = userenv('SCHEMAID')
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
	or /* user has system privileges */
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
       )
/
comment on table ALL_TAB_COMMENTS is
'Comments on tables and views accessible to the user'
/
comment on column ALL_TAB_COMMENTS.OWNER is
'Owner of the object'
/
comment on column ALL_TAB_COMMENTS.TABLE_NAME is
'Name of the object'
/
comment on column ALL_TAB_COMMENTS.TABLE_TYPE is
'Type of the object'
/
comment on column ALL_TAB_COMMENTS.COMMENTS is
'Comment on the object'
/
drop public synonym ALL_TAB_COMMENTS
/
create public synonym ALL_TAB_COMMENTS for ALL_TAB_COMMENTS
/
grant select on ALL_TAB_COMMENTS to PUBLIC with grant option
/
create or replace view DBA_TAB_COMMENTS
    (OWNER, TABLE_NAME,
     TABLE_TYPE,
     COMMENTS)
as
select u.name, o.name,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 'UNDEFINED'),
       c.comment$
from sys.obj$ o, sys.user$ u, sys.com$ c
where o.owner# = u.user#
  and o.type in (2, 4)
  and o.obj# = c.obj#(+)
  and c.col#(+) is null
/
drop public synonym DBA_TAB_COMMENTS
/
create public synonym DBA_TAB_COMMENTS for DBA_TAB_COMMENTS
/
comment on table DBA_TAB_COMMENTS is
'Comments on all tables and views in the database'
/
comment on column DBA_TAB_COMMENTS.OWNER is
'Owner of the object'
/
comment on column DBA_TAB_COMMENTS.TABLE_NAME is
'Name of the object'
/
comment on column DBA_TAB_COMMENTS.TABLE_TYPE is
'Type of the object'
/
comment on column DBA_TAB_COMMENTS.COMMENTS is
'Comment on the object'
/
remark
remark  FAMILY "TAB_PRIVS"
remark  Grants on objects.
remark
create or replace view USER_TAB_PRIVS
      (GRANTEE, OWNER, TABLE_NAME, GRANTOR, PRIVILEGE, GRANTABLE)
as
select ue.name, u.name, o.name, ur.name, tpm.name, 
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and oa.col# is null
  and u.user# = o.owner#
  and oa.privilege# = tpm.privilege
  and userenv('SCHEMAID') in (oa.grantor#, oa.grantee#, o.owner#)
/
comment on table USER_TAB_PRIVS is
'Grants on objects for which the user is the owner, grantor or grantee'
/
comment on column USER_TAB_PRIVS.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column USER_TAB_PRIVS.OWNER is
'Owner of the object'
/
comment on column USER_TAB_PRIVS.TABLE_NAME is
'Name of the object'
/
comment on column USER_TAB_PRIVS.GRANTOR is
'Name of the user who performed the grant'
/
comment on column USER_TAB_PRIVS.PRIVILEGE is
'Table Privilege'
/
comment on column USER_TAB_PRIVS.GRANTABLE is
'Privilege is grantable'
/
drop public synonym USER_TAB_PRIVS
/
create public synonym USER_TAB_PRIVS for USER_TAB_PRIVS
/
grant select on USER_TAB_PRIVS to PUBLIC with grant option
/
create or replace view ALL_TAB_PRIVS
      (GRANTOR, GRANTEE, TABLE_SCHEMA, TABLE_NAME, PRIVILEGE, GRANTABLE)
as
select ur.name, ue.name, u.name, o.name, tpm.name, 
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and oa.col# is null
  and u.user# = o.owner#
  and oa.privilege# = tpm.privilege
  and (oa.grantor# = userenv('SCHEMAID') or
       oa.grantee# in (select kzsrorol from x$kzsro) or
       o.owner# = userenv('SCHEMAID'))
/
comment on table ALL_TAB_PRIVS is
'Grants on objects for which the user is the grantor, grantee, owner, 
 or an enabled role or PUBLIC is the grantee'
/
comment on column ALL_TAB_PRIVS.GRANTOR is
'Name of the user who performed the grant'
/
comment on column ALL_TAB_PRIVS.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column ALL_TAB_PRIVS.TABLE_SCHEMA is
'Schema of the object'
/
comment on column ALL_TAB_PRIVS.TABLE_NAME is
'Name of the object'
/
comment on column ALL_TAB_PRIVS.PRIVILEGE is
'Table Privilege'
/
comment on column ALL_TAB_PRIVS.GRANTABLE is
'Privilege is grantable'
/
drop public synonym ALL_TAB_PRIVS
/
create public synonym ALL_TAB_PRIVS for ALL_TAB_PRIVS
/
grant select on ALL_TAB_PRIVS to PUBLIC with grant option
/
create or replace view DBA_TAB_PRIVS
      (GRANTEE, OWNER, TABLE_NAME, GRANTOR, PRIVILEGE, GRANTABLE)
as
select ue.name, u.name, o.name, ur.name, tpm.name,
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and oa.col# is null
  and oa.privilege# = tpm.privilege
  and u.user# = o.owner#
/
drop public synonym DBA_TAB_PRIVS
/
create public synonym DBA_TAB_PRIVS for DBA_TAB_PRIVS
/
comment on table DBA_TAB_PRIVS is
'All grants on objects in the database'
/
comment on column DBA_TAB_PRIVS.GRANTEE is
'User to whom access was granted'
/
comment on column DBA_TAB_PRIVS.OWNER is
'Owner of the object'
/
comment on column DBA_TAB_PRIVS.TABLE_NAME is
'Name of the object'
/
comment on column DBA_TAB_PRIVS.GRANTOR is
'Name of the user who performed the grant'
/
comment on column DBA_TAB_PRIVS.PRIVILEGE is
'Table Privilege'
/
comment on column DBA_TAB_PRIVS.GRANTABLE is
'Privilege is grantable'
/
remark
remark  FAMILY "TAB_PRIVS_MADE"
remark  Grants made on objects.
remark  This family has no DBA member.
remark
create or replace view USER_TAB_PRIVS_MADE
      (GRANTEE, TABLE_NAME, GRANTOR, PRIVILEGE, GRANTABLE)
as
select ue.name, o.name, ur.name, tpm.name, 
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ ue, sys.user$ ur,
     table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and oa.col# is null
  and oa.privilege# = tpm.privilege
  and o.owner# = userenv('SCHEMAID')
/
comment on table USER_TAB_PRIVS_MADE is
'All grants on objects owned by the user'
/
comment on column USER_TAB_PRIVS_MADE.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column USER_TAB_PRIVS_MADE.TABLE_NAME is
'Name of the object'
/
comment on column USER_TAB_PRIVS_MADE.GRANTOR is
'Name of the user who performed the grant'
/
comment on column USER_TAB_PRIVS_MADE.PRIVILEGE is
'Table Privilege'
/
comment on column USER_TAB_PRIVS_MADE.GRANTABLE is
'Privilege is grantable'
/
drop public synonym USER_TAB_PRIVS_MADE
/
create public synonym USER_TAB_PRIVS_MADE for USER_TAB_PRIVS_MADE
/
grant select on USER_TAB_PRIVS_MADE to PUBLIC with grant option
/
create or replace view ALL_TAB_PRIVS_MADE
      (GRANTEE, OWNER, TABLE_NAME, GRANTOR, PRIVILEGE, GRANTABLE)
as
select ue.name, u.name, o.name, ur.name, tpm.name, 
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and oa.col# is null
  and oa.privilege# = tpm.privilege
  and userenv('SCHEMAID') in (o.owner#, oa.grantor#)
/
comment on table ALL_TAB_PRIVS_MADE is
'User''s grants and grants on user''s objects'
/
comment on column ALL_TAB_PRIVS_MADE.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column ALL_TAB_PRIVS_MADE.OWNER is
'Owner of the object'
/
comment on column ALL_TAB_PRIVS_MADE.TABLE_NAME is
'Name of the object'
/
comment on column ALL_TAB_PRIVS_MADE.GRANTOR is
'Name of the user who performed the grant'
/
comment on column ALL_TAB_PRIVS_MADE.PRIVILEGE is
'Table Privilege'
/
comment on column ALL_TAB_PRIVS_MADE.GRANTABLE is
'Privilege is grantable'
/
drop public synonym ALL_TAB_PRIVS_MADE
/
create public synonym ALL_TAB_PRIVS_MADE for ALL_TAB_PRIVS_MADE
/
grant select on ALL_TAB_PRIVS_MADE to PUBLIC with grant option
/
remark
remark  FAMILY "TAB_PRIVS_RECD"
remark  Grants received on objects.
remark  This family has no DBA member.
remark
create or replace view USER_TAB_PRIVS_RECD
      (OWNER, TABLE_NAME, GRANTOR, PRIVILEGE, GRANTABLE)
as
select u.name, o.name, ur.name, tpm.name, 
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, 
     table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and u.user# = o.owner#
  and oa.col# is null
  and oa.privilege# = tpm.privilege
  and oa.grantee# = userenv('SCHEMAID')
/
comment on table USER_TAB_PRIVS_RECD is
'Grants on objects for which the user is the grantee'
/
comment on column USER_TAB_PRIVS_RECD.OWNER is
'Owner of the object'
/
comment on column USER_TAB_PRIVS_RECD.TABLE_NAME is
'Name of the object'
/
comment on column USER_TAB_PRIVS_RECD.GRANTOR is
'Name of the user who performed the grant'
/
comment on column USER_TAB_PRIVS_RECD.PRIVILEGE is
'Table Privilege'
/
comment on column USER_TAB_PRIVS_RECD.GRANTABLE is
'Privilege is grantable'
/
drop public synonym USER_TAB_PRIVS_RECD
/
create public synonym USER_TAB_PRIVS_RECD for USER_TAB_PRIVS_RECD
/
grant select on USER_TAB_PRIVS_RECD to PUBLIC with grant option
/
create or replace view ALL_TAB_PRIVS_RECD
      (GRANTEE, OWNER, TABLE_NAME, GRANTOR, PRIVILEGE, GRANTABLE)
as
select ue.name, u.name, o.name, ur.name, tpm.name, 
       decode(oa.option$, 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and oa.col# is null
  and oa.privilege# = tpm.privilege
  and oa.grantee# in (select kzsrorol from x$kzsro)
/
comment on table ALL_TAB_PRIVS_RECD is
'Grants on objects for which the user, PUBLIC or enabled role is the grantee'
/
comment on column ALL_TAB_PRIVS_RECD.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column ALL_TAB_PRIVS_RECD.OWNER is
'Owner of the object'
/
comment on column ALL_TAB_PRIVS_RECD.TABLE_NAME is
'Name of the object'
/
comment on column ALL_TAB_PRIVS_RECD.GRANTOR is
'Name of the user who performed the grant'
/
comment on column ALL_TAB_PRIVS_RECD.PRIVILEGE is
'Table Privilege'
/
comment on column ALL_TAB_PRIVS_RECD.GRANTABLE is
'Privilege is grantable'
/
drop public synonym ALL_TAB_PRIVS_RECD
/
create public synonym ALL_TAB_PRIVS_RECD for ALL_TAB_PRIVS_RECD
/
grant select on ALL_TAB_PRIVS_RECD to PUBLIC with grant option
/
remark
remark  FAMILY "TS_QUOTAS"
remark  Tablespace quotas for users.
remark  This family has no ALL member.
remark
create or replace view USER_TS_QUOTAS
    (TABLESPACE_NAME, BYTES, MAX_BYTES, BLOCKS, MAX_BLOCKS)
as
select ts.name, q.blocks * ts.blocksize,
       decode(q.maxblocks, -1, -1, q.maxblocks * ts.blocksize),
       q.blocks, q.maxblocks
from sys.tsq$ q, sys.ts$ ts
where q.ts# = ts.ts#
  and q.user# = userenv('SCHEMAID')
/
comment on table USER_TS_QUOTAS is
'Tablespace quotas for the user'
/
comment on column USER_TS_QUOTAS.TABLESPACE_NAME is
'Tablespace name'
/
comment on column USER_TS_QUOTAS.BLOCKS is
'Number of ORACLE blocks charged to the user'
/
comment on column USER_TS_QUOTAS.MAX_BLOCKS is
'User''s quota in ORACLE blocks.  NULL if no limit'
/
comment on column USER_TS_QUOTAS.BYTES is
'Number of bytes charged to the user'
/
comment on column USER_TS_QUOTAS.MAX_BYTES is
'User''s quota in bytes.  NULL if no limit'
/
drop public synonym USER_TS_QUOTAS
/
create public synonym USER_TS_QUOTAS for USER_TS_QUOTAS
/
grant select on USER_TS_QUOTAS to PUBLIC with grant option
/
create or replace view DBA_TS_QUOTAS
    (TABLESPACE_NAME, USERNAME, BYTES, MAX_BYTES, BLOCKS, MAX_BLOCKS)
as
select ts.name, u.name, 
       q.blocks * ts.blocksize, 
       decode(q.maxblocks, -1, -1, q.maxblocks * ts.blocksize),
       q.blocks, q.maxblocks
from sys.tsq$ q, sys.ts$ ts, sys.user$ u
where q.ts# = ts.ts#
  and q.user# = u.user#
  and q.maxblocks != 0
/
drop public synonym DBA_TS_QUOTAS
/
create public synonym DBA_TS_QUOTAS for DBA_TS_QUOTAS
/
comment on table DBA_TS_QUOTAS is
'Tablespace quotas for all users'
/
comment on column DBA_TS_QUOTAS.TABLESPACE_NAME is
'Tablespace name'
/
comment on column DBA_TS_QUOTAS.USERNAME is
'User with resource rights on the tablespace'
/
comment on column DBA_TS_QUOTAS.BLOCKS is
'Number of ORACLE blocks charged to the user'
/
comment on column DBA_TS_QUOTAS.MAX_BLOCKS is
'User''s quota in ORACLE blocks.  NULL if no limit'
/
comment on column DBA_TS_QUOTAS.BYTES is
'Number of bytes charged to the user'
/
comment on column DBA_TS_QUOTAS.MAX_BYTES is
'User''s quota in bytes.  NULL if no limit'
/
remark
remark  FAMILY "USERS"
remark  Users enrolled in the database.
remark
create or replace view USER_USERS
    (USERNAME, USER_ID,
     DEFAULT_TABLESPACE, TEMPORARY_TABLESPACE, CREATED)
as
select u.name, u.user#,
       dts.name, tts.name, u.ctime
from sys.user$ u, sys.ts$ dts, sys.ts$ tts
where u.datats# = dts.ts#
  and u.tempts# = tts.ts#
  and u.type = 1
  and u.user# = userenv('SCHEMAID')
/
comment on table USER_USERS is
'Information about the current user'
/
comment on column USER_USERS.USERNAME is
'Name of the user'
/
comment on column USER_USERS.USER_ID is
'ID number of the user'
/
comment on column USER_USERS.DEFAULT_TABLESPACE is
'Default tablespace for data'
/
comment on column USER_USERS.TEMPORARY_TABLESPACE is
'Default tablespace for temporary tables'
/
comment on column USER_USERS.CREATED is
'User creation date'
/
drop public synonym USER_USERS
/
create public synonym USER_USERS for USER_USERS
/
grant select on USER_USERS to PUBLIC with grant option
/
create or replace view ALL_USERS
    (USERNAME, USER_ID, CREATED)
as
select u.name, u.user#, u.ctime
from sys.user$ u, sys.ts$ dts, sys.ts$ tts
where u.datats# = dts.ts#
  and u.tempts# = tts.ts#
  and u.type = 1
/
comment on table ALL_USERS is
'Information about all users of the database'
/
comment on column ALL_USERS.USERNAME is
'Name of the user'
/
comment on column ALL_USERS.USER_ID is
'ID number of the user'
/
comment on column ALL_USERS.CREATED is
'User creation date'
/
drop public synonym ALL_USERS
/
create public synonym ALL_USERS for ALL_USERS
/
grant select on ALL_USERS to PUBLIC with grant option
/
create or replace view DBA_USERS
    (USERNAME, USER_ID, PASSWORD,
     DEFAULT_TABLESPACE, TEMPORARY_TABLESPACE, CREATED, PROFILE)
as
select u.name, u.user#, u.password,
       dts.name, tts.name, u.ctime, p.name
from sys.user$ u, sys.ts$ dts, sys.ts$ tts, sys.profname$ p
where u.datats# = dts.ts#
  and u.resource$ = p.profile#
  and u.tempts# = tts.ts#
  and u.type = 1
/
drop public synonym DBA_USERS
/
create public synonym DBA_USERS for DBA_USERS
/
comment on table DBA_USERS is
'Information about all users of the database'
/
comment on column DBA_USERS.USERNAME is
'Name of the user'
/
comment on column DBA_USERS.USER_ID is
'ID number of the user'
/
comment on column DBA_USERS.PASSWORD is
'Encrypted password'
/
comment on column DBA_USERS.DEFAULT_TABLESPACE is
'Default tablespace for data'
/
comment on column DBA_USERS.TEMPORARY_TABLESPACE is
'Default tablespace for temporary tables'
/
comment on column DBA_USERS.CREATED is
'User creation date'
/
comment on column DBA_USERS.PROFILE is
'User resource profile name'
/
remark
remark  FAMILY "VIEWS"
remark  All relevant information about views, except columns.
remark
create or replace view USER_VIEWS
    (VIEW_NAME, TEXT_LENGTH, TEXT)
as
select o.name, v.textlength, v.text
from sys.obj$ o, sys.view$ v
where o.obj# = v.obj#
  and o.owner# = userenv('SCHEMAID')
/
comment on table USER_VIEWS is
'Text of views owned by the user'
/
comment on column USER_VIEWS.VIEW_NAME is
'Name of the view'
/
comment on column USER_VIEWS.TEXT_LENGTH is
'Length of the view text'
/
comment on column USER_VIEWS.TEXT is
'View text'
/
drop public synonym USER_VIEWS
/
create public synonym USER_VIEWS for USER_VIEWS
/
grant select on USER_VIEWS to PUBLIC with grant option
/
create or replace view ALL_VIEWS
    (OWNER, VIEW_NAME, TEXT_LENGTH, TEXT)
as
select u.name, o.name, v.textlength, v.text
from sys.obj$ o, sys.view$ v, sys.user$ u
where o.obj# = v.obj#
  and o.owner# = u.user#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where oa.grantee# in ( select kzsrorol
                                         from x$kzsro
                                  )
            )
	or /* user has system privileges */
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
      )
/
comment on table ALL_VIEWS is
'Text of views accessible to the user'
/
comment on column ALL_VIEWS.OWNER is
'Owner of the view'
/
comment on column ALL_VIEWS.VIEW_NAME is
'Name of the view'
/
comment on column ALL_VIEWS.TEXT_LENGTH is
'Length of the view text'
/
comment on column ALL_VIEWS.TEXT is
'View text'
/
drop public synonym ALL_VIEWS
/
create public synonym ALL_VIEWS for ALL_VIEWS
/
grant select on ALL_VIEWS to PUBLIC with grant option
/
create or replace view DBA_VIEWS
    (OWNER, VIEW_NAME, TEXT_LENGTH, TEXT)
as
select u.name, o.name, v.textlength, v.text
from sys.obj$ o, sys.view$ v, sys.user$ u
where o.obj# = v.obj#
  and o.owner# = u.user#
/
drop public synonym DBA_VIEWS
/
create public synonym DBA_VIEWS for DBA_VIEWS
/
comment on table DBA_VIEWS is
'Text of all views in the database'
/
comment on column DBA_VIEWS.OWNER is
'Owner of the view'
/
comment on column DBA_VIEWS.VIEW_NAME is
'Name of the view'
/
comment on column DBA_VIEWS.TEXT_LENGTH is
'Length of the view text'
/
comment on column DBA_VIEWS.TEXT is
'View text'
/
remark
remark  FAMILY "CONSTRAINTS"
remark
create or replace view USER_CONSTRAINTS 
    (OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE,
     TABLE_NAME, SEARCH_CONDITION, R_OWNER,
     R_CONSTRAINT_NAME, DELETE_RULE, STATUS)
as
select ou.name, oc.name,
       decode(c.type, 1, 'C', 2, 'P', 3, 'U',
              4, 'R', 5, 'V',7,'C', '?'),
       o.name, c.condition, ru.name, rc.name, 
       decode(c.type, 4,
              decode(c.refact, 1, 'CASCADE', 'NO ACTION'), NULL),
       decode(c.type, 5, 'ENABLED',
              decode(c.enabled, NULL, 'DISABLED','ENABLED'))
from sys.con$ oc, sys.con$ rc, sys.user$ ou, sys.user$ ru,
     sys.obj$ o, sys.cdef$ c
where oc.owner# = ou.user#
  and oc.con# = c.con#
  and c.obj# = o.obj#
  and c.rcon# = rc.con#(+)
  and rc.owner# = ru.user#(+)
  and o.owner# = userenv('SCHEMAID')
  and c.type  != 8;
/
comment on table USER_CONSTRAINTS is
'Constraint definitions on user''s own tables'
/
comment on column USER_CONSTRAINTS.OWNER is
'Owner of the table'
/
comment on column USER_CONSTRAINTS.CONSTRAINT_NAME is
'Name associated with constraint definition'
/
comment on column USER_CONSTRAINTS.CONSTRAINT_TYPE is
'Type of constraint definition'
/
comment on column USER_CONSTRAINTS.TABLE_NAME is
'Name associated with table with constraint definition'
/
comment on column USER_CONSTRAINTS.SEARCH_CONDITION is
'Text of search condition for table check'
/
comment on column USER_CONSTRAINTS.R_OWNER is
'Owner of table used in referential constraint'
/
comment on column USER_CONSTRAINTS.R_CONSTRAINT_NAME is
'Name of unique constraint definition for referenced table'
/
comment on column USER_CONSTRAINTS.DELETE_RULE is
'The delete rule for a referential constraint'
/
comment on column USER_CONSTRAINTS.STATUS is
'enforcement status of constraint -  ENABLED or DISABLED'
/
grant select on USER_CONSTRAINTS to public with grant option
/
drop public synonym USER_CONSTRAINTS
/
create public synonym USER_CONSTRAINTS for USER_CONSTRAINTS
/
create or replace view ALL_CONSTRAINTS 
    (OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE,
     TABLE_NAME, SEARCH_CONDITION, R_OWNER,
     R_CONSTRAINT_NAME, DELETE_RULE, STATUS)
as
select ou.name, oc.name,
       decode(c.type, 1, 'C', 2, 'P', 3, 'U',
              4, 'R', 5, 'V',7,'C', '?'),
       o.name, c.condition, ru.name, rc.name,
       decode(c.type, 4,
              decode(c.refact, 1, 'CASCADE', 'NO ACTION'), NULL),
       decode(c.type, 5, 'ENABLED',
              decode(c.enabled, NULL, 'DISABLED','ENABLED'))
from sys.con$ oc, sys.con$ rc, sys.user$ ou, sys.user$ ru,
     sys.obj$ o, sys.cdef$ c
where oc.owner# = ou.user#
  and oc.con# = c.con#
  and c.obj# = o.obj#
  and c.type != 8
  and c.rcon# = rc.con#(+)
  and rc.owner# = ru.user#(+)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in (select obj#
                     from sys.objauth$
                     where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                    )
	or /* user has system privileges */
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50             /* DELETE ANY TABLE */)
		  )
      )
/
comment on table ALL_CONSTRAINTS is
'Constraint definitions on accessible tables'
/
comment on column ALL_CONSTRAINTS.OWNER is
'Owner of the table'
/
comment on column ALL_CONSTRAINTS.CONSTRAINT_NAME is
'Name associated with constraint definition'
/
comment on column ALL_CONSTRAINTS.CONSTRAINT_TYPE is
'Type of constraint definition'
/
comment on column ALL_CONSTRAINTS.TABLE_NAME is
'Name associated with table with constraint definition'
/
comment on column ALL_CONSTRAINTS.SEARCH_CONDITION is
'Text of search condition for table check'
/
comment on column ALL_CONSTRAINTS.R_OWNER is
'Owner of table used in referential constraint'
/
comment on column ALL_CONSTRAINTS.R_CONSTRAINT_NAME is
'Name of unique constraint definition for referenced table'
/
comment on column ALL_CONSTRAINTS.DELETE_RULE is
'The delete rule for a referential constraint'
/
comment on column ALL_CONSTRAINTS.STATUS is
'enforcement status of constraint - ENABLED or DISABLED'
/
grant select on ALL_CONSTRAINTS to public with grant option
/
drop public synonym ALL_CONSTRAINTS
/
create public synonym ALL_CONSTRAINTS for ALL_CONSTRAINTS
/
create or replace view DBA_CONSTRAINTS 
    (OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE,
     TABLE_NAME, SEARCH_CONDITION, R_OWNER,
     R_CONSTRAINT_NAME, DELETE_RULE, STATUS)
as
select ou.name, oc.name,
       decode(c.type, 1, 'C', 2, 'P', 3, 'U',
              4, 'R', 5, 'V',7,'C', '?'),
       o.name, c.condition, ru.name, rc.name, 
       decode(c.type, 4,
              decode(c.refact, 1, 'CASCADE', 'NO ACTION'), NULL),
       decode(c.type, 5, 'ENABLED',
              decode(c.enabled, NULL, 'DISABLED','ENABLED'))
from sys.con$ oc, sys.con$ rc, sys.user$ ou, sys.user$ ru,
     sys.obj$ o, sys.cdef$ c
where oc.owner# = ou.user#
  and oc.con# = c.con#
  and c.obj# = o.obj#
  and c.type != 8        /* don't include hash expressions */
  and c.rcon# = rc.con#(+)
  and rc.owner# = ru.user#(+)
/
drop public synonym DBA_CONSTRAINTS
/
create public synonym DBA_CONSTRAINTS for DBA_CONSTRAINTS
/
comment on table DBA_CONSTRAINTS is
'Constraint definitions on all tables'
/
comment on column DBA_CONSTRAINTS.OWNER is
'Owner of the table'
/
comment on column DBA_CONSTRAINTS.CONSTRAINT_NAME is
'Name associated with constraint definition'
/
comment on column DBA_CONSTRAINTS.CONSTRAINT_TYPE is
'Type of constraint definition'
/
comment on column DBA_CONSTRAINTS.TABLE_NAME is
'Name associated with table with constraint definition'
/
comment on column DBA_CONSTRAINTS.SEARCH_CONDITION is
'Text of search condition for table check'
/
comment on column DBA_CONSTRAINTS.R_OWNER is
'Owner of table used in referential constraint'
/
comment on column DBA_CONSTRAINTS.R_CONSTRAINT_NAME is
'Name of unique constraint definition for referenced table'
/
comment on column DBA_CONSTRAINTS.DELETE_RULE is
'The delete rule for a referential constraint'
/
comment on column DBA_CONSTRAINTS.STATUS is
'enforcement status of constraint - ENABLED or DISABLED'
/

remark
remark FAMILY CLUSTER_HASH_EXPRESSIONS
remark 
create or replace view USER_CLUSTER_HASH_EXPRESSIONS
    (OWNER, CLUSTER_NAME, HASH_EXPRESSION)
as
select us.name, o.name, c.condition
from sys.cdef$ c, sys.user$ us, sys.obj$ o
where c.type   = 8
and   c.obj#   = o.obj#
and   us.user# = o.owner#
and   us.user# = userenv('SCHEMAID')
/

comment on table USER_CLUSTER_HASH_EXPRESSIONS is
'Hash functions for the user''s hash clusters'
/
comment on column USER_CLUSTER_HASH_EXPRESSIONS.OWNER is
'Name of owner of cluster'
/
comment on column USER_CLUSTER_HASH_EXPRESSIONS.CLUSTER_NAME is
'Name of cluster'
/
comment on column USER_CLUSTER_HASH_EXPRESSIONS.HASH_EXPRESSION is
'Text of hash function of cluster'
/
grant select on USER_CLUSTER_HASH_EXPRESSIONS to public with grant option
/
drop public synonym USER_CLUSTER_HASH_EXPRESSIONS
/
create public synonym USER_CLUSTER_HASH_EXPRESSIONS for
 USER_CLUSTER_HASH_EXPRESSIONS
/

create or replace view ALL_CLUSTER_HASH_EXPRESSIONS
    (OWNER, CLUSTER_NAME, HASH_EXPRESSION)
as
select us.name, o.name, c.condition
from sys.cdef$ c, sys.user$ us, sys.obj$ o
where c.type   = 8
and   c.obj#   = o.obj#
and   us.user# = o.owner#
and   ( us.user# = userenv('SCHEMAID')
        or  /* user has system privilages */
           exists (select null from v$enabledprivs
               where priv_number in (-61 /* CREATE ANY CLUSTER */,
                                     -62 /* ALTER ANY CLUSTER */,
                                     -63 /* DROP ANY CLUSTER */ )
		  )
      )
/

comment on table ALL_CLUSTER_HASH_EXPRESSIONS is
'Hash functions for all accessible clusters'
/
comment on column ALL_CLUSTER_HASH_EXPRESSIONS.OWNER is
'Name of owner of cluster'
/
comment on column ALL_CLUSTER_HASH_EXPRESSIONS.CLUSTER_NAME is
'Name of cluster'
/
comment on column ALL_CLUSTER_HASH_EXPRESSIONS.HASH_EXPRESSION is
'Text of hash function of cluster'
/
grant select on ALL_CLUSTER_HASH_EXPRESSIONS to public with grant option
/
drop public synonym ALL_CLUSTER_HASH_EXPRESSIONS
/
create public synonym ALL_CLUSTER_HASH_EXPRESSIONS for
 ALL_CLUSTER_HASH_EXPRESSIONS
/

create or replace view DBA_CLUSTER_HASH_EXPRESSIONS
    (OWNER, CLUSTER_NAME, HASH_EXPRESSION)
as
select us.name, o.name, c.condition
from sys.cdef$ c, sys.user$ us, sys.obj$ o
where c.type = 8
and c.obj#   = o.obj#
and us.user# = o.owner#
/

comment on table DBA_CLUSTER_HASH_EXPRESSIONS is
'Hash functions for all clusters'
/
comment on column DBA_CLUSTER_HASH_EXPRESSIONS.OWNER is
'Name of owner of cluster'
/
comment on column DBA_CLUSTER_HASH_EXPRESSIONS.CLUSTER_NAME is
'Text of hash function of the cluster'
/
comment on column DBA_CLUSTER_HASH_EXPRESSIONS.HASH_EXPRESSION is
'Text of hash function of cluster'
/
drop public synonym DBA_CLUSTER_HASH_EXPRESSIONS
/
create public synonym DBA_CLUSTER_HASH_EXPRESSIONS for
 DBA_CLUSTER_HASH_EXPRESSIONS
/

remark
remark  FAMILY "CONS_COLUMNS"
remark
create or replace view USER_CONS_COLUMNS 
    (OWNER, CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, POSITION)
as
select u.name, c.name, o.name, col.name, cc.pos#
from sys.user$ u, sys.con$ c, sys.col$ col, sys.ccol$ cc, sys.cdef$ cd,
     sys.obj$ o
where c.owner# = u.user#
  and c.con# = cd.con#
  and cd.con# = cc.con#
  and cc.obj# = col.obj#
  and cc.col# = col.col#
  and cc.obj# = o.obj#
  and c.owner# = userenv('SCHEMAID')
/
comment on table USER_CONS_COLUMNS is
'Information about accessible columns in constraint definitions'
/
comment on column USER_CONS_COLUMNS.OWNER is
'Owner of the constraint definition'
/
comment on column USER_CONS_COLUMNS.CONSTRAINT_NAME is
'Name associated with the constraint definition'
/
comment on column USER_CONS_COLUMNS.TABLE_NAME is
'Name associated with table with constraint definition'
/
comment on column USER_CONS_COLUMNS.COLUMN_NAME is
'Name associated with column specified in the constraint definition'
/
comment on column USER_CONS_COLUMNS.POSITION is
'Original position of column in definition'
/
grant select on USER_CONS_COLUMNS to public with grant option
/
drop public synonym USER_CONS_COLUMNS
/
create public synonym USER_CONS_COLUMNS for USER_CONS_COLUMNS
/
create or replace view ALL_CONS_COLUMNS 
    (OWNER, CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, POSITION)
as
select u.name, c.name, o.name, col.name, cc.pos#
from sys.user$ u, sys.con$ c, sys.col$ col, sys.ccol$ cc, sys.cdef$ cd,
     sys.obj$ o
where c.owner# = u.user#
  and c.con# = cd.con#
  and cd.con# = cc.con#
  and cc.obj# = col.obj#
  and cc.col# = col.col#
  and cc.obj# = o.obj#
  and (c.owner# = userenv('SCHEMAID')
       or cd.obj# in (select obj#
                      from sys.objauth$
                      where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                     )
	or /* user has system privileges */
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
      )
/
comment on table ALL_CONS_COLUMNS is
'Information about accessible columns in constraint definitions'
/
comment on column ALL_CONS_COLUMNS.OWNER is
'Owner of the constraint definition'
/
comment on column ALL_CONS_COLUMNS.CONSTRAINT_NAME is
'Name associated with the constraint definition'
/
comment on column ALL_CONS_COLUMNS.TABLE_NAME is
'Name associated with table with constraint definition'
/
comment on column ALL_CONS_COLUMNS.COLUMN_NAME is
'Name associated with column specified in the constraint definition'
/
comment on column ALL_CONS_COLUMNS.POSITION is
'Original position of column in definition'
/
grant select on ALL_CONS_COLUMNS to public with grant option
/
drop public synonym ALL_CONS_COLUMNS
/
create public synonym ALL_CONS_COLUMNS for ALL_CONS_COLUMNS
/
create or replace view DBA_CONS_COLUMNS 
    (OWNER, CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, POSITION)
as
select u.name, c.name, o.name, col.name, cc.pos#
from sys.user$ u, sys.con$ c, sys.col$ col, sys.ccol$ cc, sys.cdef$ cd,
     sys.obj$ o
where c.owner# = u.user#
  and c.con# = cd.con#
  and cd.con# = cc.con#
  and cc.obj# = col.obj#
  and cc.col# = col.col#
  and cc.obj# = o.obj#
/
drop public synonym DBA_CONS_COLUMNS
/
create public synonym DBA_CONS_COLUMNS for DBA_CONS_COLUMNS
/
comment on table DBA_CONS_COLUMNS is
'Information about accessible columns in constraint definitions'
/
comment on column DBA_CONS_COLUMNS.OWNER is
'Owner of the constraint definition'
/
comment on column DBA_CONS_COLUMNS.CONSTRAINT_NAME is
'Name associated with the constraint definition'
/
comment on column DBA_CONS_COLUMNS.TABLE_NAME is
'Name associated with table with constraint definition'
/
comment on column DBA_CONS_COLUMNS.COLUMN_NAME is
'Name associated with column specified in the constraint definition'
/
comment on column DBA_CONS_COLUMNS.POSITION is
'Original position of column in definition'
/

remark
remark  FAMILY "NLS"
remark

create or replace view NLS_SESSION_PARAMETERS (PARAMETER, VALUE) as
select substr(parameter, 1, 30), 
       substr(value, 1, 30) 
from v$nls_parameters
where parameter != 'NLS_CHARACTERSET'
/
comment on table NLS_SESSION_PARAMETERS is
'NLS parameters of the user session'
/
comment on column NLS_SESSION_PARAMETERS.PARAMETER is
'Parameter name'
/
comment on column NLS_SESSION_PARAMETERS.VALUE is
'Parameter value'
/
drop public synonym NLS_SESSION_PARAMETERS
/
create public synonym NLS_SESSION_PARAMETERS for NLS_SESSION_PARAMETERS
/
grant select on NLS_SESSION_PARAMETERS to PUBLIC with grant option
/
create or replace view NLS_INSTANCE_PARAMETERS (PARAMETER, VALUE) as
select substr(upper(name), 1, 30), 
       substr(value, 1, 30) 
from v$parameter 
where name like 'nls%'
/
comment on table NLS_INSTANCE_PARAMETERS is
'NLS parameters of the instance'
/
comment on column NLS_INSTANCE_PARAMETERS.PARAMETER is
'Parameter name'
/
comment on column NLS_INSTANCE_PARAMETERS.VALUE is
'Parameter value'
/
drop public synonym NLS_INSTANCE_PARAMETERS
/
create public synonym NLS_INSTANCE_PARAMETERS for NLS_INSTANCE_PARAMETERS
/
grant select on NLS_INSTANCE_PARAMETERS to PUBLIC with grant option
/
create or replace view NLS_DATABASE_PARAMETERS (PARAMETER, VALUE) as
select name, 
       substr(value$, 1, 30)
from props$ 
where name like 'NLS%'
/
comment on table NLS_DATABASE_PARAMETERS is
'Permanent NLS parameters of the database'
/
comment on column NLS_DATABASE_PARAMETERS.PARAMETER is
'Parameter name'
/
comment on column NLS_DATABASE_PARAMETERS.VALUE is
'Parameter value'
/
drop public synonym NLS_DATABASE_PARAMETERS
/
create public synonym NLS_DATABASE_PARAMETERS for NLS_DATABASE_PARAMETERS
/
grant select on NLS_DATABASE_PARAMETERS to PUBLIC with grant option
/

rem 
rem V5 views required for other Oracle products
rem

create or replace view syscatalog_ 
    (tname, creator, creatorid, tabletype, remarks)
  as
  select o.name, u.name, o.owner#,
         decode(o.type, 2, 'TABLE', 4, 'VIEW', 6, 'SEQUENCE','?'), c.comment$
  from	sys.user$ u, sys.obj$ o, sys.com$ c
  where u.user# = o.owner#
    and	o.type in (2, 4, 6)
    and o.linkname is null
    and o.obj# = c.obj#(+)
    and ( o.owner# = userenv('SCHEMAID')
	  or o.obj# in
	     (select oa.obj#
	      from   sys.objauth$ oa
	      where  oa.grantee# in (userenv('SCHEMAID'), 1)
	      )
	  or
	  (
	  o.type in (2, 4) /* table, view */
	  and
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
	   )
	  or
	 ( o.type = 6 /* sequence */
	   and
	   exists (select null from v$enabledprivs
		   where priv_number = -109 /* SELECT ANY SEQUENCE */)
	 )
       )
/
create or replace view syscatalog (tname, creator, tabletype, remarks) as
  select tname, creator, tabletype, remarks
  from syscatalog_
/
grant select on syscatalog to public with grant option;
drop synonym system.syscatalog;
create synonym system.syscatalog for syscatalog;
rem
rem The catalog view returns almost all tables accessible to the user
rem except tables in SYS and SYSTEM ("dictionary tables").
rem 
create or replace view catalog (tname, creator, tabletype, remarks) as
  select tname, creator, tabletype, remarks
  from	syscatalog_
  where creatorid not in (0,2)
/
grant select on catalog to public with grant option;
drop synonym system.catalog;
create synonym system.catalog for catalog;

create or replace view tab (tname, tabtype, clusterid) as
   select o.name,
      decode(o.type, 2, 'TABLE', 3, 'CLUSTER', 
             4, 'VIEW', 5, 'SYNONYM'), t.tab#
  from  sys.tab$ t, sys.obj$ o
  where o.owner# = userenv('SCHEMAID')
  and o.type >=2
  and o.type <=5
  and o.linkname is null
  and o.obj# = t.obj# (+)
/
grant select on tab to public with grant option;
drop synonym system.tab;
create synonym system.tab for tab;
drop public synonym tab;
create public synonym tab for tab;
create or replace view col 
  (tname, colno, cname, coltype, width, scale, precision, nulls, defaultval) as
  select t.name, c.col#, c.name, 
	 decode(c.type#, 1, 'VARCHAR2',
                         2, decode(c.scale, null,
                                   decode(c.precision, null, 'NUMBER', 'FLOAT'),
                                  'NUMBER'),
                         8, 'LONG', 9, 'VARCHAR',
                         12, 'DATE', 23, 'RAW', 24, 'LONG RAW',
                         69, 'ROWID',96,'CHAR', 105, 'MLSLABEL',
                         106, 'MLSLABEL', 'UNDEFINED'),
         c.length, c.scale, c.precision,
	 decode(sign(c.null$),-1,'NOT NULL - DISABLED', 0, 'NULL', 
	'NOT NULL'), c.default$
  from  sys.col$ c, sys.obj$ t
  where t.obj# = c.obj#
  and   t.type in (2, 3, 4)
  and   t.owner# = userenv('SCHEMAID')
/
grant select on col to public with grant option;
drop synonym system.col;
create synonym system.col for col;
drop public synonym col;
create public synonym col for col;
create or replace view syssegobj 
    (obj#, file#, block#, type, pctfree$, pctused$) as
  select obj#, file#, block#, 'TABLE', mod(pctfree$, 100), pctused$ from sys.tab$
  union all
  select obj#, file#, block#, 'CLUSTER', pctfree$, pctused$ from sys.clu$
  union all
  select obj#, file#, block#, 'INDEX', to_number(null), to_number(null)
         from sys.ind$
/
grant select on syssegobj to public with grant option;
create or replace view tabquotas (tname, type, objno, nextext, maxext, pinc,
		       pfree, pused) as
  select t.name, so.type, t.obj#, s.extsize, s.maxexts, s.extpct, so.pctfree$,
	 so.pctused$
  from  sys.seg$ s, sys.obj$ t, syssegobj so
  where t.owner# = userenv('SCHEMAID')
  and   t.obj# = so.obj#
  and   so.file# = s.file# 
  and   so.block# = s.block#
/
grant select on tabquotas to public with grant option;
drop synonym system.tabquotas;
create synonym system.tabquotas for tabquotas;

create or replace view sysfiles (tsname, fname, blocks) as
  select ts.name, dbf.name, f.blocks
  from  sys.ts$ ts, sys.file$ f, sys.v$dbfile dbf
  where ts.ts# = f.ts#(+) and dbf.file# = f.file# and f.status$ = 2
/
grant select on sysfiles to public with grant option;
drop synonym system.sysfiles;
create synonym system.sysfiles for sysfiles;
create or replace view synonyms 
    (sname, syntype, creator, tname, database, tabtype) as
  select s.name, 
	 decode(s.owner#,1,'PUBLIC','PRIVATE'), t.owner, t.name, 'LOCAL', 
	 decode(ot.type, 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER', 4, 'VIEW',
			 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE',
                         8, 'FUNCTION', 9, 'PACKAGE', 'UNDEFINED')
  from  sys.obj$ s, sys.obj$ ot, sys.syn$ t, sys.user$ u
  where s.obj# = t.obj# 
    and ot.linkname is null
    and s.type = 5
    and ot.name = t.name
    and t.owner = u.name
    and ot.owner# = u.user#
    and s.owner# in (1,userenv('SCHEMAID'))
    and t.node is null
union all
  select s.name, decode(s.owner#, 1, 'PUBLIC', 'PRIVATE'),
	 t.owner, t.name, t.node, 'REMOTE'
  from  sys.obj$ s, sys.syn$ t
  where s.obj# = t.obj#
    and s.type = 5
    and s.owner# in (1, userenv('SCHEMAID'))
    and t.node is not null
/  
grant select on synonyms to public with grant option;
create or replace view publicsyn (sname, creator, tname, database, tabtype) as
  select sname, creator, tname, database, tabtype
  from  synonyms
  where syntype = 'PUBLIC'
/
grant select on publicsyn to public with grant option;
drop synonym system.publicsyn;
create synonym system.publicsyn for publicsyn;

rem 
rem V6 views required for other Oracle products
rem

create or replace view TABLE_PRIVILEGES
      (GRANTEE, OWNER, TABLE_NAME, GRANTOR,
       SELECT_PRIV, INSERT_PRIV, DELETE_PRIV, 
       UPDATE_PRIV, REFERENCES_PRIV, ALTER_PRIV, INDEX_PRIV,
       CREATED)
as
select ue.name, u.name, o.name, ur.name,
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 7, 2), 
      '00', 'N', '01', 'Y', '11', 'G', 'N'),
     decode(substr(lpad(sum(decode(col#, null, power(10, privilege#*2) + 
       decode(option$, null, 0, power(10, privilege#*2 + 1)), 0)), 26, '0'), 
              13, 2), '01', 'A', '11', 'G', 
          decode(sum(decode(col#,
                            null, 0,
                            decode(privilege#, 6, 1, 0))), 0, 'N', 'S')),
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 19, 2), 
      '00', 'N', '01', 'Y', '11', 'G', 'N'),
    decode(substr(lpad(sum(decode(col#, null, power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1)), 0)), 26, '0'), 
             5, 2),'01', 'A', '11', 'G', 
          decode(sum(decode(col#,
                            null, 0,
                            decode(privilege#, 10, 1, 0))), 0, 'N', 'S')),
    decode(substr(lpad(sum(decode(col#, null, power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1)), 0)), 26, '0'), 
             3, 2), '01', 'A', '11', 'G', 
          decode(sum(decode(col#,
                            null, 0,
                            decode(privilege#, 11, 1, 0))), 0, 'N', 'S')),
   decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 25, 2), 
      '00', 'N', '01', 'Y', '11', 'G', 'N'), 
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 15, 2), 
      '00', 'N', '01', 'Y', '11', 'G', 'N'), min(null)
from sys.objauth$ oa, sys.obj$ o, sys.user$ ue, sys.user$ ur, sys.user$ u
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and (oa.grantor# = userenv('SCHEMAID') or
       oa.grantee# in (select kzsrorol from x$kzsro) or
       o.owner# = userenv('SCHEMAID'))
  group by u.name, o.name, ur.name, ue.name
/
comment on table TABLE_PRIVILEGES is
'Grants on objects for which the user is the grantor, grantee, owner, 
 or an enabled role or PUBLIC is the grantee'
/
comment on column TABLE_PRIVILEGES.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column TABLE_PRIVILEGES.OWNER is
'Owner of the object'
/
comment on column TABLE_PRIVILEGES.TABLE_NAME is
'Name of the object'
/
comment on column TABLE_PRIVILEGES.GRANTOR is
'Name of the user who performed the grant'
/
comment on column TABLE_PRIVILEGES.SELECT_PRIV is
'Permission to SELECT from the object?'
/
comment on column TABLE_PRIVILEGES.INSERT_PRIV is
'Permission to INSERT into the object?'
/
comment on column TABLE_PRIVILEGES.DELETE_PRIV is
'Permission to DELETE from the object?'
/
comment on column TABLE_PRIVILEGES.UPDATE_PRIV is
'Permission to UPDATE the object?'
/
comment on column TABLE_PRIVILEGES.REFERENCES_PRIV is
'Permission to make REFERENCES to the object?'
/
comment on column TABLE_PRIVILEGES.ALTER_PRIV is
'Permission to ALTER the object?'
/
comment on column TABLE_PRIVILEGES.INDEX_PRIV is
'Permission to create/drop an INDEX on the object?'
/
comment on column TABLE_PRIVILEGES.CREATED is
'Timestamp for the grant'
/
drop public synonym TABLE_PRIVILEGES
/
create public synonym TABLE_PRIVILEGES for TABLE_PRIVILEGES
/
grant select on TABLE_PRIVILEGES to PUBLIC
/
create or replace view COLUMN_PRIVILEGES
      (GRANTEE, OWNER, TABLE_NAME, COLUMN_NAME, GRANTOR,
       INSERT_PRIV, UPDATE_PRIV, REFERENCES_PRIV,
       CREATED)
as
select ue.name, u.name, o.name, c.name, ur.name,
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 13, 2), 
      '00', 'N', '01', 'Y', '11', 'G', 'N'),
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 5, 2), 
      '00', 'N', '01', 'Y', '11', 'G', 'N'),
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 3, 2), 
      '00', 'N', '01', 'Y', '11', 'G', 'N'), min(null)
from sys.objauth$ oa, sys.col$ c,sys.obj$ o, sys.user$ ue, sys.user$ ur, 
     sys.user$ u
where oa.col# is not null
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and (oa.grantor# = userenv('SCHEMAID') or
       oa.grantee# in (select kzsrorol from x$kzsro) or
       o.owner# = userenv('SCHEMAID'))
  group by u.name, o.name, c.name, ur.name, ue.name
/
comment on table COLUMN_PRIVILEGES is
'Grants on columns for which the user is the grantor, grantee, owner, or 
 an enabled role or PUBLIC is the grantee'
/
comment on column COLUMN_PRIVILEGES.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column COLUMN_PRIVILEGES.OWNER is
'Username of the owner of the object'
/
comment on column COLUMN_PRIVILEGES.TABLE_NAME is
'Name of the object'               
/
comment on column COLUMN_PRIVILEGES.COLUMN_NAME is
'Name of the column'
/
comment on column COLUMN_PRIVILEGES.GRANTOR is
'Name of the user who performed the grant'
/
comment on column COLUMN_PRIVILEGES.INSERT_PRIV is
'Permission to INSERT into the column?'
/
comment on column COLUMN_PRIVILEGES.UPDATE_PRIV is
'Permission to UPDATE the column?'
/
comment on column COLUMN_PRIVILEGES.REFERENCES_PRIV is
'Permission to make REFERENCES to the column?'
/
comment on column COLUMN_PRIVILEGES.CREATED is
'Timestamp for the grant'
/
drop public synonym COLUMN_PRIVILEGES
/
create public synonym COLUMN_PRIVILEGES for COLUMN_PRIVILEGES
/
grant select on COLUMN_PRIVILEGES to PUBLIC
/

rem	**********************************************************************
rem		DBA TWO PHASE COMMIT DECISION / DAMAGE ASSESSMENT TABLES
rem	**********************************************************************
rem 	PSS1$: used to add user name column to pending_sub_sessions$
create or replace view pss1$ as
select	pss.*, u.name owner_name
from 	sys.pending_sub_sessions$ pss, sys.user$ u
where   pss.link_owner = u.user#;

rem 	PS1$: used to add user name column to pending_sessions$
create or replace view ps1$ as
select	ps.*, u.name db_user
from 	sys.pending_sessions$ ps, sys.user$ u
where   ps.db_userid = u.user#;

rem 	DBA_2PC_PENDING
rem	use this view to find info about pending (i.e. incomplete) distributed
rem	transactions at this DB.  Use os_user and db_userid to help track down
rem	a responsible party.  Use DBA_2PC_NEIGHBORS to find the commit point.
rem	Or take the advice, if offered.

create or replace view DBA_2PC_PENDING
    (local_tran_id, global_tran_id, state, mixed,
     advice, tran_comment, fail_time, force_time,
     retry_time, os_user, os_terminal, host, db_user, commit#) as
select  local_tran_id,
        nvl(global_oracle_id, global_tran_fmt||'.'||global_foreign_id),
	state, decode(status,'D','yes','no'), heuristic_dflt, tran_comment,
        fail_time, heuristic_time, reco_time,
        top_os_user, top_os_terminal, top_os_host, top_db_user, global_commit#
from	sys.pending_trans$;
drop public synonym DBA_2PC_PENDING;
create public synonym DBA_2PC_PENDING for DBA_2PC_PENDING;
comment on table DBA_2PC_PENDING is
  'info about distributed transactions awaiting recovery';
comment on column DBA_2PC_PENDING.local_tran_id is
  'string of form: n.n.n, n a number';
comment on column DBA_2PC_PENDING.global_tran_id is
  'globally unique transaction id';
comment on column DBA_2PC_PENDING.state is
  'collecting, prepared, committed, forced commit, or forced rollback';
comment on column DBA_2PC_PENDING.mixed is
  'yes => part of the transaction committed and part rolled back (commit or rollback with the FORCE option was used)';
comment on column DBA_2PC_PENDING.advice is
  'C for commit, R for rollback, else null';
comment on column DBA_2PC_PENDING.tran_comment is
  'text for "commit work comment <text>"';
comment on column DBA_2PC_PENDING.fail_time is
  'value of SYSDATE when the row was inserted (tx or system recovery)';
comment on column DBA_2PC_PENDING.force_time is
 'time of manual force decision (null if not forced locally)';
comment on column DBA_2PC_PENDING.retry_time is
 'time automatic recovery (RECO) last tried to recover the transaction';
comment on column DBA_2PC_PENDING.os_user is
  'operating system specific name for the end-user';
comment on column DBA_2PC_PENDING.os_terminal is
  'operating system specific name for the end-user terminal';
comment on column DBA_2PC_PENDING.host is
  'name of the host machine for the end-user';
comment on column DBA_2PC_PENDING.db_user is
  'Oracle user name of the end-user at the topmost database';
comment on column DBA_2PC_PENDING.commit# is
  'global commit number for committed transactions';

rem	DBA_2PC_NEIGHBORS: use this view to obtain info about incoming and
rem	  outgoing connections for a particular transaction.  It is suggested
rem 	  that it be queried using:
rem	    select * from dba_2pc_neighbors where local_tran_id = <id>
rem	     order by sess#, "IN_OUT";
rem	  This will group sessions, with outgoing connections following the
rem	  incoming connection for each session.
rem   columns:
rem	IN_OUT: 'in' for incoming connections, 'out' for outgoing
rem 	DATABASE: if 'in', the name of the client database, else name of 
rem	  outgoing db link
rem	DBUSER_OWNER: if 'in', name of local user, else owner of db link
rem	INTERFACE: 'C' hold commit, else 'N'.  For incoming links, 'C'
rem 	  means that we or a DB at the other end of one of our outgoing links
rem       is the commit point (and must not forget until told by the client).
rem	  For outgoing links, 'C' means that the child at the other end is the
rem	  commit point, and will know whether the tran should commit or abort.
rem	  If we are indoubt and do not find a 'C' on an outgoing link, then
rem	  the top level user/DB, or the client, should be able to locate the
rem	  commit point.
rem	DBID: the database id at the other end of the connection
rem	SESS#: session number at this database of the connection.  Sessions are
rem 	  numbered consecutively from 1; there is always at least 1 session, 
rem	  and exactly 1 incoming connection per session.
rem	BRANCH_ID: transaction branch.  An incoming branch is a two byte
rem	  hexadecimal number.  The first byte is the session_id of the
rem	  remote parent session.  The second byte is the branch_id of the
rem	  remote parent session.  If the remote parent session is not Oracle,
rem	  the branch_id can be up to 64 bytes.

create or replace view DBA_2PC_NEIGHBORS(local_tran_id, in_out, database,
                               dbuser_owner, interface, dbid, 
			       sess#, branch) as
select  local_tran_id, 'in', parent_db, db_user, interface, parent_dbid,
        session_id, rawtohex(branch_id)
from	sys.ps1$
union all
select  local_tran_id, 'out', dblink, owner_name, interface, dbid, 
        session_id, to_char(sub_session_id)
from	sys.pss1$;
drop public synonym DBA_2PC_NEIGHBORS;
create public synonym DBA_2PC_NEIGHBORS for DBA_2PC_NEIGHBORS;
comment on table DBA_2PC_NEIGHBORS is
  'information about incoming and outgoing connections for pending transactions';
comment on column DBA_2PC_NEIGHBORS.in_out is
  '"in" for incoming connections, "out" for outgoing';
comment on column DBA_2PC_NEIGHBORS.database is
  'in: client database name; out: outgoing db link';
comment on column DBA_2PC_NEIGHBORS.dbuser_owner is
  'in: name of local user; out: owner of db link';
comment on column DBA_2PC_NEIGHBORS.interface is
  '"C" for request commit, else "N" for prepare or request readonly commit';
comment on column DBA_2PC_NEIGHBORS.dbid is
  'the database id at the other end of the connection';
comment on column DBA_2PC_NEIGHBORS.sess# is
  'session number at this database of the connection';
comment on column DBA_2PC_NEIGHBORS.branch is
  'transaction branch ID at this database of the connection';
/

Rem	GLOBAL DATABASE NAME

create or replace view GLOBAL_NAME ( GLOBAL_NAME ) as
       select value$ from sys.props$ where name = 'GLOBAL_DB_NAME'
/
comment on table GLOBAL_NAME is 'global database name'
/
comment on column GLOBAL_NAME.GLOBAL_NAME is 'global database name'
/
grant select on GLOBAL_NAME to public with grant option
/
drop public synonym GLOBAL_NAME
/
create public synonym GLOBAL_NAME for GLOBAL_NAME
/

Rem     PRODUCT COMPONENT VERSION
create or replace view product_component_version(product,version,status) as
(select
substr(banner,1, instr(banner,'Version')-1),
substr(banner, instr(banner,'Version')+8,
instr(banner,' - ')-(instr(banner,'Version')+8)),
substr(banner,instr(banner,' - ')+3)
from v$version
where instr(banner,'Version') > 0
and
((instr(banner,'Version') <   instr(banner,'Release')) or
instr(banner,'Release') = 0))
union
(select
substr(banner,1, instr(banner,'Release')-1),
substr(banner, instr(banner,'Release')+8,
instr(banner,' - ')-(instr(banner,'Release')+8)),
substr(banner,instr(banner,' - ')+3)
from v$version
where instr(banner,'Release') > 0
and
instr(banner,'Release') <   instr(banner,' - '))
/
comment on table product_component_version is 
'version and status information for component products'
/
comment on column product_component_version.product is 
'product name';
/
comment on column product_component_version.version is 
'version number'
/
comment on column product_component_version.status is 
'status of release'
/
grant select on product_component_version to public with grant option
/
drop public synonym product_component_version
/
create public synonym product_component_version for product_component_version
/
remark
remark  FAMILY "UPDATABLE_COLUMNS"
remark
create or replace view USER_UPDATABLE_COLUMNS 
(OWNER, TABLE_NAME, COLUMN_NAME, UPDATABLE) as
select u.name, o.name, c.name, decode(bitand(c.fixedstorage,2), 2, 'NO', 'YES')
from sys.obj$ o, sys.user$ u, sys.col$ c
where u.user# = o.owner#
  and c.obj#  = o.obj#
  and u.user# = userenv('SCHEMAID')
/
comment on table USER_UPDATABLE_COLUMNS is
'Description of updatable columns'
/
comment on column USER_UPDATABLE_COLUMNS.OWNER is
'Table owner'
/
comment on column USER_UPDATABLE_COLUMNS.TABLE_NAME is
'Table name'
/
comment on column USER_UPDATABLE_COLUMNS.COLUMN_NAME is
'Column name'
/
comment on column USER_UPDATABLE_COLUMNS.UPDATABLE is
'Is the column updatable?'
/
drop public synonym USER_UPDATABLE_COLUMNS
/
create public synonym USER_UPDATABLE_COLUMNS for USER_UPDATABLE_COLUMNS
/
grant select on USER_UPDATABLE_COLUMNS to PUBLIC with grant option
/
create or replace view ALL_UPDATABLE_COLUMNS 
(OWNER, TABLE_NAME, COLUMN_NAME, UPDATABLE) 
as
select u.name, o.name, c.name, decode(bitand(c.fixedstorage,2), 2, 'NO', 'YES')
from sys.obj$ o, sys.user$ u, sys.col$ c
where o.owner# = u.user#
  and o.obj#  = c.obj#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               ) 
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
/
comment on table ALL_UPDATABLE_COLUMNS is
'Description of all updatable columns'
/
comment on column ALL_UPDATABLE_COLUMNS.OWNER is
'Table owner'
/
comment on column ALL_UPDATABLE_COLUMNS.TABLE_NAME is
'Table name'
/
comment on column ALL_UPDATABLE_COLUMNS.COLUMN_NAME is
'Column name'
/
comment on column ALL_UPDATABLE_COLUMNS.UPDATABLE is
'Is the column updatable?'
/
drop public synonym ALL_UPDATABLE_COLUMNS
/
create public synonym ALL_UPDATABLE_COLUMNS for ALL_UPDATABLE_COLUMNS
/
grant select on ALL_UPDATABLE_COLUMNS to PUBLIC with grant option
/
create or replace view DBA_UPDATABLE_COLUMNS 
(OWNER, TABLE_NAME, COLUMN_NAME, UPDATABLE) 
as
select u.name, o.name, c.name, decode(bitand(c.fixedstorage,2), 2, 'NO', 'YES')
from sys.obj$ o, sys.user$ u, sys.col$ c
where u.user# = o.owner#
  and c.obj#  = o.obj#
/
comment on table DBA_UPDATABLE_COLUMNS is
'Description of dba updatable columns'
/
comment on column DBA_UPDATABLE_COLUMNS.OWNER is
'table owner'
/
comment on column DBA_UPDATABLE_COLUMNS.TABLE_NAME is
'table name'
/
comment on column DBA_UPDATABLE_COLUMNS.COLUMN_NAME is
'column name'
/
comment on column DBA_UPDATABLE_COLUMNS.UPDATABLE is
'Is the column updatable?'
/
drop public synonym DBA_UPDATABLE_COLUMNS
/
create public synonym DBA_UPDATABLE_COLUMNS for DBA_UPDATABLE_COLUMNS
/

Rem Auditing views
@@cataudit

Rem Import/export views
@@catexp

Rem Loader views
@@catldr

Rem Server Manager views
@@catsvrmg

Rem ---------------------------------------------------------------------------
Rem THIS IS THE END OF THIS FILE - IF I AM NOT HERE THEN RCS HAS TRUNCATED FILE
Rem ---------------------------------------------------------------------------
