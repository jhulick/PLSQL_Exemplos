rem 
rem $Header: examp4.sql,v 1.1 1992/05/12 22:03:08 RVASIRED Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      examp4.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     rvasired   05/12/92 -  Creation 
/*
** This block finds all employees whose monthly wages (salary plus
** commission) are higher than $2000.
**
** An alias is used in the cursor declaration so that the subsequent
** use of %ROWTYPE is allowed.  (Column names in a cursor declaration
** must have aliases if they are not simple names.)
**
** Copyright (c) 1989,1992 by Oracle Corporation
*/

DECLARE
    CURSOR my_cursor IS SELECT sal + NVL(comm, 0) wages, ename 
        FROM emp;
    my_rec  my_cursor%ROWTYPE;
BEGIN
    OPEN my_cursor;
    LOOP
        FETCH my_cursor INTO my_rec;
        EXIT WHEN my_cursor%NOTFOUND;
        IF my_rec.wages > 2000 THEN
            INSERT INTO temp VALUES (NULL, my_rec.wages,
                my_rec.ename);
        END IF;
    END LOOP;
    CLOSE my_cursor;
END;
/
