rem 
rem $Header: dbmsofln.sql,v 1.5 1995/11/07 15:36:07 boki Exp $ 
rem 
Rem
Rem    NAME
Rem
Rem      dbmsofln.sql - replication offline instantiation package spec
Rem
Rem    NOTES
Rem
Rem      The procedural option is needed to use this facility.
Rem
Rem      This package is installed by sys (connect internal).
Rem
Rem      The repcat tables are defined in catrep.sql and owned by system.
Rem
Rem    DEPENDENCIES
Rem
Rem      The object generator (dbmsobjg) and the replication procedure/trigger
Rem      generator (dbmsgen) must be previously loaded.
Rem
Rem      Uses dynamic SQL (dbmssql.sql) heavily.
Rem
Rem    USAGE
Rem
Rem    MESSAGES
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     boki       10/05/95 -  add exceptions 23361 and 23363 from repcat
Rem     boki       06/21/95 -  modify for object groups
Rem     boki       01/10/95 -  merge changes from branch 1.1.720.2
Rem     boki       01/09/95 -  merge changes from branch 1.1.710.3
Rem     adowning   12/23/94 -  merge changes from branch 1.1.720.1
Rem     boki       12/21/94 -  merge changes from branch 1.1.710.1
Rem     boki       01/06/95 -  Tech writer to add explanatory comments on use
Rem     boki       01/06/95 -  Tech writer to add more self-explanatory info
Rem     boki       12/02/94 -  Branch_for_patch
Rem     boki       12/02/94 -  Creation
Rem     boki       12/02/94 -  Creation
Rem     boki       10/28/94  -- Substantial modification of Sandeep's original
Rem                             specification.
Rem
---------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE dbms_offline_og AS

  -------------
  -- TYPE DEFINITIONS
  --
  TYPE SetOfSiteType IS TABLE OF VARCHAR2(256)
     INDEX BY BINARY_INTEGER;

  -------------
  -- EXCEPTIONS
  --

  badargument EXCEPTION;
    PRAGMA exception_init(badargument, -23430);
    badargument_num NUMBER := -23430;

  wrongstate EXCEPTION;
    PRAGMA exception_init(wrongstate, -23431);
    wrongstate_num NUMBER := -23431;

  sitealreadyexists EXCEPTION;
    PRAGMA exception_init(sitealreadyexists, -23432);
    sitealreadyexists_num NUMBER := -23432;

  wrongsite EXCEPTION;
    PRAGMA exception_init (wrongsite, -23433);
    wrongsite_num NUMBER := -23433;

  unknownsite EXCEPTION;
    PRAGMA exception_init (unknownsite, -23434);
    unknownsite_num NUMBER := -23434;


  -------------
  -- PROCEDURES
  --

  -------------------------------------------------------------------------
  -- Effects: This routine adds a new site "new_site" to the object group
  --   "gname."  It readies the new site for offline importation of the
  --   group's objects.  The state of the replicated object group must be
  --   QUIESCED before this routine is run; otherwise, an exception
  --   is raised. This routine must be run at the master definition site.
  --   Raises the following exceptions:
  --      badargument:  
  --            if "gname" or "new_site" is NULL or ''
  --      dbms_repcat.nonmasterdef:  
  --            if the site this routine is executing at is not the
  --            master def. site.
  --      sitealreadyexists: 
  --            if "new_site" is already a new master site
  --      wrongstate:
  --            if master def site is not in QUIESCED state
  --      dbms_repcat.missingrepgroup: 
  --            if "gname" does not name an object group
  --
  PROCEDURE begin_instantiation (gname     IN VARCHAR2,
                                 new_site  IN VARCHAR2);


  -------------------------------------------------------------------------
  -- Effects:  For the object group "gname" this routine resumes
  --   normal activity for all master sites except for the new site
  --   "new_site."  The state of the replicated object group at each site
  --   must be QUIESCED; otherwise, an exception is raised.  When this
  --   routine returns normally, all sites are in the NORMAL state except
  --   for the new site, which is still in the QUIESCED state.  This 
  --   routine disables propagation of the queues from all sites
  --   originally in the object group to the new site "new_site."  It
  --   is meant to prevent the pushing of the queues to the new site
  --   until the new site is instantiated.
  --   This routine must be executed at the master definition site.
  --   Raises the following exceptions:
  --      badargument:    
  --           if "gname" or "new_site" is NULL or ''
  --      dbms_repcat.nonmasterdef: 
  --           if the site this routine is executing at is not the
  --           master def. site.
  --      unknownsite: 
  --           "new_site" not known to object group
  --      wrongstate:  
  --          if master def site is not in QUIESCED state
  --      dbms_repcat.missingrepgroup:
  --          if "gname" does not name an object group
  --
  PROCEDURE resume_subset_of_masters (gname    IN VARCHAR2,
          	                      new_site In VARCHAR2);


  -------------------------------------------------------------------------
  -- Effects: For object group "gname" this routine integrates the site
  --   "new_site" into the set of existing sites.  When the routine returns
  --   normally, all sites can communicate with each other. 
  --   This routine re-enables propagation of the queues from all sites
  --   originally in the object group to the new site "new_site." 
  --   Applications may now push the queues to the new site, now that it is
  --   instantiated.  All sites in the object group are in the NORMAL state.
  --   This routine  must be executed at the master definition site.
  --   Raises the following exceptions:
  --      badargument: 
  --            if "gname" or "new_site" is NULL or ''
  --      dbms_repcat.nonmasterdef:
  --            if the site this routine is executing at is not the
  --            master def. site.
  --      unknownsite:
  --            site "new_site" is not known to schema "sname".
  --      wrongstate:  
  --            if master def site is not in NORMAL state
  --      dbms_repcat.missingrepgroup:
  --            if "gname" does not name an object group
  --
  PROCEDURE end_instantiation (gname    IN VARCHAR2,
		               new_site In VARCHAR2);

  -------------------------------------------------------------------------
  -- Effects: Starts the instantiation of the object group "gname" 
  --    at site "new_site." When this routine returns normally,
  --    this new site is readied for loading of user-defined tables.
  --    The site must be in the QUIESCED state when this routine is
  --    invoked; otherwise an exception is raised.  It disables
  --    propagation of the queues from the new site "new_site" to
  --    all sites originally in the object group.  This routine must
  --    be invoked at the new site.
  --    Raises the following exceptions:
  --      badargument: 
  --            if "gname" or "new_site" is null or ''
  --      wrongsite:
  --            routine is not executing against site "new_site"
  --      unknownsite: 
  --            "new_site" is an unknown master site
  --      wrongstate:
  --            if this site is not in QUIESCED state
  --      dbms_recpat.missingrepgroup:
  --            if "gname" does not name an object group
  --
  PROCEDURE begin_load (gname     IN VARCHAR2,
  	                new_site  IN VARCHAR2);

  -------------------------------------------------------------------------
  --  Effects:  This routine ends the instantiation of object group
  --    "gname" at site "new_site" and resumes normal activity.  The site
  --    must be in the NORMAL state; otherwise, an exception is raised.
  --    It re-enables propagation of the queues from the new site
  --    "new_site" to all the sites originally in the object group
  --    before the new site was added.  The object group is now ready
  --    for normal activity that, from now on, will involve the new
  --    site.
  --   Raises the following exceptions:
  --      badargument:    
  --           if "sname" or "new_site" is NULL or ''
  --      wrongsite: 
  --           routine is not executing against site "new_site"
  --      unknownsite:
  --           "new_site" is an unknown master site
  --      wrongstate: 
  --          if this site is not in NORMAL state
  --      dbms_repcat.missingrepgroup:
  --          if "gname" does not name an object group
  --
  PROCEDURE end_load (gname    IN VARCHAR2,
                      new_site IN VARCHAR2);

end;
/

---------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE dbms_offline_snapshot AS

  -------------
  -- Exceptions
  --

  badargument EXCEPTION;
    PRAGMA exception_init(badargument, -23430);
    badargument_num NUMBER := -23430;

  missingremotesnap EXCEPTION;
    PRAGMA exception_init(missingremotesnap, -23361);
    misremsnap_num NUMBER := -23361;

  snaptabmismatch EXCEPTION;
    PRAGMA exception_init(snaptabmismatch, -23363);
    snaptabmis_num NUMBER := -23363;

  -------------
  -- PROCEDURES
  --

  -------------------------------------------------------------------------
  -- Effects:  This routine creates the snapshot named "snapshot_oname" at
  --   in schema "snapshot_sname" that is in object group "gname."
  --   The snapshot is derived from a snapshot of the same name  at
  --   the master site "master_site" located in the same schema "sname." 
  --   When this routine returns normally, the snapshot site is readied
  --   for offline importation of the snapshot tables from the master site.
  --   "storage_c" may be specified by the user for indicating storage
  --   options for snapshot creation.  "comment" will be stored with
  --   the snapshot information.
  --   Raises the following exceptions:
  --      badargument:      
  --            if "gname," "sname," "master_site," 
  --            or "snapshot_oname" is NULL or ''.
  --      dbms_repcat.missingrepgroup:
  --            if "gname" does not name an object group
  --      missingremotesnap:
  --            if snapshot named "snapshot_oname" does not exist
  --            at remote master site "master_site"
  --      snaptabmismatch:  
  --            if the base table name of the snapshot at master site
  --            and snapshot site do not match.
  --      dbms_repcat.missingschema:
  --            if "snapshot_sname" is not a schema in the object group
  --            "gname"
  --
  PROCEDURE begin_load (gname               IN VARCHAR2, 
		        sname               IN VARCHAR2,
                        master_site         IN VARCHAR2,
                        snapshot_oname      IN VARCHAR2, 
                        storage_c           IN VARCHAR2 := '',
                        comment             IN VARCHAR2 := '');

  -------------------------------------------------------------------------
  --  Effects: This routine ends the instantiation of the snapshot
  --    "snapshot_oname" in schema "sname" of object group
  --    "gname."  This routine must be run at the snapshot site.
  --  Raises the following exceptions:
  --      badargument:  
  --            if "gname," "snapshot_oname," "snapshot_sname"
  --            is NULL or ''.
  --      dbms_repcat.missingrepgroup: 
  --            if "gname" does not name a valid object group.
  --      dbms_repcat.nonsnapshot:
  --            if site executing against is not a snapshot site
  -- 
  PROCEDURE end_load (gname            IN VARCHAR2,
		      sname            IN VARCHAR2,
		      snapshot_oname   IN VARCHAR2);

end;
/

 
