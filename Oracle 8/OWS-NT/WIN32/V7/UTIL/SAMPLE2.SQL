rem 
rem $Header: sample2.sql,v 1.1 1992/05/12 22:04:17 RVASIRED Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      sample2.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     rvasired   05/12/92 -  Creation 
/*
** This program uses a cursor to select the 5 highest-paid employees 
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

    FOR i IN 1..5 LOOP
	FETCH c1 INTO my_ename, my_empno, my_sal;
	EXIT WHEN c1%NOTFOUND;	 /* in case the number requested is more *
				  * than the total number of employees   */
	INSERT INTO temp VALUES (my_sal, my_empno, my_ename);
        COMMIT;
    END LOOP;

    CLOSE c1;
END;
/
