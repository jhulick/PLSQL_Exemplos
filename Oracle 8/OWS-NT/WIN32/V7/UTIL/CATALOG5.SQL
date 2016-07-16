rem 
rem $Header: catalog5.sql,v 1.12 1994/01/26 16:16:24 wmaimone Exp $ catalog5.sql 
rem 
Rem Copyright (c) 1988 by Oracle Corporation
Rem NAME
Rem   CATALOG5.SQL
Rem FUNCTION
Rem   Create V5 catalog views.
Rem NOTES
Rem
Rem   This script must be run while connected to SYS.
Rem
Rem MODIFIED
Rem     wmaimone   12/17/93 -  merge changes from branch 1.11.710.1
Rem     wmaimone   10/08/93 -  #(176646) change type in tabauth$,colauth$ view
Rem     dleary     11/12/92 -  add OER(2024) not exists error 
Rem     mmoore     11/05/92 -  update tabauth$ 
Rem     mmoore     06/02/92 - #(96526) remove v$enabledroles 
Rem     rlim       07/31/91 - added remarks column to syscatalog view 
Rem     rlim       07/30/91 - added remarks column to syscatalog_ & catalog
Rem     mmoore     05/24/91 - fix security views (upgrade for v7 dict)
Rem     rlim       04/29/91 - change char to varchar2 
Rem   Chaudhr    06/04/90 - assorted bug fixes
Rem                       - 28120: Add REMARKS & fix WIDTH col's in SYSCOLUMNS_
Rem                       - 28121: In SYSTABAUTH & SYSUSERAUTH put ' ' for 'N'
Rem   Chaudhr    01/29/90 - bug 29307
Rem   Mendels    03/28/89 - bug 19583: sysindexes_ returns wrong value for seq
Rem   Mendels    11/14/88 - fix bug 16011; create public synonyms
Rem   Mendels    10/25/88 - fix not exists errors
Rem   Bulchan    09/21/88 - Remove '#', ensure statements are < 2048 chars.
Rem   Mendels    09/21/88 - remove public from system synonyms
Rem   Mendels    09/12/88 - remove connect
Rem   Mendels    09/08/88 - bug 15135
Rem   Mendels    08/30/88 - fix bug 14772 (tab view returns indexes)
Rem                         fix bug 9981 (decode type 69 as rowid)
Rem   Peeler     07/26/88 - address compatibility issues
Rem   Wijaya     07/22/88 - merge catsystem.sql
Rem   Wijaya     06/21/88 - add clusters view
Rem   Wijaya     04/27/88 - remove REMARKS and any references to comment$
Rem                         comments are now stored in com$
Rem   Mendels    03/25/88 - do not return dropped tablespaces (and their files)
Rem                         or dropped rollback segments
Rem   Mendels    03/22/88 - Fix audit_actions for v6; 
Rem                         move sequence and constraint views to catalog.sql
Rem   Harmon     03/22/88 - add sequence views
rem Chris   22-mar-88 added sequence catalogs
rem Mendels 15-Mar-88  Rename to catalog5.sql
rem Hong    Revised 02-Mar-88  new undo status
rem Wijaya  Revised 16-Feb-88  new dictionary table icol$
rem Hong    Revised 01-Feb-88  Fix sysfiles to use actual file names and
rem                            not to display invalid file entries
rem Wijaya  Revised 20-Jan-88  Add views for constraints
rem Wijaya  Revised 04-Dec-87  Add REMARKS column to view TAB
rem Wijaya  Revised 20-Nov-87  Add views and synonyms for fixed tables
rem Mendels Revised 05-Nov-87  Make sysfiles an outer-join.
rem Wijaya  Revised 13-Oct-87  undo the fix below, because the bug is in cri.c
rem Hong    Revised 13-Oct-87  fix sysindexes to consider cluster indexes with
rem			       no entries in col$
rem Wijaya  Revised 12-Oct-87  add VARCHAR consideration
rem Hong    Revised 27-Aug-87  pctfree/pctused moved to tab$, clu$
rem Hong    Revised 09-Aug-87  decode column types in 'col'
rem Hong    Revised 05-Aug-87  add view 'freespace'
rem Hong    Revised 27-Jul-87  modify view 'tabspaces' to consider users with
rem			       resource priv has access to ALL tablespaces
rem Hong    Revised 16-Jun-87  create views with names ended in underscore
rem			       (e.g. syscatalog_). These views return user id
rem			       and make views created using them more efficient
rem Hong    Revised 10-Jun-87  dictionary updates
rem Hong    Revised 15-Apr-87  audit$ moved from sys.obj$ to sys.tab$,sys.view$
rem Hong    Revised 04-Apr-87  Add sysfiles, modify systaballoc, storage,
rem			       (sys)extents, syscolumns, syscatalog,
rem			       (sys)indexes, (sys)tabspacesb
rem Hong    Revised 26-Mar-87  Rewrite for version 6 dict. 
rem			       Combine catalog.ora and newcat.ora
rem			       Remove spaces, partitions, progs, exptab, expvew
rem			       Add tablespaces, tsquotas, undoseg, database
rem Andy    Revised 24-Sept-86 Modify views synonyms, privatesyn, and publicsyn
rem			       to show synonyms for non-existent, local tables
rem Andy    Revised 17-Sept-86 Modify views synonyms, privatesyn, and 
rem			       publicsyn to show synonyms for remote tables
rem Derry   Revised 29-Jul-86  Create views for DBLINKS table, 5.2.
rem Andy    Revised 25-Oct-85  Make view partitions an outer join.
rem Andy    Revised 09-Oct-85  Replace sytemaudit, defaultaudit, and 
rem                            systabaudit with SYSTEM_AUDIT, DEFAULT_AUDIT,
rem                            and TABLE_AUDIT.  Added AUDIT_DBA, AUDIT_EXISTS,
rem                            AUDIT_CONNECT, AUDIT_ACCESS.
rem                            Deleted views syssessions and sysaudit_trail.
rem                            Made sessions a synonym for audit_connect.
rem Andy    Revised 15-Jul-85  Change ren$newname to new$name.
rem Derry   Revised 11-Jun-85  Add views CLUSTERS and CLUSTERCOLUMNS.
rem Andy    Revised 06-Jun-85  Add remarks columns to syscatalog, catalog,
rem                            syscolumns, columns, col.  
rem                            Add defaultval column to syscolumns, columns,
rem                            and col.
rem                            Add views and tables for auditing: defaultaudit,
rem                            systemaudit, systabaudit, audit_actions,
rem                            syssessions, sessions, sysaudit_trail, and
rem                            audit_trail.
rem Derry   Revised 24-May-85  Removed SESSIONS since SYS.SESSIONS no longer
rem			       exists (AUDIT_TRAIL views needed).
rem Andy    Revised 08-Feb-85  Qualify column references.
rem                            Rewrite views SYNONYMS, PUBSYN, and PRIVSYN
rem                            for correctness.
rem                            Rewrite views CATALOG, SYSCATALOG, VIEWS,
rem                            and SYSVIEWS for speed.
rem                            Move views back to SYSTEM from SYS.
rem                            Delete views IDX and COLIDX, since view INDEXES
rem                            provides similar information efficiently.
rem                            Rename PRIVSYN to PRIVATESYN and PUBSYN to
rem                            PUBLICSYN.
rem                            Add SET WORKSIZE 16
rem Andy    Revised 26-Nov-84  Convert queries to use EXISTS
rem Miner   Revised 13-Nov-84  Rewrite for new dictionary but it still
rem			       looks much the same to users
rem Dana    Revised 20-Jul-84  Rewrite for speed.  drop views before creating.
rem			       Added COLIDX,IDX,PRIVSYN,PUBSYN,SYNONYMS.
rem			       Renamed DEPENDENCIES to XREF.
rem Dana    Revised 03-Jun-84  update for new V4 dictionary info
rem Dana    Revised 23-May-84  fixed STORAGE not to return all users
rem Clare   Revised 10-May-84  added SYSUSERLIST to DTAB:
rem Clare   Revised 10-May-84  added SYSPROGS:
rem Dana    Revised 23-Apr-84  for V4
rem Weiss   Created 03-Feb-83
rem
rem 
rem
rem there may be no index on a table, therefore need outerjoin
rem there may be more than one indexes, therefore need to max(d.xxxxxx)
rem
create or replace view systaballoc_ 
	( creator, creatorid, tname, d_blks, d_exts, i_blks, 
			   i_exts ) as
  select
    u.name, o.owner#, o.name, d.blocks, d.extents, i.blocks, i.extents
  from sys.user$ u, sys.obj$ o, sys.tab$ t, sys.ind$ x, sys.seg$ d, sys.seg$ i
  where t.obj# = o.obj#
    and o.owner# = u.user#
    and t.file# = d.file# 
    and t.block# = d.block#
    and x.bo# (+) = t.obj#
    and x.file# = i.file# (+)
    and x.block# = i.block# (+)
/
create or replace view systaballoc 
	( creator, tname, d_blks, d_exts, i_blks, i_exts ) as
  select creator, tname, max(d_blks), max(d_exts), sum(i_blks), sum(i_exts)
  from systaballoc_
  group by creator, tname
/
create or replace view taballoc 
	( tname, d_blks, d_exts, i_blks, i_exts ) as
  select tname, max(d_blks), max(d_exts), sum(i_blks), sum(i_exts)
  from systaballoc_
  where  creatorid = uid
  group by tname
/   
grant select on taballoc to public with grant option;
rem
rem group all objects which occupies storage: tables, clusters, indexes
rem
create or replace view syssegobj 
	(obj#, file#, block#, type, pctfree$, pctused$) as
  select obj#, file#, block#, 'TABLE', pctfree$, pctused$ from sys.tab$
  union
  select obj#, file#, block#, 'CLUSTER', pctfree$, pctused$ from sys.clu$
  union 
  select obj#, file#, block#, 'INDEX', to_number(null), to_number(null)
         from sys.ind$
/
create or replace view sysstorage_ 
	(creator, creatorid, name, type, storage, extents) as
  select u.name, o.owner#, o.name, so.type, s.blocks, s.extents
  from  sys.user$ u, sys.seg$ s, sys.obj$ o, syssegobj so
  where u.user# = o.owner#
    and o.obj# = so.obj#
    and s.file# = so.file#
    and s.block# = so.block# 
/
create or replace view sysstorage 
	(creator, name, type, storage, extents) as
  select creator, name, type, sum(storage), sum(extents)
  from sysstorage_
  group by creator, name, type
/
create or replace view freespace 
	(tablespace, fileno, starting, length) as
  select ts.name, f.file#, f.block#, f.length
  from sys.ts$ ts, sys.fet$ f
  where f.ts# = ts.ts#
/
create or replace view storage
	(name, type, storage, extents) as
  select name, type, sum(storage), sum(extents)
  from  sysstorage_
  where creatorid = uid
  group by name, type
/ 
grant select on storage to public with grant option;
create or replace view sysextents_ 
	(creator, creatorid, name, type,  storage, starting, 
			 ending) as
  select u.name, o.owner#, o.name, so.type, e.length, e.block#, 
	 e.block#+e.length-1
  from sys.uet$ e, sys.seg$ s, sys.user$ u, sys.obj$ o, syssegobj so
  where e.segfile# = s.file#
    and e.segblock# = s.block#
    and s.user# = u.user#
    and e.segfile# = so.file#
    and e.segblock# = so.block#
    and so.obj# = o.obj#
/
create or replace view sysextents
	(creator, name, which, storage, starting, ending) as
  select creator, name, type, storage, starting, ending
  from sysextents_
/
create or replace view extents
	(name, which, storage, starting, ending) as
  select name, type, storage, starting, ending
  from sysextents_
  where creatorid = uid
/
grant select on extents to public with grant option;
create or replace view syscolumns_ 
	(cname, tname, creator, creatorid, colno, coltype,
			width, scale, precision, nulls, defaultval, remarks) as
  select  c.name, t.name, u.name, t.owner#, c.col#, 
	  decode(c.type#, 1, 'CHAR', 2, 'NUMBER', 8, 'LONG', 9, 'VARCHAR',
                          12, 'DATE', 23, 'RAW', 24, 'LONG RAW',
                          69, 'ROWID', 'UNDEFINED'),
	  decode(c.type#, 2, c.precision, c.length),
	  c.scale, c.precision,
          decode(c.null$, 0, 'NULL', 'NOT NULL'), c.default$, co.comment$
  from	sys.user$ u, sys.col$ c, sys.obj$ t, sys.com$ co
  where t.type in (2, 4)
    and t.obj# = c.obj#
    and c.obj# = co.obj# (+)
    and c.col# = co.col# (+)
    and	u.user# = t.owner#
    and ( t.owner# = uid
       or t.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               ) 
            )
      )
/
create or replace view syscolumns 
	(cname, tname, creator, colno, coltype,
			width, scale, precision, nulls, defaultval, remarks) as
  select cname, tname, creator, colno, coltype, width, scale, precision,
         nulls, defaultval, remarks
  from  syscolumns_
/
grant select on syscolumns to public with grant option;
create or replace view columns 
	(cname, tname, creator, colno, coltype,
		     width, scale, precision, nulls, defaultval, remarks) as
  select cname, tname, creator, colno, coltype, width, scale, precision,
         nulls, defaultval, remarks
  from  syscolumns_
  where creatorid not in (0,1)
/
grant select on columns to public with grant option;
create or replace view syscatalog_ 
	(tname, creator, creatorid, tabletype, remarks)
  as  select o.name, u.name, o.owner#,
         decode(o.type, 2, 'TABLE', 4, 'VIEW', 6, 'SEQUENCE','?'), c.comment$
  from	sys.user$ u, sys.obj$ o, sys.com$ c
  where u.user# = o.owner#
    and	o.type in (2, 4, 6)
    and o.obj# = c.obj#(+)
    and ( o.owner# = uid
          or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               ) 
            )
        )
/
create or replace view syscatalog 
	(tname, creator, tabletype, remarks) as
  select tname, creator, tabletype, remarks
  from syscatalog_
/
grant select on syscatalog to public with grant option;
rem
rem The catalog view returns almost all tables accessible to the user
rem except tables in SYS and SYSTEM ("dictionary tables").
rem 
create or replace view catalog 
	(tname, creator, tabletype, remarks) as
  select tname, creator, tabletype, remarks
  from	syscatalog_
  where creatorid not in (0,2)
/
grant select on catalog to public with grant option;
create or replace view sysindexes_ 
	(iname, icreator, icreatorid, tname, ttype, creator, 
			creatorid, colnames, indextype, compression, seq)  as
  select  oi.name, ui.name, oi.owner#, ot.name, 
	  decode(ot.type, 2, 'TABLE', 3, 'CLUSTER', 'UNDEFINED'),
	  ut.name, ot.owner#, c.name,
	  decode(i.unique$, 1, 'UNIQUE', 'NON UNIQUE'), 
	  decode(i.compress$, 1, 'COMPRESS', 'NOCOMPRESS'), ic.pos#
  from sys.user$ ui, sys.user$ ut, sys.ind$ i, sys.obj$ oi, sys.obj$ ot,
       sys.icol$ ic, sys.col$ c
  where i.obj# = oi.obj#
    and i.bo# = ot.obj#
    and i.obj# = ic.obj#
    and ic.col# = c.col#
    and c.obj# = i.bo#
    and	oi.owner# = ui.user#
    and	ot.owner# = ut.user#
    and ot.type in (2, 3)
    and (ot.owner# = uid
         or oi.owner# = uid or
         ot.obj# in ( select obj#
                      from sys.objauth$
                      where grantee# in ( select kzsrorol
                                          from x$kzsro
                                        )
                     )
        )
/
create or replace view sysindexes 
	(iname, icreator, tname, ttype, creator, colnames,
		     indextype, compression, seq) as
  select iname, icreator, tname, ttype, creator, colnames, 
	 indextype, compression, seq
  from  sysindexes_
/
grant select on sysindexes to public with grant option;
create or replace view indexes 
	(iname, icreator, tname, ttype, creator, colnames,
		     indextype, compression, seq) as
  select iname, icreator, tname, ttype, creator, colnames, 
	 indextype, compression, seq
  from  sysindexes_
  where	icreatorid = uid
     or creatorid = uid
/
grant select on indexes to public with grant option;
create or replace view clusters 
	(clcreator, clname, tcreator, tname)
as select cu.name, c.name, tu.name, t.name
from sys.user$ tu, sys.user$ cu, sys.obj$ t, sys.obj$ c, sys.tab$ tab
where c.type = 3
  and t.type = 2
  and t.obj# = tab.obj#
  and tab.clu# = c.obj#
  and c.owner# = cu.user#
  and t.owner# = tu.user#
  and (t.owner# = uid
       or c.owner# = uid
       or c.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               ) 
            )
      )
/
grant select on clusters to public with grant option;
create or replace view clustercolumns 
	(clcreator, clname, clcol, tcreator, tname, tcol) as
  select cu.name, c.name, cc.name, tu.name, t.name, tc.name
  from   sys.col$ tc, sys.col$ cc, sys.user$ tu, sys.user$ cu,
         sys.obj$ t,  sys.obj$ c, sys.tab$ tab
  where c.type = 3 and t.type = 2
    and	t.obj# = tab.obj#  and tab.clu# = c.obj#
    and	c.obj# = cc.obj#   and t.obj# = tc.obj#
    and	cc.segcol# = tc.segcol#
    and c.owner# = cu.user# and t.owner# = tu.user#
    and (t.owner# = uid or c.owner# = uid
          or c.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               ) 
            )
        )
/
grant select on clustercolumns to public with grant option;

create or replace view views
	( viewname, viewtext) as
	select o.name, v.text
	from  sys.view$ v, sys.obj$ o
	where v.obj# = o.obj# and 
        (o.owner# = uid
          or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               ) 
            )
        )
/
grant select on views to public with grant option;
create or replace view sysviews 
	(viewname, vcreator) as
  select tname, creator
  from  syscatalog
  where tabletype = 'VIEW'
/
grant select on sysviews to public with grant option;
rem
rem Create the security views which emulate the v5 and v6 security tables.
rem 
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
create or replace view colauth$ 
	(obj#, grantor#, grantee#, time, name, 
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
create or replace view systabauth 
	(grantor, grantee, creator, tname, timestamp,
		        alt, del, ndx, ins, sel, upd, ref) as
  select ur.name, ue.name, u.name, o.name, tau.time, 
         decode(tau.alter$,  0, ' ', 2, 'Y', 'G'), 
         decode(tau.delete$, 0, ' ', 2, 'Y', 'G'), 
         decode(tau.index$,  0, ' ', 2, 'Y', 'G'), 
         decode(tau.insert$, 0, ' ', 2, 'Y', 'G'), 
         decode(tau.select$, 0, ' ', 2, 'Y', 'G'), 
         decode(tau.update$, 0, ' ', 1, 'R',  2, 'Y', 'G'),
         decode(tau.references$, 0, ' ', 1, 'R',  2, 'Y', 'G')
  from sys.tabauth$ tau, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue
  where tau.obj# = o.obj#
    and o.owner# = u.user#
    and tau.grantor# = ur.user#
    and tau.grantee# = ue.user#
    and (tau.grantor# = uid or tau.grantee# in (select kzsrorol
                                                from x$kzsro))
  union
  select u.name, u.name , u.name, o.name, to_date(null),
         'G','G','G','G','G','G','G'
  from user$ u, obj$ o
  where u.user# = uid and o.owner# = uid
/
grant select on systabauth to public with grant option;
create or replace view syscolauth 
	(grantor, grantee, creator, tname, timestamp, 
		        colname, upd, ref) as
  select ur.name, ue.name, u.name, o.name, c.time, c.name, 
	 decode(c.update$, 2, 'Y', 'G'), decode(c.references$, 2, 'Y', 'G')
  from  sys.colauth$ c, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue
  where c.obj# = o.obj#
    and o.owner# = u.user#
    and c.grantor# = ur.user#
    and c.grantee# = ue.user#
    and (c.grantor# = uid or c.grantee# in (select kzsrorol
                                            from x$kzsro))
/
grant select on syscolauth to public with grant option;
create or replace view sysuserauth 
	(userid, username, password, timestamp, connectauth, 
		         dbaauth, resourceauth, tablespace, tempspace) as 
  select u.user#, u.name, u.password, u.ctime, null, null, null,
	 ts.name, tmp.name
  from  sys.user$ u, sys.ts$ ts, sys.ts$ tmp
  where u.datats# = ts.ts# 
    and u.tempts# = tmp.ts#
/
create or replace view sysuserlist 
	(userid, username, timestamp, connectauth, dbaauth, 
			 resourceauth, tablespace, tempspace) as
   select userid, username, timestamp, connectauth, dbaauth,  resourceauth, tablespace, tempspace
   from  sysuserauth
/
grant select on sysuserlist to public with grant option;
rem
rem    The first two unioned query-expressions in the SYNONY MS view
rem    could be combined into a single query-expression with the
rem    term "tab$owner in (1,uid)."  This was not done because the
rem    optimizer will not do or-optimization in the presence of
rem    outer joins; this forces the access path selector to perform
rem    a time-consuming, full-table scan of sys.tables s.
rem
create or replace view synonyms 
	(sname, syntype, creator, tname, database, tabtype) as
  select s.name, 
	 decode (s.owner#,1,'PUBLIC','PRIVATE'), t.owner, t.name, 'LOCAL', 
	 decode(ot.type, 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER', 4, 'VIEW',
			 5, 'SYNONYM', 6, 'SEQUENCE', 'UNDEFINED')
  from  sys.obj$ s, sys.obj$ ot, sys.syn$ t, sys.user$ u
  where s.obj# = t.obj#
    and s.type = 5
    and ot.name = t.name
    and t.owner = u.name
    and ot.owner# = u.user#
    and s.owner# in (1,uid)
    and t.node is null
union
  select s.name, decode(s.owner#, 1, 'PUBLIC', 'PRIVATE'),
	 t.owner, t.name, t.node, 'REMOTE'
  from  sys.obj$ s, sys.syn$ t
  where s.obj# = t.obj#
    and s.type = 5
    and s.owner# in (1, uid)
    and t.node is not null
/  
grant select on synonyms to public with grant option;
create or replace view publicsyn 
	(sname, creator, tname, database, tabtype) as
  select sname, creator, tname, database, tabtype
  from  synonyms
  where syntype = 'PUBLIC'
/
grant select on publicsyn to public with grant option;
create or replace view privatesyn 
	(sname, creator, tname, database, tabtype) as
  select sname, creator, tname, database, tabtype
  from  synonyms
  where syntype = 'PRIVATE'
/
grant select on privatesyn to public with grant option;
create or replace view tab 
	(tname, tabtype, clusterid) as
   select o.name,
      decode(o.type, 2, 'TABLE', 3, 'CLUSTER', 
             4, 'VIEW', 5, 'SYNONYM'), t.tab#
  from  sys.tab$ t, sys.obj$ o
   where o.owner# = uid and o.type >= 2 and o.type <=5
     and o.obj# = t.obj# (+)
/
grant select on tab to public with grant option;
create or replace view col 
	(tname, colno, cname, coltype, width, scale, precision, nulls,
                 defaultval, remarks) as
  select t.name, c.col#, c.name, 
	 decode(c.type#, 1, 'CHAR', 2, 'NUMBER', 8, 'LONG', 9, 'VARCHAR',
                         12, 'DATE', 23, 'RAW', 24, 'LONG RAW',
                         69, 'ROWID', 'UNDEFINED'),
         decode(c.type#, 2, c.precision, c.length),
	 c.scale, c.precision,
	 decode(c.null$, 0, 'NULL', 'NOT NULL'), c.default$, co.comment$
   from  sys.col$ c, sys.obj$ t, sys.com$ co
   where t.obj# = c.obj#
   and   c.obj# = co.obj# (+)
   and   c.col# = co.col# (+)
   and	 t.type in (2, 3, 4)
   and	 t.owner# = uid
/
grant select on col to public with grant option;
create or replace view tabquotas 
	(tname, type, objno, nextext, maxext, pinc,
		       pfree, pused) as
  select t.name, so.type, t.obj#, s.extsize, s.maxexts, s.extpct, so.pctfree$,
	 so.pctused$
  from  sys.seg$ s, sys.obj$ t, syssegobj so
  where t.owner# = uid
    and t.obj# = so.obj#
    and so.file# = s.file# 
    and so.block# = s.block#
/
grant select on tabquotas to public with grant option;
rem   
rem SYSTEM_AUDIT gives one row with the system auditing options.
rem The table is only accessible to dba's.
rem
create or replace view SYSTEM_AUDIT 
	(connect$,dba$,not_exists$,resource$) as
select substr(t.audit$,1,1) || '/' || substr(t.audit$,2,1),
       substr(t.audit$,3,1) || '/' || substr(t.audit$,4,1),
       substr(t.audit$,5,1) || '/' || substr(t.audit$,6,1),
       substr(t.audit$,7,1) || '/' || substr(t.audit$,8,1)
from    sys.obj$ o, sys.tab$ t
where o.owner# = 0 
  and o.name = '_system_auditing_options_'
  and o.obj# = t.obj#
/
rem
rem DEFAULT_AUDIT gives one row with the default table auditing options.
rem The table is accessible to public.
rem
create or replace view DEFAULT_AUDIT 
	(alt,aud,com,del,gra,ind,ins,loc,ren,sel,upd) as
select
    substr(audit$,1,1) || '/' || substr(audit$,2,1),
    substr(audit$,3,1) || '/' || substr(audit$,4,1),
    substr(audit$,5,1) || '/' || substr(audit$,6,1),
    substr(audit$,7,1) || '/' || substr(audit$,7,1),
    substr(audit$,9,1) || '/' || substr(audit$,10,1),
    substr(audit$,11,1) || '/' || substr(audit$,12,1),
    substr(audit$,13,1) || '/' || substr(audit$,14,1),
    substr(audit$,15,1) || '/' || substr(audit$,16,1),
    substr(audit$,17,1) || '/' || substr(audit$,18,1),
    substr(audit$,19,1) || '/' || substr(audit$,20,1),
    substr(audit$,21,1) || '/' || substr(audit$,22,1)
from  sys.obj$ o, sys.tab$ t
where o.owner# = 0 
  and o.name = '_default_auditing_options_'
  and t.obj# = o.obj#
/
grant select on DEFAULT_AUDIT to public with grant option;
rem
rem TABLE_AUDIT lists auditing options for the user's own tables
rem and views, or for all tables and views if a DBA.
rem
create or replace view TABLE_AUDIT 
  (creator, tname, tabletype, alt,aud,com,del,gra,ind,ins,loc,ren,sel,upd) as
  select u.name, o.name, 'TABLE',
   substr(t.audit$,1,1) || '/' || substr(t.audit$,2,1),
   substr(t.audit$,3,1) || '/' || substr(t.audit$,4,1),
   substr(t.audit$,5,1) || '/' || substr(t.audit$,6,1),
   substr(t.audit$,7,1) || '/' || substr(t.audit$,8,1),
   substr(t.audit$,9,1) || '/' || substr(t.audit$,10,1),
   substr(t.audit$,11,1) || '/' || substr(t.audit$,12,1),
   substr(t.audit$,13,1) || '/' || substr(t.audit$,14,1),
   substr(t.audit$,15,1) || '/' || substr(t.audit$,16,1),
   substr(t.audit$,17,1) || '/' || substr(t.audit$,18,1),
   substr(t.audit$,19,1) || '/' || substr(t.audit$,20,1),
   substr(t.audit$,21,1) || '/' || substr(t.audit$,22,1)
    from sys.obj$ o, sys.user$ u, sys.tab$ t
    where o.type = 2 and o.name != '_default_auditing_options_'
     and o.name != '_system_auditing_options_' and o.owner# = u.user#
     and o.obj# = t.obj# and (o.owner# = uid or exists 
                               (select null
                                from sys.v$enabledprivs
                                where priv_number = -47 /* SELECT ANY TABLE */)
                             )
  union
  select u.name, o.name, 'VIEW',
    substr(t.audit$,1,1) || '/' || substr(t.audit$,2,1),
    substr(t.audit$,3,1) || '/' || substr(t.audit$,4,1),
    substr(t.audit$,5,1) || '/' || substr(t.audit$,6,1),
    substr(t.audit$,7,1) || '/' || substr(t.audit$,8,1),
    substr(t.audit$,9,1) || '/' || substr(t.audit$,10,1),
    substr(t.audit$,11,1) || '/' || substr(t.audit$,12,1),
    substr(t.audit$,13,1) || '/' || substr(t.audit$,14,1),
    substr(t.audit$,15,1) || '/' || substr(t.audit$,16,1),
    substr(t.audit$,17,1) || '/' || substr(t.audit$,18,1),
    substr(t.audit$,19,1) || '/' || substr(t.audit$,20,1),
    substr(t.audit$,21,1) || '/' || substr(t.audit$,22,1)
    from sys.obj$ o, sys.user$ u, sys.view$ t
    where o.type = 4 and o.name != '_default_auditing_options_'
     and o.name != '_system_auditing_options_' 
     and o.owner# = u.user# and o.obj# = t.obj#
     and (o.owner# = uid or exists 
                             (select null
                              from sys.v$enabledprivs
                              where priv_number = -47 /* SELECT ANY TABLE */)
         )
/
grant select on TABLE_AUDIT to public with grant option;
rem
rem audit_actions maps an action number to the action name.
rem The table is accessible to public.
rem
drop table audit_actions;
create table audit_actions(
  action number not null, name varchar2(27) not null
);
grant select on audit_actions to public with grant option;
insert into audit_actions values (0, 'UNKNOWN');
insert into audit_actions values (1, 'CREATE TABLE');
insert into audit_actions values (2, 'INSERT');
insert into audit_actions values (3, 'SELECT');
insert into audit_actions values (4, 'CREATE CLUSTER');
insert into audit_actions values (5, 'ALTER CLUSTER');
insert into audit_actions values (6, 'UPDATE');
insert into audit_actions values (7, 'DELETE');
insert into audit_actions values (8, 'DROP CLUSTER');
insert into audit_actions values (9, 'CREATE INDEX');
insert into audit_actions values (10, 'DROP INDEX');
insert into audit_actions values (11, 'ALTER INDEX');
insert into audit_actions values (12, 'DROP TABLE');
insert into audit_actions values (13, 'CREATE SEQUENCE');
insert into audit_actions values (14, 'ALTER SEQUENCE');
insert into audit_actions values (15, 'ALTER TABLE');
insert into audit_actions values (16, 'DROP SEQUENCE');
insert into audit_actions values (17, 'GRANT OBJECT');
insert into audit_actions values (18, 'REVOKE OBJECT');
insert into audit_actions values (19, 'CREATE SYNONYM');
insert into audit_actions values (20, 'DROP SYNONYM');
insert into audit_actions values (21, 'CREATE VIEW');
insert into audit_actions values (22, 'DROP VIEW');
insert into audit_actions values (23, 'VALIDATE INDEX');
insert into audit_actions values (26, 'LOCK');
insert into audit_actions values (27, 'UNDEFINED');
insert into audit_actions values (28, 'RENAME');
insert into audit_actions values (29, 'COMMENT');
insert into audit_actions values (30, 'AUDIT OBJECT');
insert into audit_actions values (31, 'NOAUDIT OBJECT');
insert into audit_actions values (32, 'CREATE DATABASE LINK');
insert into audit_actions values (33, 'DROP DATABASE LINK');
insert into audit_actions values (34, 'CREATE DATABASE');
insert into audit_actions values (35, 'ALTER DATABASE');
insert into audit_actions values (36, 'CREATE ROLLBACK SEG');
insert into audit_actions values (37, 'ALTER ROLLBACK SEG');
insert into audit_actions values (38, 'DROP ROLLBACK SEG');
insert into audit_actions values (39, 'CREATE TABLESPACE');
insert into audit_actions values (40, 'ALTER TABLESPACE');
insert into audit_actions values (41, 'DROP TABLESPACE');
insert into audit_actions values (42, 'ALTER SESSION');
insert into audit_actions values (43, 'ALTER USER');
insert into audit_actions values (49, 'ALTER SYSTEM');
insert into audit_actions values (60, 'LOGON');
insert into audit_actions values (61, 'LOGOFF');
insert into audit_actions values (62, 'CLEANUP');
insert into audit_actions values (63, 'SESSION');
insert into audit_actions values (64, 'AUDIT SYSTEM');
insert into audit_actions values (65, 'NOAUDIT SYSTEM');
insert into audit_actions values (66, 'AUDIT DEFAULT');
insert into audit_actions values (67, 'NOAUDIT DEFAULT');
insert into audit_actions values (68, 'GRANT SYSTEM');
insert into audit_actions values (69, 'REVOKE SYSTEM');
insert into audit_actions values (70, 'CREATE PUBLIC SYNONYM');
insert into audit_actions values (71, 'DROP PUBLIC SYNONYM');
insert into audit_actions values (72, 'CREATE PUBLIC DATABASE LINK');
insert into audit_actions values (73, 'DROP PUBLIC DATABASE LINK');
insert into audit_actions values (80, 'USER COMMENT');
commit;
create unique index audact$uid on audit_actions(action,name) nocompress;

rem
rem    AUDIT_TRAIL:  Lists audit trail entries on the user's objects
rem                  or other pertinent entries.
rem                  DBA sees all.
rem
create or replace view audit_trail as 
  select userid, userhost, terminal, timestamp, obj$creator, obj$name,
         t.action action, act.name action_name, new$name,
         auth$privileges, auth$grantee, ses$actions,
         logoff$time, logoff$lread, logoff$pread, logoff$lwrite, logoff$dead,
         comment$text, sessionid, entryid, statement, returncode
  from sys.aud$ t, audit_actions act
  where t.action = act.action
    and (t.obj$creator = user 
         or (t.obj$creator is null and t.userid = user)
         or exists (select null
                    from sys.v$enabledprivs
                    where priv_number = -47 /* SELECT ANY TABLE */)
         )
/
grant select on audit_trail to public with grant option;

rem
rem    AUDIT_DBA:  Lists audit trail entries produced by AUDIT DBA
rem                (all operations with an action code of 24, 25, or
rem                64 through 73).
rem                This view is accessible to DBAs only.
rem
create or replace view AUDIT_DBA as  
  select userid, userhost, terminal, timestamp,
         obj$creator, obj$name, t.action action, act.name action_name, 
         substr(auth$privileges,1,1) connect$,
         substr(auth$privileges,2,1) dba$,
         substr(auth$privileges,3,1) resource$,
         auth$grantee, new$name,
         sessionid, entryid, statement, returncode
   from  sys.aud$ t, audit_actions act
   where t.action = act.action
     and (t.action between 24 and 25
          or t.action between 64 and 73)
/
rem
rem    AUDIT_EXISTS:  Lists audit trail entries produced by AUDIT NOT EXISTS.
rem                   This is all audit trail entries with return codes of 942,
rem                   943, 959, 1418, 1432, 1434, 1435, 2019, 2024 and 2289.
rem                   This view is accessible to DBAs only.
rem
create or replace view AUDIT_EXISTS as
  select userid, userhost, terminal, timestamp,
         obj$creator, obj$name, t.action action, act.name action_name, 
         auth$privileges, auth$grantee, new$name,
         sessionid, entryid, statement, returncode
  from sys.aud$ t, audit_actions act
  where t.action = act.action
    and returncode in (942, 943, 959, 1418, 1432, 1434, 1435, 2019, 2024, 2289)
/
rem
rem  AUDIT_CONNECT: Lists the audit trail entries produced by AUDIT CONNECT.
rem                 DBA's see all entries, while ordinary users only
rem                 see entries for their own logins/logoffs.
rem
create or replace view AUDIT_CONNECT as
  select userid, userhost, terminal, 
         decode(action, 60, 'LOGON', 61, 'LOGOFF', 62, 'CLEANUP') action_name,
         timestamp, logoff$time,
         logoff$lread, logoff$pread, logoff$lwrite, logoff$dead,
         sessionid, returncode
  from sys.aud$
  where action between 60 and 62
    and (userid = user 
         or exists (select null
                    from sys.v$enabledprivs
                    where priv_number = -47 /* SELECT ANY TABLE */)
         )
/
grant select on AUDIT_CONNECT to public with grant option;
rem
rem  SESSIONS:  same as AUDIT_CONNECT but with different column names
rem             for backward compatiblity.
rem
create or replace view SESSIONS 
  (userid, userhost, terminal, status, logon, logoff, 
		      logread, physread, logwrite, deadlocks, sessionid, 
		      cleanup_error) as
  select userid, userhost, terminal, 
         decode(action, 60, 'LOGON', 61, 'LOGOFF', 62, 'CLEANUP'),
         timestamp, logoff$time,
         logoff$lread, logoff$pread, logoff$lwrite, logoff$dead,
         sessionid, returncode
  from sys.aud$
  where action between 60 and 62
    and (userid = user 
         or exists (select null
                    from sys.v$enabledprivs
                    where priv_number = -47 /* SELECT ANY TABLE */)
         )
/
grant select on SESSIONS to public with grant option;
rem
rem     AUDIT_ACCESS: Lists audit trail entries produced by 
rem                   AUDIT <options> ON <table_name> ... 
rem                   DBA's see all entries, while ordinary users only
rem                   see entries for their own tables.
rem
create or replace view AUDIT_ACCESS as
 select userid, userhost, terminal, timestamp,
	obj$creator, obj$name, t.action action, act.name action_name, 
	new$name, auth$privileges, auth$grantee,
	substr(ses$actions,1,1) alt,
	substr(ses$actions,2,1) aud,
	substr(ses$actions,3,1) com,
	substr(ses$actions,4,1) del,
	substr(ses$actions,5,1) gra,
	substr(ses$actions,6,1) ind,
	substr(ses$actions,7,1) ins,
	substr(ses$actions,8,1) loc,
	substr(ses$actions,9,1) ren,
	substr(ses$actions,10,1) sel,
	substr(ses$actions,11,1) upd,
	sessionid, entryid, statement, returncode
 from sys.aud$ t, audit_actions act
 where  t.action = act.action  
   and t.action <= 63
   and not (t.action in (1,4,5,8,11,12,13,14,19,20,21,22,24,25,60,61,62))
   and (t.obj$creator = user 
         or exists (select null
                    from sys.v$enabledprivs
                    where priv_number = -47 /* SELECT ANY TABLE */)
         )
/ 
grant select on AUDIT_ACCESS to public with grant option;
create or replace view dblinks 
	(name, type, host, userid) as
  select name, decode(owner#, 1, 'PUBLIC', 'PRIVATE'), host, userid
  from  sys.link$
  where owner# in (1,uid)
/
grant select on dblinks to public with grant option;
create or replace view sysdblinks 
	(owner, name, host, userid) as
  select u.name, l.name, l.host, l.userid
  from  sys.user$ u, sys.link$ l
  where u.user# = l.owner#
/
create or replace view systabspaces 
	(tsname,  status, blocksize, dflminext,
			  dflmaxext, dflinitial, dflnext, dflpctinc) as
  select ts.name, decode(ts.online$, 1, 'ONLINE', 2, 'OFFLINE', 'UNDEFINED'), 
	 ts.blocksize, ts.dflminext,
	 ts.dflmaxext, ts.dflinit, ts.dflincr, ts.dflextpct
  from  sys.ts$ ts
  where ts.online$ != 3
/
create or replace view tabspaces 
	(tsname, status, blocksize, dflminext,
		       dflmaxext, dflinitial, dflnext, dflpctinc) as
  select ts.name, decode(ts.online$, 1, 'ONLINE', 2, 'OFFLINE', 'UNDEFINED'), 
	 ts.blocksize, ts.dflminext,
	 ts.dflmaxext, ts.dflinit, ts.dflincr, ts.dflextpct
  from  sys.ts$ ts
  where ts.online$ != 3 and ts.ts# in 
          (select ts# from sys.tsq$ 
           where  user# in (uid, 1))
/
grant select on tabspaces to public with grant option;
create or replace view sysfiles 
	(tsname, fname, blocks) as
  select ts.name, dbf.name, f.blocks
  from  sys.ts$ ts, sys.file$ f, sys.v$dbfile dbf
  where ts.ts# = f.ts#(+) and dbf.file# = f.file# and f.status$ = 2
/
create or replace view systsquotas_ 
	(tsname, username, userid, blocks, maxblocks) as
  select ts.name, u.name, tsq.user#, tsq.blocks, tsq.maxblocks
  from  sys.user$ u, sys.tsq$ tsq, sys.ts$ ts
  where u.user# = tsq.user#
    and tsq.ts# = ts.ts#
/
create or replace view systsquotas 
	(username, tsname, blocks, maxblocks) as
  select username, tsname, blocks, maxblocks
  from  systsquotas_
/
create or replace view tsquotas 
	(tsname, blocks, maxblocks) as
  select tsname, blocks, maxblocks
  from  systsquotas_
  where userid = uid
/
grant select on tsquotas to public with grant option;
create or replace view sysrollbackseg 
	(segname, tbaspace, segstatus) as
  select u.name, ts.name, 
	 decode(u.status$, 2, 'AVAILABLE', 3, 'INUSE', 
   	        4, 'OFFLINE', 5, 'NEED RECOVERY', 'UNDEFINED')
  from  sys.undo$ u, sys.ts$ ts, sys.seg$ s
  where u.status$ != 1 and u.file# = s.file# and u.block# = s.block#
    and s.ts# = ts.ts#
/
drop table dtab;
create table dtab(tname varchar2(14),remarks varchar2(64));
insert into dtab values ('Reference Date',
  'ORACLE catalog as of 10-Oct-85, installed on '||
  to_char(sysdate,'dd-MON-yy hh24:mi:ss.'));
insert into dtab values ('AUDIT_ACCESS',
  'Audit entries for accesses to user''s tables/views (DBA sees all)');
insert into dtab values ('AUDIT_ACTIONS',
  'Maps auditing action numbers to action names');
insert into dtab values ('AUDIT_CONNECT',
  'Audit trail entries for user logon/logoff (DBA sees all users)');
insert into dtab values ('AUDIT_DBA',
   'Audit trail entries for DBA activities - for DBA use only');
insert into dtab values ('AUDIT_EXISTS',
   'Audit trail entries for objects which do NOT EXIST - DBA''s only');
insert into dtab values ('AUDIT_TRAIL',
   'Audit trail entries relevant to the user (DBA sees all)');
insert into dtab values ('CATALOG',
  'Tables and views accessible to user (excluding data dictionary)');
insert into dtab values ('CLUSTERS',
  'Clusters and their tables (either must be accessible to user)');
insert into dtab values ('CLUSTERCOLUMNS',
  'Maps cluster columns to clustered table columns');
insert into dtab values ('COL',
  'Specifications of columns in tables created by the user');
insert into dtab values ('COLUMNS',
  'Columns in tables accessible to user (excluding data dictionary)');
insert into dtab values ('DBLINKS',
  'Public and private links to external databases');
insert into dtab values ('DEFAULT_AUDIT',
   'Default table auditing options');
insert into dtab values ('DTAB',
  'Description of tables and views in Oracle Data Dictionary');
insert into dtab values ('EXTENTS',
  'Data structure of extents within tables');
insert into dtab values ('INDEXES',
  'Indexes created by user and indexes on tables created by user');
insert into dtab values ('FREESPACE',
  'Free extents available in the system - for DBA use only');
insert into dtab values ('PRIVATESYN',
  'Private synonyms created by the user');
insert into dtab values ('PUBLICSYN',
  'Public synonyms');
insert into dtab values ('SEQUENCES',
  'Sequences created by the user');
insert into dtab values ('SESSIONS',
  'Audit trail entries for the user''s sessions (DBA sees all)');
insert into dtab values ('STORAGE',
  'Data and Index storage allocation for user''s own tables');
insert into dtab values ('SYNONYMS',
  'Synonyms, private and public');
insert into dtab values ('SYSAUDIT_TRAIL',
  'Synonym for sys.audit_trail - for DBA use only');
insert into dtab values ('SYSCATALOG',
  'Profile of tables and views accessible to the user');
insert into dtab values ('SYSCOLAUTH',
  'Directory of column update access granted by or to the user');
insert into dtab values ('SYSCOLUMNS',
  'Specifications of columns in accessible tables and views');
insert into dtab values ('SYSDATABASE',
  'Parameters of databases');
insert into dtab values ('SYSDBLINKS',
  'All links to external databases - for DBA use only');
insert into dtab values ('SYSEXTENTS',
  'Data structure of tables throughout system - for DBA use only');
insert into dtab values ('SYSFILES',
  'Files allocation - for DBA use only');
insert into dtab values ('SYSINDEXES',
  'List of indexes, underlying columns, creator, and options');
insert into dtab values ('SYSCONSTRAINTS',
  'Constraint definitions');
insert into dtab values ('SYSCONSTRACOLS',
  'Columns of primary keys, unique keys, and foreign keys');
insert into dtab values ('SYSSEQUENCES',
  'List of accessible sequences');
insert into dtab values ('SYSSTORAGE',
  'Summary of all database storage - for DBA use only');
insert into dtab values ('SYSTABALLOC',
  'Data and index space allocations for all tables - for DBA''s');
insert into dtab values ('SYSTABAUTH',
  'Directory of access authorization granted by or to the user');
insert into dtab values('SYSTABSPACES',
  'Parameters of tablespaces - for DBA use only');
insert into dtab values ('SYSTSQUOTAS',
  'Space privileges granted to users - for DBA use only');
insert into dtab values ('SYSTEM_AUDIT',
  'System auditing options - for DBA use only');
insert into dtab values ('SYSROLLBACKSEG',
  'Rollback segments for tablespaces - for DBA use only');
insert into dtab values ('SYSUSERAUTH',
  'Master list of Oracle users - for DBA use only');
insert into dtab values ('SYSUSERLIST',
  'List of Oracle users' );
insert into dtab values ('SYSVIEWS',
  'List of accessible views' );
insert into dtab values ('TAB',
  'List of tables, views, clusters and synonyms created by the user');
insert into dtab values ('TABALLOC',
  'Data and index space allocations for all user''s tables');
insert into dtab values ('TABQUOTAS',
  'Table allocation (space) parameters for tables created by user');
insert into dtab values('TABSPACES',
  'Parameters of tablespaces accessible by current user');
insert into dtab values ('TABLE_AUDIT',
  'Auditing options of user''s tables and views (DBA sees all)');
insert into dtab values ('TSQUOTAS',
  'Space privileges granted to current user');
insert into dtab values ('VIEWS',
  'Defining SQL statements for views created by the user');
grant select on dtab to public with grant option;
create synonym system.taballoc for taballoc;
create public synonym taballoc for taballoc;
create synonym system.storage for storage;
create public synonym storage for storage;
create synonym system.extents for extents;
create public synonym extents for extents;
create synonym system.freespace for freespace;
create public synonym freespace for freespace;
create synonym system.syscolumns for syscolumns;
create public synonym syscolumns for syscolumns;
create synonym system.columns for columns;
create public synonym columns for columns;
create synonym system.syscatalog for syscatalog;
create public synonym syscatalog for syscatalog;
create synonym system.catalog for catalog;
create public synonym catalog for catalog;
create synonym system.sysindexes for sysindexes;
create public synonym sysindexes for sysindexes;
create synonym system.sysconstraints for sysconstraints;
create public synonym sysconstraints for sysconstraints;
create synonym system.sysconstracols for sysconstracols;
create public synonym sysconstracols for sysconstracols;
create synonym system.indexes for indexes;
create public synonym indexes for indexes;
create synonym system.views for views;
create public synonym views for views;
create synonym system.sysviews for sysviews;
create public synonym sysviews for sysviews;
create synonym system.sequences for sequences;
create public synonym sequences for sequences;
create synonym system.syssequences for syssequences;
create public synonym syssequences for syssequences;
create synonym system.systabauth for systabauth;
create public synonym systabauth for systabauth;
create synonym system.syscolauth for syscolauth;
create public synonym syscolauth for syscolauth;
create synonym system.sysuserlist for sysuserlist;
create public synonym sysuserlist for sysuserlist;
create synonym system.synonyms for synonyms;
create public synonym synonyms for synonyms;
create synonym system.publicsyn for publicsyn;
create public synonym publicsyn for publicsyn;
create synonym system.privatesyn for privatesyn;
create public synonym privatesyn for privatesyn;
create synonym system.tab for tab;
create public synonym tab for tab;
create synonym system.col for col;
create public synonym col for col;
create synonym system.tabquotas for tabquotas;
create public synonym tabquotas for tabquotas;
create synonym system.dtab for dtab;
create public synonym dtab for dtab;
create synonym system.sysfiles for sysfiles;
create public synonym sysfiles for sysfiles;
create synonym system.systaballoc for systaballoc;
create public synonym systaballoc for systaballoc;
create synonym system.sysstorage for sysstorage;
create public synonym sysstorage for sysstorage;
create synonym system.sysextents for sysextents;
create public synonym sysextents for sysextents;
create synonym system.sysuserauth for sysuserauth;
create public synonym sysuserauth for sysuserauth;
rem create public synonym sysdatabase for sysdatabase;
create synonym system.systabspaces for systabspaces;
create public synonym systabspaces for systabspaces;
create synonym system.tabspaces for tabspaces;
create public synonym tabspaces for tabspaces;
create synonym system.systsquotas for systsquotas;
create public synonym systsquotas for systsquotas;
create synonym system.tsquotas for tsquotas;
create public synonym tsquotas for tsquotas;
create synonym system.sysrollbackseg for sysrollbackseg;
create public synonym sysrollbackseg for sysrollbackseg;
create synonym system.system_audit for system_audit;
create public synonym system_audit for system_audit;
create synonym system.default_audit for default_audit;
create public synonym default_audit for default_audit;
create synonym system.table_audit for table_audit;
create public synonym table_audit for table_audit;
create synonym system.audit_actions for audit_actions;
create public synonym audit_actions for audit_actions;
create synonym system.audit_trail for audit_trail;
create public synonym audit_trail for audit_trail;
create synonym system.sysaudit_trail for sys.audit_trail;
create public synonym sysaudit_trail for sys.audit_trail;
create synonym system.audit_dba for audit_dba;
create public synonym audit_dba for audit_dba;
create synonym system.audit_exists for audit_exists;
create public synonym audit_exists for audit_exists;
create synonym system.audit_connect for audit_connect;
create public synonym audit_connect for audit_connect;
create synonym system.sessions for sessions;
create public synonym sessions for sessions;
create synonym system.audit_access for audit_access;
create public synonym audit_access for audit_access;
create synonym system.clusters for clusters;
create public synonym clusters for clusters;
create synonym system.clustercolumns for clustercolumns;
create public synonym clustercolumns for clustercolumns;
create synonym system.dblinks for dblinks;
create public synonym dblinks for dblinks;
create synonym system.sysdblinks for sysdblinks;
create public synonym sysdblinks for sysdblinks;
