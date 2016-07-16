rem Copyright (c) 1995, 1996 Oracle Corporation. All rights reserved.
rem 
rem Created
rem 08/09/95	mlonnrot
rem
rem Modified
rem
rem 12/29/95    mbookman        Added index tx_idx1
rem 09/04/95	mlonnroth	Increased http_user_agent to 255
rem
rem Description
rem	Provide tables with data encapsulation packages suitable for PL/SQL calls.
rem	Most packages provide the following methods:
rem
rem	Fetch 1 row using primary key:
rem		function get(primary_key) return table%rowtype;
rem
rem	Fetch multiple rows using "useful" query fields in parameter:
rem		function get(table%rowtype) return boolean;
rem
rem	Insert new row:
rem		function new(table%rowtype) return primary_key;
rem
rem	Update/Insert (new) row:
rem		procedure put(table%rowtype)
rem
rem	Delete row:
rem		procedure rm(table%rowtype)

rem	The panic procedure is a general purpose panic.
rem	This is the only procedure in this file with external dependencies.
rem

create procedure panic (imsg in varchar2,ierrmsg in varchar2) is
begin
	htp.hr;
	htp.header(1,'Panic');
	htp.strong('The Oracle Travel Demo encountered an unexpected error and must now be');
	htp.strong('restarted.');
	htp.header(2,'Error stack:');
	htp.preOpen;
	htp.p(imsg);
	htp.p(ierrmsg);
	htp.preClose;
	htp.hr;
end;
/
show errors

rem
rem	The language table defines available languages to run this application in.
rem

create table language_data
(		id		number(2),
		name		varchar2(20),
		constraint	lang_pkey primary key (id)
);

rem
rem	The state_base table contains persistant information about a current process
rem

create table state_data
(		id		number(9),
		timestamp	date,
		cust_id		number(6),
		dest_id		number(2),
		lang_id		number(2),
		event_id	number(6),
		trip_id		number(6),
		counter		number(3),
		module		varchar2(16),
		date_from	date,
		date_to		date,
		auth_type	varchar2(32),
		gateway_interface varchar2(32),
		http_user_agent	varchar2(255),
		path_info	varchar2(255),
		path_translated	varchar2(255),
		remote_host	varchar2(80),
		remote_addr	varchar2(16),
		remote_user	varchar2(32),
		remote_ident	varchar2(32),
		server_protocol	varchar2(32),
		server_software	varchar2(64),
		server_name	varchar2(64),
		server_port	varchar2(8),
		script_name	varchar2(255),
		constraint	stat_pkey primary key (id)
);

create sequence state_seq;
		
create package state is
		procedure put (iostate in out state_data%rowtype);
		function get (iid in number) return state_data%rowtype;
		function get (iid in varchar2) return state_data%rowtype;
		function get return state_data%rowtype;
		function new return state_data%rowtype;
		procedure cleanup;
		lang_id state_data.lang_id%type;
		cust_id state_data.cust_id%type;		
end;
/
show errors

create package body state is
		this state_data%rowtype;
		state_not_initialized exception;
		invalid_cookie exception;
--
		procedure cleanup is
		begin
			delete from state_data
			where timestamp < sysdate - (1/24);
		exception
			when no_data_found then
				null;
			when others then
				panic('state.cleanup',sqlerrm);
		end;
--
		procedure cgiSet is
		begin
			this.auth_type := owa_util.get_cgi_env('auth_type');
			this.gateway_interface := owa_util.get_cgi_env('gateway_interface');
			this.http_user_agent := owa_util.get_cgi_env('http_user_agent');
			this.remote_host := owa_util.get_cgi_env('remote_host');
			this.remote_addr := owa_util.get_cgi_env('remote_addr');
			this.remote_user := owa_util.get_cgi_env('remote_user');
			this.remote_ident := owa_util.get_cgi_env('remote_ident');
			this.server_protocol := owa_util.get_cgi_env('server_protocol');
			this.server_software := owa_util.get_cgi_env('server_software');
			this.server_name := owa_util.get_cgi_env('server_name');
			this.server_port := owa_util.get_cgi_env('server_port');

		end;

--
		procedure put (iostate in out state_data%rowtype) is
			cursor c (this_id in number) is
				select * from state_data the
				where the.id = this_id
				for update of timestamp;
		begin
			iostate.script_name := owa_util.get_cgi_env('script_name');
			iostate.path_info := owa_util.get_cgi_env('path_info');
			iostate.path_translated := owa_util.get_cgi_env('path_translated');
			if iostate.id is null then
				select state_seq.nextval into iostate.id
				from dual;
				insert into state_data
				(id,timestamp,cust_id,dest_id,lang_id,event_id,trip_id,counter,module,date_from,
				date_to,auth_type,gateway_interface,http_user_agent,path_info,path_translated,
				remote_host,remote_addr,remote_user,remote_ident,server_protocol,
				server_software,server_name,server_port,script_name)
				 values
				(iostate.id,iostate.timestamp,iostate.cust_id,iostate.dest_id,iostate.lang_id,
				iostate.event_id,iostate.trip_id,iostate.counter,iostate.module,iostate.date_from,
				iostate.date_to,iostate.auth_type,iostate.gateway_interface,
				iostate.http_user_agent,iostate.path_info,iostate.path_translated,
				iostate.remote_host,iostate.remote_addr,iostate.remote_user,
				iostate.remote_ident,iostate.server_protocol,iostate.server_software,
				iostate.server_name,iostate.server_port,iostate.script_name);
			else
				open c (iostate.id);
				fetch c into this;
				if c%found then
					update state_data set
						timestamp	= iostate.timestamp,
						cust_id		= iostate.cust_id,
						dest_id		= iostate.dest_id,
						lang_id		= iostate.lang_id,
						event_id	= iostate.event_id,
						trip_id		= iostate.trip_id,
						counter		= iostate.counter,
						module		= iostate.module,
						date_from	= iostate.date_from,
						date_to		= iostate.date_to,
						auth_type	= iostate.auth_type,
						gateway_interface = iostate.gateway_interface,
						http_user_agent	= iostate.http_user_agent,
						path_info	= iostate.path_info,
						path_translated	= iostate.path_translated,
						remote_host	= iostate.remote_host,
						remote_addr	= iostate.remote_addr,
						remote_user	= iostate.remote_user,
						server_protocol	= iostate.server_protocol,
						server_software	= iostate.server_software,
						server_name	= iostate.server_name,
						server_port	= iostate.server_port,
						script_name	= iostate.script_name
					where current of c;
				else
					raise no_data_found;
				end if;
				close c;
			end if;
		exception when others then
			panic('state.put iid=' || to_char(iostate.id),sqlerrm);
		end;
--
		function get return state_data%rowtype is
		begin
			if this.id is null then
				raise state_not_initialized;
			end if;
			return this;
		end;
--
		function get (iid in number) return state_data%rowtype is
			cursor c (this_id number) is
				select * from state_data the
				where the.id = this_id
				for update of the.lang_id;
		begin
			open c (iid);
			fetch c into this;
			if c%notfound then
				raise invalid_cookie;
			end if;
			close c;
			state.lang_id := this.lang_id;
			state.cust_id := this.cust_id;
			return this;
		exception
			when invalid_cookie then
				panic('state.get iid=' || to_char(iid),
					'Invalid cookie detected!');
			when others then
				panic('state.get iid=' || to_char(iid),sqlerrm);
		end;
--
		function get (iid in varchar2) return state_data%rowtype is
		begin
			return get(to_number(iid));
		end;
--
		function new return state_data%rowtype is
		begin
			this.id := null;
			cgiSet;
			put(this);
			return this;
		end;
end;
/
show errors

rem
rem	The description table contains descriptive information about any object.
rem

create table description_data
(		id		number(6),
		lang_id		number(2),
		hype		long,
		constraint	desc_pkey primary key (id,lang_id),
		constraint	desc_lang_fkey foreign key (lang_id)
				references language_data(id)
);

create sequence desc_seq;

create package description is
		function	get (iid in number) return description_data%rowtype;
		function	hype (iid in number) return varchar2;
		procedure	put (iodesc in out description_data%rowtype);
		procedure	new (iodesc in out description_data%rowtype);
end;
/
show errors

create package body description is
		this 	description_data%rowtype;
--
		procedure pget (iid in number) is
			old_lang_id language_data.id%type;
			cursor c (this_id number,this_lang_id number) is
				select * from description_data the
				where the.id = this_id
				and the.lang_id = this_lang_id;
		begin
			open c (iid,nvl(state.lang_id,1));
			fetch c into this;
			if c%notfound then
				raise no_data_found;
			end if;
			close c;
		exception 
			when no_data_found then
				if state.lang_id != 1 then
					close c;
					old_lang_id := state.lang_id;
					state.lang_id := 1;
					pget(iid);
					state.lang_id := old_lang_id;
				else
					raise;
				end if;
			when others then	
				panic('description.pget iid=' || to_char(iid),sqlerrm);
		end;
--
		function get (iid in number) return description_data%rowtype is
		begin
			pget(iid);
			return this;
		end;
--
		function hype (iid in number) return varchar2 is
		begin
			pget(iid);
			return this.hype;
		end;
--
		procedure put(iodesc in out description_data%rowtype) is
			cursor c (this_id number,this_lang in number) is
				select * from description_data the
				where the.id = this_id
				  and the.lang_id = this_lang
				for update of hype;
		begin
			if (iodesc.id is null) then
				select desc_seq.nextval into iodesc.id
				from dual;
				insert into description_data
				(id,lang_id,hype)
				values
				(iodesc.id,nvl(iodesc.lang_id,1),iodesc.hype);
			else
				open c (iodesc.id,iodesc.lang_id);
				fetch c into this;
				if c%found then
					update description_data set
						hype		= iodesc.hype
					where id = iodesc.id and lang_id = iodesc.lang_id;
				else
					insert into description_data
					(id,lang_id,hype)
					values
					(iodesc.id,nvl(iodesc.lang_id,1),iodesc.hype);
					
				end if;
				close c;
			end if;
		exception
			when others then
				panic('description.put iodesc.id,lang_id=' || to_char(iodesc.id) || ',' || to_char(iodesc.lang_id), sqlerrm);
		end;
--
		procedure new (iodesc in out description_data%rowtype) is
		begin
			iodesc.id := null;
			put(iodesc);
		end;
--
begin
	this.id := 0;
end;
/
show errors

rem
rem	The message table contains short messages in multiple languages
rem

create table message_data
(		id		number(6),
		lang_id		number(2),
		msg		varchar2(255),
		constraint	msg_pkey primary key (id,lang_id),
		constraint	msg_lang_fkey foreign key (lang_id)
				references language_data (id)
);

create sequence msg_seq;

create package message is
		function	get (iid in number) return message_data%rowtype;
		function	msg (iid in number) return varchar2;
		function	msg return varchar2;
end;
/
show errors

create package body message is
		this message_data%rowtype;
--
		procedure pget (iid in number) is
			cursor c (this_id number,this_lang number) is
				select * from message_data the
				where the.id = this_id
				and the.lang_id = this_lang;
		begin
			open c (iid,nvl(state.lang_id,1));
			fetch c into this;
			if c%notfound then
				raise no_data_found;
			end if;
			close c;
		exception
			when no_data_found then
				raise;
			when others then
				panic('message.get id,lang=' || to_char(iid) || ',' || 
					to_char(state.lang_id),sqlerrm);
		end;
--
		function get (iid in number) return message_data%rowtype is
		begin
			pget(iid);
			return this;
		end;
--
		function msg (iid in number) return varchar2 is
		begin
			pget(iid);
			return this.msg;
		end;
--
		function msg return varchar2 is
		begin
			return this.msg;
		end;
		
begin
	this.id := 0;
end;
/
show errors

rem
rem	The customer table contains customer information.
rem

create table customer_data
(		id		number(6),
		desc_id		number(6),
		lang_id		number(2),
		username	varchar2(16),
		passwd		varchar2(16),
		name		varchar2(30),
		address		varchar2(30),
		city		varchar2(30),
		zip		varchar2(15),
		state		varchar2(2),
		country		varchar2(30),
		email		varchar2(30),
		balance		number(9,2),
		img_format	varchar2(3),
		img_loc		varchar2(20),
		page_history	number(1),
		constraint 	cust_pkey primary key (id),
		constraint	cust_lang_fkey foreign key (lang_id)
				references language_data(id),
		constraint	cust_unique_username unique (username)
);

create sequence cust_seq;

create package customer is
		function	get(iid in number) return customer_data%rowtype;
		function	get(iname in varchar2) return customer_data%rowtype;
		procedure	put(iocust in out customer_data%rowtype);
		function	new(iocust in out customer_data%rowtype) return customer_data.id%type;
		procedure	rm(iid in number);
end;
/
show errors

create package body customer is
		this		customer_data%rowtype;
--
		procedure rm (iid in number) is
		begin
			delete from customer_data
			where id = to_number(iid);
		exception
			when others then
				panic('customer.rm iid=' || to_char(iid),sqlerrm);
		end;
--
		function get(iid in number) return customer_data%rowtype is
			cursor c (this_id number) is
				select * from customer_data the
				where the.id = this_id;
		begin
			open c (iid);
			fetch c into this;
			if c%notfound then
				raise no_data_found;
			end if;
			close c;
			return this;
		exception
			when no_data_found then
				raise;
			when others then
				panic('customer.get iid=' || to_char(iid),sqlerrm);
		end;
--
		function get(iname in varchar2) return customer_data%rowtype is
			cursor c (this_name varchar2) is
				select * from customer_data the
				where the.username = this_name;
		begin
			open c (iname);
			fetch c into this;
			if c%notfound then
				raise no_data_found;
			end if;
			close c;
			return this;
		exception
			when no_data_found then
				raise;
			when others then
				panic('customer.get iname=' || iname,sqlerrm);
		end;
--
		procedure put(iocust in out customer_data%rowtype) is
			cursor c (this_id number) is
				select * from customer_data
				where id = this_id
				for update of name;
		begin
			if (iocust.id is null) then
				select cust_seq.nextval into iocust.id
				from dual;
				insert into customer_data
				(id,desc_id,lang_id,username,passwd,name,address,city,zip,state,country,
				email,balance,img_format,img_loc,page_history)
				values
				(iocust.id,iocust.desc_id,iocust.lang_id,iocust.username,iocust.passwd,
				iocust.name,iocust.address,iocust.city,iocust.zip,iocust.state,
				iocust.country,iocust.email,iocust.balance,iocust.img_format,iocust.img_loc,iocust.page_history);
			else
				open c (iocust.id);
				fetch c into this;
				if c%found then
					update customer_data set
						desc_id		= iocust.desc_id,
						lang_id		= iocust.lang_id,
						username	= iocust.username,
						passwd		= iocust.passwd,
						name		= iocust.name,
						address		= iocust.address,
						city		= iocust.city,
						zip		= iocust.zip,
						state		= iocust.state,
						country		= iocust.country,
						email		= iocust.email,
						balance		= iocust.balance,
						img_format	= iocust.img_format,
						img_loc		= iocust.img_loc,
						page_history	= iocust.page_history
					where id = iocust.id;
				else
					raise no_data_found;
				end if;
				close c;
			end if;
		exception
			when others then
				panic('customer.put iocust.id=' || to_char(iocust.id), sqlerrm);
		end;
--
		function new(iocust in out customer_data%rowtype) return customer_data.id%type is
		begin
			iocust.id := null;
			put(iocust);
			return iocust.id;
		exception
			when others then
				panic('customer.new',sqlerrm);
		end;
--
begin
	this.id := 0;
end;
/
show errors

rem
rem	The destination table contains information about all available destinations
rem

create table destination_data
(		id		number(3),
		desc_id		number(6),
		name		varchar2(40),
		country		varchar2(30),
		rec_price	number(9,2),
		duration	number(3),
		filename	varchar2(80),
		constraint 	dest_pkey primary key (id)
);

create sequence dest_seq;

create package destination is
		function get (iid in number) return destination_data%rowtype;
		function get (iname in varchar2) return destination_data%rowtype;
		function get (iodest in out destination_data%rowtype) return boolean;
		procedure put (iodest in out destination_data%rowtype);
		procedure new (iodest in out destination_data%rowtype);
end;
/
show errors

create package body destination is
		this destination_data%rowtype;
		cursor nrow is select * from destination_data order by name;
--
		function get (iodest in out destination_data%rowtype) return boolean is
		begin
			if not nrow%isopen then
				open nrow;
			end if;
			fetch nrow into iodest;
			if nrow%notfound then
				close nrow;
				return false;
			end if;
			return true;
		exception
			when others then
				panic('destination.get(iodest)',sqlerrm);
		end;
--
		function get (iid in number) return destination_data%rowtype is
			cursor c (this_id number) is
				select * from destination_data the
				where the.id = this_id;
		begin
			open c (iid);
			fetch c into this;
			if (c%notfound) then
				raise no_data_found;
			end if;
			close c;
			return this;
		exception
			when no_data_found then
				raise;
			when others then
				panic ('destination.get iid=' || to_char(iid),sqlerrm);
		end;
--
		function get (iname in varchar2) return destination_data%rowtype is
			cursor c (this_name varchar2) is
				select * from destination_data the
				where the.name = this_name;
		begin
			open c (iname);
			fetch c into this;
			if (c%notfound) then
				raise no_data_found;
			end if;
			close c;
			return this;
		exception
			when no_data_found then
				raise;
			when others then
				panic ('destination.get iname=' || iname,sqlerrm);
		end;
--
		procedure put (iodest in out destination_data%rowtype) is
			cursor c (this_id number) is
				select * from destination_data
				where id = this_id
				for update of name;
		begin
			if (iodest.id is null) then
				select dest_seq.nextval into iodest.id
				from dual;
				insert into destination_data
				(id,desc_id,name,country,rec_price,duration,filename)
				values
				(iodest.id,iodest.desc_id,iodest.name,iodest.country,iodest.rec_price,
				iodest.duration,iodest.filename);
			else
				open c (iodest.id);
				fetch c into this;
				if c%found then
					update destination_data set
						desc_id		= iodest.desc_id,
						name		= iodest.name,
						country		= iodest.country,
						rec_price	= iodest.rec_price,
						duration	= iodest.duration,
						filename	= iodest.filename
					where id = iodest.id;
				else
					raise no_data_found;
				end if;
				close c;
			end if;
		exception
			when others then
				panic('destination.put iodest.id=' || to_char(iodest.id),sqlerrm);
		end;
--
		procedure new (iodest in out destination_data%rowtype) is
		begin
			iodest.id := null;
			put(iodest);
		end;
begin
	this.id := 0;
end;
/
show errors

rem
rem	The image table contains images
rem

create table image_data
(		id		number(6),
		name		varchar2(32),
		img		long,
		constraint img_pkey primary key (id)
);

rem
rem	The dest_img_data table maps images to destionations
rem

create package image is
	function get(iid in number) return varchar2;
end;
/

create package body image is
	this varchar2(32760);
	function get(iid in number) return varchar2 is
		cursor c (this_id number) is
			select img from image_data the
			where the.id = this_id;
	begin
		open c (iid);
		fetch c into this;
		if c%notfound then
			raise no_data_found;
		end if;
		close c;
		return this;
	exception
		when no_data_found then
			raise;
		when others then
			panic('image.get iid=' || to_char(iid),sqlerrm);
	end;
end;
/
show errors

create table dest_img_data
(		img_id		number(6),
		dest_id		number(3),
		filename	varchar2(255),
		constraint dimg_pkey primary key (img_id),
		constraint dimg_dest_fkey foreign key (dest_id) references destination_data(id)
);

create sequence dimg_seq;

create package dimg is
		function get(iid in number) return dest_img_data%rowtype;
		function get(iodimg in out dest_img_data%rowtype) return boolean;
		procedure put(iodimg in out dest_img_data%rowtype);
		function new(iodimg in out dest_img_data%rowtype) return dest_img_data.img_id%type;
		function cnt(idest in number) return number;
end;
/
show errors

create package body dimg is
		this dest_img_data%rowtype;
		this_dest_id dest_img_data.dest_id%type;
		cursor nrows (this_dest number) is
			select * from dest_img_data the
			where the.dest_id = this_dest;
--
		function cnt(idest in number) return number is
			cursor c (this_dest in number) is
				select count(1)
				from dest_img_data the
				where the.dest_id = this_dest;
			qty number;
		begin
			open c (idest);
			fetch c into qty;
			close c;
			return qty;
		exception
			when others then
				panic('dimg.cnt idest=' || to_char(idest),sqlerrm);
		end;
--
		function get(iid in number) return dest_img_data%rowtype is
			cursor c (this_id number) is
				select * from dest_img_data the
				where the.img_id = this_id;
		begin
			open c(iid);
			fetch c into this;
			if c%notfound then
				raise no_data_found;
			end if;
			close c;
			return this;
		exception
			when no_data_found then
				raise;
			when others then
				panic('dimg.get iid=' || to_char(iid),sqlerrm);
		end;
--
		function get(iodimg in out dest_img_data%rowtype) return boolean is
		begin
			if nrows%isopen and iodimg.dest_id != this_dest_id then
				close nrows;
			end if;
			if not nrows%isopen then
				open nrows(iodimg.dest_id);
				this_dest_id := iodimg.dest_id;
			end if;
			fetch nrows into iodimg;
			if nrows%notfound then
				close nrows;
				return false;
			end if;
			return true;
		exception
			when others then
				panic('dimg.get iodimg.dest_id=' || to_char(iodimg.dest_id),sqlerrm);
		end;
--
		procedure put(iodimg in out dest_img_data%rowtype) is
			cursor c (this_img number) is
				select * from dest_img_data the
				where the.img_id = this_img
				for update of filename;
		begin
			if iodimg.img_id is null then
				select dimg_seq.nextval into iodimg.img_id
				from dual;
				insert into dest_img_data
				(img_id,dest_id,filename)
				values
				(iodimg.img_id,iodimg.dest_id,iodimg.filename);
			else
				open c(iodimg.img_id);
				fetch c into this;
				if c%found then
					update dest_img_data set
						dest_id		= iodimg.dest_id,
						filename	= iodimg.filename
					where img_id = iodimg.img_id;
				else
					raise no_data_found;
				end if;
				close c;
			end if;
		exception
			when others then
				panic('dimg.put img_id=' || to_char(iodimg.img_id),sqlerrm);
		end;
--
		function new(iodimg in out dest_img_data%rowtype) return dest_img_data.img_id%type is
		begin
			iodimg.img_id := null;
			put(iodimg);
			return iodimg.img_id;
		end;
begin
	this_dest_id := 0;
end;
/
show errors

rem
rem	The event table contains information about each occurance of a tour to a
rem	specific destination.
rem

create table event_data
(		id		number(6),
		dest_id		number(3),
		fly_out		date not null,
		persons		number(3),
		wind_seat	number(3),
		isle_seat	number(3),
		sm_wind_seat	number(3),
		sm_isle_seat	number(3),
		booked		number(3),
		price		number(9,2),
		constraint 	even_pkey primary key (id),
		constraint 	even_dest_fkey foreign key (dest_id)
				references destination_data(id) on delete cascade
);

create sequence event_seq;
create package event is
		function get(iid in number) return event_data%rowtype;
		function get(iid in number,idate in date) return event_data%rowtype;
		function get(ioevent in out event_data%rowtype,idate_from in date,
			idate_to in date) return boolean;
		procedure put(ioevent in out event_data%rowtype);
		procedure new(ioevent in out event_data%rowtype);
end;
/
show errors

create package body event is
		this event_data%rowtype;
		this_dest_id event_data.dest_id%type;
		this_date_from date;
		this_date_to date;
--
		cursor nrow (this_dest number, date1 date, date2 date) is
			select * from event_data the
			where the.dest_id = this_dest
			  and the.fly_out between date1 and date2
			order by the.fly_out;
--
		function get (iid in number) return event_data%rowtype is
			cursor c (this_id number) is
				select * from event_data the
				where the.id = this_id;
		begin
			open c (iid);
			fetch c into this;
			if (c%notfound) then
				raise no_data_found;
			end if;
			close c;
			return this;
		exception
			when no_data_found then
				raise;
			when others then
				panic ('event.get iid=' || to_char(iid),sqlerrm);
		end;
--
		function get(iid in number,idate in date) return event_data%rowtype is
		begin
			this.dest_id := iid;
			if get(this,idate,idate) then
				close nrow;
				return this;
			else
				raise no_data_found;
			end if;
		exception
			when others then
				panic('event.get iid,idate=' || to_char(iid) || ',' || 
					to_char(idate,'dd-Mon-yy'),sqlerrm);
		end;
--
		function get(ioevent in out event_data%rowtype,idate_from in date,
			idate_to in date) return boolean is

		begin
			if nrow%isopen and (this_dest_id != ioevent.dest_id or
				idate_from != this_date_from or idate_to != this_date_to) then
				close nrow;
			end if;
			if not nrow%isopen then
				open nrow (ioevent.dest_id,idate_from,idate_to);
				this_dest_id := ioevent.dest_id;
				this_date_from := idate_from;
				this_date_to := idate_to;
			end if;
			fetch nrow into ioevent;
			if (nrow%notfound) then
				close nrow;
				return false;
			end if;
			return true;
		exception
			when no_data_found then
				raise;
			when others then
				panic ('event.get dest_id,date_from,date_to' ||
					to_char(ioevent.dest_id) || ',' || 
					to_char(idate_from,'dd-Mon-yy') || ',' ||
					to_char(idate_to,'dd-Mon-yy'),sqlerrm);
		end;

		procedure put(ioevent in out event_data%rowtype) is
			cursor c (this_id number) is
				select * from event_data
				where id = this_id
				for update of fly_out;
		begin
			if (ioevent.id is null) then
				select event_seq.nextval into ioevent.id
				from dual;
				insert into event_data
				(id,dest_id,fly_out,persons,isle_seat,wind_seat,sm_isle_seat,
				sm_wind_seat,booked,price)
				values
				(ioevent.id,ioevent.dest_id,ioevent.fly_out,ioevent.persons,
				ioevent.isle_seat,ioevent.wind_seat,ioevent.sm_isle_seat,
				ioevent.sm_wind_seat,ioevent.booked,ioevent.price);
			else
				open c (ioevent.id);
				fetch c into this;
				if c%found then
					update event_data set
						dest_id		= ioevent.dest_id,
						fly_out		= ioevent.fly_out,
						persons		= ioevent.persons,
						isle_seat	= ioevent.isle_seat,
						wind_seat	= ioevent.wind_seat,
						sm_isle_seat	= ioevent.sm_isle_seat,
						sm_wind_seat	= ioevent.sm_wind_seat,
						booked		= ioevent.booked,
						price		= ioevent.price
					where id = ioevent.id;
				else
					raise no_data_found;
				end if;
				close c;
			end if;
		exception
			when others then
				panic('event.put ioevent.id=' || to_char(ioevent.id),sqlerrm);
		end;
--
		procedure new (ioevent in out event_data%rowtype) is
		begin
			ioevent.id := null;
			put(ioevent);
		end;
--
begin
	this.id := 0;
end;
/
show errors

rem
rem	The trip table contains one row for each customer and tour event.
rem

create table trip_data
(		id		number(6),
		event_id	number(6),
		cust_id		number(6),
		timestamp	date,
		price		number(7,2),
		wind_seat	number(3),
		isle_seat	number(3),
		sm_wind_seat	number(3),
		sm_isle_seat	number(3),
		constraint	trip_pkey primary key (id),
		constraint	trip_even_fkey foreign key (event_id)
				references event_data(id),
		constraint	trip_cust_fkey foreign key (cust_id)
				references customer_data(id) on delete cascade
);

create sequence trip_seq;

create package trip is
		function get(iid in number) return trip_data%rowtype;
		function get(ievent_id in number,icust_id in number) return trip_data%rowtype;
		function get(iotr in out trip_data%rowtype) return boolean;
		function get_trips(iotr in out trip_data%rowtype) return boolean;
		procedure put(iotr in out trip_data%rowtype);
		function new(iotr in out trip_data%rowtype) return trip_data.id%type;
end;
/
show errors

create package body trip is
		this trip_data%rowtype;
		that trip_data%rowtype;
		this_event_id trip_data.event_id%type;
		this_cust_id trip_data.cust_id%type;
--
		cursor trips (this_cust in number) is
			select * from trip_data the
			where the.cust_id = this_cust
			order by the.timestamp;
--
		cursor nrow (this_event in number) is
			select * from trip_data the
			where the.event_id = this_event;
--
		function get (iid in number) return trip_data%rowtype is
			cursor c (this_id number) is
				select * from trip_data the
				where the.id = this_id;
		begin
			open c (iid);
			fetch c into this;
			if (c%notfound) then
				raise no_data_found;
			end if;
			close c;
			return this;
		exception
			when no_data_found then
				raise;
			when others then
				panic ('trip.get iid=' || to_char(iid),sqlerrm);
		end;
--
		function get_trips(iotr in out trip_data%rowtype) return boolean is
		begin
			if trips%isopen and this_cust_id != iotr.cust_id then
				close trips;
			end if;
			if not trips%isopen then
				open trips (iotr.cust_id);
				this_cust_id := iotr.cust_id;
			end if;
			fetch trips into iotr;
			if trips%notfound then
				close trips;
				return false;
			else
				return true;
			end if;
		exception
			when others then
				panic('trip.get_trips iotr.id=' || to_char(iotr.id),sqlerrm);
		end;
--
		function get(iotr in out trip_data%rowtype) return boolean is
		begin
			if nrow%isopen and this_event_id != iotr.event_id then
				close nrow;
			end if;
			if not nrow%isopen then
				open nrow (iotr.event_id);
				this_event_id := iotr.event_id;
			end if;
			fetch nrow into iotr;
			if nrow%notfound then
				close nrow;
				return false;
			else
				return true;
			end if;
		exception
			when others then
				panic('trip.get iotr.id=' || to_char(iotr.id),sqlerrm);
		end;
--
		function get(ievent_id in number,icust_id in number) return trip_data%rowtype is
			cursor c (this_even number, this_cust number) is
				select * from trip_data the
				where the.event_id = this_even
				  and the.cust_id = this_cust;
		begin
			that.price := 0;
			that.isle_seat := 0;
			that.wind_seat := 0;
			that.sm_isle_seat := 0;
			that.sm_wind_seat := 0;
			this.id := null;
			open c (ievent_id,icust_id);
			while c%isopen loop
				fetch c into that;
				if c%notfound then
					if this.id is null then
						raise no_data_found;
					else
						close c;
					end if;
				else
					this.event_id := that.event_id;
					this.cust_id := that.cust_id;
					this.price := this.price + that.price;
					this.isle_seat := this.isle_seat + that.isle_seat;
					this.wind_seat := this.wind_seat + that.wind_seat;
					this.sm_isle_seat := this.sm_isle_seat + that.sm_isle_seat;
					this.sm_wind_seat := this.sm_wind_seat + that.sm_wind_seat;
				end if;
			end loop;
			return this;
		exception
			when no_data_found then
				raise;
			when others then
				panic ('trip.get ievent_id,icustid=' || to_char(ievent_id) || ',' ||
					to_char(icust_id),sqlerrm);
		end;
--
		procedure put(iotr in out trip_data%rowtype) is
			cursor c (this_id number) is
				select * from trip_data
				where id = this_id
				for update of fly_out;
		begin
			if (iotr.id is null) then
				select trip_seq.nextval into iotr.id
				from dual;
				insert into trip_data
				(id,event_id,cust_id,timestamp,price,isle_seat,wind_seat,
					sm_isle_seat,sm_wind_seat)
				values
				(iotr.id,iotr.event_id,iotr.cust_id,iotr.timestamp,iotr.price,
					iotr.isle_seat,iotr.wind_seat,
					iotr.sm_isle_seat,iotr.sm_wind_seat);
			else
				open c (iotr.id);
				fetch c into this;
				if c%found then
					update trip_data set
						event_id	= iotr.event_id,
						cust_id		= iotr.cust_id,
						timestamp	= iotr.timestamp,
						price		= iotr.price,
						isle_seat	= iotr.isle_seat,
						wind_seat	= iotr.wind_seat,
						sm_isle_seat	= iotr.sm_isle_seat,
						sm_wind_seat	= iotr.sm_wind_seat
					where id = iotr.id;
				else
					raise no_data_found;
				end if;
				close c;
			end if;
		exception
			when others then
				panic('trip.put iotr.id=' || to_char(iotr.id),sqlerrm);
		end;
--
		function new(iotr in out trip_data%rowtype) return trip_data.id%type is
		begin
			iotr.id := null;
			put(iotr);
			return iotr.id;
		end;
--
begin
	this.id := 0;
end;
/
show errors

rem
rem	The tx_record is used to record all transactions. The other tables are
rem	updated automatically through triggers on this table.
rem
rem	Valid transactions:
rem
rem		01	Create user
rem		02	Modify user
rem		03	Drop user
rem		04	Buy ticket
rem		05	Sell ticket
rem		06	Visit link

create table tx_data
(		id		number,
		cust_id		number,
		timestamp	date,
		tx_code		number(2),
		url		varchar2(80),
		auth_type	varchar2(32),
		gateway_interface varchar2(32),
		http_user_agent	varchar2(255),
		path_info	varchar2(255),
		path_translated	varchar2(255),
		remote_host	varchar2(80),
		remote_addr	varchar2(16),
		remote_user	varchar2(32),
		remote_ident	varchar2(32),
		server_protocol	varchar2(32),
		server_software	varchar2(64),
		server_name	varchar2(64),
		server_port	varchar2(8),
		script_name	varchar2(255),
		p01		varchar2(80),
		p02		varchar2(80),
		p03		varchar2(80),
		p04		varchar2(80),
		p05		varchar2(80),
		p06		varchar2(80),
		p07		varchar2(80),
		p08		varchar2(80),
		p09		varchar2(80),
		p10		varchar2(80),
		constraint tx_pkey primary key (id)
);

create index tx_idx1 on tx_data(cust_id,url);

create sequence tx_seq;

create package tx is
	function get (iid in number) return tx_data%rowtype;
	function get (iotx in out tx_data%rowtype) return boolean;
	procedure put (iotx in out tx_data%rowtype);
	function last (iurl in varchar2) return tx_data%rowtype;
	function cnt (iurl in varchar2) return number; 
--
	create_user	constant number(2) := 1;
	modify_user	constant number(2) := 2;
	drop_user	constant number(2) := 3;
	buy_ticket	constant number(2) := 4;
	sell_ticket	constant number(2) := 5;
	visit_link	constant number(2) := 6;
	login_fail	constant number(2) := 7;
	login_ok	constant number(2) := 8;
end;
/
show errors

create package body tx is
		this tx_data%rowtype;
		this_cust_id tx_data.cust_id%type;
		this_url_id tx_data.url%type;
--
		cursor nrow (this_cust number,this_url varchar2) is
			select * from tx_data the
			where the.cust_id = this_cust
			  and the.url = this_url
			order by the.timestamp desc;
--
		function get (iotx in out tx_data%rowtype) return boolean is
		begin
			if nrow%isopen and (iotx.cust_id != this_cust_id or iotx.url != this_url_id) then
				close nrow;
			end if;
			if not nrow%isopen then
				open nrow(iotx.cust_id,iotx.url);
				this_cust_id := iotx.cust_id;
				this_url_id := iotx.url;
			end if;
			fetch nrow into iotx;
			if nrow%notfound then
				close nrow;
				return false;
			else
				return true;
			end if;
		exception
			when others then
				panic('tx.get cust_id,url=' || to_char(this_cust_id) || ',' || this_url_id, sqlerrm);
		end;
--
		function get (iid in number) return tx_data%rowtype is
			cursor c (this_id number) is
				select * from tx_data the
				where the.id = this_id;
		begin
			open c (iid);
			fetch c into this;
			if c%notfound then
				raise no_data_found;
			end if;
			close c;
			return this;
	
		exception
			when no_data_found then
				raise;
			when others then
				panic ('tx.get iid=' || to_char(iid),sqlerrm);
		end;
--
		function last (iurl in varchar2) return tx_data%rowtype is
			cursor c (this_url in varchar2) is
				select * from tx_data the
				where the.id = (select max(a.id)
						from tx_data a
						where a.cust_id = state.cust_id
						  and a.url = this_url);
		begin
			open c (iurl);
			fetch c into this;
			if c%notfound then
				raise no_data_found;
			end if;
			close c;
			return this;
		exception
			when no_data_found then
				raise;
			when others then
				panic ('tx.last iurl = ' || iurl,sqlerrm);
		end;
--
		function cnt (iurl in varchar2) return number is
			cursor c (this_url in varchar2) is
				select count(1)
				from tx_data the
				where the.cust_id = state.cust_id
				  and the.url = this_url;
			the_count number(4);
		begin
			open c (iurl);
			fetch c into the_count;
			close c;
			return the_count;
		exception
			when others then
				panic('tx.cnt iurl=' || iurl,sqlerrm);
		end;
--
		procedure put (iotx in out tx_data%rowtype) is

			cursor c (this_id number) is
				select * from tx_data the
				where the.id = this_id
				for update of timestamp;
		begin
			iotx.timestamp := sysdate;
			if (iotx.id is null) then
				select tx_seq.nextval into iotx.id
				from dual;
				insert into tx_data
				(id,cust_id,timestamp,tx_code,url,auth_type,gateway_interface,http_user_agent,
				path_info,path_translated,
				remote_host,remote_addr,remote_user,remote_ident,server_protocol,
				server_software,server_name,server_port,script_name,
				p01,p02,p03,p04,p05,p06,p07,p08,p09,p10)
				values
				(iotx.id,iotx.cust_id,iotx.timestamp,iotx.tx_code,iotx.url,iotx.auth_type,
				iotx.gateway_interface,iotx.http_user_agent,iotx.path_info,iotx.path_translated,
				iotx.remote_host,iotx.remote_addr,iotx.remote_user,iotx.remote_ident,iotx.server_protocol,
				iotx.server_software,iotx.server_name,iotx.server_port,iotx.script_name,iotx.p01,iotx.p02,
				iotx.p03,iotx.p04,iotx.p05,iotx.p06,iotx.p07,iotx.p08,iotx.p09,iotx.p10);
			else
				open c (iotx.id);
				fetch c into this;
				if c%found then
					update tx_data set
						cust_id		= iotx.cust_id,
						timestamp	= iotx.timestamp,
						tx_code		= iotx.tx_code,
						url		= iotx.url,
						auth_type	= iotx.auth_type,
						gateway_interface = iotx.gateway_interface,
						http_user_agent	= iotx.http_user_agent,
						path_info	= iotx.path_info,
						path_translated	= iotx.path_translated,
						remote_host	= iotx.remote_host,
						remote_addr	= iotx.remote_addr,
						remote_user	= iotx.remote_user,
						server_protocol	= iotx.server_protocol,
						server_software	= iotx.server_software,
						server_name	= iotx.server_name,
						server_port	= iotx.server_port,
						script_name	= iotx.script_name,
						p01		= iotx.p01,
						p02		= iotx.p02,
						p03		= iotx.p03,
						p04		= iotx.p04,
						p05		= iotx.p05,
						p06		= iotx.p06,
						p07		= iotx.p07,
						p08		= iotx.p08,
						p09		= iotx.p09,
						p10		= iotx.p10
					where id = iotx.id;
				else
					raise no_data_found;
				end if;
				close c;
			end if;
		exception
			when others then
				panic('tx.put iotx.id=' || to_char(iotx.id),sqlerrm);
		end;
begin
	this.id := 0;
end;
/
show errors

	

