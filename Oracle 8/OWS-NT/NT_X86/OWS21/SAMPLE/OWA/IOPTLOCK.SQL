Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
Rem    NAME
Rem      ioptlock.sql
Rem    DESCRIPTION
Rem      
Rem    RETURNS
Rem 
Rem    NOTES
Rem      
Rem    MODIFIED   (MM/DD/YY)
Rem     mfreedma      09/11/96 -  Added Banner 

create or replace procedure oolk_ogtg_html_begin( theTitle in varchar2,
											 theImage in varchar2 default
											 NULL )
as
begin
	htp.p( ' <html> <head> ' );
	htp.title( TheTitle );
	htp.p( ' </head> <body>' );
	if ( theImage is NOT NULL ) then
		htp.p( '<center>' );
		htp.p( '<img src="' || theImage || '" alt="'||theTitle||'">' );
		htp.p( '</center><hr>' );
    else
        htp.line;
        htp.img('/ows-img/ows.gif');
        htp.line;
    end if;
end oolk_ogtg_html_begin;
/
show errors

create or replace procedure oolk_ogtg_html_end
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
end oolk_ogtg_html_end;
/
show errors


create table owaoptlk_demo
as
select username, user_id from all_users where rownum = 1
/

create or replace package owaoptlk_demo_hidden
as
	procedure start_it;

	procedure do_update( old_OWAOPTLK_DEMO in owa_opt_lock.vcArray,
					     new_username      in owaoptlk_demo.username%type,
					     new_user_id       in owaoptlk_demo.user_id%type );
end;
/
show errors

create or replace package body owaoptlk_demo_hidden
as

procedure show_update_form
is
	cursor  c1 is select rowid, a.* from owaoptlk_demo a;
	rec		c1%rowtype;
begin
	open c1;
	fetch c1 into rec;
	close c1;

	htp.formOpen( 'owaoptlk_demo_hidden.do_update' );
	owa_opt_lock.store_values( USER, 'OWAOPTLK_DEMO', rec.rowid );
	htp.tableOpen;
	htp.tableRowOpen;
	htp.tableData( 'Username: ' ); 
	htp.tableData( htf.formText( 'new_username', cvalue => rec.username ) );
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData( 'User-Id: ' ); 
	htp.tableData( htf.formText( 'new_user_id', cvalue => rec.user_id ) );
	htp.tableRowClose;
	htp.tableClose;
	htp.formSubmit;
	htp.formReset;
	htp.formClose;
end;

procedure update_form_build( fail in boolean )
is
begin
	htp.hr;
	show_update_form;
	
	if ( fail ) then
		update owaoptlk_demo set user_id = user_id+1;
		commit;
	end if;
end;


procedure options
is
begin
	htp.hr( cattributes => 'size=5' );
	htp.p( 'Updating this record will always FAIL since the record has
	        already  been changed to the values in the next form on this
			page (after we built the form, we updated the value so as to
			make sure it would be changed.)' );
	update_form_build( TRUE );
	htp.hr( cattributes => 'size=5' );

	htp.p( 'Updating this record will <b>usually</b> succeed but is not
	        gauranteed to (someone else could be running this demo after
			all!).' );
	update_form_build( FALSE );
	htp.hr( cattributes => 'size=5' );
	htp.anchor( '/samples.html', 'Back to Samples' );
end;


procedure do_update( old_OWAOPTLK_DEMO in owa_opt_lock.vcArray,
					 new_username      in owaoptlk_demo.username%type,
					 new_user_id       in owaoptlk_demo.user_id%type )
is
	the_rowid	rowid default owa_opt_lock.get_rowid( old_OWAOPTLK_DEMO );
	cursor  c1 is select rowid, a.* from owaoptlk_demo a;
	rec		c1%rowtype;
begin

	oolk_ogtg_html_begin( 'Locking Demo' );

	if ( owa_opt_lock.verify_values( old_OWAOPTLK_DEMO ) ) then
		update owaoptlk_demo
		   set username = new_username,
			   user_id  = new_user_id
		 where rowid = the_rowid;

		 htp.bold( 'Update Was Successful....' );
	else
		htp.bold( 'Sorry, row has changed, please requery to see new value');
		htp.br;
		htp.p( 'You had ' || old_owaoptlk_demo(4) || ',' ||
					old_owaoptlk_demo(5) );
		htp.br;
		open c1;
		fetch c1 into rec;
		close c1;
		htp.p( 'And the current values are ' || rec.username || ',' ||
				rec.user_id );
	end if;

	options;

	oolk_ogtg_html_end;
end;

procedure start_it
is
begin
	oolk_ogtg_html_begin( 'Hidden Field Locking' );
	options;
	oolk_ogtg_html_end;
end;


end;
/
show errors


create or replace package owaoptlk_demo_pure_checksum
as
	procedure start_it;

	procedure do_update( old_checksum      in number,
						 old_rowid		   in rowid,
					     new_username      in owaoptlk_demo.username%type,
					     new_user_id       in owaoptlk_demo.user_id%type );
end;
/
show errors

create or replace package body owaoptlk_demo_pure_checksum
as

procedure show_update_form
is
	cursor  c1 is 
		select rowid, owa_opt_lock.checksum( username || user_id ) checksum, 
			   a.* 
		  from owaoptlk_demo a;
	rec		c1%rowtype;
begin
	open c1;
	fetch c1 into rec;
	close c1;

	htp.formOpen( 'owaoptlk_demo_pure_checksum.do_update' );
	htp.formHidden( 'old_checksum', rec.checksum );
	htp.formHidden( 'old_rowid', rec.rowid );
	htp.bold( 'The checksum for this row is ' || rec.checksum );
	htp.tableOpen;
	htp.tableRowOpen;
	htp.tableData( 'Username: ' ); 
	htp.tableData( htf.formText( 'new_username', cvalue => rec.username ) );
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData( 'User-Id: ' ); 
	htp.tableData( htf.formText( 'new_user_id', cvalue => rec.user_id ) );
	htp.tableRowClose;
	htp.tableClose;
	htp.formSubmit;
	htp.formReset;
	htp.formClose;
end;

procedure update_form_build( fail in boolean )
is
begin
	htp.hr;
	show_update_form;
	
	if ( fail ) then
		update owaoptlk_demo set user_id = user_id+1;
		commit;
	end if;
end;


procedure options
is
begin
	htp.hr( cattributes => 'size=5' );
	htp.p( 'Updating this record will always FAIL since the record has
	        already  been changed to the values in the next form on this
			page (after we built the form, we updated the value so as to
			make sure it would be changed.)' );
	update_form_build( TRUE );
	htp.hr( cattributes => 'size=5' );

	htp.p( 'Updating this record will <b>usually</b> succeed but is not
	        gauranteed to (someone else could be running this demo after
			all!).' );
	update_form_build( FALSE );
	htp.hr( cattributes => 'size=5' );
        htp.anchor( '/samples.html', 'Back to Samples' );
end;


procedure do_update( old_checksum	   in number,
					 old_rowid		   in rowid,
					 new_username      in owaoptlk_demo.username%type,
					 new_user_id       in owaoptlk_demo.user_id%type )
is
	c		number;
begin
	oolk_ogtg_html_begin( 'Locking Demo' );

	update owaoptlk_demo
	   set username = new_username,
		   user_id  = new_user_id
	 where rowid = old_rowid
	   and owa_opt_lock.checksum( username||user_id ) = old_checksum;

	if ( sql%rowcount = 1 ) then
		 htp.bold( 'Update Was Successful....' );
	else
		htp.bold( 'Sorry, row has changed, please requery to see new value');
		htp.br;
		htp.p( 'You had a checksum of ' || old_checksum );
		htp.br;
		select owa_opt_lock.checksum( username || user_id ) into c
		  from owaoptlk_demo
		 where rowid = old_rowid;

		htp.p( 'And the current value is ' || c );
	end if;

	options;

	oolk_ogtg_html_end;
end;

procedure start_it
is
begin
	oolk_ogtg_html_begin( 'pure_checksum Field Locking' );
	options;
	oolk_ogtg_html_end;
end;


end;
/
show errors

create or replace package owaoptlk_demo_nonpure_checksum
as
	procedure start_it;

	procedure do_update( old_checksum      in number,
						 old_rowid		   in rowid,
					     new_username      in owaoptlk_demo.username%type,
					     new_user_id       in owaoptlk_demo.user_id%type );
end;
/
show errors

create or replace package body owaoptlk_demo_nonpure_checksum
as

procedure show_update_form
is
	cursor  c1 is select rowid, a.* from owaoptlk_demo a;
	rec		c1%rowtype;
begin
	open c1;
	fetch c1 into rec;
	close c1;

	htp.formOpen( 'owaoptlk_demo_nonpure_checksum.do_update' );
	htp.formHidden( 'old_checksum', 
			owa_opt_lock.checksum( USER, 'owaoptlk_demo', rec.rowid ));
	htp.formHidden( 'old_rowid', rec.rowid );
	htp.bold( 'The checksum for this row is ' || 
			owa_opt_lock.checksum( USER, 'owaoptlk_demo', rec.rowid ));
	htp.tableOpen;
	htp.tableRowOpen;
	htp.tableData( 'Username: ' ); 
	htp.tableData( htf.formText( 'new_username', cvalue => rec.username ) );
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData( 'User-Id: ' ); 
	htp.tableData( htf.formText( 'new_user_id', cvalue => rec.user_id ) );
	htp.tableRowClose;
	htp.tableClose;
	htp.formSubmit;
	htp.formReset;
	htp.formClose;
end;

procedure update_form_build( fail in boolean )
is
begin
	htp.hr;
	show_update_form;
	
	if ( fail ) then
		update owaoptlk_demo set user_id = user_id+1;
		commit;
	end if;
end;


procedure options
is
begin
	htp.hr( cattributes => 'size=5' );
	htp.p( 'Updating this record will always FAIL since the record has
	        already  been changed to the values in the next form on this
			page (after we built the form, we updated the value so as to
			make sure it would be changed.)' );
	update_form_build( TRUE );
	htp.hr( cattributes => 'size=5' );

	htp.p( 'Updating this record will <b>usually</b> succeed but is not
	        gauranteed to (someone else could be running this demo after
			all!).' );
	update_form_build( FALSE );
	htp.hr( cattributes => 'size=5' );
        htp.anchor( '/samples.html', 'Back to Samples' );
end;


procedure do_update( old_checksum	   in number,
					 old_rowid		   in rowid,
					 new_username      in owaoptlk_demo.username%type,
					 new_user_id       in owaoptlk_demo.user_id%type )
is
	c		number;
begin
	oolk_ogtg_html_begin( 'Locking Demo' );

	if ( owa_opt_lock.checksum( USER, 'owaoptlk_demo', old_rowid ) = 
			old_checksum ) 
	then
		update owaoptlk_demo
	       set username = new_username,
		       user_id  = new_user_id
	     where rowid = old_rowid;

		 htp.bold( 'Update Was Successful....' );
	else
		htp.bold( 'Sorry, row has changed, please requery to see new value');
		htp.br;
		htp.p( 'You had a checksum of ' || old_checksum );
		htp.br;
		htp.p( 'And the current value is ' ||
	        owa_opt_lock.checksum( USER, 'owaoptlk_demo', old_rowid ));
	end if;

	options;

	oolk_ogtg_html_end;
end;

procedure start_it
is
begin
	oolk_ogtg_html_begin( 'nonpure_checksum Field Locking' );
	options;
	oolk_ogtg_html_end;
end;


end;
/
show errors
