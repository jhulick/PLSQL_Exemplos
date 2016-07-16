Rem  Copyright (c) 1995, 1996 by Oracle Corp.  All Rights Reserved.
Rem
Rem   NAME
Rem     pubinit.sql - Oracle Web Agent PL/SQL initialization package.
Rem   PURPOSE
Rem     Set up some values to be used by Web Agent packages.
Rem   NOTES
Rem
Rem   HISTORY
Rem     rpang      07/09/96 -  Added authorize function for OWA authorization
Rem     mbookman   02/06/96 -  Creation
Rem

create or replace package OWA_INIT is

   -- If your timezone is not in the list of standard timezones,
   -- then use dbms_server_gmtdiff to give the number of hours
   -- that your database server is ahead (or negative if behind)
   -- Greenwich Mean Time
   dbms_server_timezone constant varchar2(3) := 'PST';
   dbms_server_gmtdiff  constant number      := NULL;

      /*******************************************************************/
     /* Global DCD Authorization callback function -                    */
    /*    it is used when DCD's authorization scheme is set to GLOBAL  */
   /*******************************************************************/
   function authorize return boolean;

end;
/
show errors
