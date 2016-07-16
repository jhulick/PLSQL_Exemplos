rem 
rem $Header: examp14.sql,v 1.1 1992/05/12 22:02:45 RVASIRED Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      examp14.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     rvasired   05/12/92 -  Creation 
/*
** This block uses a cursor to select the 5 highest-paid employees 
** from the EMP table.
**
** Copyright (c) 1989,1992 by Oracle Corporation
*/

DECLARE
    CURSOR c1 is
	SELECT ename, empno, sal FROM emp
	ORDER BY sal DESC;   -- start with highest-paid employee
    my_ename  CHAR(10);
    my_empno  NUMBER(4);
    my_sal    NUMBER(7,2);

BEGIN
    OPEN c1;
    LOOP
	FETCH c1 INTO my_ename, my_empno, my_sal;
	EXIT WHEN (c1%ROWCOUNT > 5) OR (c1%NOTFOUND);
	INSERT INTO temp VALUES (my_sal, my_empno, my_ename);
        COMMIT;
    END LOOP;
    CLOSE c1;
END;
/
