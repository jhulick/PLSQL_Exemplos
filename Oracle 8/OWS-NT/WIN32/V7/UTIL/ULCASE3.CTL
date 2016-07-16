-- Copyright (c) 1991 by Oracle Corporation 
--   NAME
--     ulcase3.ctl - <one-line expansion of the name>
--   DESCRIPTION
--     <short description of component this file declares/defines>
--   RETURNS
--
--   NOTES
--     <other useful comments, qualifications, etc.>
--   MODIFIED   (MM/DD/YY)
--    cheigham   08/28/91 -  Creation 
-- 
-- $Header: ulcase3.ctl,v 1.1 1991/09/02 14:52:19 CHEIGHAM Stab $ case3.ctl 
-- 
-- Variable length, delimited and enclosed data format

LOAD DATA 
INFILE *
APPEND

INTO TABLE EMP
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'	
(empno, ename, job, mgr,
 hiredate DATE(20) "DD-Month-YYYY",
 sal, comm,
 deptno   CHAR TERMINATED BY ':',
 projno,
 loadseq  SEQUENCE(MAX,1) )		

BEGINDATA
7782, "Clark", "Manager", 7839, 09-June-1981, 2572.50,, 10:101
7839, "King", "President", , 17-November-1981, 5500.00,, 10:102
7934, "Miller", "Clerk", 7782, 23-January-1982, 920.00,, 10:102
7566, "Jones", "Manager", 7839, 02-April-1981, 3123.75,, 20:101
7499, "Allen", "Salesman", 7698, 20-February-1981, 1600.00, 300.00, 30:103
7654, "Martin", "Salesman", 7698, 28-September-1981, 1312.50, 1400.00, 30:103
7658, "Chan", "Analyst", 7566, 03-May-1982, 3450,, 20:101
