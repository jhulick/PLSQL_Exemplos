Rem  Copyright (c) 1995, 1996 by Oracle Corp.  All Rights Reserved.
Rem
Rem   NAME
Rem     owains.sql - Oracle Web Agent INStall
Rem   PURPOSE
Rem     Install the PL/SQL needed to run the Oracle Web Agent.
Rem   NOTES
Rem
Rem   HISTORY
Rem     rpang      06/29/96 -  Added OWA_SEC package and OWA_INIT package body
Rem     mpal       06/28/96 -  Add owa_opt_lock package (*oolk.sql)
Rem     mbookman   08/01/95 -  Creation
Rem
@@pubinit.sql
@@pubht.sql
@@pubutil.sql
@@pubsec.sql
@@pubowa.sql
@@pubtext.sql
@@pubpat.sql
@@pubimg.sql
@@pubcook.sql
@@puboolk.sql

@@privinit.sql
@@privht.sql
@@privowa.sql
@@privutil.sql
@@privtext.sql
@@privpat.sql
@@privimg.sql
@@privcook.sql
@@privoolk.sql
@@privsec.sql


