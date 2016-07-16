rem 
rem $Header: sample3.sql,v 1.1 1992/05/12 22:04:28 RVASIRED Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      sample3.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     rvasired   05/12/92 -  Creation 
/*
** This example illustrates block structure and scope rules.  An
** outer block declares two variables named X and COUNTER, and loops four
** times.  Inside the loop is a sub-block that also declares a variable
** named X.  The values inserted into the TEMP table show that the two
** X's are indeed different.
**
** Copyright (c) 1989,1992 by Oracle Corporation
*/

DECLARE
    x        NUMBER := 0;
    counter  NUMBER := 0;
BEGIN
    FOR i IN 1..4 LOOP
	x := x + 1000;
	counter := counter + 1;
        INSERT INTO temp VALUES (x, counter, 'in OUTER loop');

	/* start an inner block */
        DECLARE
	    x  NUMBER := 0;   -- this is a local version of x
	BEGIN
	    FOR i IN 1..4 LOOP
		x := x + 1;   -- this increments the local x
		counter := counter + 1;
	        INSERT INTO temp VALUES (x, counter, 'inner loop');
	    END LOOP;
	END;

    END LOOP;
    COMMIT;
END;
/
