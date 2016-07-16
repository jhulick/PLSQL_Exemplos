rem 
rem $Header: catrepr.sql,v 1.2 1995/11/20 13:06:42 sjain Exp $ 
rem 
Rem  Copyright (c) 1995 by Oracle Corporation 
Rem    NAME
Rem      catrepr.sql - CATalog REPlication Remove
Rem    DESCRIPTION
Rem      Removes all replication tables, views, packages
Rem        synonyms, and sequences from a database
Rem    RETURNS
Rem 
Rem    NOTES
Rem      This script must be updated eveytime Replication is modified.
Rem    MODIFIED   (MM/DD/YY)
Rem     sjain      10/10/95 -  Name changes of dba_repcat etc.
Rem     hasun      03/06/95 -  Creation

---
--- RepCat Tables
---
DROP TABLE system.repcat$_audit_column
/
DROP TABLE system.repcat$_audit_attribute
/
DROP TABLE system.repcat$_parameter_column
/
DROP TABLE system.repcat$_resol_stats_control
/
DROP TABLE system.repcat$_resolution_statistics
/
DROP TABLE system.repcat$_resolution
/
DROP TABLE system.repcat$_resolution_method
/
DROP TABLE system.repcat$_conflict
/
DROP TABLE system.repcat$_grouped_column
/
DROP TABLE system.repcat$_column_group
/
DROP TABLE system.repcat$_priority
/
DROP TABLE system.repcat$_priority_group
/
DROP TABLE system.repcat$_ddl
/
DROP TABLE system.repcat$_repcatlog
/
DROP TABLE system.repcat$_repprop
/
DROP TABLE system.repcat$_generated
/
DROP TABLE system.repcat$_key_columns
/
DROP TABLE system.repcat$_repobject
/
DROP TABLE system.repcat$_repschema
/
DROP TABLE system.repcat$_repcat
/
---
--- RepCat Views
---
DROP VIEW repcat_repcat
/
DROP VIEW user_repcat
/
DROP VIEW all_repcat
/
DROP VIEW dba_repcat
/
DROP VIEW user_repgroup
/
DROP VIEW all_repgroup
/
DROP VIEW dba_repgroup
/
DROP VIEW user_repdestination
/
DROP VIEW all_repdestination
/
DROP VIEW dba_repdestination
/
DROP VIEW repcat_repschema
/
DROP VIEW user_repschema
/
DROP VIEW all_repschema
/
DROP VIEW dba_repschema
/
DROP VIEW repcat_repobject
/
DROP VIEW user_repobject
/
DROP VIEW all_repobject
/
DROP VIEW dba_repobject
/
DROP VIEW repcat_generated
/
DROP VIEW user_repgenerated
/
DROP VIEW all_repgenerated
/
DROP VIEW dba_repgenerated;
/
DROP VIEW repcat_repprop
/
DROP VIEW user_repprop
/
DROP VIEW all_repprop
/
DROP VIEW dba_repprop
/
DROP VIEW repcat_repcatlog
/
DROP VIEW user_repcatlog
/
DROP VIEW all_repcatlog
/
DROP VIEW dba_repcatlog
/
DROP VIEW user_repkey_columns
/
DROP VIEW all_repkey_columns
/
DROP VIEW dba_repkey_columns
/
DROP VIEW user_repddl
/
DROP VIEW all_repddl
/
DROP VIEW dba_repddl
/
DROP VIEW dba_reppriority
/
DROP VIEW all_reppriority
/
DROP VIEW user_reppriority
/
DROP VIEW dba_reppriority_group
/
DROP VIEW all_reppriority_group
/
DROP VIEW user_reppriority_group
/
DROP VIEW dba_repcolumn_group
/
DROP VIEW all_repcolumn_group
/
DROP VIEW user_repcolumn_group
/
DROP VIEW dba_repgrouped_column
/
DROP VIEW all_repgrouped_column
/
DROP VIEW user_repgrouped_column
/
DROP VIEW dba_repconflict
/
DROP VIEW all_repconflict
/
DROP VIEW user_repconflict
/
DROP VIEW dba_represolution_method
/
DROP VIEW all_represolution_method
/
DROP VIEW user_represolution_method
/
DROP VIEW dba_represolution
/
DROP VIEW all_represolution
/
DROP VIEW user_represolution
/
DROP VIEW dba_represolution_statistics
/
DROP VIEW all_represolution_statistics
/
DROP VIEW user_represolution_statistics
/
DROP VIEW dba_represol_stats_control
/
DROP VIEW all_represol_stats_control
/
DROP VIEW user_represol_stats_control
/
DROP VIEW dba_repparameter_column
/
DROP VIEW all_repparameter_column
/
DROP VIEW user_repparameter_column
/
DROP VIEW dba_repaudit_attribute
/
DROP VIEW all_repaudit_attribute
/
DROP VIEW user_repaudit_attribute
/
DROP VIEW dba_repaudit_column
/
DROP VIEW all_repaudit_column
/
DROP VIEW user_repaudit_column
/
---
--- RepCat Synonyms
---
DROP PUBLIC SYNONYM USER_REPCAT;
DROP PUBLIC SYNONYM ALL_REPCAT;
DROP PUBLIC SYNONYM USER_REPGROUP;
DROP PUBLIC SYNONYM ALL_REPGROUP;
DROP PUBLIC SYNONYM USER_REPDESTINATION;
DROP PUBLIC SYNONYM ALL_REPDESTINATION;
DROP PUBLIC SYNONYM USER_REPSCHEMA;
DROP PUBLIC SYNONYM ALL_REPSCHEMA;
DROP PUBLIC SYNONYM USER_REPOBJECT;
DROP PUBLIC SYNONYM ALL_REPOBJECT;
DROP PUBLIC SYNONYM USER_REPPROP;
DROP PUBLIC SYNONYM ALL_REPPROP;
DROP PUBLIC SYNONYM USER_REPKEY_COLUMNS;
DROP PUBLIC SYNONYM ALL_REPKEY_COLUMNS;
DROP PUBLIC SYNONYM USER_REPGENERATED;
DROP PUBLIC SYNONYM ALL_REPGENERATED;
DROP PUBLIC SYNONYM USER_REPCATLOG;
DROP PUBLIC SYNONYM ALL_REPCATLOG;
DROP PUBLIC SYNONYM USER_REPDDL;
DROP PUBLIC SYNONYM ALL_REPDDL;
DROP PUBLIC SYNONYM all_reppriority_group;
DROP PUBLIC SYNONYM user_reppriority_group;
DROP PUBLIC SYNONYM all_reppriority;
DROP PUBLIC SYNONYM user_reppriority;
DROP PUBLIC SYNONYM all_repcolumn_group;
DROP PUBLIC SYNONYM user_repcolumn_group;
DROP PUBLIC SYNONYM all_repgrouped_column;
DROP PUBLIC SYNONYM user_repgrouped_column;
DROP PUBLIC SYNONYM all_repconflict;
DROP PUBLIC SYNONYM user_repconflict;
DROP PUBLIC SYNONYM all_represolution_method;
DROP PUBLIC SYNONYM user_represolution_method;
DROP PUBLIC SYNONYM all_represolution;
DROP PUBLIC SYNONYM user_represolution;
DROP PUBLIC SYNONYM all_represolution_statistics;
DROP PUBLIC SYNONYM user_represolution_statistics;
DROP PUBLIC SYNONYM all_represol_stats_control;
DROP PUBLIC SYNONYM user_represol_stats_control;
DROP PUBLIC SYNONYM all_repparameter_column;
DROP PUBLIC SYNONYM user_repparameter_column;
DROP PUBLIC SYNONYM all_repaudit_attribute;
DROP PUBLIC SYNONYM user_repaudit_attribute;
DROP PUBLIC SYNONYM all_repaudit_column;
DROP PUBLIC SYNONYM user_repaudit_column;
/
---
--- RepCat Sequences
---
DROP SEQUENCE system.repcat_log_sequence;
/
---
--- Deferred RPC Packages
---
DROP PACKAGE dbms_repcat;
DROP PACKAGE dbms_repcat_auth;
DROP PACKAGE dbms_repcat_admin;
DROP PACKAGE dbms_repcat_mas;
DROP PACKAGE dbms_repcat_sna;
DROP PACKAGE dbms_repcat_sna_utl;
DROP PACKAGE dbms_repcat_utl;
DROP PACKAGE dbms_repcat_utl2;
DROP PACKAGE dbms_repcat_utl3;
DROP PACKAGE dbms_repcat_conf;
DROP PACKAGE dbmsobjgwrapper;
DROP PACKAGE system.dbms_repcat_auth;
/
---
--- Deferred RPC Tables
---
DROP TABLE system.def$_defaultdest 
/
DROP TABLE system.def$_calldest
/
DROP TABLE system.def$_destination
/
DROP TABLE system.def$_error
/
DROP TABLE system.def$_call
/
---
--- Deferred RPC Views
---
DROP VIEW def$_tran;
DROP VIEW defschedule;
DROP VIEW deferror;
DROP VIEW deferrcount;
DROP VIEW deftran;
DROP VIEW defcalldest;
DROP VIEW deftrandest;
DROP VIEW defcall;
DROP VIEW defdefaultdest;
/
---
--- Deferred RPC Synonyms
---
DROP SYNONYM def$_call;
DROP SYNONYM def$_calldest;
DROP SYNONYM def$_schedule;
DROP SYNONYM def$_error;
DROP SYNONYM def$_defaultdest;
/
---
--- Deferred RPC Sequences
---
/
---
--- Deferred RPC Packages
---
DROP PACKAGE dbms_defer;
DROP PACKAGE dbms_defer_query;
DROP PACKAGE dbms_defer_sys;
DROP PACKAGE dbms_defer_pack;
DROP PACKAGE dbms_asyncrpc;
DROP PACKAGE dbms_defer_sys_part1;
DROP PACKAGE dbms_defer_internal_sys;
DROP PACKAGE dbms_defer_repcat;
DROP PACKAGE dbms_defer_import_internal;
/
