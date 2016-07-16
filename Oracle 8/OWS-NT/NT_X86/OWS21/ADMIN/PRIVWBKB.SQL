Rem  Copyright (c) 1995, 1996 by Oracle Corp.  All Rights Reserved.
Rem
Rem   NAME
Rem     privwbkb.sql - create package body for Web Browser Knowledge Base
Rem   PURPOSE
Rem     Provide a repository of information about Web Browsers
Rem   NOTES
Rem     This package depends on the existence of the tables
Rem        NDW_BROWSERS and NDW_BROWSER_ATTRIBUTES.
Rem     This package depends on the PL/SQL package OWA_UTIL.
Rem   HISTORY
Rem     mbookman   12/19/95 -  Creation
Rem

create or replace package body OWA_BROWSERS is

   function get_user_agent return varchar2 is
   begin
      return owa_util.get_cgi_env('HTTP_USER_AGENT');
   end;

   function add_browser return integer is
   begin
      return add_browser(get_user_agent);
   end;

   function add_browser(user_agent in varchar2) return integer is
      browser_id integer;
   begin
      select ndw_browser_seq.nextval into browser_id
         from dual;

      insert into ndw__browsers (br_id, http_user_agent)
         values (browser_id, user_agent);

      return browser_id;
   end;

   procedure delete_browser is
   begin
      delete_browser(get_user_agent);
   end;

   procedure delete_browser(user_agent in varchar2) is
   begin
      delete_browser(get_browser_id(user_agent));
   end;

   -- DELETE_BROWSER will be silent if the specified browser_id does
   -- not exist.
   procedure delete_browser(browser_id in integer) is
   begin
      delete from ndw__browser_attributes
         where br_id = browser_id;

      delete from ndw__browsers
         where br_id = browser_id;
   end;

   function get_browser_id return integer is
   begin
      return get_browser_id(get_user_agent);
   end;

   function get_browser_id(user_agent in varchar2) return integer is
      browser_id integer;
   begin
      select br_id into browser_id
         from ndw__browsers
      where http_user_agent = user_agent;

      return browser_id;
   exception
      when NO_DATA_FOUND
      then
         return NULL;

      when others
      then
         raise;
   end;

   function get_attribute(attribute  in varchar2) return varchar2 is
   begin
      return get_attribute(attribute, get_user_agent);
   end;

   function get_attribute(attribute  in varchar2,
                          user_agent in varchar2) return varchar2 is
      browser_id integer;
   begin
      browser_id := get_browser_id(user_agent);

      if (browser_id is NULL)
      then
         return NULL;
      else
         return get_attribute(attribute, browser_id);
      end if;
   end;

   function get_attribute(attribute  in varchar2,
                          browser_id in integer) return varchar2 is
      return_val varchar2(2000);
   begin
      select val into return_val
         from ndw__browser_attributes
      where br_id  = browser_id
        and attrib = attribute;

      return return_val;
   exception
      when NO_DATA_FOUND
      then
         return NULL;

      when others
      then
         raise;
   end;

   procedure set_attribute(attribute in varchar2,
                           value     in varchar2) is
   begin
      set_attribute(attribute, value, get_user_agent);
   end;

   procedure set_attribute(attribute  in varchar2,
                           value      in varchar2,
                           user_agent in varchar2) is
      browser_id integer;
   begin
      browser_id := get_browser_id(user_agent);

      if (browser_id is NULL)
      then
         browser_id := add_browser(user_agent);
      end if;

      set_attribute(attribute, value, browser_id);
   end;

   procedure set_attribute(attribute  in varchar2,
                           value      in varchar2,
                           browser_id in integer) is
      rid rowid;
   begin
      select rowid into rid
         from ndw__browser_attributes
      where br_id  = browser_id
        and attrib = attribute;

      update ndw__browser_attributes
         set val = value
      where rowid = rid;

   exception
      when NO_DATA_FOUND
      then
         insert into ndw__browser_attributes (br_id, attrib, val)
            values (browser_id, attribute, value);

      when OTHERS
      then
         raise;
   end;

   procedure delete_attribute(attribute  in varchar2) is
   begin
      delete_attribute(attribute, get_user_agent);
   end;

   procedure delete_attribute(attribute  in varchar2,
                              user_agent in varchar2) is
   begin
      delete_attribute(attribute, get_browser_id(user_agent));
   end;

   procedure delete_attribute(attribute  in varchar2,
                              browser_id in integer) is
   begin
      delete from ndw__browser_attributes
         where br_id  = browser_id
           and attrib = attribute;
   end;
end;
/
show errors
