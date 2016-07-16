rem
rem
Rem  Copyright (c) 1995, 1996 by Oracle Corporation. All rights reserved.
Rem    NAME
Rem      browseu.sql - package for browsing an Oracle database as
Rem                    a regular, non-DBA user.
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
Rem    MODIFIED   (MM/DD/YY)
Rem     mbookman   08/02/95 -  Creation

Rem set define off


REM Creating BROWSE package...
create or replace package BROWSE is

   procedure intro;
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

end;
/
show errors

REM Creating BROWSE package body...
create or replace package body BROWSE is

  procedure intro is
  begin
      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle Internet Server Database Browser Introduction');
      htp.headClose;
 
      htp.bodyOpen;
      htp.img('/ows-img/dbbrowse.gif');
      htp.nl;
      htp.nl;
 
      htp.print('Does your Web Browser support HTML tables?');
      htp.anchor(owa_util.get_owa_service_path||
                 'browse.list?ntable_type='||
                 to_char(owa_util.html_table), 'Yes');
      htp.print('/');
      htp.anchor(owa_util.get_owa_service_path||
                 'browse.list?ntable_type='||
                 to_char(owa_util.pre_table),
                 'No');
      htp.nl;
      htp.bodyClose;
      htp.htmlClose;
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
      htp.ulistClose;
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
      htp.bodyClose;
      htp.htmlClose;
   end;
 
   procedure show_source(cname in varchar2) is
   begin
      owa_util.showsource(cname);
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
      htp.bodyClose;
      htp.htmlClose;
   end;

end;
/
show errors
