rem
rem
Rem  Copyright (c) 1995, 1996 by Oracle Corporation. All rights reserved.
Rem    NAME
Rem      browse.sql - package for browsing an Oracle database.
Rem    DESCRIPTION
Rem      This file contains one package:
Rem         browse    - A series of procedures built on the htp, htf,
Rem                       and owa_util packages which allow easy access
Rem                       to Oracle data.
Rem
Rem    NOTES
Rem      This should be run in SQL*DBA, not SQL*Plus.
Rem      To run this in SQL*Plus, uncomment the "set define off" below.
Rem
Rem      The Oracle Web Agent is needed to use these facilities.
Rem      The package owa is needed to use these facilities.
Rem      The packages htp and htf are needed to use these facilities.
Rem
Rem      Privileges required to run this as it is intended:
Rem        DBA, SELECT ANY TABLE, CREATE ANY PROCEDURE, EXECUTE ANY PROCEDURE
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     mbookman   12/19/95 -  Incorporated owa_browser knowledge base
Rem     mbookman   07/09/95 -  Creation

Rem set define off

@@objwbkb.sql
@@pubwbkb.sql
@@privwbkb.sql

REM Creating EXTENT_MAP view...
create or replace view EXTENT_MAP as
   select owner, segment_name, segment_type,
          to_char(extent_id) extent_id, file_id, block_id, blocks, bytes,
          tablespace_name 
      from dba_extents
   union
   select 'FREE','FREE','FREE',
          'FREE', file_id, block_id, blocks, bytes,
          tablespace_name
      from dba_free_space
/
REM Creating LOG_VIEW view...
create or replace view LOG_VIEW as
   select l.thread#, l.group#, l.sequence#, l.bytes, lf.member file_name,
          l.status group_status, l.archived, lf.status file_status
   from v$log l, v$logfile lf
  where l.group# = lf.group#
/


REM Creating BROWSE package...
create or replace package BROWSE is

   procedure intro;
   procedure browser_setup;
   procedure browser_test;
   procedure register_and_list(ntable_type in integer);
   procedure list(ntable_type in integer DEFAULT owa_util.html_table);
   procedure tabs_and_views(ntable_type in integer DEFAULT owa_util.html_table);
   procedure show_source(cname in varchar2);
   procedure pl_sql(ntable_type in integer DEFAULT owa_util.html_table);
   procedure table_columns(ctable      in varchar2,
                           ntable_type in integer  DEFAULT owa_util.html_table);
   procedure table_browse_c (ctable      in varchar2,
                             ntable_type in integer DEFAULT owa_util.html_table,
                             cols        in owa_util.ident_arr);
   procedure user_tnv(cuser       in varchar2,
                      ntable_type in integer DEFAULT owa_util.html_table);
   procedure user_plsql(cuser in varchar2);
             
   procedure table_browse (ctable      in varchar2,
                           ntable_type in integer  DEFAULT owa_util.html_table,
                           ccolumns    in varchar2 DEFAULT '*',
                           cclauses    in varchar2 DEFAULT NULL,
                           nrow_min    in integer  DEFAULT 0,
                           nrow_max    in integer  DEFAULT NULL,
                           cbutton     in varchar2 DEFAULT NULL);
   procedure users(ntable_type in integer DEFAULT owa_util.html_table);
   procedure sessions(ntable_type in integer DEFAULT owa_util.html_table);
   procedure rollback_segs(ntable_type in integer DEFAULT owa_util.html_table);
   procedure datafiles(ntable_type in integer DEFAULT owa_util.html_table);
   procedure space_usage(ntable_type in integer DEFAULT owa_util.html_table);
   procedure freespace_usage(ntable_type in integer
                                                DEFAULT owa_util.html_table);
   procedure tablespace_usage(ctablespace_name in varchar2,
                              ntable_type in integer DEFAULT owa_util.html_table);

end;
/
show errors

REM Creating BROWSE package body...
create or replace package body BROWSE is

  procedure register_browser_table_support(support in integer) is
  begin
     if (support = owa_util.html_table)
     then
        owa_browsers.set_attribute('HTML_TABLES', 'Y');
     else
        owa_browsers.set_attribute('HTML_TABLES', 'N');
     end if;
  end;

  -- BROWSER_SUPPORTS_TABLES will return 
  --   NULL if it cannot determine HTML table support
  function browser_supports_tables return boolean is
     table_support varchar2(1);
  begin 
     table_support := owa_browsers.get_attribute('HTML_TABLES');

     if (table_support is NULL)
     then
        return NULL;
     else if (table_support in ('y','Y'))
     then
        return TRUE;
     else
        return FALSE;
     end if;
     end if;
  end;

  procedure print_button_bar is
  begin
      htp.nl;
      htp.line;
      htp.print(
          htf.anchor('/ows-adoc/Intro.html',
             htf.img('/ows-img/navadm.gif',NULL,'Administration'))||
          htf.anchor(owa_util.get_owa_service_path||
                     'browse.intro',
             htf.img('/ows-img/navbrws.gif',NULL,'Browse'))||
          htf.anchor('/ows-doc/index.html',
             htf.img('/ows-img/navhome.gif',NULL,'OWS Home'))
               );
  end;

  procedure intro is
     supports_tables boolean;
  begin
     supports_tables := browser_supports_tables;

     if (supports_tables is NULL)
     then
        browser_setup;
     else
        if (supports_tables = TRUE)
        then
           list(owa_util.html_table);
        else
           list(owa_util.pre_table);
        end if;
     end if;
  end;

  procedure browser_setup is
  begin
     htp.htmlOpen;
     htp.headOpen;
     htp.title('Oracle WebServer Database Browser Introduction');
     htp.headClose;

     htp.bodyOpen;
     htp.img('/ows-img/dbbrowse.gif');
     htp.nl;
     htp.nl;

     htp.print('Does your Web Browser support HTML tables?');
     htp.ulistOpen;
     htp.listItem(htf.anchor(owa_util.get_owa_service_path||
                             'browse.register_and_list?ntable_type='||
                             to_char(owa_util.html_table), 'Yes'));
     htp.listItem(htf.anchor(owa_util.get_owa_service_path||
                             'browse.register_and_list?ntable_type='||
                             to_char(owa_util.pre_table), 'No'));
     htp.listItem(htf.anchor(owa_util.get_owa_service_path||
                             'browse.browser_test', 'Not Sure'));
     htp.ulistClose;

     print_button_bar;
     htp.bodyClose;
     htp.htmlClose;
  end;

  procedure browser_test is
  begin
     htp.htmlOpen;
     htp.headOpen;
     htp.title('Oracle WebServer Web Browser Configuration');
     htp.headClose;

     htp.bodyOpen;
     htp.img('/ows-img/dbbrowse.gif');
     htp.nl;

     htp.print('Below is an HTML table.');
     htp.print('If it appears to be properly formatted, then your web browser does support HTML tables.');
     htp.print('If it does not appear to be properly formatted, then your web browser does not support HTML tables.');
     htp.nl;
     htp.nl;

     htp.tableOpen('BORDER');

     htp.tableRowOpen;
     htp.tableHeader('Dept. Number');
     htp.tableHeader('Dept. Name');
     htp.tableHeader('Location');
     htp.tableRowClose;

     htp.tableRowOpen;
     htp.tableData('10');
     htp.tableData('ACCOUNTING');
     htp.tableData('NEW YORK');
     htp.tableRowClose;

     htp.tableRowOpen;
     htp.tableData('20');
     htp.tableData('RESEARCH');
     htp.tableData('DALLAS');
     htp.tableRowClose;

     htp.tableRowOpen;
     htp.tableData('30');
     htp.tableData('SALES');
     htp.tableData('CHICAGO');
     htp.tableRowClose;

     htp.tableRowOpen;
     htp.tableData('40');
     htp.tableData('OPERATIONS');
     htp.tableData('BOSTON');
     htp.tableRowClose;

     htp.tableClose;

     htp.nl;

     htp.print('Does your Web Browser support HTML tables?');
     htp.ulistOpen;
     htp.listItem(htf.anchor(owa_util.get_owa_service_path||
                             'browse.register_and_list?ntable_type='||
                             to_char(owa_util.html_table), 'Yes'));
     htp.listItem(htf.anchor(owa_util.get_owa_service_path||
                             'browse.register_and_list?ntable_type='||
                             to_char(owa_util.pre_table), 'No'));
     htp.ulistClose;

     print_button_bar;
     htp.bodyClose;
     htp.htmlClose;
  end;

  procedure register_and_list(ntable_type in integer) is
  begin
     register_browser_table_support(ntable_type);
     list(ntable_type);
  end;

  procedure list(ntable_type in integer DEFAULT owa_util.html_table) is
     service_name_path varchar2(2000);
  begin
      service_name_path := owa_util.get_owa_service_path;

      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle WebServer Database Browser Options');
      htp.headClose;

      htp.bodyOpen;
      htp.img('/ows-img/dbbropts.gif');
      htp.nl;

      htp.header(2,'Welcome to the '||htf.em('Oracle Web Server')||
                   ' Database Browser.');
      htp.header(3,'What would you like to browse?');

      htp.ulistOpen;
      htp.listItem(
            htf.anchor(service_name_path||
                       'browse.tabs_and_views?ntable_type='||
                       to_char(ntable_type), 'Tables and Views'));

      htp.listItem(
            htf.anchor(service_name_path||
                       'browse.pl_sql?ntable_type='||
                       to_char(ntable_type), 'Stored PL/SQL'));

      htp.listItem(
            htf.anchor(service_name_path||
                       'browse.users?ntable_type='||
                       to_char(ntable_type), 'Database Users'));
      
      htp.listItem(
            htf.anchor(service_name_path||
                       'browse.sessions?ntable_type='||
                       to_char(ntable_type), 'Database Sessions'));
      
      htp.listItem(
            htf.anchor(service_name_path||
                       'browse.rollback_segs?ntable_type='||
                       to_char(ntable_type), 'Rollback Segments'));

      htp.listItem(
            htf.anchor(service_name_path||
                       'browse.datafiles?ntable_type='||
                       to_char(ntable_type), 'Database Files'));

      htp.listItem(
            htf.anchor(service_name_path||
                       'browse.space_usage?'||
                       'ntable_type='||to_char(ntable_type),
                       'Tablespace Space Usage'));

      htp.listItem(
            htf.anchor(service_name_path||
                       'browse.freespace_usage?'||
                       'ntable_type='||to_char(ntable_type),
                       'Tablespace Free Space Summary'));
      htp.ulistClose;

      htp.nl;
      htp.print('If you are having trouble viewing the tables displayed by the Database Browser, your web browser may not support HTML tables.');
      htp.print('Update the list of browsers which support HTML tables in the '
               ||htf.anchor(service_name_path||'browse.browser_test',
                           'Web Browser Knowledge Base')||'.');
      htp.nl;

      print_button_bar;
      htp.bodyClose;
      htp.htmlClose;
   end;

   procedure user_tnv(cuser       in varchar2,
                      ntable_type in integer DEFAULT owa_util.html_table)
      is
     cursor object_cursor (user in varchar2) is 
        select object_name from all_objects
           where object_type in ('TABLE','VIEW')
             and owner = upper(user)
           order by object_name;
   begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle WebServer Browse Database Tables and Views');
      htp.headClose;

      htp.bodyOpen;
      htp.img('/ows-img/dbbrtbvw.gif');
      htp.nl;

      htp.header(3,'Which of '||
                   cuser||'''s tables and views would you like to browse?');
      htp.nl;
      htp.ulistOpen;

      for object_rec in object_cursor (cuser)
      loop
         htp.listItem(
             htf.anchor (owa_util.get_owa_service_path||
                         'browse.table_columns?ctable='||
                         cuser||'.'||object_rec.object_name||
                         '&ntable_type='||to_char(ntable_type),
                         object_rec.object_name)
                        );
         htp.nl;
      end loop;
      htp.ulistClose;
      print_button_bar;
      htp.bodyClose;
      htp.htmlClose;
   end;


   procedure tabs_and_views(ntable_type in integer DEFAULT owa_util.html_table)
      is
     cursor user_cursor is 
        select distinct owner from all_objects
           where object_type in ('TABLE','VIEW')
           order by owner;
   begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle WebServer Browse Database Tables and Views');
      htp.headClose;

      htp.bodyOpen;
      htp.img('/ows-img/dbbrtbvw.gif');
      htp.nl;

      htp.header(3,'Which user''s tables and views would you like to browse?');
      htp.ulistOpen;

      for object_rec in user_cursor
      loop
         htp.listItem(
             htf.anchor (owa_util.get_owa_service_path||
                         'browse.user_tnv?cuser='||
                         object_rec.owner||
                         '&ntable_type='||to_char(ntable_type),
                         object_rec.owner)
                        );
         htp.nl;
      end loop;
      htp.ulistClose;
      print_button_bar;
      htp.bodyClose;
      htp.htmlClose;
   end;

   procedure show_source(cname in varchar2) is
      procname  varchar2(30);
      procowner varchar2(30);
 
      part1      varchar2(30);
      part2      varchar2(30);
      part1_type integer;
      dblink varchar2(128);
      object_id  integer;
 
      cursor c1 (n in varchar2, o in varchar2) is
        select line, text from all_source
           where name  = upper(n)
             and owner = upper(o)
           order by type, line;
 
      line1s integer := 0;
   begin
 
      dbms_utility.name_resolve(cname, 1, procowner, part1, part2, dblink,
                                part1_type, object_id);
      if part1_type in (7,8)
      then
         procname := part2;
      else
         procname := part1;
      end if;
 
      htp.title('Source code for '||procname);

      owa_util.showsource(cname);
      print_button_bar;
   end;

   procedure user_plsql(cuser in varchar2)
      is
     cursor object_cursor (user in varchar2) is 
        select distinct name, type from all_source
          where type in ('PACKAGE','PROCEDURE','FUNCTION')
             and owner = upper(user)
           order by type, name;
     curr_pltype varchar2(30);
   begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle WebServer Browse Database Stored PL/SQL');
      htp.headClose;

      htp.bodyOpen;
      htp.img('/ows-img/dbbrpls.gif');
      htp.nl;

      htp.header(3,'Which of '||
                   cuser||'''s PL/SQL would you like to browse?');

      htp.ulistOpen;
      curr_pltype := ' ';
      for object_rec in object_cursor (cuser)
      loop
         if object_rec.type != curr_pltype 
         then
            if (curr_pltype is not NULL)
               then htp.ulistClose;
            end if;

            htp.listItem(object_rec.type);
            htp.ulistOpen;
            curr_pltype := object_rec.type;
         end if;

         htp.listItem(
             htf.anchor (owa_util.get_owa_service_path||
                         'browse.show_source?cname='||
                         cuser||'.'||object_rec.name,
                         object_rec.name)
                        );
      end loop;
      htp.ulistClose;

      print_button_bar;
      htp.bodyClose;
      htp.htmlClose;
   end;

   procedure pl_sql(ntable_type in integer DEFAULT owa_util.html_table)
      is
     cursor user_cursor is 
        select distinct owner from all_objects
       where object_type in ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION')
           order by owner;
   begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle WebServer Browse Stored PL/SQL');
      htp.headClose;

      htp.bodyOpen;
      htp.img('/ows-img/dbbrpls.gif');
      htp.nl;

      htp.header(3,'Which user''s PL/SQL would you like to browse?');
      htp.ulistOpen;

      for object_rec in user_cursor
      loop
         htp.listItem(
             htf.anchor (owa_util.get_owa_service_path||
                         'browse.user_plsql?cuser='||object_rec.owner,
                         object_rec.owner)
                        );
         htp.nl;
      end loop;
      htp.ulistClose;
      print_button_bar;
      htp.bodyClose;
      htp.htmlClose;
   end;

   procedure table_columns(ctable      in varchar2,
                           ntable_type in integer  DEFAULT owa_util.html_table)
     is
   begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title('Select columns for '||ctable);
      htp.headClose;

      htp.bodyOpen;
      htp.header(1,'Select columns for '||upper(ctable)||htf.line);
      htp.formOpen(owa_util.get_owa_service_path||'browse.table_browse_c');
      htp.formHidden('ntable_type', to_char(ntable_type));
      htp.header(3,'Select specific columns to view, or just '||
                   'select "Execute Query" for all columns to be shown.');
      htp.para;
      owa_util.show_query_columns(ctable);
      htp.formClose;
      print_button_bar;
      htp.bodyClose;
      htp.htmlClose;
   end;

   procedure table_browse_c (ctable      in varchar2,
                             ntable_type in integer DEFAULT owa_util.html_table,
                             cols        in owa_util.ident_arr) is
      column_list varchar2(32000);
      col_counter integer;
   begin
 
      /* The first column should always be ignored */
      col_counter := 2;
      loop
         column_list := column_list||cols(col_counter)||',';
         col_counter := col_counter + 1;
      end loop;
 
   exception
      when no_data_found
      then
         /* Strip out the trailing comma */
         if column_list is null
            then column_list := '*';
            else column_list := substr(column_list,1,length(column_list)-1);
         end if;
         table_browse(ctable, ntable_type, column_list, NULL,
                              1, 100);
   end;

   procedure table_browse (ctable      in varchar2,
                           ntable_type in integer  DEFAULT owa_util.html_table,
                           ccolumns    in varchar2 DEFAULT '*',
                           cclauses    in varchar2 DEFAULT NULL,
                           nrow_min    in integer  DEFAULT 0,
                           nrow_max    in integer  DEFAULT NULL,
                           cbutton     in varchar2 DEFAULT NULL) is
      more_rows boolean;
      new_min   integer;
      new_max   integer;
   begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title(upper(ctable));
      htp.headClose;

      htp.bodyOpen;
      htp.header(1,upper(ctable)||htf.line);

      htp.formOpen(owa_util.get_owa_service_path||
                   'browse.table_browse','GET');

      if (cbutton = '<-Previous set of records')
      then
         new_max := nrow_max - 100;

         if (nrow_min < 100)
            then new_min := 0;
            else new_min := nrow_min-100;
         end if;
      else if (cbutton = 'Next set of records->')
           then
              new_min := nrow_min + 100;
              new_max := nrow_max + 100;
           else 
              new_min := nrow_min;
              new_max := nrow_max;
           end if;
      end if;

      htp.formHidden('ctable', ctable);
      htp.formHidden('ntable_type', ntable_type);
      htp.formHidden('ccolumns', ccolumns);
      htp.formHidden('cclauses', cclauses);
      htp.formHidden('nrow_min', new_min);
      htp.formHidden('nrow_max', new_max);

      if (new_min > 1)
      then
         htp.formSubmit('cbutton', '&lt;-Previous set of records');
         htp.br;
      end if;

      more_rows := owa_util.tablePrint(ctable, 'BORDER', ntable_type,
                                      ccolumns, cclauses, NULL,
                                      new_min, new_max);

      if (more_rows)
      then
         htp.br;
         htp.formSubmit('cbutton', 'Next set of records-&gt;');
      end if;
        
      htp.formClose;
      print_button_bar;
      htp.bodyClose;
      htp.htmlClose;
   end;

   procedure users(ntable_type in integer DEFAULT owa_util.html_table) is
      ignore boolean;
   begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle WebServer Browse Database Users');
      htp.headClose;
 
      htp.bodyOpen;
      htp.img('/ows-img/dbbrusrs.gif');
      htp.nl;

      htp.header(3, 'Database user information:');

      ignore := owa_util.tablePrint('dba_users', 'BORDER', ntable_type,
                        'username,default_tablespace,temporary_tablespace,'||
                        'profile,created',
                        'order by username',
                        'Username, Default TS, Temporary TS, Profile, Created');

      htp.bodyClose;
      print_button_bar;
      htp.htmlClose;
   end;

   procedure sessions(ntable_type in integer DEFAULT owa_util.html_table) is
      ignore boolean;
   begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle WebServer Browse Database Sessions');
      htp.headClose;

      htp.bodyOpen;
      htp.img('/ows-img/dbbrsess.gif');
      htp.nl;
 
      htp.header(3, 'Current sessions connect to your database:');

      ignore := owa_util.tablePrint('v$session', 'BORDER', ntable_type,
                         'username, osuser, status, server, machine, program',
                         'where type=''USER'' order by username',
                         'Username, OS Username, Status, Server, Machine, Program');
 
      print_button_bar;
      htp.bodyClose;
      htp.htmlClose;
   end;

   procedure rollback_segs(ntable_type in integer DEFAULT owa_util.html_table) is
     ignore boolean;
   begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle WebServer Browse Rollback Segments');
      htp.headClose;
 
      htp.bodyOpen;
      htp.img('/ows-img/dbbrrbsg.gif');
      htp.nl;

      htp.header(3, 'Rollback segment space allocation:');

      ignore := owa_util.tablePrint('dba_segments', 'BORDER', ntable_type,
                        'owner,segment_name,tablespace_name,bytes,'||
                        'initial_extent,next_extent,extents,max_extents',
                        'where segment_type=''ROLLBACK'' order by segment_name',
                        'Owner, Rollback Segment, TS Name, Bytes, Initial, Next, Extents, Max Extents');

      print_button_bar;
      htp.bodyClose;
      htp.htmlClose;
   end;

   procedure datafiles(ntable_type in integer DEFAULT owa_util.html_table) is
      ignore boolean;
   begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle WebServer Browse Database Files');
      htp.headClose;

      htp.bodyOpen;
      htp.img('/ows-img/dbbrfils.gif');
      htp.nl;

      htp.header(3, 'Database files for your database:');

      ignore := owa_util.tablePrint('dba_data_files', 'BORDER', ntable_type,
                         'tablespace_name,file_name,bytes,blocks',
                         'order by tablespace_name, file_name',
                         'Tablespace Name, File Name, Bytes, Blocks');

      htp.header(3, 'Redo log files for your database:');

      ignore := owa_util.tablePrint('log_view', 'BORDER', ntable_type,
'thread#,group#,sequence#,bytes,file_name,group_status, archived, file_status',
                         'order by thread#, group#, file_name',
'Thread#,Group#,Sequence#,Bytes,File Name, Group Status, Archived?, File Status');

      htp.header(3, 'Control files for your database:');
      ignore := owa_util.tablePrint('v$controlfile', 'BORDER', ntable_type,
                                    'name, status', 'order by name');

      print_button_bar;
      htp.bodyClose;
      htp.htmlClose;
   end;

  procedure space_usage(ntable_type in integer DEFAULT owa_util.html_table) is
      cursor tablespace_cursor is select tablespace_name from dba_tablespaces;
  begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle WebServer Browse Database Tablespace Usage');
      htp.headClose;

      htp.bodyOpen;
      htp.img('/ows-img/dbbrspce.gif');
      htp.nl;

      htp.header(3,'Which tablespace would you like to view?');
      htp.ulistOpen;
      for ts_rec in tablespace_cursor
      loop
         htp.listItem( htf.anchor(owa_util.get_owa_service_path||
                                  'browse.tablespace_usage?'||
                                  'ctablespace_name='||ts_rec.tablespace_name||
                                  '&ntable_type='||to_char(ntable_type),
                                  ts_rec.tablespace_name));
      end loop;

      htp.ulistClose;
      print_button_bar;
      htp.bodyClose;
      htp.htmlClose;
  end;

  procedure tablespace_usage(ctablespace_name in varchar2,
                             ntable_type in integer DEFAULT owa_util.html_table)
  is
      ignore boolean;
  begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle WebServer Browse Tablespace '||ctablespace_name);
      htp.headClose;

      htp.bodyOpen;
      htp.img('/ows-img/dbbrspce.gif');
      htp.nl;
      htp.header(3,'Space usage for tablespace '||ctablespace_name||':');

      ignore := owa_util.tablePrint('extent_map', 'BORDER', ntable_type,
                'owner,segment_name,segment_type,extent_id,block_id,blocks',
                 'where tablespace_name = '''||upper(ctablespace_name)||''' '||
                   'order by tablespace_name, file_id, block_id',
                   'Owner, Segment Name, Segment Type, Extent ID, Starting Block, Blocks');

      print_button_bar;
      htp.bodyClose;
      htp.htmlClose;
  end;

  procedure freespace_usage(ntable_type in integer DEFAULT owa_util.html_table)
  is
      ignore boolean;
  begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle WebServer Browse Database Freespace');
      htp.headClose;

      htp.bodyOpen;
      htp.img('/ows-img/dbbrfrsp.gif');
      htp.nl;

      htp.header(3,'Available free space for your database:');

      ignore := owa_util.tablePrint('user_free_space', 'BORDER', ntable_type,
           'tablespace_name, sum(bytes), max(bytes),'||
                           ' sum(blocks), max(blocks)',
              'group by tablespace_name',
           'Tablespace Name, Total Free (bytes), Largest Free (bytes),'||
                           ' Total Free (blocks), Largest Free (blocks)');

      print_button_bar;
      htp.bodyClose;
      htp.htmlClose;
  end;

end;
/
show errors
