rem 
rem $Header: catdbsyn.sql,v 1.2 1994/06/13 17:46:32 wmaimone Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      catdbsyn.sql - catalog dba synonyms
Rem    DESCRIPTION
Rem      Creates private synonyms for DBA-only dictionary views.
Rem    RETURNS
Rem 
Rem    NOTES
Rem      This file is made obsolete as DBA is now a role.  All DBA_% catalog
Rem      views have a corresponding public synonym, and are accessible to
Rem      any user with SELECT ANY TABLE privilege.
Rem    MODIFIED   (MM/DD/YY)
Rem     wmaimone   05/26/94 -  #186155 add public synoyms for dba_
Rem     glumpkin   10/20/92 -  Renamed from DBA_SYN.SQL 
Rem     mmoore     07/13/92 - #(118440) add dba_priv_audit_opts synonym 
Rem     mmoore     07/06/92 -  change 'grants' to 'privs' in privilege views 
Rem     rjenkins   04/24/92 -  adding snapshot views 
Rem     mmoore     09/18/91 -  add dba_roles 
Rem     rlim       08/22/91 - Creation - rename dba_synonyms.sql to dba_syn.sql
Rem     rlim       07/30/91 -         added dba synonyms from catalog.sql & aud
Rem     Kooi       03/11/91 - new stuff for procedures/triggers
Rem     Moore      10/04/90 - add dba_col_grants
rem	Grayson	   03/20/88 - Creation
rem     Mendels    05/11/89 - rename dba_exp_tables -> dba_exp_objects
rem
drop synonym DBA_CATALOG
/
create synonym DBA_CATALOG for SYS.DBA_CATALOG
/
drop synonym DBA_CLUSTERS
/
create synonym DBA_CLUSTERS for SYS.DBA_CLUSTERS
/
drop synonym DBA_CLU_COLUMNS
/
create synonym DBA_CLU_COLUMNS for SYS.DBA_CLU_COLUMNS
/
drop synonym DBA_COL_COMMENTS
/
create synonym DBA_COL_COMMENTS for SYS.DBA_COL_COMMENTS
/
drop synonym DBA_CROSS_REFS
/
create synonym DBA_CROSS_REFS for SYS.DBA_CROSS_REFS
/
drop synonym DBA_DATA_FILES
/
create synonym DBA_DATA_FILES for SYS.DBA_DATA_FILES
/
drop synonym DBA_DB_LINKS
/
create synonym DBA_DB_LINKS for SYS.DBA_DB_LINKS
/
drop synonym DBA_EXP_FILES
/
create synonym DBA_EXP_FILES for SYS.DBA_EXP_FILES
/
drop synonym DBA_EXP_OBJECTS
/
create synonym DBA_EXP_OBJECTS for SYS.DBA_EXP_OBJECTS
/
drop synonym DBA_EXP_VERSION
/
create synonym DBA_EXP_VERSION for SYS.DBA_EXP_VERSION
/
drop synonym DBA_EXTENTS
/
create synonym DBA_EXTENTS for SYS.DBA_EXTENTS
/
drop synonym DBA_FREE_SPACE
/
create synonym DBA_FREE_SPACE for SYS.DBA_FREE_SPACE
/
drop synonym DBA_INDEXES
/
create synonym DBA_INDEXES for SYS.DBA_INDEXES
/
drop synonym DBA_IND_COLUMNS
/
create synonym DBA_IND_COLUMNS for SYS.DBA_IND_COLUMNS
/
drop synonym DBA_OBJECTS
/
create synonym DBA_OBJECTS for SYS.DBA_OBJECTS
/
drop synonym DBA_SEQUENCES
/
create synonym DBA_SEQUENCES for SYS.DBA_SEQUENCES
/
drop synonym DBA_TAB_COLUMNS
/
create synonym DBA_TAB_COLUMNS for SYS.DBA_TAB_COLUMNS
/
drop synonym DBA_TAB_COMMENTS
/
create synonym DBA_TAB_COMMENTS for SYS.DBA_TAB_COMMENTS
/
drop synonym DBA_TAB_PRIVS
/
create synonym DBA_TAB_PRIVS for SYS.DBA_TAB_PRIVS
/
drop synonym DBA_ROLLBACK_SEGS
/
create synonym DBA_ROLLBACK_SEGS for SYS.DBA_ROLLBACK_SEGS
/
drop synonym DBA_SEGMENTS
/
create synonym DBA_SEGMENTS for SYS.DBA_SEGMENTS
/
drop synonym DBA_SYNONYMS
/
create synonym DBA_SYNONYMS for SYS.DBA_SYNONYMS
/
drop synonym DBA_TABLESPACES
/
create synonym DBA_TABLESPACES for SYS.DBA_TABLESPACES
/
drop synonym DBA_TABLES
/
create synonym DBA_TABLES for SYS.DBA_TABLES
/
drop synonym DBA_TS_QUOTAS
/
create synonym DBA_TS_QUOTAS for SYS.DBA_TS_QUOTAS
/
drop synonym DBA_USERS
/
create synonym DBA_USERS for SYS.DBA_USERS
/
drop synonym DBA_VIEWS
/
create synonym DBA_VIEWS for SYS.DBA_VIEWS
/
drop synonym DBA_COL_PRIVS
/
create synonym DBA_COL_PRIVS for SYS.DBA_COL_PRIVS
/
drop synonym DBA_TRIGGERS
/
create synonym DBA_TRIGGERS for SYS.DBA_TRIGGERS
/
drop synonym DBA_ROLE_PRIVS
/
create synonym DBA_ROLE_PRIVS for SYS.DBA_ROLE_PRIVS
/
drop synonym DBA_SYS_PRIVS
/
create synonym DBA_SYS_PRIVS for SYS.DBA_SYS_PRIVS
/
drop synonym DBA_CONSTRAINTS
/
create synonym DBA_CONSTRAINTS for SYS.DBA_CONSTRAINTS
/
drop synonym DBA_CONS_COLUMNS
/
create synonym DBA_CONS_COLUMNS for SYS.DBA_CONS_COLUMNS
/
drop synonym DBA_OBJ_AUDIT_OPTS
/
create synonym DBA_OBJ_AUDIT_OPTS for SYS.DBA_OBJ_AUDIT_OPTS
/
drop synonym DBA_STMT_AUDIT_OPTS
/
create synonym DBA_STMT_AUDIT_OPTS for SYS.DBA_STMT_AUDIT_OPTS
/
drop synonym DBA_PRIV_AUDIT_OPTS
/
create synonym DBA_PRIV_AUDIT_OPTS for SYS.DBA_PRIV_AUDIT_OPTS
/
drop synonym DBA_AUDIT_TRAIL
/
create synonym DBA_AUDIT_TRAIL for SYS.DBA_AUDIT_TRAIL
/
drop synonym DBA_AUDIT_SESSION
/
create synonym DBA_AUDIT_SESSION for SYS.DBA_AUDIT_SESSION
/
drop synonym DBA_AUDIT_STATEMENT
/
create synonym DBA_AUDIT_STATEMENT for SYS.DBA_AUDIT_STATEMENT
/
drop synonym DBA_AUDIT_OBJECT
/
create synonym DBA_AUDIT_OBJECT for SYS.DBA_AUDIT_OBJECT
/
drop synonym DBA_AUDIT_EXISTS
/
create synonym DBA_AUDIT_EXISTS for SYS.DBA_AUDIT_EXISTS
/
drop synonym DBA_2PC_PENDING
/
create synonym DBA_2PC_PENDING for SYS.DBA_2PC_PENDING
/
drop synonym DBA_2PC_NEIGHBORS
/
create synonym DBA_2PC_NEIGHBORS for SYS.DBA_2PC_NEIGHBORS
/
drop synonym DBA_DEPENDENCIES
/
create synonym DBA_DEPENDENCIES for SYS.DBA_DEPENDENCIES
/
drop synonym DBA_ERRORS
/
create synonym DBA_ERRORS for SYS.DBA_ERRORS
/
drop synonym DBA_OBJECT_SIZE
/
create synonym DBA_OBJECT_SIZE for SYS.DBA_OBJECT_SIZE
/
drop synonym DBA_SOURCE
/
create synonym DBA_SOURCE for SYS.DBA_SOURCE
/
drop synonym DBA_PROFILES
/
create synonym DBA_PROFILES for SYS.DBA_PROFILES
/
drop synonym DBA_ROLES
/
create synonym DBA_ROLES for SYS.DBA_ROLES
/
drop synonym DBA_SNAPSHOTS
/
create synonym DBA_SNAPSHOTS for SYS.DBA_SNAPSHOTS
/
drop synonym DBA_SNAPSHOT_LOGS
/
create synonym DBA_SNAPSHOT_LOGS for SYS.DBA_SNAPSHOT_LOGS
/
