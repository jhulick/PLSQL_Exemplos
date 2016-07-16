REM **************************************************************
REM David L. Hunt (file author) distributes this and other 
REM files/scripts for educational purposes only, to illustrate the 
REM use or application of various computing techniques. Neither the 
REM author nor Oracle Corporation makes any warranty regarding this 
REM script's fitness for any industrial application or purpose nor is 
REM there any claim that this or any similarly-distributed scripts 
REM are error free or should be used for any purpose other than
REM illustration.
REM 
REM Please contact the author via email (see address below) when 
REM you have comments, suggestions, and/or difficulties with this
REM packages functions.
REM
REM [Please keep the above disclaimer and the embedded electronic 
REM  documentation with this script.]
REM **************************************************************
REM About this script/file:
REM
REM NAME: SPELCHEK.SQL - PL/SQL code to create a package (DH_UTIL)
REM       providing 1) Number spelling and 2) Bank Draft/Checking
REM       protection via spelled amounts.
REM
REM AUTHOR: Dave Hunt, Senior Principal Instructor
REM         Oracle Eduction Services
REM         170 South Main Street, Suite 1150
REM         Salt Lake City, Utah, USA  84101
REM         dhunt@us.oracle.com
REM
REM **************************************************************
REM Maintenance History:
REM
REM 24-APR-96: Original Code
REM 03-MAR-96: Enhanced to handle 1) negative numbers and 2) zero
REM 16-JAN-97: Enhanced to translate non-integer decimal numbers
REM 20-JAN-97: Enhanced to handle numbers in the range:
REM            (-10 ** 100)+1 to (10 ** 100) -1 with precision to
REM            40 digits. Up to 40 digits behind the decimal point
REM            can be spelled.
REM 25-JAN-97: Added additional documentation and remarks.
REM **************************************************************
REM This package contains two GLOBAL functions:
REM   1) DH_UTIL.SPELL: Translates a number into English words.
REM      [Note: This version contains "American" (vs. "British")
REM             numeric-magnitude wordings: 
REM
REM                         Number American     British 
REM      ------------------------- -----------  -----------------
REM                  1,000,000,000 Billion      Milliard
REM              1,000,000,000,000 Trillion     Billion
REM          1,000,000,000,000,000 Quadrillion  Thousand Billion
REM      1,000,000,000,000,000,000 Quintillion  Trillion
REM
REM      For British system spellings, modify the table as needed
REM      at the end of the Package Body.]
REM 
REM **************************************************************
REM      Function 1 Usage: "DH_UTIL.SPELL(any-number)"
REM      SQL Example:
REM         SELECT last_name,
REM            salary, DH_UTIL.SPELL(salary) Worded
REM         FROM s_emp;"
REM
REM         LAST_NAME    SALARY WORDED
REM         ------------ ------ --------------------------------
REM         Velasquez      2500 Two Thousand Five Hundred
REM         Ngao           1450 One Thousand Four Hundred Fifty
REM         Nagayama       1400 One Thousand Four Hundred
REM
REM **************************************************************
REM      PL/SQL Example:
REM         BEGIN
REM            DBMS_OUTPUT.PUT_LINE
REM              (dh_util.spell(-123456789.123456789));
REM         END;
REM         /
REM         Negative One Hundred Twenty-Three Million Four 
REM         Hundred Fifty-Six Thousand Seven Hundred Eighty-Nine
REM         and One Hundred Twenty-Three Million Four 
REM         Hundred Fifty-Six Thousand Seven Hundred
REM         Eighty-Nine / Billionths
REM
REM **************************************************************
REM **************************************************************
REM   2) DH_UTIL.CHECK_PROTECT: Translates a number into spelled
REM         "Dollars & Cents".
REM      Function 2 Usage: "DH_UTIL.CHECK_PROTECT(any-number)"
REM **************************************************************
REM      SQL Example:
REM         select 'Pay to the order of: '||
REM           rpad(ltrim(first_name||' '||last_name||' '),22,'*')
REM           ||'  '||lpad(rtrim(' '||ltrim(nvl(
REM           to_char(salary,'$99,999,990.00'),'Null Amount')
REM                )),16,'*')||chr(10)||
REM           rpad('** '||
REM           dh_util.check_protect(SALARY)||' ',56,'*') " "
REM         from s_emp
REM         where rownum <= 3;
REM         
REM  Pay to the order of: Carmen Velasquez *****  ****** $2,500.00
REM  ** Two Thousand Five Hundred Dollars and Zero Cents *********
REM         
REM  Pay to the order of: LaDoris Ngao *********  ****** $1,450.00
REM  ** One Thousand Four Hundred Fifty Dollars and Zero Cents ***
REM       
REM  Pay to the order of: Midori Nagayama ******  ****** $1,400.00
REM  ** One Thousand Four Hundred Dollars and Zero Cents *********
REM
REM **************************************************************
REM      PL/SQL Example:
REM         begin
REM            dbms_output.put_line
REM               (dh_util.check_protect(123456789.56));
REM         end;
REM         /
REM      One Hundred Twenty-Three Million Four Hundred 
REM      Fifty-Six Thousand Seven Hundred Eighty-Nine Dollars
REM      and Fifty-Six Cents
REM
REM **************************************************************
REM DH_UTIL Package Specification
REM **************************************************************
create or replace package dh_util is
   function spell (x in number) return varchar2;
   function check_protect (x in number) return varchar2;
   pragma restrict_references(spell,WNDS);
   pragma restrict_references(check_protect,WNDS);
end;
/
REM **************************************************************
REM DH_UTIL Package Body
REM **************************************************************
create or replace package body dh_util is
  result   varchar2(2000);
  working_integer        number;
  working_decimal        varchar2(100);
  working_dec_mag        number;
  working_integer_spell  varchar2(2000);
  working_decimal_spell  varchar2(2000);
  working_fraction_spell varchar2(2000);
  type number_stencil is table of number
       index by binary_integer;
  type varchar2_stencil is table of varchar2(2000)
       index by binary_integer;
  denom varchar2_stencil;
  pad_factor number_stencil;
  hold varchar2_stencil;
--  **************************************************************
--  Packaged Global Function Definition: DH_UTIL.SPELL 
--  **************************************************************
function spell (x in number) return varchar2 is
--  **************************************************************
--  Local Function Specification: WORDING
--  **************************************************************
  function wording (x in number) return varchar2 is
  begin
     if x = 0 then
        return 'Zero';
     else
        return to_char(to_date(x,'j'),'Jsp'); -- Numbers-to-words
     end if;
  end wording;
--  **************************************************************
--  Local Function Specification: INTEGER_TRANSLATION
--  **************************************************************
  function integer_translation (working_x in number)
           return varchar2 is
     x_char varchar2(128);
     denoms_to_do number;
     start_byte   number;
     pointer      binary_integer;
     interim_spelling varchar2(2000);
  begin
     if working_x is null then
        return 'Null';
     elsif working_x = 0 then
        return 'Zero';
     end if;
     x_char := abs(working_x);
     pointer := 3-mod(length(x_char),3);
     x_char := lpad(x_char,length(x_char)+pad_factor(pointer),'0');
     denoms_to_do := length(x_char)/3;
     result := null;
     for i in 1..denoms_to_do loop
         start_byte := ((i-1)*3)+1;
         interim_spelling := wording(substr(x_char,start_byte,3));
         pointer := (denoms_to_do+1)-i;
         if upper(interim_spelling) <> 'ZERO' then
            result := rtrim(ltrim(result||' '||interim_spelling||
               ' '||denom(pointer)));
         end if;
         hold(i) := result;
     end loop;
     return result;
  end integer_translation;
--  **************************************************************
--  Global Function SPELL Procedural Section 
--  **************************************************************
begin
  working_integer_spell := null;
  working_decimal_spell := null;
  working_fraction_spell := null;
  working_integer := trunc(x);
  if abs(x) > abs(working_integer) then
     working_decimal :=
       substr(rtrim(to_char(abs(x)-abs(working_integer),
       '.00000000000000000000000000000000000000000'),
       '0'),3);
  else     
     working_decimal := null;
     working_dec_mag := null;
  end if; 
  working_integer_spell := integer_translation(working_integer);
  if working_decimal is not null then
     working_dec_mag := 10 ** length(working_decimal);
     working_decimal_spell := 
        ' and '||integer_translation(working_decimal);
     working_fraction_spell :=
        integer_translation(working_dec_mag)||'th';
     if working_decimal > 1 then
        working_fraction_spell := working_fraction_spell||'s';
     end if;
     if upper(substr(working_fraction_spell,1,3))='ONE' then
        working_fraction_spell := substr(working_fraction_spell,5);
     end if;
     working_fraction_spell := ' / '||working_fraction_spell;
  end if;
  if working_integer = 0 and working_decimal_spell is not null then
     result := substr(working_decimal_spell,5)||
        working_fraction_spell;
  else
     result := working_integer_spell||
        working_decimal_spell||working_fraction_spell;
  end if;
  if x < 0 then
     result := 'Negative '||result;
  end if;
  result := replace(result,'  ',' ');
  return result;
end spell;
--  **************************************************************
--  End of Global Function: SPELL
--  **************************************************************
--  **************************************************************
--  Global Function Specification: CHECK_PROTECT
--  **************************************************************
function check_protect (x in number) return varchar2 is
   hold_dollar number;
   hold_cents  number;
   function check_for_single (y in number, currency in varchar2)
      return varchar2 is
   begin
      if y = 1 then
         return 'One '||currency;
      else
         return spell(y) ||' '||currency||'s';
      end if;
   end;
begin
   if x is null then
      return 'Non Negotiable';
   end if;
   hold_dollar := trunc(x);
   hold_cents  := (abs(x) - trunc(abs(x)))*100;
   return check_for_single(hold_dollar,'Dollar')||' and '||
          check_for_single(hold_cents,'Cent');
end check_protect;
--  **************************************************************
--  "First-time-only" Package Initialization activities
--  **************************************************************
begin
   pad_factor(1) := 1;
   pad_factor(2) := 2;
   pad_factor(3) := 0;
   denom(1) := null;
   denom(2) := 'Thousand';
   denom(3) := 'Million';
   denom(4) := 'Billion';
   denom(5) := 'Trillion';
   denom(6) := 'Quadrillion';
   denom(7) := 'Quintillion';
   denom(8) := 'Sextillion';
   denom(9) := 'Septillion';
   denom(10) := 'Octillion';
   denom(11) := 'Nonillion';
   denom(12) := 'Decillion';
   denom(13) := 'Undecillion';
   denom(14) := 'Duodecillion';
   denom(15) := 'Tredecillion';
   denom(16) := 'Quattuordecillion';
   denom(17) := 'Quindecillion';
   denom(18) := 'Sexdecillion';
   denom(19) := 'Septendecillion';
   denom(20) := 'Octodecillion';
   denom(21) := 'Novemdecillion';
   denom(22) := 'Vigintillion';
   denom(23) := 'Unvigintillion';
   denom(24) := 'Duovigintillion';
   denom(25) := 'Trevigintillion';
   denom(26) := 'Quattuorvigintillion';
   denom(27) := 'Quinvigintillion';
   denom(28) := 'Sexvigintillion';
   denom(29) := 'Septenvigintillion';
   denom(30) := 'Octovigintillion';
   denom(31) := 'Novemvigintillion';
   denom(32) := 'Tregintillion';
   denom(33) := 'Untregintillion';
   denom(34) := 'Duotregintillion';
end dh_util;
--  **************************************************************
--  End of Global Function: SPELL
--  **************************************************************
/
