Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
Rem    NAME
Rem      demoins.sql
Rem    DESCRIPTION
Rem      
Rem    RETURNS
Rem 
Rem    NOTES
Rem      
Rem    MODIFIED   (MM/DD/YY)
Rem     mfreedma      09/11/96 -  Added Banner 

rem Utility functions
@@util
rem Create tables for HR demo
rem @@hrbuild
rem Create user interface packages for HR demo
rem @@hrui
rem Create tables and data encapsulation packages for TRAVEL demo
@@trbuild
rem Create testdata for TRAVEL demo
@@trdata
rem Create NLS messages for TRAVEL demo
@@trmsg
rem Create user interface packages for TRAVEL demo
@@trui
