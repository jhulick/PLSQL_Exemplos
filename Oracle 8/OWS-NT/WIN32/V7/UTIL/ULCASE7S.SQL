Rem  Copyright (c) 1991 by Oracle Corporation
Rem    NAME
Rem      ulcase7s.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     ksudarsh   03/11/93 -  comment out vms specific host command 
Rem     ksudarsh   12/30/92 -  Creation 
Rem     ksudarsh   12/27/92 -  Creation
Rem
Rem $Header: ulcase7s.sql,v 1.2 1993/03/11 10:55:13 KSUDARSH Exp $
Rem
Rem ULDEMO7S.SQL
Rem   Start-script for SQL*Loader Examples, Case 7

Rem The variables the insert-trigger uses to save the last valid value
Rem  are defined in a package so they will persist between calls.

Rem Since these values will be accessed by anyone inserting into EMP, only
Rem  the user doing the load should have access to EMP during this time
Rem  (Alternatively, the trigger could be modified to check the USERENV fnction
Rem  in a WHEN clause and only perform its functions for a particular user.)

set termout off
rem host write sys$output "Building Package and Trigger for Case7.Please wait"
set feedback off

CREATE OR REPLACE PACKAGE uldemo7 AS
    last_deptno  NUMBER;
    last_job     CHAR(9);
    last_mgr     NUMBER;
END uldemo7;
/
                        
CREATE OR REPLACE TRIGGER uldemo7_emp_insert
  BEFORE INSERT ON emp
  FOR EACH ROW

  BEGIN
  IF :new.deptno IS NOT NULL THEN
     uldemo7.last_deptno := :new.deptno;   -- save value for later use
  ELSE
     :new.deptno := uldemo7.last_deptno;   -- use last valid value
  END IF;

  IF :new.job IS NOT NULL THEN
     uldemo7.last_job := :new.job;   -- save value for later use
  ELSE
     :new.job := uldemo7.last_job;   -- use last valid value
  END IF;

  IF :new.mgr IS NOT NULL THEN
     uldemo7.last_mgr := :new.mgr;   -- save value for later use
  ELSE
     :new.mgr := uldemo7.last_mgr;   -- use last valid value
  END IF;

  END;
/

EXIT
