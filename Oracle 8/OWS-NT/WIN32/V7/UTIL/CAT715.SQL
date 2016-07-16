rem 
rem $Header: cat715.sql,v 1.1 1993/05/14 09:02:45 WMAIMONE Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      cat715.sql - Migrate 7.0.14 to 7.0.15
Rem    DESCRIPTION
Rem      RIGHT AFTER A 7.0.14 DATABASE IS STARTED UP USING 7.0.15
Rem      FOR THE FIRST TIME, RUN THIS SCRIPT ONCE AS INTERNAL.
Rem      A 7.0.14 database is a database that has been created using
Rem      7.0.14 release or upgraded to use 7.0.14 release.
Rem    MODIFIED   (MM/DD/YY)
Rem     wmaimone   05/07/93 -  Creation for #161964.

Rem
Rem  Fix up ALL_* views to take system privileges into account.

create or replace view ALL_OBJECTS
    (OWNER, OBJECT_NAME, OBJECT_ID, OBJECT_TYPE,
     CREATED, LAST_DDL_TIME, TIMESTAMP, STATUS)
as
select u.name, o.name, o.obj#,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 
                      7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                      11, 'PACKAGE BODY', 12, 'TRIGGER', 'UNDEFINED'),
       o.ctime, o.mtime,
       to_char(o.stime, 'YYYY-MM-DD:HH24:MI:SS'),
       decode(o.status, 0, 'N/A', 1, 'VALID', 'INVALID')
from sys.obj$ o, sys.user$ u
where o.owner# = u.user#
  and o.linkname is null
  and o.type != 10
  and
  (
    o.owner# in (uid, 1 /* PUBLIC */)
    or
    (
      o.type != 11 /* EXECUTE priv does not let user see pkg body */
      and
      o.obj# in (select obj# from sys.objauth$
                 where grantee# in (select kzsrorol from x$kzsro)
                   and privilege# in (3 /* DELETE */,   6 /* INSERT */,
                                      7 /* LOCK */,     9 /* SELECT */,
                                      10 /* UPDATE */, 12 /* EXECUTE */))
    )
    or
    (
       o.type in (7, 8, 9) /* prc, fcn, pkg */
       and
       exists (select null from v$enabledprivs
	       where priv_number = -144 /* EXECUTE ANY PROCEDURE */)
    )
    or
    (
       o.type in (2, 4, 5) /* table, view, synonym */
       and
       exists (select null from v$enabledprivs
               where priv_number in (-45 /* LOCK ANY TABLE */,
				     -47 /* SELECT ANY TABLE */,
				     -48 /* INSERT ANY TABLE */,
				     -49 /* UPDATE ANY TABLE */,
				     -50 /* DELETE ANY TABLE */)
               )
    )
    or
    ( o.type = 6 /* sequence */
      and
      exists (select null from v$enabledprivs
              where priv_number = -109 /* SELECT ANY SEQUENCE */)
    )
  )
/
remark
remark  This view shows all tables, views, synonyms, and sequences owned by the
remark  user and those tables, views, synonyms, and sequences that PUBLIC
remark  has been granted access.
remark
create or replace view ALL_CATALOG
    (OWNER, TABLE_NAME,
     TABLE_TYPE)
as
select u.name, o.name,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 'UNDEFINED')
from sys.user$ u, sys.obj$ o
where o.owner# = u.user#
  and o.type in (2, 4, 5, 6)
  and o.linkname is null
  and (o.owner# in (uid, 1)   /* public objects */
       or
       obj# in ( select obj#  /* directly granted privileges */
                 from sys.objauth$
                 where grantee# in ( select kzsrorol
                                      from x$kzsro
                                    )
                )
       or
       (
	  o.type in (7, 8, 9) /* prc, fcn, pkg */
	  and
	  exists (select null from v$enabledprivs
		  where priv_number = -144 /* EXECUTE ANY PROCEDURE */)
        )
       or
       (
	  o.type in (2, 4, 5) /* table, view, synonym */
	  and
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */))
       )
       or
       ( o.type = 6 /* sequence */
	 and
	 exists (select null from v$enabledprivs
		 where priv_number = -109 /* SELECT ANY SEQUENCE */)))
/

create or replace view ALL_COL_COMMENTS
    (OWNER, TABLE_NAME, COLUMN_NAME, COMMENTS)
as
select u.name, o.name, c.name, co.comment$
from sys.obj$ o, sys.col$ c, sys.user$ u, sys.com$ co
where o.owner# = u.user#
  and o.type in (2, 4, 5)
  and o.obj# = c.obj#
  and c.obj# = co.obj#(+)
  and c.col# = co.col#(+)
  and (o.owner# = uid
       or o.obj# in
         (select obj#
          from sys.objauth$
          where grantee# in ( select kzsrorol
                              from x$kzsro
                            )
          )
       or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */))
      )
/
remark
remark  This view does not include cluster indexes on clusters
remark  containing tables which are accessible to the user.
remark
create or replace view ALL_INDEXES
    (OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME,
     TABLE_TYPE,
     UNIQUENESS,
     TABLESPACE_NAME, INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT, MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     PCT_FREE, BLEVEL, LEAF_BLOCKS, DISTINCT_KEYS, AVG_LEAF_BLOCKS_PER_KEY,
     AVG_DATA_BLOCKS_PER_KEY, CLUSTERING_FACTOR, STATUS)
 as 
select u.name, o.name, iu.name, io.name, 'TABLE',
       decode(i.unique$, 0, 'NONUNIQUE', 1, 'UNIQUE', 'UNDEFINED'), 
       ts.name, i.initrans, i.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, 
       s.minexts, s.maxexts, s.extpct, i.pctfree$,
       i.blevel, i.leafcnt, i.distkey, i.lblkkey, i.dblkkey, i.clufac,
       decode(i.compress$, 2, 'DIRECT LOAD', 'VALID')
from sys.ts$ ts, sys.seg$ s, sys.user$ iu, sys.obj$ io, 
     sys.user$ u, sys.ind$ i, sys.obj$ o
where u.user# = o.owner#
  and o.obj# = i.obj#
  and i.bo# = io.obj#
  and io.owner# = iu.user# 
  and io.type = 2 /* tables */
  and i.ts# = ts.ts# 
  and i.file# = s.file#
  and i.block# = s.block# 
  and (io.owner# = uid
        or
       io.obj# in ( select obj#
                    from objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
create or replace view ALL_IND_COLUMNS
    (INDEX_OWNER, INDEX_NAME,
     TABLE_OWNER, TABLE_NAME,
     COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH)
as
select io.name, idx.name, bo.name, base.name, 
       c.name, ic.pos#, c.length
from sys.col$ c, sys.obj$ idx, sys.obj$ base, sys.icol$ ic,
     sys.user$ io, sys.user$ bo
where base.obj# = c.obj#
  and ic.col# = c.col#
  and ic.bo# = base.obj#
  and io.user# = idx.owner#
  and bo.user# = base.owner#
  and ic.obj# = idx.obj#
  and (idx.owner# = uid or
       base.owner# = uid
       or
       base.obj# in ( select obj#
                     from sys.objauth$
                     where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                   )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
create or replace view ALL_SEQUENCES
  (SEQUENCE_OWNER, SEQUENCE_NAME, 
                  MIN_VALUE, MAX_VALUE, INCREMENT_BY,
                  CYCLE_FLAG, ORDER_FLAG, CACHE_SIZE, LAST_NUMBER)
as select u.name, o.name,
      s.minvalue, s.maxvalue, s.increment$, 
      decode (s.cycle, 0, 'N', 1, 'Y'),
      decode (s.order$, 0, 'N', 1, 'Y'),
      s.cache, s.highwater
from sys.seq$ s, sys.obj$ o, sys.user$ u
where u.user# = o.owner#
  and o.obj# = s.obj#
  and (o.owner# = uid
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or
	 exists (select null from v$enabledprivs
	         where priv_number = -109 /* SELECT ANY SEQUENCE */
                 )
      )
/
remark
remark  This view shows all synonyms owned by the user (private synonyms),
remark  plus all public synonyms.
remark
create or replace view ALL_SYNONYMS
    (OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME, DB_LINK)
as
select u.name, o.name, s.owner, s.name, s.node
from sys.user$ u, sys.syn$ s, sys.obj$ o
where o.obj# = s.obj#
  and o.type = 5
  and o.owner# = u.user#
  and (
       o.owner# in (UID, 1 /* PUBLIC */)  /* user's private, any public */
       or /* user has any privs on base object */
	exists
        (select null from sys.objauth$ ba, sys.obj$ bo, sys.user$ bu
         where bu.name = s.owner
           and bo.name = s.name
           and bu.user# = bo.owner#
           and ba.obj# = bo.obj#
           and ba.grantee# in (select kzsrorol from x$kzsro))
        or /* user has system privileges */
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
create or replace view ALL_TABLES
    (OWNER, TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME,
     PCT_FREE, PCT_USED,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
     AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN)
as
select u.name, o.name, ts.name, co.name,
       t.pctfree$, t.pctused$,
       t.initrans, t.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
       s.minexts, s.maxexts, s.extpct,
       decode(t.modified, 0, 'Y', 1, 'N', '?'),
       t.rowcnt, t.blkcnt, t.empcnt, t.avgspc, t.chncnt, t.avgrln    
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = t.obj#
  and t.clu# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
  and (o.owner# = uid
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               ) 
            )
       or /* user has system privileges */
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
      )
/
create or replace view ALL_TAB_COLUMNS
    (OWNER, TABLE_NAME,
     COLUMN_NAME, 
     DATA_TYPE,
     DATA_LENGTH, DATA_PRECISION, DATA_SCALE,
     NULLABLE, COLUMN_ID, DEFAULT_LENGTH, DATA_DEFAULT,
     NUM_DISTINCT, LOW_VALUE, HIGH_VALUE,DENSITY)
as
select u.name, o.name,
       c.name,
       decode(c.type#, 1, 'VARCHAR2',
                       2, decode(c.scale, null,
                                 decode(c.precision, null, 'NUMBER', 'FLOAT'),
                                 'NUMBER'),
                       8, 'LONG', 9, 'VARCHAR',
                       12, 'DATE', 23, 'RAW', 24, 'LONG RAW',
                       69, 'ROWID',96,'CHAR', 105, 'MLSLABEL',
                       106, 'MLSLABEL', 'UNDEFINED'),
       c.length, c.precision, c.scale,
       decode(sign(c.null$),-1,'D', 0, 'Y', 'N'), c.col#, c.deflength, 
	c.default$,
       c.distcnt, c.lowval, c.hival, c.spare2
from sys.col$ c, sys.obj$ o, sys.user$ u
where o.obj# = c.obj#
  and o.owner# = u.user#
  and o.type in (2, 3, 4)
  and (o.owner# = uid
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
	or /* user has system privileges */
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
       )
/
create or replace view ALL_TAB_COMMENTS
    (OWNER, TABLE_NAME,
     TABLE_TYPE,
     COMMENTS)
as
select u.name, o.name,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 'UNDEFINED'),
       c.comment$
from sys.obj$ o, sys.user$ u, sys.com$ c
where o.owner# = u.user#
  and o.obj# = c.obj#(+)
  and c.col#(+) is null
  and o.type in (2, 4)
  and (o.owner# = uid
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
	or /* user has system privileges */
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
       )
/
create or replace view ALL_VIEWS
    (OWNER, VIEW_NAME, TEXT_LENGTH, TEXT)
as
select u.name, o.name, v.textlength, v.text
from sys.obj$ o, sys.view$ v, sys.user$ u
where o.obj# = v.obj#
  and o.owner# = u.user#
  and (o.owner# = uid
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where oa.grantee# in ( select kzsrorol
                                         from x$kzsro
                                  )
            )
	or /* user has system privileges */
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
      )
/
create or replace view ALL_CONSTRAINTS 
    (OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE,
     TABLE_NAME, SEARCH_CONDITION, R_OWNER,
     R_CONSTRAINT_NAME, DELETE_RULE, STATUS)
as
select ou.name, oc.name,
       decode(c.type, 1, 'C', 2, 'P', 3, 'U',
              4, 'R', 5, 'V',7,'C', '?'),
       o.name, c.condition, ru.name, rc.name,
       decode(c.type, 4,
              decode(c.refact, 1, 'CASCADE', 'NO ACTION'), NULL),
       decode(c.type, 5, 'ENABLED',
              decode(c.enabled, NULL, 'DISABLED','ENABLED'))
from sys.con$ oc, sys.con$ rc, sys.user$ ou, sys.user$ ru,
     sys.obj$ o, sys.cdef$ c
where oc.owner# = ou.user#
  and oc.con# = c.con#
  and c.obj# = o.obj#
  and c.rcon# = rc.con#(+)
  and rc.owner# = ru.user#(+)
  and (o.owner# = uid
       or o.obj# in (select obj#
                     from sys.objauth$
                     where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                    )
	or /* user has system privileges */
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
      )
/
create or replace view ALL_CONS_COLUMNS 
    (OWNER, CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, POSITION)
as
select u.name, c.name, o.name, col.name, cc.pos#
from sys.user$ u, sys.con$ c, sys.col$ col, sys.ccol$ cc, sys.cdef$ cd,
     sys.obj$ o
where c.owner# = u.user#
  and c.con# = cd.con#
  and cd.con# = cc.con#
  and cc.obj# = col.obj#
  and cc.col# = col.col#
  and cc.obj# = o.obj#
  and (c.owner# = uid
       or cd.obj# in (select obj#
                      from sys.objauth$
                      where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                     )
	or /* user has system privileges */
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
      )
/
create or replace view syscatalog_ 
    (tname, creator, creatorid, tabletype, remarks)
  as
  select o.name, u.name, o.owner#,
         decode(o.type, 2, 'TABLE', 4, 'VIEW', 6, 'SEQUENCE','?'), c.comment$
  from	sys.user$ u, sys.obj$ o, sys.com$ c
  where u.user# = o.owner#
    and	o.type in (2, 4, 6)
    and o.linkname is null
    and o.obj# = c.obj#(+)
    and ( o.owner# = uid
	  or o.obj# in
	     (select oa.obj#
	      from   sys.objauth$ oa
	      where  oa.grantee# in (uid, 1)
	      )
	  or
	  (
	  o.type in (2, 4) /* table, view */
	  and
	  exists (select null from v$enabledprivs
		  where priv_number in (-45 /* LOCK ANY TABLE */,
					-47 /* SELECT ANY TABLE */,
					-48 /* INSERT ANY TABLE */,
					-49 /* UPDATE ANY TABLE */,
					-50 /* DELETE ANY TABLE */)
		  )
	   )
	  or
	 ( o.type = 6 /* sequence */
	   and
	   exists (select null from v$enabledprivs
		   where priv_number = -109 /* SELECT ANY SEQUENCE */)
	 )
       )
/
