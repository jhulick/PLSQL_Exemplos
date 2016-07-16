Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved.
Rem    NAME
Rem      iowaext.sql
Rem    DESCRIPTION
Rem      
Rem    RETURNS
Rem 
Rem    NOTES
Rem      
Rem    MODIFIED   (MM/DD/YY)
Rem     mfreedma      09/11/96 -  Added Banner 

create or replace procedure oext_ogtg_html_begin( theTitle in varchar2,
											 theImage in varchar2 default
											 NULL )
as
begin
	htp.print( ' <html> <head> ' );
	htp.title( TheTitle );
	htp.print( ' </head> <body>' );
	if ( theImage is NOT NULL ) then
		htp.p( '<center>' );
		htp.p( '<img src="' || theImage || '" alt="'||theTitle||'">' );
		htp.p( '</center><hr>' );
	else
		htp.line;
		htp.img('/ows-img/ows.gif');
		htp.line;
	end if;
end oext_ogtg_html_begin;
/
show errors

create or replace procedure oext_ogtg_html_end
as
	o	varchar2(30);
	n	varchar2(30);
	l	varchar2(30);
	t	varchar2(30);
begin
	htp.p( '<hr>');
	owa_util.who_called_me( o, n, l, t );
	owa_util.signature( o || '.' || n );

        htp.line;
        htp.address('(c)1996 Oracle Corporation');

	htp.p( '</body>' );
	htp.p( '</html>' );

	if ( owa_util.get_cgi_env( 'HTTP_USER_AGENT' ) like '%Mozilla%Win%' )
	then
		for i in 1 .. 10 loop
			htp.p( '<br>' );
		end loop;
		htp.p( '<font size=0><!--' );
	end if;
end oext_ogtg_html_end;
/
show errors

--
create or replace procedure owaext_demo_table1( p_mon in varchar2 )
is
begin
    oext_ogtg_html_begin( 'Table Demo 1' );
    htp.p( 'Feel free to change the month ' || p_mon || ' in the 
            above URL to whatever 3 character month you want...' );
    htp.tableOpen( 'border' );
    owa_util.cellsprint( 
        owa_util.bind_variables( 'select a.* , user_id * 1000
                         from all_users a
                        where to_char(created,''MON'') = :x1', 
                      ':x1', p_mon ), 100, 'Yes' );
    htp.tableClose;
    oext_ogtg_html_end;
end;
/
--
create or replace procedure owaext_demo_table2
( p_start in number default 0 )
is
    l_more_data        boolean default FALSE;
begin
    oext_ogtg_html_begin( 'Paging Demo' );
--
    htp.tableOpen( 'border' );
    owa_util.cellsprint( 'select rownum, a.* from all_objects a', 
                               15,
                               'Yes', 
                               p_start,
                               l_more_data );
    htp.tableClose;
--
    if ( p_start > 0 ) then
        htp.formOpen( 'owaext_demo_table2' );
        htp.formHidden( 'p_start', p_start-15 );
        htp.formSubmit( cvalue => 'Previous 15' );
        htp.formClose;
    end if;
    if ( l_more_data ) then
        htp.formOpen( 'owaext_demo_table2' );
        htp.formHidden( 'p_start', p_start+15 );
        htp.formSubmit( cvalue => 'Next 15' );
        htp.formClose;
    end if;
--
    oext_ogtg_html_end;
end;
/
--
create or replace package owaext_demo_list1
as
    empty    owa_util.ident_arr;
--
    procedure show( p_my_list in owa_util.ident_arr default empty);
end;
/
--
create or replace package body owaext_demo_list1
as
--
procedure show( p_my_list in owa_util.ident_arr default empty )
is
    l_tmp        varchar2(4096) default '/';
begin
    oext_ogtg_html_begin( 'Simple List Demo' );
--
    for i in 1 .. 10000 loop
        begin
            htp.p( 'You picked object_id = ' || p_my_list(i) );
            htp.br;
            l_tmp := l_tmp || p_my_list(i) || '/';
        exception
            when no_data_found then exit;
        end;
    end loop;
--
    htp.formOpen( 'owaext_demo_list1.show' );
    htp.p( 'Select some objects:' );
    owa_util.listprint( 
        owa_util.bind_variables( 
        'select object_id, object_type || ''.'' || object_name, 
            decode( sign(instr( :x2, ''/''||object_id||''/'' )),1,1,null)
           from all_objects
          where owner = :x', ':x', USER, ':x2', l_tmp ), 
        'p_my_list', 5, TRUE );
    htp.formSubmit;
    htp.formClose;
--
    oext_ogtg_html_end;
end;
--
end owaext_demo_list1;
/
--
create or replace procedure owaext_demo_choose_date
( p_date in owa_util.datetype default owa_util.empty_date )
is
    l_date    date default owa_util.todate(p_date);
begin
    oext_ogtg_html_begin( 'Date Selection' );
--
    if ( l_date is not NULL ) then
        htp.bold( 'You picked the date ' || l_date );
    end if;
--
    htp.formOpen( 'owaext_demo_choose_date' );
    htp.p( 'Select a date, any date:<br>' );
    owa_util.choose_date( 'p_date', nvl(l_date,sysdate ) );
    htp.br;
    htp.formSubmit;
    htp.formClose;
--
    oext_ogtg_html_end;
end;
/
--
create or replace procedure owaext_demo_cal
( p_data in varchar2 default NULL )
is
begin
    oext_ogtg_html_begin( 'Calendar Demo' );
--
    if ( p_data is not null ) then
        htp.tableOpen( 'Border' );
        owa_util.cellsprint(
            owa_util.bind_variables( 'select * from all_users where user_id = :x',
                          ':x', p_data ) );
        htp.tableClose;
    end if;
--
--
    owa_util.calendarprint( 'select created, username, 
                    ''owaext_demo_cal?p_data=''||user_id
                     from all_users
                    where username like ''WWW%''
                    order by created' );
--
--
    oext_ogtg_html_end;
end;
/
