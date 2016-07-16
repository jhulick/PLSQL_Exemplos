rem 
rem $Header: ulcase6.sql,v 1.3 1994/04/08 13:51:27 ksudarsh Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      ulcase6.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     ksudarsh   02/21/94 -  create unique index "empix"
Rem     ksudarsh   03/11/93 -  comment out vms specific host command 
Rem     ksudarsh   12/29/92 -  Creation 
Rem     ksudarsh   12/28/92 -  Don't drop dept 
Rem     cheigham   08/28/91 -  Creation 
Rem     cheigham   03/19/91 -         Creation 
set termout off
rem host write sys$output "Building case6 demonstration tables.  Please wait"
set feedback off
drop table emp;

create table emp
       (empno number(4) not null,
	ename char(10),
	job char(9),
	mgr number(4),
	hiredate date,
	sal number(7,2),
	comm number(7,2),
	deptno number(2));

create unique index empix on emp(empno); 

exit
