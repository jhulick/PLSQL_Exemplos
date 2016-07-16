Rem  Copyright (c) 1995, 1996 by Oracle Corp.  All Rights Reserved.
Rem
Rem   NAME
Rem     pubwbkb.sql - create package for Web Browser Knowledge Base
Rem   PURPOSE
Rem     Provide a repository of information about Web Browsers
Rem   NOTES
Rem     This package depends on the existence of the tables
Rem        NDW__BROWSERS and NDW__BROWSER_ATTRIBUTES, as well as the
Rem        sequence NDW_BROWSER_SEQ
Rem	These objects are created by the objwbkb.sql script.
Rem   HISTORY
Rem     mbookman   12/19/95 -  Creation
Rem

create or replace package OWA_BROWSERS is

   -- Pre-defined constants which can be used as browser attributes.
   -- Any attribute can be added using OWA_BROWSERS, but one should
   -- define constants to be consistent in the attributes that they
   -- add/request.  A simple mistake might be to use:
   --
   --    owa_browsers.set_attribute('HTML FORMS','Y');
   --  
   -- in one PL/SQL procedure while using:
   --
   --    owa_browsers.get_attribute('HTML Forms');
   --  
   -- in another procedure. 
   HTML_TABLES constant varchar2(11) := 'HTML TABLES';
   HTML_FORMS  constant varchar2(10) := 'HTML FORMS';

   -- Short-cut call for owa_util.get_cgi_env('HTTP_USER_AGENT');
   function get_user_agent return varchar2;

   -- Add a new "HTTP_USER_AGENT" to the list of web browsers.
   -- If user_agent is not specified explicitly, then it will be
   -- derived from the environment.
   -- Function returns the "browser_id" of the newly added browser.
   -- This value can be used in subsequent calls to get/set attributes
   -- for improved performance.
   function add_browser return integer;
   function add_browser(user_agent in varchar2) return integer;
 
   -- Delete an "HTTP_USER_AGENT" from the list of web browsers.
   -- If user_agent is not specified explicitly, then it will be
   -- derived from the environment.
   procedure delete_browser;
   procedure delete_browser(user_agent in varchar2);
   procedure delete_browser(browser_id in integer);

   -- GET_BROWSER_ID returns the "browser_id" of the requested browser.
   -- This value can be used in subsequent calls to get/set attributes
   -- for improved performance.
   -- If user_agent is not specified explicitly, then it will be
   -- derived from the environment.
   function get_browser_id return integer;
   function get_browser_id(user_agent in varchar2) return integer;

   -- GET_ATTRIBUTE returns the value of the attribute associated with the
   -- specified browser.
   -- If user_agent is not specified explicitly, then it will be
   -- derived from the environment.
   function get_attribute(attribute  in varchar2) return varchar2;

   function get_attribute(attribute  in varchar2,
                          user_agent in varchar2) return varchar2;

   function get_attribute(attribute  in varchar2,
                          browser_id in integer) return varchar2;

   -- SET_ATTRIBUTE sets the value of the attribute associated with the
   -- specified browser.
   -- If user_agent is not specified explicitly, then it will be
   -- derived from the environment.
   procedure set_attribute(attribute in varchar2,
                           value     in varchar2);

   procedure set_attribute(attribute  in varchar2,
                           value      in varchar2,
                           user_agent in varchar2);

   procedure set_attribute(attribute  in varchar2,
                           value      in varchar2,
                           browser_id in integer);

   -- DELETE_ATTRIBUTE deletes the entry associated with the
   -- specified attribute and browser.
   -- If user_agent is not specified explicitly, then it will be
   -- derived from the environment.
   procedure delete_attribute(attribute  in varchar2);

   procedure delete_attribute(attribute  in varchar2,
                              user_agent in varchar2);

   procedure delete_attribute(attribute  in varchar2,
                              browser_id in integer);

end;
/
show errors
