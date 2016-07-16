rem 
rem $Header: examp6.sql,v 1.1 1992/05/12 22:03:28 RVASIRED Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      examp6.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     rvasired   05/12/92 -  Creation 
/*
** This block accumulates 1000 units of part number 5469 from
** various storage bins.
**
** Copyright (c) 1989,1992 by Oracle Corporation
*/
DECLARE
    CURSOR bin_cur(part_number NUMBER) IS SELECT amt_in_bin
        FROM bins
        WHERE part_num = part_number AND 
            amt_in_bin > 0
            ORDER BY bin_num
            FOR UPDATE OF amt_in_bin;
    bin_amt	    bins.amt_in_bin%TYPE;
    total_so_far    NUMBER(5) := 0;
    amount_needed   CONSTANT NUMBER(5) := 1000;
    bins_looked_at  NUMBER(3) := 0;
BEGIN
    OPEN bin_cur(5469);
    WHILE total_so_far < amount_needed LOOP
        FETCH bin_cur INTO bin_amt;
        EXIT WHEN bin_cur%NOTFOUND;
             /* If we exit, there's not enough to *
              * satisfy the order.                */
        bins_looked_at := bins_looked_at + 1;
        IF total_so_far + bin_amt < amount_needed THEN
            UPDATE bins SET amt_in_bin = 0
                WHERE CURRENT OF bin_cur;  
                    -- take everything in the bin
            total_so_far := total_so_far + bin_amt;
        ELSE        -- we finally have enough
            UPDATE bins SET amt_in_bin = amt_in_bin
                - (amount_needed - total_so_far)
                WHERE CURRENT OF bin_cur;
            total_so_far := amount_needed;
        END IF;
    END LOOP;
    CLOSE bin_cur;
    INSERT INTO temp VALUES (NULL, bins_looked_at, '<- bins looked at');
    COMMIT;
END;
/
