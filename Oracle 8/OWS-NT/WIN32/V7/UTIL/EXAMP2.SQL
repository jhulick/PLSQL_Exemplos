rem 
rem $Header: examp2.sql,v 1.2 1992/12/02 16:16:15 GCLOSSMA Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      examp2.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     gclossma   12/02/92 -  cuz 
Rem     rvasired   05/12/92 -  Creation 
/*
** This block debits account 3 by $500 only if there are sufficient
** funds to cover the withdrawal.
**
** Copyright (c) 1989,1992 by Oracle Corporation
*/

DECLARE
    acct_balance  NUMBER(11,2);
    acct          CONSTANT NUMBER(4) := 3;
    debit_amt     CONSTANT NUMBER(5,2) := 500.00;
BEGIN
    SELECT bal INTO acct_balance FROM accounts
        WHERE account_id = acct
        FOR UPDATE OF bal;
    
    IF acct_balance >= debit_amt THEN
        UPDATE accounts SET bal = bal - debit_amt
            WHERE account_id = acct;
    ELSE
        INSERT INTO temp VALUES
            (acct, acct_balance, 'Insufficient funds');
                -- insert account, current balance, and message
    END IF;

    COMMIT;
END;
/
