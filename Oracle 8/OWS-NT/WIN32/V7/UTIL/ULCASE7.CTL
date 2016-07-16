-- Copyright (c) 1991 by Oracle Corporation
--   NAME
--     ulcase7.ctl - <one-line expansion of the name>
--   DESCRIPTION
--     <short description of component this file declares/defines>
--   RETURNS
--
--   NOTES
--     <other useful comments, qualifications, etc.>
--   MODIFIED   (MM/DD/YY)
--    ksudarsh   04/08/94 -  merge changes from branch 1.1.710.1
--    ksudarsh   02/21/94 -  quote dat file
--    ksudarsh   12/30/92 -  Creation 
--    ksudarsh   12/27/92 -  Creation
--
-- $Header: ulcase7.ctl,v 1.2 1994/04/08 13:53:22 ksudarsh Exp $ ulcase7.ctl
--
LOAD DATA
INFILE 'ulcase7.dat'
APPEND
INTO TABLE emp
  WHEN (57)='.'
  TRAILING NULLCOLS
  (hiredate SYSDATE,
   deptno   POSITION(1:2)  INTEGER EXTERNAL(3)  
            NULLIF deptno=BLANKS,
   job      POSITION(7:14)   CHAR  TERMINATED BY WHITESPACE  
            NULLIF job=BLANKS  "UPPER(:job)",
   mgr      POSITION(28:31)  INTEGER EXTERNAL TERMINATED BY WHITESPACE 
            NULLIF mgr=BLANKS,
   ename    POSITION (34:41) CHAR  TERMINATED BY WHITESPACE  
            "UPPER(:ename)",
   empno    INTEGER EXTERNAL  TERMINATED BY WHITESPACE,
   sal      POSITION(51)  CHAR  TERMINATED BY WHITESPACE
            "TO_NUMBER(:sal,'$99,999.99')",
   comm     INTEGER EXTERNAL  ENCLOSED BY '(' AND '%'  
            ":comm * 100"
  )
