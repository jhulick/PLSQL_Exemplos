rem
rem
Rem  Copyright (c) 1995, 1996 by Oracle Corporation. All rights reserved.
Rem    NAME
Rem      owa.sql - package of procedures called directly from OWA
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
Rem     rpang      07/03/96 -  Added initialzation section to touch OWA_INIT
Rem     mbookman   07/09/95 -  Creation

REM Creating OWA package body...
create or replace package body OWA is

   dummy number;

     /********************************************/
    /* Initialize the CGI environment variables */
   /********************************************/
   procedure init_cgi_env (num_params in number,
                           param_name in vc_arr,
                           param_val  in vc_arr) is
   begin
      for i in 1..num_params
      loop
         cgi_var_name(i) := param_name(i);
         cgi_var_val(i)  := param_val(i);
      end loop;

      num_cgi_vars := num_params;
   end;
            
     /*****************************************/
    /* Get the output from the user's PL/SQL */
   /*****************************************/
   procedure get_page (thepage     out htp.htbuf_arr,
                       irows    in out integer ) is
   begin
      irows := least(irows,htp.rows_in - htp.rows_out);

      for i in 1..irows
      loop
         thepage(i) := htp.htbuf(htp.rows_out+i);
      end loop;

      htp.rows_out := htp.rows_out + irows;
   end;

begin
   /* touch owa_init so that the package initialization is executed */
   dummy := owa_init.dbms_server_gmtdiff;
end;
/
show errors
