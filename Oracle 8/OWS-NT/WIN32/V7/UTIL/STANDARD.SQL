rem 
rem $Header: standard.sql  21-feb-95.14:19:35 cbarclay Exp $ 
rem 
Rem  Copyright (c) 1991, 1995 by Oracle Corporation 
Rem    NAME
Rem      standard.sql - standard types and functions
Rem                  
Rem    DESCRIPTION
Rem      This is generated in a PLSQL dve from stdspc.pls and stdbdy.pls
Rem      using a PLSQL tool (ps2s.pls). At release times, this file
Rem      should be checked out and the old generated portion below
Rem      should be replaced by the new generated portion.
Rem
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     cbarclay   02/21/95 -  fixing ROWTYPE_MISMATCH position
Rem     cbarclay   02/21/95 -  fixing ROWTYPE_MISMATCH position
Rem     cbarclay   02/21/95 -  add exception ROWTYPE_MISMATCH
Rem     rhari      02/20/95 -  Adding acos, asin, atan, atan2
Rem     gclossma   01/02/95 -  \'PDP->NDE sync\'
Rem     gclossma   01/02/95 -  243943
Rem     llao       07/06/94 -  update timestamp for diana reorg
Rem     btaymour   03/22/94 -  Regen:Merg changes from 7.1, old time stamp
Rem     spuranik   08/24/93 -  for tag k70101
Rem     kaghevli   12/18/92 -  for tag k70012 
Rem     hrizvi     12/06/92 -  for tag i92_12_06 
Rem     hrizvi     12/06/92 -  for tag i92_12_06 
Rem     kaghevli   11/28/92 -  for tag i92_11_28 
Rem     rhari      11/26/92 -  typo 
Rem     rhari      11/26/92 -  add special characters for new tag scheme 
Rem     kaghevli   11/21/92 -  Creation 
Rem 
Rem the following line is not to be changed. It should be the last line
Rem in this rcs header. The portion below it is generated.
Rem ##$$##

create or replace package STANDARD -- TIMESTAMP is comment on next line in file stdspc.pls
 timestamp '1994-07-04:00:00:00' -- utility p2s inserts this into .sql file
 is
 
  type BOOLEAN is (FALSE, TRUE);
 
  type DATE is DATE_BASE;
 
  type NUMBER is NUMBER_BASE;
  subtype FLOAT is NUMBER; -- NUMBER(126)
  subtype REAL is FLOAT; -- FLOAT(63)
  subtype "DOUBLE PRECISION" is FLOAT;
 
-- other number subtypes
  subtype INTEGER is NUMBER(38,0);
  subtype INT is INTEGER;
  subtype SMALLINT is NUMBER(38,0);
  subtype DECIMAL is NUMBER(38,0);
  subtype NUMERIC is DECIMAL;
  subtype DEC is DECIMAL;
 
 
  subtype BINARY_INTEGER is INTEGER range '-2147483647'..2147483647;
--                used to be -2147483648 - less than MAXSB4MINVAL
  subtype NATURAL is BINARY_INTEGER range 0..2147483647;
  subtype NATURALN is NATURAL not null;
  subtype POSITIVE is BINARY_INTEGER range 1..2147483647;
  subtype POSITIVEN is POSITIVE not null;
  subtype SIGNTYPE is BINARY_INTEGER range '-1'..1;  -- for SIGN functions
 
  type VARCHAR2 is NEW CHAR_BASE;
  pragma PACK(VARCHAR2);
 
  subtype VARCHAR is VARCHAR2;
  subtype STRING is VARCHAR2;
 
  subtype LONG is VARCHAR2(32760);
 
  subtype RAW is VARCHAR2;
  subtype "LONG RAW" is RAW(32760);
 
  subtype ROWID is VARCHAR2(256);
 
  -- Ansi fixed-length char
  -- Define synonyms for CHAR and CHARN.
  subtype CHAR is VARCHAR2;
  subtype CHARACTER is CHAR;
 
  type MLSLABEL is new CHAR_BASE;
--  subtype MLSLABEL is MLSLABEL_BASE(256); 
 
 
--***************** Predefined exceptions *****************
 
  CURSOR_ALREADY_OPEN exception;
    pragma EXCEPTION_INIT(CURSOR_ALREADY_OPEN, '-6511');
 
  DUP_VAL_ON_INDEX exception;
    pragma EXCEPTION_INIT(DUP_VAL_ON_INDEX, '-0001');
 
  TIMEOUT_ON_RESOURCE exception;
    pragma EXCEPTION_INIT(TIMEOUT_ON_RESOURCE, '-0051');
 
--TRANSACTION_BACKED_OUT exception;
--  pragma EXCEPTION_INIT(TRANSACTION_BACKED_OUT, '-0061');
 
  INVALID_CURSOR exception;
    pragma EXCEPTION_INIT(INVALID_CURSOR, '-1001');
 
  NOT_LOGGED_ON exception;
    pragma EXCEPTION_INIT(NOT_LOGGED_ON, '-1012');
 
  LOGIN_DENIED exception;
    pragma EXCEPTION_INIT(LOGIN_DENIED, '-1017');
 
  NO_DATA_FOUND exception;
    pragma EXCEPTION_INIT(NO_DATA_FOUND, 100);
 
  ZERO_DIVIDE exception;
    pragma EXCEPTION_INIT(ZERO_DIVIDE, '-1476');
 
  INVALID_NUMBER exception;
    pragma EXCEPTION_INIT(INVALID_NUMBER, '-1722');
 
  TOO_MANY_ROWS exception;
    pragma EXCEPTION_INIT(TOO_MANY_ROWS, '-1422');
 
  STORAGE_ERROR exception;
    pragma EXCEPTION_INIT(STORAGE_ERROR, '-6500');
 
  PROGRAM_ERROR exception;
    pragma EXCEPTION_INIT(PROGRAM_ERROR, '-6501');
 
  VALUE_ERROR exception;
    pragma EXCEPTION_INIT(VALUE_ERROR, '-6502');
 
 
--****************************************************************
 
  function "EXISTS" return BOOLEAN;
    pragma BUILTIN('EXISTS',10,240,240); -- This is special cased in PH2 -- Pj
 
  function GREATEST (pattern NUMBER) return NUMBER;
    pragma BUILTIN('GREATEST',12,240,240);-- This is special cased in PH2 -- Pj
  function GREATEST (pattern VARCHAR2) return VARCHAR2;
    pragma BUILTIN('GREATEST',12,240,240);-- This is special cased in PH2 -- Pj
  function GREATEST (pattern DATE) return DATE;
    pragma BUILTIN('GREATEST',12,240,240);-- This is special cased in PH2 -- Pj
 
  function LEAST (pattern NUMBER) return NUMBER;
    pragma BUILTIN('LEAST',13,240,240);-- This is special cased in PH2 -- Pj
  function LEAST (pattern VARCHAR2) return VARCHAR2;
    pragma BUILTIN('LEAST',13,240,240);-- This is special cased in PH2 -- Pj
  function LEAST (pattern DATE) return DATE;
    pragma BUILTIN('LEAST',13,240,240);-- This is special cased in PH2 -- Pj
 
  function DECODE (expr NUMBER, pat NUMBER, res NUMBER) return NUMBER;
    pragma BUILTIN('DECODE',22,240,240);-- This is special cased in PH2 -- Pj
  function DECODE (expr NUMBER, pat NUMBER, res VARCHAR2) return VARCHAR2;
    pragma BUILTIN('DECODE',22,240,240);-- This is special cased in PH2 -- Pj
  function DECODE (expr NUMBER, pat NUMBER, res DATE) return DATE;
    pragma BUILTIN('DECODE',22,240,240);-- This is special cased in PH2 -- Pj
 
  function DECODE (expr VARCHAR2, pat VARCHAR2, res NUMBER) return NUMBER;
    pragma BUILTIN('DECODE',22,240,240);-- This is special cased in PH2 -- Pj
  function DECODE (expr VARCHAR2, pat VARCHAR2, res VARCHAR2)
	 return VARCHAR2;
    pragma BUILTIN('DECODE',22,240,240);-- This is special cased in PH2 -- Pj
  function DECODE (expr VARCHAR2, pat VARCHAR2, res DATE) return DATE;
    pragma BUILTIN('DECODE',22,240,240);-- This is special cased in PH2 -- Pj
 
  function DECODE (expr DATE, pat DATE, res NUMBER) return NUMBER;
    pragma BUILTIN('DECODE',22,240,240);-- This is special cased in PH2 -- Pj
  function DECODE (expr DATE, pat DATE, res VARCHAR2) return VARCHAR2;
    pragma BUILTIN('DECODE',22,240,240);-- This is special cased in PH2 -- Pj
  function DECODE (expr DATE, pat DATE, res DATE) return DATE;
    pragma BUILTIN('DECODE',22,240,240);-- This is special cased in PH2 -- Pj
 
  function SQLCODE return NUMBER;
    pragma BUILTIN('SQLCODE',45, 10, 0); -- PEMS_DB, DB_SQLCODE
 
  function SQLERRM return varchar2;
    pragma FIPSFLAG('SQLERRM', 1452);	
 
  function SQLERRM (code NUMBER) return varchar2;
    pragma BUILTIN('SQLERRM',46, 10, 1); -- PEMS_DB, DB_SQLERRM
    pragma FIPSFLAG('SQLERRM', 1452);	
 
  function LEVEL return NUMBER;
 
  function ROWNUM return NUMBER;
 
  function '='  (LEFT BOOLEAN, RIGHT BOOLEAN) return BOOLEAN;
    pragma BUILTIN('=',2, 3, 1); -- PEMS_INTEGER, PEMDCMEQ
    pragma FIPSFLAG('=', 1450);	
  function '!=' (LEFT BOOLEAN, RIGHT BOOLEAN) return BOOLEAN; -- also <> and ~=
    pragma BUILTIN('!=',5, 3, 2); -- PEMS_INTEGER, PEMDCMNE
    pragma FIPSFLAG('!=', 1450);	
  function '<'  (LEFT BOOLEAN, RIGHT BOOLEAN) return BOOLEAN;
    pragma BUILTIN('<',4, 3, 3);  -- PEMS_INTEGER, PEMDCMLT
    pragma FIPSFLAG('<', 1450);	
  function '<=' (LEFT BOOLEAN, RIGHT BOOLEAN) return BOOLEAN;
    pragma BUILTIN('<=',6, 3, 4); -- PEMS_INTEGER, PEMDCMLE
    pragma FIPSFLAG('<=', 1450);	
  function '>'  (LEFT BOOLEAN, RIGHT BOOLEAN) return BOOLEAN;
    pragma BUILTIN('>',1, 3, 5); -- PEMS_INTEGER, PEMDCMGT
    pragma FIPSFLAG('>', 1450);	
  function '>=' (LEFT BOOLEAN, RIGHT BOOLEAN) return BOOLEAN;
    pragma BUILTIN('>=',3, 3, 6); -- PEMS_INTEGER, PEMDMGE
    pragma FIPSFLAG('>=', 1450);	
 
  --  Since SQL permits short-circuit evaluation, the 'and' and 'or'
  --  operations will always be interpreted as 'and then' and 'or else'
  --  when they occur in conditional statements.
 
  function XOR (LEFT BOOLEAN, RIGHT BOOLEAN) return BOOLEAN;
    pragma BUILTIN('XOR',8, 3, 9); -- PEMS_INTEGER, INT_XOR
    pragma FIPSFLAG('XOR', 1450);	
 
  function 'NOT' (RIGHT BOOLEAN) return BOOLEAN;
    pragma BUILTIN('NOT',9, 3, 10); -- PEMS_INTEGER, INT_NOT
 
  function 'IS NULL' (B BOOLEAN) return BOOLEAN;
    pragma BUILTIN('IS NULL', 0, 3, 0);  -- PEMS_INTEGER, PEMDNUL
    pragma FIPSFLAG('IS NULL', 1450);	
 
  function 'IS NOT NULL' (B BOOLEAN) return BOOLEAN;
    pragma FIPSFLAG('IS NOT NULL', 1450);	
 
  function NVL (B1 BOOLEAN, B2 BOOLEAN) return BOOLEAN;
    pragma FIPSFLAG('NVL', 1450);	
 
--****************************************************************
 
  function '='  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
    pragma BUILTIN('=',2, 1, 14); -- PEMS_CHAR, PEMDCMEQ (VARCHAR2 SEMANTICS)
    pragma FIPSFLAG('=', 1454);	
  function '!=' (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
    pragma BUILTIN('!=',5, 1, 15);  -- PEMS_CHAR, PEMDCMNE (VARCHAR2 SEMANTICS)
    pragma FIPSFLAG('!=', 1454);	
  function '<'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
    pragma BUILTIN('<',4, 1, 16); -- PEMS_CHAR, PEMDCMLT (VARCHAR2 SEMANTICS)
    pragma FIPSFLAG('<', 1454);	
  function '<=' (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
    pragma BUILTIN('<=',6, 1, 17); -- PEMS_CHAR, PEMDCMLE (VARCHAR2 SEMANTICS)
    pragma FIPSFLAG('<=', 1454);	
  function '>'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
    pragma BUILTIN('>',1, 1, 18); -- PEMS_CHAR, PEMDCMGT (VARCHAR2 SEMANTICS)
    pragma FIPSFLAG('>', 1454);	
  function '>=' (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
    pragma BUILTIN('>=',3, 1, 19); -- PEMS_CHAR, PEMDCMGE (VARCHAR2 SEMANTICS)
    pragma FIPSFLAG('>=', 1454);	
 
  function '||' (LEFT VARCHAR2, RIGHT VARCHAR2) return VARCHAR2;
    pragma BUILTIN('||',25, 1, 7); -- PEMS_CHAR, CHAR_CONCAT
    pragma FIPSFLAG('||', 1454);	
 
  function CONCAT(LEFT VARCHAR2, RIGHT VARCHAR2) return varchar2;
    pragma BUILTIN(CONCAT,25, 1, 7); -- PEMS_CHAR, CHAR_CONCAT
    pragma FIPSFLAG(CONCAT, 1454);	
 
 
  function LENGTH(ch VARCHAR2) return natural;
    pragma FIPSFLAG('LENGTH', 1452);	
 
  -- In SUBSTR, LEN defaults to remainder of string
  -- In substr and instr, a negative value of parameter POS means to
  -- count from the right end of the string.
  function SUBSTR(STR1 VARCHAR2, POS binary_integer, 
			LEN binary_integer := NULL)
	return varchar2;
    pragma FIPSFLAG('SUBSTR', 1452);	
 
  -- Find nth occurrence of str1 in str2 starting at pos
  function INSTR(STR1 VARCHAR2, STR2 VARCHAR2, POS BINARY_INTEGER := 1,
                 NTH POSITIVE := 1) return BINARY_INTEGER;
    pragma FIPSFLAG('INSTR', 1452);	
 
  function UPPER(ch VARCHAR2) return varchar2;
    pragma FIPSFLAG('UPPER', 1452);	
  function LOWER(ch VARCHAR2) return varchar2;
    pragma FIPSFLAG('LOWER', 1452);	
  function ASCII(ch VARCHAR2) return BINARY_INTEGER; -- should be ASCII.CHRANGE
    pragma FIPSFLAG('ASCII', 1452);	
  function CHR(n BINARY_INTEGER) return varchar2;  -- N should be ASCII.CHRANGE
    pragma FIPSFLAG('CHR', 1452);	
  function INITCAP(ch VARCHAR2) return varchar2;
    pragma FIPSFLAG('INITCAP', 1452);	
  function SOUNDEX(ch VARCHAR2) return varchar2;
    pragma FIPSFLAG('SOUNDEX', 1452);	
 
  function LPAD(STR1 VARCHAR2, LEN binary_integer,
		PAD VARCHAR2 := ' ') return VARCHAR2;
    pragma FIPSFLAG('LPAD', 1452);	
 
  function RPAD(STR1 VARCHAR2, LEN binary_integer,
		PAD VARCHAR2 := ' ') return VARCHAR2;
    pragma FIPSFLAG('RPAD', 1452);	 
 
  function TRANSLATE(STR1 VARCHAR2, SRC VARCHAR2, DEST VARCHAR2)
	return VARCHAR2;
    pragma FIPSFLAG('TRANSLATE', 1452);	
 
  function REPLACE(SRCSTR VARCHAR2, OLDSUB VARCHAR2,
		   NEWSUB VARCHAR2 := '') return VARCHAR2;
    pragma FIPSFLAG('REPLACE', 1452);
 
  function LTRIM(STR1 VARCHAR2 := ' ',
	 	 TSET VARCHAR2 := ' ') return VARCHAR2;
    pragma FIPSFLAG('LTRIM', 1452);
 
  function RTRIM(STR1 VARCHAR2 := ' ',
	 	 TSET VARCHAR2 := ' ') return VARCHAR2;
    pragma FIPSFLAG('RTRIM', 1452);
 
  function 'LIKE' (str VARCHAR2, pat VARCHAR2) return BOOLEAN;
  function 'NOT_LIKE' (str VARCHAR2, pat VARCHAR2) return BOOLEAN;
  function 'LIKE' (str VARCHAR2, pat VARCHAR2, esc VARCHAR2) return BOOLEAN;
  function 'NOT_LIKE' (str VARCHAR2, pat VARCHAR2, esc VARCHAR2) 
	return BOOLEAN;
  function 'IS NULL' (s VARCHAR2) return BOOLEAN;
    pragma BUILTIN('IS NULL', 0, 1, 20);  -- PEMS_CHAR, PEMDNUL
  function 'IS NOT NULL' (s VARCHAR2) return BOOLEAN;
 
  function NVL(s1 VARCHAR2, s2 VARCHAR2) return VARCHAR2;
    pragma FIPSFLAG('NVL', 1452);
 
 
--****************************************************************
 
  function '='  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
    pragma BUILTIN('=',2, 2, 1); -- PEMS_NUMBER, PEMDCMEQ
  function '!=' (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;  -- also <> and ~=
    pragma BUILTIN('!=',5, 2, 2); -- PEMS_NUMBER, PEMDCMNE
    pragma FIPSFLAG('!=', 1452);
  function '<'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
    pragma BUILTIN('<',4, 2, 3); -- PEMS_NUMBER, PEMDCMLT
  function '<=' (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
    pragma BUILTIN('<=',6, 2, 4); -- PEMS_NUMBER, PEMDCMLE
  function '>'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
    pragma BUILTIN('>',1, 2, 5); -- PEMS_NUMBER, PEMDCMGT
  function '>=' (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
    pragma BUILTIN('>=',3, 2, 6); -- PEMS_NUMBER, PEMDCMGE
 
  function 'IS NULL' (n NUMBER) return BOOLEAN;
    pragma BUILTIN('IS NULL', 0, 2, 0); -- PEMS_NUMBER, PEMDNUL
  function 'IS NOT NULL' (n NUMBER) return BOOLEAN;
  function NVL(n1 NUMBER, n2 NUMBER) return NUMBER;
    pragma FIPSFLAG('NVL', 1452);
 
  function '+' (RIGHT NUMBER) return NUMBER;
    pragma BUILTIN('+',14, 0, 1); -- PEMS_QUICK
  function '-' (RIGHT NUMBER) return NUMBER;
    pragma BUILTIN('-',15, 2, 7); -- PEMS_NUMBER, NUM_NEG
  function ABS(n NUMBER) return NUMBER;
    pragma FIPSFLAG('ABS', 1452);
 
  function '+' (LEFT NUMBER, RIGHT NUMBER) return NUMBER;
    pragma BUILTIN('+',14, 2, 8); -- PEMS_NUMBER, NUM_ADD
  function '-' (LEFT NUMBER, RIGHT NUMBER) return NUMBER;
    pragma BUILTIN('-',15, 2, 9); -- PEMS_NUMBER, NUM_SUB
  function '*' (LEFT NUMBER, RIGHT NUMBER) return NUMBER;
    pragma BUILTIN('*',17, 2, 10); -- PEMS_NUMBER, NUM_MUL
  function '/' (LEFT NUMBER, RIGHT NUMBER) return NUMBER;
    pragma BUILTIN('/',18, 2, 11); -- PEMS_NUMBER, NUM_DIV
 
  function 'REM' (LEFT NUMBER, RIGHT NUMBER) return NUMBER;
    pragma FIPSFLAG('REM', 1452);
  function 'MOD'(n1 NUMBER, n2 NUMBER) return NUMBER;
    pragma FIPSFLAG('MOD', 1452);
 
  function '**' (LEFT NUMBER, RIGHT NUMBER) return NUMBER;
    pragma FIPSFLAG('**', 1452);
 
  function FLOOR(n NUMBER) return NUMBER;
    pragma FIPSFLAG('FLOOR', 1452);
  function CEIL(n NUMBER) return NUMBER;
    pragma FIPSFLAG('CEIL', 1452);
  function SQRT(n NUMBER) return NUMBER;
    pragma FIPSFLAG('SQRT', 1452);
  function SIGN(n NUMBER) return SIGNTYPE;
    pragma FIPSFLAG('SIGN', 1452);
 
  function COS(N NUMBER) return NUMBER;
  function SIN(N NUMBER) return NUMBER;
  function TAN(N NUMBER) return NUMBER;
  function COSH(N NUMBER) return NUMBER;
  function SINH(N NUMBER) return NUMBER;
  function TANH(N NUMBER) return NUMBER;
  function EXP(N NUMBER) return NUMBER;
  function LN(N NUMBER) return NUMBER;
 
  function BITAND (LEFT binary_integer, RIGHT binary_integer)  
	return binary_integer; 
  function LOG (LEFT NUMBER, RIGHT NUMBER) return NUMBER;
 
  function TRUNC (n NUMBER, places binary_integer := 0) return NUMBER;
    pragma FIPSFLAG('TRUNC', 1452);
 
  function ROUND (LEFT NUMBER, RIGHT binary_integer := 0) return NUMBER;
    pragma FIPSFLAG('ROUND', 1452);
 
  function POWER (n NUMBER, e NUMBER) return NUMBER;
    pragma FIPSFLAG('POWER', 1452);
 
--****************************************************************
 
  function '='  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma BUILTIN('=',2, 12, 1); -- PEMS_DATE, PEMDCMEQ
    pragma FIPSFLAG('=', 1450);
  function '!=' (LEFT DATE, RIGHT DATE) return BOOLEAN;  -- also <> and ~=
    pragma BUILTIN('!=',5, 12, 2); -- PEMS_DATE, PEMDCMNE
    pragma FIPSFLAG('!=', 1450);
  function '<'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma BUILTIN('<',4, 12, 3); -- PEMS_DATE, PEMDCMLT
    pragma FIPSFLAG('<', 1450);
  function '<=' (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma BUILTIN('<=',6, 12, 4); -- PEMS_DATE, PEMDCMLE
    pragma FIPSFLAG('<=', 1450);
  function '>'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma BUILTIN('>',1, 12, 5);  -- PEMS_DATE, PEMDCMGT
    pragma FIPSFLAG('>', 1450);
  function '>=' (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma BUILTIN('>=',3, 12, 6);  -- PEMS_DATE, PEMDCMGE
    pragma FIPSFLAG('>=', 1450);
 
  function '+' (LEFT DATE, RIGHT NUMBER) return DATE;
    pragma BUILTIN('+',14, 12, 7); -- PEMS_DATE, DATE_ADD1
    pragma FIPSFLAG('+', 1450);
  function '+' (LEFT NUMBER, RIGHT DATE) return DATE;
    pragma BUILTIN('+',14, 12, 8); -- PEMS_DATE, DATE_ADD2
    pragma FIPSFLAG('+', 1450);
  function '-' (LEFT DATE, RIGHT NUMBER) return DATE;
    pragma BUILTIN('-',15, 12, 9); -- PEMS_DATE, DATE_SUB1
    pragma FIPSFLAG('-', 1450);
  function '-' (LEFT NUMBER, RIGHT DATE) return DATE;
    pragma BUILTIN('-',15, 12, 10); -- PEMS_DATE, DATE_SUB2
    pragma FIPSFLAG('-', 1450);
  function '-' (LEFT DATE, RIGHT DATE) return NUMBER;
    pragma BUILTIN('-',15, 12, 11); -- PEMS_DATE, DATE_SUB3
    pragma FIPSFLAG('-', 1450);
 
  function LAST_DAY(RIGHT DATE) return DATE;
    pragma BUILTIN('LAST_DAY',38, 12, 12); -- PEMS_DATE, DATE_LAST_DAY
    pragma FIPSFLAG('LAST_DAY', 1450);
  function ADD_MONTHS(LEFT DATE, RIGHT NUMBER) return DATE;
    pragma BUILTIN('ADD_MONTHS',39, 12, 13); -- PEMS_DATE, DATE_ADD_MONTHS1
    pragma FIPSFLAG('ADD_MONTHS', 1450);
  function ADD_MONTHS(LEFT NUMBER, RIGHT DATE) return DATE;
    pragma BUILTIN('ADD_MONTHS',39, 12, 14); -- PEMS_DATE, DATE_ADD_MONTHS2
    pragma FIPSFLAG('ADD_MONTHS', 1450);
 
  function MONTHS_BETWEEN(LEFT DATE, RIGHT DATE) return NUMBER;
    pragma BUILTIN('MONTHS_BETWEEN',42, 12, 15); -- PEMS_DATE, DATE_MONTHS_BET
    pragma FIPSFLAG('MONTHS_BETWEEN', 1450);
  function NEXT_DAY(LEFT DATE, RIGHT VARCHAR2) return DATE;
    pragma BUILTIN('NEXT_DAY',43, 12, 16); -- PEMS_DATE, DATE_NEXT_DAY
    pragma FIPSFLAG('NEXT_DAY', 1450);
  function ROUND(RIGHT DATE) return DATE;
    pragma BUILTIN('ROUND',24, 12, 17); -- PEMS_DATE, DATE_ROUND
    pragma FIPSFLAG('ROUND', 1450);
  function NEW_TIME(RIGHT DATE, MIDDLE VARCHAR2, LEFT VARCHAR2) return DATE;
    pragma FIPSFLAG('NEW_TIME', 1450);
 
  function 'IS NULL' (d DATE) return BOOLEAN;
    pragma BUILTIN('IS NULL', 0, 12, 0);  -- PEMS_DATE, PEMDNUL
    pragma FIPSFLAG('IS NULL', 1450);
  function 'IS NOT NULL' (d DATE) return BOOLEAN;
    pragma FIPSFLAG('IS NOT NULL', 1450);
  function NVL (d1 DATE, d2 DATE) return DATE;
    pragma FIPSFLAG('NVL', 1450);
 
--****************************************************************
 
  function TRUNC(LEFT DATE) return DATE;
    pragma BUILTIN('TRUNC',51, 12, 20); -- PEMS_DATE, DATE_TRUNC1
    pragma FIPSFLAG('TRUNC', 1450);
  function TRUNC(LEFT DATE, RIGHT VARCHAR2) return DATE;
    pragma BUILTIN('TRUNC',51, 12, 21); -- PEMS_DATE, DATE_TRUNC2
    pragma FIPSFLAG('TRUNC', 1450);
  function ROUND(LEFT DATE, RIGHT VARCHAR2) return DATE;
    pragma BUILTIN('ROUND',24, 12, 22); -- PEMS_DATE, DATE_ROUND2
    pragma FIPSFLAG('ROUND', 1450);
 
--****************************************************************
-- basetype conversion routines
 
  function TO_DATE    (RIGHT VARCHAR2)	 return DATE;
    pragma BUILTIN('TO_DATE',40, 1, 10); -- PEMS_CHAR, CHR_CNV_DAT
    pragma FIPSFLAG('TO_DATE', 1450);
 
  function TO_DATE (LEFT VARCHAR2, RIGHT VARCHAR2) return DATE;
    pragma BUILTIN('TO_DATE',40, 1, 8); -- PEMS_CHAR, CHR_CNV_DATE
    pragma FIPSFLAG('TO_DATE', 1450);
 
  function TO_DATE (LEFT NUMBER, RIGHT VARCHAR2) return DATE;
    pragma FIPSFLAG('TO_DATE', 1450);
 
  function TO_DATE(left varchar2, format varchar2, parms varchar2) return date;
 
  function TO_CHAR (RIGHT DATE) return VARCHAR2;
    pragma BUILTIN('TO_CHAR',41, 12, 23); -- PEMS_DATE, DAT_CNV_CHR2
 
  function TO_CHAR (LEFT DATE, RIGHT VARCHAR2) return VARCHAR2;
    pragma BUILTIN('TO_CHAR',41, 12, 19); -- PEMS_DATE, DAT_CNV_CHR1
    pragma FIPSFLAG('TO_CHAR', 1450);
 
  function TO_CHAR (LEFT NUMBER, RIGHT VARCHAR2) return VARCHAR2;
    pragma BUILTIN('TO_CHAR',41, 2, 12); -- PEMS_NUMBER, NUM_CNV_CHR
 
  function TO_CHAR (LEFT NUMBER) return VARCHAR2;
 
  function TO_NUMBER (LEFT NUMBER) RETURN NUMBER;
 
  function TO_NUMBER (RIGHT VARCHAR2) 	 return NUMBER;
    pragma BUILTIN('TO_NUMBER',48, 1, 9); -- PEMS_CHAR, CHR_CNV_NUM
 
  function TO_NUMBER(left varchar2, format varchar2) 	return number;
  function TO_NUMBER(left varchar2, format varchar2, parms varchar2) 
    return number;
 
--****************************************************************
 
  -- Note that we really aren't returning an binary_integer.  It returns
  -- whatever the POSth datatype is....  This should COG ok though...
  function  GETBND(POS BINARY_INTEGER)	         return BINARY_INTEGER;
    pragma BUILTIN('GETBND',240,202,240);
    pragma FIPSFLAG('GETBND', 1452);
 
  procedure SETBND(POS BINARY_INTEGER, VAL NUMBER);
    pragma BUILTIN('SETBND',240,201,240);
    pragma FIPSFLAG('SETBND', 1453);
 
 
------------ Define the Pragmas ----------------
-- (most of) these don't really need the argument_id's
-- in fact I think this is unneeded
pragma NEWPRAGMA(interface,language,subprogram);
pragma NEWPRAGMA(interface_C,subprogram,C_routine);
pragma NEWPRAGMA(Environ_Call,Call_Num,Arg);
pragma NEWPRAGMA(Environ_Call1,Call_Num,Arg);
 
 
-- Define SQL predicates.  These don't gen code, so no body is needed.
 
-- PRIOR is WEIRD - For now, it will be treated as a function call.
-- Does the function only take a column name?  how about its use in
-- a predicate?
function 'PRIOR'(colname VARCHAR2) return VARCHAR2;
    pragma FIPSFLAG('PRIOR', 1452);
function 'PRIOR'(colname NUMBER) return NUMBER;
    pragma FIPSFLAG('PRIOR', 1452);
function 'PRIOR'(colname DATE) return DATE;
    pragma FIPSFLAG('PRIOR', 1450);
 
-- Outer Join has same problem as PRIOR
function '(+)'(colname VARCHAR2) return VARCHAR2;
function '(+)'(colname NUMBER) return NUMBER;
function '(+)'(colname DATE) return DATE;
    pragma FIPSFLAG('(+)', 1450);
 
function '=ANY'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '=ANY'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('=ANY', 1450);
function '=ANY'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '!=ANY'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '!=ANY'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('!=ANY', 1450);
function '!=ANY'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '<ANY'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '<ANY'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('<ANY', 1450);
function '<ANY'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '<=ANY'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '<=ANY'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('<=ANY', 1450);
function '<=ANY'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '>ANY'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '>ANY'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('>ANY', 1450);
function '>ANY'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '>=ANY'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '>=ANY'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('>=ANY', 1450);
function '>=ANY'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '=ALL'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '=ALL'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('=ALL', 1450);
function '=ALL'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '!=ALL'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '!=ALL'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('!=ALL', 1450);
function '!=ALL'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '<ALL'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '<ALL'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('<ALL', 1450);
function '<ALL'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '<=ALL'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '<=ALL'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('<=ALL', 1450);
function '<=ALL'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '>ALL'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '>ALL'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('>ALL', 1450);
function '>ALL'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '>=ALL'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '>=ALL'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('>=ALL', 1450);
function '>=ALL'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '=SOME'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '=SOME'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('=SOME', 1450);
function '=SOME'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '!=SOME'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '!=SOME'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('!=SOME', 1450);
function '!=SOME'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '<SOME'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '<SOME'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('<SOME', 1450);
function '<SOME'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '<=SOME'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '<=SOME'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('<=SOME', 1450);
function '<=SOME'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '>SOME'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '>SOME'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('>SOME', 1450);
function '>SOME'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function '>=SOME'  (LEFT VARCHAR2, RIGHT VARCHAR2) return BOOLEAN;
function '>=SOME'  (LEFT DATE, RIGHT DATE) return BOOLEAN;
    pragma FIPSFLAG('>=SOME', 1450);
function '>=SOME'  (LEFT NUMBER, RIGHT NUMBER) return BOOLEAN;
 
function 'BETWEEN' (TESTVAL VARCHAR2, LOW VARCHAR2, HIGH VARCHAR2)
	return BOOLEAN;
function 'BETWEEN' (TESTVAL NUMBER, LOW NUMBER, HIGH NUMBER) return BOOLEAN;
function 'BETWEEN' (TESTVAL BOOLEAN, LOW BOOLEAN, HIGH BOOLEAN) return BOOLEAN;
    pragma FIPSFLAG('BETWEEN', 1450);
function 'BETWEEN' (TESTVAL DATE, LOW DATE, HIGH DATE) return BOOLEAN;
    pragma FIPSFLAG('BETWEEN', 1450);
 
 
--	SQL Transaction routines
 
procedure SET_TRANSACTION_USE(vc VARCHAR2);
procedure COMMIT;
procedure COMMIT_CM(vc VARCHAR2);
procedure ROLLBACK_NR;
procedure ROLLBACK_SV(Save_Point CHAR);
procedure SAVEPOINT(Save_Point CHAR);
 
--	Generic SQL DDL routine
 
--procedure SQL_DDL(Stmt VARCHAR2);
 
 
  function SYSDATE return DATE;
    pragma FIPSFLAG('SYSDATE', 1452);
 
  function UID return NUMBER;
    pragma FIPSFLAG('UID', 1452);
 
  function USER return VARCHAR2;
 
  function USERENV (envstr VARCHAR2) return VARCHAR2;
    pragma FIPSFLAG('USERENV', 1452);
 
 
  -- ROWID: this dreadful identifier is supposed to represent a datatype
  -- outside of SQL and and a pseudo-column (function, to us) when inside
  -- a sql statement.  ADA data model doesn't allow for any
  -- function X return X;
  -- so we must special case this.  Yuk.  There's special-case code in ph2nre
  -- which maps "rowid" to "rowid " if we're inside a SQL stmt.
  function "ROWID " return ROWID;
    pragma builtin('ROWID ', 1, 209, 240);  -- this had better never be called.
 
  function NULLFN (str VARCHAR2) return RAW;
    pragma builtin('NULLFN', 1, 0, 1); 
 
  function HEXTORAW (c VARCHAR2) return RAW;
     pragma builtin('HEXTORAW', 1, 23, 1);
 
  function RAWTOHEX (r RAW) return VARCHAR2;
     pragma builtin('RAWTOHEX', 1, 23, 2);
 
  function CHARTOROWID (str VARCHAR2) return ROWID;
    pragma builtin('CHARTOROWID', 1, 0, 1);
 
  function ROWIDTOCHAR (str ROWID) return VARCHAR2;
    pragma builtin('ROWIDTOCHAR', 1, 0, 1);
 
 
-- Trusted*Oracle additions
 
  Function ROWLABEL return MLSLABEL;  			 -- pseudo column
 
  Function TO_CHAR(label MLSLABEL) return VARCHAR2;
    pragma BUILTIN('TO_CHAR',90, 4, 1); -- PEMS_CHAR, CHR_CNV_MLS
 
  Function TO_CHAR(label MLSLABEL, format VARCHAR2) return VARCHAR2;
    pragma BUILTIN('TO_CHAR',90, 4, 19); -- PEMS_DATE, MLS_CNV_CHR1
    pragma FIPSFLAG('TO_CHAR', 1450);
 
  Function TO_LABEL(label VARCHAR2, format VARCHAR2 ) return  MLSLABEL;
    pragma BUILTIN('TO_LABEL',90, 4, 8); -- PEMS_CHAR, CHR_CNV_MLS
    pragma FIPSFLAG('TO_LABEL', 1450);
 
  Function TO_LABEL(label VARCHAR2 ) return  MLSLABEL;
    pragma BUILTIN('TO_LABEL',90, 4, 2); -- PEMS_CHAR, CHR_CNV_MLS
    pragma FIPSFLAG('TO_LABEL', 1450);
 
-- vararg routines - icds in stdbdy 
  Function LEAST_UB    (pattern MLSLABEL) return MLSLABEL;
    pragma BUILTIN('LEAST_UB',90, 4, 3); -- PEMS_CHAR, CHR_CNV_MLS
  Function GREATEST_LB (pattern MLSLABEL) return MLSLABEL;
    pragma BUILTIN('GREATEST_LB',90, 4, 4); -- PEMS_CHAR, CHR_CNV_MLS
 
  Function '>=' (label1 MLSLABEL, label2 MLSLABEL) return BOOLEAN;
  Function '>'  (label1 MLSLABEL, label2 MLSLABEL) return BOOLEAN;
  Function '<=' (label1 MLSLABEL, label2 MLSLABEL) return BOOLEAN;
  Function '<'  (label1 MLSLABEL, label2 MLSLABEL) return BOOLEAN;
  Function '='  (label1 MLSLABEL, label2 MLSLABEL) return BOOLEAN;
  Function '!=' (label1 MLSLABEL, label2 MLSLABEL) return BOOLEAN;
  function 'IS NULL' (label MLSLABEL) return BOOLEAN;
    pragma BUILTIN('IS NULL', 0, 1,20);   -- same "cod" as IS NULL(varchar2)
  function 'IS NOT NULL' (label MLSLABEL) return BOOLEAN;
 
  function NVL(label1 MLSLABEL, label2 MLSLABEL) return MLSLABEL;
    pragma FIPSFLAG('NVL', 1452);
 
-- group functions 
  Function LUB (label MLSLABEL) return MLSLABEL;
  Function GLB (label MLSLABEL) return MLSLABEL;
 
-- end of Trusted*Oracle additions 
 
 
-- beginning of NLS routines 
 
  function NLSSORT(c VARCHAR2) return RAW;
    pragma FIPSFLAG('NLSSORT', 1452);	
  function NLSSORT(c VARCHAR2, c2 VARCHAR2) return RAW;
    pragma FIPSFLAG('NLSSORT', 1452);	
  function NLS_UPPER(ch VARCHAR2, parms varchar2) return varchar2;
    pragma FIPSFLAG('NLS_UPPER', 1452);	
  function NLS_UPPER(c VARCHAR2) return VARCHAR2;
    pragma FIPSFLAG('NLS_UPPER', 1452);	
  function NLS_LOWER(ch VARCHAR2, parms varchar2) return varchar2;
    pragma FIPSFLAG('NLS_LOWER', 1452);	
  function NLS_LOWER(c VARCHAR2) return VARCHAR2;
    pragma FIPSFLAG('NLS_LOWER', 1452);	
  function NLS_INITCAP(ch VARCHAR2, parms varchar2) return varchar2;
    pragma FIPSFLAG('NLS_INITCAP', 1452);	
  function NLS_INITCAP(c VARCHAR2) return VARCHAR2;
    pragma FIPSFLAG('NLS_INITCAP', 1452);	
 
  function LENGTHB(ch VARCHAR2) return number;
    pragma FIPSFLAG('LENGTHB', 1452);	
  function SUBSTRB(STR1 VARCHAR2, POS binary_integer, 
		LEN binary_integer := NULL)
	return VARCHAR2;
    pragma FIPSFLAG('SUBSTRB', 1452);	
  function INSTRB(STR1 VARCHAR2, STR2 VARCHAR2, POS binary_integer := 1,
                 NTH binary_integer := 1) return NUMBER;
    pragma FIPSFLAG('INSTRB', 1452);	
 
  function TO_SINGLE_BYTE(c VARCHAR2) return VARCHAR2;
    pragma FIPSFLAG('TO_SINGLE_BYTE', 1452);	
  function TO_MULTI_BYTE(c VARCHAR2) return VARCHAR2;
    pragma FIPSFLAG('TO_MULTI_BYTE', 1452);	
 
  -- Next two added for NLS 6/3/92 JEM.
  function TO_CHAR(left date, format varchar2, parms varchar2) return varchar2;
  function TO_CHAR(left number, format varchar2, parms varchar2) 
    return varchar2;
 
-- end of NLS routines 
 
function CONVERT(src VARCHAR2, destcset VARCHAR2) return VARCHAR2;
function CONVERT(src VARCHAR2, destcset VARCHAR2, srccset VARCHAR2) 
	return VARCHAR2;
 
function VSIZE (e number ) return NUMBER;
    pragma builtin('VSIZE', 1, 0, 1);
function VSIZE (e DATE) return NUMBER;
    pragma builtin('VSIZE', 1, 0, 1);
function VSIZE (e VARCHAR2) return NUMBER;
    pragma builtin('VSIZE', 1, 0, 1);
 
 
-- dump 
-- dump( expr [,display_format[,start_pos[,length]]]) return VARCHAR2
function DUMP(e varchar2,df binary_integer := null,sp binary_integer := null,
		len binary_integer := null) return VARCHAR2;
    pragma builtin('DUMP', 1, 0, 1);
 
function DUMP(e number,df binary_integer := null,sp binary_integer := null,
		len binary_integer := null) return VARCHAR2;
    pragma builtin('DUMP', 1, 0, 1);
 
function DUMP(e date,df binary_integer := null,sp binary_integer := null,
		len binary_integer := null) return VARCHAR2;
    pragma builtin('DUMP', 1, 0, 1);
 
     /* exception for ref cursors  */
     ROWTYPE_MISMATCH exception;
     pragma EXCEPTION_INIT(ROWTYPE_MISMATCH, '-6504');

subtype pls_integer is binary_integer;

    -- Fips flagging for Trigonometric functions already declared
    pragma FIPSFLAG('COS', 1452);
    pragma FIPSFLAG('SIN', 1452);
    pragma FIPSFLAG('TAN', 1452);
    pragma FIPSFLAG('COSH', 1452);
    pragma FIPSFLAG('SINH', 1452);
    pragma FIPSFLAG('TANH', 1452);


--
-- ACOS, ASIN, ATAN, ATAN2 
--   Inverse Trigonometric functions
--   These functions return NULL if any of the inputs are NULL
--
  function ACOS(N NUMBER) return NUMBER;
    pragma FIPSFLAG('ACOS', 1452);
    
  function ASIN(N NUMBER) return NUMBER;
    pragma FIPSFLAG('ASIN', 1452);
    
  function ATAN(N NUMBER) return NUMBER;
    pragma FIPSFLAG('ATAN', 1452);
    
  function ATAN2(x NUMBER, y NUMBER) return NUMBER;
    pragma FIPSFLAG('ATAN2', 1452);


end STANDARD;
/

create or replace package body STANDARD is
 
subtype Cursor_Handle is binary_integer range 0..255;
 
-- icds 
 
  function peslen(ch VARCHAR2) return NATURAL;
    pragma interface (c,peslen);
  function pessub(ch VARCHAR2, pos BINARY_INTEGER, len BINARY_INTEGER) 
	return varchar2;
    pragma interface (c,pessub);
 
  function pesist(text VARCHAR2, substr VARCHAR2, 
		strt BINARY_INTEGER, cnt POSITIVE)
		return BINARY_INTEGER;
    pragma interface (c,pesist);
 
  function pesupp(ch VARCHAR2) return varchar2;
    pragma interface (c,pesupp);
 
  function peslow(ch VARCHAR2) return varchar2;
    pragma interface (c,peslow);
 
  function peslpd(ch VARCHAR2, len BINARY_INTEGER, padchar VARCHAR2) 
    	return varchar2;
    pragma interface (c,peslpd);
 
  function pesrpd(ch VARCHAR2, len BINARY_INTEGER, padchar varchar2) 
    	return varchar2;
    pragma interface (c,pesrpd);
 
  function pesasc(ch VARCHAR2) return NATURAL;
    pragma interface (c,pesasc);
 
  function peschr(n NATURAL) return varchar2;
    pragma interface (c,peschr);
 
  function pesicp(ch VARCHAR2) return varchar2;
    pragma interface (c,pesicp);
 
  function pesxlt(ch VARCHAR2, cpy VARCHAR2, frm VARCHAR2, too VARCHAR2) 
	return varchar2;
    pragma interface (c,pesxlt);
 
  function pesltr(ch VARCHAR2, trimset VARCHAR2) return varchar2;
    pragma interface (c,pesltr);
 
  function pesrtr(ch VARCHAR2, trimset VARCHAR2) return varchar2;
    pragma interface (c,pesrtr);
 
  function peslik(str varchar2, pat varchar2) return boolean;
    pragma interface (c,peslik);
 
  function pesli2(str varchar2, pat varchar2, esc varchar2) return boolean;
    pragma interface (c,pesli2);
 
  function pesabs(n NUMBER) return NUMBER;
    pragma interface (c,pesabs);
 
  function pesmod(n1 NUMBER, n2 NUMBER) return NUMBER;
    pragma interface (c,pesmod);
 
  function pesflo(n NUMBER) return NUMBER;
    pragma interface (c,pesflo);
 
  function pescei(n NUMBER) return NUMBER;
    pragma interface (c,pescei);
 
  function pessqt(n NUMBER) return NUMBER;
    pragma interface (c,pessqt);
 
  function pessgn(n NUMBER) return SIGNTYPE;
    pragma interface (c,pessgn);
 
-- trig fns 
  function pescos(n number) return number;
    pragma interface (c,pescos);
  function pessin(n number) return number;
    pragma interface (c,pessin);
  function pestan(n number) return number;
    pragma interface (c,pestan);
  function pescsh(n number) return number;
    pragma interface (c,pescsh);
  function pessnh(n number) return number;
    pragma interface (c,pessnh);
  function pestnh(n number) return number;
    pragma interface (c,pestnh);
  function pesexp(n number) return number;
    pragma interface (c,pesexp);
  function pesln(n number) return number;
    pragma interface (c,pesln);
  function peslog(left number,right number) return number;
    pragma interface (c,peslog);
  function pesbtd(left binary_integer,right binary_integer) 
	return binary_integer;
    pragma interface (c,pesbtd);
 
  function pestru(n NUMBER, places BINARY_INTEGER) return NUMBER;
    pragma interface (c,pestru);
 
  function pesrnd(n NUMBER, places BINARY_INTEGER) return NUMBER;
    pragma interface (c,pesrnd);
 
  function pespow(n NUMBER, e NUMBER) return NUMBER;
    pragma interface (c,pespow);
 
  function pesnwt(r date, m varchar2, l varchar2) return date;
    pragma interface (c,pesnwt);
 
  function pessdt return DATE;
    pragma interface (c,pessdt);
 
  function pesxco(c VARCHAR2, format VARCHAR2) return raw;
    pragma interface (c,pesxco);
 
  function pesxup(ch VARCHAR2, format VARCHAR2) return varchar2;
    pragma interface (c,pesxup);
 
  function pesxlo(ch VARCHAR2, format VARCHAR2) return varchar2;
    pragma interface (c,pesxlo);
 
  function pesxcp(ch VARCHAR2, format VARCHAR2) return varchar2;
    pragma interface (c,pesxcp);
 
  function pesxln(ch VARCHAR2) return NATURAL;
    pragma interface (c,pesxln);
 
  function pesxsu(ch VARCHAR2, pos BINARY_INTEGER, len BINARY_INTEGER) 
	return varchar2;
    pragma interface (c,pesxsu);
 
  function pesxis(text VARCHAR2, substr VARCHAR2, strt BINARY_INTEGER, 
	cnt POSITIVE)
		return BINARY_INTEGER;
    pragma interface (c,pesxis);
 
  function pesxsi(ch VARCHAR2) return varchar2;
    pragma interface (c,pesxsi);
 
  function pesxmu(ch VARCHAR2) return varchar2;
    pragma interface (c,pesxmu);
 
  function pesc2d(left varchar2, format varchar2, parms varchar2) return date;
    pragma interface(c, pesc2d);
 
  function pesc2n(left varchar2, format varchar2, parms varchar2) 
	return number;
    pragma interface(c, pesc2n);
 
  function pesd2c(left date, format varchar2, parms varchar2) return varchar2;
    pragma interface(c, pesd2c);
 
  function pesn2c(left number, format varchar2, parms varchar2) 
	return varchar2;
    pragma interface(c, pesn2c);
 
-- end of NLS icds
 
-- begin trusted icds
-- Comparisons
  function peszge(label1 MLSLABEL,label2 MLSLABEL) return BOOLEAN;
    pragma interface (c,peszge);
  function peszgt(label1 MLSLABEL,label2 MLSLABEL) return BOOLEAN;
    pragma interface (c,peszgt);
  function peszle(label1 MLSLABEL,label2 MLSLABEL) return BOOLEAN;
    pragma interface (c,peszle);
  function peszlt(label1 MLSLABEL,label2 MLSLABEL) return BOOLEAN;
    pragma interface (c,peszlt);
  function peszeq(label1 MLSLABEL,label2 MLSLABEL) return BOOLEAN;
    pragma interface (c,peszeq);
  function peszne(label1 MLSLABEL,label2 MLSLABEL) return BOOLEAN;
    pragma interface (c,peszne);
-- Conversions
--  function peslts(label MLSLABEL,format VARCHAR2) return VARCHAR2;
--    pragma interface (c,peslts);
--  function pesstl(label varchar2,format VARCHAR2) return MLSLABEL;
--    pragma interface (c,pesstl);
-- end trusted icds
-----------------------------------------------------------
 
  function 'IS NOT NULL'(b BOOLEAN) return BOOLEAN is
  begin
    return (NOT b IS NULL);
  end 'IS NOT NULL';
 
  function NVL (b1 BOOLEAN, b2 BOOLEAN) return BOOLEAN is
  begin
    if (b1 IS NULL) then return (b2); else return(b1); end if;
  end NVL;
 
  function sqlerrm return varchar2 is
    n1 number;
  begin
    n1 := sqlcode;
    return sqlerrm(n1);
  end sqlerrm;
 
  function length (ch varchar2) return natural is
  begin
    return peslen(ch);
  end length;
 
  function SUBSTR(STR1 VARCHAR2, POS BINARY_INTEGER, 
			LEN BINARY_INTEGER := NULL) 
	return varchar2 is
  begin
    return pessub(STR1, POS, LEN);
  end SUBSTR;
 
  function INSTR(STR1 VARCHAR2, STR2 VARCHAR2, POS BINARY_INTEGER := 1,
                 NTH POSITIVE := 1) return BINARY_INTEGER is
  begin
    return pesist(STR1, STR2, POS, NTH);
  end INSTR;
 
  function UPPER(ch VARCHAR2) return varchar2 is
  begin
    return pesupp(ch);
  end UPPER;
 
  function LOWER(ch VARCHAR2) return varchar2 is
  begin
    return peslow(ch);
  end LOWER;
 
  function ASCII(ch VARCHAR2) return BINARY_INTEGER is
  begin
    return pesasc(ch);
  end ASCII;
 
  function CHR(n BINARY_INTEGER) return varchar2 is
  begin
    return peschr(n);
  end CHR;
 
  function INITCAP(ch VARCHAR2) return varchar2 is
  begin
    return pesicp(ch);
  end INITCAP;
 
  function SOUNDEX(ch VARCHAR2) return varchar2 is
    c varchar2(2000);
  begin
  --return pessdx(ch);
    select soundex(ch) into c from sys.dual;
    return c;
  end SOUNDEX;
 
--
-- This was previously called from LPAD and RPAD. But they now call pes{lr}pd.
-- 10/14/92 JEM.
--
--  function l_r_pad(STR1 VARCHAR2, LEN BINARY_INTEGER, 
--			PAD VARCHAR2, LEFT BOOLEAN)
--	 return VARCHAR2 is
--  str1len binary_integer; padlen binary_integer; 
--  newlen binary_integer; newstr varchar2(32767); len2 binary_integer;
--  begin
--    len2 := len;
--    if str1 IS NULL) or (len2 IS NULL) or (pad IS NULL)
--      then return(''); end if;
--    str1len := length(str1);
--    if (str1len >= len2) then return(substr(str1, 1, len2)); end if;
--    padlen := length(pad);
--    newstr := '';
--    newlen := 0;
--    len2 := len2 - str1len;
--    while newlen < len2 loop
--      newstr := pad || newstr; newlen := newlen + padlen;
--    end loop;
--    if left then return(substr(newstr, 1, len2) || str1);
--	    else return(str1 || substr(newstr, 1, len2)); end if;
--  end l_r_pad;
 
  function LPAD(STR1 VARCHAR2, LEN binary_integer, 
		PAD VARCHAR2 := ' ') return VARCHAR2 is
  begin
    return peslpd(STR1, LEN, PAD);
--    return(l_r_pad(str1, len, pad, true));    replaced 10/14/92 JEM.
  end LPAD;
 
  function RPAD(STR1 VARCHAR2, LEN binary_integer,
	        PAD VARCHAR2 := ' ') return VARCHAR2 is 
  begin 
    return pesrpd(STR1, LEN, PAD);
--    return(l_r_pad(str1, len, pad, false));   replaced 10/14/92 JEM.
  end RPAD;
 
  function TRANSLATE(STR1 VARCHAR2, SRC VARCHAR2, DEST VARCHAR2) 
	return varchar2 is
  begin
    if str1 is null then return str1; else
	-- The substr and concat in arg list to pesxlt is done to
	-- allocate a modifiable COPY of the first arg, STR1. This
	-- operation is a complete cheat, because we pass the copy
	-- as an IN parm, and modify it on the sly.  
    return pesxlt(STR1, substr(str1,1,1) || substr(str1,2),
			   SRC, DEST);
    end if;
  end TRANSLATE;
 
  function REPLACE(SRCSTR VARCHAR2, OLDSUB VARCHAR2,
	 	   NEWSUB VARCHAR2 := '') RETURN VARCHAR2 
  is
  brk binary_integer;
  begin
    if srcstr is null then return '';
    else
	brk := instr(srcstr, oldsub);
	if brk > 0
	then
	  return(substr(srcstr, 1, brk - 1) || newsub 
		 || replace(substr(srcstr, 
				    brk + length(oldsub)),
			    oldsub, newsub));
	else return srcstr; 
	end if;
    end if;
  end;
 
  function LTRIM(STR1 VARCHAR2 := ' ',
		 TSET VARCHAR2 := ' ') return varchar2 is
  begin
    return pesltr(STR1, TSET);
  end LTRIM;
 
  function RTRIM(STR1 VARCHAR2 := ' ',
		 TSET VARCHAR2 := ' ') return varchar2 is
  begin
    return pesrtr(STR1, TSET);
  end RTRIM; 
 
  -- might we want to combine peslik and pesli2? 
  function 'LIKE' (str varchar2, pat varchar2) return boolean is
  begin
    return peslik(str, pat);
  end;
  function 'NOT_LIKE' (str varchar2, pat varchar2) return boolean is
  begin
    return (not peslik(str, pat));
  end;
  function 'LIKE' (str varchar2, pat varchar2, esc varchar2) return boolean is
  begin
    return pesli2(str, pat, esc);
  end;
  function 'NOT_LIKE' (str varchar2, pat varchar2, esc varchar2) return boolean is
  begin
    return (not pesli2(str, pat, esc));
  end;
 
  function 'IS NOT NULL'(s VARCHAR2) return BOOLEAN is
  begin
    return (NOT (s IS NULL));
  end 'IS NOT NULL';
 
  function NVL (s1 VARCHAR2, s2 VARCHAR2) return varchar2 is
  begin
    if (s1 IS NULL) then return (s2); else return (s1); end if;
  end NVL;
 
  function 'IS NOT NULL'(n NUMBER) return BOOLEAN is
  begin
    return (NOT (n IS NULL));
  end 'IS NOT NULL';
 
  function NVL (n1 NUMBER, n2 NUMBER) return NUMBER is
  begin
    if (n1 IS NULL) then return (n2); else return(n1); end if;
  end NVL;
 
  function ABS(n NUMBER) return NUMBER is
  begin
    return pesabs(n);
  end ABS;
 
  function 'REM' (LEFT NUMBER, RIGHT NUMBER) return NUMBER is
  begin
    return (LEFT - (trunc(LEFT / RIGHT) * RIGHT));
  end;
 
  function 'MOD'(n1 NUMBER, n2 NUMBER) return NUMBER is
  begin
  --return (n1 - ((floor(n1/n2)) * n2));  
    return pesmod(n1,n2);
  end;
 
  function '**' (LEFT NUMBER, RIGHT NUMBER) return NUMBER is
  begin
    return (POWER(LEFT, RIGHT));
  end;
 
  function FLOOR(n NUMBER) return NUMBER is
  begin
    return pesflo(n);
  end FLOOR;
 
  function CEIL(n NUMBER) return NUMBER is
  begin
    return pescei(n);
  end CEIL;
 
  function SQRT(n NUMBER) return NUMBER is
  begin
    if (0.0 > n) then raise VALUE_ERROR; end if;
    return pessqt(n);
  end SQRT;
 
  function SIGN(n NUMBER) return SIGNTYPE is
  begin
    return pessgn(n);
  end SIGN;
 
 
  function COS(N NUMBER) return NUMBER IS
   begin return(pescos(n)); end;
  function SIN(N NUMBER) return NUMBER IS
   begin return(pessin(n)); end;
  function TAN(N NUMBER) return NUMBER IS
   begin return(pestan(n)); end;
  function COSH(N NUMBER) return NUMBER IS
   begin return(pescsh(n)); end;
  function SINH(N NUMBER) return NUMBER IS
   begin return(pessnh(n)); end;
  function TANH(N NUMBER) return NUMBER IS
   begin return(pestnh(n)); end;
  function EXP(N NUMBER) return NUMBER IS
   begin return(pesexp(n)); end;
  function LN(N NUMBER) return NUMBER IS
   begin return(pesln(n)); end;
  function LOG(LEFT NUMBER, RIGHT NUMBER) return NUMBER IS
    begin return(peslog(left,right)); end;
  function BITAND(LEFT binary_integer, RIGHT binary_integer) 
	return binary_integer IS        
    begin return(pesbtd(left,right)); END;
 
  function TRUNC(n NUMBER, places BINARY_INTEGER := 0) return NUMBER is
  begin
    return pestru(n, places);
  end TRUNC;
 
  function ROUND(LEFT NUMBER, RIGHT BINARY_INTEGER := 0) return NUMBER is
  begin
    return pesrnd(LEFT, RIGHT);
  end ROUND;
 
  function POWER(n NUMBER, e NUMBER) return NUMBER is
  begin
    return pespow(n, e);
  end POWER;
 
  function NEW_TIME(right DATE, middle VARCHAR2, left VARCHAR2) return DATE is
  begin
    return pesnwt(right, middle, left);
  end;
 
  function 'IS NOT NULL'(d DATE) return BOOLEAN is
  begin
    return(NOT (d IS NULL));
  end 'IS NOT NULL';
 
  function NVL (d1 DATE, d2 DATE) return DATE is
  begin
    if (d1 IS NULL) then return(d2); else return(d1); end if;
  end NVL;
 
-- Just call the other to_char with a null format string. 
-- Perhaps this can be done more intelligently in the future. JEM 3/14/90.
  function TO_CHAR(LEFT NUMBER)	 return varchar2 is
  begin
    return TO_CHAR(LEFT, '');
  end TO_CHAR;
 
-- Added 3/16/90 by JEM.
 function TO_NUMBER(LEFT NUMBER) return NUMBER is
 begin
   return(LEFT);
 end to_number;
 
function TO_DATE(LEFT NUMBER, RIGHT VARCHAR2) return DATE IS
begin
  return (TO_DATE(TO_char(LEFT), RIGHT));
end TO_DATE;
 
--	SQL 'PSD' routines
 
Procedure plzopn(cnum OUT Cursor_Handle, rc OUT Binary_Integer);
    pragma interface (c,plzopn);
Function plzosq(cnum Cursor_Handle, stmt VARCHAR2) return Binary_Integer;
    pragma interface (c,plzosq);
Function plzexe(cnum Cursor_Handle,chp Binary_Integer,nbnds Binary_Integer) 
    return Binary_Integer;
    pragma interface (c,plzexe);
Function plzexe(cnum Cursor_Handle) return Binary_Integer is
Begin
  return(plzexe(cnum,0,0));
End;
Function plzcls(cnum Cursor_Handle) return Binary_Integer;
    pragma interface (c,plzcls);
 
--	Generic SQL DDL routine
 
procedure SQL_DDL(Stmt VARCHAR2) is
  rc Binary_Integer;
  cnum Cursor_Handle;
  DDL_ERROR exception;
Begin
  plzopn(cnum,rc);
  if ( rc IS NOT NULL ) then
    RAISE DDL_ERROR;
  end if;
  rc := plzosq(cnum,Stmt);
  if ( rc IS NOT NULL ) then
    RAISE DDL_ERROR;
  end if;
  rc := plzexe(cnum);
  if ( rc IS NOT NULL ) then
    RAISE DDL_ERROR;
  end if;
  rc := plzcls(cnum);
  if ( rc IS NOT NULL ) then
    RAISE DDL_ERROR;
  end if;
End;
 
--	SQL Transaction routines
 
procedure SET_TRANSACTION_USE (vc varchar2) is
Begin
  SQL_DDL('SET TRANSACTION USE ROLLBACK SEGMENT ' || vc);
End;
 
procedure COMMIT is
Begin
  SQL_DDL('COMMIT');
End;
 
procedure COMMIT_CM (vc varchar2) is
Begin
  SQL_DDL('COMMIT work comment ' || '''' || vc || '''');
End;
 
procedure ROLLBACK_NR is
Begin
  SQL_DDL('ROLLBACK');
End;
 
procedure ROLLBACK_SV(Save_Point CHAR) is
Begin
  SQL_DDL('ROLLBACK TO ' || Save_Point);
End;
 
procedure SAVEPOINT(Save_Point CHAR) is
begin
  SQL_DDL('SAVEPOINT ' || Save_Point);
end;
 
  function SYSDATE return DATE is begin return pessdt; end;
 
  function UID return NUMBER is
  n number;
  begin
	select uid into n from sys.dual;
	return n;
  end;
 
  function USER return varchar2 is
  c varchar2(255);
  begin
	select user into c from sys.dual;
	return c;
  end;
 
  function USERENV (envstr VARCHAR2) return varchar2 is
  c varchar2(255);
  begin
    c := upper(envstr);
    if c is null then 
	null;
    elsif c = 'TERMINAL' then
	select userenv('TERMINAL') into c from sys.dual;
    elsif c = 'ENTRYID' then
	select userenv('ENTRYID') into c from sys.dual;
    elsif c = 'SESSIONID' then
	select userenv('SESSIONID') into c from sys.dual;
    elsif c = 'LANGUAGE' then
	select userenv('LANGUAGE') into c from sys.dual;
    elsif c = 'LABEL' then
	select userenv('LABEL') into c from sys.dual;
    else raise VALUE_ERROR;
    end if;
    return c;
  end;
 
-- Trusted*Oracle additions 
 
  Function ROWLABEL return MLSLABEL is
        begin return null; end;
-- removed - now builtin's
/*
  Function TO_CHAR(label MLSLABEL, format varchar2 := '')
	 return VARCHAR2 is
    begin return peslts(label,format); end;
 
  Function TO_LABEL(label varchar2, format varchar2 := '')
	 return MLSLABEL is
    begin return pesstl(label,format); end;
*/
-- Comparison functions 
  Function '>=' (label1 MLSLABEL, label2 MLSLABEL) return BOOLEAN is
    begin return peszge(label1,label2); end;
  Function '>'  (label1 MLSLABEL, label2 MLSLABEL) return BOOLEAN is
    begin return peszgt(label1,label2); end;
  Function '<=' (label1 MLSLABEL, label2 MLSLABEL) return BOOLEAN is
    begin return peszle(label1,label2); end;
  Function '<'  (label1 MLSLABEL, label2 MLSLABEL) return BOOLEAN is
    begin return peszlt(label1,label2); end;
  Function '='  (label1 MLSLABEL, label2 MLSLABEL) return BOOLEAN is
    begin return peszeq(label1,label2); end;
  Function '!=' (label1 MLSLABEL, label2 MLSLABEL) return BOOLEAN is
    begin return peszne(label1,label2); end;
 
  function 'IS NOT NULL'(label MLSLABEL) return BOOLEAN is
  begin
    return (NOT (label IS NULL));
  end 'IS NOT NULL';
 
  function NVL (label1 MLSLABEL, label2 MLSLABEL) return MLSLABEL is
  begin
    if (label1 IS NULL) then return (label2); else return (label1); end if;
  end NVL;
 
-- group functions 
  Function LUB (label MLSLABEL) return MLSLABEL is
	begin return null; end;
  Function GLB (label MLSLABEL) return MLSLABEL is
	begin return null; end;
 
-- end of Trusted*Oracle additions 
 
    
-- beginning of NLS routines 
-- replaced with new versions 6/3/92 JEM 
 
  function NLSSORT(c VARCHAR2, c2 varchar2) return raw is
  begin
    return pesxco(c, c2);
  end NLSSORT;
 
  function NLSSORT(c VARCHAR2) return raw is
  begin
    return pesxco(c,'');
  end NLSSORT;
 
  function NLS_UPPER(ch VARCHAR2, parms varchar2) return varchar2 is
  begin
    return pesxup(ch,parms);
  end NLS_UPPER;
 
  function NLS_UPPER(c VARCHAR2) return varchar2 is
  begin
    return pesxup(c,'');
  end NLS_UPPER;
 
  function NLS_LOWER(ch VARCHAR2, parms varchar2) return varchar2 is
  begin
    return pesxlo(ch,parms);
  end NLS_LOWER;
 
  function NLS_LOWER(c VARCHAR2) return varchar2 is
  begin
    return pesxlo(c,'');
  end NLS_LOWER;
 
  function NLS_INITCAP(ch VARCHAR2, parms varchar2) return varchar2 is
  begin
    return pesxcp(ch,parms);
  end NLS_INITCAP;
 
  function NLS_INITCAP(c VARCHAR2) return varchar2 is
  begin
    return pesxcp(c,'');
  end NLS_INITCAP;
 
  function LENGTHB(ch VARCHAR2) return NUMBER is
  begin
    return TO_NUMBER(pesxln(ch));
  end LENGTHB;
 
  function SUBSTRB(STR1 VARCHAR2, POS binary_integer, 
			LEN binary_integer := NULL) 
	return varchar2 is
  begin
    return pesxsu(str1, pos, len);
  end SUBSTRB;
 
  function INSTRB(STR1 VARCHAR2, STR2 VARCHAR2, POS binary_integer := 1,
                 NTH binary_integer := 1) return NUMBER is
  begin
    return pesxis(STR1, STR2, pos, nth);
  end INSTRB;
 
  function TO_SINGLE_BYTE(c VARCHAR2) return varchar2 is
  begin
    return pesxsi(c);
  end TO_SINGLE_BYTE;
 
  function TO_MULTI_BYTE(c VARCHAR2) return varchar2 is
  begin
    return pesxmu(c);
  end TO_MULTI_BYTE;
 
  function TO_DATE(left varchar2, format varchar2, parms varchar2) 
   	   return date is
  begin
    return pesc2d(left, format, parms);
  end TO_DATE;
 
  function TO_NUMBER(left varchar2, format varchar2) return number is
  begin
    return pesc2n(left, format, '');
  end TO_NUMBER;
 
  function TO_NUMBER(left varchar2, format varchar2, parms varchar2) 
    return number is
  begin
    return pesc2n(left, format, parms);
  end TO_NUMBER;
 
  function TO_CHAR(left date, format varchar2, parms varchar2) 
  	   return varchar2 is
  begin
    return pesd2c(left, format, parms);
  end TO_CHAR;
 
  function TO_CHAR(left number, format varchar2, parms varchar2) 
    return varchar2 is
  begin
    return pesn2c(left, format, parms);
  end TO_CHAR;
 
-- end of NLS routines 
 
 
function CONVERT(src varchar2, destcset varchar2) return varchar2
is
  v varchar2(2000);
  begin
  select convert(src,destcset) into v from sys.dual;
  return v;
end;
 
function CONVERT(src varchar2, destcset varchar2,srccset varchar2) return varchar2
is
  v varchar2(2000);
  begin
  select convert(src,destcset,srccset) into v from sys.dual;
  return v;
end;
 
-- DUMP and VSIZE are now not allowed in non-sql plsql, has code to forbid 
-- it there, and is defined as a builtin in stdspc. The body will not be 
-- called in plsql.
--- CMB
----
-- dump 
-- dump( expr [,display_format[,start_pos[,length]]]) return varchar2
-- how large should the plsql varchar2 string be 
--
 
-- why do we need these dummy bodies for LEVEL and ROWNUM?
 
  function LEVEL return NUMBER is
	begin return 0.0; end;
 
  function ROWNUM return NUMBER is
	begin return 0.0; end;


--
-- ACOS, ASIN, ATAN, ATAN2 
--   These functions return NULL if any of the inputs are NULL
--
  function pesacos(n NUMBER) return NUMBER;
    pragma interface (c,pesacos);

  function pesasin(n NUMBER) return NUMBER;
    pragma interface (c,pesasin);

  function pesatan(n NUMBER) return NUMBER;
    pragma interface (c,pesatan);

  function pesatn2(x NUMBER, y NUMBER) return NUMBER;
    pragma interface (c,pesatn2);

  function ACOS(n NUMBER) return NUMBER is
  begin
    if (n > 1) or (n < -1) then raise VALUE_ERROR; end if;
    return pesacos(n);
  end ACOS;

  function ASIN(n NUMBER) return NUMBER is
  begin
    if (n > 1) or (n < -1) then raise VALUE_ERROR; end if;
    return pesasin(n);
  end ASIN;

  function ATAN(n NUMBER) return NUMBER is
  begin
    -- anything is legal
    return pesatan(n);
  end ATAN;

  
  function ATAN2(x NUMBER, y NUMBER) return NUMBER is
  begin
    if ((x = 0) and (y = 0)) then raise VALUE_ERROR; end if;
    return pesatn2(x, y);
  end ATAN2;

    
end STANDARD;
/
