-- Copyright (c) 1991 by Oracle Corporation 
--   NAME
--     ulcase2.ctl - <one-line expansion of the name>
--   DESCRIPTION
--     <short description of component this file declares/defines>
--   RETURNS
--
--   NOTES
--     <other useful comments, qualifications, etc.>
--   MODIFIED   (MM/DD/YY)
--    ksudarsh   04/08/94 -  merge changes from branch 1.3.710.1
--    ksudarsh   02/21/94 -  quote dat file
--    ksudarsh   03/11/93 -  make filename lowercase 
--    ksudarsh   11/06/92 -  infile is ulcase2
--    cheigham   08/28/91 -  Creation 
-- 
-- $Header: ulcase2.ctl,v 1.4 1994/04/08 13:42:44 ksudarsh Exp $ case2.ctl 
-- 
LOAD DATA
INFILE 'ulcase2.dat'
INTO TABLE EMP 

( EMPNO    POSITION(01:04) INTEGER EXTERNAL,
  ENAME    POSITION(06:15) CHAR,
  JOB      POSITION(17:25) CHAR,
  MGR      POSITION(27:30) INTEGER EXTERNAL,
  SAL      POSITION(32:39) DECIMAL EXTERNAL,
  COMM     POSITION(41:48) DECIMAL EXTERNAL,
  DEPTNO   POSITION(50:51) INTEGER EXTERNAL)

