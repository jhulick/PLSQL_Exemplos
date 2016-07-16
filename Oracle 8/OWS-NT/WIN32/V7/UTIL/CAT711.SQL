rem 
rem $Header: cat711.sql,v 1.1 1992/10/20 13:19:14 GLUMPKIN Stab $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      m710711.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     glumpkin   10/20/92 -  Renamed from M710711.SQL 
Rem     epeeler    06/24/92 -  Creation 


REM update the cdef$ table first to make the NULL$ constraints type 7
update cdef$ set type=7 where
  con# in (select abs(null$) from col$ where null$>0 or
	   null$ < 0);


REM update the col$ for the enabled NOT NULL column constraints
update col$ set null$=1 where null$ > 0;

REM update the col$ table for the disabled NOT NULL column constraints
update col$ set null$=0 where null$ < 0;

REM update the col$ table for the enabled primary keys
update col$ c set null$=null$+1 where
(obj#,col#) = (select cc.obj#,cc.col# from ccol$ cc,cdef$ cd
	       where cc.con#=cd.con# and cd.type=2 and
	       enabled is not null and c.obj#=cc.obj# and
	       c.col#=cc.col#);

