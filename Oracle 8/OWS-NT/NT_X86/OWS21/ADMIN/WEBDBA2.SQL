REM Copyright (c) 1995 by Oracle Corporation
REM
REM NAME
REM   webdbademo.sql
REM FUNCTION
REM   Creates the Web*DBA demo tables and constraints.
REM NOTES
REM   Must be run when connected as the Web*DBA owner.
REM
REM MODIFIED
REM   kireland   02/21/96 - Creation
REM   kireland   04/10/96 - Project cancelled, deemed only a demo
			    by ASHARMA.
  
REM
REM  DROP Web*DBA TABLES
REM

@@webdbaddemo.sql

REM
REM  CREATE Web*DBA TABLES
REM


create table EMPS
(
	EMPNO number(4) 	constraint EMPS_PK primary key,
        ENAME varchar2(10) 	constraint EMPS_NN NOT NULL,
        JOB varchar2(9)		constraint JOB_DOMAIN check (JOB in ('CLERK', 'MANAGER','SALESMAN','PRESIDENT', 'VP', 'ANALYST')),
        SALARY number(7,2)	constraint SALARY_DOMAIN check (SALARY between 10000 and 100000),
        DEPTNO number(2)	);


insert into EMPS values
        (1,'SMITH','CLERK',12000,20);
insert into EMPS values
        (2,'ALLEN','SALESMAN',16000,30);
insert into EMPS values
        (3,'WARD','SALESMAN',12500,30);
insert into EMPS values
        (4,'JONES','MANAGER',29750,20);
insert into EMPS values
        (5,'MARTIN','SALESMAN',12500,30);
insert into EMPS values
        (6,'BLAKE','MANAGER',28500,30);
insert into EMPS values
        (7,'CLARK','MANAGER',24500,10);
insert into EMPS values
        (8,'SCOTT','ANALYST',30000,20);
insert into EMPS values
        (9,'KING','PRESIDENT',50000,10);
insert into EMPS values
        (10,'TURNER','SALESMAN',15000,30);
insert into EMPS values
        (11,'ADAMS','CLERK',11000,20);
insert into EMPS values
        (12,'JAMES','CLERK',10000,30);
insert into EMPS values
        (13,'FORD','ANALYST',30000,20);
insert into EMPS values
        (14,'MILLER','CLERK',13000,10);
insert into EMPS values
        (15,'MILLER','MANAGER',33000,40);

create table DEPTS
(
        DEPTNO NUMBER(2)	constraint DEPTS_PK primary key,
        DNAME VARCHAR2(14)	constraint DNAME_UNQ unique,
        LOC VARCHAR2(13)	constraint LOC_NN not null, 
	MGR NUMBER(4)		constraint DEPTS_FK references EMPS(EMPNO));


insert into depts values
        (10,'ACCOUNTING','NEW YORK', 9);
insert into depts values 
	(20,'RESEARCH','DALLAS', 4);
insert into depts values
        (30,'SALES','CHICAGO', 6);
insert into depts values
        (40,'OPERATIONS','BOSTON', 15);


alter table emps add constraint DEPTNO_FK foreign key (DEPTNO) references DEPTS(DEPTNO);



create table SUPPLIERS
(
	SNAME	varchar(10)	constraint SUPPLIERS_PK primary key,
	SADDR	varchar2(100)	constraint SADDR_NN not null);

create table ITEMS
(
	ITEMNO	number(2)	constraint ITEMS_PK primary key,
	INAME	varchar(10)	constraint INAME_UNQ unique,
	DEPTNO	number(2)	constraint ITEMS_FK references DEPTS(DEPTNO));

create table CUSTOMERS
(
	CNAME	varchar2(25)	constraint CUSTOMERS_PK primary key,
	CADDR	varchar(100)	constraint CADDR_NN not null,
	BALANCE	number(3)	constraint BALANCE_DOMAIN check (BALANCE between 0 and 1000));

create table ORDERS
(
	ORDERNO	number(2)	constraint ORDERS_PK primary key,
	ORDERDATE date		constraint ORDERDATE_NN not null,
	CUST varchar2(25)	constraint ORDERS_FK references CUSTOMERS(CNAME));

create table INCLUDES
(
	ORDERNO number(2)	constraint ORDERNO_FK references ORDERS(ORDERNO),
	INAME	varchar(10)	constraint INAME_FK references ITEMS(INAME),
	QUANTITY number(3)	constraint QUANTITY check (QUANTITY between 1 and 1000));

create table SUPPLIES
(
	SNAME	varchar(10)	constraint SUPPLIES_PK primary key,
	INAME	varchar(10)	constraint SUPPLIES_FK references ITEMS(INAME),
	PRICE	number(3)	constraint PRICE_DOMAIN check (PRICE between 0 and 1000));

	


