rem (c) 1995, 1996 Oracle Corporation.  All rights reserved.
rem
rem Created
rem	9/6/95	mlonnrot
rem
rem Modified
rem
rem Description
rem	WebServer/WebStation integration demo
rem
rem	Screens:
rem	1) tree - display entire emp tre
rem	2) person - display 1 person

create or replace package hr is
	image_dir varchar2(255) := '/hr-img/';
	fancy_background boolean := false;
--
	override_authentication boolean := true;
	procedure tree;
	procedure tree (itop in varchar2);
	procedure person (iempno in varchar2);
	procedure person (iempno in varchar2,iurlname in varchar2,iurl in varchar2);
end;
/
show errors

create or replace package body hr is
	prolog_done boolean;
--
	function ceo return number is
		cursor emp_ceo is
			select empno from emp where mgr is null;
		the_ceo emp.empno%type;
	begin
		open emp_ceo;
		fetch emp_ceo into the_ceo;
		if emp_ceo%found then
			return the_ceo;
		else
			raise no_data_found;
		end if;
	end;
--
	function inline (img in varchar2, alt in varchar2 := null,
			attr in varchar2 := null) return varchar2 is
	begin
		return htf.img(image_dir || img,null,nvl(alt,img),
			null,nvl(attr,'border=0'));
	end;
--
	procedure inline (img in varchar2, alt in varchar2 := null,
			attr in varchar2 := null) is
	begin
		htp.p(inline(img,alt,attr));
	end;
--
	procedure prolog(c in varchar2) is
	begin
		if not prolog_done then
			htp.htmlOpen;
			htp.headOpen;
				htp.title(c);
				htp.base;
			htp.headClose;
			if fancy_background then
				htp.bodyOpen(image_dir ||'chalk.jpg', 
					'link=#cd0000 vlink=#483d8b alink=#ff3300');
			else
				htp.bodyOpen;
			end if;
			inline('hr.gif');
			htp.nl;
		prolog_done := true;
		end if;
	end;
--
	procedure epilog is
	begin
		htp.hr;
		htp.anchor('hr.tree',inline('tag' || 
			to_char(random.rndint(4)+1) || 
			'.gif'),'border=0');
		htp.bodyClose;
		htp.htmlClose;
	end;
--
	function is_me (who in varchar2) return boolean is
	begin
		if who = upper(owa_util.get_cgi_env('remote_user')) then
			return true;
		end if;
		return false;
	end;
--
	function is_webstation return boolean is
	begin
		if owa_util.get_cgi_env('http_user_agent') like 
			'%WebStation%' then
			return true;
		end if;
		return false;
	end;
--
	function webstation_hook (c in varchar2) return varchar2 is
	begin
		if is_webstation then
			return 'method="csp:script" action="c:\travel\' 
			|| c || '"';
		end if;
		return null;
	end;
--
	procedure tree (itop in varchar2) is
		cursor emp_tree (this_mgr number) is
			select empno,ename,mgr,hiredate,sal,comm,level,deptno
			from emp
			connect by prior empno = mgr
			start with empno = this_mgr;
		prev_level number := 1;
		ntop emp.empno%type;
		cbuf varchar2(255);
	begin
		prolog('Employee Tree');
		htp.p('Select an employee for details.');
		if itop is not null then
			ntop := to_number(itop);
		else
			ntop := ceo;
		end if;
		for e in emp_tree(ntop) loop
			while e.level < prev_level loop
				htp.ulistClose;
				prev_level := prev_level - 1;
			end loop;
			while e.level > prev_level loop
				htp.ulistOpen;
				prev_level := prev_level + 1;
			end loop;
			cbuf := htf.anchor('hr.person?iempno=' ||
				to_char(e.empno),initcap(e.ename));
			if is_me(e.ename) then
				cbuf := cbuf || ' (This is you)';
			end if;
			if e.level = 1 then
				htp.header(3,cbuf);
			else
				htp.bold(cbuf);
				htp.nl;
			end if;
		end loop;
		while prev_level > 1 loop
			htp.ulistClose;
			prev_level := prev_level - 1;
		end loop;
		epilog;
	end;
--
	procedure one_row(nam in varchar2,val in varchar2) is
	begin
		htp.tableRowOpen;
		htp.tableData(nam,'right');
		htp.tableData(htf.bold(val));
		htp.tableRowClose;
	end;
	procedure emp_table (er in emp%rowtype) is
	begin
		htp.tableOpen('yes');
		one_row('Emp#',to_char(er.empno));
		one_row('Name',initcap(er.ename));
		one_row('Title',initcap(er.job));
		if er.mgr is not null then
			one_row('Manager',htf.anchor('hr.person?iempno=' || 
				to_char(er.mgr),to_char(er.mgr)));
		end if;
		one_row('Hiredate',to_char(er.hiredate));
		htp.tableClose;
	end;
--
	procedure person (iempno in varchar2) is
		cursor ec (this_empno in number) is
			select * from emp the
			where the.empno = this_empno;
		cursor xc (this_empno in number) is
			select * from emp_xtra the
			where the.empno = this_empno;
		er emp%rowtype;
		ex emp_xtra%rowtype;
	begin
		open ec(to_number(iempno));
		fetch ec into er;
		if ec%notfound then
			raise no_data_found;
		end if;
		close ec;
		open xc(to_number(iempno));
		fetch xc into ex;
		if xc%notfound then
			raise no_data_found;
		end if;
		close xc;
		prolog(initcap(er.ename));
		inline(ex.img,er.ename,'align=left');
		inline(lower(er.ename) || '.gif');
		htp.nl;
		emp_table(er);
		htp.nl;
		htp.anchor('hr.tree','Return to top.');
		htp.nl('left');
		htp.hr;
		if ex.url is not null then
			htp.header(3,htf.anchor(ex.url,ex.urlname));
		end if;
		if is_me(er.ename) or override_authentication then
			htp.formOpen('hr.person');
			htp.formHidden('iempno',to_char(er.empno));
			htp.header(3,'Personal Link');
                        htp.print ('If you enter a description and ');
                        htp.print ('URL in the boxes provided, a link to ');
                        htp.print ('that URL will appear under the ');
                        htp.print ('photograph so you can click on it and ');
                        htp.print ('go directly to the employee''s home ');
                        htp.print ('page.');
			htp.para;
			htp.preOpen;
			htp.bold('Description: ' || htf.formText('iurlname',40,255,ex.urlname));
			htp.bold('        URL: ' || htf.formText('iurl',40,255,ex.url));
			htp.preClose;
			htp.formSubmit;
		end if;
		epilog;
	end;
--
	procedure person (iempno in varchar2,iurlname in varchar2, iurl in varchar2) is
	begin
		update emp_xtra
		set url = iurl, urlname=iurlname
		where empno = to_number(iempno);
		person(iempno);
	end;
--
	procedure tree is
	begin
		tree(null);
	end;
begin
	prolog_done := false;
end;
/
show errors
