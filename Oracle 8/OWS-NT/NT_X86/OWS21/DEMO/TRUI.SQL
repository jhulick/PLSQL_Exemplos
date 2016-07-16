rem Copyright (c) 1995, 1996 Oracle Corporation. All rights reserved.
rem 
rem Created
rem 08/18/95	mlonnrot
rem
rem Modified
rem
rem Description
rem 	This is a demo travel agency on the web. A visitor will be able to
rem	purchase tickets for various travel events as well as visit the
rem	sights on-line.
rem
rem Objectives
rem	Demonstrate functions that are difficult and/or time-consuming to 
rem	implement with traditional CGI programming.
rem
rem Implementation
rem	The following is a description of high level functions in the demo:
rem
rem		1) Home page. Create new account or connect with existing.
rem		2) Status screen. Provides details of purchase and travel
rem		   history as well as current tickets and balance.
rem		3) Special offers. Upcoming travel events the user may join.
rem		4) Travel event details. Display details about a travel event.
rem		5) Travel details. The virtual tour.
rem		6) Buy tickets.
rem		7) Sell tickets.
rem

create or replace package tr is
	procedure splash;
	procedure auth(cookie in varchar2,iuser in varchar2,
		ipasswd in varchar2,iaction in varchar2);
	procedure home(cookie in varchar2);
	procedure prefs(cookie in varchar2);
	procedure prefsUpdate(cookie in varchar2,iname in varchar2,
		iaddress in varchar2,icity in varchar2,izip in varchar2,
		istate in varchar2,icountry in varchar2,iemail in varchar2,
		ibalance in varchar2,ilang in varchar2,iimg_loc in varchar2,
		ipagehist in varchar2,idesc in varchar2,iaction in varchar2);
	procedure dests(cookie in varchar2);
	procedure city(cookie in varchar2,icity in varchar2);
	procedure ticket(cookie in varchar2,ifrom in varchar2, ito in varchar2);
	procedure purchase(cookie in varchar2,idate in varchar2,iqty in varchar2,iseat in varchar2);
	dateformat varchar2(9) := 'dd-Mon-yy';
	function get_state return state_data%rowtype;
end;
/
show errors

create or replace package tru is
	procedure prolog(c in varchar2);
	procedure epilog;
	procedure failure (txt in varchar2);
	procedure die (txt in varchar2,errmsg in varchar2);
	procedure toolbar(cookie in varchar2,iurl in varchar2);
	procedure loginForm(cookie in varchar2);
	procedure prefsForm(cookie in varchar2,cu in customer_data%rowtype);
	procedure success (txt in varchar2);
	procedure inline (img in varchar2, alt in varchar2 := null,attr in varchar2 := null);
	function inline (img in varchar2, alt in varchar2 := null,attr in varchar2 := null) return varchar2;
	function title_gif(icity in varchar2) return varchar2;
	function html(c in varchar2) return varchar2;
	procedure dbimage ( iid in varchar2);
	function has_tables return boolean;
	function links_in_tables return boolean;
	procedure webstation_ticker;
	function webstation_hook (c in varchar2) return varchar2;
	prolog_done boolean;
	image_dir constant varchar2(20) := '/tr-img/';
end;
/
show errors

create or replace package body tru is
	st state_data%rowtype;
	de description_data%rowtype;
--
--	Get state struct from tr package if needed
--
	procedure get_state_if_needed is
	begin
		if st.id is null then
			st := tr.get_state;
		end if;
	end;
--
--	Opening center tag
--
	procedure centerOn is
	begin
		htp.p(html('center'));
	end;
--
--	Closing center tag
--
	procedure centerOff is
	begin
		htp.p(html('/center'));
	end;
--
--	Header info for each page
--
	procedure prolog(c in varchar2) is
	begin
		if not prolog_done then
			htp.htmlOpen;
			htp.headOpen;
				htp.title(c);
				htp.base;
			htp.headClose;
			htp.bodyOpen;
		prolog_done := true;
		end if;
	end;
--
--	Footer on each page
--
	procedure epilog is
	begin
		htp.hr;
		inline('tag' || to_char(random.rndint(4)+1) || '.gif');
		htp.bodyClose;
		htp.htmlClose;
	end;
--
--	Any nonstandard HTML
--
	function html(c in varchar2) return varchar2 is
	begin
		return '<' || c || '>';
	end;
--
--	Returns true if client understands html-3 tables
--
	function has_tables return boolean is
	begin
		get_state_if_needed;
		if 	st.http_user_agent like 'Mozilla%' or
			st.http_user_agent like '%PowerBrowser%' or
			st.http_user_agent like 'Enhanced_Mosaic/2.1%' or
			st.http_user_agent like 'NCSA_Mosaic%' then
			return true;
		end if;
		return false;
	end;
--
--	Returns true if client is Oracle PowerBrowser (or "WebStation") 
--
	function is_webstation return boolean is
	begin
		get_state_if_needed;
		if st.http_user_agent like '%PowerBrowser%' then
			return true;
		end if;
		return false;
	end;
--
--	Generate inline code for Webstation applet
--
	procedure webstation_ticker is
	begin
		if is_webstation then
--			htp.p(html('nlo type=msgtiker src=c:\trains.dat width=380 height=15 align=left'));
			htp.p(html('nlo type=msgtiker src="applet.get?iname=trains.dat" width=380 height=15 align=left'));
			htp.nl('left');
		end if;
	end;
--
--	Generate inline code for Webstation validation applet (in html form submit button)
--
	function webstation_hook (c in varchar2) return varchar2 is
	begin
		if is_webstation then
--			return 'method="csp:script" action="c:\travel\' || c || '"';
			return 'method="csp:script" action="applet.get?iname='||c||'"';
		end if;
		return null;
	end;
--
--	Return true if client understand anchors in table cells
--
	function links_in_tables return boolean is
	begin
		get_state_if_needed;
		if 	st.http_user_agent like 'Mozilla%' or
			is_webstation or
			st.http_user_agent like 'Enhanced_Mosaic/2.1%' then
			return true;
		end if;
		return false;
	end;
--
--	Generate inline image
--
	procedure inline (img in varchar2, alt in varchar2,attr in varchar2) is
	begin
		htp.img(image_dir || img,null,nvl(alt,img),null,nvl(attr,'border=0'));
	end;
--
--	Generate inline image text
--
	function inline (img in varchar2, alt in varchar2,attr in varchar2) return varchar2 is
	begin
		return htf.img(image_dir || img,null,nvl(alt,img),null,nvl(attr,'border=0'));
	end;
--
--	Display error message
--
	procedure failure (txt in varchar2) is
	begin
		inline(message.msg(75));
		htp.nl;
		htp.bold(txt);
		htp.hr;
	end;
--
--	General purpose abend routine
--
	procedure die (txt in varchar2,errmsg in varchar2) is
	begin
		failure(message.msg(76) || htf.bold(txt) || message.msg(77));
		htp.code(errmsg);
		htp.hr;
		htp.anchor('tr.splash',htf.header(1,message.msg(78)));
	end;
--
--	Display toolbar
--
	procedure toolbar(cookie in varchar2,iurl in varchar2) is
	begin
		htp.para;
		if iurl != 'tr.home' then
			htp.anchor('tr.home?cookie=' || cookie, message.msg(57));
		end if;
		if iurl != 'tr.prefs' then
			htp.anchor('tr.prefs?cookie=' || cookie, message.msg(58));
		end if;
		if iurl != 'tr.dests' then
			htp.anchor('tr.dests?cookie=' || cookie, message.msg(59));
		end if;
		htp.anchor('tr.splash', message.msg(60));

	end;
--
--	Display login html form
--
	procedure loginForm (cookie in varchar2)is
	begin
		htp.formOpen('tr.auth');
		htp.preOpen;
			htp.formHidden('cookie',cookie);
			htp.p(htf.bold(message.msg(72)) || htf.formText('iuser'));
			htp.p(htf.bold(message.msg(73)) || htf.formPassword('ipasswd'));
			htp.p(htf.bold(message.msg(74)) || htf.formSubmit('iaction',message.msg(49),
				webstation_hook('password.scr')) || 
				htf.formSubmit('iaction',message.msg(50),webstation_hook('password.scr')));
		htp.preClose;
		htp.formClose;
	end;
--
--	Display form for updating prefs
--
	procedure prefsForm(cookie in varchar2,cu in customer_data%rowtype) is
		cursor c is
			select * from language_data
			order by name;
		ccheck varchar2(10);
	begin
		htp.formOpen('tr.prefsUpdate');
		htp.preOpen;
			htp.formHidden('cookie',cookie);
			htp.p(htf.bold(message.msg(61)) || htf.formText('iname',30,30,cu.name));
			htp.p(htf.bold(message.msg(62)) || htf.formText('iaddress',30,30,cu.address));
			htp.p(htf.bold(message.msg(63)) || htf.formText('icity',30,30,cu.city));
			htp.p(htf.bold(message.msg(65)) || htf.formText('istate',2,2,cu.state));
			htp.p(htf.bold(message.msg(64)) || htf.formText('izip',15,15,cu.zip));
			htp.p(htf.bold(message.msg(66)) || htf.formText('icountry',30,30,cu.country));
			htp.p(htf.bold(message.msg(67)) || htf.formText('iemail',30,30,cu.email));
			htp.p(htf.bold(message.msg(68)) || htf.formText('ibalance',12,12,to_char(cu.balance)));
			htp.preClose;
			htp.bold(message.msg(69));
			for r in c loop
				if r.id = cu.lang_id then
					ccheck := 'CHECKED';
				else
					ccheck := NULL;
				end if;
				htp.p(htf.formRadio('ilang',to_char(r.id),ccheck) ||r.name);
			end loop;
			htp.nl;
-- 			I can't figure out how to get the images into long fields without truncating...
--			htp.bold(message.msg(70));
--			if cu.img_loc = 'Filesystem' then
--				ccheck := 'CHECKED';
--			else
--				ccheck := null;
--			end if;
--			htp.p(htf.formRadio('iimg_loc','Filesystem',ccheck) || message.msg(51));
--			if cu.img_loc = 'Database' then
--				ccheck := 'CHECKED';
--			else
--				ccheck := null;
--			end if;
--			htp.p(htf.formRadio('iimg_loc','Database',ccheck) || message.msg(56));
--			htp.nl;
			htp.formHidden('iimg_loc','Filesystem');
			htp.bold(message.msg(119));
			ccheck := null;
			if cu.page_history = 1 then
				ccheck := 'CHECKED';
			end if;
			htp.p(htf.formRadio('ipagehist','1',ccheck) || message.msg(120));
			ccheck := null;
			if cu.page_history = 0 then
				ccheck := 'CHECKED';
			end if;
			htp.p(htf.formRadio('ipagehist','0',ccheck) || message.msg(121));
			htp.nl;
			htp.bold(message.msg(71));
			htp.nl;
			begin
				de := description.get(cu.desc_id);
			exception
				when no_data_found then
					null;
				when others then
					raise;
			end;
			htp.formTextareaOpen('idesc',3,80);
			htp.p(de.hype);
			htp.formTextareaClose;
			htp.nl;
			htp.p(htf.formSubmit('iaction',message.msg(53),webstation_hook('travpref.scr')) || 
				htf.formSubmit('iaction',message.msg(52)));
		htp.formClose;
	end;
--
--	Display success message
--
	procedure success (txt in varchar2) is
	begin
		inline(message.msg(79));
		htp.nl;
		htp.bold(txt);
		htp.hr;
	end;
--
--	Return name of image file containing a city name
--
	function title_gif(icity in varchar2) return varchar2 is
		x varchar2(80);
		y number(2);
	begin
		x := 't_';
		for y in 1..length(icity) loop
			if substr(icity,y,1) != ' ' then
				x := x || lower(substr(icity,y,1));
			end if;
		end loop;
		x := x || '.gif';
		return x;
	exception
		when others then
			htp.comment(message.msg(80));
	end;
--
--	Return image stored in db
--
	procedure dbimage ( iid in varchar2) is
		this_image varchar2(32760);
	begin
		this_image := image.get(to_number(iid));
		owa_util.mime_header('image/jpg');
		htp.prn(this_image);
	exception
		when others then
			tru.die('tru.db_image',sqlerrm);
	end;
end;
/
show errors

create or replace package body tr is
--
--	Global Variables
--
	st state_data%rowtype;
	cu customer_data%rowtype;
	de description_data%rowtype;
	ds destination_data%rowtype;
	di dest_img_data%rowtype;
	ev event_data%rowtype;
	go trip_data%rowtype;
	xx tx_data%rowtype;
	me varchar2(20);
	cnt number;
--
--	Exceptions
--
	http_authenticated exception;
	invalid_user exception;
	invalid_input exception;
--
--	Return current state to external caller
--
	function get_state return state_data%rowtype is
	begin
		return st;
	end;
--
--	Restore all state information from previous request
--
	procedure restore_state (cookie in varchar2) is
	begin
		st := state.get(cookie);
		if st.cust_id is not null then
			cu := customer.get(st.cust_id);
		end if;
		if cu.desc_id is not null then
			de := description.get(cu.desc_id);
		end if;
		if st.dest_id is not null then
			ds := destination.get(st.dest_id);
		end if;
		if st.event_id is not null then
			ev := event.get(st.event_id);
		end if;
		if st.trip_id is not null then
			go := trip.get(st.trip_id);
		end if;
	end;
--
--	Return Netscape specific font tag
--
	function fontup(x varchar2) return varchar2 is
	begin
		if st.http_user_agent like 'Mozilla%' then
			return tru.html('font size=+2') || substr(x,1,1) || tru.html('/font') || substr(x,2);
		else
			return x;
		end if;
	end;
--
--	Check if user is authenticated by webserver for this demo. If so, use remote_user
--	and raise http_authenticated exception in this demo
--
	procedure auth_user(iuser in varchar2) is
	begin
		if iuser is not null then
			begin
				cu := customer.get(iuser);
			exception
				when no_data_found then
					null;
				when others then
					raise;
			end;
			if cu.id is not null then
				raise http_authenticated;
			end if;
		end if;
	end;
--
--	Save process state
--
	procedure save_state is
	begin
		st.module := me;
		st.timestamp := sysdate;
		state.put(st);
	exception
		when others then
			tru.die(message.msg(81) || me || ')',sqlerrm);
	end;
--
--	Display random image for given city
--
	procedure random_city_image (ialign in varchar2) is
		this_img dest_img_data.img_id%type;
		this_file dest_img_data.filename%type;
		x number;
	begin
		x := random.rndint(dimg.cnt(ds.id));
		di.dest_id := ds.id;
		while x >= 0 and dimg.get(di) loop
			x := x-1;
			this_img := di.img_id;
			this_file := di.filename;
		end loop;
		if cu.img_loc = 'Database' then
			htp.anchor('tr.city?cookie=' || to_char(st.id) || '&icity=' || to_char(ds.id),
				htf.img('tru.dbimage?iid=' || to_char(this_img),null,message.msg(55),null,
					'width=384 height=256 border=0 ' || ialign));
		else
			htp.anchor('tr.city?cookie=' || to_char(st.id) || '&icity=' || to_char(ds.id),
				tru.inline(this_file,message.msg(55),
					'width=384 height=256 border=0 ' || ialign));
		end if;
	end;
--
--	Display page access stats if preference is set
--
	procedure page_stats is
	begin
		if cu.page_history = 1 then
			htp.hr;
			xx.url := me;
			xx.cust_id := cu.id;
			if tru.has_tables then
				htp.tableOpen('BORDER');
				htp.tableCaption(message.msg(82));
				htp.tableRowOpen;
				htp.tableHeader(message.msg(83));
				htp.tableHeader(message.msg(84));
				htp.tableHeader(message.msg(85));
				htp.tableHeader(message.msg(86));
				htp.tableHeader(message.msg(87));
				htp.tableRowClose;
			else
				htp.preOpen;
				htp.p(message.msg(122));
				htp.p(rpad(message.msg(83),20) || ' ' || rpad(message.msg(84),20) || ' ' || 
					rpad(message.msg(85),40) || ' ' || rpad(message.msg(86),30) || 
					' ' || rpad(message.msg(87),20));
				htp.p(rpad('-',20,'-') || ' ' || rpad('-',20,'-') || ' ' || 
					rpad('-',40,'-') || ' ' || rpad('-',30,'-') || ' ' || 
					rpad('-',20,'-'));
			end if;
			while tx.get(xx) loop
				if tru.has_tables then
					htp.tableRowOpen;
					htp.tableData(to_char(xx.timestamp,'dd-Mon-yy hh24:mi:ss'));
					htp.tableData(xx.remote_addr);
					htp.tableData(xx.http_user_agent);
					htp.tableData(xx.server_name);
					htp.tableData(xx.server_software);
					htp.tableRowClose;
				else
					htp.p(rpad(to_char(xx.timestamp,'dd-Mon-yy hh24:mi:ss'),20) || ' ' ||
						rpad(xx.remote_addr,20) || 
						' ' || rpad(xx.http_user_agent,40) || ' ' || rpad(xx.server_name,30) ||
						' ' || rpad(xx.server_software,20));
				end if;
			end loop;
			if tru.has_tables then
				htp.tableClose;
			else
				htp.preClose;
			end if;
		end if;
	end;
--
--	Display summary page access stats
--
	procedure page_count is
		delta number;
		cdelta varchar2(32);
	begin
		cnt := tx.cnt(me);
		htp.para;
		if cnt = 0 then
			htp.p(message.msg(88));
		else
			htp.p(message.msg(89) || to_char(cnt) || message.msg(90));
		end if;
		if cnt > 0 then
			xx := tx.last(me);
			htp.para;
			delta :=sysdate-xx.timestamp;
			if delta <= 1/24/60 then
				cdelta := to_char(delta*24*60*60,'90.0') || message.msg(91);
			elsif delta <= 1/24 then
				cdelta := to_char(delta*24*60,'90.0') || message.msg(92);
			elsif delta <= 1 then
				cdelta := to_char(delta*24,'90.0') || message.msg(93);
			else
				cdelta := to_char(delta,'9990.0') || message.msg(94);
			end if;
			htp.p(message.msg(95) || to_char(xx.timestamp,'dd-Mon-yy hh24:mi:ss') || message.msg(96) ||
				cdelta || message.msg(97));
		end if;
		if cnt > 0 then
			page_stats;
		end if;
	end;
--
--	Save transaction entry 
--
	procedure tx_save (iaction in number) is
	begin
		xx.auth_type := st.auth_type;
		xx.gateway_interface := st.gateway_interface;
		xx.http_user_agent := st.http_user_agent;
		xx.path_info := st.path_info;
		xx.path_translated := st.path_translated;
		xx.remote_host := st.remote_host;
		xx.remote_addr := st.remote_addr;
		xx.remote_user := st.remote_user;
		xx.remote_ident := st.remote_ident;
		xx.server_protocol := st.server_protocol;	
		xx.server_software := st.server_software;
		xx.server_name := st.server_name;
		xx.server_port := st.server_port;
		xx.script_name := st.script_name;
		xx.id := null;
		xx.tx_code := iaction;
		xx.cust_id := cu.id;
		xx.url := me;
		xx.p01 := cu.username;
		if iaction = tx.visit_link or iaction = tx.login_fail or iaction = tx.login_ok then
			xx.p02 := null;
			xx.p03 := null;
		elsif iaction = tx.create_user then
			xx.p02 := cu.passwd;
			xx.p03 := 'create user';
		elsif iaction = tx.modify_user then
			xx.p02 := null;
			xx.p03 := 'modify';
		elsif iaction = tx.drop_user then
			xx.p02 := null;
			xx.p03 := 'drop user';
		elsif iaction = tx.buy_ticket or iaction = tx.sell_ticket then
			xx.p02 := ds.name;
			xx.p03 := null;

		else
			tru.die(message.msg(98) || me || ')',message.msg(99) || to_char(iaction));
		end if;
		tx.put(xx);
	exception
		when others then
			tru.die(message.msg(98) || me || ')',sqlerrm);
	end;
--
--	Initial Splash screen
--
	procedure splash is
	begin
		me := 'tr.splash';
		st := state.new;
		st.counter := 1;
		st.lang_id := 1;
		save_state;
		auth_user(st.remote_user);
		tru.prolog(message.msg(54));
		tru.inline(message.msg(100),message.msg(1));
		htp.nl;
		tru.inline('train.jpg',message.msg(2));
		htp.nl;
		tru.webstation_ticker;
		htp.italic(fontup(message.msg(3)));
		tru.loginForm(to_char(st.id));
		htp.para;
		tru.epilog;
	exception
		when http_authenticated then
			home(to_char(st.id));
		when others then
			tru.die(me,sqlerrm);
	end;
--
--	Splash Screen after failed authentication
--
	procedure splash (cookie in varchar2) is
	begin
		me := 'tr.splash';
		restore_state(cookie);
		st.counter := st.counter + 1;
		save_state;
		tx_save(tx.login_fail);
		if st.counter > 3 then
			tru.prolog(message.msg(4));
			tru.inline(message.msg(101),message.msg(5));
			htp.nl;
			tru.inline('train.jpg',message.msg(2));
			htp.nl;
			htp.bold(message.msg(6) || st.remote_addr || message.msg(7));
			tru.epilog;
		else
			tru.prolog(message.msg(1));
			tru.failure(message.msg(8));
			tru.inline(message.msg(100),message.msg(1));
			htp.nl;
			tru.inline('train.jpg',message.msg(2));
			htp.nl;
			tru.webstation_ticker;
			htp.italic(message.msg(9) || to_char(st.counter));
			htp.para;
			tru.loginForm(cookie);
			htp.para;
			tru.epilog;
		end if;
	exception
		when http_authenticated then
			home(to_char(st.id));
		when others then
			tru.die(me,sqlerrm);
	end;
--
--	Authenticate or create a user
--		
	procedure auth(cookie in varchar2, iuser in varchar2,
		ipasswd in varchar2,iaction in varchar2) is
		duplicate_user exception;
	begin
		me := 'tr.auth';
		restore_state(cookie);
		save_state;
		state.cleanup;
		if iaction = message.msg(49) then
			begin
				cu := customer.get(iuser);
				if ipasswd != cu.passwd then
					raise invalid_user;
				end if;
				st.cust_id := cu.id;
				st.lang_id := cu.lang_id;
				save_state;
				tx_save(tx.login_ok);
				home(cookie);
			exception
				when no_data_found then
					raise invalid_user;
				when others then
					raise;
			end;
		elsif iaction = message.msg(50) then
			begin
				cu := customer.get(iuser);
				raise duplicate_user;
			exception
				when no_data_found then
					null;
				when others then
					raise;
			end;
			cu.username := iuser;
			cu.passwd := ipasswd;
			cu.lang_id := 1;
			cu.balance := 5000;
			cu.img_loc := 'Filesystem';
			cu.page_history := 0;
			st.cust_id := customer.new(cu);
			st.lang_id := cu.lang_id;
			save_state;
			tx_save(tx.create_user);
			prefs(cookie);
		end if;
	exception
		when invalid_user then
			splash(cookie);
		when duplicate_user then
			tru.failure(message.msg(123));
			splash;
		when others then
			tru.die(me,sqlerrm);
	end;
--
--	Home page
--
	procedure home(cookie in varchar2) is
		fly_out number;
		fly_in number;
	begin
		me := 'tr.home';
		restore_state(cookie);
		st.counter := 0;
		save_state;
		cu := customer.get(st.cust_id);
		tru.prolog(cu.name || message.msg(10));
		tru.inline(message.msg(102),message.msg(11));
		htp.nl;
		tru.inline('usa.jpg',message.msg(12));
		htp.nl;
		htp.p(htf.bold(fontup(nvl(cu.name,message.msg(25)))) || message.msg(13));
		htp.anchor('tr.dests?cookie=' || cookie,message.msg(14));
		htp.p(message.msg(137) || to_char(cu.balance));
		if tru.has_tables then
			htp.para;
			htp.tableOpen('BORDER');
			htp.tableCaption(message.msg(124));
			htp.tableRowopen;
			htp.tableHeader(message.msg(125));
			htp.tableHeader(message.msg(126));
			htp.tableHeader(message.msg(127));
			htp.tableHeader(message.msg(128));
			htp.tableHeader(message.msg(129));
			htp.tableHeader(message.msg(130));
			htp.tableHeader(message.msg(131));
			htp.tableRowClose;
		else
			htp.header(3,message.msg(124));
		end if;
		go.cust_id := cu.id;
		while trip.get_trips(go) loop
			ev := event.get(go.event_id);
			ds := destination.get(ev.dest_id);
			fly_out := ceil(ev.fly_out - sysdate);
			fly_in := (ev.fly_out-sysdate) + ds.duration - 1;
			if tru.has_tables then
				htp.tableRowOpen;
				if fly_out > 0 then
					htp.tableData(to_char(fly_out) || message.msg(134));
				elsif fly_out <= 0 and fly_in > 0 then
					htp.tableData(message.msg(132));
				elsif fly_out < 0 and fly_in <=0 then
					htp.tableData(message.msg(133));
				end if;
				if tru.links_in_tables then
					htp.tableData(htf.anchor('tr.city?cookie=' || cookie || '&icity=' || to_char(ds.id),ds.name));
				else
					htp.tableData(ds.name);
				end if;
				htp.tableData(to_char(ev.fly_out,dateformat),'center');
				htp.tableData(to_char(ev.fly_out + ds.duration - 1,dateformat),'center');
				htp.tableData(to_char(go.isle_seat + go.wind_seat + go.sm_isle_seat + go.sm_wind_seat),'right');
				htp.tableData(to_char(go.price,'999,999.00'),'right');
				htp.tableData(to_char(go.timestamp,dateformat),'center');
				htp.tableRowClose;
			else
				htp.header(4,htf.anchor('tr.city?cookie=' || cookie || '&icity=' || to_char(ds.id),ds.name));
				htp.ulistOpen;
				htp.listItem(htf.bold(message.msg(125)) || ': ');
				if fly_out > 0 then
					htp.p(to_char(fly_in) || message.msg(134));
				elsif fly_out <= 0 and fly_in > 0 then
					htp.p(message.msg(132));
				elsif fly_out < 0 and fly_in <=0 then
					htp.p(message.msg(133));
				end if;
				htp.listItem(htf.bold(message.msg(127)) || ': ' || 
					to_char(ev.fly_out,dateformat));
				htp.listItem(htf.bold(message.msg(128)) || ': ' || 
					to_char(ev.fly_out + ds.duration - 1,dateformat));
				htp.listItem(htf.bold(message.msg(129)) || ': ' || 
					to_char(go.isle_seat + go.wind_seat + go.sm_isle_seat + go.sm_wind_seat));
				htp.listItem(htf.bold(message.msg(130)) || ': ' || to_char(go.price,'999,999.00'));
				htp.listItem(htf.bold(message.msg(131)) || ': ' || to_char(go.timestamp,dateformat));
				htp.ulistClose;
			end if;
		end loop;
		if tru.has_tables then
			htp.tableClose;
		end if;
		page_count;
		tx_save(tx.visit_link);
		tru.toolbar(cookie,me);
		tru.epilog;
	exception
		when others then
			tru.die(me,sqlerrm);
	end;
--
--	User Preferences
--
	procedure prefs(cookie in varchar2) is
	begin
		me := 'tr.prefs';
		restore_state(cookie);
		save_state;
		tru.prolog(cu.name || message.msg(15));
		tru.inline(message.msg(118),message.msg(15));
		htp.nl;
		htp.p(fontup(message.msg(16)));
		tru.prefsForm(cookie,cu);
		page_count;
		tx_save(tx.visit_link);
		tru.toolbar(cookie,me);
		tru.epilog;		
	exception
		when others then
			tru.die(me,sqlerrm);
	end;
--
--	Update User preferences
--
	procedure prefsUpdate(cookie in varchar2,iname in varchar2,
		iaddress in varchar2,icity in varchar2,izip in varchar2,
		istate in varchar2,icountry in varchar2,iemail in varchar2,
		ibalance in varchar2,ilang in varchar2,iimg_loc in varchar2,
		ipagehist in varchar2,idesc in varchar2,iaction in varchar2) is
	begin
		me := 'tr.prefsUpdate';
		restore_state(cookie);
		if iaction = message.msg(53) then
			cu.name := iname;
			cu.address := iaddress;
			cu.city := icity;
			cu.zip := izip;
			cu.state := istate;
			cu.country := icountry;
			cu.email := iemail;
			cu.img_loc := iimg_loc;
			cu.lang_id := to_number(ilang);
			cu.page_history := to_number(ipagehist);
			st.lang_id := cu.lang_id;
			-- description is updated using previous lang_id
			begin
				de := description.get(cu.desc_id);
				if de.hype != idesc then
					de.hype := idesc;
					description.put(de);
				end if;
			exception
				when no_data_found then
					de.lang_id := state.lang_id;
					de.hype := idesc;
					description.new(de);
				when others then
					raise;
			end;
			cu.desc_id := de.id;
			begin
				cu.balance := to_number(ibalance);
				if (cu.balance < 0)
				  then raise value_error;
				  end if;
			exception
				when value_error then
					customer.put(cu);
					tx_save(tx.modify_user);
					save_state;
					tru.prolog(message.msg(17));
					tru.failure(message.msg(18) || htf.italic(message.msg(19)) ||
						message.msg(20));
					raise value_error;
				when others then 
					raise;
			end;
			customer.put(cu);
			tx_save(tx.modify_user);
			state.lang_id := st.lang_id;
			tru.prolog(cu.name || message.msg(10));
			tru.success(message.msg(21));
			save_state;
			home(cookie);
		elsif iaction = message.msg(52) then
			customer.rm(cu.id);
			tx_save(tx.drop_user);
			splash;
		end if;
	exception
		when value_error then
			prefs(cookie);
		when others then
			tru.die(me,sqlerrm);
	end;

--
--	Choose Destination
--
	procedure dests(cookie in varchar2) is
		align varchar2(10);
		x number(2);
		buf varchar2(500);
	begin
		me := 'tr.dests';
		restore_state(cookie);
		tru.prolog(message.msg(23));
		tru.inline(message.msg(103),message.msg(24));
		htp.nl;
		htp.p(htf.bold(fontup(nvl(cu.name,message.msg(25)))) || message.msg(22));
		if tru.links_in_tables then
			htp.tableOpen;
		else
			htp.para;
		end if;
		x :=1;
		while destination.get(ds) loop
			if tru.links_in_tables and (mod(x,3) = 1) then
			   htp.tableRowOpen;
			end if;
			buf := htf.anchor('tr.city?cookie=' || cookie || '&icity=' || to_char(ds.id),
				tru.inline(tru.title_gif(ds.name),ds.name)) || htf.nl ||
				htf.anchor('tr.city?cookie=' || cookie || '&icity=' || 
				to_char(ds.id),tru.inline(ds.filename,ds.name));
			if tru.links_in_tables then
				htp.tableData(buf);
			else
				htp.p(buf);
				htp.para;
			end if;
			if tru.links_in_tables and (mod(x,3) = 0) then
				htp.tableRowClose;
			end if;
			x := x + 1;
		end loop;
		if tru.links_in_tables then
			if mod(x,3) != 1 then
				htp.tableRowClose;
			end if;
			htp.tableClose;
		end if;
		page_count;
		tx_save(tx.visit_link);
		tru.toolbar(cookie,me);
		tru.epilog;
		save_state;
	exception
		when others then
			tru.die(me,sqlerrm);
	end;
--
--	City info and choose desired travel interval
--
	procedure city(cookie in varchar2,icity in varchar2) is	
	begin
		me := 'tr.city';
		restore_state(cookie);
		ds := destination.get(to_number(icity));
		st.dest_id := ds.id;
		tru.prolog(ds.name);
		tru.inline(tru.title_gif(ds.name),ds.name);
		htp.nl;
		random_city_image(null);
		htp.para;
		de := description.get(ds.desc_id);
		htp.p(fontup(de.hype));
		htp.para;
		htp.formOpen('tr.ticket');
		htp.formHidden('cookie',cookie);
		htp.p(message.msg(26) || htf.bold(ds.name) || message.msg(27));
		htp.nl;
		htp.formText('ifrom',9,9,to_char(sysdate,dateformat));
		htp.p(' - ');
		htp.formText('ito',9,9,to_char(sysdate+30,dateformat));
		htp.formSubmit(null,null,tru.webstation_hook('travdate.scr'));
		htp.formClose;
		page_count;
		tx_save(tx.visit_link);
		tru.toolbar(cookie,me);
		tru.epilog;
		save_state;
	exception
		when others then
			tru.die(me,sqlerrm);
 	end;
--
--	Select purchase
--
	procedure ticket(cookie in varchar2,ifrom in varchar2, ito in varchar2) is
		invalid_day exception;
		invalid_month exception;
		invalid_length exception;
		invalid_data exception;
		pragma exception_init(invalid_day,-1847);
		pragma exception_init(invalid_month,-1843);
		pragma exception_init(invalid_length,-1840);
		pragma exception_init(invalid_data,-1858);
	begin
		me := 'tr.ticket';
		restore_state(cookie);
		begin
			st.date_from := to_date(ifrom,dateformat);
			st.date_to := to_date(ito,dateformat);
			if st.date_from > st.date_to then
				raise value_error;
			end if;
			if st.date_from is null or st.date_to is null then
				raise value_error;
			end if;
		exception
			when value_error or invalid_day or invalid_month or invalid_length or invalid_data then
				tru.prolog(message.msg(28));
				tru.failure(message.msg(29));
				city(cookie,to_char(ds.id));
				raise invalid_input;
		end;
		tru.prolog(message.msg(30) || ds.name);
		tru.inline(message.msg(104),message.msg(30));
		htp.p(' ');
		tru.inline(tru.title_gif(ds.name),ds.name );
		htp.nl;
		random_city_image(null);
		htp.nl;
		htp.p(htf.bold(fontup(nvl(cu.name,message.msg(25)))) || 
			message.msg(31));
		htp.p(message.msg(32) || to_char(ds.rec_price));
		htp.p(message.msg(135));
		ev.dest_id := ds.id;
		if tru.has_tables then
			htp.tableOpen;
			htp.tableRowOpen;
			htp.tableHeader(message.msg(127));
			htp.tableHeader(message.msg(136),'right');
			htp.tableRowClose;
		else
			htp.ulistOpen;
		end if;
		while event.get(ev,st.date_from,st.date_to) loop
			if tru.has_tables then
				htp.tableRowOpen;
				htp.tableData(to_char(ev.fly_out,dateformat));
				htp.tableData(to_char(ev.price,'999990.00'),'right');
				htp.tableRowClose;
			else
				htp.listItem(message.msg(127) || ': ' || to_char(ev.fly_out,dateformat) || ' - ' || 
					message.msg(127) || to_char(ev.price,'999990.00'));
			end if;
		end loop;
		if tru.has_tables then
			htp.tableClose;
		else
			htp.ulistClose;
		end if;
		htp.para;
		htp.bold(message.msg(137) || to_char(cu.balance,'999,999.00'));
		htp.nl;
		htp.formOpen('tr.purchase');
			htp.formHidden('cookie',cookie);
			htp.bold(message.msg(33));
			htp.formSelectOpen('idate');
			ev.dest_id := ds.id;
			while event.get(ev,st.date_from,st.date_to) loop
				htp.formSelectOption(to_char(ev.fly_out,dateformat));
			end loop;
			htp.formSelectClose;
			htp.bold(message.msg(34));
			htp.formText('iqty',2,2,'1');
			htp.formSelectOpen('iseat');
			htp.formSelectOption('(a) ' || message.msg(105));
			htp.formSelectOption('(b) ' || message.msg(106));
			htp.formSelectOption('(c) ' || message.msg(107));
			htp.formSelectoption('(d) ' || message.msg(108));
			htp.formSelectClose;
			htp.nl;
			htp.formSubmit;
		htp.formClose;
		page_count;
		tx_save(tx.visit_link);
		tru.toolbar(cookie,me);
		tru.epilog;
		save_state;
	exception
		when invalid_input then
			null;
		when others then
			tru.die(me,sqlerrm);
	end;
--
--	Purchase tickets for an event
--
	procedure purchase(cookie in varchar2,idate in varchar2,iqty in varchar2,iseat in varchar2) is
		event_overbooked exception;
	begin
		me := 'tr.purchase';
		restore_state(cookie);
		ev := event.get(st.dest_id,to_date(idate,dateformat));
		st.event_id := ev.id;
		begin
			go.isle_seat := 0;
			go.wind_seat := 0;
			go.sm_isle_seat := 0;
			go.sm_wind_seat := 0;
			htp.comment(iseat);
			if iseat like '(a)%' then
				go.isle_seat := to_number(iqty);
			elsif iseat like '(b)%' then
				go.wind_seat := to_number(iqty);
			elsif iseat like '(c)%' then
				go.sm_isle_seat := to_number(iqty);
			elsif iseat like '(d)%' then
				go.sm_wind_seat := to_number(iqty);
			end if;
			if to_number(iqty) <= 0 then 
				raise value_error;
			end if;
			if ev.booked + go.isle_seat + go.wind_seat + go.sm_isle_seat + 
				go.sm_wind_seat > ev.persons then
				raise event_overbooked;
			end if;
			go.price := (go.isle_seat + go.wind_seat + go.sm_isle_seat + 
				go.sm_wind_seat) * ev.price;
			if go.price > cu.balance then
				raise invalid_input;
			end if;
			if go.isle_seat > ev.isle_seat or go.wind_seat > ev.wind_seat or 
				go.sm_isle_seat > ev.sm_isle_seat or 
				go.sm_wind_seat > ev.sm_wind_seat then
				raise event_overbooked;
			end if;
		exception
			when event_overbooked then
				tru.prolog(message.msg(35));
				tru.failure(message.msg(36));
				htp.p(to_char(ev.booked) || message.msg(109));
				htp.bold(to_char(ev.fly_out,dateformat));
				htp.p(message.msg(110) || to_char(ev.isle_seat+ev.wind_seat+ev.sm_isle_seat+ev.sm_wind_seat) ||
					message.msg(111));
				htp.ulistOpen;
				htp.listItem(to_char(ev.isle_seat) || message.msg(112));
				htp.listItem(to_char(ev.wind_seat) || message.msg(113));
				htp.listItem(to_char(ev.sm_isle_seat) || message.msg(114));
				htp.listItem(to_char(ev.sm_wind_seat) || message.msg(115));
				htp.ulistClose;
				raise invalid_input;
			when value_error then
				tru.prolog(message.msg(37));
				tru.failure(message.msg(38));
				raise invalid_input;
			when invalid_input then
				tru.prolog(message.msg(39));
				tru.failure(message.msg(40));
				raise invalid_input;
		end;
		go.event_id := ev.id;
		go.cust_id := cu.id;
		go.timestamp := sysdate;
		st.trip_id := trip.new(go);
		cu.balance := cu.balance - go.price;
		customer.put(cu);
		ev.booked := ev.booked + go.isle_seat + go.wind_seat + go.sm_isle_seat + go.sm_wind_seat;
		ev.isle_seat := ev.isle_seat - go.isle_seat;
		ev.wind_seat := ev.wind_seat - go.wind_seat;
		ev.sm_isle_seat := ev.sm_isle_seat - go.sm_isle_seat;
		ev.sm_wind_seat := ev.sm_wind_seat - go.sm_wind_seat;
		event.put(ev);
		tru.prolog(message.msg(41) || ds.name);
		tru.success(message.msg(42) || 
			to_char(go.isle_seat + go.wind_seat + go.sm_isle_seat + go.sm_wind_seat) ||
			message.msg(43) || ds.name);
		tru.inline(message.msg(116),message.msg(41));
		htp.p(' ');
		tru.inline(tru.title_gif(ds.name), ds.name);
		htp.nl;
		htp.nl;
		random_city_image(null);
		htp.nl;
		htp.p(htf.bold(cu.name) || message.msg(138) || to_char(cu.balance) || htf.para);
		tru.inline(message.msg(117),message.msg(44));
		htp.nl;
		if tru.has_tables then
			htp.tableOpen('BORDER');
			htp.tableRowOpen;
			htp.tableHeader(message.msg(45));
			htp.tableHeader(message.msg(46));
			htp.tableHeader(message.msg(47));
			htp.tableRowClose;
		else
			htp.preOpen;
			htp.p(rpad(message.msg(45),20) || ' ' || rpad(message.msg(46),20) || ' ' ||
				rpad(message.msg(47),40));
			htp.p(rpad('-',20,'-') || ' ' || rpad('-',20,'-') || ' ' || rpad('-',40,'-'));
		end if;
		while trip.get(go) loop
			cu := customer.get(go.cust_id);
			de.hype := htf.italic(message.msg(48));
			if cu.desc_id is not null then
				de := description.get(cu.desc_id);
			end if;
			if tru.has_tables then
				htp.tableRowOpen;
				htp.tableData(cu.username);
				if rtrim (cu.email) is null
				  then htp.tableData (cu.name);
				  else htp.tableData(htf.mailto(cu.email,cu.name));
				  end if;
				htp.tableData(de.hype);
				htp.tableRowClose;
			else
				htp.p(rpad(cu.username,20) || ' ');
				if rtrim (cu.email) is null
				  then htp.tableData (cu.name);
				  else htp.p(rpad(htf.mailto(cu.email,cu.name),20));
				  end if;
				htp.p(' ' || rpad(de.hype,40));
			end if;
		end loop;
		if tru.has_tables then
			htp.tableClose;
		else
			htp.preClose;
		end if;
		page_count;
		tx_save(tx.buy_ticket);
		tru.toolbar(cookie,me);
		save_state;
		tru.epilog;
	exception
		when invalid_input then
			ticket(cookie,to_char(st.date_from,dateformat),to_char(st.date_to,dateformat));
		when others then
			tru.die(me,sqlerrm);
	end;
begin
	tru.prolog_done := false;
end;
/
show errors
