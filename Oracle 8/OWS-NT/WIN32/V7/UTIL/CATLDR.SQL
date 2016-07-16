rem 
rem $Header: catldr.sql,v 1.9 1995/11/08 15:21:34 jhealy Exp $ ulview.sql 
rem
Rem Copyright (c) 1990 by Oracle Corporation
Rem NAME
Rem    catldr.sql
Rem  FUNCTION
Rem    Views for the direct path of the loader
Rem  NOTES
Rem    This script must be run while connected as SYS or INTERNAL.
Rem  MODIFIED
Rem     jhealy     11/07/95 -  bitmap index support phase 1
Rem     wmaimone   05/06/94 -  #184921 run as sys/internal
Rem     ksudarsh   04/07/94 -  update loader_constraints_info
Rem     ksudarsh   02/06/94 -  merge changes from branch 1.3.710.2
Rem     ksudarsh   02/04/94 -  fix authorizations
Rem     jbellemo   12/17/93 -  merge changes from branch 1.3.710.1
Rem     jbellemo   11/29/93 -  #170173: change uid to userenv schemaid
Rem     ksudarsh   11/02/92 -  pdl changes 
Rem     tpystyne   11/22/92 -  use create or replace view 
Rem     glumpkin   10/25/92 -  Renamed from ULVIEW.SQL 
Rem     cheigham   04/28/92 -  users should see info only on tables on which th
Rem     cheigham   10/26/91 -  Creation 
Rem     cheigham   10/07/91 -  add lists, groups to tab,ind views
Rem     cheigham   09/30/91 -  merge changes from branch 1.3.50.2 
Rem     cheigham   09/23/91 -  fix cdef$ column reference 
Rem     cheigham   08/27/91 -  add ts# to loader_tab_info: 
Rem     cheigham   04/11/91 -         expand loader_constraint_info 
Rem   Heigham    09/26/90 - fix v7 LOADER_TRIGGER_INFO def
Rem   Heigham    07/16/90 - remove duplicate grant
Rem   Heigham    06/28/90 - add v$parameters grant
Rem   Heigham    01/22/90 - Creation
Rem
rem 

create or replace view LOADER_COL_INFO
(TABNAME, OWNER, COLNAME, SEGCOL, TYPE, LENGTH, PRECISION, SCALE, NONULL,
OFFSET)
as
select o.name, u.name, c.name, c.segcol#, c.type#, c.length, c.precision,
c.scale, c.null$, c.offset
from sys.col$ c, sys.obj$ o, sys.user$ u
where o.obj# = c.obj#
and o.owner# = u.user#
 and (o.owner# = userenv('schemaid')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
	    )
       or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK   ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
      )
/
drop public synonym LOADER_COL_INFO
/
create public synonym LOADER_COL_INFO for LOADER_COL_INFO
/
grant select on LOADER_COL_INFO to public
/
create or replace view LOADER_TAB_INFO
(NAME, FILENO, BLOCKNO, NUMCOLS, OWNER, OBJECTNO, TABLESPACENO, LISTS, GROUPS)
as
select o.name, t.file#, t.block#, t.cols, u.name, t.obj#, t.ts#, s.lists,
s.groups
from sys.tab$ t, sys.obj$ o, sys.user$ u, sys.seg$ s
where t.obj# = o.obj#
and o.owner# = u.user#
and t.file# = s.file#
and t.block# = s.block#
 and (o.owner# = userenv('schemaid')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
	    )
       or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK   ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
      )
/
drop public synonym LOADER_TAB_INFO
/
create public synonym LOADER_TAB_INFO for LOADER_TAB_INFO
/
grant select on LOADER_TAB_INFO to PUBLIC
/
create or replace view LOADER_IND_INFO
(NAME, TAB_NAME, OWNER_NAME, TABLESPACENO, PCTFRE, FILENO, BLOCKNO, NUMCOLS, OWNERNO, 
UNIQUENESS, OBJECTNO, LISTS, GROUPS, BITMAP)
as 
select o.name, t.name, u.name, i.ts#, i.pctfree$, i.file#, i.block#, i.cols, o.owner#,
i.unique$, i.obj#, s.lists, s.groups, i.spare8
from sys.ind$ i, sys.obj$ t, sys.obj$ o, sys.user$ u, sys.seg$ s
where i.obj# = o.obj#
and i.bo# = t.obj#
and o.owner# = u.user#
and i.file# = s.file#
and i.block# = s.block#
 and (o.owner# = userenv('schemaid')
       or i.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
	    )
       or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK   ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
      )
/
drop public synonym LOADER_IND_INFO
/
create public synonym LOADER_IND_INFO for LOADER_IND_INFO
/
grant select on LOADER_IND_INFO to PUBLIC
/
create or replace view LOADER_INDCOL_INFO
(INDEX_NAME, INDEX_OWNER, POSITION, SEGCOL)
as 
select idx.name, io.name, ic.pos#, ic.segcol#
from sys.user$ io, sys.obj$ idx, sys.icol$ ic
where idx.obj# = ic.obj#
and  idx.owner# = io.user# 
and (idx.owner# = userenv('schemaid')
       or ic.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
	    )
       or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK   ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
    )
/
drop public synonym LOADER_INDCOL_INFO
/
create public synonym LOADER_INDCOL_INFO for LOADER_INDCOL_INFO
/
grant select on LOADER_INDCOL_INFO to PUBLIC
/
create or replace view LOADER_PARAM_INFO
(BLOCKSZ, SERIALIZABLE)
as 
select v1.value, v2.value from v$parameter v1, v$parameter v2
where v1.name = 'db_block_size' and  v2.name = 'serializable'
/
drop public synonym LOADER_PARAM_INFO
/
create public synonym LOADER_PARAM_INFO for LOADER_PARAM_INFO
/
grant select on LOADER_PARAM_INFO to PUBLIC
/
remark
remark VIEWS FOR FIXED TABLES OF STATISTICS
remark
remark CONTROL BLOCK STATS 
remark
create or replace view v_$loadcstat as select * from v$loadcstat;
drop public synonym v$loadcstat;
create public synonym v$loadcstat for v_$loadcstat;
grant select on v_$loadcstat to public;
remark
remark TABLE STATS 
remark
create or replace view v_$loadtstat as select * from v$loadtstat;
drop public synonym v$loadtstat;
create public synonym v$loadtstat for v_$loadtstat;
grant select on v_$loadtstat to public;
remark
remark VIEWS FOR V7
create or replace view LOADER_CONSTRAINT_INFO
(OWNER, CONSTRAINT_NAME, CONSTRAINT_NUMBER, TYPE, TABLE_NAME, ENABLED, 
 NOTNULL, NUMCOLS)
as
   select u.name, con.name, cd.con#, cd.type,
   o.name, cd.enabled, col.null$, cd.cols
   from sys.con$ con, sys.user$ u, sys.cdef$ cd, sys.obj$ o,
   sys.ccol$ cco, sys.col$ col
   where con.owner# = u.user#
   and con.con# = cd.con#
   and cd.obj# = o.obj#
   and cco.con# = con.con#
   and col.obj# = cco.obj#
   and col.col# = cco.col#
   and (con.owner# = userenv('schemaid')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
	    )
       or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK   ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
      )
/
drop public synonym LOADER_CONSTRAINT_INFO
/
create public synonym LOADER_CONSTRAINT_INFO for LOADER_CONSTRAINT_INFO
/
grant select on LOADER_CONSTRAINT_INFO to PUBLIC
/
create or replace view LOADER_TRIGGER_INFO
(OWNER, TRIGGER_NAME, TABLE_NAME, ENABLED)
as
   select u.name, o1.name, o.name, t.enabled
   from sys.obj$ o, sys.obj$ o1, sys.user$ u, sys.trigger$ t
   where t.baseobject = o.obj#
   and o.owner# = u.user#
   and t.obj# = o1.obj#
 and (o.owner# = userenv('schemaid')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
	    )
       or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK   ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
     )
/
drop public synonym LOADER_TRIGGER_INFO
/
create public synonym LOADER_TRIGGER_INFO for LOADER_TRIGGER_INFO
/
grant select on LOADER_TRIGGER_INFO to PUBLIC
/
remark
remark VIEWS for Parallel Data Loader
remark
drop view LOADER_FILE_TS
/
create view LOADER_FILE_TS
(TABLESPACENO, FILENAME, FILENO)
as
   select file$.ts#, v$dbfile.name, file$.file# 
   from file$, v$dbfile
   where file$.file# = v$dbfile.file#
/
drop public synonym LOADER_FILE_TS
/
create public synonym LOADER_FILE_TS for LOADER_FILE_TS
/
grant select on LOADER_FILE_TS to public
/
