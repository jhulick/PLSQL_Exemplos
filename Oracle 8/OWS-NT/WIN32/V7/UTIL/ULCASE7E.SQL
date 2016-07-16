Rem  Copyright (c) 1991 by Oracle Corporation
Rem    NAME
Rem      ulcase7e.sql - <one-line expansion of the name>
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
Rem $Header: ulcase7e.sql,v 1.2 1993/03/11 10:57:36 KSUDARSH Exp $
Rem
Rem ULDEMO7E.SQL
Rem   End-script for SQL*Loader Examples, Case 7

set termout off
rem host write sys$output "Cleaning up Case 7 Trigger and Package."
set feedback off

DROP PACKAGE uldemo7;
DROP TRIGGER uldemo7_emp_insert;

EXIT
