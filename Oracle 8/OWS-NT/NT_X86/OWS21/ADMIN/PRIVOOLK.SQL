rem
rem
Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved.
Rem    NAME
Rem      privoolk.sql - package of various OWA OPTIMISTIC LOCKING procedures
Rem    DESCRIPTION
Rem      This file contains one package:
Rem         owa_opt_lock    - Utitility procedures/functions for use
Rem                           with the Oracle Web Agent
Rem
Rem    NOTES
Rem      The Oracle Web Agent is needed to use these facilities.
Rem      The package owa is needed to use these facilities.
Rem      The package owa_util is needed to use these facilities.
Rem      The packages htp and htf are needed to use these facilities.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     mpal	   06/24/96 -  Creation

REM Creating OWA_OPT_LOCK package...
create or replace package body owa_opt_lock
as
	
	last_column		exception;
	pragma exception_init( last_column, -1007 );
	
	
     /******************************************************************/
    /* Function to calculate checksum                                 */
   /******************************************************************/
	function checksum( p_buff in varchar2 ) return number
	is
		l_sum	number default 0;
		l_n		number;
	begin
		for i in 1 .. trunc(length(p_buff||'x')/2) loop
			l_n := ascii(substr(p_buff||'x', 1+(i-1)*2, 1))*256 + 
				   ascii(substr(p_buff||'x', 2+(i-1)*2, 1));
			l_sum := mod(l_sum+l_n,4294967296);
		end loop;
		while ( l_sum > 65536 ) loop
			l_sum := bitand( l_sum, 65535 ) + trunc(l_sum/65536);
		end loop;
		return l_sum;
	end checksum;
	
	
	function checksum( p_owner in varchar2, 
					   p_tname in varchar2, 
					   p_rowid in rowid ) return number
	is
		l_theQuery		varchar2(4096) default NULL;
		l_cursor		integer;
	    l_variable    	number;
	    l_status    	number;
	begin
	    l_cursor := dbms_sql.open_cursor;
		
		for x in ( select column_name
					 from all_tab_columns
					where owner = upper( p_owner )
					  and table_name = upper( p_tname )
					order by column_id ) loop
			if ( l_theQuery is NULL ) then
				l_theQuery := 'select owa_opt_lock.checksum(';
			else
				l_theQuery := l_theQuery || '||';
			end if;
			l_theQuery := l_theQuery || x.column_name;
		end loop;
		l_theQuery := l_theQuery || ') from ' || p_owner || '.' || p_tname ||
					 ' where rowid = :x1 for update';
	
	   dbms_sql.parse( l_cursor, l_theQuery, dbms_sql.native );
		dbms_sql.bind_variable( l_cursor, ':x1', p_rowid );
		dbms_sql.define_column( l_cursor, 1, l_variable );
	
	    l_status := dbms_sql.execute(l_cursor);
	    l_status := dbms_sql.fetch_rows(l_cursor);
	    dbms_sql.column_value( l_cursor, 1, l_variable );
		dbms_sql.close_cursor( l_cursor );
	
		return l_variable;
	end;
	
     /******************************************************************/
    /* Procedure to store values before modifying values              */
   /******************************************************************/
	procedure store_values( p_owner in varchar2, 
							 p_tname in varchar2, 
							 p_rowid in rowid )
	is
		l_theQuery		varchar2(4096) default
						'select rowid, a.* from ' || p_owner || '.' || p_tname ||
						' a where rowid = :x1';
	
		l_cursor		integer;
	    l_variable    	varchar2(2000);
	    l_status    	number;
		l_col_cnt 		number default 0;
	begin
	    l_cursor := dbms_sql.open_cursor;
	
	    dbms_sql.parse( l_cursor, l_theQuery, dbms_sql.native );
		dbms_sql.bind_variable( l_cursor, ':x1', p_rowid );
		for i in 1 .. 255 loop
			begin
				dbms_sql.define_column( l_cursor, i, l_variable, 2000 );
				l_col_cnt := l_col_cnt + 1;
			exception
				when last_column then exit;
			end;
		end loop;
	
	    l_status := dbms_sql.execute(l_cursor);
	    l_status := dbms_sql.fetch_rows(l_cursor);
	
		htp.formHidden( 'old_' || p_tname, htf.escape_sc(p_owner) );
		htp.formHidden( 'old_' || p_tname, htf.escape_sc(p_tname) );
		for i in 1 .. l_col_cnt loop
			dbms_sql.column_value( l_cursor, i, l_variable );
			htp.formHidden( 'old_'||p_tname, htf.escape_sc(l_variable) );
		end loop;
	
		dbms_sql.close_cursor( l_cursor );
	end;
	
     /******************************************************************/
    /* Function to verify stored values                               */
   /******************************************************************/
	function verify_values( p_old_values in vcArray ) return boolean
	is
		l_theQuery		varchar2(4096) default
						'select * from ' || 
						 p_old_values(1) || '.' || p_old_values(2) ||
						' where rowid = :x1 for update';
	
		l_cursor		integer;
	    l_variable    	varchar2(2000);
	    l_status    	number;
		l_col_cnt 		number default 0;
		l_return_val    boolean default TRUE;
	begin
	    l_cursor := dbms_sql.open_cursor;
	
	    dbms_sql.parse( l_cursor, l_theQuery, dbms_sql.native );
		dbms_sql.bind_variable( l_cursor, ':x1', p_old_values(3) );
		for i in 1 .. 255 loop
			begin
				dbms_sql.define_column( l_cursor, i, l_variable, 2000 );
				l_col_cnt := l_col_cnt + 1;
			exception
				when last_column then exit;
			end;
		end loop;
	
	    l_status := dbms_sql.execute(l_cursor);
	    l_status := dbms_sql.fetch_rows(l_cursor);
	
		for i in 1 .. l_col_cnt loop
			dbms_sql.column_value( l_cursor, i, l_variable );
			if ( l_variable <> p_old_values(i+3) AND
				 l_variable is not null          AND
				 p_old_values(i+3) is not null ) then 
					l_return_val := FALSE;
					exit;
			end if;
		end loop;
	
		dbms_sql.close_cursor( l_cursor );
		return l_return_val;
	end;
	
     /******************************************************************/
    /* Internal function used by verify_values                        */
   /******************************************************************/
	function get_rowid( p_old_values in vcArray ) return rowid
	is
	begin
		return p_old_values(3);
	end;
	
end;
/
show errors
