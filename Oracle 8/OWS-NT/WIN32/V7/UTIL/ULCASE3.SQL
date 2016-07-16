Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      ulcase3.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     ksudarsh   03/11/93 -  comment out vms specific host command 
Rem     ksudarsh   12/29/92 -  Creation 
Rem     cheigham   08/28/91 -  Creation 
rem 
rem $Header: ulcase3.sql,v 1.2 1993/03/11 10:47:40 KSUDARSH Exp $ 
rem 
set termout off
rem host write sys$output "Adding columns to emp.  Please wait."
set feedback off
alter table emp add (projno number, loadseq number);

exit
