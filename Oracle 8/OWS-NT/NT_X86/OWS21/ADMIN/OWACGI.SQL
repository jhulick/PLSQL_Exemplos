Rem
Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved.
Rem    NAME
Rem      owacgi.sql - package for browsing an Oracle database.
Rem    DESCRIPTION
Rem
Rem    NOTES
Rem
Rem    MODIFIED   (MM/DD/YY)


create or replace package OWA_CGI is

   procedure getword(word      out varchar2,
                     line   in out varchar2,
                     stop   in     varchar2);

   function makeword(line in out varchar2,
                     stop in     varchar2) return varchar2;
   
   function x2c(what in varchar2) return varchar2;

   procedure unescape_url(url in out varchar2);

   procedure plustospace(str in out varchar2);

   function rind(s in varchar2,
                 c in varchar2) return integer;

   function ind(s in varchar2,
                c in varchar2) return integer;

   procedure escape_shell_cmd(cmd in out varchar2);

   procedure encode_url(url in out varchar2);
end;
/
show errors

create or replace package body OWA_CGI is

   procedure getword(word    out varchar2,
                     line in out varchar2,
                     stop in     varchar2) is
      stop_loc integer;
   begin
      stop_loc := instr(line, stop);

      if (stop_loc != 0)
      then
         word := substr(line, 1, stop_loc);
         line := substr(line, stop_loc+1);
      else
         word := line;
         line := NULL;
      end if;
   end;

   function makeword(line in out varchar2,
                     stop in     varchar2) return varchar2 is
      word varchar2(32767);
   begin
      getword(word, line, stop);
      return word;
   end;

   /* x2c needs to be able to run on any Oracle database, regardless of */
   /* characterset.  The RFC specification defines the hex characters   */
   /* which would be passed in here to be 8-bit ASCII encodings, hence  */
   /* we have to do a complete mapping of characters to their unescaped */
   /* values.                                                           */
   /* First cut of this will assume ascii characters */
   function x2c(what in varchar2) return varchar2 is
      digit1 char(1);
      digit2 char(2);

      val1 integer;
      val2 integer;
   begin
      digit1 := upper(substr(what,1,1));
      digit2 := upper(substr(what,2,1));

      if (digit1 >= 'A')
      then
         val1 := ascii(digit1) - ascii('A') + 10;
      else
         val1 := to_number(digit1);
      end if;

      if (digit2 >= 'A')
      then
         val2 := ascii(digit2) - ascii('A') + 10;
      else
         val2 := to_number(digit2);
      end if;

      return chr(val1*16 + val2);
   end;

   procedure unescape_url(url in out varchar2) is
      new_url   varchar2(32767);
      pct_loc   integer;
      start_loc integer;
   begin
      start_loc := 1;
      pct_loc := instr(url, '%', start_loc);

      while (pct_loc != 0)
      loop
         new_url := new_url||substr(url, start_loc, pct_loc - start_loc)||
                             x2c(substr(url, pct_loc+1, 2));
         start_loc := pct_loc + 3;
         pct_loc := instr(url, '%', start_loc);
      end loop;

      new_url := new_url||substr(url, start_loc);

      url := new_url;
   end;

   procedure plustospace(str in out varchar2) is
   begin
      str := replace(str, '+', ' ');
   end;

   function rind(s in varchar2,
                 c in varchar2) return integer is
   begin
      return instr(s, c, -1);
   end;

   function ind(s in varchar2,
                c in varchar2) return integer is
   begin
      return instr(s, c);
   end;

   procedure escape_shell_cmd(cmd in out varchar2) is
      i   integer;
      len integer;
   begin
      len := length(cmd);

      i := 0;
      while (i <= len)
      loop
         if (instr('&;`''"|~<>^()[]{}$\',substr(cmd,i,1)) != 0)
         then
            cmd := substr(cmd,1,i-1)||'\'||substr(cmd,i);
            i   := i + 1;
            len := len + 1;
         end if; 

         i := i + 1;
      end loop;
   end;

/*
1.The form field names and values are escaped: space characters are replaced by `+', and then reserved characters are escaped as: non-alphanumeric characters are replaced by `%HH', a percent sign and two hexadecimal digits representing the ASCII code of the character. Line breaks, as in multi-line text field values, are represented as CR LF pairs, i.e. `%0D%0A'. 
*/
/* I believe that below, it should be:
new_url := new_url||'%'||rawtohex(utl_raw.cast_to_raw(
                                  convert(curr_ch,'US7ASCII'));
*/
   procedure encode_url(url in out varchar2) is
      /* The broken line below is intentional */
      NL_CHAR  constant  char(1) := '
';
      CRLF    constant char(6) := '%0D%0A';
      ALPHAS  constant char(62) := '0123456789'||
                                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'||
                                   'abcdefghijklmnopqrstuvwxyz';
      SPACE constant char(1) := ' ';
      PLUS  constant char(1) := '+';

      new_url varchar2(32767);
      curr_ch char(1);
   begin
      for i in 1..length(url)
      loop
         curr_ch := substr(url,i,1);
         if (instr(alphas, curr_ch) = 0)
         then
            if (curr_ch = SPACE)
            then
               new_url := new_url||PLUS;
            else
            if (curr_ch = NL_CHAR)
            then
               new_url := new_url||CRLF;
            else
               new_url := new_url||'%'||rawtohex(utl_raw.cast_to_raw(curr_ch));
            end if;
            end if;
         else
            new_url := new_url||curr_ch;
         end if;
      end loop;

      url := new_url;
   end;
end;
/
show errors






