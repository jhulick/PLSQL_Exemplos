Rem  Copyright (c) 1995, 1996 by Oracle Corp.  All Rights Reserved.
Rem
Rem   NAME
Rem     owadins.sql - Oracle Web Agent De-INStall
Rem   PURPOSE
Rem     Drop PL/SQL packages installed with the Oracle Web Agent.
Rem
Rem   NOTES
Rem
Rem     This script should be run by the owner of the OWA packages.
Rem   HISTORY
Rem     rpang      07/09/96 -  Add drop of sec
Rem 	mpal	   06/28/96 -  Add drop of owa_opt_lock package
Rem     mbookman   03/04/96 -  Add drop of init, text, pattern, cookie
Rem     mbookman   08/01/95 -  Creation
Rem

drop package owa_cookie;
drop package owa_image;
drop package owa_pattern;
drop package owa_text;
drop package owa_util;
drop package owa;
drop package htp;
drop package htf;
drop package owa_init;
drop package owa_sec;
drop package owa_opt_lock;

