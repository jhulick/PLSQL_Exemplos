grant connect to sqldebug
;

grant select any table to sqldebug with admin option
;

grant grant any privilege to sqldebug
;

grant create public synonym to sqldebug
;

grant drop public synonym to sqldebug
;

grant unlimited tablespace to sqldebug
;

grant drop any procedure to sqldebug
;

grant create any procedure to sqldebug
;

grant drop any procedure to sqldebug
;

grant alter any procedure to sqldebug
;

grant execute any procedure to sqldebug
;
commit
;

grant create any trigger to sqldebug
;

grant alter any trigger to sqldebug
;

grant drop any trigger to sqldebug
;

drop role ptsql_debug_role
;

create role ptsql_debug_role
;

grant create any procedure to ptsql_debug_role
;

grant drop any procedure to ptsql_debug_role
;

grant alter any procedure to ptsql_debug_role
;

grant execute any procedure to ptsql_debug_role
;

grant create any trigger to ptsql_debug_role
;

grant alter any trigger to ptsql_debug_role
;

grant drop any trigger to ptsql_debug_role
;


