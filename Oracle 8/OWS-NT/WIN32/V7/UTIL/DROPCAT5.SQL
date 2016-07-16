rem 
rem $Header: dropcat5.sql,v 1.1 1989/05/11 15:37:03 MFREELAN Stab $ dropcat5.sql 
rem 
Rem Copyright (c) 1988 by Oracle Corporation
Rem NAME
Rem    dropcat5.sql
Rem  FUNCTION
Rem    Drop version 5 dictionary objects owned by SYSTEM
Rem  NOTES
Rem    This script should be run while logged-in as SYSTEM on a version 5
Rem    database.  It drops all version 5 dictionary objects.
Rem    If a user is about to perform a full database export of a
Rem    version 5 database that will be imported into a version 6
Rem    database, he should first run this script to prevent the export
Rem    and later import of the old dictionary objects. 
Rem    All version 6 dictionary objects are owned by SYS, while version 5
Rem    dictionary objects are owned by SYSTEM. 
Rem
Rem  MODIFIED
Rem   Mendels    07/26/88 - Creation
Rem
set echo on
drop public synonym dual;
drop public synonym taballoc;
drop public synonym storage;
drop public synonym extents;
drop public synonym spaces;
drop public synonym syscolumns;
drop public synonym columns;
drop public synonym syscatalog;
drop public synonym catalog;
drop public synonym sysindexes;
drop public synonym indexes;
drop public synonym views;
drop public synonym sysviews;
drop public synonym systabauth;
drop public synonym syscolauth;
drop public synonym sysuserlist;
drop public synonym sysprogs;
drop public synonym synonyms;
drop public synonym publicsyn;
drop public synonym privatesyn;
drop public synonym tab;
drop public synonym col;
drop public synonym tabquotas;
drop public synonym dtab;
drop public synonym partitions;
drop public synonym systaballoc;
drop public synonym sysstorage;
drop public synonym sysextents;
drop public synonym sysuserauth;
drop public synonym system_audit;
drop public synonym default_audit;
drop public synonym table_audit;
drop public synonym audit_actions;
drop public synonym audit_trail;
drop public synonym sysaudit_trail;
drop public synonym audit_dba;
drop public synonym audit_exists;
drop public synonym audit_connect;
drop public synonym sessions;
drop public synonym audit_access;
drop public synonym clusters;
drop public synonym clustercolumns;
drop table dual;
drop view taballoc;
drop view storage;
drop view extents;
drop view spaces;
drop view syscolumns;
drop view columns;
drop view syscatalog;
drop view catalog;
drop view sysindexes;
drop view indexes;
drop view views;
drop view sysviews;
drop view systabauth;
drop view syscolauth;
drop view sysuserlist;
drop view sysprogs;
drop view synonyms;
drop view publicsyn;
drop view privatesyn;
drop view tab;
drop view col;
drop view tabquotas;
drop table dtab;
drop view partitions;
drop view systaballoc;
drop view sysstorage;
drop view sysextents;
drop view sysuserauth;
drop view system_audit;
drop view default_audit;
drop view table_audit;
drop table audit_actions;
drop view audit_trail;
drop view audit_dba;
drop view audit_exists;
drop view audit_connect;
drop view sessions;
drop view audit_access;
drop view clusters;
drop view clustercolumns;
set echo off;
