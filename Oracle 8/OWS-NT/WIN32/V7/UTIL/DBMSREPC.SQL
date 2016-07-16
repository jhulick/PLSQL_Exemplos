rem 
rem $Header: dbmsrepc.sql,v 1.16 1995/11/22 14:19:35 sjain Exp $ 
rem 
Rem  Copyright (c) Oracle Corporation 1994.  All Rights Reserved.
Rem    NAME
Rem      dbmsrepc.sql - replication catalog (repcat) packages
Rem
Rem    DESCRIPTION
Rem      The following packages are located in this file:
Rem        dbms_repcat - the main package, which is a cover for the 
Rem                      implementation packages
Rem        dbms_repcat_auth - avoid a clique of SYS links between masters
Rem        dbms_repcat_admin - grant/revoke privileges to a replication
Rem                            administrator to facilitate usage of repcat
Rem
Rem    NOTES
Rem 
Rem      The procedural option is needed to use this facility.
Rem
Rem      This packages are installed by sys (connect internal).
Rem
Rem      The repcat tables are defined in catrep.sql and owned by system.
Rem
Rem    DEPENDENCIES
Rem      
Rem    USAGE
Rem
Rem    SECURITY
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     sjain      11/22/95 -  Add comment_on_repgroup
Rem     sjain      11/16/95 -  Change repgroup to repsites
Rem     boki       10/02/95 -  BUG#303555:add new exception
Rem     hasun      09/22/95 -  Add comment_on_repgroup() for snapshot sites
Rem     hasun      08/18/95 -  merge changes from branch 1.3.720.6
Rem     hasun      07/30/95 -  Add "execute any procedure" privilege to
Rem                            grant_admin_any_repschema()
Rem     hasun/     07/30/95 -  Unify sync security model with async:
Rem     ldoo                   Add gen_objs_owner parameter to let users
Rem                            specify the owner of generated objects
Rem     hasun      06/06/95 -  BUG#284808: Add execute_as_user parameter
Rem     hasun      05/16/95 -  Add support for connection qualifiers
Rem     hasun      03/23/95 -  Fix incorrect comments
Rem     hasun      03/20/95 -  Change RepCat for SYNC Replication
Rem     hasun      03/08/95 -  Fix merge conflicts
Rem     hasun      01/23/95 -  Modify API for Rep3 - Object Groups
Rem     jstamos    01/23/95 -  merge changes from branch 1.3.720.4
Rem     jstamos    12/23/94 -  merge changes from branch 1.3.720.1&2&3
Rem     adowning   06/14/94 -  latest revision from repint
Rem     adowning   05/19/94 -  Make spec public
Rem     adowning   02/04/94 -  Branch_for_patch
Rem     adowning   02/04/94 -  Creation
Rem

REM  ***********************************************************************
REM  THESE PACKAGES AND PACKAGE BODIES MUST NOT BE MODIFIED BY THE CUSTOMER.
REM  DOING SO COULD CAUSE INTERNAL ERRORS AND CORRUPTIONS IN THE RDBMS.
REM  ***********************************************************************

REM  ************************************************************
REM  THESE PACKAGES AND PACKAGE BODIES MUST BE CREATED UNDER SYS.
REM  ************************************************************

CREATE OR REPLACE PACKAGE dbms_repcat AS

  -------------------------
  -- OVERVIEW
  --
  -- This package provides routines to administer and update the replication
  -- catalog.  An alternative would be to invent SQL DDL syntax.

  -----------
  -- SECURITY
  --

  --------
  -- TYPES
  --
  -- allow room for quotes in columns
  TYPE varchar2s IS TABLE OF VARCHAR(60) INDEX BY BINARY_INTEGER;

  ------------
  -- CONSTANTS
  --

  -------------
  -- EXCEPTIONS
  --
  missingschema EXCEPTION;
  PRAGMA exception_init(missingschema, -23306);
  missschema_num NUMBER := -23306;

  duplicateschema EXCEPTION;
  PRAGMA exception_init(duplicateschema, -23307);
  duplschema_num NUMBER := -23307;

  missingobject EXCEPTION;
  PRAGMA exception_init(missingobject, -23308);
  missobj_num NUMBER := -23308;

  duplicateobject EXCEPTION;
  PRAGMA exception_init(duplicateobject, -23309);
  duplobj_num NUMBER := -23309;

  notquiesced EXCEPTION;
  PRAGMA exception_init(notquiesced, -23310);
  notquiesced_num NUMBER := -23310;

  notnormal EXCEPTION;
  PRAGMA exception_init(notnormal, -23311);
  notnormal_num NUMBER := -23311;

  nonmasterdef EXCEPTION;
  PRAGMA exception_init(nonmasterdef, -23312);
  nonmasterdef_num NUMBER := -23312;

  nonmaster EXCEPTION;
  PRAGMA exception_init(nonmaster, -23313);
  nonmaster_num NUMBER := -23313;

  nonsnapshot EXCEPTION;
  PRAGMA exception_init(nonsnapshot, -23314);
  nonsnapshot_num NUMBER := -23314;

  version EXCEPTION;
  PRAGMA exception_init(version, -23315);
  version_num NUMBER := -23315;

  reconfigerror EXCEPTION;
  PRAGMA exception_init(reconfigerror, -23316);
  reconfig_num NUMBER := -23316;

  commfailure EXCEPTION;
  PRAGMA exception_init(commfailure, -23317);
  commfail_num NUMBER := -23317;

  ddlfailure EXCEPTION;
  PRAGMA exception_init(ddlfailure, -23318);
  ddlfail_num NUMBER := -23318;

  typefailure EXCEPTION;
  PRAGMA exception_init(typefailure, -23319);
  typefail_num NUMBER := -23319;

  corrupt EXCEPTION;
  PRAGMA exception_init(corrupt, -23320);
  corrupt_num NUMBER := -23320;

  -- numbers 2321 to 2327 already used
  badsnapname EXCEPTION;
  PRAGMA exception_init(badsnapname, -23328);
  badsnapname_num NUMBER := -23328;

  badsnapddl EXCEPTION;
  PRAGMA exception_init(badsnapddl, -23329);
  badsnapddl_num NUMBER := -23329;

  -- next available was 23353
  fullqueue EXCEPTION;
  PRAGMA exception_init(fullqueue, -23353);
  fullqueue_num NUMBER := -23353;

  misssnapobject EXCEPTION;
  PRAGMA exception_init(misssnapobject, -23355);
  misssnapobj_num NUMBER := -23355;

  invalidqualifier EXCEPTION;
  PRAGMA exception_init(invalidqualifier,-23378);
  invldqual_num NUMBER := -23378;

  qualifiertoolong EXCEPTION;
  PRAGMA exception_init(qualifiertoolong,-23379);
  qualtoolong_num NUMBER := -23379;

  invalidpropmode EXCEPTION;
  PRAGMA exception_init(invalidpropmode,-23380);
  invldpmode_num NUMBER := -23380;

  missingremoteobject EXCEPTION;
  PRAGMA exception_init(missingremoteobject, -23381);
  missrmtobj_num NUMBER := -23381;

  -- 
  -- Conflict Resolution exceptions
  --

  -- error message from deferred rpc applies equally well here
  paramtype EXCEPTION;
    PRAGMA exception_init(paramtype, -23325);
    paramtype_num NUMBER := -23325;

  duplicategroup EXCEPTION;
    PRAGMA exception_init(duplicategroup, -23330);
    dupgrp_num NUMBER := -23330;
   
  missinggroup EXCEPTION;
    PRAGMA exception_init(missinggroup, -23331);
    missgrp_num NUMBER := -23331;
   
  referenced EXCEPTION;
    PRAGMA exception_init(referenced, -23332);
    ref_num NUMBER := -23332;
  
  duplicatecolumn EXCEPTION;
    PRAGMA exception_init(duplicatecolumn, -23333);
    dupcol_num NUMBER := -23333;
  
  missingcolumn EXCEPTION;
    PRAGMA exception_init(missingcolumn, -23334);
    misscol_num NUMBER := -23334;
   
  duplicateprioritygroup EXCEPTION;
    PRAGMA exception_init(duplicateprioritygroup, -23335);
    duppriorgrp_num NUMBER := -23335;
   
  missingprioritygroup EXCEPTION;
    PRAGMA exception_init(missingprioritygroup, -23336);
    misspriorgrp_num NUMBER := -23336;
  
  missingvalue EXCEPTION;
    PRAGMA exception_init(missingvalue, -23337);
    missval_num NUMBER := -23337;
  
  duplicatevalue EXCEPTION;
    PRAGMA exception_init(duplicatevalue, -23338);
    dupval_num NUMBER := -23338;
  
  duplicateresolution EXCEPTION;
    PRAGMA exception_init(duplicateresolution, -23339);
    dupres_num NUMBER := -23339;
   
  invalidmethod EXCEPTION;
    PRAGMA exception_init(invalidmethod, -23340);
    badmeth_num NUMBER := -23340;
   
  missingfunction EXCEPTION;
    PRAGMA exception_init(missingfunction, -23341);
    missfunc_num NUMBER := -23341;
   
  invalidparameter EXCEPTION;
    PRAGMA exception_init(invalidparameter, -23342);
    badparam_num NUMBER := -23342;
   
  missingresolution EXCEPTION;
    PRAGMA exception_init(missingresolution, -23343);
    missres_num NUMBER := -23343;
  
  missingconstraint EXCEPTION;
    PRAGMA exception_init(missingconstraint, -23344);
    missconst_num NUMBER := -23344;

  statnotreg  EXCEPTION;
    PRAGMA exception_init(statnotreg, -23345);
    statnotreg_num NUMBER := -23345;

  onlyonesnap EXCEPTION;
    PRAGMA exception_init(onlyonesnap, -23360);
    onlyonesnap_num NUMBER := -23360;

  --
  -- Product factoring exceptions
  --

  norepoption EXCEPTION;
    PRAGMA exception_init(norepoption, -23364);
    norepoption_num NUMBER := -23364;

  ---
  --- Object Group exceptions
  ---

  missingrepgroup EXCEPTION;
    PRAGMA exception_init(missingrepgroup, -23373);
    missrepgrp_num NUMBER := -23373;

  duplicaterepgroup EXCEPTION;
    PRAGMA exception_init(duplicaterepgroup, -23374);
    duplrepgrp_num NUMBER := -23374;

  dbnotcompatible EXCEPTION;
    PRAGMA exception_init(dbnotcompatible, -23375);
    notcompat_num NUMBER := -23375;

  repnotcompatible EXCEPTION;
    PRAGMA exception_init(repnotcompatible, -23376);
    repcompat_num NUMBER := -23376;

  -------------
  -- PROCEDURES
  --

  PROCEDURE create_master_repgroup(gname          IN VARCHAR2,
                                   group_comment  IN VARCHAR2 := '',
                                   master_comment IN VARCHAR2 := '',
                                   qualifier      IN VARCHAR2 := '');
  -- Create a new, empty, quiesced master repgroup, making the local database
  -- the first replica and the masterdef. 
  --
  -- Exceptions:
  --   duplicateschema if the object group already exists as a repgroup.
  --   ddlfailure if there is a problem creating the rep$what_am_i package
  --     or package body.
  

  PROCEDURE create_master_repschema(sname          IN VARCHAR2,
                                    schema_comment IN VARCHAR2 := '',
                                    master_comment IN VARCHAR2 := '');
  -- OBSOLETE PROCEDURE: user create_master_repgroup()
  -- Create a new, empty, quiesced master repgroup, making the local database
  -- the first replica and the masterdef. The name of the object group 
  -- must be a schema which already exist locally as a database schema.
  --
  -- Exceptions:
  --   duplicateschema if the object group already exists as a repgroup.
  --   missingschema if the schema does not exist.
  --   ddlfailure if there is a problem creating the rep$what_am_i package
  --     or package body.

  PROCEDURE add_master_database(gname                IN VARCHAR2 := '',
                                master               IN VARCHAR2, 
                                use_existing_objects IN BOOLEAN := TRUE,
                                copy_rows            IN BOOLEAN := TRUE,
                                comment              IN VARCHAR2 := '',
                                propagation_mode     IN VARCHAR2
                                                           := 'ASYNCHRONOUS',
                                sname                IN VARCHAR2 := '');
  -- The given master database is added to the given master repgroup. The
  -- new database is initialized with a consistent copy of all of the
  -- contents of the repgroup at the given host database. So that the host
  -- database is consistent, all master repgroup replicas must have been
  -- quiesced with an earlier call to suspend_master_activity.
  -- 
  -- If a replicated object does not exist at the new master, the new
  -- master creates the object.  If copy_rows is TRUE, then it copies any
  -- contents from the masterdef site.
  -- 
  -- If a replicated object already exists at the new master, the situation
  -- is more complicated.  If use_existing_objects is FALSE, or if the
  -- object has the wrong type or "shape," the name conflict is recorded.
  -- On the contrary, if the object has the right name, type, and "shape,"
  -- and if use_existing_objects is TRUE, the object is reused.
  -- If copy_rows is TRUE, the contents of the two objects are compared
  -- piece by piece, and any discrepancies are rectified by using the
  -- contents of the masterdef's object.  A probabilistic comparison
  -- algorithm (such as one based on a checksum) may be used.  Such an
  -- algorithm never states that two objects with identical contents are
  -- different.
  -- 
  -- If prop_mode is "ASYNCHRONOUS", then the new site's repgroup propagation 
  -- mode will be asynchronous to all other masters, and all other masters
  -- will be asynchronous to it.  The replication trigger will be generated
  -- only at the new site (after the $RP was generated).
  --
  -- If prop_mode is "SYNCHRONOUS", then the new site's repgroup propagation 
  -- mode will be synchronous to all other masters, and all other masters
  -- will be synchronous to it.  The replication trigger will be generated
  -- at all master sites (after the $RP was generated at the new site only).
  --
  -- Because this procedure may use asynchronous activities, interim status
  -- and all asynchronous errors are recorded in the RepCat log. If the
  -- request completes successfully, the new master is added to all
  -- RepSchema views, and no mention of the request appears in the RepCat
  -- log.
  -- 
  -- Generated triggers and replication packages are regenerated at the 
  -- remaining sites.
  -- 
  -- Exceptions:
  --
  --   nonmasterdef if the invocation site is not the masterdef site.
  --   notquiesced if the replicated object group has not been suspended.
  --   duplicateschema if the group already exists as a repgroup at
  --     the given database.
  --    missingrepgroup if the object group does not exist as a repgroup at
  --     the given database.
  --   commfailure if the new master is not accessible.

  PROCEDURE remove_master_databases(gname       IN VARCHAR2 := '',
                                    master_list IN VARCHAR2,
                                    sname       IN VARCHAR2 := '');
  -- To handle the case where several masters are inaccessible and must be
  -- removed at one time, we provide a procedure that deletes a set of
  -- masters. Master_list is a comma-separated list of masters.
  -- Remove_master_databases does not require any removed database to be
  -- accessible.  The other masters must be accessible.
  -- 
  -- For example, suppose A is the masterdef site and sites B, C, D, and E
  -- are master sites for repschema R. If masters C and E become
  -- inaccessible and should no longer be masters, the following should
  -- be executed at site A:
  -- 
  --   -- remove C & E from RepGroup at A, B, & D
  --   remove_master_databases(`R', `C,E');
  -- 
  -- Generated triggers and replication packages are regenerated at the 
  -- remaining sites.
  -- 
  -- Exceptions:
  --   nonmasterdef if the invocation site is not the masterdef site.
  --   nonmaster if any of the given databases is not a master site.
  --   reconfigerror if any of the given databases is the masterdef site.
  --   commfailure if any remaining master is not accessible.

  PROCEDURE remove_master_databases(gname        IN VARCHAR2 := '',
                                    master_table IN dbms_utility.dblink_array,
                                    sname       IN VARCHAR2 := '');
  -- This overloads the preceding procedure and takes a table of masters
  -- instead of a comma-separated list. The preceding example may also be
  -- coded as follows:
  -- 
  -- master_table dbms_utility.dblink_array;
  -- ...
  -- master_table(1) := `C';
  -- master_table(2) := `E';
  -- remove_master_databases(`R', master_table);
  -- 
  -- Exceptions:
  --   nonmasterdef if the invocation site is not the masterdef site.
  --   nonmaster if any of the given databases is not a master site.
  --   reconfigerror if any of the given databases is the masterdef site.
  --   commfailure if any remaining master is not accessible.

  PROCEDURE create_master_repobject(sname               IN VARCHAR2,
                                    oname               IN VARCHAR2,
                                    type                IN VARCHAR2,
                                    use_existing_object IN BOOLEAN := TRUE,
                                    ddl_text            IN VARCHAR2 := NULL,
                                    comment             IN VARCHAR2 := '',
                                    retry               IN BOOLEAN := FALSE,
                                    copy_rows           IN BOOLEAN := TRUE,
                                    gname               IN VARCHAR2 := '');
  -- This procedure, which typically operates in an asynchronous fashion,
  -- requires that the replicated object group be quiesced with
  -- suspend_master_activity. It adds the given object name and type to the
  -- RepObject view at each repobject site. It optionally uses the given
  -- DDL text to create the object at the masterdef site. If no DDL text is
  -- given, the object must already exist at the masterdef site.  If retry
  -- is TRUE, it creates the object only at masters whose object status is
  -- not 'valid'.
  -- 
  -- If the object does not exist at a non-masterdef site, the site creates
  -- the object.  If copy_rows is TRUE, it then copies any contents from the
  -- masterdef site.
  -- 
  -- If the object already exists at a non-masterdef site, the situation is
  -- more complicated.  If use_existing_object is FALSE, or if the object has
  -- the wrong type or "shape," a duplicateobject exception is stored in the
  -- RepCat log. On the contrary, if the object has the right name, type,
  -- and "shape," and if use_existing_object is TRUE, the object is reused.
  -- If copy_rows is TRUE, the contents of the two objects are
  -- (probabilistically) compared piece by piece and any discrepancies are
  -- rectified by using the contents of the masterdef's object.
  -- 
  -- The RepCat log contains interim status and any asynchronous error
  -- messages generated by the request.
  -- 
  -- Exceptions:
  --   nonmasterdef if the invocation site is not the masterdef site.
  --   notquiesced if the replicated schema has not been suspended.
  --   duplicateobject if the given object already exists in the repschema
  --     and retry is FALSE, or if a name conflict occurs.
  --   missingobject if the given object does not exist and no DDL text is
  --     given, or if oname directly or indirectly refers to a remote object.
  --   typefailure if objects of the given type can not be replicated.
  --   ddlfailure if any DDL at the masterdef does not succeed.
  --   commfailure if any master is not accessible.

  PROCEDURE alter_master_propagation(gname        IN VARCHAR2,
                                     master       IN VARCHAR2,
                                     dblink_table IN dbms_utility.dblink_array,
                                     propagation_mode IN VARCHAR2 := 
                                                  'ASYNCHRONOUS',
                                     comment      IN VARCHAR2 := '');

  PROCEDURE alter_master_propagation(gname        IN VARCHAR2,
                                     master       IN VARCHAR2,
                                     dblink_list  IN VARCHAR2,
                                     propagation_mode IN VARCHAR2 := 
                                                  'ASYNCHRONOUS',
                                     comment      IN VARCHAR2 := '');
 --  This is a new call that modifies designated master's repprop for all the 
 --  objects in the repgroup sent to dblink destinations.  It must be called 
 --  at the masterdef.  alter_master_propagation requires the schema to be 
 --  quiesced.
 --
 --  This call does not regenerate any triggers.  generate_replication_triggers
 --  (for all generated objects) must be called to have any mode modifications
 --  take place. This call does not automatically regenerate triggers 
 --  because it is anticipated that several alter_master_propagation calls 
 --  for different designated masters.
 --
 --  Although repcat$_repprop is on an object basis, administration of
 --  propagation modes is on an object-group basis.
 --
 --  gname is the object group that is having its propagation mode modified.
 --  master is the master that is having its propagation mode modified.
 --  dblink is a list of database links at the specified master master that 
 --         are having their propagation mode altered.
 --  Propagation_mode can be "SYNCHRONOUS" or "ASYNCHRONOUS".
 --
 --  comment is the comment associated with the specified dblinks in the
  -- repprop tables.  
  -- 
  -- Exceptions: 
  -- non_masterdef if local site is not the masterdef site
  -- not_quiesced is local site is not quiesced
  -- type_failure an unknown propagation type was specified


  PROCEDURE set_columns(sname       IN VARCHAR2,
                        oname       IN VARCHAR2,
                        column_list IN VARCHAR2);
  -- If oname exists in the replicated schema as a table using column-level
  -- replication, record the set of columns to be used as the "primary key"
  -- for replication purposes.  Unlike true primary keys, these columns may
  -- contain NULLS.  The column_list parameter is a comma-separated list of
  -- column names.  Set_columns does not affect the generated PL/SQL until
  -- the next call to generate_replication_support on the given object.
  --
  -- Exceptions:
  --  nonmasterdef if the invocation site is not the masterdef site.
  --  missingobject if the given object does not exist as a table in the
  --    replicated schema awaiting column-level replication information.
  --  missingcolumn if any column is not in the table.

  PROCEDURE set_columns(sname        IN VARCHAR2,
                        oname        IN VARCHAR2,
                        column_table IN dbms_utility.name_array);
  -- This overloads the preceding procedure and takes a table of column names.

  PROCEDURE generate_replication_support(sname            IN VARCHAR2,
                                         oname            IN VARCHAR2,
                                         type             IN VARCHAR2,
                                         package_prefix   IN VARCHAR2 := NULL,
                                         procedure_prefix IN VARCHAR2 := NULL,
                                         distributed      IN BOOLEAN  := TRUE,
                                         gen_objs_owner   IN VARCHAR2 := NULL,
                                         gen_rep2_trigger IN BOOLEAN := FALSE);
  -- If the object exists in the replicated schema as a table using
  -- row/column-level replication, generate the row-level replication trigger
  -- and stored package. When row-level or column-level replication is used for
  -- an object, generate_replication_support should be called immediately after
  -- all calls to set_columns.
  --
  -- If the object exists in the replicated object group as a procedure, 
  -- generate the procedure wrapper using the given
  -- procedure prefix.  If the object exists in the object group as a
  -- package (body), generate the procedure wrappers
  -- using the given package and procedure prefixes.  In either case
  -- generate_replication_support should be called immediately after
  -- create_master_repobject or alter_master_repobject.
  --
  -- If distributed is TRUE, invoke the replication generator at each master.
  -- Otherwise, invoke it once at the masterdef and copy the results.
  -- Rep3 requires distributed generation.  Distributed can only be FALSE
  -- if compatibility mode is Rep2.
  --
  -- Parameter gen_objs_owner specifies the schema in which the generated
  -- replication trigger and trigger package or procedural wrapper should
  -- be installed. If this value if NULL, then the generated trigger and 
  -- trigger package or procedural wrapper will be installed in the schema
  -- specified by the sname parameter.
  --
  -- If gen_rep2_trigger is TRUE, then generate an additional Rep2 trigger.
  -- this trigger is extracted by Rep2 snapshot sites with Rep3 masters.
  --
  -- The generation of replication packages, triggers, and wrappers are now
  -- performed in a 2-phases in lock-step.  The lock-step is required because
  -- synchronous triggers require that the $RP packages have already been
  -- generated.  Similarly, package wrappers for procedural replication must
  -- be generated before the package body wrappers.  The 2-phases require an
  -- extra do_deferred_repcat_admin to be run at each master compared to
  -- the Rep2 version.
  --
  -- Exceptions:
  --   nonmasterdef if the invocation site is not the masterdef site.
  --   missingobject if the given object does not exist as a table in the
  --     replicated schema awaiting row/column-level replication information
  --     or as a procedure or package (body) awaiting wrapper generation.
  --   missingschema if specified owner of generated objects does not exist
  --   typefailure if the given type parameter is not supported.
  --   notquiesced if the replicated schema has not been suspended.
  --   commfailure if any master is not accessible.
  
  PROCEDURE generate_replication_package(sname            IN VARCHAR2,
                                         oname            IN VARCHAR2);
  -- generate_replication_package generates the 
  -- $RP package for a particular object at ALL masters.  This would 
  -- also generate the audit tables and conflict resolution packages
  -- without regenerating the triggers.
  --
  -- For global-asynch configurations, generate_replication_package can be
  -- combined with generate_replication_trigger to avoid the 2-phase
  -- generation.
  --
  -- The system must be quiesced.
  --
  -- Note: type must be TABLE.

  PROCEDURE generate_replication_trigger(sname            IN VARCHAR2,
                                         oname            IN VARCHAR2,
                                         gen_objs_owner   IN VARCHAR2 := NULL,
                                         gen_rep2_trigger IN BOOLEAN := FALSE);

  -- The system must be quiesced.  The procedure must be called at 
  -- the masterdef.  
  --
  -- It generates the $TP package and triggers for the specified particular 
  -- object at all masters.  
  -- 
  -- Parameter gen_objs_owner specifies the schema in which the generated
  -- replication trigger and trigger package or procedural wrapper should
  -- be installed. If this value if NULL, then the generated trigger and 
  -- trigger package or procedural wrapper will be installed in the schema
  -- specified by the sname parameter.
  --
  -- gen_rep2_trigger is only valid for tables which have Rep2 snapshots
  -- on them.  It generates a disabled Rep2-compatable trigger. 
  --
  -- Good in conjunction with generate_replication_package for asynch-only 
  -- configurations when adding replication support for a new replicated 
  -- 	object.
  -- 
  -- Do not call generate_replication_trigger without previously having
  -- called generate_replication_support or generate_replication_package
  -- for the same object.
  --
  -- Exceptions:
  --   missingschema if specified owner of generated objects does not exist

  PROCEDURE generate_replication_trigger(gname            IN VARCHAR2,
                                         master_list      IN VARCHAR2 := NULL,
                                         gen_objs_owner   IN VARCHAR2 := NULL);

  PROCEDURE generate_replication_trigger(gname            IN VARCHAR2,
                                         master_table     IN
                                                    dbms_utility.dblink_array,
                                         gen_objs_owner   IN VARCHAR2 := NULL);
  -- The system must be quiesced. The procedure must be called at the 
  -- masterdef.  
  -- 
  -- It generates the $TP package and triggers and procedural replication
  -- wrappers for all generated objects at the specified masters.  If the 
  -- master list is NULL, then all masters will be regenerated. 
  --
  -- Parameter gen_objs_owner specifies the schema in which the generated
  -- replication trigger and trigger package or procedural wrapper should
  -- be installed. If this value if NULL, then the generated trigger and 
  -- trigger package or procedural wrapper will be installed in the schema
  -- in which they currently reside.
  -- 
  -- This procedure will normally be called after calls to 
  -- alter_master_propagation.
  -- 
  -- Triggers that have synchronous destinations require that the $RP
  -- package for the oname is already generated at that site.  This lock-step
  -- generation is provided automatically if generate_replication_support
  -- or add_master_database is used to generate the triggers.
  --
  -- Exceptions:
  --   missingschema if specified owner of generated objects does not exist


  PROCEDURE alter_master_repobject(sname    IN VARCHAR2,
                                   oname    IN VARCHAR2, 
                                   type     IN VARCHAR2,
                                   ddl_text IN VARCHAR2,
                                   comment  IN VARCHAR2 := '',
                                   retry    IN BOOLEAN := FALSE);
  -- This procedure, which typically operates in an asynchronous fashion,
  -- requires that the replicated schema be quiesced with
  -- suspend_master_activity. The DDL is applied at the masterdef and is
  -- synchronously multicast to all masters. Each master (asynchronously)
  -- checks that the object exists locally and then applies the DDL to its
  -- replica.  If comment is not NULL, then each altered object's comment
  -- is updated.  If retry is TRUE, alter_master_repobject alters
  -- the object only at masters whose object status is not 'valid'.
  -- The RepCat log contains interim status and any asynchronous
  -- error messages generated by the request.
  -- 
  -- Local customization of individual replicas is outside the
  -- scope of RepCat.  Replication administrators should ensure that local
  -- customizations do not interfere with the global customizations done
  -- with alter_master_repobject. 
  -- 
  -- Exceptions:
  --   nonmasterdef if the invocation site is not the masterdef site.
  --   notquiesced if the replicated schema has not been suspended.
  --   missingobject if the given object does not exist.
  --   typefailure if the given type parameter is not supported.
  --   ddlfailure if any DDL at the masterdef does not succeed.
  --   commfailure if a master is not accessible.

  PROCEDURE drop_master_repobject(sname        IN VARCHAR2,
                                  oname        IN VARCHAR2, 
                                  type         IN VARCHAR2, 
                                  drop_objects IN BOOLEAN := FALSE);
  -- This procedure typically operates in an asynchronous fashion. It
  -- removes the given object name from the RepObject view at all sites,
  -- and optionally drops the object and dependent objects at all sites.
  -- The RepCat log contains interim status and any asynchronous error
  -- messages generated by the request.
  -- 
  -- Exceptions:
  --   nonmasterdef if the invocation site is not the masterdef site.
  --   missingobject if the given object does not exist.
  --   typefailure if the given type parameter is not supported.
  --   commfailure if a master is not accessible.

  PROCEDURE execute_DDL(gname       IN VARCHAR2 := '',
                        master_list IN VARCHAR2 := NULL,
                        ddl_text    IN VARCHAR2,
                        sname       IN VARCHAR2 := '');
  -- Master_list is a comma-separated list of masters. If NULL, it means
  -- all masters including the masterdef. The DDL is applied at the given
  -- set of masters. This is typically done asynchronously. The RepCat log
  -- contains interim status and any asynchronous error messages generated
  -- by the request.  Although the repgroup need not be quiesced when
  -- execute_DDL is invoked, an administrator may quiesce the group first.
  -- 
  -- Exceptions:
  --   nonmasterdef if the invocation site is not the masterdef site.
  --   nonmaster if any site is not a master.
  --   ddlfailure if any DDL at the masterdef does not succeed.
  --   commfailure if a master is not accessible.

  PROCEDURE execute_DDL(gname        IN VARCHAR2 := '',
                        master_table IN dbms_utility.dblink_array,
                        ddl_text     IN VARCHAR2,
                        sname        IN VARCHAR2 := '');
  -- This overloads the preceding procedure and takes a table of masters
  -- instead of a comma-separated list.
  -- 
  -- Exceptions:
  --   nonmasterdef if the invocation site is not the masterdef site.
  --   nonmaster if any site is not a master.
  --   ddlfailure if any DDL at the masterdef does not succeed.
  --   commfailure if a master is not accessible.

  PROCEDURE comment_on_repcat(gname   IN VARCHAR2 := '',
                              comment IN VARCHAR2,
                              sname   IN VARCHAR2 := '');
  -- Update the comment field for the given repgroup in RepCat.
  -- OBSOLETE. Use Comment on repgroup
  -- Exceptions:
  --
  --  nonmasterdef if the invocation site is not the masterdef site.
  --  commfailure if any master is not accessible.

  PROCEDURE comment_on_repgroup(gname   IN VARCHAR2 := '',
                              comment IN VARCHAR2,
                              sname   IN VARCHAR2 := '');
  -- Update the comment field for the given repgroup in RepCat.
  --
  -- Exceptions:
  --
  --  nonmasterdef if the invocation site is not the masterdef site.
  --  commfailure if any master is not accessible.

  PROCEDURE comment_on_repobject(sname   IN VARCHAR2,
                                 oname   IN VARCHAR2,
                                 type    IN VARCHAR2,
                                 comment IN VARCHAR2);
  -- Update the comment field for the given repobject in RepObject.
  --
  -- Exceptions:
  --
  --  nonmasterdef if the invocation site is not the masterdef site.
  --  missingobject if the given object does not exist.
  --  typefailure if the given type parameter is not supported.
  --  commfailure if any master is not accessible.

  PROCEDURE comment_on_repsites(gname   IN VARCHAR2,
                                master  IN VARCHAR,
                                comment IN VARCHAR2);
  -- Update the comment field for the given master in RepGroup.
  -- The group name must be registered locally as a replicated 
  -- master object group.
  -- Exceptions:
  --
  --  nonmasterdef if the invocation site is not the masterdef site.
  --  nonmaster if the given master is not a master.
  --  commfailure if any master is not accessible.

  PROCEDURE comment_on_repsites(gname   IN VARCHAR2,
                                comment IN VARCHAR2);
  -- Update the comment field for the given snapshot object group.
  -- The group name must be registered locally as a replicated 
  -- snapshot object group.
  -- Exceptions:
  --
  -- missingschema if the group name is not registered with RepCat
  -- nonsnapshot if the invocation site is not a snapshot site.
  
  PROCEDURE comment_on_repschema(sname   IN VARCHAR2,
                                 master  IN VARCHAR,
                                 comment IN VARCHAR2);
  -- OBSOLETE PROCEDURE: use comment_on_repsites
  -- Update the comment field for the given master in RepSchema.
  -- The schema name must exist locally as a database schema.
  -- Exceptions:
  --
  --  nonmasterdef if the invocation site is not the masterdef site.
  --  nonmaster if the given master is not a master.
  --  commfailure if any master is not accessible.

  PROCEDURE suspend_master_activity(gname           IN VARCHAR2 := '',
                                    execute_as_user IN BOOLEAN  := FALSE,
                                    sname           IN VARCHAR2 := '');
  -- The repgroup must be in normal operation when this procedure
  -- is called. It quiesces all activity at all master repgroup sites,
  -- disables deferred procedure calls, and processes all pending queued
  -- procedure calls. Each master remains in this state until
  -- resume_master_activity is invoked. Queued Deferred RPCs are pushed to 
  -- remote masters as the current session's user if execute_as_user is TRUE.
  -- 
  -- Several of the above administrative procedures (e.g. adding a master
  -- database) must first suspend activity. Administrators may wish to
  -- suspend activity and manually perform a distributed query and update
  -- on the replicas in order to restore equivalence in the event of an
  -- errant conflict resolution.
  -- 
  -- This procedure typically operates asynchronously at the masterdef and
  -- the masters. The RepCat log contains interim status.
  -- 
  -- Exceptions:
  --   nonmasterdef if the invocation site is not the masterdef site.
  --   notnormal if the replicated schema is not in normal operation.
  --   commfailure if any master is not accessible.

  PROCEDURE resume_master_activity(gname    IN VARCHAR2 := '',
                                   override IN BOOLEAN  := FALSE,
                                   sname    IN VARCHAR2 := '');
  -- The replicated object group must be quiescing or quiesced when this
  -- procedure is called. If override is TRUE, it ignores any pending
  -- RepCat administration requests and restores normal replication
  -- activity at each master as quickly as possible. If override is FALSE,
  -- it restores normal replication activity at each master only when there
  -- is no pending RepCat administration request for sname at that
  -- master.
  -- 
  -- Queued Deferred RPCs are pushed to remote masters as the current
  -- session's user if execute_as_user is TRUE.
  --
  -- Exceptions:
  --   nonmasterdef if the invocation site is not the masterdef site.
  --   notquiesced if the replicated schema is not quiescing or quiesced.
  --   commfailure if any master is not accessible.

  PROCEDURE drop_master_repgroup(gname         IN VARCHAR2,
                                 drop_contents IN BOOLEAN := FALSE,
                                 all_sites     IN BOOLEAN := FALSE);
  -- Drop the master repgroup and optionally all of its contents. If
  -- all_sites is TRUE and the invocation site is the masterdef,
  -- synchronously multicast the request to all masters.  In this case
  -- execution is immediate at the masterdef and possibly deferred at all
  -- other master sites. Note that this procedure may leave some dangling
  -- snapshots.
  -- 
  -- Exceptions:
  --   nonmaster if the invocation site is not a master site.
  --   nonmasterdef if the invocation site is not the masterdef and all_sites
  --     is TRUE.
  --   fullqueue if the deferred RPC queue has entries for the repgroup.
  --   commfailure if a master is not accessible and all_sites is TRUE.



  PROCEDURE drop_master_repschema(sname         IN VARCHAR2,
                                  drop_contents IN BOOLEAN := FALSE,
                                  all_sites     IN BOOLEAN := FALSE);
  -- OBSOLETE PROCEDURE: use drop_master_repgroup()
  -- Drop the master repgroup and optionally all of its contents. If
  -- all_sites is TRUE and the invocation site is the masterdef,
  -- synchronously multicast the request to all masters.  In this case
  -- execution is immediate at the masterdef and possibly deferred at all
  -- other master sites. Note that this procedure may leave some dangling
  -- snapshots.
  -- 
  -- Exceptions:
  --   nonmaster if the invocation site is not a master site.
  --   nonmasterdef if the invocation site is not the masterdef and all_sites
  --     is TRUE.
  --   fullqueue if the deferred RPC queue has entries for the repgroup.
  --   commfailure if a master is not accessible and all_sites is TRUE.

  PROCEDURE relocate_masterdef(gname                 IN VARCHAR2 := '',
                               old_masterdef         IN VARCHAR2, 
                               new_masterdef         IN VARCHAR2,
                               notify_masters        IN BOOLEAN := TRUE, 
                               include_old_masterdef IN BOOLEAN := TRUE,
                               sname                 IN VARCHAR2 := '');
  -- Move the masterdef designation from old_masterdef to new_masterdef.
  -- Old_masterdef must be the current masterdef, and new_masterdef must be
  -- a master. If notify_masters is TRUE, sychronously multicast the change
  -- to all masters (including old_masterdef only if include_old_masterdef
  -- is TRUE). If any master does not make the change, rollback the changes
  -- at all masters.
  -- 
  -- In a planned reconfiguration, relocate_masterdef should be invoked
  -- with notify_masters TRUE and include_old_masterdef TRUE. If just the
  -- masterdef fails, relocate_masterdef should be invoked with
  -- notify_masters TRUE and include_old_masterdef FALSE. If several
  -- masters and the masterdef fail, the administrator should invoke
  -- relocate_masterdef at each operational master with notify_masters FALSE.
  -- 
  -- Exceptions:
  --   nonmaster if new_masterdef is not a master site or if the invocation
  --     site is not a master site.
  --   nonmasterdef if old_masterdef is not the masterdef site.
  --   commfailure if a master is not accessible and notify_masters is TRUE.

  PROCEDURE purge_master_log(id     IN NATURAL,
                             source IN VARCHAR2,
                             gname  IN VARCHAR2 := '',
                             sname  IN VARCHAR2 := '');
  -- Remove all local log records corresponding to the request on a given
  -- replicated schema that originated at the given master with the given
  -- identification. If any parameter is NULL, treat it as a wildcard.
  -- 
  -- Exceptions:
  --   nonmaster if sname is not NULL and the invocation site is not a
  --     master site.

  PROCEDURE wait_master_log(gname        IN  VARCHAR2 := '',
                            record_count IN  NATURAL,
                            timeout      IN  NATURAL,
                            true_count   OUT NATURAL,
                            sname        IN  VARCHAR2 := '');
  -- Wait until either timeout seconds have passed or there are at most
  -- record_count records in the local RepCat log that represent administrative
  -- activities for the given replicated object group that have not completed.
  -- Activities that have completed with or without an error are not
  -- considered. The number of incomplete activities is returned in the
  -- parameter true_count.
  -- 
  -- If there are N masters and 1 masterdef for a replicated schema, most
  -- asynchronous administrative requests eventually create N+1 log records
  -- at the masterdef and 1 log record at each master.  Add_master_database
  -- is an exception and may create a log record at the masterdef and a log
  -- record at the new master for each object in the replicated schema.
  -- 
  -- Exceptions:
  --   nonmaster if the invocation site is not a master site.

  PROCEDURE do_deferred_repcat_admin(gname     IN VARCHAR2 := '',
                                     all_sites IN BOOLEAN := FALSE,
                                     sname     IN VARCHAR2 := '');
  -- Execute local outstanding deferred administrative procedures for the
  -- given replicated object group requested by the current user.  If all_sites
  -- is TRUE, do this at each master.
  -- 
  -- Exceptions:
  --   nonmaster if the invocation site is not a master site.
  --   commfailure if a master is not accessible and all_sites is TRUE.

  PROCEDURE repcat_import_check(gname  IN VARCHAR2 := '',
                                master IN BOOLEAN,
                                sname  IN VARCHAR2 := '');
  -- Update the object identifiers and status values in repcat$_repobject
  -- for the given repgroup, preserving object status values other than VALID.
  --
  -- Exceptions:
  --   missingschema if the replicated schema does not exist.
  --   nonmaster if master is TRUE and either the database is not a master or
  --      the database is not the expected database.
  --   nonsnapshot if master is FALSE and the database is not a snapshot site.
  --   missingobject if a valid replicated object in the schema does not exist.

  PROCEDURE repcat_import_check;
  -- Invoke repcat_import_check(gname) on each replicated schema
  --
  -- Exceptions:
  --   nonmaster if the database is not the expected database for any
  --     replicated object group.
  --   missingobject if a valid replicated object in any schema does not exist.

  PROCEDURE create_snapshot_repgroup(gname            IN VARCHAR2,
                                     master           IN VARCHAR2,
                                     comment          IN VARCHAR2 := '',
                                     propagation_mode IN VARCHAR2 
                                                         := 'ASYNCHRONOUS');
  -- Create a new empty snapshot repgroup and make the given database the
  -- master. The group name must be a master repgroup at the master
  -- database.
  --
  -- propagation_mode: This is the method of propagation for all updatable
  --   snapshots in the repgroup. Values are either SYNCHRONOUS or
  --   ASYNCHRONOUS.
  -- 
  -- Exceptions:
  --   duplicaterepgroup if the objectgroup already exists as a repgroup
  --     at the invocation site.
  --   nonmaster if the given database is not a master site.
  --   commfailure if the given database is not accessible.


  PROCEDURE create_snapshot_repschema(sname   IN VARCHAR2,
                                      master  IN VARCHAR2,
                                      comment IN VARCHAR2 := '');
  -- OBSOLETE PROCEDURE: use create_snapshot_repgroup()
  -- Create a new empty snapshot repgroup and make the given database the
  -- master. The schema name must be a master repgroup at the master
  -- database. In addition, the schema must also exist locally as a database
  -- schema.
  -- 
  -- Exceptions:
  --   duplicateschema if the schema already exists as a replicated schema
  --     at the invocation site.
  --   nonmaster if the given database is not a master site.
  --   commfailure if the given database is not accessible.

  PROCEDURE drop_snapshot_repgroup(gname         IN VARCHAR2,
                                   drop_contents IN BOOLEAN := FALSE);
  -- Drop the given snapshot repgroup and optionally all of its contents
  -- at this snapshot site. 
  -- 
  -- Exceptions:
  --   nonsnapshot if the invocation site is not a snapshot site.

  PROCEDURE drop_snapshot_repschema(sname         IN VARCHAR2,
                                    drop_contents IN BOOLEAN := FALSE);
  -- OBSOLETE PROCEDURE: use drop_snapshot_repgroup()
  -- Drop the given snapshot repgroup and optionally all of its contents
  -- at this snapshot site. In addition, the schema must also exist locally 
  -- as a database schema.
  -- 
  -- Exceptions:
  --   nonsnapshot if the invocation site is not a snapshot site.

  PROCEDURE refresh_snapshot_repgroup(gname                 IN VARCHAR2,
                                      drop_missing_contents IN BOOLEAN 
                                        := FALSE,
                                      refresh_snapshots     IN BOOLEAN 
                                        := FALSE,
                                      refresh_other_objects IN BOOLEAN 
                                        := FALSE,
                                      execute_as_user       IN BOOLEAN 
                                        := FALSE);
  -- Refresh the RepCat views for the given repgroup and optionally drop
  -- objects no longer in the repschema.  Consistently refresh the snapshots
  -- iff refresh_snapshots is TRUE.  Refresh the other objects if
  -- refresh_other_objects is TRUE. Deferred RPCs to the master site are
  -- pushed as the current session's user if execute_as_user is TRUE
  -- The value in gname must be an existing object group in the local database.
  --
  -- Exceptions:
  --   nonsnapshot if the invocation site is not a snapshot site.
  --   nonmaster if the master is no longer a master site.
  --   commfailure if the master is not accessible.

  PROCEDURE refresh_snapshot_repschema(sname                 IN VARCHAR2,
                                       drop_missing_contents IN BOOLEAN
                                         := FALSE,
                                       refresh_snapshots     IN BOOLEAN
                                         := FALSE,
                                       refresh_other_objects IN BOOLEAN
                                         := FALSE,
                                       execute_as_user       IN BOOLEAN 
                                         := FALSE);
  -- OBSOLETE PROCEDURE: use refresh_snapshot_repgroup()
  -- Refresh the RepCat views for the given repgroup and optionally drop
  -- objects no longer in the repschema.  Consistently refresh the snapshots
  -- iff refresh_snapshots is TRUE.  Refresh the other objects if
  -- refresh_other_objects is TRUE. Deferred RPCs to the master site are
  -- pushed as the current session's user if execute_as_user is TRUE
  -- The schema sname must exist as a schema in the local database
  --
  -- Exceptions:
  --   nonsnapshot if the invocation site is not a snapshot site.
  --   nonmaster if the master is no longer a master site.
  --   commfailure if the master is not accessible.

  PROCEDURE switch_snapshot_master(gname           IN VARCHAR2 := '',
                                   master          IN VARCHAR2,
                                   execute_as_user IN BOOLEAN  := FALSE,
                                   sname           IN VARCHAR2 := '');
  -- Change the master database of the snapshot repgroup to the given
  -- database. The new database must contain a replica of the master
  -- repgroup. Each snapshot in the local repgroup will be completely
  -- refreshed from the new master the next time it is refreshed.
  -- Will not work if snapshot query is > 32 K.
  -- 
  -- Deferred RPCs to the master site are pushed as the current session's
  -- user if execute_as_user is TRUE
  --
  -- Any snapshot logs should be created at all masters to avoid future 
  -- complete refreshes.
  --
  -- During creation, Snapshots names & onames should be the same.  
  -- Also, masters in snapshot defs should match repschema's snapshot master.
  -- 
  -- Exceptions:
  --   nonsnapshot if the invocation site is not a snapshot site.
  --   nonmaster if the given database is not a master site.
  --   commfailure if the given database is not accessible.

  PROCEDURE create_snapshot_repobject(sname          IN VARCHAR2,
                                      oname          IN VARCHAR2,
                                      type           IN VARCHAR2,
                                      ddl_text       IN VARCHAR2 := '',
                                      comment        IN VARCHAR2 := '',
                                      gname          IN VARCHAR2 := '',
                                      gen_objs_owner IN VARCHAR2 := '');
  -- Add the given object name and type to the RepObject view at the local
  -- snapshot repschema. The allowed types are `package', `package body',
  -- 'procedure', `snapshot', `synonym', and `view'.
  -- 
  -- For objects of type `snapshot', generate the row-level replication trigger
  -- and client-side half of the stored package if the underlying table
  -- uses row/column-level replication.  
  -- 
  -- ddl_text defines the snapshots.  The oname should match the snapshot
  -- name defined in the ddl_text.  The snaphot's master should match the
  -- master stored in all_repgroup (for switch_snapshot_masters to work).
  -- 
  -- gen_objs_owner indicates the schema in which the generated replication
  -- trigger and trigger package or procedural wrapper should be install.
  -- If this parameter is NULL, the value of the sname parameter is used.
  --
  -- Exceptions:
  --   missingschema if specified owner of generated objects does not exist
  --   nonsnapshot if the invocation site is not a snapshot site.
  --   nonmaster if the master is no longer a master site.
  --   misssnapobject if the given object does not exist at the master
  --   missingobject if the given object does not exist in the master's
  --     replicated schema.
  --   missingremoteobject if the master object has not yet generated
  --     replication support.
  --   duplicateobject if the given object already exists.
  --   typefailure if the type is not an allowable type.
  --   ddlfailure if the DDL does not succeed.
  --   commfailure if the master is not accessible.

  PROCEDURE generate_snapshot_support(sname          IN VARCHAR2,
                                      oname          IN VARCHAR2,
                                      type           IN VARCHAR2,
                                      gen_objs_owner IN VARCHAR2 := '');
  -- If the object exists in the replicated snapshot object group
  -- as an updatable snapshot using row/column-level replication, 
  -- generate the row-level replication trigger and stored package.   
  -- 
  -- If the object exists in the replicated object group as a procedure
  -- or package (body), then generate the appropriate wrappers.
  -- 
  -- Parameter gen_objs_owner specifies the schema in which the generated
  -- replication trigger and trigger package or wrapper should
  -- be installed. If this value if NULL, then the generated trigger and 
  -- trigger package or wrapper will be installed in the schema
  -- specified by the sname parameter.
  --
  -- Exceptions:
  --   nonsnapshot if the invocation site is not a snapshot site.
  --   missingobject if the given object does not exist as a snapshot in the
  --     replicated schema awaiting row/column-level replication information
  --     or as a procedure or package (body) awaiting wrapper generation.
  --   typefailure if the given type parameter is not supported.
  --   missingschema if specified owner of generated objects does not exist
  --   missingremoteobject if the master object has not yet generated
  --     replication support.
  --   commfailure if the master is not accessible

  PROCEDURE drop_snapshot_repobject(sname        IN VARCHAR2,
                                    oname        IN VARCHAR2, 
                                    type         IN VARCHAR2, 
                                    drop_objects IN BOOLEAN := FALSE);
  -- Remove the given object name from the local snapshot RepObject view,
  -- and optionally drop the object and dependent objects.
  -- 
  -- Exceptions:
  --   nonsnapshot if the invocation site is not a snapshot site.
  --   missingobject if the given object does not exist.
  --   typefailure if the given type parameter is not supported.

  PROCEDURE alter_snapshot_propagation(gname            IN VARCHAR2,
                                       propagation_mode IN VARCHAR2,
                                       comment          IN VARCHAR2 := '',
                                       execute_as_user  IN BOOLEAN  := FALSE);
  -- Alter the propagation method of all replication snapshots, procedure,
  -- packages, and package bodies for all snapshot repobjects in the
  -- specified snapshot repgroup.
  --
  -- Altering the replication support involve regenerating replication
  -- support at the snapshot site. When converting from asynchronous
  -- replication to synchronous replication, the deferred RPC queue is
  -- pushed before conversion.
  --
  -- Queued Deferred RPCs are pushed to remote masters as the current
  -- session's user if execute_as_user is TRUE.
  --
  -- EXCEPTIONS:
  --   notcompat: only databases operating in 7.3 (or later) mode can
  --   use this procedure.

  PROCEDURE tickle_job(canon_sname IN VARCHAR2,
                       start_now   IN BOOLEAN := FALSE);

  -- Start the background job for processing the group's repcatlog records,
  -- creating the job if necessary.  This procedure is normally called by
  -- repcat executing as the user, and is here only for privilege reasons.

  -------------
  -- CONFLICT RESOLUTION PROCEDURES
  --
  -- The following procedures are added to support automatic conflict 
  -- resolution.  Note that these procedures are available only on master 
  -- sites.  Conflict resolution is not available on snapshot sites.

 PROCEDURE define_column_group(sname IN VARCHAR2, 
                               oname IN VARCHAR2, 
                               column_group IN VARCHAR2, 
                               comment IN VARCHAR2 := NULL);
  -- Create a new column group for the given repobject.  Define_column_group 
  -- does not affect the generated PL/SQL until the next call to 
  --  generate_replication_support.
  --
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    oname: The name of the table being replicated.
  --    column_group: The name of the column group being defined. 
  --    comment: Comment text for the column group being defined. 
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    duplicategroup: if the given column group already exists for the 
  --                    repobject.
  --    missingobject: if the given repobject does not exist.

  PROCEDURE comment_on_column_group(sname IN VARCHAR2, 
                                    oname IN VARCHAR2, 
                                    column_group IN VARCHAR2, 
                                    comment IN VARCHAR2);

  -- Update the comment field for the given column group.
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    oname: The name of the table being replicated.
  --    column_group: The name of the column group.
  --    comment: Comment text for the column group being defined. 
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missinggroup: if the given column group does not exist.

  PROCEDURE drop_column_group(sname IN VARCHAR2, 
                              oname IN VARCHAR2, 
                              column_group IN VARCHAR2);
  -- Drop the given column group.  Drop_column_group does not affect the 
  -- PL/SQL until the next call to generate_replication_support.
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user.
  --    oname: The name of the table being replicated.
  --    column_group: The name of the column group.
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    referenced: if the given column group is being used in conflict 
  --                detection and resolution.
 
  PROCEDURE add_grouped_column(sname IN VARCHAR2,
                               oname IN VARCHAR2,
                               column_group IN VARCHAR2,
                               list_of_column_names IN VARCHAR2);
  PROCEDURE add_grouped_column(sname IN VARCHAR2, 
                               oname IN VARCHAR2,
                               column_group IN VARCHAR2,
                               list_of_column_names IN dbms_repcat.varchar2s);
  -- Assign a set of columns to the given column group.  Add_grouped_column 
  -- does not affect the generated PL/SQL until the next call to 
  -- generate_replication_support.
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.
  --           Defaults to invoking user.
  --    oname: The name of the table being replicated.
  --    column_group: The name of the column group.
  --    list_of_column_names: A list of columns being added to the column .
  --            group. The list can be a comma separated list of columns or
  --            a pl/sql table of columns.
  --            a '*' as the only entry in the list results in all the
  --            columns in the table being entered as part of the column group 
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    duplicatecolumn: if the given column already exists in the column group.
  --    missinggroup: if the given column group does not exist.
  --    missingcolumn: if the given column does not exist in the repobject.
  PROCEDURE make_column_group (sname                IN VARCHAR2,
                               oname                IN VARCHAR2,
                               column_group         IN VARCHAR2,
                               list_of_column_names IN VARCHAR2);
  PROCEDURE make_column_group (sname        IN VARCHAR2, 
                               oname        IN VARCHAR2,
                               column_group IN VARCHAR2,
                               list_of_column_names 
                                            IN dbms_repcat.varchar2s);
  -- do a combined define & add
 
  PROCEDURE drop_grouped_column(sname        IN VARCHAR2,
                                oname        IN VARCHAR2,
                                column_group IN VARCHAR2,
                                list_of_column_names 
                                             IN dbms_repcat.varchar2s);
 
  PROCEDURE drop_grouped_column(sname                IN VARCHAR2,
                                oname                IN VARCHAR2,
                                column_group         IN VARCHAR2,
                                list_of_column_names IN VARCHAR2);
  -- Remove a column from the given column group.  Drop_grouped_column does not 
  -- affect the generated PL/SQL until the next call to 
  -- generate_replication_support.
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.
  --           Defaults to invoking user.
  --    oname: The name of the table being replicated.
  --    column_group: The name of the column group.
  --    column_name: The name of  the column being added to the column group.
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missinggroup: if the given column group does not exist.

  PROCEDURE define_priority_group(gname        IN VARCHAR2 := '',
                                  pgroup       IN VARCHAR2,
                                  datatype     IN VARCHAR2,
                                  fixed_length IN INTEGER := NULL,
                                  comment      IN VARCHAR2 := NULL,
                                  sname        IN VARCHAR2 := '');
  -- Create a new priority group.  The name of the priority group must be 
  -- unique in a repschema.  The valid values of datatype are those, except 
  -- rowid, that are supported by Rep2.  Define_priority_group does not affect 
  -- the generated PL/SQL until the next call to generate_replication_support.  
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    pgroup: The name of the priority group being created.
  --    datatype: The datatype of value in the priority group being created.  
  --            Supported datatypes are: `CHAR', `VARCHAR2', `NUMBER', `DATE', 
  --            and `RAW'. 
  --    fixed_length: The fixed length for data of type CHAR.  
  --    comment: Comment text for the priority group being created.
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missingschema: if the given repschema does not exist.
  --    duplicateprioritygroup: if the given priority group already exists 
  --             in the repschema.
  --    typefailure: if the given datatype is not an allowable type.

  PROCEDURE comment_on_priority_group(gname   IN VARCHAR2 := '',
                                      pgroup  IN VARCHAR2, 
                                      comment IN VARCHAR2,
                                      sname   IN VARCHAR2 := '');
  -- Update the comment field for the given priority group.
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    pgroup: The name of the priority group.
  --    comment: Comment text for the priority group being created.
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missingprioritygroup: if the given priority group does not exist.

  PROCEDURE drop_priority_group(gname  IN VARCHAR2 := '',
                                pgroup IN VARCHAR2,
                                sname  IN VARCHAR2 := '');
  -- Drop the given priority group.  Drop_priority_group does not affect the 
  -- generated PL/SQL until the next call to generate_replication_support.  
  -- Users cannot drop a priority group if the priority group is still 
  -- referenced in any generated resolution packages.
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    pgroup: The name of the priority group.
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    referenced: if the given priority group is being used in conflict 
  --           resolution.

  PROCEDURE add_priority_char(gname    IN VARCHAR2 := '',
                              pgroup   IN VARCHAR2,
                              value    IN CHAR,
                              priority IN NUMBER,
                              sname    IN VARCHAR2 := '');
  PROCEDURE add_priority_varchar2(gname    IN VARCHAR2 := '',
                                  pgroup   IN VARCHAR2,
                                  value    IN VARCHAR2,
                                  priority IN NUMBER,
                                  sname    IN VARCHAR2 := '');
  PROCEDURE add_priority_number(gname    IN VARCHAR2 := '',
                                pgroup   IN VARCHAR2, 
                                value    IN NUMBER,
                                priority IN NUMBER,
                                sname    IN VARCHAR2 := '');
  PROCEDURE add_priority_date(gname    IN VARCHAR2 := '',
                              pgroup   IN VARCHAR2,
                              value    IN DATE,
                              priority IN NUMBER,
                              sname    IN VARCHAR2 := '');
  PROCEDURE add_priority_raw(gname    IN VARCHAR2 := '',
                             pgroup   IN VARCHAR2,
                             value    IN RAW,
                             priority IN NUMBER,
                             sname    IN VARCHAR2 := '');
  -- Add a new value to the given priority group.  The new value
  -- must be unique, and the priority must be unique.  The addition of this
  -- value becomes effective immediately.
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.
  --           Defaults to invoking user.
  --    pgroup: The name of the priority group.
  --    value: A new value for the priority group.
  --    priority: The priority for the new value.
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    duplicatevalue: if the given value already exists in the priority group.
  --    duplicatepriority: if the given priority already exists in the priority 
  --           group.
  --    missingprioritygroup: if the given priority group does not exist.
  --    typefailure: if the given value has an incorrect datatype for the
  --           priority group.

  PROCEDURE alter_priority_char(gname     IN VARCHAR2 := '',
                                pgroup    IN VARCHAR2,
                                old_value IN CHAR,
                                new_value IN CHAR,
                                sname     IN VARCHAR2 := '');
  PROCEDURE alter_priority_varchar2(gname     IN VARCHAR2 := '',
                                    pgroup    IN VARCHAR2,
                                    old_value IN VARCHAR2,
                                    new_value IN VARCHAR2,
                                    sname     IN VARCHAR2 := '');
  PROCEDURE alter_priority_number(gname     IN VARCHAR2 := '',
                                  pgroup    IN VARCHAR2,
                                  old_value IN NUMBER,
                                  new_value IN NUMBER,
                                  sname     IN VARCHAR2 := '');
  PROCEDURE alter_priority_raw(gname     IN VARCHAR2 := '',
                               pgroup    IN VARCHAR2,
                               old_value IN RAW,
                               new_value IN RAW,
                               sname     IN VARCHAR2 := '');
  PROCEDURE alter_priority_date(gname     IN VARCHAR2 := '',
                                pgroup    IN VARCHAR2,
                                old_value IN DATE,
                                new_value IN DATE,
                                sname     IN VARCHAR2 := '');
  -- Update the old value with the new value.  The new value must be unique.  
  -- The change in value becomes effective immediately.  
  -- Note that implicit conversion will work from many different
  -- data types into VARCHAR2.
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    pgroup: The name of the priority group.
  --    old_value: The old value to be altered.
  --    new_value: The new value. 
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    duplicatevalue: if the given new value already exists in the priority 
  --           group.
  --    missingprioritygroup: if the given priority group does not exist.
  --    typefailure: if the given value has an incorrect datatype for the 
  --           priority group.

  PROCEDURE alter_priority(gname        IN VARCHAR2 := '',
                           pgroup       IN VARCHAR2,
                           old_priority IN NUMBER,
                           new_priority IN NUMBER,
                           sname        IN VARCHAR2 := '');
  -- Update an old priority to a new priority. The new priority must be unique.
  -- The change in priority becomes effective immediately.  
  --
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    pgroup: The name of the priority group.
  --    old_priority: The priority to be altered.  
  --    new_priority:  The new priority.  
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    duplicatepriority: if the given new priority already exists in the 
  --           priority group.
  --    missingprioritygroup: if the given priority group does not exist.

  PROCEDURE drop_priority(gname        IN VARCHAR2 := '',
                          pgroup       IN VARCHAR2,
                          priority_num IN NUMBER,
                          sname        IN VARCHAR2 := '');
  -- Remove a value from the given priority group by priority.  
  -- The removal of this value becomes effective immediately.  
  --
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user.
  --    pgroup: The name of the priority group.
  --    priority: The priority for the value being dropped.  
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missingprioritygroup: if the given priority group does not exist.

  PROCEDURE drop_priority_number(gname  IN VARCHAR2 := '',
                                 pgroup IN VARCHAR2,
                                 value  IN NUMBER,
                                 sname  IN VARCHAR2 := '');
  PROCEDURE drop_priority_char(gname  IN VARCHAR2 := '',
                               pgroup IN VARCHAR2,
                               value  IN CHAR,
                               sname  IN VARCHAR2 := '');
  PROCEDURE drop_priority_varchar2(gname  IN VARCHAR2 := '',
                                   pgroup IN VARCHAR2,
                                   value  IN VARCHAR2,
                                   sname  IN VARCHAR2 := '');
  PROCEDURE drop_priority_date(gname  IN VARCHAR2 := '',
                               pgroup IN VARCHAR2,
                               value  IN DATE,
                               sname  IN VARCHAR2 := '');
  PROCEDURE drop_priority_raw (gname  IN VARCHAR2 := '',
                               pgroup IN VARCHAR2,
                               value  IN RAW,
                               sname  IN VARCHAR2 := '');
  -- Remove a value from the given priority group.  
  -- The removal of this value becomes effective immediately.  
  -- Note that implicit conversion will work from many different
  -- data types into VARCHAR2.
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user.
  --    pgroup: The name of the priority group.
  --    value: The value to be dropped
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missingprioritygroup: if the given priority group does not exist.
  --    typefailure: if the given value has an incorrect datatype for the 
  --           priority group.

  PROCEDURE define_site_priority(gname   IN VARCHAR2 := '',
                                 name    IN VARCHAR2,
                                 comment IN VARCHAR2 := NULL,
                                 sname   IN VARCHAR2 := '');
  -- Create a new site priority.  The site priority name must be unique in a 
  -- repschema.  Define_site_priority does not affect the generated PL/SQL 
  -- until the next call to generate_replication_support.  
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    name: The name of the site priority being created.
  --    comment: Comment text for the site priority being created.
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missingschema: if the given repschema does not exist.
  --    duplicatepriority: if the given site priority already exists in the 
  --           repschema.

  PROCEDURE comment_on_site_priority(gname   IN VARCHAR2 := '',
                                     name    IN VARCHAR2,
                                     comment IN VARCHAR2,
                                     sname   IN VARCHAR2 := '');
  -- Update the comment field for the given site priority.
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    name: The name of the site priority.
  --    comment: Comment text for the site priority being created.
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missingpriority: if the given site priority does not exist.

  PROCEDURE drop_site_priority(gname IN VARCHAR2 := '',
                               name  IN VARCHAR2,
                               sname IN VARCHAR2 := '');
  -- Drop the given site priority.  Drop_site_priority does not affect the 
  -- generated PL/SQL until the next call to generate_replication_support.  
  -- Users cannot drop a site priority if the site priority is still referenced 
  -- in any generated resolution packages.
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    name: The name of the site priority.
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    referenced: if the given site priority is being used in conflict 
  --           resolution.

  PROCEDURE add_site_priority_site(gname    IN VARCHAR2 := '',
                                   name     IN VARCHAR2,
                                   site     IN VARCHAR2,
                                   priority IN NUMBER,
                                   sname    IN VARCHAR2 := '');
  -- Add a new site to the given site priority.  The new site must be unique, 
  -- and the priority must be unique.  The addition of this site becomes 
  -- effective immediately.  
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.
  --           Defaults to invoking user. 
  --    name: The name of the site priority.
  --    site: A new site for the site priority.  The site value should come 
  --          from global_name view.  It must already be canonicalized.
  --    priority: The priority for the new site.  
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    duplicatesite: if the given site already exists in the site priority.
  --    duplicatepriority: if the given priority already exists in the site 
  --           priority.
  --    missingpriority if the given site priority does not exist.

  PROCEDURE alter_site_priority_site(gname    IN VARCHAR2 := '',
                                     name     IN VARCHAR2,
                                     old_site IN VARCHAR2,
                                     new_site IN VARCHAR2,
                                     sname    IN VARCHAR2 := '');
  -- Update the old site with the new site.  The new site must be unique.  
  -- The change in site becomes effective immediately.  
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    name: The name of the site priority.
  --    old_site: The old site to be altered.
  --    old_site: The new site. 
  -- Exceptions:
  --  nonmasterdef if the invocation site is not the masterdef site.
  --  duplicatesite if the given new site already exists in the site priority.
  --    missingpriority if the given site priority does not exist.

  PROCEDURE alter_site_priority(gname        IN VARCHAR2 := '',
                                name         IN VARCHAR2,
                                old_priority IN NUMBER,
                                new_priority IN NUMBER,
                                sname        IN VARCHAR2 := '');
  -- Update an old priority to a new priority. The new priority must be unique.
  -- The change in priority becomes effective immediately.  
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.
  --           Defaults to invoking user.
  --    name: The name of the site priority.
  --    old_priority: The priority to be altered.
  --    new_priority: The new priority.
  -- Exceptions:
  --  nonmasterdef if the invocation site is not the masterdef site.
  --  duplicatesite if the given new site already exists in the site priority.
  --    missingpriority if the given site priority does not exist.

  PROCEDURE drop_site_priority_site(gname IN VARCHAR2 := '',
                                    name  IN VARCHAR2,
                                    site  IN VARCHAR2,
                                    sname IN VARCHAR2 := '');
  -- Remove a site from the given site priority.  The removal of this site 
  -- becomes effective immediately.  
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    name: The name of the site priority.
  --    site: The site to be dropped.
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missingpriority: if the given site priority does not exist.

  PROCEDURE add_update_resolution(sname                 IN VARCHAR2,
                                  oname                 IN VARCHAR2,
                                  column_group          IN VARCHAR2,
                                  sequence_no           IN NUMBER,
                                  method                IN VARCHAR2,
                                  parameter_column_name 
                                            IN dbms_repcat.varchar2s,
                                  priority_group IN VARCHAR2 := NULL,
                                  function_name  IN VARCHAR2 := NULL,
                                  comment        IN VARCHAR2 := NULL);

  PROCEDURE add_update_resolution(sname                 IN VARCHAR2,
                                  oname                 IN VARCHAR2,
                                  column_group          IN VARCHAR2,
                                  sequence_no           IN NUMBER,
                                  method                IN VARCHAR2,
                                  parameter_column_name IN VARCHAR2,
                                  priority_group IN VARCHAR2 := NULL,
                                  function_name  IN VARCHAR2 := NULL,
                                  comment        IN VARCHAR2 := NULL);

  PROCEDURE add_delete_resolution(sname          IN VARCHAR2,
                                  oname          IN VARCHAR2,
                                  sequence_no    IN NUMBER,
                                  parameter_column_name 
                                            IN dbms_repcat.varchar2s,
                                  function_name  IN VARCHAR2,
                                  comment        IN VARCHAR2 := NULL);

  PROCEDURE add_delete_resolution(sname          IN VARCHAR2,
                                  oname          IN VARCHAR2,
                                  sequence_no    IN NUMBER,
                                  parameter_column_name IN VARCHAR2,
                                  function_name  IN VARCHAR2,
                                  comment        IN VARCHAR2      := NULL);


  PROCEDURE add_unique_resolution(sname           IN VARCHAR2,
                                  oname           IN VARCHAR2,
                                  constraint_name IN VARCHAR2,
                                  sequence_no     IN NUMBER,
                                  method          IN VARCHAR2, 
                                  parameter_column_name 
                                            IN dbms_repcat.varchar2s,
                                  function_name   IN VARCHAR2 := NULL,
                                  comment         IN VARCHAR2 := NULL);

  PROCEDURE add_unique_resolution(sname           IN VARCHAR2,
                                  oname           IN VARCHAR2,
                                  constraint_name IN VARCHAR2,
                                  sequence_no     IN NUMBER,
                                  method          IN VARCHAR2,
                                  parameter_column_name IN VARCHAR2,
                                  function_name   IN VARCHAR2 := NULL,
                                  comment         IN VARCHAR2 := NULL);

  -- Add a new conflict resolution for the given object.  
  -- Add_update_resolution does not affect the generated PL/SQL until the 
  -- next call to generate_replication_support on the given object.   
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    oname: The name of the table being replicated.
  --    column_group: name of the column_group
  --    sequence_no: A number which indicates the order conflict resolutions 
  --           are applied.  A smaller sequence number precedes a larger one.  
  --    method: The conflict resolution method. 
  --    parameter_column_name: An ordered list of columns to be used for 
  --           resolving the conflict.  May also be a comma-separated list.
  --            a '*' as the only entry in the list results in all the
  --            columns in the column group being entered in the alphebetical
  --            order (only applicable for 'user function'
  --    priority_group: If the method is `PRIORITY GROUP', enter the name of 
  --           priority group used for resolving the conflict.
  --    function_name: If the method is `USER FUNCTION', enter the user 
  --           resolution function name here.
  --    comment: Comment text for the conflict resolution being defined.
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missingobject: if the given object does not exist as a table in the 
  --           replicated schema awaiting replication information.
  --    duplicatesequence: if the sequence number already exists for the given 
  --           object.
  --    missingcolumn: if the given columns do not exist in the table.  
  --    missinggroup: if the given column group does not exist for the table.
  --    invalidmethod: if the given resolution method does not exist.
  --    invalidprioritygroup: if the given priority group does not exist.
  --    invalidparameter: if the given number of parameter columns is invalid.
  --    missingfunction: if the user function does not exist. 

  PROCEDURE comment_on_update_resolution(sname IN VARCHAR2,
                                         oname IN VARCHAR2,
                                         column_group IN VARCHAR2,
                                         sequence_no IN NUMBER,
                                         comment IN VARCHAR2);
  -- Update the comment field for the given update conflict resolution.   
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    oname: The name of the table being replicated.
  --    column_group: The name of the column group
  --    sequence_no: A number which indicates the order conflict resolutions 
  --           are applied.  A smaller sequence number precedes a larger one.  
  --    comment: Comment text for the conflict resolution being defined.
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missingobject: if the given object does not exist as a table in the 
  --           replicated schema awaiting replication information.
  --    missingresolution: if the given conflict resolution does not exist.

  PROCEDURE comment_on_delete_resolution(sname IN VARCHAR2,
                                         oname IN VARCHAR2,
                                         sequence_no IN NUMBER,
                                         comment IN VARCHAR2) ;
  -- Update the comment field for the given delete conflict resolution.  
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    oname: The name of the table being replicated.
  --    sequence_no: A number which indicates the order conflict resolutions 
  --           are applied.  A smaller sequence number precedes a larger one.  
  --    comment: Comment text for the conflict resolution being defined.
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missingobject: if the given object does not exist as a table in the 
  --           replicated schema awaiting replication information.
  --    missingresolution: if the given conflict resolution does not exist.

  PROCEDURE comment_on_unique_resolution(sname IN VARCHAR2,
                                         ONAME in VARCHAR2,
                                         constraint_name IN VARCHAR2,
                                         sequence_no IN NUMBER,
                                         comment IN VARCHAR2) ;
  -- Update the comment field for the given delete conflict resolution.
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.  
  --           Defaults to invoking user. 
  --    oname: The name of the table being replicated.
  --    constraint_name: The name of the unique constraint to be resolved.  
  --    sequence_no: A number which indicates the order conflict resolutions are 
  --           applied.  A smaller sequence number precedes a larger one.  
  --    comment: Comment text for the conflict resolution being defined.
  --    Update: the comment field for the given uniqueness conflict resolution.  
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missingobject: if the given object does not exist as a table in the 
  --           replicated schema awaiting replication information.
  --    missingresolution: if the given conflict resolution does not exist.

  PROCEDURE drop_update_resolution(sname IN VARCHAR2,
                                   oname IN VARCHAR2,
                                   column_group IN VARCHAR2,
                                   sequence_no IN NUMBER) ;

  -- Remove an update conflict resolution for the given object.    
  -- Drop_update_resolution does not affect the generated PL/SQL until the 
  -- next call to generate_replication_support on the given object.   
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.
  --           Defaults to invoking user.
  --    oname: The name of the table being replicated.
  --    column_group_name: enter column group name
  --    sequence_no: A number which indicates the order conflict resolutions 
  --           are applied.  A smaller sequence number precedes a larger one.  
  -- Exceptions:
  --    nonmasterdef: if the invocation site is not the masterdef site.
  --    missingobject: if the given object does not exist as a table in 
  --           the replicated schema awaiting replication information.

  PROCEDURE drop_delete_resolution(sname IN VARCHAR2,
                                   oname IN VARCHAR2,
                                   sequence_no IN NUMBER) ;
  -- Remove a delete conflict resolution for the given object.  
  -- Drop_delete_resolution does not affect the generated PL/SQL until 
  -- the next call to generate_replication_support on the given object.   
  -- Input Parameters:
  --     sname: The name of the schema containing the table to be replicated.  
  --            Defaults to invoking user. 
  --     oname: The name of the table being replicated.
  --     sequence_no: A number which indicates the order conflict resolutions 
  --            are applied.  A smaller sequence number precedes a larger one.  
  -- Exceptions:
  --     nonmasterdef: if the invocation site is not the masterdef site.
  --     missingobject: if the given object does not exist as a table in 
  --            the replicated schema awaiting replication information.

  PROCEDURE drop_unique_resolution(sname IN VARCHAR2,
                                   oname IN VARCHAR2,
                                   constraint_name IN VARCHAR2,
                                   sequence_no IN NUMBER) ;
  -- Remove a uniqueness conflict resolution for the given object.    
  -- Drop_unique_resolution does not affect the generated PL/SQL 
  -- until the next call to generate_replication_support on the given object.   
  -- Input Parameters:
  --     sname: The name of the schema containing the table to be replicated.  
  --            Defaults to invoking user.
  --     oname: The name of the table being replicated.
  --     constraint_name: The name of the unique constraint to be resolved.  
  --     sequence_no: A number which indicates the order conflict resolutions 
  --            are applied.  A smaller sequence number precedes a larger one.
  -- Exceptions:
  --     nonmasterdef: if the invocation site is not the masterdef site.
  --     missingobject: if the given object does not exist as a table in 
  --            the replicated schema awaiting replication information.

  PROCEDURE purge_statistics(sname      IN VARCHAR2,
                             oname      IN VARCHAR2,
                             start_date IN DATE,
                             end_date   IN DATE);
  -- Purge the collected statistics for the given range of date in which
  -- conflicts were resolved. 
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.
  --    oname: The name of the table being replicated.
  --    start_date: The start date of the given range.  If NULL, assume no
  --                start date.
  --    end_date: The end date of the given range.  If NULL, assume no end date.
 
  PROCEDURE register_statistics(sname IN VARCHAR2,
                                oname IN VARCHAR2);
  -- Enable the collection of conflict resolution statistics for the given
  -- replicated table.
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.
  --    oname: The name of the table being replicated.
 
  PROCEDURE cancel_statistics(sname IN VARCHAR2,
                              oname IN VARCHAR2);
  -- Cancel the collection of conflict resolution statistics for the given
  -- replicated table. 
  -- Input Parameters:
  --    sname: The name of the schema containing the table to be replicated.
  --    oname: The name of the table being replicated.

END dbms_repcat;
/

DROP PUBLIC SYNONYM dbms_repcat;
 
CREATE PUBLIC SYNONYM dbms_repcat for dbms_repcat;


CREATE OR REPLACE PACKAGE dbms_repcat_auth AS

  -- This package is separate from the other repcat packages to avoid
  -- deadlocks.

  PROCEDURE grant_surrogate_repcat(userid IN VARCHAR2);
  -- This procedure grants enough privileges and roles to the specified
  -- user and creates enough synonyms to let that user operate on behalf
  -- of repcat at this instance.  This avoids the need for a clique of
  -- SYS/SYS_PASSWORD dblinks.  These privileges and roles should not
  -- be granted to replication users.
  --
  -- Exceptions:
  --   ORA-01917 if the user does not exist.

  PROCEDURE revoke_surrogate_repcat(userid IN VARCHAR2);
  -- This procedure revokes all privileges and roles that would be
  -- granted to the specified user with grant_surrogate_repcat.
  -- It also drops any synonyms that would have been created.
  -- WARNING: identical privileges and roles that were granted
  -- independently of grant_surrogate_repcat will also be revoked.
  -- Identically named synonyms that were created independently of
  -- grant_surrogate_repcat will also be dropped.
  --
  -- Exceptions:
  --   ORA-01917 if the user does not exist.

END dbms_repcat_auth;
/


CREATE OR REPLACE PACKAGE dbms_repcat_admin AS

  -------------------------
  -- OVERVIEW
  --

  -- This package exports procedures that grant or revoke a set of
  -- privileges useful for administering replication on one or more
  -- local schemas.  The package body is included in this file to make
  -- the privileges apparent as well as to provide an example for
  -- sophisticated customers that want to implement similar functionality.
  --
  -- The following procedures can be customized by doing explicit
  -- GRANTS and REVOKES after the procedure is invoked if the canned
  -- privileges are insufficient or too powerful.  Any modification
  -- to these procedures will not be supported.

  -----------
  -- SECURITY
  -- 

  -- Because this package grants and revokes many powerful privileges,
  -- execute privileges on the package should not be granted widely.

  -------------
  -- PROCEDURES
  --

  PROCEDURE grant_admin_repschema(userid IN VARCHAR2);
  --- Note: This procedure is obsolete. Use grant_admin_repgroup()

  PROCEDURE grant_admin_repgroup(userid IN VARCHAR2);
  -- Grant enough privileges and roles to the specified user so that user
  -- can do typical repcat administration of a schema of the same
  -- name within a replication object group at this instance.  
  -- This procedure is appropriate when the instance
  -- is, or will be, a master site or a snapshot site for the replicated
  -- schema.
  --
  -- Exceptions:
  --   ORA-01917 if the user does not exist.

  PROCEDURE revoke_admin_repschema(userid IN VARCHAR2);
  --- Note: This procedure is obsolete. Use revoke_admin_repgroup()

  PROCEDURE revoke_admin_repgroup(userid IN VARCHAR2);
  -- If userid is SYS, this procedure has no effect.  Otherwise,
  -- this procedure revokes all privileges and roles that would be
  -- granted to the specified user with grant_admin_repgroup.
  -- WARNING: identical privileges and roles that were granted
  -- independently of grant_admin_repgroup will also be revoked.
  --
  -- Exceptions:
  --   ORA-01917 if the user does not exist.

  PROCEDURE grant_admin_any_repschema(userid IN VARCHAR2);
  --- Note: This procedure is obsolete. Use grant_admin_any_repgroup()

  PROCEDURE grant_admin_any_repgroup(userid IN VARCHAR2);
  -- Grant enough privileges and roles to the specified user so that user
  -- can do typical repcat administration of any object group at this
  -- instance.  This procedure is appropriate when the instance is, or
  -- will be, a master site and/or a snapshot site for object groups.
  --
  -- Exceptions:
  --   ORA-01917 if the user does not exist.

  PROCEDURE revoke_admin_any_repschema(userid IN VARCHAR2);
  --- Note: This procedure is obsolete. Use revoke_admin_any_repgroup()

  PROCEDURE revoke_admin_any_repgroup(userid IN VARCHAR2);
  -- If userid is SYS, this procedure has no effect.  Otherwise,
  -- this procedure revokes all privileges and roles that would be
  -- granted to the specified user with grant_admin_any_repgroup.
  -- WARNING: identical privileges and roles that were granted
  -- independently of grant_admin_any_repgroup will also be revoked.
  --
  -- Exceptions:
  --   ORA-01917 if the user does not exist.

END dbms_repcat_admin;
/


CREATE OR REPLACE PACKAGE BODY dbms_repcat_admin AS


  PROCEDURE do_sql(statement IN VARCHAR2,
                   resignal  IN BOOLEAN) IS
  -- Use dbms_sql to execute the parameter statement.
  -- Raise any exception if resignal is TRUE.

  sql_cursor NUMBER;
  dummy      NUMBER;

  BEGIN
    sql_cursor := dbms_sql.open_cursor;
    dbms_sql.parse(sql_cursor, statement, dbms_sql.v7);
    dummy := dbms_sql.execute(sql_cursor);
    dbms_sql.close_cursor(sql_cursor);
  EXCEPTION WHEN others THEN
    IF dbms_sql.is_open(sql_cursor) THEN
      dbms_sql.close_cursor(sql_cursor);
    END IF;
    IF resignal THEN RAISE;
    END IF;
  END do_sql;


  FUNCTION get_nls_substr(s      IN     VARCHAR2,
                          offset IN OUT NUMBER,
                          len    IN     NUMBER) RETURN VARCHAR2 IS
  -- Return the largest substring of s that begins at character offset offset,
  -- fits in len bytes, and does not split any characters.  The OUT value of
  -- offset points to the first character after the returned substring if it
  -- exists.  Otherwise, offset is larger than the length of s in characters.

  max_bytes_per_char CONSTANT NUMBER := 4;
  char_count                  INTEGER := len;
  excess                      NUMBER;

  BEGIN
    WHILE char_count > 0 LOOP
      excess := LENGTHB(SUBSTR(s, offset, char_count)) - len;
      IF excess <= 0 THEN EXIT;
      END IF;
      excess := excess/max_bytes_per_char;
      IF excess < 1 THEN excess := 1;        -- prevent looping
      END IF;
      char_count := char_count - excess;
    END LOOP;
  offset := offset + char_count;
  RETURN SUBSTR(s, offset-char_count, char_count);
  END get_nls_substr;


  PROCEDURE canonicalize(name       IN  VARCHAR2,
                         canon_name OUT VARCHAR2,
                         canon_len  IN  NUMBER) IS
  -- Canonicalize the string passed in as parameter name, determine the
  -- longest prefix that fits in canon_len bytes, and return the result in 
  -- canon_name.  Canonicalization is defined as follows.  If name is NULL,
  -- canon_name becomes NULL.  If name begins and ends with a double quote,
  -- remove both.  Otherwise, convert name to upper case with NLS_UPPER.

  name_length NUMBER;
  dummy       NUMBER := 1;

  BEGIN
    IF name is NULL THEN
      canon_name := NULL;
      RETURN;
    END IF;
    name_length := LENGTH(name);
    IF SUBSTR(name, 1, 1) = '"' AND SUBSTR(name, name_length, 1) = '"' THEN
      canon_name := get_nls_substr(SUBSTR(name, 2, name_length-2), dummy,
                                   canon_len);
    ELSE canon_name := get_nls_substr(NLS_UPPER(name), dummy, canon_len);
    END IF;
  END canonicalize;


  FUNCTION ensure_user_exists(userid IN VARCHAR2) RETURN VARCHAR2 IS
  -- Canonicalize userid.  If the user does not exist, raise ORA-01917.
  -- Otherwise, return the canonicalized form of userid.

  canon_user VARCHAR2(30);
  user_count NUMBER;

  BEGIN
    canonicalize(userid, canon_user, 30);
    SELECT COUNT(*) INTO user_count
      FROM DBA_USERS
      WHERE username = canon_user;
    IF user_count = 0 THEN
      -- raise an exception unless user created in the interim
      do_sql('GRANT CREATE SYNONYM TO "' || canon_user || '"', TRUE);
    END IF;
    RETURN canon_user;
  END ensure_user_exists;


  PROCEDURE grant_admin(userid   IN VARCHAR2,
                        multiple IN BOOLEAN,
                        grants   IN BOOLEAN) IS
  -- Grant/revoke the privileges and roles required to do typical repcat
  -- administration on one or all local repschemas.  The target is
  -- the user identified by userid.
  -- If multiple is TRUE, the privileges apply to any local repschema.
  -- Otherwise, the privileges apply to only the local repschema given
  -- by userid.
  -- If grants is TRUE, grant these privileges and roles.
  -- If grants is FALSE and the user is not SYS, revoke these privileges and
  -- roles.
  -- If grants is FALSE and the user is SYS, do nothing.

  canon_user VARCHAR2(38);
  verb       VARCHAR2(7);
  any_null   VARCHAR2(4);
  is_sys     BOOLEAN;

  BEGIN
    canon_user := ensure_user_exists(userid);
    is_sys := canon_user = 'SYS';

    -- avoid deadlocks and mistakes
    IF is_sys AND NOT grants THEN RETURN;
    END IF;

    IF multiple THEN
      any_null := 'ANY ';
    ELSE any_null := '';
    END IF;
    IF grants THEN
      verb := 'GRANT ';
      canon_user := ' TO "' || canon_user || '"';
    ELSE
      verb := 'REVOKE ';
      canon_user := ' FROM "' || canon_user || '"';
    END IF;
    do_sql(verb || 'CREATE SESSION' || canon_user, grants);
    do_sql(verb || 'ALTER SESSION' || canon_user, grants);
    IF NOT is_sys THEN
      IF multiple THEN
        do_sql(verb || 'EXECUTE ANY PROCEDURE' || canon_user, grants);
      ELSE
        do_sql(verb || 'EXECUTE ON SYS.DBMS_DEFER' || canon_user, grants);
        do_sql(verb || 'EXECUTE ON SYS.DBMS_DEFER_SYS' || canon_user, grants);
        do_sql(verb || 'EXECUTE ON SYS.DBMS_REPCAT' || canon_user, grants);
        do_sql(verb || 'EXECUTE ON SYS.DBMSOBJGWRAPPER' || canon_user, grants);
      END IF;
    END IF;
    do_sql(verb || 'UNLIMITED TABLESPACE' || canon_user, grants);

    IF multiple THEN
      do_sql(verb || 'DBA' || canon_user, grants);
      do_sql(verb || 'SELECT ANY TABLE' || canon_user, grants);
      do_sql(verb || 'INSERT ANY TABLE' || canon_user, grants);
      do_sql(verb || 'DELETE ANY TABLE' || canon_user, grants);
    END IF;

    do_sql(verb || 'CREATE ' || any_null || 'CLUSTER' || canon_user, grants);
    do_sql(verb || 'CREATE DATABASE LINK' || canon_user, grants);
    IF multiple THEN
      do_sql(verb || 'CREATE ANY INDEX' || canon_user, grants);
    END IF;
    do_sql(verb || 'CREATE ' || any_null || 'PROCEDURE' || canon_user, grants);
    do_sql(verb || 'CREATE ' || any_null || 'SEQUENCE' || canon_user, grants);
    do_sql(verb || 'CREATE ' || any_null || 'SNAPSHOT' || canon_user, grants);
    do_sql(verb || 'CREATE ' || any_null || 'SYNONYM' || canon_user, grants);
    do_sql(verb || 'CREATE ' || any_null || 'TABLE' || canon_user, grants);
    do_sql(verb || 'CREATE ' || any_null || 'TRIGGER' || canon_user, grants);
    do_sql(verb || 'CREATE ' || any_null || 'VIEW' || canon_user, grants);

    IF multiple THEN
      do_sql(verb || 'DROP ANY CLUSTER' || canon_user, grants);
      do_sql(verb || 'DROP ANY INDEX' || canon_user, grants);
      do_sql(verb || 'DROP ANY PROCEDURE' || canon_user, grants);
      do_sql(verb || 'DROP ANY SEQUENCE' || canon_user, grants);
      do_sql(verb || 'DROP ANY SYNONYM' || canon_user, grants);
      do_sql(verb || 'DROP ANY SNAPSHOT' || canon_user, grants);
      do_sql(verb || 'DROP ANY TABLE' || canon_user, grants);
      do_sql(verb || 'DROP ANY TRIGGER' || canon_user, grants);
      do_sql(verb || 'DROP ANY VIEW' || canon_user, grants);
    END IF;

    IF multiple THEN
      do_sql(verb || 'ALTER ANY CLUSTER' || canon_user, grants);
      do_sql(verb || 'ALTER ANY INDEX' || canon_user, grants);
      do_sql(verb || 'ALTER ANY PROCEDURE' || canon_user, grants);
      do_sql(verb || 'ALTER ANY SEQUENCE' || canon_user, grants);
      do_sql(verb || 'ALTER ANY SNAPSHOT' || canon_user, grants);
      do_sql(verb || 'ALTER ANY TABLE' || canon_user, grants);
      do_sql(verb || 'ALTER ANY TRIGGER' || canon_user, grants);
    END IF;

  END grant_admin;


  --------
  -- PACKAGE EXTERNAL PROCEDURES
  --

  PROCEDURE grant_admin_repgroup(userid IN VARCHAR2) IS
  BEGIN
    grant_admin(userid, FALSE, TRUE);
  END grant_admin_repgroup;
  PROCEDURE grant_admin_repschema(userid IN VARCHAR2) IS
  BEGIN
    grant_admin(userid, FALSE, TRUE);
  END grant_admin_repschema;


  PROCEDURE revoke_admin_repgroup(userid IN VARCHAR2) IS
  BEGIN
    grant_admin(userid, FALSE, FALSE);
  END revoke_admin_repgroup;
  PROCEDURE revoke_admin_repschema(userid IN VARCHAR2) IS
  BEGIN
    grant_admin(userid, FALSE, FALSE);
  END revoke_admin_repschema;


  PROCEDURE grant_admin_any_repgroup(userid IN VARCHAR2) IS
  BEGIN
    grant_admin(userid, TRUE, TRUE);
  END grant_admin_any_repgroup;
  PROCEDURE grant_admin_any_repschema(userid IN VARCHAR2) IS
  BEGIN
    grant_admin(userid, TRUE, TRUE);
  END grant_admin_any_repschema;


  PROCEDURE revoke_admin_any_repgroup(userid IN VARCHAR2) IS
  BEGIN
    grant_admin(userid, TRUE, FALSE);
  END revoke_admin_any_repgroup;
  PROCEDURE revoke_admin_any_repschema(userid IN VARCHAR2) IS
  BEGIN
    grant_admin(userid, TRUE, FALSE);
  END revoke_admin_any_repschema;

END dbms_repcat_admin;
/

DROP PUBLIC SYNONYM dbms_repcat_admin;

CREATE PUBLIC SYNONYM dbms_repcat_admin FOR dbms_repcat_admin;
