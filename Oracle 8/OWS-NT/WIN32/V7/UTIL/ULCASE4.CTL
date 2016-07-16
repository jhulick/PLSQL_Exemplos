-- Copyright (c) 1991 by Oracle Corporation 
--   NAME
--     ulcase4.ctl - <one-line expansion of the name>
--   DESCRIPTION
--     <short description of component this file declares/defines>
--   RETURNS
--
--   NOTES
--     <other useful comments, qualifications, etc.>
--   MODIFIED   (MM/DD/YY)
--    ksudarsh   11/06/92 -  infile is ulcase4 
--    cheigham   08/28/91 -  Creation 
-- 
-- $Header: ulcase4.ctl,v 1.2 1992/11/06 11:09:40 KSUDARSH Exp $ case4.ctl 
-- 
LOAD DATA
INFILE "ulcase4.dat"
DISCARDFILE "ulcase4.dis"	
DISCARDMAX 999	
REPLACE
CONTINUEIF (1) = '*'
INTO TABLE EMP 

( EMPNO    POSITION(01:04) INTEGER EXTERNAL,
  ENAME    POSITION(06:15) CHAR,
  JOB      POSITION(17:25) CHAR,
  MGR      POSITION(27:30) INTEGER EXTERNAL,
  SAL      POSITION(32:39) DECIMAL EXTERNAL,
  COMM     POSITION(41:48) DECIMAL EXTERNAL,
  DEPTNO   POSITION(50:51) INTEGER EXTERNAL,
  HIREDATE POSITION(52:60) INTEGER EXTERNAL)
