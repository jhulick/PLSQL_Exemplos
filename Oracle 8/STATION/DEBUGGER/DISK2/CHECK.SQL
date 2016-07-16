 /* check_ptsql.sql
 *  checks that the debugger main objects are there.
 *  called as a "check" routine from pl_install.exe
 *    returns 1 if ok, 0 if not.
 */

select count(*) from all_objects
  where object_name = 'PTSQL_DEBUG'
  and   object_type = 'PACKAGE BODY'
  and   status      = 'VALID'
  and   owner       = 'sqldebug'
;
