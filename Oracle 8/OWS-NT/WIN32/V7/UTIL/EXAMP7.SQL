rem 
rem $Header: examp7.sql,v 1.1 1992/05/12 22:03:40 RVASIRED Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      examp7.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     rvasired   05/12/92 -  Creation 
/*
** This block does some numeric processing on data that comes
** from experiment #1.  The results are stored in the TEMP table.
**
** Copyright (c) 1989,1992 Oracle Corporation
*/

DECLARE
    result  temp.num_col1%TYPE;
    CURSOR c1 IS
        SELECT n1, n2, n3 FROM data_table
            WHERE exper_num = 1;
BEGIN
    FOR c1rec IN c1 LOOP
            /* calculate and store the results */
        result := c1rec.n2 / (c1rec.n1 + c1rec.n3);
        INSERT INTO temp VALUES (result, NULL, NULL);
    END LOOP;
    COMMIT;
END;
/
