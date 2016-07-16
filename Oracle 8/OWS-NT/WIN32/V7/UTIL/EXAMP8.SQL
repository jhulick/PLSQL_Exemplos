rem 
rem $Header: examp8.sql,v 1.1 1992/05/12 22:03:53 RVASIRED Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      examp8.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     rvasired   05/12/92 -  Creation 
/*
** This block calculates the total wages (salary plus commission)
** paid to employees in department 20.  It also determines how
** many of the employees have salaries higher than $2000, and how
** many have commissions larger than their salaries.
**
** Copyright (c) 1989,1992 by Oracle Corporation
*/

DECLARE
    CURSOR emp_cursor(dnum NUMBER) IS
        SELECT sal, comm FROM emp WHERE deptno = dnum;
    total_wages   NUMBER(11,2) := 0;
    high_paid	  NUMBER(4) := 0;
    higher_comm	  NUMBER(4) := 0;
BEGIN
    /* The number of iterations will equal the number of rows *
     * returned by emp_cursor.                                */
    FOR emp_record IN emp_cursor(20) LOOP
        emp_record.comm := NVL(emp_record.comm, 0);
        total_wages := total_wages + emp_record.sal +
            emp_record.comm;
        IF emp_record.sal > 2000.00 THEN
            high_paid := high_paid + 1;
        END IF;
        IF emp_record.comm > emp_record.sal THEN
            higher_comm := higher_comm + 1;
        END IF;
    END LOOP;
    INSERT INTO temp VALUES (high_paid, higher_comm,
        'Total Wages: ' || TO_CHAR(total_wages));
    COMMIT;
END;
/
