Rem Copyright (c) 1990 by Oracle Corporation
Rem NAME
Rem    <name>
Rem  FUNCTION
Rem  NOTES
Rem  MODIFIED
Rem     ksudarsh   03/11/93 -  comment out vms specific host command 
Rem     ksudarsh   12/29/92 -  Creation 
Rem     cheigham   08/28/91 -  Creation 
Rem   Heigham    11/21/90 - create UNIQUE index
Rem
rem 
rem $Header: ulcase4.sql,v 1.2 1993/03/11 10:49:09 KSUDARSH Exp $ 
rem 
set termout off
rem host write sys$output "Adding unique index on emp(empno).  Please wait..."
set feedback off
create unique index empix on emp(empno);

exit
