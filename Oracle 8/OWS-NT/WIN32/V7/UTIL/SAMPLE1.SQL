rem 
rem $Header: sample1.sql,v 1.1 1992/05/12 22:04:07 RVASIRED Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      sample1.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     rvasired   05/12/92 -  Creation 
/*
** This block uses a simple FOR loop to insert 10 rows into a table.  
** The values of a loop index, counter variable, and either of two 
** character strings are inserted.  Which string is inserted
** depends on the value of the loop index.
**
** Copyright (c) 1989,1992 by Oracle Corporation
*/

DECLARE
    x  NUMBER := 100;
BEGIN
    FOR i IN 1..10 LOOP
	IF MOD(i,2) = 0 THEN     -- i is even
	    INSERT INTO temp VALUES (i, x, 'i is even');
	ELSE
	    INSERT INTO temp VALUES (i, x, 'i is odd');
	END IF;

	x := x + 100;        
    END LOOP;
    COMMIT;
END;
/
