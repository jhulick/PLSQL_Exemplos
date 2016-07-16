rem 
rem $Header: catexp6.sql,v 1.6 1994/07/08 11:10:28 jloaiza Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      catexp6.sql - CATalog EXPort views for v6 SQL script
Rem    DESCRIPTION
Rem      Creates V6.0-style export views against the V7 RDBMS so that EXP V6.0
Rem      can be used to read out the data in a V7 RDBMS
Rem    NOTES
Rem    MODIFIED   (MM/DD/YY)
Rem     jloaiza    07/08/94 -  bitand modified column
Rem     vraghuna   03/21/94 -  bug 190141 - change expvew6.sql header
Rem     vraghuna   08/26/93 -  bug 178457 - increase performance of exucol
Rem     mmoore     11/05/92 -  update tabauth$ 
Rem     vraghuna   11/04/92 -  add tabauth$ from catalog5.sql 
Rem     glumpkin   10/20/92 -  Renamed from EXPVEW6.SQL 
Rem     cheigham   06/25/92 -  redo exu7col, add exu7colnn for dict. changes 
Rem     cheigham   06/23/92 -  fix exucol to accommodate dictionary changes 
Rem     cheigham   03/06/92 -  fix to_date clauses to be language-independent 
Rem     cheigham   02/27/92 -  exclude objects which are in hash clusters 
Rem     cheigham   02/26/92 -  fix exutab query 
Rem     cheigham   02/24/92 -  exclude snapshot,snapshot log tables,views 
Rem     rkooi      01/30/92 -  add newline to end 
Rem     cheigham   01/03/92 -  add _system_audit_options_ table 
Rem     cheigham   01/02/92 -  truncate audit$ columns to 24 chars 
Rem     cheigham   11/20/91 -  fix db link name selection 
Rem     cheigham   10/01/91 -  fix exugrn 
Rem     cheigham   09/25/91 -  create index for privilege views 
Rem     cheigham   09/18/91 -  use distinct(), not group by's, in exudba,exures
Rem     agupta     09/04/91 -  initial revision of file 
Rem     agupta     08/28/91 -  Creation 

set echo on;

rem this index makes exu(res/dba/cnt) much faster
create index i_sysauth2 on sysauth$(privilege#,grantee#);

rem
rem  adding tabauth$ for exugrn
rem Create the security views which emulate the v5 and v6 security tables.
rem 
drop view tabauth$
/                                              
create view tabauth$ (obj#, grantor#, grantee#, time, sequence#, alter$, 
                      delete$,index$, insert$, select$, update$, references$) as
  select obj#, grantor#, grantee#, max(null), min(sequence#),
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
rem all tables 
rem   NOTE: we exclude tables created by snapshots,snapshot logs
rem   and tables in hash clusters since these aren't supported in v6.
drop view exutab;
CREATE VIEW exutab (objid,name, owner, ownerid, tablespace, fileno, blockno,
		    audit$, comment$, clusterflag, mtime, modified,
                    pctfree$, pctused$, initrans, maxtrans) AS
       SELECT o$.obj#,o$.name, u$.name, o$.owner#, ts$.name, t$.file#, 
	      t$.block#, substr(t$.audit$,1, 24), 
	      c$.comment$, NVL(t$.clu#, 0), o$.mtime,
	      bitand(t$.modified,1), t$.pctfree$, t$.pctused$, t$.initrans, 
	      t$.maxtrans
       FROM sys.tab$ t$, sys.obj$ o$, sys.ts$ ts$, sys.user$ u$, sys.com$ c$,
	    sys.clu$ cl$
       WHERE  t$.obj# = o$.obj# and t$.ts# = ts$.ts# and 
              u$.user# = o$.owner# and o$.obj# = c$.obj#(+) 
	      and c$.col#(+) is null
	      and o$.name NOT LIKE 'SNAP$_%'
	      and o$.name NOT LIKE 'MLOG$_%'
	      and t$.clu# = cl$.obj#(+)
	      and (t$.clu#  is null or cl$.hashkeys = 0)
/
rem tables for incremental export: modified, altered or new
drop view exutabi;
CREATE VIEW exutabi AS 
       SELECT t.* FROM exutab t,incexp i, incvid v
       WHERE t.name  = i.name(+) AND t.ownerid = i.owner#(+) AND
             NVL(i.type,2) = 2 AND  
             (bitand(t.modified,1) = 1 OR t.mtime > i.itime OR 
              NVL(i.expid,9999) > v.expid)
/	     
rem tables for cumulative export: modified, last export was inc, altered or new
drop view exutabc;
CREATE VIEW exutabc AS 
       SELECT t.* FROM exutab t,incexp i, incvid v
       WHERE  t.name  = i.name(+) AND t.ownerid = i.owner#(+) AND 
   	      NVL(i.type,2) = 2 AND 
              (bitand(t.modified,1) = 1 OR i.itime > NVL(i.ctime,
                                             TO_DATE('01-01-00','DD-MM-YY'))
               OR t.mtime > i.itime OR NVL(i.expid,9999) > v.expid)
/
rem current user's tables 
drop view exutabu;
CREATE VIEW exutabu AS
       SELECT * FROM exutab WHERE ownerid = uid
/
grant select on exutabu to public;

rem not null constraints on columns
drop view exucolnn;
CREATE view exucolnn (tobjid, colid, conname, isnull) AS
      SELECT o$.obj#, c$.col#, 
              DECODE(SUBSTR(con$.name,1,5), 'SYS_C', '', NVL(con$.name, '')),
	      1
      FROM  sys.obj$ o$, sys.col$ c$, sys.con$ con$, sys.cdef$ cd$,
            sys.ccol$ cc$
      WHERE c$.obj# = o$.obj# and c$.obj# = cc$.obj# and 
            c$.col# = cc$.col# and cc$.con# = cd$.con# and
            cd$.con# = con$.con#(+) and cd$.type =7
/

rem all columns  - map v7 type 96 (varchar2) to type 1 (char)
drop view exucol_temp;
CREATE VIEW exucol_temp (tobjid, towner, townerid, tname, name, length, 
		    precision, scale, type, isnull, conname, colid, 
		    comment$, --default$, 
		    dfltlen) AS
       SELECT o$.obj#, u$.name, o$.owner#, o$.name, c$.name, c$.length, 
              c$.precision, c$.scale, 
	      DECODE(c$.type#, 96, 1, c$.type#), NVL(cn.isnull,0), cn.conname,
              c$.col#, com$.comment$, -- c$.default$, 
	      NVL(c$.deflength, 0)
       FROM sys.col$ c$, sys.obj$ o$, sys.user$ u$,
	    sys.com$ com$, sys.exucolnn cn
       WHERE c$.obj# = o$.obj# and o$.owner# = u$.user# and 
	     c$.obj# = com$.obj#(+) and c$.col# = com$.col#(+) and
	     c$.obj# = cn.tobjid and c$.col# = cn.colid
    union all
       SELECT o$.obj#, u$.name, o$.owner#, o$.name, c$.name, c$.length, 
              c$.precision, c$.scale, 
	      DECODE(c$.type#, 96, 1, c$.type#), 0, null,
              c$.col#, com$.comment$, -- c$.default$, 
	      NVL(c$.deflength, 0)
       FROM sys.col$ c$, sys.obj$ o$, sys.user$ u$,
	    sys.com$ 
       WHERE c$.obj# = o$.obj# and o$.owner# = u$.user# and 
	     c$.obj# = com$.obj#(+) and c$.col# = com$.col#(+) 
	     and not exists
	     (select null from sys.exucolnn cn
		where c$.obj# = cn.tobjid and c$.col# = cn.colid)
/
drop view exucol;
CREATE VIEW exucol (tobjid, towner, townerid, tname, name, length, precision, 
		    scale, type, isnull, conname, colid, comment$, default$, 
	            dfltlen) AS
	SELECT tobjid, towner, townerid, v$.tname, v$.name, v$.length, 
	       v$.precision, v$.scale, type, isnull, conname, colid, comment$,
	       default$, dfltlen
	FROM exucol_temp v$, sys.col$ c$
	WHERE c$.obj# = v$.tobjid and c$.col# = v$.colid
/
drop view exucolu;
CREATE VIEW exucolu AS				   /* current user's columns */
       SELECT * from exucol WHERE townerid = uid
/
grant select on exucolu to public;

rem all columns for index
drop view exuico;
CREATE VIEW exuico (tobjid, towner, townerid, tname, name, length, precision,
		    scale, type, isnull, conname, colid, comment$, default$, 
		    dfltlen) AS
       SELECT o$.obj#, u$.name, o$.owner#, o$.name, c$.name, 0, 0, 0, 0, 0, '',
              i$.pos#, NULL, NULL, 0
       FROM sys.col$ c$, sys.icol$ i$, sys.obj$ o$, sys.user$ u$
       WHERE c$.obj# = i$.bo# and c$.col# = i$.col# and 
	     i$.obj# = o$.obj# and o$.owner# = u$.user#
/
drop view exuicou;
CREATE VIEW exuicou AS				   /* current user's columns */
       SELECT * from exuico WHERE townerid = uid
/
grant select on exuicou to public;

rem all users with connect (create session priv)
rem drop both table and view; either could be there
drop table exucnt;
drop view exucnt;
create view exucnt as
select distinct(grantee#) from sysauth$
connect by privilege# = prior grantee#
start with privilege#=-5
/
rem all users with resource (unlimited tablespace priv)
drop table exures;
drop view exures;
create view exures as 
select distinct(grantee#) from sysauth$
connect by privilege# = prior grantee#
start with privilege#=-15
/
rem all users with dba (alter system priv)
drop table exudba;
drop view exudba;
create view exudba as
select distinct(grantee#) from sysauth$
connect by privilege# = prior grantee#
start with privilege#=-3
/
drop view exuusr;
CREATE VIEW exuusr (name, userid, passwd, privs, datats, tempts) AS
        SELECT u.name, u.user#, DECODE(u.password, 'N', '', u.password),
	DECODE(c.grantee#, NULL, 'N', 'Y')||
	DECODE(d.grantee#, NULL, 'N', 'Y')||
	DECODE(r.grantee#, NULL, 'N', 'Y'),
        ts1.name, ts2.name       
	FROM sys.user$ u, sys.ts$ ts1, sys.ts$ ts2, sys.exucnt c, 
	     sys.exures r, sys.exudba d
        WHERE u.datats# = ts1.ts# 
	and u.tempts# = ts2.ts# 
	and u.user#=c.grantee#(+)
	and u.user#=r.grantee#(+) 
	and u.user#=d.grantee#(+)
/
drop view exuusru;
CREATE VIEW exuusru AS					     /* current user */
       SELECT * FROM exuusr WHERE userid = UID
/
grant select on exuusru to public;

rem all grants
drop view exugrn;
CREATE VIEW exugrn (objid, grantor, grantorid, grantee, privs,
                    creatorid, sequence#) AS
	SELECT t$.obj#, ur$.name, t$.grantor#, ue$.name,
	       DECODE(t$.alter$, 0, 'N', 2, 'Y', 'G') ||
	       DECODE(t$.delete$, 0, 'N', 2,  'Y', 'G') ||
	       DECODE(t$.index$, 0, 'N', 2, 'Y', 'G') ||
	       DECODE(t$.insert$, 0, 'N', 2, 'Y', 'G') ||
	       DECODE(t$.select$, 0, 'N', 2, 'Y', 'G') ||
	       DECODE(t$.update$, 0, 'N', 1, 'R', 2, 'Y', 'G') ||
 	       DECODE(t$.references$, 0, 'N', 2, 'Y', 'G'), 
	       o$.owner#, t$.sequence#
       FROM sys.tabauth$ t$, sys.obj$ o$, sys.user$ ur$,
	    sys.user$ ue$
       WHERE o$.obj# = t$.obj# AND
             t$.grantor# = ur$.user# AND t$.grantee# = ue$.user#
/
rem first level grants
drop view exugrnu;
CREATE VIEW exugrnu AS
       SELECT * FROM exugrn WHERE grantorid = UID AND creatorid = UID
/
grant select on exugrnu to public;

rem all column grants
drop view exucgr;
CREATE VIEW exucgr (objid, grantor, grantorid, grantee, creatorid, cname, 
	           sequence#, wgo) AS
       SELECT c$.obj#, ur$.name, c$.grantor#, ue$.name, o$.owner#, cl$.name,
              c$.sequence#, NVL(c$.option$,0)
       FROM sys.objauth$ c$, sys.obj$ o$, sys.user$ ur$, sys.user$ ue$,
            sys.col$ cl$
       WHERE c$.grantor# = ur$.user# AND c$.grantee# = ue$.user# AND
             c$.obj# = o$.obj# AND c$.privilege# = 10 AND 
             c$.obj# = cl$.obj# AND c$.col# = cl$.col#
/
rem first level grants
drop view exucgru;
CREATE VIEW exucgru AS
       SELECT * FROM exucgr WHERE grantorid = UID AND creatorid = UID
/
grant select on exucgru to public;

rem all indexes
drop view exuind;
CREATE VIEW exuind (iobjid, iname, iowner, iownerid, ispace, ifileno, iblockno,
		    btname, btobjid, btowner, btownerid, unique$,
		    cluster$, pctfree$, initrans, maxtrans)  AS
       SELECT i$.obj#, i$.name, ui$.name, i$.owner#, ts$.name, ind$.file#,
	      ind$.block#, t$.name, t$.obj#, ut$.name, t$.owner#,
              ind$.unique$, DECODE(t$.type, 3, 1, 0), ind$.pctfree$, 
	      ind$.initrans, ind$.maxtrans
       FROM  sys.obj$ t$, sys.obj$ i$, sys.ind$ ind$,
	     sys.user$ ui$, sys.user$ ut$, sys.ts$ ts$
       WHERE ind$.bo# = t$.obj# AND ind$.obj# = i$.obj# AND
	     ts$.ts# = ind$.ts# AND i$.owner# = ui$.user# AND
             t$.owner# = ut$.user# AND (unique$=0 OR 
	     NOT EXISTS (SELECT * from sys.con$ c$
			 WHERE c$.owner# = i$.owner#
                         AND   c$.name = i$.name))
/
rem current user indexes
drop view exuindu;
CREATE VIEW exuindu AS
       SELECT * FROM exuind WHERE iownerid = UID and btownerid = UID
/
grant select on exuindu to public;

rem all views 
rem  we exclude views created by snapshot logs since they aren't supported
rem  in v6
drop view exuvew;
CREATE VIEW exuvew (vobjid,vname, vlen, vtext, vowner, vownerid,
		    vtime, vaudit, vcomment, vcname) AS
       SELECT o$.obj#, o$.name, v$.textlength, v$.text, u$.name, o$.owner#, 
  	      TO_CHAR(o$.ctime, 'YYMMDDHH24MISS'), 
	      substr(v$.audit$, 1, 24), com$.comment$,
              DECODE(SUBSTR(c$.name,1,5), 'SYS_C', '', NVL(c$.name, ''))
       FROM sys.obj$ o$, sys.view$ v$, sys.user$ u$, sys.cdef$ cd$,
            sys.con$ c$, sys.com$ com$
       WHERE o$.obj# = v$.obj# AND o$.owner# = u$.user# AND
	     o$.obj# = cd$.obj#(+) AND cd$.con# = c$.con#(+) AND 
             o$.obj# = com$.obj#(+) AND com$.col#(+) is null AND
	     o$.name not like 'MVIEW$_%'
/
rem views for incremental export: new or last export not valid
rem cannot use union as in exutabi because of long field
drop view exuvewi;
CREATE VIEW exuvewi AS 
       SELECT vw.* FROM exuvew vw, incexp i, incvid v
       WHERE i.name(+) = vw.vname AND i.owner#(+) = vw.vownerid
             AND v.expid < NVL(i.expid, 9999) AND NVL(i.type, 4) = 4
/	     
rem views for cumulative export: new, last export was inc or not valid
drop view exuvewc;
CREATE VIEW exuvewc AS 
       SELECT vw.* FROM exuvew vw, incexp i, incvid v
       WHERE vw.vname = i.name(+) AND vw.vownerid = i.owner#(+) AND 
             NVL(i.type,4) = 4 AND
             (NVL(i.ctime,TO_DATE('01-01-00','DD-MM-YY')) < i.itime OR 
              v.expid < NVL(i.expid, 9999))
/
rem current user's view
drop view exuvewu;
CREATE VIEW exuvewu AS
       SELECT *	FROM exuvew WHERE vownerid = UID
/
grant select on exuvewu to public;

rem all synonyms
drop view exusyn;
CREATE VIEW exusyn (synnam, syntab, tabown, tabnode,
		        public$, synown, synownid, syntime) AS
       SELECT o$.name, s$.name, s$.owner, s$.node,
  	      DECODE(o$.owner#, 1, 1, 0),
   	      uo$.name, o$.owner#, TO_CHAR(o$.ctime, 'YYMMDDHH24MISS')
       FROM sys.obj$ o$, sys.syn$ s$, sys.user$ us$, sys.user$ uo$
       WHERE s$.obj# = o$.obj# AND o$.owner# = uo$.user# AND
	     s$.owner = us$.name(+)
/
rem synonyms for incremental export: new or last export not valid
drop view exusyni;
CREATE VIEW exusyni AS 
       SELECT s.* FROM exusyn s, incexp i, incvid v
       WHERE s.synnam = i.name(+) AND s.synownid = i.owner#(+) AND 
             NVL(i.type,5) = 5 AND NVL(i.expid,9999) > v.expid
/	     
rem synonyms for cumulative export: new, last export was inc or not valid
drop view exusync;
CREATE VIEW exusync AS 
       SELECT s.* FROM exusyn s, incexp i, incvid v
       WHERE  s.synnam  = i.name(+) AND s.synownid = i.owner#(+) AND 
              NVL(i.type,5) = 5 AND
	      (NVL(i.ctime,TO_DATE('01-01-00','DD-MM-YY')) < i.itime OR 
               NVL(i.expid,9999) > v.expid)
/
rem user's synnonyms
drop view exusynu;
CREATE VIEW exusynu AS
       SELECT * FROM exusyn WHERE synownid = UID
/
grant select on exusynu to public;

rem clustered tables' columns
drop view exucco;
CREATE VIEW exucco(tname, towner, townerid, cluster$, tcolnam, seq) AS
       SELECT t$.name, u$.name, t$.owner#, c$.name, tc$.name, cc$.col#
       FROM sys.obj$ t$, sys.tab$ tab$, sys.obj$ c$,
	    sys.col$ tc$, sys.col$ cc$, sys.user$ u$
       WHERE t$.type = 2 AND t$.obj# = tab$.obj# AND
  	     tab$.clu# = cc$.obj# AND tab$.obj# = tc$.obj# AND 
             tab$.clu# = c$.obj# AND 
             cc$.segcol# = tc$.segcol# AND t$.owner# = u$.user#
/
rem current user's clustered tables' columns
drop view exuccou;
CREATE VIEW exuccou AS
       SELECT * FROM exucco WHERE townerid = UID
/
grant select on exuccou to public;

rem all clusters except HASH clusters (not supported in v6)
drop view exuclu;
CREATE VIEW exuclu (objid, owner, ownerid, name, tblspace, size$, fileno,
	            blockno, mtime, pctfree$, pctused$, initrans, maxtrans) AS
       SELECT o$.obj#, u$.name, o$.owner#, o$.name, ts$.name, 
	      NVL(c$.size$, -1), c$.file#, c$.block#, o$.mtime, c$.pctfree$, 
              c$.pctused$, c$.initrans, c$.maxtrans
       FROM sys.obj$ o$, sys.clu$ c$, sys.ts$ ts$, sys.user$ u$
       WHERE o$.obj# = c$.obj# AND c$.ts# = ts$.ts# AND o$.owner# = u$.user#
	AND c$.hashkeys = 0
/
rem clusters for incremental export: new or last export invalid
rem altered cluster is not exported because this would require exporting all
rem tables in it.
drop view exuclui;
CREATE VIEW exuclui AS 
       SELECT c.* FROM exuclu c,incexp i, incvid v
       WHERE c.name  = i.name(+) AND c.ownerid = i.owner#(+) AND
	     NVL(i.expid,9999) > v.expid
/	     
rem clusters for cumulative export: last export was inc or new
rem altered cluster is not exported because this would require exporting all
rem tables in it.
drop view exucluc;
CREATE VIEW exucluc AS 
       SELECT c.* FROM exuclu c,incexp i, incvid v
       WHERE c.name = i.name(+) AND c.ownerid = i.owner#(+) AND 
             NVL(i.type,3) = 3 AND
	      (i.itime > NVL(i.ctime,TO_DATE('01-01-00','DD-MM-YY'))
             OR NVL(i.expid,9999) > v.expid)
/
rem current user's clusters
drop view exucluu;
CREATE VIEW exucluu AS
       SELECT * FROM exuclu WHERE ownerid = UID
/
grant select on exucluu to public;

rem all storage parameters
drop view exusto;
CREATE VIEW exusto (ownerid, fileno, blockno, iniext, sext, minext,
                    maxext, pctinc, blocks) AS
       SELECT user#, file#, block#, iniexts, extsize, minexts, maxexts, 
              extpct, blocks
       FROM sys.seg$
/ 

rem storage parameters for current user's segments
drop view exustou;
CREATE VIEW exustou AS
       SELECT * FROM exusto WHERE ownerid = UID
/
grant select on exustou to public;

rem all tablespaces
drop view exutbs;
CREATE VIEW exutbs (id, owner, name, isonline, iniext, sext, pctinc,
		    minext, maxext) AS
       SELECT ts$.ts#, 'SYSTEM', ts$.name, 
	      DECODE(ts$.online$, 1, 'ONLINE', 'OFFLINE'), ts$.dflinit,
   	      ts$.dflincr, ts$.dflextpct, ts$.dflminext, ts$.dflmaxext
       FROM sys.ts$ ts$ 
       WHERE ts$.online$ in (1, 2) and ts$.ts# != 0
/

rem tablespace quotas
drop view exutsq;
CREATE VIEW exutsq(tsname, tsid, uname, maxblocks) AS
       SELECT t$.name, q$.ts#, u$.name, q$.maxblocks
       FROM  sys.ts$ t$, sys.tsq$ q$, sys.user$ u$
       WHERE  q$.user# = u$.user# AND q$.ts# = t$.ts# AND q$.maxblocks != 0
/

rem block size
drop view exubsz;
CREATE VIEW exubsz(blocksize) AS
       SELECT ts$.blocksize
       FROM   sys.ts$ ts$
/
grant select on exubsz to public;

rem all files
drop view exufil;
CREATE VIEW exufil(fname, fsize, tsid) AS
       SELECT v$.name, f$.blocks, f$.ts#
       FROM   sys.file$ f$, sys.v$dbfile v$
       WHERE  f$.file# = v$.file#
/

rem all database links
rem in v7, db link names can be longer than in v6.  We compress the form
rem  'x.y[.a.b]' to 'x'.  If the name is of form 'x', it is unchanged.
drop view exulnk;
CREATE VIEW exulnk (owner, ownerid, name, user$, passwd, host, public$) AS
       SELECT DECODE(l$.owner#, 1, 'SYSTEM', u$.name), l$.owner#,
	decode(instr(l$.name,'.'), 0, l$.name,
	       substr(l$.name, 1, instr(l$.name,'.')-1)),
              l$.userid, l$.password, l$.host, DECODE(l$.owner#, 1, 1, 0)
       FROM sys.user$ u$, sys.link$ l$
       WHERE u$.user# = l$.owner#
/
drop view exulnku;
CREATE VIEW exulnku AS			    /* current user's database links */
       SELECT * FROM exulnk WHERE ownerid = UID
/
grant select on exulnku to public;

rem all rollback segments
drop view exursg;
CREATE VIEW exursg (name, space$, fileno , blockno, minext, public$) AS 
       SELECT r$.name, ts$.name, r$.file#, r$.block#, s$.minexts,
   	      DECODE(r$.user#, 1, 1, 0)
       FROM sys.ts$ ts$, sys.undo$ r$, sys.seg$ s$
       WHERE r$.status$ != 1 AND r$.file# = s$.file# AND r$.block# = s$.block#
             AND s$.ts# = ts$.ts# and r$.us# != 0
/

rem info on deleted object
drop view exudel;
CREATE VIEW exudel (owner, name, type, type#) AS
       SELECT u$.name, i$.name, DECODE(i$.type, 2, 'TABLE', 3, 
              'CLUSTER', 4, 'VIEW', 5, 'SYNONYM'), i$.type
       FROM sys.incexp i$, sys.user$ u$
       WHERE i$.owner# = u$.user# AND
             (i$.owner#, i$.name, i$.type) 
             NOT IN (SELECT o$.owner#, o$.name, o$.type 
		     FROM   sys.obj$ o$
                     WHERE  o$.linkname is null
		    )
/

rem info on sequence number
drop view exuseq;
CREATE VIEW exuseq (owner, ownerid, name, objid, curval, minval, maxval, 
		    incr, cache, cycle, order$, audt) AS
       SELECT u.name, u.user#, o.name, o.obj#, s.highwater, s.minvalue, 
	      s.maxvalue, s.increment$, s.cache, s.cycle, s.order$, 
	      substr(s.audit$, 1, 24)
       FROM sys.obj$ o, sys.user$ u, sys.seq$ s
       WHERE o.obj# = s.obj# AND o.owner# = u.user#
/
drop view exusequ;
CREATE VIEW exusequ AS 
       SELECT * FROM sys.exuseq WHERE UID = ownerid
/
grant select on sys.exusequ to public;

rem contraints on table
drop view exucon;
CREATE VIEW exucon (objid, owner, ownerid, tname, type, cname, cno, condition,
                    condlength) AS
       SELECT o.obj#, u.name, c.owner#, o.name, cd.type, 
	      DECODE(SUBSTR(c.name,1,5), 'SYS_C', '', NVL(c.name, '')),
              c.con#, cd.condition, cd.condlength
       FROM sys.obj$ o, sys.user$ u, sys.con$ c, sys.cdef$ cd
       WHERE u.user# = c.owner# AND o.obj# = cd.obj# AND cd.con# = c.con#
/
drop view exuconu;
CREATE VIEW exuconu AS 
       SELECT * FROM sys.exucon WHERE UID = ownerid
/
grant select on sys.exuconu to public;

rem referential constraints
drop view exuref;
CREATE VIEW exuref (objid, owner, ownerid, tname, rowner, rtname, cname, cno,
	            rcno) AS
       SELECT o.obj#, u.name, c.owner#, o.name, ru.name, ro.name, 
              DECODE(SUBSTR(c.name, 1, 5), 'SYS_C', '', NVL(c.name, '')),
	      c.con#, cd.rcon#
       FROM sys.user$ u, sys.user$ ru, sys.obj$ o, sys.obj$ ro, 
            sys.con$ c, sys.cdef$ cd
       WHERE u.user# = c.owner# AND o.obj# = cd.obj# AND ro.obj# = cd.robj# AND
             cd.con# = c.con# AND cd.type = 4 AND ru.user# = ro.owner#
/
drop view exurefu;
CREATE VIEW exurefu AS SELECT * FROM sys.exuref WHERE UID = ownerid
/
grant select on sys.exurefu to public;
rem referential constraints for incremental and cumulative export
rem for tables just exported, i.expid will be greater than v.expid
rem as v.expid is incremented only at the end of the incremental export
rem but i.expid is incremented when the table is exported.
rem USED ONLY WHEN REOCRD = YES
drop view exurefic;
CREATE VIEW exurefic AS
       SELECT * FROM sys.exuref 
       WHERE (ownerid, tname) in 
             (SELECT i.owner#, i.name 
              FROM sys.incexp i, sys.incvid v
              WHERE i.expid > v.expid AND i.type = 2)
/
rem referentail constraints for incremental export
rem exutabi will return the correct table name because RECORD = NO
drop view exurefi;
CREATE VIEW exurefi AS
       SELECT * FROM sys.exuref
       WHERE (ownerid, tname) in (SELECT ownerid, name FROM sys.exutabi)
/
rem referentail constraints for cumulative export, assuming
rem exutabc will return the correct table name because RECORD = NO
drop view exurefc;
CREATE VIEW exurefc AS
       SELECT * FROM sys.exuref
       WHERE (ownerid, tname) in (SELECT ownerid, name FROM sys.exutabc)
/

rem contraint column list
drop view exuccl;
CREATE VIEW exuccl (ownerid, cno, colname, colno) AS
       SELECT o.owner#, cc.con#, c.name, cc.pos#
       FROM sys.obj$ o, sys.col$ c, sys.ccol$ cc
       WHERE o.obj# = cc.obj# AND c.obj# = cc.obj# AND cc.col# = c.col#
/
drop view exucclu;
CREATE VIEW exucclu AS
       SELECT * FROM sys.exuccl WHERE UID = ownerid
/
grant select on sys.exucclu to public;
drop view exucclo;
CREATE VIEW exucclo (ownerid, cno, colname, colno) AS
	SELECT a.ownerid, a.cno, a.colname, a.colno
	FROM sys.exuccl a, sys.con$ b , sys.cdef$ c
	WHERE b.owner#=UID
	AND   b.con# = c.con#
	AND   c.rcon# = a.cno
/
grant select on sys.exucclo to public;

rem replication constraints
drop view exurep;
CREATE VIEW exurep (objid, owner, ownerid, tname, rowner, rtname, cname, 
		    sowner, sname, scname, cno, rcno) AS
	SELECT NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	FROM dual where 1=2
/
drop view exurepu;
CREATE VIEW exurepu AS SELECT * FROM sys.exurep WHERE UID = ownerid
/
grant select on sys.exurepu to public;

rem replication constraints for incremental and cumulative export
rem for tables just exported, i.expid will be greater than v.expid
rem as v.expid is incremented only at the end of the incremental export
rem but i.expid is incremented when the table is exported.
rem USED ONLY WHEN REOCRD = YES
drop view exurepic;
CREATE VIEW exurepic AS
	SELECT * from exurep
/
rem replication constraints for incremental export
rem exutabi will return the correct table name because RECORD = NO
drop view exurepi;
CREATE VIEW exurepi AS
	SELECT * FROM exurep
/
rem replication constraints for cumulative export, assuming
rem exutabc will return the correct table name because RECORD = NO
drop view exurepc;
CREATE VIEW exurepc AS
	SELECT * FROM exurep
/

rem v6 export wants this table around; it was discontinued in v7
create table "_system_auditing_options_" (a char(1))
/
