Rem 
Rem $Header: plitblm.sql 21-mar-96.20:31:02 csexton Exp $
Rem
Rem plitblm.sql
Rem 
Rem  Copyright (c) Oracle Corporation 1995, 1996. All Rights Reserved.
Rem
Rem    NAME
Rem      plitblm.sql - package PLITBLM
Rem
Rem    DESCRIPTION
Rem      PL/sql Index-TaBLe Methods
Rem      Package for index-table operations. This package must
Rem      be loaded by catproc.sql script.
Rem      
Rem    NOTES
Rem      This file needs to be kept in sync with its .pls version
Rem      (icd/plitblm.pls) currently. We hope to soon eliminate 
Rem      this dependency once we automate the generation of .pls
Rem      version.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    csexton     03/21/96 - additions for table of any feature
Rem    kmuthukk    03/21/95 - change method names
Rem    kmuthukk    03/07/95 - PLITBLM package .sql file
Rem    kmuthukk    03/06/95 - Created
Rem
 
drop public synonym plitblm;

drop package sys.plitblm;

create or replace package sys.plitblm is

 subtype key_type is binary_integer;
 
 function count return key_type;
  pragma interface(c, count);
 
 function first return key_type;
  pragma interface(c, first);

 function last  return key_type;
  pragma interface(c, last);

 function exists (i key_type) return boolean;
  pragma interface(c, exists);

 function prior (i key_type) return key_type;
  pragma interface(c, prior);
  
 function next  (i key_type) return key_type;
  pragma interface(c, next);

 procedure delete;
  pragma interface(c, delete);

 procedure delete (i key_type);
  pragma interface(c, delete);
  
 procedure delete (i key_type, j key_type);
  pragma interface(c, delete);
  
 -- This type name and the package name are recorded in pls/scmfst.c, and a
 -- symbolic form specified in pls/scmfst.h; Changes to either name must be
 -- reflected in the .c file, at least.
 type table_of_any is table of char index by binary_integer;

end plitblm;
/

create public synonym plitblm for sys.plitblm;

grant execute on sys.plitblm to public;
