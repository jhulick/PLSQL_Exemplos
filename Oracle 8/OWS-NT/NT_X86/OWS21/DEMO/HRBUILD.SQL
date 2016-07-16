Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
Rem    NAME
Rem      hrbuild.sql
Rem    DESCRIPTION
Rem      
Rem    RETURNS
Rem 
Rem    NOTES
Rem      
Rem    MODIFIED   (MM/DD/YY)
Rem     mfreedma      09/11/96 -  Added Banner 

drop table emp;
drop table emp_xtra;
create table emp
(	empno	number(4),
	ename	varchar2(10),
	job	varchar2(20),
	mgr	number(4),
	hiredate date,
	sal 	number(7,2),
	comm	number(7,2),
	deptno	number(2)
);

insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno) 
values (7369,'SMITH','CLERK',7902,'17-Dec-80',800,null,20);

insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno) 
values (7499,'ALLEN','SALESPERSON',7698,'20-Feb-81',1600,300,30);

insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno) 
values (7521,'WARD','SALESPERSON',7698,'22-Feb-81',1250,500,30);
                                                            
insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno)
values (7566,'JONES','MANAGER',7839,'02-Apr-81',2975,null,20);

insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno)
values (7654,'MARTIN','SALESPERSON',7698,'28-Sep-81',1250,1400,30);

insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno)
values (7698,'BLAKE','MANAGER',7839,'01-May-81',2850,null,30);

insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno)
values (7782,'CLARK','MANAGER',7839,'09-Jun-81',2450,null,10);

insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno)
values (7788,'SCOTT','ANALYST',7566,'09-Dec-82',3000,null,20);

insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno)
values (7839,'KING','PRESIDENT',null,'17-Nov-81',5000,null,10);

insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno)
values (7844,'TURNER','SALESPERSON',7698,'08-Sep-81',1500,0,30);

insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno)
values (7876,'ADAMS','CLERK',7788,'12-Jan-83',1100,null,20);

insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno)
values (7900,'JAMES','CLERK',7698,'03-Dec-81',950,null,30);

insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno)
values (7902,'FORD','ANALYST',7566,'03-Dec-81',3000,null,20);

insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno)
values (7934,'MILLER','CLERK',7782,'23-Jan-82',1300,null,10);

create table emp_xtra
( empno number, img varchar2(255), urlname varchar2(255), url varchar2(255));

insert into emp_xtra
select empno, lower(ename) || '.jpg', null, null
from emp;
