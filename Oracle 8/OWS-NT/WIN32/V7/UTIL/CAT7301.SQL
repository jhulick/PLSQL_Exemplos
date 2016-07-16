rem 
rem $Header: cat7301.sql,v 1.7 1995/05/31 16:46:01 msimon Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      cat7301.sql - upgrade Oracle RDBMS from version 7.2.X to 7.3
Rem    DESCRIPTION
Rem
Rem    RETURNS
Rem 
Rem    NOTES
Rem      Run this as INTERNAL.  Run it before installing catalog or pl/sql.
Rem      It is preferable to run it on 7.2.
Rem    MODIFIED   (MM/DD/YY)
Rem     msimon     05/31/95 -  Bug 282581 Make 7.3 sequences compatible with 7.2
Rem     rmarimon   04/06/95 -  Bug 110894: add column to dependency$ for EXPORT
Rem     hasun      03/22/95 -  Upgrade for Sync Replication
Rem     hasun      03/08/95 -  Fix merge conflicts
Rem     hasun      03/01/95 -  Add upgrade for Rep3: Object Groups
Rem     mramache   03/06/95 -  stored triggers
Rem     glumpkin   11/27/94 -  Creation
 
rem
rem  Histograms
rem
create cluster c_obj#_col#
( obj#            number,                                   /* object number */
  col#            number)                                   /* column number */
  pctfree 5
/
create index i_obj#_col# on cluster c_obj#_col#
/
create table histgrm$                                     /* histogram table */
( obj#            number not null,                          /* object number */
  col#            number not null,                          /* column number */
  row#            number not null,              /* row number (in row cache) */
  bucket          number not null,                          /* bucket number */
  endpoint        number not null)                  /* endpoint hashed value */
cluster c_obj#_col#(obj#, col#)
/
create table hist_head$                            /* histogram header table */
 (obj#            number not null,                          /* object number */
  col#            number not null,                          /* column number */
  bucket_cnt      number not null,                      /* number of buckets */
  row_cnt         number not null,           /* number of rows in histogram$ */
  cache_cnt       number not null,           /* number of rows in histogram$ */
  null_cnt        number,                  /* number of nulls in this column */
  timestamp       date,                   /* date of histogram's last update */
  sample_size     number,             /* for estimated stats, size of sample */
  minimum         number,           /* minimum value (if 1-bucket histogram) */
  maximum         number,           /* minimum value (if 1-bucket histogram) */
  spare1          number,                                           /* spare */
  spare2          number)                                           /* spare */
/

rem
rem Replication
rem

rem Add object group name to tables
ALTER TABLE system.repcat$_repcatlog ADD (gname VARCHAR2(30))
/
ALTER TABLE system.repcat$_repobject ADD (gname VARCHAR2(30))
/
ALTER TABLE system.def$_call ADD (groupname VARCHAR2(30))
/

rem Drop obsolete constraints
ALTER TABLE system.repcat$_repobject 
  DROP CONSTRAINT repcat$_repobject_prnt
/
ALTER TABLE system.repcat$_repprop 
  DROP CONSTRAINT repcat$_repprop_prnt2
/
ALTER TABLE system.repcat$_resolution 
  DROP CONSTRAINT repcat$_resolution_f2
/
ALTER TABLE system.repcat$_repobject
  DROP CONSTRAINT repcat$_repobject_type
/
ALTER TABLE system.repcat$_generated
  DROP CONSTRAINT repcat$_generated_obj
/
ALTER TABLE system.repcat$_repcatlog
  DROP CONSTRAINT repcat$_repcatlog_type
/
ALTER TABLE system.repcat$_repcatlog
  DROP CONSTRAINT repcat$_repcatlog_status
/
ALTER TABLE system.repcat$_repcatlog
  DROP CONSTRAINT repcat$_repcatlog_request
/


rem Add New constraints
ALTER TABLE system.repcat$_repobject 
  ADD CONSTRAINT repcat$_repobject_prnt FOREIGN KEY(gname)
      REFERENCES system.repcat$_repcat(sname)
      ON DELETE CASCADE
/
ALTER TABLE system.repcat$_repobject 
  ADD CONSTRAINT repcat$_repobject_type
      CHECK (type IN (-1, 1, 2, 4, 5, 7, 8, 9, 11, 12, -3))
/
ALTER TABLE system.repcat$_generated
  ADD CONSTRAINT repcat$_generated_obj
      CHECK (reason IN (0, 1, 2, 3, 4, 5, 6, 7))
/
ALTER TABLE system.repcat$_repcatlog
  ADD CONSTRAINT repcat$_repcatlog_request
      CHECK (request IN (-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11))
/
ALTER TABLE system.repcat$_repcatlog
  ADD CONSTRAINT repcat$_repcatlog_type
      CHECK (type IN (-1, 0, 1, 2, 4, 5, 7, 8, 9, 11, 12, -3))
/
ALTER TABLE system.repcat$_repcatlog
  ADD  CONSTRAINT repcat$_repcatlog_status
       CHECK (status IN (0, 1, 2, 3, 4))
/

rem Convert repschemas to object group
UPDATE system.repcat$_repobject SET gname=sname
/
UPDATE system.def$_call SET groupname=schemaname
  WHERE destination_list = 'R'
/

rem
rem Invalidate non-stored triggers so that they will be recompiled under
rem stored trigger release. Status has no meaning for triggers prior to
rem 7.3, so this can be done under 7.2 and earlier.
rem
update obj$ set status = 5 where type = 12
/

rem
rem Bug 110894 requires a d_owner# column be added to dependency$
rem to be used by EXPORT.  
rem The d_owner# is explicitly set to NOT NULL in the last statement to
rem cover the situation where an upgrade, followed by a downgrade and then
rem another upgrade occurs.  The downgrade script does not remove the
rem d_owner#, it merely allows NULLs to be inserted.  When this upgrade script
rem is run the second time, a non-fatal error will occur on the attempt to
rem add the existing d_owner# column and then it will be set to NOT NULL.

ALTER TABLE dependency$
   ADD (d_owner# number)
/
UPDATE dependency$ SET d_owner# =
    (SELECT owner# FROM obj$ 
     WHERE obj# = d_obj#)
/
ALTER TABLE dependency$
     MODIFY (d_owner# number CONSTRAINT n_d_owner# NOT NULL)
/	

rem
rem In release 7.2 and earlier it was possible for sequences with illegal
rem parameters to be created. The following statements clip any illegal 
rem parameters into the legal range. Nothing needs to be done for a downgrade
rem because the old code would not properly deal with illegal parameters
rem anyway so we are just playing safe in any case. The 7.3 code silently
rem clips illegal parameters into the legal range.
rem
rem Sequences with illegal hiwater marks will have the hiwater marks updated
rem in such a way that the sequence will be considered saturated - i.e.
rem incapable of generating any more values.
rem

update seq$
  set   MINVALUE = -99999999999999999999999999
  where MINVALUE < -99999999999999999999999999
/
update seq$
  set   MINVALUE = 9999999999999999999999999999
  where MINVALUE > 9999999999999999999999999999
/
update seq$
  set   MAXVALUE = -99999999999999999999999999
  where MAXVALUE < -99999999999999999999999999
/
update seq$
  set   MAXVALUE = 9999999999999999999999999999
  where MAXVALUE > 9999999999999999999999999999
/
update seq$
  set   INCREMENT$ = -99999999999999999999999999
  where INCREMENT$ < -99999999999999999999999999
/
update seq$
  set   INCREMENT$ = 9999999999999999999999999999
  where INCREMENT$ > 9999999999999999999999999999
/
update seq$
  set   CACHE = -99999999999999999999999999
  where CACHE < -99999999999999999999999999
/
update seq$
  set   CACHE = 9999999999999999999999999999
  where CACHE > 9999999999999999999999999999
/
update seq$
  set   HIGHWATER = INCREMENT$ + MAXVALUE
  where HIGHWATER > INCREMENT$ + MAXVALUE and INCREMENT$ > 0
/
update seq$
  set   HIGHWATER = INCREMENT$ + MINVALUE
  where HIGHWATER < INCREMENT$ + MINVALUE and INCREMENT$ < 0
/
COMMIT
/
