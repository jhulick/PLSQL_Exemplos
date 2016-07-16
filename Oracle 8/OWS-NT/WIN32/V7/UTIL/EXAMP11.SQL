rem 
rem $Header: examp11.sql,v 1.1 1992/05/12 22:02:16 RVASIRED Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      examp11.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     rvasired   05/12/92 -  Creation 
/*
** This block calculates the ratio between the X and Y columns of
** the RATIO table.  If the ratio is greater than 0.72, the block
** inserts the ratio into RESULT_TABLE.  Otherwise, it inserts -1.
** If the denominator is zero, ZERO_DIVIDE is raised, and a
** zero is inserted into RESULT_TABLE.
**
** Copyright (c) 1989,1992 by Oracle Corporation
*/

DECLARE
    numerator    NUMBER;
    denominator  NUMBER;
    the_ratio    NUMBER;
    lower_limit  CONSTANT NUMBER := 0.72;
    samp_num     CONSTANT NUMBER := 132;
BEGIN
    SELECT x, y INTO numerator, denominator FROM result_table
        WHERE sample_id = samp_num;
    the_ratio := numerator/denominator;
    IF the_ratio > lower_limit THEN
        INSERT INTO ratio VALUES (samp_num, the_ratio);
    ELSE
        INSERT INTO ratio VALUES (samp_num, -1);
    END IF;
    COMMIT;
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        INSERT INTO ratio VALUES (samp_num, 0);
        COMMIT;
    WHEN OTHERS THEN
        ROLLBACK;
END;
/
