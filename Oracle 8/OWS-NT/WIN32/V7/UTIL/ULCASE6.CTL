-- Copyright (c) 1991 by Oracle Corporation 
--   NAME
--     ulcase6.ctl - <one-line expansion of the name>
--   DESCRIPTION
--     <short description of component this file declares/defines>
--   RETURNS
--
--   NOTES
--     <other useful comments, qualifications, etc.>
--   MODIFIED   (MM/DD/YY)
--    jhealy     01/27/95 -  merge changes from branch 1.2.720.1
--    ksudarsh   11/06/92 -  infile is ulcase6 
--    cheigham   08/28/91 -  Creation 
-- 
-- $Header: ulcase6.ctl,v 1.3 1995/01/27 13:05:59 jhealy Exp $ 
-- 
load data
infile 'ulcase6.dat'
replace
into table emp
sorted indexes (empix)
(empno position(1:4) nullif empno=blanks,
ename position(6:15),
job position(17:25),
mgr position(27:30) nullif mgr=blanks,
sal position(32:39) nullif sal=blanks,
comm position(41:48) nullif comm=blanks,
deptno position(50:51) nullif empno=blanks)
