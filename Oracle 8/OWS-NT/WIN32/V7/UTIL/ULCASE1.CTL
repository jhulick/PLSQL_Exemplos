-- Copyright (c) 1991 by Oracle Corporation 
--   NAME
--     ulcase1.ctl - <one-line expansion of the name>
--   DESCRIPTION
--     <short description of component this file declares/defines>
--   RETURNS
--
--   NOTES
--     <other useful comments, qualifications, etc.>
--   MODIFIED   (MM/DD/YY)
--    cheigham   08/28/91 -  Creation 
-- 
-- $Header: ulcase1.ctl,v 1.1 1991/09/02 14:50:39 CHEIGHAM Stab $ case1.ctl 
-- 
LOAD DATA
INFILE * 
INTO TABLE DEPT	
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(DEPTNO, DNAME, LOC)
BEGINDATA
12,RESEARCH,"SARATOGA" 	
10,"ACCOUNTING",CLEVELAND
11,"ART",SALEM
13,FINANCE,"BOSTON"
21,"SALES",PHILA.
22,"SALES",ROCHESTER
42,"INT'L","SAN FRAN"
