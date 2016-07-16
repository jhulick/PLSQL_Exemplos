rem 
rem $Header: catalog6.sql,v 1.12 1994/04/06 22:56:17 gdoherty Exp $ 
rem 
Rem Copyright (c) 1990 by Oracle Corporation
Rem NAME
Rem   CATALOG6.SQL
Rem FUNCTION
Rem   Contains V6 views removed from V7 CATALOG.SQL.
Rem   These views are obsolete or have been replaced by better views in V7.
Rem   The accessible_* and constraint_* views were part of the SQL2 spec
Rem   at the time V6 was released, but are no longer part of the spec.
Rem NOTES
Rem   Must be run when connected as SYS after catalog.sql and audit.sql
Rem   have been run.
Rem 
Rem MODIFIED
Rem     gdoherty   04/06/94 -  merge changes from branch 1.10.710.2
Rem     wmaimone   12/17/93 -  merge changes from branch 1.10.710.1
Rem     wmaimone   10/08/93 -  #(176646) change type in tabauth$,colauth$ view
Rem     lfeng      11/25/92 -  remove insert_priv column in col_grants views 
Rem     mmoore     11/04/92 -  add tabauth$ and colauth$ 
Rem     mmoore     06/02/92 - #(96526) remove v$enabledroles 
Rem     mmoore     04/13/92 -  merge changes from branch 1.6.300.1 
Rem     mmoore     03/03/92 -  change view names
Rem     wmaimone   10/26/91 -  add audit views 
Rem     mmoore     08/01/91 -         merge changes from branch 1.4.100.1 
Rem     mmoore     08/01/91 -         move column_privileges back to catalog  
Rem     mmoore     06/28/91 -         take table_privileges out 
Rem     mmoore     06/23/91 -         add security views 
Rem     jwijaya    06/21/91 -         fix DBA_CROSS_REFS
Rem     amendels   06/10/91 - move obsolete sql2 views accessible_* and
Rem                           constraint_* from catalog.sql
Rem   Wijaya     01/04/91 - Creation
Rem

remark
remark  This view shows all tables and views owned by the
remark  user, plus all tables and views to which the user or PUBLIC
remark  has been granted access.
remark
create or replace view ACCESSIBLE_TABLES
    (OWNER, TABLE_NAME, TABLE_TYPE)
as
select u.name, o.name,
       decode(o.type, 2, 'TABLE', 4, 'VIEW')
from sys.user$ u, sys.obj$ o
where o.owner# = u.user#
  and o.linkname is null
  and o.type in (2, 4)
  and (o.owner# = uid
       or
       obj# in (select obj#
                from sys.objauth$
                where grantee# in (select kzsrorol from x$kzsro)
               )
      )
/
comment on table ACCESSIBLE_TABLES is
'Tables and Views accessible to the user'
/
comment on column ACCESSIBLE_TABLES.OWNER is
'Owner of the object'
/
comment on column ACCESSIBLE_TABLES.TABLE_NAME is
'Name of the object'
/
comment on column ACCESSIBLE_TABLES.TABLE_TYPE is
'Type of the object'
/
drop public synonym ACCESSIBLE_TABLES
/
create public synonym ACCESSIBLE_TABLES for ACCESSIBLE_TABLES
/
grant select on ACCESSIBLE_TABLES to PUBLIC with grant option
/
drop public synonym ACCESSIBLE_COLUMNS
/
create public synonym ACCESSIBLE_COLUMNS for ALL_TAB_COLUMNS
/
remark
remark  FAMILY "CONSTRAINT" VIEWS FOR ANSI
remark
create or replace view CONSTRAINT_DEFS
    (OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME,
     SEARCH_CONDITION, R_OWNER, R_CONSTRAINT_NAME)
as
select owner, constraint_name, constraint_type, table_name,
       search_condition, r_owner, r_constraint_name
from all_constraints;
/
comment on table CONSTRAINT_DEFS is
'Constraint Definitions on accessible tables'
/
comment on column CONSTRAINT_DEFS.OWNER is
'Owner of the table'
/
comment on column CONSTRAINT_DEFS.CONSTRAINT_NAME is
'Name associated with constraint definition'
/
comment on column CONSTRAINT_DEFS.CONSTRAINT_TYPE is
'Type of constraint definition'
/
comment on column CONSTRAINT_DEFS.TABLE_NAME is
'Name associated with table with constraint definition'
/
comment on column CONSTRAINT_DEFS.SEARCH_CONDITION is
'Text of search condition for table check'
/
comment on column CONSTRAINT_DEFS.R_OWNER is
'Owner of table used in referential constraint'
/
comment on column CONSTRAINT_DEFS.R_CONSTRAINT_NAME is
'Name of unique constraint definition for referenced table'
/
grant select on CONSTRAINT_DEFS to public with grant option
/
drop public synonym CONSTRAINT_DEFS
/
create public synonym CONSTRAINT_DEFS for CONSTRAINT_DEFS
/
create or replace view CONSTRAINT_COLUMNS
     (OWNER, CONSTRAINT_NAME, COLUMN_NAME, POSITION)
as
select u.name, c.name, col.name, cc.pos#
from sys.user$ u, sys.con$ c, sys.col$ col, sys.ccol$ cc, sys.cdef$ cd
where c.owner# = u.user#
  and c.con# = cd.con#
  and cd.type in (2,3,4)
  and cd.con# = cc.con#
  and cc.obj# = col.obj#
  and cc.col# = col.col#
  and (c.owner# = uid
       or
       cd.obj# in (select obj#
	           from sys.objauth$
		   where grantee# in (select kzsrorol from x$kzsro)
                  )
      )
/
comment on table CONSTRAINT_COLUMNS is
'Information about accessible columns in constraint definitions'
/
comment on column CONSTRAINT_COLUMNS.OWNER is
'Owner of the constraint definition'
/
comment on column CONSTRAINT_COLUMNS.CONSTRAINT_NAME is
'Name associated with the constraint definition'
/
comment on column CONSTRAINT_COLUMNS.COLUMN_NAME is
'Name associated with column specified in the constraint definition'
/
comment on column CONSTRAINT_COLUMNS.POSITION is
'Original position of column in definition'
/
grant select on CONSTRAINT_COLUMNS to public with grant option
/
drop public synonym CONSTRAINT_COLUMNS
/
create public synonym CONSTRAINT_COLUMNS for CONSTRAINT_COLUMNS
/
remark
remark  FAMILY "CROSS_REFS"
remark  Object cross-referencing information.
remark
create or replace view USER_CROSS_REFS
    (TABLE_NAME, TABLE_TYPE, REF_OWNER, REF_TABLE_NAME, REF_DB_LINK)
as
select o.name, 'SYNONYM', s.owner, s.name, s.node
from sys.syn$ s, sys.obj$ o
where o.owner# = uid
  and o.type = 5
  and o.obj# = s.obj#
union all
select do.name, 'VIEW', nvl(po.remoteowner, pu.name), po.name, po.linkname
from dependency$ d, obj$ do, obj$ po, user$ pu
where d.d_obj# = do.obj#
  and d.d_timestamp = do.stime
  and do.owner# = uid
  and d.p_obj# = po.obj#
  and d.p_timestamp = po.stime
  and po.owner# = pu.user#
/
comment on table USER_CROSS_REFS is 
'Cross references for user''s views and synonyms'
/
comment on column USER_CROSS_REFS.TABLE_NAME is
'Name of the referencing object'
/
comment on column USER_CROSS_REFS.TABLE_TYPE is
'Type of the referencing object'
/
comment on column USER_CROSS_REFS.REF_OWNER is
'Owner of the referenced object'
/
comment on column USER_CROSS_REFS.REF_TABLE_NAME is
'Name of the referenced object'
/
comment on column USER_CROSS_REFS.REF_DB_LINK is
'Database link of the referenced object'
/
drop public synonym USER_CROSS_REFS
/
create public synonym USER_CROSS_REFS for USER_CROSS_REFS
/
grant select on USER_CROSS_REFS to PUBLIC with grant option
/
create or replace view DBA_CROSS_REFS
    (OWNER, TABLE_NAME, TABLE_TYPE, REF_OWNER, REF_TABLE_NAME, REF_DB_LINK)
as
select u.name, o.name, 'SYNONYM', s.owner, s.name, s.node
from sys.syn$ s, sys.obj$ o, sys.user$ u
where o.type = 5
  and o.obj# = s.obj#
  and o.owner# = u.user#
union
select du.name, do.name, 'VIEW', nvl(po.remoteowner, pu.name),
       po.name, po.linkname
from dependency$ d, obj$ do, obj$ po, user$ pu, user$ du
where d.d_obj# = do.obj#
  and d.d_timestamp = do.stime
  and d.p_obj# = po.obj#
  and d.p_timestamp = po.stime
  and po.owner# = pu.user#
  and do.owner# = du.user#
/
comment on table DBA_CROSS_REFS is
'Cross reference of all views and synonyms'
/
comment on column DBA_CROSS_REFS.OWNER is
'Owner of the referencing object'
/
comment on column DBA_CROSS_REFS.TABLE_NAME is
'Name of the referencing object'
/
comment on column DBA_CROSS_REFS.TABLE_TYPE is
'Type of the referencing object'
/
comment on column DBA_CROSS_REFS.REF_OWNER is
'Owner of the referenced object'
/
comment on column DBA_CROSS_REFS.REF_TABLE_NAME is
'Name of the referenced object'
/
comment on column DBA_CROSS_REFS.REF_DB_LINK is
'Database link of the referenced object'
/
Rem
Rem  Create views which subsitute for old tabauth$ and colauth$ tables
Rem
create or replace view tabauth$ 
  (obj#, grantor#, grantee#, time, sequence#, alter$, 
   delete$,index$, insert$, select$, update$, references$) as
  select obj#, grantor#, grantee#, to_date(max(null)), min(sequence#),
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 25, 2), 
      '00', 0, '01', 2, '11', 3, 0),
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 19, 2), 
      '00', 0, '01', 2, '11', 3, 0),
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 15, 2), 
      '00', 0, '01', 2, '11', 3, 0),
    decode(substr(lpad(sum(decode(col#, null, power(10, privilege#*2) + 
       decode(option$, null, 0, power(10, privilege#*2 + 1)), 0)), 26, '0'), 
              13, 2), '01', 2, '11', 3, 
         decode(substr(lpad(sum(decode(col#, null, 0, power(10, privilege#))),
                12, '0'), 6, 1), '0', 0, 1)),
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 7, 2), 
      '00', 0, '01', 2, '11', 3, 0),
    decode(substr(lpad(sum(decode(col#, null, power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1)), 0)), 26, '0'), 
             5, 2),'01', 2, '11', 3, 
          decode(substr(lpad(sum(decode(col#, null, 0, power(10, privilege#))),
                 12, '0'), 2, 1), '0', 0, 1)),
    decode(substr(lpad(sum(decode(col#, null, power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1)), 0)), 26, '0'), 
             3, 2), '01', 2, '11', 3, 
          decode(substr(lpad(sum(decode(col#, null, 0, power(10, privilege#))),
                 12, '0'), 1, 1), '0', 0, 1))
  from sys.objauth$
  group by obj#, grantor#, grantee#
/
create or replace view colauth$ (obj#, grantor#, grantee#, time, name, 
                      update$, references$, select$, insert$) as
  select oa.obj#, grantor#, grantee#, to_date(max(null)), max(c.name),
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 5, 2), 
      '00', 0, '01', 2, '11', 3, 0),
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 3, 2), 
      '00', 0, '01', 2, '11', 3, 0),
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 7, 2), 
      '00', 0, '01', 2, '11', 3, 0),
    decode(substr(lpad(sum(power(10, privilege#*2) + 
      decode(option$, null, 0, power(10, privilege#*2 + 1))), 26, '0'), 13, 2), 
      '00', 0, '01', 2, '11', 3, 0)
  from col$ c, objauth$ oa
  where oa.col# is not null and oa.obj# = c.obj# and oa.col# = c.col#
  group by oa.obj#, oa.col#, grantor#, grantee#
/
remark
remark  FAMILY "TAB_GRANTS"
remark  Grants on objects.
remark
create or replace view USER_TAB_GRANTS
      (GRANTEE, OWNER, TABLE_NAME, GRANTOR,
       SELECT_PRIV, INSERT_PRIV, DELETE_PRIV, 
       UPDATE_PRIV, REFERENCES_PRIV, ALTER_PRIV, INDEX_PRIV,
       CREATED)
as
select ue.name, u.name, o.name, ur.name,
       decode(ta.select$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.insert$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.delete$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.update$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.references$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.alter$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.index$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       ta.time
from sys.tabauth$ ta, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue
where ta.obj# = o.obj#
  and ta.grantor# = ur.user#
  and ta.grantee# = ue.user#
  and u.user# = o.owner#
  and uid in (ta.grantor#, ta.grantee#, o.owner#)
/
comment on table USER_TAB_GRANTS is
'Grants on objects for which the user is the owner, grantor or grantee'
/
comment on column USER_TAB_GRANTS.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column USER_TAB_GRANTS.OWNER is
'Owner of the object'
/
comment on column USER_TAB_GRANTS.TABLE_NAME is
'Name of the object'
/
comment on column USER_TAB_GRANTS.GRANTOR is
'Name of the user who performed the grant'
/
comment on column USER_TAB_GRANTS.SELECT_PRIV is
'Permission to SELECT from the object?'
/
comment on column USER_TAB_GRANTS.INSERT_PRIV is
'Permission to INSERT into the object?'
/
comment on column USER_TAB_GRANTS.DELETE_PRIV is
'Permission to DELETE from the object?'
/
comment on column USER_TAB_GRANTS.UPDATE_PRIV is
'Permission to UPDATE the object?'
/
comment on column USER_TAB_GRANTS.REFERENCES_PRIV is
'Permission to make REFERENCES to the object?'
/
comment on column USER_TAB_GRANTS.ALTER_PRIV is
'Permission to ALTER the object?'
/
comment on column USER_TAB_GRANTS.INDEX_PRIV is
'Permission to create/drop an INDEX on the object?'
/
comment on column USER_TAB_GRANTS.CREATED is
'Timestamp for the grant'
/
drop public synonym USER_TAB_GRANTS
/
create public synonym USER_TAB_GRANTS for USER_TAB_GRANTS
/
grant select on USER_TAB_GRANTS to PUBLIC
/
create or replace view DBA_TAB_GRANTS
      (GRANTEE, OWNER, TABLE_NAME, GRANTOR,
       SELECT_PRIV, INSERT_PRIV, DELETE_PRIV, 
       UPDATE_PRIV, REFERENCES_PRIV, ALTER_PRIV, INDEX_PRIV,
       CREATED)
as
select ue.name, u.name, o.name, ur.name,
       decode(ta.select$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.insert$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.delete$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.update$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.references$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.alter$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.index$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       ta.time
from sys.tabauth$ ta, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue
where ta.obj# = o.obj#
  and ta.grantor# = ur.user#
  and ta.grantee# = ue.user#
  and u.user# = o.owner#
/
comment on table DBA_TAB_GRANTS is
'All grants on objects in the database'
/
comment on column DBA_TAB_GRANTS.GRANTEE is
'User to whom access was granted'
/
comment on column DBA_TAB_GRANTS.OWNER is
'Owner of the object'
/
comment on column DBA_TAB_GRANTS.TABLE_NAME is
'Name of the object'
/
comment on column DBA_TAB_GRANTS.GRANTOR is
'Name of the user who performed the grant'
/
comment on column DBA_TAB_GRANTS.SELECT_PRIV is
'Permission to SELECT from the object?'
/
comment on column DBA_TAB_GRANTS.INSERT_PRIV is
'Permission to INSERT into the object?'
/
comment on column DBA_TAB_GRANTS.DELETE_PRIV is
'Permission to DELETE from the object?'
/
comment on column DBA_TAB_GRANTS.UPDATE_PRIV is
'Permission to UPDATE the object?'
/
comment on column DBA_TAB_GRANTS.REFERENCES_PRIV is
'Permission to make REFERENCES to the object?'
/
comment on column DBA_TAB_GRANTS.ALTER_PRIV is
'Permission to ALTER the object?'
/
comment on column DBA_TAB_GRANTS.INDEX_PRIV is
'Permission to create/drop an INDEX on the object?'
/
comment on column DBA_TAB_GRANTS.CREATED is
'Timestamp for the grant'
/
remark
remark  FAMILY "TAB_GRANTS_MADE"
remark  Grants made on objects.
remark  This family has no DBA member.
remark
create or replace view USER_TAB_GRANTS_MADE
      (GRANTEE, TABLE_NAME, GRANTOR,
       SELECT_PRIV, INSERT_PRIV, DELETE_PRIV, 
       UPDATE_PRIV, REFERENCES_PRIV, ALTER_PRIV, INDEX_PRIV,
       CREATED)
as
select ue.name, o.name, ur.name,
       decode(ta.select$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.insert$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.delete$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.update$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.references$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.alter$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.index$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       ta.time
from sys.tabauth$ ta, sys.obj$ o, sys.user$ ue, sys.user$ ur
where ta.obj# = o.obj#
  and ta.grantor# = ur.user#
  and ta.grantee# = ue.user#
  and o.owner# = uid
/
comment on table USER_TAB_GRANTS_MADE is
'All grants on objects owned by the user'
/
comment on column USER_TAB_GRANTS_MADE.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column USER_TAB_GRANTS_MADE.TABLE_NAME is
'Name of the object'
/
comment on column USER_TAB_GRANTS_MADE.GRANTOR is
'Name of the user who performed the grant'
/
comment on column USER_TAB_GRANTS_MADE.SELECT_PRIV is
'Permission to SELECT from the object?'
/
comment on column USER_TAB_GRANTS_MADE.INSERT_PRIV is
'Permission to INSERT into the object?'
/
comment on column USER_TAB_GRANTS_MADE.DELETE_PRIV is
'Permission to DELETE from the object?'
/
comment on column USER_TAB_GRANTS_MADE.UPDATE_PRIV is
'Permission to UPDATE the object?'
/
comment on column USER_TAB_GRANTS_MADE.REFERENCES_PRIV is
'Permission to make REFERENCES to the object?'
/
comment on column USER_TAB_GRANTS_MADE.ALTER_PRIV is
'Permission to ALTER the object?'
/
comment on column USER_TAB_GRANTS_MADE.INDEX_PRIV is
'Permission to CREATE/DROP INDEX on the object?'
/
comment on column USER_TAB_GRANTS_MADE.CREATED is
'Timestamp for the grant'
/
drop public synonym USER_TAB_GRANTS_MADE
/
create public synonym USER_TAB_GRANTS_MADE for USER_TAB_GRANTS_MADE
/
grant select on USER_TAB_GRANTS_MADE to PUBLIC
/
create or replace view ALL_TAB_GRANTS_MADE
      (GRANTEE, OWNER, TABLE_NAME, GRANTOR,
       SELECT_PRIV, INSERT_PRIV, DELETE_PRIV, 
       UPDATE_PRIV, REFERENCES_PRIV, ALTER_PRIV, INDEX_PRIV,
       CREATED)
as
select ue.name, u.name, o.name, ur.name,
       decode(ta.select$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.insert$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.delete$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.update$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.references$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.alter$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.index$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       ta.time
from sys.tabauth$ ta, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue
where ta.obj# = o.obj#
  and ta.grantor# = ur.user#
  and ta.grantee# = ue.user#
  and u.user# = o.owner#
  and uid in (o.owner#, ta.grantor#)
/
comment on table ALL_TAB_GRANTS_MADE is
'User''s grants and grants on user''s objects'
/
comment on column ALL_TAB_GRANTS_MADE.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column ALL_TAB_GRANTS_MADE.OWNER is
'Owner of the object'
/
comment on column ALL_TAB_GRANTS_MADE.TABLE_NAME is
'Name of the object'
/
comment on column ALL_TAB_GRANTS_MADE.GRANTOR is
'Name of the user who performed the grant'
/
comment on column ALL_TAB_GRANTS_MADE.SELECT_PRIV is
'Permission to SELECT from the object?'
/
comment on column ALL_TAB_GRANTS_MADE.INSERT_PRIV is
'Permission to INSERT into the object?'
/
comment on column ALL_TAB_GRANTS_MADE.DELETE_PRIV is
'Permission to DELETE from the object?'
/
comment on column ALL_TAB_GRANTS_MADE.UPDATE_PRIV is
'Permission to UPDATE the object?'
/
comment on column ALL_TAB_GRANTS_MADE.REFERENCES_PRIV is
'Permission to make REFERENCES to the object?'
/
comment on column ALL_TAB_GRANTS_MADE.ALTER_PRIV is
'Permission to ALTER the object?'
/
comment on column ALL_TAB_GRANTS_MADE.INDEX_PRIV is
'Permission to CREATE/DROP INDEX on the object?'
/
comment on column ALL_TAB_GRANTS_MADE.CREATED is
'Timestamp for the grant'
/
drop public synonym ALL_TAB_GRANTS_MADE
/
create public synonym ALL_TAB_GRANTS_MADE for ALL_TAB_GRANTS_MADE
/
grant select on ALL_TAB_GRANTS_MADE to PUBLIC
/
remark
remark  FAMILY "TAB_GRANTS_RECD"
remark  Grants received on objects.
remark  This family has no DBA member.
remark
create or replace view USER_TAB_GRANTS_RECD
      (OWNER, TABLE_NAME, GRANTOR,
       SELECT_PRIV, INSERT_PRIV, DELETE_PRIV, 
       UPDATE_PRIV, REFERENCES_PRIV, ALTER_PRIV, INDEX_PRIV,
       CREATED)
as
select u.name, o.name, ur.name,
       decode(ta.select$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.insert$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.delete$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.update$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.references$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.alter$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.index$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       ta.time
from sys.tabauth$ ta, sys.obj$ o, sys.user$ u, sys.user$ ur
where ta.obj# = o.obj#
  and ta.grantor# = ur.user#
  and u.user# = o.owner#
  and ta.grantee# = uid
/
comment on table USER_TAB_GRANTS_RECD is
'Grants on objects for which the user is the grantee'
/
comment on column USER_TAB_GRANTS_RECD.OWNER is
'Owner of the object'
/
comment on column USER_TAB_GRANTS_RECD.TABLE_NAME is
'Name of the object'
/
comment on column USER_TAB_GRANTS_RECD.GRANTOR is
'Name of the user who performed the grant'
/
comment on column USER_TAB_GRANTS_RECD.SELECT_PRIV is
'Permission to SELECT from the object?'
/
comment on column USER_TAB_GRANTS_RECD.INSERT_PRIV is
'Permission to INSERT into the object?'
/
comment on column USER_TAB_GRANTS_RECD.DELETE_PRIV is
'Permission to DELETE from the object?'
/
comment on column USER_TAB_GRANTS_RECD.UPDATE_PRIV is
'Permission to UPDATE the object?'
/
comment on column USER_TAB_GRANTS_RECD.REFERENCES_PRIV is
'Permission to make REFERENCES to the object?'
/
comment on column USER_TAB_GRANTS_RECD.ALTER_PRIV is
'Permission to ALTER the object?'
/
comment on column USER_TAB_GRANTS_RECD.INDEX_PRIV is
'Permission to create/drop an INDEX on the object?'
/
comment on column USER_TAB_GRANTS_RECD.CREATED is
'Timestamp for the grant'
/
drop public synonym USER_TAB_GRANTS_RECD
/
create public synonym USER_TAB_GRANTS_RECD for USER_TAB_GRANTS_RECD
/
grant select on USER_TAB_GRANTS_RECD to PUBLIC
/
create or replace view ALL_TAB_GRANTS_RECD
      (GRANTEE, OWNER, TABLE_NAME, GRANTOR,
       SELECT_PRIV, INSERT_PRIV, DELETE_PRIV, 
       UPDATE_PRIV, REFERENCES_PRIV, ALTER_PRIV, INDEX_PRIV,
       CREATED)
as
select ue.name, u.name, o.name, ur.name,
       decode(ta.select$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.insert$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.delete$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.update$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.references$, 0, 'N', 1, 'S', 2, 'A', 3, 'G', '?'),
       decode(ta.alter$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ta.index$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       ta.time
from sys.tabauth$ ta, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue
where ta.obj# = o.obj#
  and ta.grantor# = ur.user#
  and ta.grantee# = ue.user#
  and u.user# = o.owner#
  and ta.grantee# in (select kzsrorol from x$kzsro)
/
comment on table ALL_TAB_GRANTS_RECD is
'Grants on objects for which the user or PUBLIC is the grantee'
/
comment on column ALL_TAB_GRANTS_RECD.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column ALL_TAB_GRANTS_RECD.OWNER is
'Owner of the object'
/
comment on column ALL_TAB_GRANTS_RECD.TABLE_NAME is
'Name of the object'
/
comment on column ALL_TAB_GRANTS_RECD.GRANTOR is
'Name of the user who performed the grant'
/
comment on column ALL_TAB_GRANTS_RECD.SELECT_PRIV is
'Permission to SELECT from the object?'
/
comment on column ALL_TAB_GRANTS_RECD.INSERT_PRIV is
'Permission to INSERT into the object?'
/
comment on column ALL_TAB_GRANTS_RECD.DELETE_PRIV is
'Permission to DELETE from the object?'
/
comment on column ALL_TAB_GRANTS_RECD.UPDATE_PRIV is
'Permission to UPDATE the object?'
/
comment on column ALL_TAB_GRANTS_RECD.REFERENCES_PRIV is
'Permission to make REFERENCES to the object?'
/
comment on column ALL_TAB_GRANTS_RECD.ALTER_PRIV is
'Permission to ALTER the object?'
/
comment on column ALL_TAB_GRANTS_RECD.INDEX_PRIV is
'Permission to create/drop an INDEX on the object?'
/
comment on column ALL_TAB_GRANTS_RECD.CREATED is
'Timestamp for the grant'
/
drop public synonym ALL_TAB_GRANTS_RECD
/
create public synonym ALL_TAB_GRANTS_RECD for ALL_TAB_GRANTS_RECD
/
grant select on ALL_TAB_GRANTS_RECD to PUBLIC
/
remark
remark  FAMILY "COL_GRANTS"
remark  Grants on columns.
remark
create or replace view USER_COL_GRANTS
      (GRANTEE, OWNER, TABLE_NAME, COLUMN_NAME, GRANTOR,
       UPDATE_PRIV, REFERENCES_PRIV,
       CREATED)
as
select ue.name, u.name, o.name, ca.name, ur.name,
       decode(ca.update$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ca.references$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       ca.time
from sys.colauth$ ca, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue
where ca.obj# = o.obj#
  and ca.grantor# = ur.user#
  and ca.grantee# = ue.user#
  and u.user# = o.owner#
  and uid in (ca.grantor#, ca.grantee#, o.owner#)
/
comment on table USER_COL_GRANTS is
'Grants on columns for which the user is the owner, grantor or grantee'
/
comment on column USER_COL_GRANTS.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column USER_COL_GRANTS.OWNER is
'Username of the owner of the object'
/
comment on column USER_COL_GRANTS.TABLE_NAME is
'Name of the object'
/
comment on column USER_COL_GRANTS.COLUMN_NAME is
'Name of the column'
/
comment on column USER_COL_GRANTS.GRANTOR is
'Name of the user who performed the grant'
/
comment on column USER_COL_GRANTS.UPDATE_PRIV is
'Permission to UPDATE the column?'
/
comment on column USER_COL_GRANTS.REFERENCES_PRIV is
'Permission to make REFERENCES to the column?'
/
comment on column USER_COL_GRANTS.CREATED is
'Timestamp for the grant'
/
drop public synonym USER_COL_GRANTS
/
create public synonym USER_COL_GRANTS for USER_COL_GRANTS
/
grant select on USER_COL_GRANTS to PUBLIC
/
drop public synonym ALL_TAB_GRANTS
/
create public synonym ALL_TAB_GRANTS for TABLE_PRIVILEGES
/
drop public synonym ALL_COL_GRANTS
/
create public synonym ALL_COL_GRANTS for COLUMN_PRIVILEGES
/
create or replace view DBA_COL_GRANTS
      (GRANTEE, OWNER, TABLE_NAME, COLUMN_NAME, GRANTOR,
       UPDATE_PRIV, REFERENCES_PRIV,
       CREATED)
as
select ue.name, u.name, o.name, ca.name, ur.name,
       decode(ca.update$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ca.references$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       ca.time
from sys.colauth$ ca, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue
where ca.obj# = o.obj#
  and ca.grantor# = ur.user#
  and ca.grantee# = ue.user#
  and u.user# = o.owner#
/
comment on table DBA_COL_GRANTS is
'All grants on columns in the database'
/
comment on column DBA_COL_GRANTS.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column DBA_COL_GRANTS.OWNER is
'Username of the owner of the object'
/
comment on column DBA_COL_GRANTS.TABLE_NAME is
'Name of the object'
/
comment on column DBA_COL_GRANTS.COLUMN_NAME is
'Name of the column'
/
comment on column DBA_COL_GRANTS.GRANTOR is
'Name of the user who performed the grant'
/
comment on column DBA_COL_GRANTS.UPDATE_PRIV is
'Permission to UPDATE the column?'
/
comment on column DBA_COL_GRANTS.REFERENCES_PRIV is
'Permission to make REFERENCES to the column?'
/
comment on column DBA_COL_GRANTS.CREATED is
'Timestamp for the grant'
/
remark
remark  FAMILY "COL_GRANTS_MADE"
remark  Grants on columns made by the user.
remark  This family has no DBA member.
remark
create or replace view USER_COL_GRANTS_MADE
      (GRANTEE, TABLE_NAME, COLUMN_NAME, GRANTOR,
       UPDATE_PRIV, REFERENCES_PRIV,
       CREATED)
as
select ue.name, o.name, ca.name, ur.name,
       decode(ca.update$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ca.references$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       ca.time
from sys.colauth$ ca, sys.obj$ o, sys.user$ ue, sys.user$ ur
where ca.obj# = o.obj#
  and ca.grantor# = ur.user#
  and ca.grantee# = ue.user#
  and o.owner# = uid
/
comment on table USER_COL_GRANTS_MADE is
'All grants on columns of objects owned by the user'
/
comment on column USER_COL_GRANTS_MADE.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column USER_COL_GRANTS_MADE.TABLE_NAME is
'Name of the object'
/
comment on column USER_COL_GRANTS_MADE.COLUMN_NAME is
'Name of the column'
/
comment on column USER_COL_GRANTS_MADE.GRANTOR is
'Name of the user who performed the grant'
/
comment on column USER_COL_GRANTS_MADE.UPDATE_PRIV is
'Permission to UPDATE the column?'
/
comment on column USER_COL_GRANTS_MADE.REFERENCES_PRIV is
'Permission to make REFERENCES to the column?'
/
comment on column USER_COL_GRANTS_MADE.CREATED is
'Timestamp for the grant'
/
drop public synonym USER_COL_GRANTS_MADE
/
create public synonym USER_COL_GRANTS_MADE for USER_COL_GRANTS_MADE
/
grant select on USER_COL_GRANTS_MADE to PUBLIC
/
create or replace view ALL_COL_GRANTS_MADE
      (GRANTEE, OWNER, TABLE_NAME, COLUMN_NAME, GRANTOR,
       UPDATE_PRIV, REFERENCES_PRIV,
       CREATED)
as
select ue.name, u.name, o.name, ca.name, ur.name,
       decode(ca.update$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ca.references$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       ca.time
from sys.colauth$ ca, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue
where ca.obj# = o.obj#
  and ca.grantor# = ur.user#
  and ca.grantee# = ue.user#
  and u.user# = o.owner#
  and uid in (o.owner#, ca.grantor#)
/
comment on table ALL_COL_GRANTS_MADE is
'Grants on columns for which the user is owner or grantor'
/
comment on column ALL_COL_GRANTS_MADE.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column ALL_COL_GRANTS_MADE.OWNER is
'Username of the owner of the object'
/
comment on column ALL_COL_GRANTS_MADE.TABLE_NAME is
'Name of the object'
/
comment on column ALL_COL_GRANTS_MADE.COLUMN_NAME is
'Name of the column'
/
comment on column ALL_COL_GRANTS_MADE.GRANTOR is
'Name of the user who performed the grant'
/
comment on column ALL_COL_GRANTS_MADE.UPDATE_PRIV is
'Permission to UPDATE the column?'
/
comment on column ALL_COL_GRANTS_MADE.REFERENCES_PRIV is
'Permission to make REFERENCES to the column?'
/
comment on column ALL_COL_GRANTS_MADE.CREATED is
'Timestamp for the grant'
/
drop public synonym ALL_COL_GRANTS_MADE
/
create public synonym ALL_COL_GRANTS_MADE for ALL_COL_GRANTS_MADE
/
grant select on ALL_COL_GRANTS_MADE to PUBLIC
/
remark
remark  FAMILY "COL_GRANTS_RECD"
remark  Received grants on columns
remark
create or replace view USER_COL_GRANTS_RECD
      (OWNER, TABLE_NAME, COLUMN_NAME, GRANTOR,
       UPDATE_PRIV, REFERENCES_PRIV,
       CREATED)
as
select u.name, o.name, ca.name, ur.name,
       decode(ca.update$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ca.references$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       ca.time
from sys.colauth$ ca, sys.obj$ o, sys.user$ u, sys.user$ ur
where ca.obj# = o.obj#
  and ca.grantor# = ur.user#
  and u.user# = o.owner#
  and ca.grantee# = uid
/
comment on table USER_COL_GRANTS_RECD is
'Grants on columns for which the user is the grantee'
/
comment on column USER_COL_GRANTS_RECD.OWNER is
'Username of the owner of the object'
/
comment on column USER_COL_GRANTS_RECD.TABLE_NAME is
'Name of the object'
/
comment on column USER_COL_GRANTS_RECD.COLUMN_NAME is
'Name of the column'
/
comment on column USER_COL_GRANTS_RECD.GRANTOR is
'Name of the user who performed the grant'
/
comment on column USER_COL_GRANTS_RECD.UPDATE_PRIV is
'Permission to UPDATE the column?'
/
comment on column USER_COL_GRANTS_RECD.REFERENCES_PRIV is
'Permission to make REFERENCES to the column?'
/
comment on column USER_COL_GRANTS_RECD.CREATED is
'Timestamp for the grant'
/
drop public synonym USER_COL_GRANTS_RECD
/
create public synonym USER_COL_GRANTS_RECD for USER_COL_GRANTS_RECD
/
grant select on USER_COL_GRANTS_RECD to PUBLIC
/
create or replace view ALL_COL_GRANTS_RECD
      (GRANTEE, OWNER, TABLE_NAME, COLUMN_NAME, GRANTOR,
       UPDATE_PRIV, REFERENCES_PRIV,
       CREATED)
as
select ue.name, u.name, o.name, ca.name, ur.name,
       decode(ca.update$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       decode(ca.references$, 0, 'N', 2, 'Y', 3, 'G', '?'),
       ca.time
from sys.colauth$ ca, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue
where ca.obj# = o.obj#
  and ca.grantor# = ur.user#
  and ca.grantee# = ue.user#
  and u.user# = o.owner#
  and ca.grantee# in (select kzsrorol from x$kzsro)
/
comment on table ALL_COL_GRANTS_RECD is
'Grants on columns for which the user or PUBLIC is the grantee'
/
comment on column ALL_COL_GRANTS_RECD.GRANTEE is
'Name of the user to whom access was granted'
/
comment on column ALL_COL_GRANTS_RECD.OWNER is
'Username of the owner of the object'
/
comment on column ALL_COL_GRANTS_RECD.TABLE_NAME is
'Name of the object'
/
comment on column ALL_COL_GRANTS_RECD.COLUMN_NAME is
'Name of the column'
/
comment on column ALL_COL_GRANTS_RECD.GRANTOR is
'Name of the user who performed the grant'
/
comment on column ALL_COL_GRANTS_RECD.UPDATE_PRIV is
'Permission to UPDATE the column?'
/
comment on column ALL_COL_GRANTS_RECD.REFERENCES_PRIV is
'Permission to make REFERENCES to the column?'
/
comment on column ALL_COL_GRANTS_RECD.CREATED is
'Timestamp for the grant'
/
drop public synonym ALL_COL_GRANTS_RECD
/
create public synonym ALL_COL_GRANTS_RECD for ALL_COL_GRANTS_RECD
/
grant select on ALL_COL_GRANTS_RECD to PUBLIC
/

remark
remark  USER_AUDIT_CONNECT
remark  Lists the audit trail entries produced by AUDIT CONNECT.
remark  DBA's see all entries, while ordinary users only
remark  see entries for their own logins/logoffs.
remark
remark  DBA_AUDIT_CONNECT is implemented as synonym of user_audit_connect,
remark  which in turn is implemented in terms of user_audit_trail.
remark
create or replace view USER_AUDIT_CONNECT as
  select username, userhost, terminal, timestamp,
         action_name,
         logoff_time, logoff_lread, logoff_pread, logoff_lwrite, logoff_dlock,
         sessionid, returncode
  from user_audit_trail
  where action between 100 and 102
/
comment on table USER_AUDIT_CONNECT is
'Audit trail entries for user logons/logoffs'
/
comment on column USER_AUDIT_CONNECT.USERNAME is
'Name (not ID number) of the user whose actions were audited'
/
comment on column USER_AUDIT_CONNECT.USERHOST is
'Numeric instance ID for the Oracle instance from which the user is accessing t\
he database.  Used only in environments with distributed file systems and share\
d database files (e.g., clustered Oracle on DEC VAX/VMS clusters)'
/
comment on column USER_AUDIT_CONNECT.TERMINAL is
'Identifier for the user''s terminal'
/
comment on column USER_AUDIT_CONNECT.TIMESTAMP is
'Timestamp for the user''s logon'
/
comment on column USER_AUDIT_CONNECT.ACTION_NAME is
'Name of the action type corresponding to the numeric code in ACTION'
/
remark  A single audit entry describes both the logon and logoff.
remark  The logoff_* columns are null while a user is logged in.
/
comment on column USER_AUDIT_CONNECT.LOGOFF_TIME is
'Timestamp for user logoff'
/
comment on column USER_AUDIT_CONNECT.LOGOFF_LREAD is
'Logical reads for the session'
/
comment on column USER_AUDIT_CONNECT.LOGOFF_PREAD is
'Physical reads for the session'
/
comment on column USER_AUDIT_CONNECT.LOGOFF_LWRITE is
'Logical writes for the session'
/
comment on column USER_AUDIT_CONNECT.LOGOFF_DLOCK is
'Deadlocks detected during the session'
/
comment on column USER_AUDIT_CONNECT.SESSIONID is
'Numeric ID for each Oracle session'
/
comment on column USER_AUDIT_CONNECT.RETURNCODE is
'Oracle error code generated by the action.  Zero if the action succeeded'
/
drop public synonym USER_AUDIT_CONNECT
/
create public synonym USER_AUDIT_CONNECT for USER_AUDIT_CONNECT
/
grant select on USER_AUDIT_CONNECT to public
/
drop public synonym DBA_AUDIT_CONNECT
/
create public synonym DBA_AUDIT_CONNECT for USER_AUDIT_CONNECT
/
remark
remark  USER_AUDIT_RESOURCE
remark  DBA_AUDIT_RESOURCE implemented in terms of user_audit_resource.
remark  DBA Sees all.
remark
remark  Lists audit trail entries produced by AUDIT RESOURCE.
remark
/
create or replace view USER_AUDIT_RESOURCE as
  select username, userhost, terminal, timestamp,
         owner, obj_name,
         action_name,
         sessionid, entryid, statementid, returncode
  from user_audit_trail
  where action in (1, 4, 8, 9, 10, 12, 13, 16, 19, 20, 21, 22, 24,
                   32, 33, 36, 38, 39, 41, 58, 59, 61, 65, 66, 68,
                   71, 73, 74, 76, 110, 111, 112, 113)
/
comment on column USER_AUDIT_RESOURCE.USERNAME is
'Name (not ID number) of the user whose actions were audited'
/
comment on column USER_AUDIT_RESOURCE.USERHOST is
'Numeric instance ID for the Oracle instance from which the user is accessing t\
he database.  Used only in environments with distributed file systems and share\
d database files (e.g., clustered Oracle on DEC VAX/VMS clusters)'
/
comment on column USER_AUDIT_RESOURCE.TERMINAL is
'Identifier for the user''s terminal'
/
comment on column USER_AUDIT_RESOURCE.TIMESTAMP is
'Timestamp for the creation of the audit trail entry'
/
comment on column USER_AUDIT_RESOURCE.OWNER is
'Intended creator of the non-existent object'
/
comment on column USER_AUDIT_RESOURCE.OBJ_NAME is
'Name of the object affected by the action'
/
comment on column USER_AUDIT_RESOURCE.ACTION_NAME is
'Name of the action type corresponding to the numeric code in ACTION'
/
comment on column USER_AUDIT_RESOURCE.SESSIONID is
'Numeric ID for each Oracle session'
/
comment on column USER_AUDIT_RESOURCE.ENTRYID is
'Numeric ID for each audit trail entry in the session'
/
comment on column USER_AUDIT_RESOURCE.STATEMENTID is
'Numeric ID for each statement run (a statement may cause many actions)'
/
comment on column USER_AUDIT_RESOURCE.RETURNCODE is
'Oracle error code generated by the action.  Zero if the action succeeded'
/
drop public synonym USER_AUDIT_RESOURCE
/
create public synonym USER_AUDIT_RESOURCE for USER_AUDIT_RESOURCE
/
grant select on USER_AUDIT_RESOURCE to public
/
drop public synonym DBA_AUDIT_RESOURCE
/
create public synonym DBA_AUDIT_RESOURCE for USER_AUDIT_RESOURCE
/

remark
remark  DBA_AUDIT_DBA
remark  This view is only accessible to DBAs.
remark  Lists audit trail entries produced by AUDIT DBA
remark
remark
remark  The connect, resource and dba columns are filled in for
remark  entries related to granting/revoking system-wide privileges.
remark  The value 'Y' indicates the priv was granted/revoked.  If not,
remark  a '-' appears.
remark
/
create or replace view DBA_AUDIT_DBA as
  select username, userhost, terminal, timestamp,
         owner, 
	 decode(obj_name, 'CONNECT', NULL, 'RESOURCE', NULL, 'DBA', NULL,
	        obj_name) obj_name,
         action, action_name,
	 decode(action, 108, decode(logoff_dlock, 5, 'Y', '-'),
	        109, decode(logoff_dlock, 5, 'Y', '-'),
                114, decode(obj_name, 'CONNECT', 'Y', '-'),
                115, decode(obj_name, 'CONNECT', 'Y', '-')) connect_priv,
	 decode(obj_name, 'DBA', 'Y', '-') dba_priv,
	 decode(action, 108, decode(logoff_dlock, 15, 'Y', '-'),
                109, decode(logoff_dlock, 15, 'Y', '-'),
                114, decode(obj_name, 'RESOURCE', 'Y', '-'),
                115, decode(obj_name, 'RESOURCE', 'Y', '-')) resource_priv,
         grantee,
         sessionid, entryid, statementid, returncode
   from user_audit_trail
   where action in (17, 18, 30, 31, 43, 79)
         or action between 51 and 55
	 or action between 104 and 115
/
comment on table DBA_AUDIT_DBA is
'Audit trail entries created by AUDIT DBA'
/
comment on column DBA_AUDIT_DBA.USERNAME is
'Name (not ID number) of the user whose actions were audited'
/
comment on column DBA_AUDIT_DBA.USERHOST is
'Numeric instance ID for the Oracle instance from which the user is accessing t\
he database.  Used only in environments with distributed file systems and share\
d database files (e.g., clustered Oracle on DEC VAX/VMS clusters)'
/
comment on column DBA_AUDIT_DBA.TERMINAL is
'Identifier for the user''s terminal'
/
comment on column DBA_AUDIT_DBA.TIMESTAMP is
'Timestamp for the creation of the audit trail entry (Timestamp for the user''s\
 logon for entries created by AUDIT CONNECT)'
/
comment on column DBA_AUDIT_DBA.OWNER is
'Creator of object affected by the action'
/
comment on column DBA_AUDIT_DBA.OBJ_NAME is
'Name of the object affected by the action'
/
comment on column DBA_AUDIT_DBA.ACTION is
'Numeric action type code.  The corresponding name of the action type (CREATE T\
ABLE, INSERT, etc.) is in the column ACTION_NAME'
/
comment on column DBA_AUDIT_DBA.ACTION_NAME is
'Name of the action type corresponding to the numeric code in ACTION'
/
comment on column DBA_AUDIT_DBA.CONNECT_PRIV is
'Y or - for CONNECT privilege did or did not appear in GRANT/REVOKE statement'
/
comment on column DBA_AUDIT_DBA.DBA_PRIV is
'Y or - for DBA privilege did or did not appear in GRANT/REVOKE statement'
/
comment on column DBA_AUDIT_DBA.RESOURCE_PRIV is
'Y or - for RESOURCE privilege did or did not appear in GRANT/REVOKE statement'
/
remark  There is one audit entry for each grantee.
/
comment on column DBA_AUDIT_DBA.GRANTEE is
'The name of the grantee specified in a GRANT/REVOKE statement'
/
comment on column DBA_AUDIT_DBA.SESSIONID is
'Numeric ID for each Oracle session'
/
comment on column DBA_AUDIT_DBA.ENTRYID is
'Numeric ID for each audit trail entry in the session'
/
comment on column DBA_AUDIT_DBA.STATEMENTID is
'Numeric ID for each statement run (a statement may cause many actions)'
/
comment on column DBA_AUDIT_DBA.RETURNCODE is
'Oracle error code generated by the action.  Zero if the action succeeded'
/
drop public synonym DBA_AUDIT_DBA
/
create public synonym DBA_AUDIT_DBA for DBA_AUDIT_DBA
/

remark
remark  FAMILY "TAB_AUDIT_OPTS"
remark  Auditing options on objects.  Only "user_" and "dba_" members.
remark  A user is not allowed to see audit options for other people's objects.
remark
remark  These views indicate what kind of audit trail entries (none,
remark  session-level, or access-level) are generated by the success or failure
remark  of each possible operation on a table or view (e.g., select, alter).
remark
remark  The values in the columns ALT through UPD are three character
remark  strings like 'A/S', 'A/-'.  The letters 'A', 'S', and '-' correspond to
remark  different levels of detail called Access, Session and None.  The
remark  character before the slash determines the auditing level if the action
remark  is successful.  The character after the slash determines auditing level
remark  if the operation fails for any reason.
remark
remark  This compressed three character format has been chosen to make all
remark  the information fit on a single line.  The column names are
remark  three chars long for the same reason.  The alternative is to use long
remark  column names to improve readability, but
remark  serious users can get further documentation using the describe
remark  column statement.  I do not expect novice users to be looking at audit
remark  information.  Another alternative is to have separate columns for the
remark  success and failure settings.  This would eliminate the need to
remark  use the substr function in views built on top of these views,
remark  but the advantage to users of making information fit on one line
remark  overrides the hassle to view-implementors of using the substr function.
remark
create or replace view USER_TAB_AUDIT_OPTS
    (TABLE_NAME,
     TABLE_TYPE,
     ALT,
     AUD,
     COM,
     DEL,
     GRA,
     IND,
     INS,
     LOC,
     REN,
     SEL,
     UPD)
as
select o.name, 'TABLE',
       substr(t.audit$, 1, 1) || '/' || substr(t.audit$, 2, 1),
       substr(t.audit$, 3, 1) || '/' || substr(t.audit$, 4, 1),
       substr(t.audit$, 5, 1) || '/' || substr(t.audit$, 6, 1),
       substr(t.audit$, 7, 1) || '/' || substr(t.audit$, 8, 1),
       substr(t.audit$, 9, 1) || '/' || substr(t.audit$, 10, 1),
       substr(t.audit$, 11, 1) || '/' || substr(t.audit$, 12, 1),
       substr(t.audit$, 13, 1) || '/' || substr(t.audit$, 14, 1),
       substr(t.audit$, 15, 1) || '/' || substr(t.audit$, 16, 1),
       substr(t.audit$, 17, 1) || '/' || substr(t.audit$, 18, 1),
       substr(t.audit$, 19, 1) || '/' || substr(t.audit$, 20, 1),
       substr(t.audit$, 21, 1) || '/' || substr(t.audit$, 22, 1)
from sys.obj$ o, sys.tab$ t
where o.type = 2
  and not (o.owner# = 0 and o.name = '_default_auditing_options_')
  and o.owner# = uid
  and o.obj# = t.obj#
union all
select o.name, 'VIEW',
       substr(v.audit$, 1, 1) || '/' || substr(v.audit$, 2, 1),
       substr(v.audit$, 3, 1) || '/' || substr(v.audit$, 4, 1),
       substr(v.audit$, 5, 1) || '/' || substr(v.audit$, 6, 1),
       substr(v.audit$, 7, 1) || '/' || substr(v.audit$, 8, 1),
       substr(v.audit$, 9, 1) || '/' || substr(v.audit$, 10, 1),
       substr(v.audit$, 11, 1) || '/' || substr(v.audit$, 12, 1),
       substr(v.audit$, 13, 1) || '/' || substr(v.audit$, 14, 1),
       substr(v.audit$, 15, 1) || '/' || substr(v.audit$, 16, 1),
       substr(v.audit$, 17, 1) || '/' || substr(v.audit$, 18, 1),
       substr(v.audit$, 19, 1) || '/' || substr(v.audit$, 20, 1),
       substr(v.audit$, 21, 1) || '/' || substr(v.audit$, 22, 1)
from sys.obj$ o, sys.view$ v
where o.type = 4
  and o.owner# = uid
  and o.obj# = v.obj#
/
comment on table USER_TAB_AUDIT_OPTS is
'Auditing options for user''s own tables and views'
/
comment on column USER_TAB_AUDIT_OPTS.TABLE_NAME is
'Name of the object'
/
comment on column USER_TAB_AUDIT_OPTS.TABLE_TYPE is
'Type of the object:  "TABLE" or "VIEW"'
/
comment on column USER_TAB_AUDIT_OPTS.ALT is
'Auditing ALTER WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column USER_TAB_AUDIT_OPTS.AUD is
'Auditing AUDIT WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column USER_TAB_AUDIT_OPTS.COM is
'Auditing COMMENT WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column USER_TAB_AUDIT_OPTS.DEL is
'Auditing DELETE WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column USER_TAB_AUDIT_OPTS.GRA is
'Auditing GRANT WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column USER_TAB_AUDIT_OPTS.IND is
'Auditing INDEX WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column USER_TAB_AUDIT_OPTS.INS is
'Auditing INSERT WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column USER_TAB_AUDIT_OPTS.LOC is
'Auditing LOCK WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column USER_TAB_AUDIT_OPTS.REN is
'Auditing RENAME WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column USER_TAB_AUDIT_OPTS.SEL is
'Auditing SELECT WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column USER_TAB_AUDIT_OPTS.UPD is
'Auditing UPDATE WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
drop public synonym USER_TAB_AUDIT_OPTS
/
create public synonym USER_TAB_AUDIT_OPTS for USER_TAB_AUDIT_OPTS
/
grant select on USER_TAB_AUDIT_OPTS to PUBLIC
/
create or replace view DBA_TAB_AUDIT_OPTS
    (OWNER,
     TABLE_NAME,
     TABLE_TYPE,
     ALT,
     AUD,
     COM,
     DEL,
     GRA,
     IND,
     INS,
     LOC,
     REN,
     SEL,
     UPD)
as
select u.name, o.name, 'TABLE',
       substr(t.audit$, 1, 1) || '/' || substr(t.audit$, 2, 1),
       substr(t.audit$, 3, 1) || '/' || substr(t.audit$, 4, 1),
       substr(t.audit$, 5, 1) || '/' || substr(t.audit$, 6, 1),
       substr(t.audit$, 7, 1) || '/' || substr(t.audit$, 8, 1),
       substr(t.audit$, 9, 1) || '/' || substr(t.audit$, 10, 1),
       substr(t.audit$, 11, 1) || '/' || substr(t.audit$, 12, 1),
       substr(t.audit$, 13, 1) || '/' || substr(t.audit$, 14, 1),
       substr(t.audit$, 15, 1) || '/' || substr(t.audit$, 16, 1),
       substr(t.audit$, 17, 1) || '/' || substr(t.audit$, 18, 1),
       substr(t.audit$, 19, 1) || '/' || substr(t.audit$, 20, 1),
       substr(t.audit$, 21, 1) || '/' || substr(t.audit$, 22, 1)
from sys.obj$ o, sys.user$ u, sys.tab$ t
where o.type = 2
  and not (o.owner# = 0 and o.name = '_default_auditing_options_')
  and o.owner# = u.user#
  and o.obj# = t.obj#
union all
select u.name, o.name, 'VIEW',
       substr(v.audit$, 1, 1) || '/' || substr(v.audit$, 2, 1),
       substr(v.audit$, 3, 1) || '/' || substr(v.audit$, 4, 1),
       substr(v.audit$, 5, 1) || '/' || substr(v.audit$, 6, 1),
       substr(v.audit$, 7, 1) || '/' || substr(v.audit$, 8, 1),
       substr(v.audit$, 9, 1) || '/' || substr(v.audit$, 10, 1),
       substr(v.audit$, 11, 1) || '/' || substr(v.audit$, 12, 1),
       substr(v.audit$, 13, 1) || '/' || substr(v.audit$, 14, 1),
       substr(v.audit$, 15, 1) || '/' || substr(v.audit$, 16, 1),
       substr(v.audit$, 17, 1) || '/' || substr(v.audit$, 18, 1),
       substr(v.audit$, 19, 1) || '/' || substr(v.audit$, 20, 1),
       substr(v.audit$, 21, 1) || '/' || substr(v.audit$, 22, 1)
from sys.obj$ o, sys.user$ u, sys.view$ v
where o.type = 4
  and o.owner# = u.user#
  and o.obj# = v.obj#
/
comment on table DBA_TAB_AUDIT_OPTS is
'Auditing options for all tables and views'
/
comment on column DBA_TAB_AUDIT_OPTS.OWNER is
'Owner of the object'
/
comment on column DBA_TAB_AUDIT_OPTS.TABLE_NAME is
'Name of the object'
/
comment on column DBA_TAB_AUDIT_OPTS.TABLE_TYPE is
'Type of the object'
/
comment on column DBA_TAB_AUDIT_OPTS.ALT is
'Auditing ALTER WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column DBA_TAB_AUDIT_OPTS.AUD is
'Auditing AUDIT WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column DBA_TAB_AUDIT_OPTS.COM is
'Auditing COMMENT WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column DBA_TAB_AUDIT_OPTS.DEL is
'Auditing DELETE WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column DBA_TAB_AUDIT_OPTS.GRA is
'Auditing GRANT WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column DBA_TAB_AUDIT_OPTS.IND is
'Auditing INDEX WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column DBA_TAB_AUDIT_OPTS.INS is
'Auditing INSERT WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column DBA_TAB_AUDIT_OPTS.LOC is
'Auditing LOCK WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column DBA_TAB_AUDIT_OPTS.REN is
'Auditing RENAME WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column DBA_TAB_AUDIT_OPTS.SEL is
'Auditing SELECT WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
comment on column DBA_TAB_AUDIT_OPTS.UPD is
'Auditing UPDATE WHENEVER SUCCESSFUL / UNSUCCESSFUL'
/
