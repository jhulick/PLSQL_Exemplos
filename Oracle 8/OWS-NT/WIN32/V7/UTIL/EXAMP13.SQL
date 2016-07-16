rem 
rem $Header: examp13.sql,v 1.1 1992/05/12 22:02:32 RVASIRED Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      examp13.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     rvasired   05/12/92 -  Creation 
/*
** This block returns a number from each of two tables, then
** inserts the sum of the numbers into a third table.  It stops
** when all rows have been fetched from either of the two tables.
**
** Copyright (c) 1989,1992 by Oracle Corporation
*/

DECLARE
    CURSOR num1_cur IS SELECT num FROM num1_tab
        ORDER BY sequence;
    CURSOR num2_cur IS SELECT num FROM num2_tab
        ORDER BY sequence;
    num1      num1_tab.num%TYPE;
    num2      num2_tab.num%TYPE;
    pair_num  NUMBER := 0;
BEGIN
    OPEN num1_cur;
    OPEN num2_cur;
    LOOP   -- loop through the two tables and get
           -- pairs of numbers
        FETCH num1_cur INTO num1;
        FETCH num2_cur INTO num2;
        EXIT WHEN (num1_cur%NOTFOUND) OR (num2_cur%NOTFOUND);
        pair_num := pair_num + 1;
        INSERT INTO sum_tab VALUES (pair_num, num1 + num2);
    END LOOP;
    CLOSE num1_cur;
    CLOSE num2_cur;
END;
/
