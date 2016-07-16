rem 
rem $Header: /private1/RCS_01Nov/src.mig/./utl/RCS/catexp.sql,v 1.49 1995/10/18 10:22:55 jcohen Exp $ expvew.sql 
rem $Header: /private1/RCS_01Nov/src.mig/./utl/RCS/catexp.sql,v 1.49 1995/10/18 10:22:55 jcohen Exp $ expvew.sql 
rem 
Rem Copyright (c) 1987, 1996 by Oracle Corporation
Rem NAME
REM    CATEXP.SQL - CATalog EXPort/import sql script
Rem  FUNCTION
Rem    Creates internal views for Export/Import utility
Rem  NOTES
Rem    Must be run when connected to SYS or INTERNAL.
Rem
Rem    This file is organized into 3 sections:
Rem	Section 1: Views needed by BOTH export and import
Rem	Section 2: Views required by import ONLY
Rem 	Section 3: Views required by export ONLY
Rem
Rem 	Import does not currently require any views of its own. The views
Rem     used by both tools are moved to the top so that a user doing an import
Rem     only has to run part of this file. Since there are common views
Rem     a separate file called catimp.sql was not created for now for
Rem	maintenance reasons.
Rem
Rem	No views depend on catalog.sql. This script can be run standalone.
Rem
Rem  MODIFIED
Rem     ccchang    05/20/96 -  fix spare8 of exu7ind
Rem     ccchang    10/10/95 -  add bitmap to exu7ind view for bitmap index
Rem     ixhu       09/18/95 -  bug 250819 - misspelt RECORD, referential
Rem     ixhu       09/11/95 -  bug 110894 - add exu7ordu to speed up exu7vewu
Rem     bhimatsi   07/11/95 -  merge changes from branch 1.37.720.2
Rem     ssamu      06/15/95 -  change views on tab$
Rem     ixhu       05/25/95 -  add content to exu7tbs
Rem     ixhu       05/15/95 -  bug 274629 - export ts quota even for dropped ts
Rem     lcprice    05/08/95 -  merge changes from branch 1.37.720.1
Rem     ixhu       04/18/95 -  add imp7uec for unlimited extent compatibility 
Rem     jcchou     04/17/95 -  (258186) fix
Rem     ixhu       04/04/95 -  temporary/permanent tablespace in exu7tbs
Rem     ixhu       03/09/95 -  add segcol# in exu7col & exu7colu, exu7cset
Rem     lcprice    04/18/95 -  Fix bug #267737 - default roles processing
Rem     vraghuna   08/19/94 -  move views reqd by both imp and exp to the top
Rem     vraghuna   08/18/94 -  move compatibility checks from sql.bsq
Rem     vraghuna   08/15/94 -  bug 227714 - add exu7cpo
Rem     jloaiza    07/08/94 -  bitand modified column
Rem     vraghuna   06/20/94 -  add support for hash cluster functions
Rem     vraghuna   06/10/94 -  bug 218372 - speed up exu7del
Rem     vraghuna   06/09/94 -  bug 219654 - add NVLs for ||l and cache params
Rem     vraghuna   05/16/94 -  bug 215597 - change exu7snaplu also
Rem     vraghuna   05/12/94 -  bug 215597 - change exu7snapl to exclude slog
Rem     vraghuna   04/24/94 -  bug 211989 - add create roles but not drop
Rem     ltung      03/02/94 -  merge changes from branch 1.15.710.1
Rem     vraghuna   02/09/94 -  add exu7ver for version control
Rem     vraghuna   02/02/94 -  bug 190236 - add outer join to exu7ord in exu7ve
Rem     vraghuna   01/17/94 -  bug 191751 - add support for deferred RPC/RepCat
Rem     vraghuna   01/12/94 -  bug 191750 - add support for refresh groups
Rem     vraghuna   01/11/94 -  bug 191749 - add support for job queues exu7jbq
Rem     vraghuna   01/11/94 -  bug 193733 - use basename in incr trigger views
Rem     vraghuna   01/11/94 -  bug 193732 - fix exu7del for trigs, pkg bodies
Rem     vraghuna   01/10/94 -  bug 192781 - add basetable name for trigger view
Rem     vraghuna   12/30/93 -  bug 192652 - change MM to MI for exu7spr
Rem     vraghuna   12/21/93 -  bug 191879 - grants issued twice
Rem     vraghuna   12/06/93 -  bug 186073 - add read only tablespaces
Rem     vraghuna   08/18/93 -  bug 174029 - moving role creation to sql.bsq
Rem     vraghuna   07/07/93 -  add support for updatable snapshots
Rem     vraghuna   06/17/93 -  bug 166480 - add exu7erc for resource costs
Rem     vraghuna   06/17/93 -  bug 168261 - imp_full_database needs insert priv
Rem     vraghuna   06/17/93 -  bug 166482 - export role passwords
Rem     vraghuna   05/27/93 -  bug 166484 - add audt to exu7spr
Rem     ltung      05/16/93 -  export parallel/cache parameters 
Rem     vraghuna   03/15/93 -  bug 140485 - incrementals on tables with constra
Rem     vraghuna   03/12/93 -  bug 152906 - add tspname to exu7uscu 
Rem     vraghuna   01/27/93 -  bug 146283 - add exu7usc 
Rem     vraghuna   12/18/92 -  bug 143375 - break up exu7col 
Rem     vraghuna   12/02/92 -  bug 139302 - speed up exu7colnn 
Rem     tpystyne   11/07/92 -  use create or replace view 
Rem     vraghuna   10/28/92 -  bug 130560 - add exu7ful 
Rem     vraghuna   10/23/92 -  bug 135594 - remove exu7inv and exu7invu 
Rem     glumpkin   10/20/92 -  Renamed from EXPVEW.SQL 
Rem     vraghuna   10/14/92 -  bug 131957 - add field to exu7sto and exu7stou 
Rem     vraghuna   07/14/92 -  bug 115048 - support for analyze statement 
Rem     cheigham   06/24/92 -  add exu7colnn view 
Rem     cheigham   06/22/92 -  fix cdef$,col$ joins to accommodate changes for 
Rem     jbellemo   06/12/92 -  add mapping for MLSLABEL 
Rem     vraghuna   06/03/92 -  bug 39511 - add exu7grs 
Rem     cheigham   05/27/92 -  speed up exu7vew 
Rem     cheigham   02/13/92 -  add select any to imp_full_database 
Rem     cheigham   02/13/92 -  grant alter any table to imp_full_database 
Rem     cheigham   01/29/92 -  export altered clusters in inc. exports 
Rem     cheigham   01/09/92 -  add more privs to imp_full_database 
Rem     cheigham   11/15/91 -  fix object codes 
Rem     cheigham   11/06/91 -  fix inc. trigger views 
Rem     cheigham   11/02/91 -  merge in hash changes 
Rem     cheigham   10/11/91 -  view names: exu -> exu7
Rem     cheigham   09/27/91 -  add snapshot views 
Rem     sksingh    09/30/91 -  merge changes from branch 1.13.50.1 
Rem     sksingh    09/23/91 -  replace spare1,2,3 with match, refact, enabled
Rem     agupta     09/20/91 -  add support for lists/groups storage params 
Rem     agupta     08/16/91 -  enable|disable constraints 
Rem     agupta     07/30/91 -  7037 - views not created in dependency or
Rem     agupta     07/02/91 -  timestamp syntax for procedures 
Rem     agupta     06/21/91 -  fix errors in exurlg 
Rem     agupta     06/14/91 -  user$ column name changes 
Rem     agupta     05/31/91 -  add userid to tablespace quota view 
Rem     agupta     05/04/91 -  fix unique constraints bug 
Rem     agupta     04/16/91 -  fix auditing views 
Rem     jwijaya    04/12/91 -  remove LINKNAME IS NULL 
Rem     rkooi      04/01/91 -  add 'o.linkname IS NULL' clause 
Rem     Gupta      02/26/90 -  Lots of modifications for V7
Rem     Hong       10/31/88 -  don't export quotas of 0
Rem     Hong       09/21/88 -  allow null precision/scale
Rem     Hong       09/10/88 -  fix outer joins
Rem     Hong       08/10/88 -  get default/temp tablespace in exuusr
Rem     Hong       07/01/88 -  get obj id in some views
Rem     Hong       06/10/88 -  remove userid != 0 from views
Rem     Hong       04/28/88 -  comment$ moved to com$
Rem     Hong       03/24/88 -  add audit field to exu7seq
Rem     Hong       03/07/88 -  deal with initrans, maxtrans
Rem                            add views for constraints, sequence #
Rem     Hong       02/01/88 -  add exuico and exuicou
Rem                            temporary commented out col$.default$
Rem     Hong       02/01/88 -  fix exufil to use v$dbfile directly
Rem     Hong       12/12/87 -  fix exutbs
Rem     Hong       12/07/87 -  handle min extents 
Rem

set echo on;

rem this role allows the grantee to perform full database exports
rem including incremental exports
CREATE ROLE exp_full_database;
grant select any table to exp_full_database;
grant backup any table to exp_full_database;
grant execute any procedure to exp_full_database;
GRANT insert,update,delete
 ON sys.incexp
 TO exp_full_database;
GRANT insert,update,delete
 ON sys.incvid
 TO exp_full_database;
GRANT insert,update,delete
 ON sys.incfil
 TO exp_full_database;
grant exp_full_database to dba;

rem this role allows the grantee to perform full database imports
CREATE ROLE imp_full_database;
grant become user to imp_full_database;
grant create any cluster to imp_full_database;
grant create any index to imp_full_database;
grant create any table to imp_full_database;
grant create any procedure to imp_full_database;
grant create any sequence to imp_full_database;
grant create any snapshot to imp_full_database;
grant create any synonym to imp_full_database;
grant create any trigger to imp_full_database;
grant create any view to imp_full_database;
grant create profile to imp_full_database;
grant create public database link to imp_full_database;
grant create database link to imp_full_database;
grant create public synonym to imp_full_database;
grant create rollback segment to imp_full_database;
grant create role to imp_full_database;
grant create tablespace to imp_full_database;
grant create user to imp_full_database;
grant audit any to imp_full_database;
grant comment any table to imp_full_database;
grant alter any table to imp_full_database;
grant select any table to imp_full_database;
grant execute any procedure to imp_full_database;
grant insert any table to imp_full_database;

rem for import of incremental export files
grant drop any cluster to imp_full_database;
grant drop any index to imp_full_database;
grant drop any table to imp_full_database;
grant drop any procedure to imp_full_database;
grant drop any sequence to imp_full_database;
grant drop any snapshot to imp_full_database;
grant drop any synonym to imp_full_database;
grant drop any trigger to imp_full_database;
grant drop any view to imp_full_database;
grant drop profile to imp_full_database;
grant drop public database link to imp_full_database;
grant drop public synonym to imp_full_database;
grant drop rollback segment to imp_full_database;
grant drop any role to imp_full_database;
grant drop tablespace to imp_full_database;
grant drop user to imp_full_database;

grant imp_full_database to dba;

Rem
Rem  ***************************************************
Rem  Section 1: Views required by BOTH export and import
Rem  ***************************************************
Rem 
rem block size
CREATE OR REPLACE view exu7bsz(blocksize) AS
       SELECT ts$.blocksize
       FROM   sys.ts$ ts$
/
grant select on exu7bsz to public;

rem all users
CREATE OR REPLACE view exu7usr 
                   (name, userid, passwd, defrole, datats, tempts, profile#, 
	            profname) AS 
       SELECT u.name, u.user#, DECODE(u.password, 'N', '', u.password), 
              DECODE(u.defrole, 0, 'N', 1, 'A', 2, 'L', 3, 'E', 'X'), 
	      ts1.name, ts2.name, u.resource$, p.name
       FROM sys.user$ u, sys.ts$ ts1, sys.ts$ ts2, sys.profname$ p
       WHERE u.datats# = ts1.ts# and u.tempts# = ts2.ts# and u.type = 1 and
             u.resource$ = p.profile#
/
CREATE OR REPLACE view exu7usru AS			     /* current user */
       SELECT * from exu7usr WHERE userid = UID
/
grant select on exu7usru to public;

rem check if user has priv to do a full db export
CREATE OR REPLACE view exu7ful(role) as
select u.name
from x$kzsro, user$ u
where kzsrorol!=uid and kzsrorol!=1 and u.user#=kzsrorol
/
grant select on sys.exu7ful to public;


Rem
Rem  ****************************************
Rem  Section 2: Views required by import ONLY
Rem  ****************************************
Rem 
REM Get Unlimited Extent Compatibility Information
CREATE or REPLACE view imp7uec (release) AS
		SELECT release 
		FROM v$compatibility
		WHERE type_id = 'UNLMTEXT'
/
grant select on imp7uec to public
/
Rem
Rem  ****************************************
Rem  Section 3: Views required by export ONLY
Rem  ****************************************
Rem 
rem all tables
CREATE OR REPLACE view exu7tab 
                   (objid, name, owner, ownerid, tablespace, fileno, blockno,
		    audit$, comment$, clusterflag, mtime, modified, 
	            pctfree$,
                    pctused$, initrans, maxtrans, parallel, cache) AS
       SELECT o$.obj#,o$.name, u$.name, o$.owner#, ts$.name, t$.file#, 
	      t$.block#, t$.audit$, c$.comment$, NVL(t$.clu#, 0), o$.mtime,
	      bitand(t$.modified,1), mod(t$.pctfree$, 100), t$.pctused$, t$.initrans, 
	      t$.maxtrans, NVL(t$.spare1,0), NVL(t$.spare2,0)
       FROM sys.tab$ t$, sys.obj$ o$, sys.ts$ ts$, sys.user$ u$, sys.com$ c$
       WHERE  t$.obj# = o$.obj# and t$.ts# = ts$.ts# and 
              u$.user# = o$.owner# and o$.obj# = c$.obj#(+) 
	      and c$.col#(+) is null
/
rem tables for incremental export: modified, altered or new
CREATE OR REPLACE view exu7tabi AS 
       SELECT t.* from exu7tab t,incexp i, incvid v
       WHERE t.name  = i.name(+) AND t.ownerid = i.owner#(+) AND
             NVL(i.type,2) = 2 AND  
             (bitand(t.modified,1) = 1 OR t.mtime > i.itime OR 
              NVL(i.expid,9999) > v.expid)
/	     
rem tables for cumulative export: modified, last export was inc, altered or new
CREATE OR REPLACE view exu7tabc AS 
       SELECT t.* from exu7tab t,incexp i, incvid v
       WHERE  t.name  = i.name(+) AND t.ownerid = i.owner#(+) AND 
   	      NVL(i.type,2) = 2 AND 
              (bitand(t.modified,1) = 1 OR i.itime > NVL(i.ctime,
                                                TO_DATE('01-01-00','DD-MM-YY'))
               OR t.mtime > i.itime OR NVL(i.expid,9999) > v.expid)
/
rem current user's tables 
CREATE OR REPLACE view exu7tabu AS
       SELECT * from exu7tab WHERE ownerid = uid
/
grant select on exu7tabu to public;

rem not null constraints on columns
CREATE OR REPLACE view exu7colnn (tobjid, colid, conname, isnull, enabled) AS
      SELECT cc$.obj#, cc$.col#, 
              DECODE(SUBSTR(con$.name,1,5), 'SYS_C', '', NVL(con$.name, '')),
	      1, NVL(cd$.enabled, 0)
      FROM  sys.con$ con$, sys.cdef$ cd$, sys.ccol$ cc$
      WHERE cc$.con# = cd$.con# and
            cd$.con# = con$.con# and cd$.type =7
/
CREATE OR REPLACE view exu7col_temp
                   (tobjid, towner, townerid, tname, name, length, precision, 
		    scale, type, isnull, conname, colid, segcolid,
		    comment$, --default$, 
	            dfltlen, enabled) AS
       SELECT o$.obj#, u$.name, o$.owner#, o$.name, c$.name, c$.length, 
              c$.precision, c$.scale, c$.type#, NVL(cn.isnull,0), 
              cn.conname, c$.col#, c$.segcol#,
	      com$.comment$,-- c$.default$, 
	      NVL(c$.deflength, 0), cn.enabled
       FROM sys.col$ c$, sys.obj$ o$, sys.user$ u$, sys.com$ com$,
		sys.exu7colnn cn
       WHERE c$.obj# = o$.obj# and o$.owner# = u$.user# and 
	     c$.obj# = com$.obj#(+) and c$.col# = com$.col#(+) and
	     c$.obj# = cn.tobjid and c$.col# = cn.colid
  union all
       SELECT o$.obj#, u$.name, o$.owner#, o$.name, c$.name, c$.length, 
              c$.precision, c$.scale, c$.type#, 0,
              null, c$.col#, c$.segcol#, com$.comment$,-- c$.default$, 
	      NVL(c$.deflength, 0), to_number(null)
       FROM sys.col$ c$, sys.obj$ o$, sys.user$ u$, sys.com$ com$
       WHERE c$.obj# = o$.obj# and o$.owner# = u$.user# and 
	     c$.obj# = com$.obj#(+) and c$.col# = com$.col#(+)
             and not exists 
              (select null from sys.exu7colnn cn
	         where c$.obj# = cn.tobjid and c$.col# = cn.colid)
/
create or replace view exu7col
   (tobjid, towner, townerid, tname, name, length, precision,
    scale, type, isnull, conname, colid, segcolid, comment$, default$,
    dfltlen, enabled) AS
 select tobjid, towner, townerid, v$.tname, v$.name, v$.length, v$.precision,
                    v$.scale, type, isnull, conname, colid, segcolid,
		    comment$, default$,
                    dfltlen, enabled
   from exu7col_temp v$, sys.col$ c$
    where c$.obj# = v$.tobjid and c$.col# = v$.colid
/

CREATE OR REPLACE view exu7colu AS                 /* current user's columns */
       SELECT * from exu7col WHERE townerid = uid
/
grant select on exu7colu to public;

rem all columns for index
CREATE OR REPLACE view exu7ico 
                   (tobjid, towner, townerid, tname, name, length, precision,
		    scale, type, isnull, conname, colid, comment$, default$, 
		    dfltlen, enabled) AS
       SELECT o$.obj#, u$.name, o$.owner#, o$.name, c$.name, 0, 0, 0, 0, 0, '',
              i$.pos#, NULL, NULL, 0, 0
       FROM sys.col$ c$, sys.icol$ i$, sys.obj$ o$, sys.user$ u$
       WHERE c$.obj# = i$.bo# and c$.col# = i$.col# and 
	     i$.obj# = o$.obj# and o$.owner# = u$.user#
/
CREATE OR REPLACE view exu7icou AS		   /* current user's columns */
       SELECT * from exu7ico WHERE townerid = uid
/
grant select on exu7icou to public;

rem all users' default roles
CREATE OR REPLACE view exu7dfr (name, userid, role, roleid) AS
       SELECT u$.name, u$.user#, u1$.name, u1$.user#
       FROM sys.user$ u$, sys.user$ u1$, sys.defrole$ d$
       WHERE u$.user# = d$.user# and u1$.user# = d$.role#
/
rem all roles
CREATE OR REPLACE view exu7rol (role, password) AS    /* enumerate all roles */
       SELECT name, password
       FROM sys.user$ 
       WHERE type = 0 and name not in 
            ('CONNECT', 'RESOURCE', 'DBA', 'PUBLIC', '_NEXT_USER', 
	     'EXP_FULL_DATABASE', 'IMP_FULL_DATABASE')
/
rem all role grants
CREATE OR REPLACE view exu7rlg
                   (grantee, granteeid, role, roleid, admin, sequence) AS
	SELECT u1$.name, u1$.user#, u2$.name, u2$.user#, 
	       NVL(g$.option$, 0), g$.sequence#
   	FROM sys.user$ u1$, sys.user$ u2$, sys.sysauth$ g$ 
	WHERE u1$.user# = g$.grantee# AND u2$.user# = g$.privilege# AND 
	      g$.privilege# > 0
/
rem all system privs, type is 1 for user, 0 for role
CREATE OR REPLACE view exu7spv (grantee, granteeid, priv, wgo, sequence) AS
       SELECT u1$.name, u1$.user#, m$.name, NVL(a$.option$,0), a$.sequence#
       FROM sys.sysauth$ a$, sys.system_privilege_map m$, sys.user$ u1$
       WHERE a$.grantee# = u1$.user# and a$.privilege# = m$.privilege AND 
	     u1$.name not in 
	     ('CONNECT', 'RESOURCE', 'DBA', 'PUBLIC', '_NEXT_USER', 
	     'EXP_FULL_DATABASE', 'IMP_FULL_DATABASE')
/
rem all grants
CREATE OR REPLACE view exu7grn (objid, grantor, grantorid, grantee, priv, wgo,
                    creatorid, sequence) AS
       SELECT t$.obj#, ur$.name, t$.grantor#, ue$.name, 
              m$.name, NVL(t$.option$,0), o$.owner#, t$.sequence#
       FROM sys.objauth$ t$, sys.obj$ o$, sys.user$ ur$,
            sys.table_privilege_map m$, sys.user$ ue$
       WHERE o$.obj# = t$.obj# AND t$.privilege# = m$.privilege AND
             t$.col# IS NULL AND t$.grantor# = ur$.user# AND
             t$.grantee# = ue$.user#
/

rem just SYS's grants
CREATE OR REPLACE view exu7grs (objid, name) AS
       SELECT t$.obj#, o$.name
       FROM sys.objauth$ t$, sys.obj$ o$
       WHERE o$.obj# = t$.obj# 
	AND t$.col# is null
	AND t$.grantor# = 0
/

rem first level grants
CREATE OR REPLACE view exu7grnu AS
       SELECT * from exu7grn WHERE grantorid = UID AND creatorid = UID
/
grant select on exu7grnu to public;

rem all column grants
CREATE OR REPLACE view exu7cgr 
                   (objid, grantor, grantorid, grantee, creatorid, cname, 
	            priv, sequence, wgo) AS
       SELECT c$.obj#, ur$.name, c$.grantor#, ue$.name, o$.owner#, cl$.name,
              m$.name, c$.sequence#, NVL(c$.option$,0)
       FROM sys.objauth$ c$, sys.obj$ o$, sys.user$ ur$, sys.user$ ue$,
            sys.table_privilege_map m$, sys.col$ cl$
       WHERE c$.grantor# = ur$.user# AND c$.grantee# = ue$.user# AND
             c$.obj# = o$.obj# AND c$.privilege# = m$.privilege AND 
             c$.obj# = cl$.obj# AND c$.col# = cl$.col#
/
rem first level grants
CREATE OR REPLACE view exu7cgru AS
       SELECT * from exu7cgr WHERE grantorid = UID AND creatorid = UID
/
grant select on exu7cgru to public;

rem all indexes
rem add spare8 for bitmap index
CREATE OR REPLACE view exu7ind 
                   (iobjid, iname, iowner, iownerid, ispace, ifileno, iblockno,
		    btname, btobjid, btowner, btownerid, unique$,
		    cluster$, pctfree$, initrans, maxtrans, blevel, bitmap) AS
       SELECT i$.obj#, i$.name, ui$.name, i$.owner#, ts$.name, ind$.file#,
	      ind$.block#, t$.name, t$.obj#, ut$.name, t$.owner#,
              ind$.unique$, DECODE(t$.type, 3, 1, 0), ind$.pctfree$, 
	      ind$.initrans, ind$.maxtrans, NVL(ind$.blevel,-1),
              NVL(ind$.spare8,0)
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
CREATE OR REPLACE view exu7indu AS
       SELECT * from exu7ind WHERE iownerid = UID and btownerid = UID
/
grant select on exu7indu to public;
rem dependency order
CREATE OR REPLACE view exu7ord (dlevel, obj#) AS
       SELECT MAX(LEVEL), d_obj# from sys.dependency$
       CONNECT BY PRIOR d_obj# = p_obj#
       GROUP BY d_obj#
/
grant select on exu7ord to public;
rem current user's dependency order
CREATE OR REPLACE view exu7ordu (dlevel, obj#) AS
       SELECT MAX(LEVEL), d_obj# from sys.dependency$
       WHERE d_owner# = uid
       CONNECT BY PRIOR d_obj# = p_obj#
       GROUP BY d_obj#, d_owner#
/
grant select on exu7ordu to public;
rem all views 
CREATE OR REPLACE view exu7vew (vobjid,vname, vlen, vtext, vowner, vownerid,
		    vaudit, vcomment, vcname, vlevel) AS
       SELECT
	o$.obj#, o$.name, v$.textlength, v$.text, u$.name, o$.owner#, 
  	      v$.audit$, com$.comment$, 
	      DECODE(SUBSTR(c$.name,1,5), 'SYS_C', '', NVL(c$.name, '')),
	      d$.dlevel
       FROM sys.obj$ o$, sys.view$ v$, sys.user$ u$, sys.cdef$ cd$,
            sys.con$ c$, sys.com$ com$, exu7ord d$
       WHERE v$.obj# = o$.obj# AND o$.owner# = u$.user# AND
	     o$.obj# = cd$.obj#(+) AND cd$.con# = c$.con#(+) AND 
             o$.obj# = com$.obj#(+) AND com$.col#(+) IS NULL AND
	     o$.obj# = d$.obj#(+)
/
rem views for incremental export: new or last export not valid
rem cannot use union as in exutabi because of long field
CREATE OR REPLACE view exu7vewi AS 
       SELECT vw.* from exu7vew vw, incexp i, incvid v
       WHERE i.name(+) = vw.vname AND i.owner#(+) = vw.vownerid
             AND v.expid < NVL(i.expid, 9999) AND NVL(i.type, 4) = 4
/	     
rem views for cumulative export: new, last export was inc or not valid
CREATE OR REPLACE view exu7vewc AS 
       SELECT vw.* from exu7vew vw, incexp i, incvid v
       WHERE vw.vname = i.name(+) AND vw.vownerid = i.owner#(+) AND 
             NVL(i.type,4) = 4 AND
             (NVL(i.ctime,TO_DATE('01-01-00','DD-MM-YY')) < i.itime OR 
              v.expid < NVL(i.expid, 9999))
/
rem current user's view
CREATE OR REPLACE view exu7vewu (vobjid,vname, vlen, vtext, vowner, vownerid,
		    vaudit, vcomment, vcname, vlevel) AS
       SELECT
	o$.obj#, o$.name, v$.textlength, v$.text, u$.name, o$.owner#, 
  	      v$.audit$, com$.comment$, 
	      DECODE(SUBSTR(c$.name,1,5), 'SYS_C', '', NVL(c$.name, '')),
	      d$.dlevel
       FROM sys.obj$ o$, sys.view$ v$, sys.user$ u$, sys.cdef$ cd$,
            sys.con$ c$, sys.com$ com$, exu7ordu d$
       WHERE v$.obj# = o$.obj# AND o$.owner# = u$.user# AND
	     o$.obj# = cd$.obj#(+) AND cd$.con# = c$.con#(+) AND 
             o$.obj# = com$.obj#(+) AND com$.col#(+) IS NULL AND
	     o$.obj# = d$.obj#
/
grant select on exu7vewu to public;

rem all synonyms
CREATE OR REPLACE view exu7syn (synnam, syntab, tabown, tabnode,
		        public$, synown, synownid, syntime) AS
       SELECT o$.name, s$.name, s$.owner, s$.node,
  	      DECODE(o$.owner#, 1, 1, 0),
   	      uo$.name, o$.owner#, TO_CHAR(o$.ctime, 'YYMMDDHH24MISS')
       FROM sys.obj$ o$, sys.syn$ s$, sys.user$ us$, sys.user$ uo$
       WHERE s$.obj# = o$.obj# AND o$.owner# = uo$.user# AND
	     s$.owner = us$.name(+)
/
rem synonyms for incremental export: new or last export not valid
CREATE OR REPLACE view exu7syni AS 
       SELECT s.* from exu7syn s, incexp i, incvid v
       WHERE s.synnam = i.name(+) AND s.synownid = i.owner#(+) AND 
             NVL(i.type,5) = 5 AND NVL(i.expid,9999) > v.expid
/	     
rem synonyms for cumulative export: new, last export was inc or not valid
CREATE OR REPLACE view exu7sync AS 
       SELECT s.* from exu7syn s, incexp i, incvid v
       WHERE  s.synnam  = i.name(+) AND s.synownid = i.owner#(+) AND 
              NVL(i.type,5) = 5 AND
	      (NVL(i.ctime,TO_DATE('01-01-00','DD-MM-YY')) < i.itime OR 
               NVL(i.expid,9999) > v.expid)
/
rem user's synnonyms
CREATE OR REPLACE view exu7synu AS
       SELECT * from exu7syn WHERE synownid = UID
/
grant select on exu7synu to public;

rem clustered tables' columns
CREATE OR REPLACE view exu7cco
                   (tname, towner, townerid, cluster$, tcolnam, seq) AS
       SELECT t$.name, u$.name, t$.owner#, c$.name, tc$.name, cc$.col#
       FROM sys.obj$ t$, sys.tab$ tab$, sys.obj$ c$,
	    sys.col$ tc$, sys.col$ cc$, sys.user$ u$
       WHERE t$.type = 2 AND t$.obj# = tab$.obj# AND
  	     tab$.clu# = cc$.obj# AND tab$.obj# = tc$.obj# AND 
             tab$.clu# = c$.obj# AND 
             cc$.segcol# = tc$.segcol# AND t$.owner# = u$.user#
/
rem current user's clustered tables' columns
CREATE OR REPLACE view exu7ccou AS
       SELECT * from exu7cco WHERE townerid = UID
/
grant select on exu7ccou to public;

rem all clusters
CREATE OR REPLACE view exu7clu 
                   (objid, owner, ownerid, name, tblspace, size$, fileno,
	            blockno, mtime, pctfree$, pctused$, initrans, maxtrans,
		    hashkeys, function, spare4, parallel, cache, 
		    functxt , funclen ) AS
       SELECT o$.obj#, u$.name, o$.owner#, o$.name, ts$.name, 
	      NVL(c$.size$, -1), c$.file#, c$.block#, o$.mtime, mod(c$.pctfree$, 100), 
              c$.pctused$, c$.initrans, c$.maxtrans, NVL(c$.hashkeys, 0), 
	      NVL(c$.func, 1), NVL(c$.spare4,-1), 
	      NVL(c$.spare5, 0), NVL(c$.spare6,0),
	      cd$.condition, cd$.condlength
       FROM sys.obj$ o$, sys.clu$ c$, sys.ts$ ts$, sys.user$ u$,
	    sys.cdef$ cd$
       WHERE o$.obj# = c$.obj# AND c$.ts# = ts$.ts# AND o$.owner# = u$.user#
	     AND cd$.obj#(+) = c$.obj# 
/
rem clusters for incremental export: new or last export invalid
rem altered cluster is now exported because its tables are also exported
CREATE OR REPLACE view exu7clui AS 
       SELECT c.* from exu7clu c,incexp i, incvid v
       WHERE c.name  = i.name(+) AND c.ownerid = i.owner#(+) AND
	    (c.mtime > i.itime OR NVL(i.expid,9999) > v.expid)
/	     
rem clusters for cumulative export: last export was inc or new
rem altered cluster is now exported because its tables are also exported
CREATE OR REPLACE view exu7cluc AS 
       SELECT c.* from exu7clu c,incexp i, incvid v
       WHERE c.name = i.name(+) AND c.ownerid = i.owner#(+) AND 
             NVL(i.type,3) = 3 AND
	      (i.itime > NVL(i.ctime,TO_DATE('01-01-00','DD-MM-YY'))
		OR c.mtime > i.itime OR NVL(i.expid,9999) > v.expid)
/
rem current user's clusters
CREATE OR REPLACE view exu7cluu AS
       SELECT * from exu7clu WHERE ownerid = UID
/
grant select on exu7cluu to public;

rem all storage parameters
CREATE OR REPLACE view exu7sto (ownerid, fileno, blockno, iniext, sext, minext,
                    maxext, pctinc, blocks, lists, groups, extents) AS
       SELECT user#, file#, block#, iniexts, extsize, minexts, maxexts, 
		extpct, blocks, decode(lists, NULL, 1, 65535, 1, lists),
	      decode(groups, NULL, 1, 65535, 1, groups), extents
       FROM sys.seg$
/ 

rem storage parameters for current user's segments
CREATE OR REPLACE view exu7stou AS
       SELECT * from exu7sto WHERE ownerid = UID
/
grant select on exu7stou to public;

rem find out correct size of second extent using uet$
CREATE OR REPLACE view exu7tne (fileno, blockno, length) AS
	SELECT segfile#, segblock#, length
	from uet$ where ext# = 1
/
grant select on exu7tne to public;

rem all tablespaces
CREATE OR REPLACE view exu7tbs 
                   (id, owner, name, isonline, content, iniext, sext, pctinc,
		    minext, maxext) AS
       SELECT ts$.ts#, 'SYSTEM', ts$.name, 
	      DECODE(mod(ts$.online$, 65536), 1, 'ONLINE', 
		4, 'ONLINE', 'OFFLINE'), 
	      DECODE(floor(ts$.online$ / 65536), 0, 'PERMANENT', 1,
		'TEMPORARY'),
	      ts$.dflinit,
   	      ts$.dflincr, ts$.dflextpct, ts$.dflminext, ts$.dflmaxext
       FROM sys.ts$ ts$ 
       WHERE ts$.online$ in (1, 2, 4) and ts$.ts# != 0
/

rem tablespace quotas
CREATE OR REPLACE view exu7tsq(tsname, tsid, uname, userid, maxblocks) AS
       SELECT t$.name, q$.ts#, u$.name, u$.user#, q$.maxblocks
       FROM  sys.ts$ t$, sys.tsq$ q$, sys.user$ u$
       WHERE  q$.user# = u$.user# AND q$.ts# = t$.ts# AND q$.maxblocks != 0
	    		AND t$.online$ in (1, 2, 4)
/

rem all files
CREATE OR REPLACE view exu7fil(fname, fsize, tsid) AS
       SELECT v$.name, f$.blocks, f$.ts#
       FROM   sys.file$ f$, sys.v$dbfile v$
       WHERE  f$.file# = v$.file#
/

rem all database links
CREATE OR REPLACE view exu7lnk 
                   (owner, ownerid, name, user$, passwd, host, public$) AS
       SELECT DECODE(l$.owner#, 1, 'SYSTEM', u$.name), l$.owner#, l$.name, 
              l$.userid, l$.password, l$.host, DECODE(l$.owner#, 1, 1, 0)
       FROM sys.user$ u$, sys.link$ l$
       WHERE u$.user# = l$.owner#
/
CREATE OR REPLACE view exu7lnku AS	    /* current user's database links */
       SELECT * from exu7lnk WHERE ownerid = UID
/
grant select on exu7lnku to public;

rem all rollback segments
CREATE OR REPLACE view exu7rsg 
                   (owner, name, space$, fileno , blockno, minext, public$) AS 
       SELECT 'SYSTEM', r$.name, ts$.name, r$.file#, r$.block#, s$.minexts,
   	      DECODE(r$.user#, 1, 1, 0)
       FROM sys.ts$ ts$, sys.undo$ r$, sys.seg$ s$
       WHERE r$.status$ != 1 AND r$.file# = s$.file# AND r$.block# = s$.block#
             AND s$.ts# = ts$.ts# and r$.us# != 0
/

rem info on deleted objects EXCEPT snapshots, snapshot logs
CREATE OR REPLACE view exu7del (owner, name, type, type#) AS 
       SELECT u$.name, i$.name, DECODE(i$.type, 2, 'TABLE', 3,
              'CLUSTER', 4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
              7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
             -1, 'TRIGGER', -4, 'PACKAGE BODY'), i$.type
       FROM sys.incexp i$, sys.user$ u$, sys.obj$ o$
       WHERE i$.owner# = u$.user#
             AND i$.type NOT IN (-2,-3)
             AND i$.owner# = o$.owner# (+) /* "+ 0" for sort-merge outer jn */
             AND i$.name   = o$.name (+)
             AND i$.type   = DECODE(o$.type (+), 12, -1, 11, -4, o$.type (+))
             AND o$.owner# is NULL AND o$.linkname is NULL
/

rem info on sequence number
CREATE OR REPLACE view exu7seq 
                   (owner, ownerid, name, objid, curval, minval, maxval, 
		    incr, cache, cycle, order$, audt) AS
       SELECT u.name, u.user#, o.name, o.obj#, s.highwater, s.minvalue, 
	      s.maxvalue, s.increment$, s.cache, s.cycle, s.order$, s.audit$
       FROM sys.obj$ o, sys.user$ u, sys.seq$ s
       WHERE o.obj# = s.obj# AND o.owner# = u.user#
/
CREATE OR REPLACE view exu7sequ AS 
       SELECT * from sys.exu7seq WHERE UID = ownerid
/
grant select on sys.exu7sequ to public;

rem contraints on table
CREATE OR REPLACE view exu7con 
                   (objid, owner, ownerid, tname, type, cname, cno, condition,
                    condlength, enabled) AS
       SELECT o.obj#, u.name, c.owner#, o.name, cd.type, c.name,
              c.con#, cd.condition, cd.condlength, NVL(cd.enabled,0)
       FROM sys.obj$ o, sys.user$ u, sys.con$ c, sys.cdef$ cd
       WHERE u.user# = c.owner# AND o.obj# = cd.obj# AND cd.con# = c.con#
/
CREATE OR REPLACE view exu7conu AS 
       SELECT * from sys.exu7con WHERE UID = ownerid
/
grant select on sys.exu7conu to public;

rem referential constraints
CREATE OR REPLACE view exu7ref 
                   (objid, owner, ownerid, tname, rowner, rtname, cname, cno,
	            rcno, action, enabled) AS
       SELECT o.obj#, u.name, c.owner#, o.name, ru.name, ro.name, 
              DECODE(SUBSTR(c.name, 1, 5), 'SYS_C', '', NVL(c.name, '')),
	      c.con#, cd.rcon#, NVL(cd.refact,0), NVL(cd.enabled,0)
       FROM sys.user$ u, sys.user$ ru, sys.obj$ o, sys.obj$ ro, 
            sys.con$ c, sys.cdef$ cd
       WHERE u.user# = c.owner# AND o.obj# = cd.obj# AND ro.obj# = cd.robj# AND
             cd.con# = c.con# AND cd.type = 4 AND ru.user# = ro.owner#
/
CREATE OR REPLACE view exu7refu AS SELECT * from sys.exu7ref WHERE UID = ownerid
/
grant select on sys.exu7refu to public;
rem referential constraints for incremental and cumulative export
rem for tables just exported, i.expid will be greater than v.expid
rem as v.expid is incremented only at the end of the incremental export
rem but i.expid is incremented when the table is exported.
rem USED ONLY WHEN RECROD = YES
CREATE OR REPLACE view exu7refic AS
       SELECT * from sys.exu7ref 
       WHERE (ownerid, tname) in 
             (SELECT i.owner#, i.name 
              FROM sys.incexp i, sys.incvid v
              WHERE i.expid > v.expid AND i.type = 2)
/
rem referential constraints for incremental export
rem exutabi will return the correct table name because RECORD = NO
CREATE OR REPLACE view exu7refi AS
       SELECT * from sys.exu7ref
       WHERE (ownerid, tname) in (SELECT ownerid, name from sys.exu7tabi)
/
rem referential constraints for cumulative export, assuming
rem exutabc will return the correct table name because RECORD = NO
CREATE OR REPLACE view exu7refc AS
       SELECT * from sys.exu7ref
       WHERE (ownerid, tname) in (SELECT ownerid, name from sys.exu7tabc)
/

rem contraint column list
CREATE OR REPLACE view exu7ccl (ownerid, cno, colname, colno) AS
       SELECT o.owner#, cc.con#, c.name, cc.pos#
       FROM sys.obj$ o, sys.col$ c, sys.ccol$ cc
       WHERE o.obj# = cc.obj# AND c.obj# = cc.obj# AND cc.col# = c.col#
/
CREATE OR REPLACE view exu7cclu AS
       SELECT * from sys.exu7ccl WHERE UID = ownerid
/
grant select on sys.exu7cclu to public
/
CREATE OR REPLACE view exu7cclo (ownerid, cno, colname, colno) AS
	SELECT a.ownerid, a.cno, a.colname, a.colno
	from sys.exu7ccl a, sys.con$ b , sys.cdef$ c
	WHERE b.owner#=UID
	AND   b.con# = c.con#
	AND   c.rcon# = a.cno
/
grant select on sys.exu7cclo to public
/
rem triggers
CREATE OR REPLACE view exu7tgr 
                   (ownerid, owner, baseobject, definition, whenclause, 
	            actionsize, action, enabled, name, basename) AS
        SELECT o.owner#, u.name, t.baseobject, t.definition, t.whenclause, 
	       t.actionsize, t.action, t.enabled, o.name, o2.name
        FROM sys.obj$ o, sys.trigger$ t, sys.user$ u, sys.obj$ o2
        WHERE o.obj# = t.obj# AND u.user# = o.owner# AND
	      o2.obj# = t.baseobject
/
CREATE OR REPLACE view exu7tgru AS
        SELECT * from sys.exu7tgr WHERE UID = ownerid
/
grant select on sys.exu7tgru to public
/
rem triggers for incremental and cumulative export for table just 
rem exported.  See comment on exu7refic.
CREATE OR REPLACE view exu7tgric as 
	SELECT * from sys.exu7tgr 
	WHERE (ownerid, basename) in
             (SELECT i.owner#, i.name
              from sys.incexp i, sys.incvid v
              WHERE i.expid > v.expid AND i.type = 2)
/
rem triggers for incremental export: record=no
CREATE OR REPLACE view exu7tgri as 
       SELECT * from sys.exu7tgr
	WHERE (ownerid, basename) in (SELECT ownerid, name from sys.exu7tabi)
/
rem triggers for cumulative export: record=no
CREATE OR REPLACE view exu7tgrc as 
       SELECT * from sys.exu7tgr 
	WHERE (ownerid, basename) in (SELECT ownerid, name from sys.exu7tabc)
/
CREATE OR REPLACE view exu7spr(ownerid, uname, id, name, time, typeid, type,
	 audt) AS
   SELECT o.owner#, u.name, o.obj#, o.name, 
	  TO_CHAR(o.mtime, 'YYYY-MM-DD:HH24:MI:SS'), o.type,
          DECODE(o.type, 7, 'PROCEDURE', 8, 'FUNCTION', 
	         9, 'PACKAGE', 11, 'PACKAGE BODY'), p.audit$
   FROM sys.obj$ o, sys.user$ u, sys.procedure$ p
   WHERE o.owner# = u.user# AND (o.type=7 OR o.type=8 OR o.type=9 OR o.type=11)
	AND o.obj# = p.obj#
/
CREATE OR REPLACE view exu7spu(ownerid, uname, id, name, time, typeid, type,
	audt) AS
   SELECT * from sys.exu7spr WHERE UID = ownerid
/
grant select on sys.exu7spu to public
/
rem stored procedures for incremental export: modified, altered or new
CREATE OR REPLACE view exu7spri AS
       SELECT s.* from exu7spr s,incexp i, incvid v
       WHERE s.name  = i.name(+) AND s.ownerid = i.owner#(+) AND
             NVL(i.type,7) = 7 AND
             NVL(i.expid,9999) > v.expid
/
rem stored procedures for incremental export: modified, altered or new
CREATE OR REPLACE view exu7sprc AS
       SELECT s.* from exu7spr s,incexp i, incvid v
       WHERE s.name  = i.name(+) AND s.ownerid = i.owner#(+) AND
             NVL(i.type,7) = 7 AND
(NVL(i.ctime,TO_DATE('01-01-00','DD-MM-YY')) < i.itime OR
               NVL(i.expid,9999) > v.expid)
/
CREATE OR REPLACE view exu7sps(obj#, line, source) AS
   SELECT obj#,line,source 
   FROM sys.source$ 
/
CREATE OR REPLACE view exu7spsu(obj#, line, source) AS
   SELECT s.obj#, s.line, s.source
   FROM sys.source$ s, sys.obj$ o
   WHERE s.obj# = o.obj# and o.owner# = UID
/
grant select on sys.exu7spsu to public
/
rem system auditting options
CREATE OR REPLACE view exu7aud (userid, name, action, success, failure) AS
	SELECT a.user#, u.name, m.name, NVL(a.success,0), NVL(a.failure,0)
	FROM sys.audit$ a, sys.user$ u, sys.stmt_audit_option_map m
	WHERE a.user# = u.user# AND a.option# = m.option#
/
rem profiles
CREATE OR REPLACE view exu7prf(profile#, name) AS
	SELECT profile#, name 
	FROM sys.profname$
	WHERE profile# != 0
/
CREATE OR REPLACE view exu7prr(profile#, resname, limit) AS
	SELECT profile#, DECODE(resource#,
		0, 'COMPOSITE_LIMIT',
		1, 'SESSIONS_PER_USER',
		2, 'CPU_PER_SESSION',
		3, 'CPU_PER_CALL',
		4, 'LOGICAL_READS_PER_SESSION',
		5, 'LOGICAL_READS_PER_CALL',
		6, 'IDLE_TIME',
		7, 'CONNECT_TIME',
		8, 'PRIVATE_SGA', 'UNDEFINED'), limit
	FROM sys.profile$
	WHERE resource# != 9 and type = 0
/
rem snapshots
CREATE OR REPLACE view exu7snap
( OWNER, OWNERID, NAME, TABLE_NAME, MASTER_VIEW, MASTER_OWNER, MASTER, 
  MASTER_LINK, CAN_USE_LOG, LAST_REFRESH, ERROR, TYPE, NEXT, START_WITH, QUERY,
  UPDATABLE, UPDATE_TRIG, UPDATE_LOG)
as
SELECT sowner, u.user#, vname, tname, mview, mowner, master, mlink,
       decode(can_use_log, null, 'NO', 'YES'), 
       snaptime, error#, 
       decode(auto_fast, 
              'C', 'COMPLETE', 
              'F', 'FAST', 
              '?', 'FORCE', 
              null, 'FORCE', 'ERROR'), 
       auto_fun, auto_date, query_txt, mod(trunc(flag/2),2), ustrg, uslog
from sys.snap$ s, sys.user$ u
WHERE u.name = s.sowner
/
CREATE OR REPLACE view exu7snapu
( OWNER, OWNERID, NAME, TABLE_NAME, MASTER_VIEW, MASTER_OWNER, MASTER, 
  MASTER_LINK, CAN_USE_LOG, LAST_REFRESH, ERROR, TYPE, NEXT, START_WITH, QUERY,
  UPDATABLE, UPDATE_TRIG, UPDATE_LOG)
as
SELECT sowner, u.user#, vname, tname, mview, mowner, master, mlink,
       decode(can_use_log, null, 'NO', 'YES'), 
       snaptime, error#, 
       decode(auto_fast, 
              'C', 'COMPLETE', 
              'F', 'FAST', 
              '?', 'FORCE', 
              null, 'FORCE', 'ERROR'), 
       auto_fun, auto_date, query_txt, mod(trunc(flag/2),2), ustrg, uslog
from sys.snap$ s, sys.user$ u
WHERE u.name = s.sowner
and UID = u.user#
/
grant SELECT on sys.exu7snapu to public;

rem snapshots for incremental export: modified, altered or new
CREATE OR REPLACE view exu7snapi AS
        SELECT s.* from exu7snap s,incexp i, incvid v
       WHERE s.name  = i.name(+) AND s.ownerid = i.owner#(+) AND
             NVL(i.type,-2) = -2 AND
             NVL(i.expid,9999) > v.expid
/
rem snapshots for cumulative export: new, last export was inc or not valid
CREATE OR REPLACE view exu7snapc AS
       SELECT s.* from exu7snap s, incexp i, incvid v
       WHERE  s.name  = i.name(+) AND s.ownerid = i.owner#(+) AND
              NVL(i.type,-2) = -2 AND
              (NVL(i.ctime,TO_DATE('01-01-00','DD-MM-YY')) < i.itime OR
               NVL(i.expid,9999) > v.expid)
/
rem snapshot logs
CREATE OR REPLACE view exu7snapl
( LOG_OWNER, LOG_OWNERID, MASTER, LOG_TABLE, LOG_TRIGGER)
as
SELECT m.mowner, u.user#, m.master, m.log, m.trig
from sys.mlog$ m, sys.user$ u
WHERE m.mowner = u.name
/

CREATE OR REPLACE view exu7snaplu
( LOG_OWNER, LOG_OWNERID, MASTER, LOG_TABLE, LOG_TRIGGER)
as
SELECT m.mowner, u.user#, m.master, m.log, m.trig
from sys.mlog$ m,  sys.user$ u
WHERE  m.mowner = u.name
  and UID = u.user#
/
grant SELECT on sys.exu7snaplu to public;

rem snapshot logs for incremental export: modified, altered or new
CREATE OR REPLACE view exu7snapli AS
        SELECT s.* from exu7snapl s,incexp i, incvid v
       WHERE s.master  = i.name(+) AND s.log_ownerid = i.owner#(+) AND
             NVL(i.type,-3) = -3 AND
             NVL(i.expid,9999) > v.expid
/
rem snapshot logs for cumulative export: new, last export was inc or not valid
CREATE OR REPLACE view exu7snaplc AS
       SELECT s.* from exu7snapl s, incexp i, incvid v
       WHERE s.master  = i.name(+) AND s.log_ownerid = i.owner#(+) AND
              NVL(i.type,-3) = -3 AND
              (NVL(i.ctime,TO_DATE('01-01-00','DD-MM-YY')) < i.itime OR
               NVL(i.expid,9999) > v.expid)
/

rem info on deleted snapshots -- they aren't in obj$
CREATE OR REPLACE view exu7delsnap (owner, name, type) as
       SELECT u$.name, i$.name, 'SNAPSHOT'
       from sys.incexp i$, sys.user$ u$
       WHERE i$.owner# = u$.user# and
	     i$.type = -2 and
             (u$.name, i$.name)
             NOT IN (SELECT s$.sowner, s$.vname
 			from sys.snap$ s$)
/
rem info on deleted snapshot logs -- they aren't in obj$
CREATE OR REPLACE view exu7delsnapl (owner, name, type) as
       SELECT u$.name, i$.name, 'SNAPSHOT LOG'
       from sys.incexp i$, sys.user$ u$
       WHERE i$.owner# = u$.user# and
	     i$.type = -3 and
             (u$.name, i$.name)
             NOT IN (SELECT m$.mowner, m$.master
 			from sys.mlog$ m$)
/

rem info on analyzed objects
CREATE OR REPLACE view exu7anal(id,rowcnt) as
	select obj#, NVL(rowcnt,-1) from sys.tab$;
grant select on exu7anal to public
/

rem add a view to determine storage clause for unique constraint
rem need for it to be user level because two different users can have the
rem same index name 
CREATE OR REPLACE view exu7uscu 
(iobjid, iname, ifileno, iblockno, ibobjid, tspname) as
	SELECT o$.obj#, o$.name, i$.file#, i$.block#, i$.bo#, t$.name
	from sys.obj$ o$, sys.ind$ i$, sys.file$ f$, sys.ts$ t$
	where o$.obj# = i$.obj# and unique$ = 1 and f$.file#=i$.file#
	and f$.ts# = t$.ts#
/
grant select on sys.exu7uscu to public; 

rem referential constraints
CREATE OR REPLACE view exu7rif 
                   (objid, owner, ownerid, tname, rowner, rtname, cname, cno,
	            rcno, action, enabled, robjid) AS
       SELECT o.obj#, u.name, c.owner#, o.name, ru.name, ro.name, 
              DECODE(SUBSTR(c.name, 1, 5), 'SYS_C', '', NVL(c.name, '')),
	      c.con#, cd.rcon#, NVL(cd.refact,0), NVL(cd.enabled,0),
	      cd.robj#
       FROM sys.user$ u, sys.user$ ru, sys.obj$ o, sys.obj$ ro, 
            sys.con$ c, sys.cdef$ cd
       WHERE u.user# = c.owner# AND o.obj# = cd.obj# AND ro.obj# = cd.robj# AND
             cd.con# = c.con# AND cd.type = 4 AND ru.user# = ro.owner#
/
CREATE OR REPLACE view exu7erc
		(resource_name, unit_cost) as
		SELECT m.name, c.cost 
		FROM sys.resource_cost$ c, sys.resource_map m 
		WHERE c.resource# = m.resource#
			AND c.resource# in (2, 4, 7, 8)
/

REM
REM Job Queues
REM
CREATE OR REPLACE view exu7jbq
	        (job, ownerid, owner) as
		SELECT j$.job, u$.user#, j$.powner
		FROM sys.job$ j$, sys.user$ u$
		WHERE j$.powner = u$.name
/

CREATE OR REPLACE view exu7jbqu 
		(job, ownerid, owner) as
		SELECT * FROM sys.exu7jbq 
		WHERE uid = ownerid
/
grant select on exu7jbqu to public
/
REM
REM Refresh Groups
REM
CREATE OR REPLACE view exu7rgs 
		(refgroup, ownerid, owner) as
		SELECT r$.refgroup, u$.user#, r$.owner
		FROM sys.rgroup$ r$, sys.user$ u$
		WHERE r$.owner = u$.name
/

CREATE OR REPLACE view exu7rgsu
		(refgroup, ownerid, owner) as
		SELECT * from sys.exu7rgs
		WHERE uid = ownerid
/
grant select on exu7rgsu to public
/
REM
REM Refresh Group Children
REM
CREATE OR REPLACE view exu7rgc
		(owner, ownerid, child, type, refgroup) as
		SELECT rc$.owner, u$.user#, rc$.name, rc$.type, rc$.refgroup
		FROM sys.rgchild$ rc$, sys.user$ u$
		WHERE rc$.owner = u$.name
/

CREATE OR REPLACE view exu7rgcu
		(owner, ownerid,  child, type, refgroup) as
		SELECT * from sys.exu7rgc
		WHERE uid = ownerid
/
grant select on exu7rgcu to public
/
REM
REM PoSTtables actions 
REM
/
CREATE OR REPLACE view exu7pst
		(owner, ownerid, tname, tobjid, callorder) as
		SELECT a$.owner, u$.user#, a$.name, o$.obj#, a$.callorder
		FROM sys.expact$ a$, sys.user$ u$, sys.obj$ o$
		WHERE u$.name = a$.owner and o$.owner# = u$.user#
		      and o$.name = a$.name 
/

CREATE OR REPLACE view exu7pstu
		(owner, ownerid, tname, tobjid, callorder) as
		SELECT * from sys.exu7pst
	        where ownerid = uid
/
grant select on exu7pstu to public
/

REM PoSTtables actions incremental/cumulative with record = Y
CREATE OR REPLACE view exu7pstic
		(owner, ownerid, tname, tobjid, callorder) as
		SELECT * from sys.exu7pst
		WHERE (ownerid, tname) in
	        (SELECT i.owner#, i.name
                 FROM sys.incexp i, sys.incvid v
                 WHERE i.expid > v.expid AND i.type = 2)
/
REM PoSTtables actions for incremental export : record = N
CREATE OR REPLACE view exu7psti as
		SELECT * from sys.exu7pst
		WHERE (ownerid, tname) in 
		(SELECT ownerid, name from sys.exu7tabi)
/
REM PoSTtables actions for cumulative  export : record = N
CREATE OR REPLACE view exu7pstc as
		SELECT * from sys.exu7pst
		WHERE (ownerid, tname) in 
		(SELECT ownerid, name from sys.exu7tabc)
/

REM Version Control
CREATE OR REPLACE view exu7ver (version) AS
	        SELECT TO_NUMBER(value$) from sys.props$
		WHERE name = 'EXPORT_VIEWS_VERSION'
/
grant select on exu7ver to public
/
REM Database Character Set
CREATE OR REPLACE view exu7cset (value) AS
                SELECT value$ from sys.props$
                WHERE name = 'NLS_CHARACTERSET'
/
grant select on exu7cset to public
/
REM Check for Procedural Option
CREATE OR REPLACE view exu7cpo (value) AS
		SELECT DECODE(value, 'TRUE', 1, 'FALSE', 0, 2) 
		FROM v$option
		WHERE parameter = 'procedural'
/
grant select on exu7cpo to public
/
REM
REM Add versioning support for export
REM This will get bumped up as the views evolve. The insert is needed
REM for upgrades from 7.0 or new databases. The update is needed for 
REM databases that have older compatibility.
REM These are the releases when the compatibility was bumped:
REM    7.0.* - no compatibility - assume zero
REM    7.1.3 - set to one
REM    7.2.1 - set to two
REM    7.2.3 - set to three
REM
insert into props$ 
select 'EXPORT_VIEWS_VERSION', '3', 'Export views revision #' from dual
where not exists
  (select 'x' from props$ where name = 'EXPORT_VIEWS_VERSION')
/
update props$ set value$ = 3 where name = 'EXPORT_VIEWS_VERSION'
/
commit
/

