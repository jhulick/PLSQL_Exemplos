rem
rem
Rem  Copyright (c) 1995, 1996 by Oracle Corporation. All rights reserved.
Rem    NAME
Rem      pubowa.sql - package of procedures called directly from OWA
Rem    DESCRIPTION
Rem      This file contains one package:
Rem         owa     - These procedures are interface procedures for
Rem                     the Oracle Web Agent.  These procedures should
Rem                     not be called by an end-user.
Rem
Rem    NOTES
Rem      The Oracle Web Agent is needed to use these facilities.
Rem      The package htp is needed to use these facilities.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     rpang      07/03/96 -  Added package variables for authorization
Rem     mbookman   03/04/96 -  Asserted the purity of the OWA initialization
Rem     mbookman   03/04/96 -  Added package variable num_cgi_vars (314403)
Rem     mbookman   07/09/95 -  Creation

REM Creating OWA package...
create or replace package OWA is
--   PRAGMA RESTRICT_REFERENCES(owa, WNDS, RNDS, WNPS, RNPS);

   type vc_arr is table of varchar2(2000) index by binary_integer;

   cgi_var_name vc_arr;
   cgi_var_val  vc_arr;
   num_cgi_vars number;

   auth_scheme       integer := OWA_SEC.NO_CHECK;
   protection_realm  varchar2(255);
   user_id           varchar2(255);
   password          varchar2(255);
   ip_address        owa_util.ip_address;
   hostname          varchar2(255);

     /********************************************/
    /* Initialize the CGI environment variables */
   /********************************************/
   procedure init_cgi_env (num_params in number,
                           param_name in vc_arr,
                           param_val  in vc_arr);

     /*****************************************/
    /* Get the output from the user's PL/SQL */
   /*****************************************/
   procedure get_page (thepage     out htp.htbuf_arr,
                       irows    in out integer );

end;
/
show errors
