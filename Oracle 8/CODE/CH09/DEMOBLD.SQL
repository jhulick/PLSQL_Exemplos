-- 
-- modified demobld.sql 
-- 
 
prompt Enter password for SYSTEM: 
prompt WARNING, we will DROP USER UCDEMO CASCADE!!!!!! 
prompt ^C if you do not want that!!!!! 
connect system/&1 
set echo off 
drop user UCDEMO cascade 
/ 
create user UCDEMO  
identified by UCDEMO 
/ 
grant connect, resource to UCDEMO 
/ 
grant create procedure, create trigger to UCDEMO 
/ 
 
 
connect UCDEMO/UCDEMO 
 
 
CREATE TABLE DEPT 
       (DEPTNO NUMBER(2) primary key, 
        DNAME VARCHAR2(14), 
        LOC VARCHAR2(13) ); 
 
INSERT INTO DEPT VALUES (10,'ACCOUNTING','NEW YORK'); 
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS'); 
INSERT INTO DEPT VALUES (30,'SALES','CHICAGO'); 
INSERT INTO DEPT VALUES (40,'OPERATIONS','BOSTON'); 
 
CREATE TABLE EMP 
       (EMPNO NUMBER(4) primary key, 
        ENAME VARCHAR2(10), 
        JOB VARCHAR2(9), 
        MGR NUMBER(4) references emp, 
        HIREDATE DATE, 
        SAL NUMBER(7,2), 
        COMM NUMBER(7,2), 
        DEPTNO NUMBER(2) references dept); 

create index emp_mgr_idx on emp(mgr);
create index emp_deptno_idx on emp(deptno);

INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,'17-NOV-81',5000,NULL,10); 
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,'1-MAY-81',2850,NULL,30); 
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,'9-JUN-81',2450,NULL,10); 
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,'2-APR-81',2975,NULL,20); 
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,'20-FEB-81',1600,300,30); 
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,'22-FEB-81',1250,500,30); 
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,'28-SEP-81',1250,1400,30); 
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,'3-DEC-81',3000,NULL,20); 
INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,'17-DEC-80',800,NULL,20); 
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,'09-DEC-82',3000,NULL,20); 
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,'8-SEP-81',1500,0,30); 
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,'12-JAN-83',1100,NULL,20); 
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,'3-DEC-81',950,NULL,30); 
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,'23-JAN-82',1300,NULL,10); 
 
COMMIT; 
 
create table projects ( 
    empno     number(4)        references emp, 
    proj_no    number, 
    project_name    varchar2(50), 
    project_description varchar2(2000), 
    constraint pk_projects primary key (empno, proj_no) 
    ); 
 
create  or replace trigger bi_projects 
    before insert on projects 
        for each row 
begin 
    select nvl(max(proj_no),0) + 1 into :new.proj_no from projects; 
end; 
/ 
 
INSERT INTO projects VALUES (7839,null,'Education Plan','Learn SQL'); 
INSERT INTO projects VALUES (7839,null,'Business Plan','Increase sales by educating work force on technical issues.'); 
INSERT INTO projects VALUES (7698,null,'Education Plan','Learn HTML'); 
INSERT INTO projects VALUES (7782,null,'Education Plan','Learn C++'); 
INSERT INTO projects VALUES (7566,null,'Education Plan','Learn Unix'); 
INSERT INTO projects VALUES (7499,null,'Education Plan','Learn NT'); 
INSERT INTO projects VALUES (7521,null,'Education Plan','Learn Ada'); 
INSERT INTO projects VALUES (7654,null,'Education Plan','Learn Networking'); 
INSERT INTO projects VALUES (7369,null,'Education Plan','Learn MVS'); 
INSERT INTO projects VALUES (7788,null,'Education Plan','Learn how to build a data warehouse'); 
INSERT INTO projects VALUES (7844,null,'Education Plan','Learn how replacation can enhance distributed systems.'); 
INSERT INTO projects VALUES (7876,null,'Education Plan','Learn how to exploit parallel processing.'); 
INSERT INTO projects VALUES (7900,null,'Education Plan','Learn how to achive high availability'); 
INSERT INTO projects VALUES (7934,null,'Education Plan','Learn Oracle'); 
     
commit; 
 
create table T1 ( a int, 
                  constraint T1_pk primary key(a) 
); 
insert into t1 values ( 1 );

create table T2 ( a int, 
                  b int, 
                  constraint T2_pk primary key(a,b), 
                  constraint t1_t2_fk foreign key(a) 
                  references t1(a) 
); 

begin
    for i in 1..335 loop
        insert into t2 values ( 1, i );
    end loop;
end;
/

create table T3 ( a int, 
                  b int, 
                  c int,  
                  constraint T3_pk primary key(a,b,c), 
                  constraint t2_t3_fk foreign key(a,b) 
                  references t2(a,b) 
); 
begin
    for i in 1..10 loop
        insert into t3 values ( 1, i, 1 );
    end loop;
end;
/
 

commit;

@uc
