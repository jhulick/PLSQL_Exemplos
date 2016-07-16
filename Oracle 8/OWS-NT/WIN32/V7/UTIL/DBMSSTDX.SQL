rem 
rem $Header: dbmsstdx.sql,v 1.5 1994/10/16 20:12:46 hjakobss Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      stdext.sql - Kernel extensions to package standard
Rem    DESCRIPTION
Rem      Routines in this package do not need to be qualified by the
Rem      owner or package name, similar to the behaviour of package
Rem      'standard'.  This package mostly contains utility routines for
Rem      triggers.
Rem    RETURNS
Rem 
Rem    NOTES
Rem      
Rem    MODIFIED   (MM/DD/YY)
Rem     hjakobss   10/16/94 -  bug 151485 - remove sql_ddl
Rem     jwijaya    04/05/93 -  merge changes from branch 1.3.312.1 
Rem     jwijaya    03/26/93 -  bug 157348 
Rem     rkooi      11/28/92 -  add 'keep' option to raise_application_error 
Rem     rkooi      10/25/92 -  deal with null arg to rae 
Rem     glumpkin   10/21/92 -  Renamed from STDEXT.SQL 
Rem     mmoore     09/24/92 - #(130568) add callback for commit comment 
Rem     rkooi      09/02/92 -  change pls_integer to binary_integer 
Rem     mmoore     08/12/92 -  override the savepoint command in standard
Rem     rkooi      06/10/92 -  add 'do not change' comment 
Rem     mmoore     04/14/92 -  move begin_oltp to package transaction 
Rem     rkooi      04/06/92 -  merge changes from branch 1.7.300.1 
Rem     rkooi      04/02/92 -  split dbms_standard into separate pkgs 
Rem     maporter   03/25/92 -  renumber 8200 to 8175
Rem     rbamford   03/07/92 -  add BEGIN_OLTP_TRANSACTION 
Rem     mroberts   02/21/92 -  delete extra rollback_sv procedure 
Rem     rkooi      02/17/92 -  add set_role and related procedures 
Rem     mroberts   02/14/92 -  add execute_ddl internal 
Rem     mmoore     02/06/92 -  change name of package 
Rem     mmoore     01/14/92 -  add rollback_nr 
Rem     mmoore     01/09/92 -  speed up 
Rem      rkooi      11/24/91 -  rename to stdext.sql from stdext.pls
Rem      rkooi      08/26/91 -  get rid of stack_application_error 
Rem      rkooi      05/08/91 -  change name to standard_extension 
Rem      rkooi      05/02/91 -  forgot skip_row procedure 
Rem      mmoore     05/02/91 -  move trigger icds to psd, use varchar2 in
Rem                             rae/sae
Rem      rkooi      04/23/91 -  add 'skip_row' procedure, commit etc.
Rem                             procedures. 
Rem      Moore      04/02/91 -  fix typo
Rem      Moore      03/28/91 -  add boolean trigger functions 
Rem      Kooi       03/17/91 -  Creation
Rem      Kooi       03/12/91 -  change name to standard_utilities
Rem      Kooi       02/26/91 -  get rid of raise now that psdkse does it
Rem      Kooi       02/26/91 -  Creation
------------------------------------------------------------------------------

REM *****************************************************************
REM THIS PACKAGE MUST NOT BE MODIFIED BY THE CUSTOMER.  DOING SO
REM COULD CAUSE INTERNAL ERRORS AND SECURITY VIOLATIONS IN THE RDBMS.
REM *****************************************************************

drop package dbms_standard
/
create package dbms_standard is

  -- Trigger Operations
  procedure raise_application_error(num binary_integer, msg varchar2,
      keeperrorstack boolean default FALSE);
    pragma interface (C, raise_application_error);         -- 1 (see psdicd.c)
  function inserting return boolean;
    pragma interface (C, inserting);                       -- 2 
  function deleting  return boolean;
    pragma interface (C, deleting);                        -- 3 
  function updating  return boolean;
    pragma interface (C, updating);                        -- 4 
  function updating (colnam varchar2) return boolean;
    pragma interface (C, updating);                        -- 5 

  -- Transaction Commands
  procedure commit;
    pragma interface (C, commit);                          -- 6 
  procedure commit_cm(vc varchar2);
    pragma interface (C, commit_cm);                       -- 7
  procedure rollback_nr;
    pragma interface (C, rollback_nr);                     -- 8 
  procedure rollback_sv(save_point varchar2);
    pragma interface (C, rollback_sv);                     -- 9 
  procedure savepoint(save_point varchar2);
    pragma interface (C, savepoint);                       -- 10
  procedure set_transaction_use(vc varchar2);   
    pragma interface (C, set_transaction_use);             -- 11

end;
/

drop public synonym dbms_standard
/
create public synonym dbms_standard for sys.dbms_standard
/
grant execute on dbms_standard to public
/
