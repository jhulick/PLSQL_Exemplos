rem 
rem $Header: examplod.sql,v 1.1 1992/12/02 16:27:53 GCLOSSMA Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      examplod.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     gclossma   12/02/92 -  Creation 
delete from accounts
/
insert into accounts values (1,1000.00)
/
insert into accounts values (2,2000.00)
/
insert into accounts values (3,1500.00)
/
insert into accounts values (4,6500.00)
/
insert into accounts values (5,500.00)
/
delete from action
/
insert into action values
	(3,'u',599,null,sysdate)
/
insert into action values
	(6,'i',20099,null, sysdate)
/
insert into action values
	(5,'d',null,null, sysdate)
/
insert into action values
	(7,'u',1599,null, sysdate)
/
insert into action values
	(1,'i',399,null,sysdate)
/
insert into action values
	(9,'d',null,null,sysdate)
/
insert into action values
	(10,'x',null,null,sysdate)
/
delete from bins
/
insert into bins values (1, 5469, 650)
/
insert into bins values (2, 7243, 450)
/
insert into bins values (3, 5469, 120)
/
insert into bins values (4, 5469, 300)
/
insert into bins values (5, 6085, 415)
/
insert into bins values (6, 5469, 280)
/
insert into bins values (7, 8159, 619)
/
delete from data_table
/
insert into data_table values
	(1, 10, 167, 17)
/
insert into data_table values
	(1, 16, 223, 35)
/
insert into data_table values
	(2, 34, 547, 2)
/
insert into data_table values
	(3, 23, 318, 11)
/
insert into data_table values
	(1, 17, 266, 15)
/
insert into data_table values
	(1, 20, 117, 9)
/
delete from emp
/
insert into emp values
	(7369,'SMITH','CLERK',7902,TO_DATE('12-17-80','MM-DD-YY'),
         800,NULL,20)
/
insert into emp values
	(7499,'ALLEN','SALESMAN',7698,TO_DATE('02-20-81','MM-DD-YY'),
         1600,300,30)
/
insert into emp values
	(7521,'WARD','SALESMAN',7698,TO_DATE('02-22-81','MM-DD-YY'),
         1250,500,30)
/
insert into emp values
	(7566,'JONES','MANAGER',7839,TO_DATE('04-02-81','MM-DD-YY'),
         2975,NULL,20)
/
insert into emp values
	(7654,'MARTIN','SALESMAN',7698,TO_DATE('09-28-81','MM-DD-YY'),
         1250,1400,30)
/
insert into emp values
	(7698,'BLAKE','MANAGER',7839,TO_DATE('05-1-81','MM-DD-YY'),
         2850,NULL,30)
/
insert into emp values
	(7782,'CLARK','MANAGER',7839,TO_DATE('06-9-81','MM-DD-YY'),
         2450,NULL,10)
/
insert into emp values
	(7788,'SCOTT','ANALYST',7566,SYSDATE-85,3000,NULL,20)
/
insert into emp values
	(7839,'KING','PRESIDENT',NULL,TO_DATE('11-17-81','MM-DD-YY'),
         5000,NULL,10)
/
insert into emp values
	(7844,'TURNER','SALESMAN',7698,TO_DATE('09-8-81','MM-DD-YY'),
         1500,0,30)
/
insert into emp values
	(7876,'ADAMS','CLERK',7788,SYSDATE-51,1100,NULL,20)
/
insert into emp values
	(7900,'JAMES','CLERK',7698,TO_DATE('12-3-81','MM-DD-YY'),
         950,NULL,30)
/
insert into emp values
	(7902,'FORD','ANALYST',7566,TO_DATE('12-3-81','MM-DD-YY'),
         3000,NULL,20)
/
insert into emp values
	(7934,'MILLER','CLERK',7782,TO_DATE('01-23-82','MM-DD-YY'),
         1300,NULL,10)
/
delete from inventory
/
insert into inventory values
	(1234, 'TENNIS RACKET', 3)
/
insert into inventory values
	(8159, 'GOLF CLUB', 4)
/
insert into inventory values
	(2741, 'SOCCER BALL', 2)
/
delete from journal
/
delete from num1_tab
/
insert into num1_tab values (1, 5)
/
insert into num1_tab values (2, 7)
/
insert into num1_tab values (3, 4)
/
insert into num1_tab values (4, 9)
/
delete from num2_tab
/
insert into num2_tab values (1, 15)
/
insert into num2_tab values (2, 19)
/
insert into num2_tab values (3, 27)
/
delete from purchase_record
/
delete from ratio
/
delete from result_table
/
insert into result_table values (130, 70, 87)
/
insert into result_table values (131, 77, 194)
/
insert into result_table values (132, 73, 0)
/
insert into result_table values (133, 81, 98)
/
delete from sum_tab
/
delete from temp
/
commit
/
