rem 
rem $Header: cat7301d.sql,v 1.10 1996/01/04 13:26:31 cracicot Exp $ 
rem 
Rem  Copyright (c) 1995 by Oracle Corporation 
Rem    NAME
Rem      cat7301d.sql - Downgrade Oracle RDBMS from 7.3 to 7.2.X
Rem    DESCRIPTION
Rem
Rem    RETURNS
Rem 
Rem    NOTES
Rem      Run this as INTERNAL.
Rem    MODIFIED   (MM/DD/YY)
Rem     cracicot   12/06/95 -  mark all pl/sql objects invalid
Rem     hasun      10/10/95 -  Drop procedural replication wrappers
Rem     kmuthukk   08/25/95 -  drop plsql:plitblm package on downgrade
Rem     bhimatsi   06/20/95 -  add downgrade sql for removing truncation
Rem			       count from overloaded pctfree column
Rem     hasun      05/09/95 -  Remove "server output on"
Rem     mramache   05/01/95 -  stored trigger downgrade fixup
Rem     hasun      04/21/95 -  Change $RTS -> $ST
Rem     rmarimon   04/06/95 -  Bug 110894: downgrade changes to dependency$
Rem     hasun      03/22/95 -  Downgrade from Sync Replication
Rem     hasun      03/10/95 -  Add replication downgrade
Rem     glumpkin   01/18/95 -  Creation
 

rem  Delete all histogram data

truncate table hist_head$;
delete from histgrm$;
commit;
alter system flush shared_pool;

--- Remove constraints new to Rep3
ALTER TABLE system.repcat$_repobject 
  DROP CONSTRAINT repcat$_repobject_prnt
/
ALTER TABLE system.repcat$_repobject
  DROP CONSTRAINT repcat$_repobject_type
/
ALTER TABLE system.repcat$_generated
  DROP CONSTRAINT repcat$_generated_obj
/
ALTER TABLE system.repcat$_repcatlog
  DROP CONSTRAINT repcat$_repcatlog_request
/
ALTER TABLE system.repcat$_repcatlog
  DROP CONSTRAINT repcat$_repcatlog_type
/
ALTER TABLE system.repcat$_repcatlog
  DROP CONSTRAINT repcat$_repcatlog_status
/

--- Delete all $ST triggers ONLY AT MASTER SITES
DECLARE
  sql_cursor NUMBER;
  rows       NUMBER;
  CURSOR rtstrigs IS
    SELECT g.sname, g.oname, g.type 
    FROM system.repcat$_generated g, 
         system.repcat$_repobject o,
         system.repcat$_repcat c
    WHERE g.oname LIKE '%$ST' AND 
          g.type = 12  AND --- trigger
          g.reason = 0 AND --- replication trigger
          g.sname = o.sname AND g.oname = o.oname AND g.type = o.type AND
          o.gname = c.sname AND c.master = 'Y';
BEGIN
  FOR r IN rtstrigs LOOP
    BEGIN
      --- Delete RepCat entries
      DELETE FROM system.repcat$_generated
        WHERE sname = r.sname AND oname = r.oname AND type = r.type;
      DELETE FROM system.repcat$_repobject
        WHERE sname = r.sname AND oname = r.oname AND type = r.type;
    EXCEPTION WHEN others THEN NULL;
    END;

    BEGIN
      --- Delete $ST trigger       
      sql_cursor := dbms_sql.open_cursor;
      dbms_sql.parse(sql_cursor,    
        'DROP TRIGGER "' || r.sname || '"."' || r.oname || '"',
        dbms_sql.v7);
      rows := dbms_sql.execute(sql_cursor);
      dbms_sql.close_cursor(sql_cursor); 
    EXCEPTION WHEN OTHERS THEN
      IF dbms_sql.is_open(sql_cursor) THEN
        dbms_sql.close_cursor(sql_cursor);
      END IF;
    END;
  END LOOP;
  COMMIT;
END;
/
--- Convert Object Groups to Repschema when possible:
DECLARE
  CURSOR repgrps IS    --- list of object groups
    SELECT sname 
    FROM system.repcat$_repcat;
  schema VARCHAR2(30); --- schema associated with object group (if any)
BEGIN
  FOR g IN repgrps LOOP
    BEGIN
      --- determine if current group has a corresponding schema
      SELECT username INTO schema FROM dba_users
      WHERE username = g.sname;

      --- drop all repobject not in corresponding schema
      FOR o IN (SELECT sname, oname, type FROM dba_repobject
                WHERE gname = g.sname AND sname != schema) LOOP
        BEGIN
          dbms_repcat.drop_master_repobject(o.sname, o.oname, o.type);
          COMMIT;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
      END LOOP;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        --- The object group has no corresponding schema
        IF dbms_repcat_utl.is_master(g.sname) OR 
           dbms_repcat_utl.is_masterdef(g.sname) THEN
          dbms_repcat.drop_master_repgroup(g.sname);
        ELSE --- is_snapshot
          dbms_repcat.drop_snapshot_repgroup(g.sname);
        END IF;
      WHEN OTHERS THEN NULL;
    END;
  END LOOP;
  COMMIT;
END;
/
--- Delete all $TP packages
DECLARE
  sql_cursor NUMBER;
  rows       NUMBER;
  CURSOR tppkgs IS
    SELECT g.sname, g.oname, g.type 
    FROM system.repcat$_generated g 
    WHERE g.oname LIKE '%$TP' AND 
          (g.type = 9 or g.type = 11) AND --- package or body
          g.reason = 6;                   --- trigger package
BEGIN
  FOR t IN tppkgs LOOP
    BEGIN
      --- Delete RepCat entries
      DELETE FROM system.repcat$_generated
        WHERE sname = t.sname AND oname = t.oname AND type = t.type;
      DELETE FROM system.repcat$_repobject
        WHERE sname = t.sname AND oname = t.oname AND type = t.type;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    BEGIN
      --- Delete $TP package
      IF t.type = 9 THEN
        sql_cursor := dbms_sql.open_cursor;
        dbms_sql.parse(sql_cursor,    
          'DROP PACKAGE"' || t.sname || '"."' || t.oname || '"',
          dbms_sql.v7);
        rows := dbms_sql.execute(sql_cursor);
        dbms_sql.close_cursor(sql_cursor); 
      END IF;
    EXCEPTION WHEN others THEN
      IF dbms_sql.is_open(sql_cursor) THEN
        dbms_sql.close_cursor(sql_cursor);
      END IF;
    END;
  END LOOP;
  COMMIT;
END;
/

--- Delete all procedural replication wrappers
DECLARE
  sql_cursor NUMBER;
  rows       NUMBER;
  CURSOR procwraps IS
     SELECT g.sname, g.oname, g.type,
            DECODE(g.type, 7, 'PROCEDURE', 9, 'PACKAGE', 
                           11, 'PACKAGE BODY') canon_type
     FROM system.repcat$_generated g
     WHERE g.type IN (7,9,11) AND  --- procedure, package, or package body
           g.reason = 5;           --- procedural replication wrapper
BEGIN
  FOR wrapper IN procwraps LOOP
    BEGIN
      --- Delete wrappers
      sql_cursor := dbms_sql.open_cursor;
       dbms_sql.parse(sql_cursor,    
         'DROP ' || wrapper.canon_type ||
           ' "' || wrapper.sname || '"."' || wrapper.oname || '"',
         dbms_sql.v7);

      rows := dbms_sql.execute(sql_cursor);

      DELETE FROM system.repcat$_repobject
        WHERE sname = wrapper.sname AND oname = wrapper.oname 
          AND type = wrapper.type;
      --- repcat$_generated and repcat$_repprop both have an ON DELETE CASCADE
      --- referential constraint to repcat$_repobject

      dbms_sql.close_cursor(sql_cursor); 
    EXCEPTION WHEN others THEN
      IF dbms_sql.is_open(sql_cursor) THEN
        dbms_sql.close_cursor(sql_cursor);
      END IF;
    END;
    COMMIT;
  END LOOP;
END;
/

--- Reset reason for $RT triggers
UPDATE system.repcat$_generated
  SET reason = 0 WHERE reason = 7;

--- Reset Rep2 constraints
ALTER TABLE system.repcat$_repprop
  ADD CONSTRAINT repcat$_repprop_prnt2
      FOREIGN KEY(sname, dblink)
      REFERENCES system.repcat$_repschema(sname, dblink)
        ON DELETE CASCADE
/
ALTER TABLE system.repcat$_resolution
  ADD CONSTRAINT repcat$_resolution_f2
      FOREIGN KEY (priority_group, sname)
      REFERENCES system.repcat$_priority_group
/
ALTER TABLE system.repcat$_repobject
  ADD CONSTRAINT repcat$_repobject_prnt FOREIGN KEY(sname)
      REFERENCES system.repcat$_repcat(sname)
        ON DELETE CASCADE
/
ALTER TABLE system.repcat$_repobject
  ADD  CONSTRAINT repcat$_repobject_type
       CHECK (type IN (-1, 1, 2, 4, 5, 7, 8, 9, 11, 12))
/
ALTER TABLE system.repcat$_generated
  ADD CONSTRAINT repcat$_generated_obj
      CHECK (reason IN (0, 1, 2, 3, 4, 5))
/
ALTER TABLE system.repcat$_repcatlog
  ADD CONSTRAINT repcat$_repcatlog_request
      CHECK (request IN (-1, 0, 1, 2, 3, 4, 5, 6, 7, 8))
/
ALTER TABLE system.repcat$_repcatlog
  ADD CONSTRAINT repcat$_repcatlog_type
      CHECK (type IN (-1, 0, 1, 2, 4, 5, 7, 8, 9, 11, 12))
/
ALTER TABLE system.repcat$_repcatlog
  ADD CONSTRAINT repcat$_repcatlog_status
      CHECK (status IN (0, 1, 2, 3))
/

--- Remove *_repgroup views
DROP VIEW sys.dba_repgroup;
DROP VIEW sys.all_repgroup;
DROP VIEW sys.user_repgroup;
/

--- Remove all indications of synchronous propagation from RepCat
UPDATE system.repcat$_repschema
  SET prop_updates=0
/
UPDATE system.repcat$_repprop 
  SET how = 1 WHERE how > 1
/

rem
rem Bug 110894: modify d_owner# to allow nulls since earlier release do
rem not use this column
rem

ALTER TABLE dependency$ MODIFY (d_owner# number CONSTRAINT n_d_owner# NULL)
/
COMMIT
/

rem
rem Dependency information is stored for triggers in release 7.3 and above.
rem This causes a problem for the DROP TABLE operation when a table's trigger  
rem is stored in compiled form and the drop table is issued in a pre-7.3
rem release. To prevent problems, all trigger dependencies are deleted 
rem during the downgrade and the triggers are marked invalid. 

DELETE FROM dependency$ WHERE d_obj# IN (SELECT obj# FROM obj$ WHERE type = 12)
/

COMMIT
/

UPDATE obj$ SET status = 5 WHERE type = 12
/

COMMIT
/ 

--- Drop PL/sql Index-TaBLe Methods (plitblm) package.
--- Also, mark all pl/sql objects invalid.

DROP PUBLIC  synonym plitblm;
DROP PACKAGE sys.plitblm;
UPDATE obj$ SET status = 5 WHERE type=7 OR type=8 OR type=9 OR type=11
/

COMMIT
/

rem lets remove the truncation values from tab$ and clu$ so that users can
rem downgrade to 7.2.X from 7.3.Y

UPDATE tab$ SET pctfree$ = mod(pctfree$, 100)
/
UPDATE clu$ SET pctfree$ = mod(pctfree$, 100)
/
COMMIT
/
alter system flush shared_pool;
