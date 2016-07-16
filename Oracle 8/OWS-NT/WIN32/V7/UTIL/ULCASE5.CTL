-- Copyright (c) 1991 by Oracle Corporation 
--   NAME
--     ulcase5.ctl - <one-line expansion of the name>
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
--    ksudarsh   11/06/92 -  infile is ulcase5 
--    cheigham   08/28/91 -  Creation 
-- 
-- $Header: ulcase5.ctl,v 1.4 1994/04/08 13:44:31 ksudarsh Exp $ case5.ctl 
-- 
-- Loads EMP records from first 23 characters
-- Creates and loads PROJ records for each PROJO listed
-- for each employee

LOAD DATA
INFILE 'ulcase5.dat'
BADFILE 'ulcase5.bad'
DISCARDFILE 'ulcase5.dis'
REPLACE

INTO TABLE EMP
  (EMPNO    POSITION(1:4)   INTEGER EXTERNAL,
   ENAME    POSITION(6:15)  CHAR,
   DEPTNO   POSITION(17:18) CHAR,
   MGR      POSITION(20:23) INTEGER EXTERNAL)

INTO TABLE PROJ
-- PROJ has two columns, both not null: EMPNO and PROJNO
WHEN PROJNO != '   '
  (EMPNO    POSITION(1:4)   INTEGER EXTERNAL,
   PROJNO   POSITION(25:27) INTEGER EXTERNAL)   -- 1st proj

INTO TABLE PROJ
WHEN PROJNO != '   '
  (EMPNO    POSITION(1:4)   INTEGER EXTERNAL,
   PROJNO   POSITION(29:31) INTEGER EXTERNAL)   -- 2nd proj

INTO TABLE PROJ
WHEN PROJNO != '   '
  (EMPNO    POSITION(1:4)   INTEGER EXTERNAL,
   PROJNO   POSITION(33:35) INTEGER EXTERNAL)   -- 3rd proj	
