rem 
rem $Header: catrep.sql,v 1.7 1996/01/10 12:35:43 sjain Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      catrep.sql
Rem    DESCRIPTION
Rem	 Run all sql scripts for replication option
Rem    RETURNS
Rem 
Rem    NOTES
Rem      Must be run when connected to SYS or INTERNAL
Rem    MODIFIED   (MM/DD/YY)
Rem     sjain      01/09/96 -  Remove catrepad include
Rem     boki       07/10/95 -  add offline instantiaton
Rem     dsternbe   03/24/95 -  merge changes from branch 1.2.720.4
Rem     dsternbe   03/02/95 -  add catrepad.sql
Rem     boki       02/10/95 -  add table comparison feature packages
Rem     adowning   12/23/94 -  merge changes from branch 1.2.720.1
Rem     adowning   12/21/94 -  merge changes from branch 1.1.710.4
Rem     adowning   11/22/94 -  add comment
Rem     dsdaniel   11/01/94 -  utlraw changes merged froward
Rem     dsdaniel   10/13/94 -  merge changes from branch 1.1.710.2&3
Rem     dsdaniel   09/30/94 -  utl_raw changes - backed out must redo when 
Rem                            utl_raw changes are merged forward.
Rem     dsdaniel   09/30/94 -  utl_raw changes
Rem     jstamos    07/25/94 -  reorder entries because of package dependencies
Rem     adowning   03/29/94 -  merge changes from branch 1.1.710.1
Rem     adowning   02/04/94 -  Branch_for_patch
Rem     adowning   02/04/94 -  Creation

Rem Views and tables for the replication catalog
@@catrepc

Rem pl/sql packages used for rdbms replication functionality
@@utlraw
Rem changes utlrab to prvtrawb.plb  when utl_raw changes merged forward 
@@prvtrawb.plb
@@dbmsdefr
@@prvtdefr.plb
@@dbmsgen
@@prvtgen.plb
@@dbmsobjg
@@prvtobjg.plb
@@dbmsrepc
@@prvtrepc.plb
@@dbmsrctf
@@prvtrctf.plb
@@dbmsofln
@@prvtofln.plb
