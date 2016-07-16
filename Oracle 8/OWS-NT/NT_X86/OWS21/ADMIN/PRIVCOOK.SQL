Rem  Copyright (c) 1996 by Oracle Corp.  All Rights Reserved.
Rem
Rem   NAME
Rem     pubcook.sql - Wrappers for passing HTTP_COOKIES using
Rem	              the Oracle Web Agent.
Rem   PURPOSE
Rem     
Rem   NOTES
Rem
Rem   HISTORY
Rem     mbookman   02/06/96 -  Creation
Rem

create or replace package body OWA_COOKIE is

   cookie_names vc_arr;
   cookie_vals  vc_arr;
   num_vals     integer;

   cookies_parsed boolean;

   function IFNOTNULL(val1 in varchar2,
                      val2 in varchar2) return varchar2 is
   begin
      if (val1 is not null)
      then
         return val2;
      else
         return NULL;
      end if;
   end;

   procedure http_cookie2array(names    out vc_arr,
                               vals     out vc_arr,
                               num_vals out integer) is
      http_cookie varchar2(32767);

      start_loc  integer;
      end_loc    integer;
      equal_sign integer;

      val_counter integer;
   begin
      http_cookie := owa_util.get_cgi_env('HTTP_COOKIE');

      val_counter := 0;

      /* If the last character is a ';', trim it out */
      if (substr(http_cookie, -1) = ';')
      then
         http_cookie := substr(http_cookie, 1, length(http_cookie)-1);
      end if;

      if (http_cookie is not NULL)
      then
         start_loc := 1;
         end_loc := instr(http_cookie, ';', start_loc);
         while (end_loc != 0)
         loop
            val_counter := val_counter+1;
            equal_sign := instr(http_cookie, '=', start_loc);
            names(val_counter) := ltrim(substr(http_cookie, start_loc,
                                               equal_sign-start_loc));
            vals(val_counter) := substr(http_cookie, equal_sign+1,
                                      end_loc - equal_sign - 1);
   
            start_loc := end_loc + 1;
            end_loc := instr(http_cookie, ';', start_loc);
         end loop;
   
         val_counter := val_counter + 1;
         equal_sign := instr(http_cookie, '=', start_loc);
         names(val_counter) := ltrim(substr(http_cookie, start_loc,
                                            equal_sign-start_loc));
         vals(val_counter) := substr(http_cookie, equal_sign+1);
      end if;

      num_vals := val_counter;
   end;

   procedure send(name    in varchar2,
                  value   in varchar2,
                  expires in date     DEFAULT NULL,
                  path    in varchar2 DEFAULT NULL,
                  domain  in varchar2 DEFAULT NULL,
                  secure  in varchar2 DEFAULT NULL) is
      expires_gmt date;
   begin
      if (OWA_INIT.DBMS_SERVER_GMTDIFF is not NULL)
      then
         expires_gmt := expires-(OWA_INIT.DBMS_SERVER_GMTDIFF/24);
      else
         expires_gmt := new_time(expires,OWA_INIT.DBMS_SERVER_TIMEZONE,'GMT');
      end if;

      htp.print('Set-Cookie: '||name||'='||value||';'||
                 IFNOTNULL(expires_gmt, ' expires='||
                    rtrim(to_char(expires_gmt,'Day'))||
                    to_char(expires_gmt,', DD-Mon-YY HH24:MM:SS')||' GMT;')||
                 IFNOTNULL(path,    ' path='||path||';')||
                 IFNOTNULL(domain,  ' domain='||domain||';')||
                 IFNOTNULL(secure,  ' secure'));
   end;

   function make_cookie(name in varchar2 DEFAULT NULL) return cookie is
      choc_chip cookie;
   begin
      choc_chip.num_vals := 0;
      choc_chip.name := name;
      
      return choc_chip;
   end;

   function get(name in varchar2) return cookie is
      choc_chip cookie;
   begin
      if (NOT cookies_parsed)
      then
         http_cookie2array(cookie_names, cookie_vals, num_vals);
         cookies_parsed := TRUE;
      end if;

      choc_chip := make_cookie(name);

      /* This is not the most efficient thing to do. */
      /* should probably have cookie2array sort */
      /* then we could do binary search here.   */
      for i in 1..num_vals
      loop
         if (cookie_names(i) = name)
         then
            choc_chip.num_vals := choc_chip.num_vals + 1;
            choc_chip.vals(choc_chip.num_vals) := cookie_vals(i);
         end if;
      end loop;

      return choc_chip;
   end;

   procedure remove(name in varchar2,
                    val  in varchar2,
                    path in varchar2 DEFAULT NULL) is
   begin
      send(name, val, to_date('01-JAN-1990','DD-MON-YYYY'));
   end;

   procedure get_all(names    out vc_arr,
                     vals     out vc_arr,
                     num_vals out integer) is
   begin
      if (NOT cookies_parsed)
      then
         http_cookie2array(names, vals, num_vals);
         cookies_parsed := TRUE;
      end if;
   end;
begin
   cookies_parsed := FALSE;
end;
/
show errors
