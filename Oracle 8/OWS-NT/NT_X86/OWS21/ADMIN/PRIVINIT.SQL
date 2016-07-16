Rem  Copyright (c) 1996 by Oracle Corp.  All Rights Reserved.
Rem
Rem   NAME
Rem     privinit.sql - Oracle Web Agent PL/SQL initialization package.
Rem   PURPOSE
Rem     Set up some values to be used by Web Agent packages.
Rem   NOTES
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     rpang      06/29/96 -  Creation
Rem

create or replace package body OWA_INIT is

       /*******************************************************************/
      /* Global DCD Authorization callback function -                    */
     /*    It is used when DCD's authorization scheme is set to GLOBAL. */
    /*     This is a default implementation. User should modify.       */
   /*******************************************************************/
   function authorize return boolean is
   begin
      owa_sec.set_protection_realm('To-be-defined realm');
      return FALSE;
   end;

begin /* OWA_INIT package initialization */

   /*******************************************************************/
   /* Set the PL/SQL Agent's authorization scheme --                  */
   /*   This should be modified to reflect the authorization need of  */
   /*   your Database Connection Descriptor (DCD)                     */
   /*******************************************************************/
   owa_sec.set_authorization(OWA_SEC.NO_CHECK);

end;
/
show errors
