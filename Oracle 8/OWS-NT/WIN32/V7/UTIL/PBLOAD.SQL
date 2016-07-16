Rem
Rem   Copyright (c) Oracle Corporation 1996. All Rights Reserved.
Rem
Rem
Rem    NAME
Rem      pbload.sql - Load ProBe (PL/SQL debugger) server-side packages.
Rem
Rem    DESCRIPTION
Rem      Loads the Probe packages. This is also done by catproc.sql, but
Rem      this script is provided in case there are customers that are
Rem      upgrading without rerunning catproc. 
Rem      It may also be used if the Probe packages get invalidated
Rem      (although it is actually preferable to do 'alter <package> compile')
Rem
Rem    NOTES
Rem      * Must be installed as SYS.
Rem

--  Load the specs
@@dbmspb.sql

-- Load the shrink-wrapped bodies
@@prvtpb.plb
