rem
rem
Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved.
Rem    NAME
Rem      privsec.sql
Rem    DESCRIPTION
Rem      This file contains one package:
Rem         owa_sec - Utitility procedures/functions to provide security
Rem                     to procedures accessed via the PL/SQL Agent.
Rem
Rem    NOTES
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     rpang      06/29/96 -  Creation
Rem

create or replace package body OWA_SEC is

     /*******************************************************************/
    /* Procedure to specify the PL/SQL Agent's authorization scheme    */
   /*******************************************************************/
   procedure set_authorization(scheme in integer) is
   begin
      owa.auth_scheme := scheme;
   end;

     /*******************************************************************/
    /* Functions to obtain the Web client's authentication information */
   /*******************************************************************/
   function get_user_id return varchar2 is
   begin
      return owa.user_id;
   end;

   function get_password return varchar2 is
   begin
      return owa.password;
   end;

   function get_client_ip return owa_util.ip_address is
   begin
      return owa.ip_address;
   end;

   function get_client_hostname return varchar2 is
   begin
      return owa.hostname;
   end;

     /*******************************************************************/
    /* Procedure to specify the dynamic page's protection realm        */
   /*******************************************************************/
   procedure set_protection_realm(realm in varchar2) is
   begin
      owa.protection_realm := realm;
   end;

end;
/
show errors
