Rem  Copyright (c) 1996 by Oracle Corp.  All Rights Reserved.
Rem
Rem   NAME
Rem     webdba.sql - Web*DBA HTML procedures
Rem   PURPOSE
Rem     Provide SQL*DBA utility functions for producing dynamic HTML documents
Rem     
Rem   NOTES
Rem   HISTORY
Rem     kireland   12/05/95 -  Creation
Rem	kireland   01/22/96 -  Variable parameter passing
Rem	kireland   04/10/96 -  Development ceases, project deemed only
				a demo by ASHARMA.



create or replace package WEBDBA is

type bool_array is table of boolean index by binary_integer;
type array is table of varchar2(2000) index by binary_integer;
empty array;
empty_point owa_image.point;

procedure hello(ctext in varchar2 DEFAULT NULL);
procedure demo;

function getValue( ckey in varchar2, cnames in array, cvalues in array) return varchar2;

procedure tablePrint(	ctable		in varchar2,
			cattributes 	in varchar2 DEFAULT NULL,
			ccolumns 	in varchar2 DEFAULT '*',
			cclauses 	in varchar2 DEFAULT NULL,
			ccol_aliases 	in varchar2 DEFAULT NULL,
			nrows		in number DEFAULT 10,
			nrow_min	in number DEFAULT 0,
			nrow_max	in number DEFAULT NULL);

procedure SQLForm;
procedure queryForm(ctable in varchar2);
procedure insertForm(ctable in varchar2);
--procedure deleteForm(ctable in varchar2);
--procedure updateForm(ctable in varchar2);

procedure execQuery(ctable in varchar2, cnames in array, cvalues in array, cols in owa_util.ident_arr);
procedure execInsert(ctable in varchar2, cnames in array, cvalues in array, ctypes in array);
procedure execSQL(csql in varchar2);
procedure execSELECT(csql in varchar2);

procedure showsource(cname in varchar2);
procedure navigate(	ctable       	in varchar2,
                       	cattributes 	in varchar2 DEFAULT 'BORDER=8 CELLPADDING=5 CELLSPACING=3',
                       	ccolumns     	in varchar2 DEFAULT '*',
                       	cclauses     	in varchar2 DEFAULT NULL,
                       	ccol_aliases 	in varchar2 DEFAULT NULL,
		       	nrows		in number DEFAULT 10,
                       	nrow_min     	in number DEFAULT 0,
                       	nrow_max     	in number DEFAULT NULL,
		       	cuptable    	in varchar2 DEFAULT NULL,
		       	cupval	    	in varchar2 DEFAULT NULL,
		       	cuptext	    	in varchar2 DEFAULT NULL,		       
		       	left_button     in owa_image.point DEFAULT empty_point,
		       	right_button  	in owa_image.point DEFAULT empty_point,
		       	up_button	in owa_image.point DEFAULT empty_point);
end;
/
show errors

create or replace package body WEBDBA is

   /* The broken line below is intentional */
   NL_CHAR  constant  char(1) := '
';


 function getValue (ckey in varchar2, cnames in array, cvalues in array) return varchar2 is
 i integer;
 begin
  loop
	i := i + 1;
	if ( ckey = cnames(i) ) then
		return cvalues(i);
	end if;
  end loop;
 exception
	when NO_DATA_FOUND then return NULL;
 end getValue;

 procedure hello (ctext in varchar2 DEFAULT NULL) is
 
 begin
	htp.print('Hello kelly ireland');

	if (owa_pattern.match('kelly  ire%land', '\w*%\w*')) then
		htp.p('kelly matches %');
	else
		htp.p('kelly not match %');
	end if;
	
 end;


 procedure header(ctitle in varchar2) is
 begin

      htp.htmlOpen;
      htp.headOpen;
      htp.title('Oracle Web*DBA');
      htp.headClose;
      htp.bodyOpen(NULL, 'BGCOLOR=#B4B4DA VLINK=#FF2400');
      htp.img('/ows-img/oisicon2.gif', 'LEFT', 'Web*DBA', NULL);
	htp.br;
	htp.header(1, ctitle);
	htp.br('ALL');

 end header;

procedure buttonBar(ctable in varchar2) is
path varchar2(2000);
begin
	htp.centerOpen;
	path := owa_util.get_owa_service_path;
	htp.p(htf.header(3, 
		htf.anchor(path || 'webdba.SQLForm', 'SQL') || ' | ' ||
		htf.anchor(path || 'webdba.queryForm?ctable='  || ctable, 'QUERY') || ' | ' ||
		htf.anchor(path || 'webdba.insertForm?ctable=' || ctable, 'INSERT') || ' | ' ||
		htf.anchor(path || 'webdba.updateForm?ctable=' || ctable, 'UPDATE') || ' | ' ||		
		htf.anchor(path || 'webdba.deleteForm?ctable=' || ctable, 'DELETE') || ' | ' ||
		htf.anchor(path || 'webdba.showsource?cname=browse', 'OPB')));
	htp.centerClose;
end buttonBar;


procedure demo is
begin

  webdba.navigate('emps');

end demo;

/* procedure find is
begin
 webdba.header('Web*DBA Find');
 htp.header(2, 'Find Database Object: ');
 htp.formOpen(owa_util.get_owa_service_path || ' webdba.execFind');
 htp.form
 

end find; */


/*
procedure browse is
begin
 webdba.header('Web*DBA');
 service_name_path := owa_util.get_owa_service_path;
 htp.header(2, 'Choose a Database: ');

 for c1 in (
	select 'LOCAL' db_link 
	from dual 
	union all 
		select db_link 
		from sys.all_db_links 	
		order by db_link
	   ) loop

 htp.img('/ows-img/database.gif'
 end loop;




exception
 when others then
	htp.br;
	htp.img('/ows-img/error.gif');
	htp.p('Error Web*DBA.browse');
	htp.p(sqlerrm);
end browse;

*/

 procedure SQLForm is
 begin
 webdba.header('Oracle Web*DBA');

 htp.header(2, 'Enter SQL: ');
 htp.formOpen(owa_util.get_owa_service_path || 'webdba.execSELECT');
 htp.formTextAreaOpen('csql', 10, 60, 'CENTER');
 htp.p('SELECT * FROM dictionary');
 htp.formTextAreaClose;
 htp.formSubmit(NULL, 'Execute SQL');
 htp.formReset;
 htp.formClose;

 htp.bodyClose;
 htp.htmlClose;
end SQLForm;

procedure tablePrint(ctable       in varchar2,
                       cattributes  in varchar2 DEFAULT NULL,
                       ccolumns     in varchar2 DEFAULT '*',
                       cclauses     in varchar2 DEFAULT NULL,
                       ccol_aliases in varchar2 DEFAULT NULL,
		       nrows	    in number DEFAULT 10,
             	       nrow_min     in number DEFAULT 0,
                       nrow_max     in number DEFAULT NULL) is

 NOT_IN_SELECT_LIST exception;
 pragma exception_init(NOT_IN_SELECT_LIST, -1007);
 up_cnt		integer := 0;
 c1 		integer := 0;
 col_names   	owa_util.ident_arr;
 col_aliases 	owa_util.ident_arr;
 fkeys_par	owa_util.ident_arr;
 fkeys_col	owa_util.ident_arr;
 fkeys_child	owa_util.ident_arr;
 num_aliases 	integer := 0;
 col_dtypes  	owa_util.ident_arr;
 col_sizes   	owa_util.num_arr;
 nnum_cols   	integer := 0;
 res 		integer := 0;
 colValue 	varchar2(2000);
 row_count	integer := 0;
 foreign_key_found boolean;
 data_align	varchar2(5);
 table_resolved varchar2(30);
 owner_resolved varchar2(30);
 db_link_resolved varchar2(30);
 where_clause varchar2(2000);
 num_rows integer := 0;
 count_cursor integer;
 begin
	owa_util.resolve_table(ctable, USER, table_resolved, owner_resolved, db_link_resolved);
      	owa_util.describe_cols(ctable, ccolumns, col_names, col_dtypes, nnum_cols);
	owa_util.comma_to_ident_arr(ccol_aliases, col_aliases, num_aliases);

	count_cursor := dbms_sql.open_cursor;
	dbms_sql.parse(count_cursor, 'select count(*) from '||ctable||' '||cclauses,dbms_sql.v7);
	dbms_sql.define_column(count_cursor,1,num_rows);
	res := dbms_sql.execute(count_cursor);
	if(dbms_sql.fetch_rows(count_cursor) > 0) then
	  dbms_sql.column_value(count_cursor,1,num_rows);
	end if;

	c1 := dbms_sql.open_cursor;
	dbms_sql.parse(c1,'SELECT '||ccolumns||' FROM '||ctable||' '||cclauses, dbms_sql.v7);
	
-- Define Columns to be selected.
-- Loop through all the possible columns, 1 to 254, 
-- SQL Language Reference Manual "Create Table", p. 4-208

	for i in 1..nnum_cols loop
	  begin
	    	dbms_sql.define_column(c1, i, colValue, 2000);
	  exception
	    	when NOT_IN_SELECT_LIST then exit;
	    	when others then raise;
	  end;
	end loop;
	res := dbms_sql.execute(c1);

-- Determine if this Table Column has a Foreign Key Reference
-- and create a Header that is a Link to the Foreign Table
-- selecting all rows.

	htp.br('ALL');
	if (nrow_min > 1) then 
	  htp.formImage('left_button', '/ows-img/arrowleft.gif', 'LEFT','BORDER=0'); 
	end if;
	if (num_rows > nrow_max) then 
	  htp.formImage('right_button', '/ows-img/arrowright.gif', 'RIGHT','BORDER=0'); 
	end if;
	htp.br('ALL');
      	htp.centerOpen;

	htp.tableOpen(cattributes=>cattributes);
	htp.tableRowOpen;
	for i in 1..nnum_cols loop
          fkeys_par(i) := NULL;
 	  fkeys_col(i) := NULL;
	  for fkeys in ( 	
	    select 	p_col.table_name parent_table, p_col.column_name parent_col, ch_col.column_name child_col
	    from 	sys.all_cons_columns ch_col, sys.all_cons_columns p_col, 
			sys.all_constraints child, sys.all_constraints parent
	    where  	child.table_name = upper(ctable)
		  	and child.owner = upper(owner_resolved)
			and child.r_constraint_name = parent.constraint_name
			and child.r_owner = parent.owner
			and parent.constraint_name = p_col.constraint_name
			and parent.owner = p_col.owner
			and child.constraint_name = ch_col.constraint_name
			and child.owner = ch_col.owner) loop	
	
	    if (upper(col_names(i)) = upper(fkeys.child_col)) then
	      fkeys_par(i) := fkeys.parent_table;
	      fkeys_col(i) := fkeys.parent_col;
	      if(i> num_aliases) then
		  htp.tableHeader(htf.anchor(owa_util.get_owa_service_path||
			'webdba.navigate?ctable='||fkeys.parent_table, col_names(i)));
	      else
		  htp.tableHeader(htf.anchor(owa_util.get_owa_service_path||
				'webdba.navigate?ctable='||fkeys.parent_table, col_aliases(i)));
	      end if;
	    end if;
	  end loop; 
-- END FOREIGN KEYS CURSOR LOOP

	  if(fkeys_par(i) IS NULL) then
	    if (i > num_aliases) then
		htp.tableHeader(col_names(i));
	    else
	  	htp.tableHeader(col_aliases(i));
	    end if;
	  end if;

	end loop;
-- END COLUMN HEADERS LOOP

	htp.tableRowClose;	
	
	row_count := 1;
	while (row_count < nrow_min) loop
	  if (dbms_sql.fetch_rows(c1) > 0) then 
		row_count := row_count + 1;
	  else exit;
	  end if;
	end loop;

	while ((nrow_max IS NULL) or (row_count <= nrow_max)) loop
	  if (dbms_sql.fetch_rows(c1) > 0) then
		row_count := row_count + 1;
		htp.tableRowOpen;
		for i in 1..nnum_cols loop
	  	  if (col_dtypes(i) = 'NUMBER') then
			data_align := 'RIGHT';
		  else
			data_align := 'LEFT';
		  end if;
		  
		  dbms_sql.column_value(c1, i, colValue);

-- Construct the CELL ANCHOR by appending a [WHERE CLAUSE parent_column = VALUE] to the table selection

		  if(fkeys_par(i) IS NOT NULL) then
			where_clause := 'WHERE '||fkeys_col(i)||'='||''''||colValue||'''';
			owa_cgi.encode_url(where_clause);
--			htp.p(where_clause);		 	
		 	htp.tableData(htf.anchor(owa_util.get_owa_service_path||
				'webdba.navigate?ctable='||fkeys_par(i)||'&cclauses='||where_clause, colValue), data_align);
		  else		
		  	htp.tableData(colValue, data_align);
		  end if;
		end loop;
		htp.tableRowClose;
-- NO more ROWS exit the LOOP
	  else exit;
	  end if;
	end loop;
	dbms_sql.close_cursor(c1);
	htp.tableClose;   
	htp.centerClose;

	htp.br('ALL'); 
	if (nrow_min > 1) then 
	  htp.formImage('left_button', '/ows-img/arrowleft.gif', 'LEFT','BORDER=0'); 
	end if;
	if (num_rows > nrow_max) then 
	  htp.formImage('right_button', '/ows-img/arrowright.gif', 'RIGHT','BORDER=0'); 
	end if;
	htp.br('ALL'); 

	up_cnt := 0;
	for fkeys in (
	    select 	p_col.table_name parent_table, p_col.column_name parent_col, 
			ch_col.table_name child_table, ch_col.column_name child_col
	    from 	sys.all_cons_columns ch_col, sys.all_cons_columns p_col, 
			sys.all_constraints child, sys.all_constraints parent
	    where  	parent.table_name = upper(ctable)
		  	and parent.owner = upper(owner_resolved)
			and parent.constraint_name = child.r_constraint_name
			and parent.owner = child.r_owner
			and child.constraint_name = ch_col.constraint_name
			and child.owner = ch_col.owner
			and parent.constraint_name = p_col.constraint_name
			and parent.owner = p_col.owner) loop	

--		htp.p('PARENT TABLE: '||fkeys.parent_table||' PARENT COL: '||fkeys.parent_col
--				||' CHILD TABLE: '||fkeys.child_table||' CHILD COL: '||fkeys.child_col);

		up_cnt := up_cnt + 1;
		fkeys_child(up_cnt) := fkeys.child_table;
	end loop;

	htp.centerOpen;
	htp.tableOpen;
	htp.tableRowOpen;
	htp.p('<TD>');
	htp.strong('Number of Rows:');
	htp.formText('nrows', 3,3,nrows);
	htp.p('</TD>'); 
	if (up_cnt > 0) then
	  htp.p('<TD>');
	  htp.p('<STRONG>');
	  htp.formSelectOpen('cuptable',htf.strong('Up to Table:'));
	  
	  for j in 1..up_cnt loop
		htp.formSelectOption(fkeys_child(j));
	  end loop;

	  htp.formSelectClose;
	  htp.p('</STRONG>');
	  htp.p('</TD>');

/*	  htp.p('<TD>');
	  htp.p('<STRONG>');
	  htp.formSelectOpen('cupval');
	  htp.formSelectOption('All Values', 'SELECTED');
	  htp.formSelectOption('Values Selected');
	  htp.formSelectOption('Enter Value: ');
	  htp.formSelectClose;
	  htp.p('</STRONG>');
	  htp.p('</TD>');
	  htp.p('<TD>');
	  htp.formText('cuptext', 5);
	  htp.p('</TD>'); 
*/
	  htp.p('<TD>');
	  htp.formImage('up_button','/ows-img/arrowup.gif',cattributes=>'BORDER=0');
	  htp.p('</TD>');
	end if;
	htp.tableRowClose;
	htp.tableClose;
	htp.centerClose;

exception
	when others then
	  if (dbms_sql.is_open(c1)) then
	  	dbms_sql.close_cursor(c1);
	  end if;
	  raise;
end tablePrint;


procedure navigate(	ctable		in varchar2,
                       	cattributes  	in varchar2 DEFAULT 'BORDER=8 CELLPADDING=5 CELLSPACING=3',
                       	ccolumns     	in varchar2 DEFAULT '*',
                       	cclauses     	in varchar2 DEFAULT NULL,
                       	ccol_aliases 	in varchar2 DEFAULT NULL,
		       	nrows	    	in number DEFAULT 10,
                       	nrow_min     	in number DEFAULT 0,
                       	nrow_max     	in number DEFAULT NULL,
		       	cuptable	in varchar2 DEFAULT NULL,
		       	cupval	    	in varchar2 DEFAULT NULL,
		       	cuptext	    	in varchar2 DEFAULT NULL,		       
		       	left_button     in owa_image.point DEFAULT empty_point,
		       	right_button	in owa_image.point DEFAULT empty_point,
		       	up_button	in owa_image.point DEFAULT empty_point) is
 res integer;
 new_table varchar2(2000);
 new_columns varchar2(2000);
 new_clauses varchar2(2000);
 new_col_aliases varchar2(2000);
 new_row_min integer := 0;
 new_row_max integer := 0;
 begin
	new_table := ctable;
	new_columns := ccolumns;
        new_clauses := cclauses;
	new_col_aliases := ccol_aliases;

-- Determine if the page was activated by a LEFT, RIGHT, or UP button press
	begin
	if(up_button(1) IS NOT NULL) then	
	  new_table := cuptable;	
	  new_columns := '*';
          new_clauses := NULL;
	  new_col_aliases := NULL;
	  new_row_min := 1;
	  new_row_max := nrows;
	end if;
	exception
	  when no_data_found then null;
	  when others then raise;
	end;
	begin
	if(left_button(1) is not null) then	
	  new_row_min := nrow_min - nrows;
	  new_row_max := nrow_max - nrows;
	end if;
	exception
	  when no_data_found then null;
	  when others then raise;
	end;
	begin
	if(right_button(1) is not null) then 	
	  new_row_min := nrow_min + nrows;
	  new_row_max := nrow_max + nrows;
	end if;
	exception
	  when no_data_found then null;
	  when others then raise;
	end;

-- Determine which rows should be displayed once the form is submitted	
	if ((nrow_max IS NULL) AND (nrow_min = 0)) then 
	  new_row_min := 1; 
	  new_row_max := nrows; 
	end if;

	webdba.header('Table Navigator: '||upper(new_table));
	htp.formOpen(owa_util.get_owa_service_path||'webdba.navigate','GET');

-- Hide all the incoming parameters in the form so next and previous arrows can regenerate the table
	htp.formHidden( 'ctable', 	new_table);
      	htp.formHidden( 'ccolumns', 	new_columns);
      	htp.formHidden( 'cclauses', 	new_clauses);
      	htp.formHidden( 'ccol_aliases', new_col_aliases);
      	htp.formHidden( 'nrow_min', 	new_row_min);
      	htp.formHidden( 'nrow_max', 	new_row_max);

/*	htp.p('COUNT: '||num_rows);
	htp.p('ctable: '||NVL(ctable,'NULL')||' cattributes: '||
		NVL(cattributes,'NULL')||' ccolumns: '||
		NVL(ccolumns,'NULL')||' cclauses: '||NVL(cclauses,'NULL')||' ccol_aliases: '||
		NVL(ccol_aliases,'NULL')||' nrow_min: '||
		NVL(TO_CHAR(nrow_min),'NULL')||' nrow_max: '||NVL(TO_CHAR(nrow_max),'NULL')); 
	htp.p('new_row_min: '||new_row_min);
	htp.p('new_row_max: '||new_row_max);
	htp.p('nrows: '||nrows); */

	webdba.tablePrint( new_table, cattributes, new_columns, new_clauses, 
			   new_col_aliases, nrows, new_row_min, new_row_max ); 
	
	htp.formClose;
	buttonBar(new_table);
      	htp.bodyClose;
      	htp.htmlClose;
 end;
 
procedure insertForm(ctable in varchar2) is

cursor c1 (restable in varchar2, resowner in varchar2) is 
	SELECT column_name, data_length, data_type
	FROM all_tab_columns 
	WHERE 	table_name = upper(restable)
		AND owner = upper(resowner)
	ORDER BY column_id;

 rows integer;
 table_resolved varchar2(30);
 owner_resolved varchar2(30);
 db_link_resolved varchar2(30);
 MAX_TEXT_LENGTH integer :=50;
begin

 owa_util.resolve_table(ctable, USER, table_resolved, owner_resolved, db_link_resolved);
	
 webdba.header('Insert: '||upper(ctable));

 htp.formOpen(owa_util.get_owa_service_path || 'webdba.execInsert');
 htp.formHidden('ctable', ctable);
 
 htp.tableOpen;

 for crec in c1(table_resolved, owner_resolved) loop
  	htp.tableRowOpen;	

-- Print the COLUMN NAME followed by the column DATA_TYPE

	htp.tableData(htf.strong(initcap(translate(crec.column_name,'_',' '))), 'LEFT', NULL, 'NOWRAP');
	htp.tableData(htf.img('/ows-img/'||lower(translate(crec.data_type,' ','_'))||'.gif',
		NULL, lower(crec.data_type)), 'LEFT');

	htp.formHidden('cnames',crec.column_name);
	htp.formHidden('ctypes',crec.data_type);

	if (crec.data_length <= MAX_TEXT_LENGTH) then
		htp.tableData(htf.formText('cvalues', crec.data_length));
	else
		htp.tableData(htf.formTextarea('cvalues', 3, MAX_TEXT_LENGTH));
	end if;

 htp.tableRowClose;
 end loop;
 htp.tableClose;
 htp.nl;
 htp.formSubmit(NULL, ' Execute Insert ');
 htp.formReset(' Reset ');
 htp.formClose;

 buttonBar(ctable);

 htp.bodyClose;
 htp.htmlClose;
end;



procedure queryForm(ctable in varchar2) is

 cursor c1 (restable in varchar2, resowner in varchar2) is 
	SELECT column_name, data_length, data_type 
	FROM all_tab_columns 
	WHERE 	table_name = upper(restable)
		AND owner = upper(resowner)
	ORDER BY column_id;

 table_resolved varchar2(30);
 owner_resolved varchar2(30);
 db_link_resolved varchar2(30);
 MAX_TEXT_LENGTH integer := 50;

begin
 owa_util.resolve_table(ctable, USER, table_resolved, owner_resolved, db_link_resolved);

 webdba.header('Query: '||upper(ctable));

 htp.formOpen(owa_util.get_owa_service_path || 'webdba.execQuery');
 htp.formHidden('ctable', ctable);
 htp.formHidden('COLS', 'dummy');
 htp.tableOpen;
 for crec in c1(table_resolved, owner_resolved) loop
	htp.tableRowOpen;
	
-- Print the SELECT CHECKBOXes
	htp.tableData(htf.formCheckbox('COLS', crec.column_name), 'RIGHT');

-- Print the COLUMN NAME followed by the column DATA_TYPE
  	htp.tableData(htf.strong(initcap(translate(crec.column_name,'_',' '))), 'LEFT', NULL, 'NOWRAP');
	
	htp.tableData(htf.img('/ows-img/'||lower(translate(crec.data_type,' ','_'))||'.gif', 
		NULL, lower(crec.data_type)), 'LEFT');


-- Kelly add CONSTRAINT checking to print out SELECT/OPTION list of possible values if CHECK CONSTRAINT exists!!!

	htp.formHidden( 'cnames', crec.column_name );
	if (crec.data_length <= MAX_TEXT_LENGTH) then
		htp.tableData(htf.formText( 'cvalues', crec.data_length));
	else
		htp.tableData(htf.formTextarea( 'cvalues', 3, MAX_TEXT_LENGTH));
	end if;

	htp.tableRowClose;
 end loop;
 htp.tableClose;
 htp.nl;
 htp.formSubmit(NULL, 'Execute Query');
 htp.formClose;

 buttonBar(ctable);
 htp.bodyClose;
 htp.htmlClose;
end;

 procedure execQuery(ctable in varchar2, cnames in array, cvalues in array, cols in owa_util.ident_arr) is
   select_clause varchar2(32767);
   where_clause varchar2(32767);
   val varchar2(2000);
   operand varchar2(6) := '';
   i integer;
 begin
   i := 2;
   loop
     select_clause := select_clause||cols(i)||',';
     i := i + 1;
   end loop;
 
 exception
 when NO_DATA_FOUND then
 	begin
	if (select_clause IS NULL) then 
		select_clause := '*';
	else 
		select_clause := substr(select_clause,1,length(select_clause)-1);
	end if;
	
	i := 1;

	loop
	  if (cvalues(i) IS NOT NULL ) then
	     val := cvalues(i);
	    if(substr(cvalues(i),1,1)) in ('>','<','=') then 
		operand := ' '||substr(cvalues(i),1,1)||' ';
		val := ltrim(substr(cvalues(i),2, length(cvalues(i))), ' ');
	    elsif (owa_pattern.match(cvalues(i),'\w*%\w*')) then
		operand := ' LIKE ';
	    else
		operand := ' = '; 
	    end if;
	    if (where_clause IS NULL) then
		where_clause := 'WHERE '||cnames(i)||operand||''''||val||'''';
	    else
	    	where_clause := where_clause||' AND '||cnames(i)||operand||''''||val||'''';
	    end if;	 
	  end if;	
	  i := i + 1;
	end loop;

	exception 
	when NO_DATA_FOUND then
--	htp.p(where_clause);
	  webdba.navigate(ctable=>ctable, ccolumns=>select_clause, cclauses=>where_clause);
	end;

end;

procedure showsource(cname in varchar2) is
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

      owa_util.mime_header('application/x-pls');  

      for source_rec in c1 (procname, procowner)
      loop
         if (source_rec.line = 1)
         then
            line1s := line1s + 1;
            if (line1s = 2)
               then htp.print;
            end if;
         end if;

         htp.prints(translate(source_rec.text,NL_CHAR,' '));
      end loop;
 end;

 procedure execInsert(ctable in varchar2, cnames in array, cvalues in array, ctypes in array) is
   insert_names varchar2(32767);
   insert_values varchar2(32767);
   i integer;
 begin
	insert_names := '(';
	insert_values := '(';	

	i := 1;
	loop
	  if ( (i > 1) and (cnames(i) IS NOT NULL) ) then
		insert_names := insert_names||',';
		insert_values := insert_values||',';
	  end if;

	  if (cnames(i) IS NOT NULL ) then
		insert_names := insert_names||cnames(i);
	  	if (ctypes(i) != 'NUMBER' ) then
			insert_values := insert_values||''''||cvalues(i)||'''';
		else
			insert_values := insert_values||REPLACE(cvalues(i),',');
		end if;
	  end if;
	  i := i + 1;
	end loop;

	exception 
	when NO_DATA_FOUND then
	insert_names := insert_names||')';
	insert_values := insert_values||')';


	webdba.execSQL('INSERT INTO '||ctable||' '||insert_names||' VALUES '||insert_values);
--	htp.p('INSERT INTO '||ctable||' '||insert_names||' VALUES '||insert_values);
	webdba.navigate(ctable);
	
end execInsert;

procedure execSELECT(csql in varchar2) is
begin

--	execSQL('CREATE TABLE kelly AS SELECT * FROM SCOTT.EMP');
--	htp.p('hello kelly');
	webdba.execSQL('CREATE OR REPLACE VIEW tmpview AS '||translate(csql,';',' '));
	webdba.navigate('tmpview');
	webdba.execSQL('DROP VIEW tmpview');
end execSELECT;

procedure execSQL(csql in varchar2) is
c1 number;
res number;
begin 
	c1 := dbms_sql.open_cursor;
	dbms_sql.parse(c1, csql, dbms_sql.v7);
	res := dbms_sql.execute(c1);
	dbms_sql.close_cursor(c1);

end execSQL;


/* procedure tablePrint(csql in varchar2) is
NOT_IN_SELECT_LIST exception;
pragma exception_init(NOT_IN_SELECT_LIST, -1007);
res number;
c1 integer;
ctr integer := 0;
colValue varchar2(2000);
begin
	htp.tableOpen('BORDER=8');
	c1 := dbms_sql.open_cursor;
	dbms_sql.parse(c1, csql, dbms_sql.v7);

-- Define Columns to be selected.
-- Loop through all the possible columns, 1 to 254, 
-- SQL Language Reference Manual "Create Table", p. 4-208

	for i in 1 .. 254 loop
	begin
		dbms_sql.define_column(c1, i, colValue, 2000);
		ctr := ctr + 1;
	exception
	when NOT_IN_SELECT_LIST then exit;
	when others then raise;
	end;
	end loop;

	res := dbms_sql.execute(c1);
	
	loop
	exit when (dbms_sql.fetch_rows(c1) <= 0);
		htp.tableRowOpen;
		for i in 1 .. ctr loop
			dbms_sql.column_value(c1, i, colValue);
			htp.tableData(colValue);
		end loop;
		htp.tableRowClose;
	end loop;	
	dbms_sql.close_cursor(c1);	
	htp.tableClose;
exception
when others then 
	if (dbms_sql.is_open(c1)) then 
		dbms_sql.close_cursor(c1); 
	end if;
	raise; -- reraise the exception

end execSQL;
*/

-- procedure exec_sql (csql in varchar2) is
-- c1 number;
-- res number;
-- begin
--	c1 := dbms_sql.open_cursor;
--	dbms_sql.parse(c1, csql, dbms_sql.v7);
--	res := dbms_sql.execute(c1);
--	dbms_sql.close_cursor(c1);
--
-- exception
--	when webdb.my_exception then
--		insert into msg values ('got exception');
--	when others then
--		insert into msg values ('got others');
--
--		
-- end;	


end;
/
show errors;
