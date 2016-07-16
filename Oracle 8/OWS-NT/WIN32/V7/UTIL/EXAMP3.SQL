rem 
rem $Header: examp3.sql,v 1.1 1992/05/12 22:03:01 RVASIRED Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      examp3.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     rvasired   05/12/92 -  Creation 
/*
** This block finds the first employee who has a salary over $4000
** and is higher in the chain of command than employee 7902.
**
** Copyright (c) 1989,1992 Oracle Corporation
*/

DECLARE
    salary          emp.sal%TYPE;
    mgr_num         emp.mgr%TYPE;
    last_name       emp.ename%TYPE;
    starting_empno  CONSTANT NUMBER(4) := 7902;
BEGIN
    SELECT sal, mgr INTO salary, mgr_num FROM emp
        WHERE empno = starting_empno;
    WHILE salary < 4000 LOOP
        SELECT sal, mgr, ename INTO salary, mgr_num, last_name
            FROM emp
            WHERE empno = mgr_num;
    END LOOP;

    INSERT INTO temp VALUES (NULL, salary, last_name);
    COMMIT;
END;
/
