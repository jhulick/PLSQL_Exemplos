rem Copyright (c) 1994, 1996 Oracle Corporation.  All rights reserved.
rem Random number generator compliments of Russ Seligman (April '94)
drop table applet_data;
create table applet_data
(	name	varchar2(255),
	code	long,
	constraint app_pkey primary key (name)
);

create or replace package applet is
	procedure get(iname in varchar2);
	procedure put(iname in varchar2,icode in varchar2);
	procedure rm(iname in varchar2);
end;
/
show errors

create or replace package body applet is
	this varchar2(32767);
	procedure get(iname in varchar2) is
		cursor c (this_name varchar2) is
			select the.code from applet_data the
			where the.name = this_name;
	begin
		open c(iname);
		fetch c into this;
		if c%notfound then
			raise no_data_found;
		end if;
		close c;
		owa_util.mime_header('text/plain');
		htp.prn(this);
	end;
--
	procedure put(iname in varchar2,icode in varchar2) is
	begin
		insert into applet_data
		(name,code)
		values
		(iname,icode);
	end;
--
	procedure rm(iname in varchar2) is
	begin
		delete from applet_data the
		where the.name = iname;
	end;
end;
/
show errors

declare
	crlf varchar2(2) := chr(13) || chr(10);
begin
	applet.put('trains.dat','Platform 6: 619 Arriving from Chicago.......' ||
'Platform 5: 618 Departing for Chicago........Platform 3: 234 Arriving from ' ||
'New York.......Platform 2: 618 Departing for Miami........Platform 6: 619 ' ||
'Arriving from Chicago.......Platform 5: 618 Departing for Chicago........' ||
'Platform 3: 234 Arriving from New York.......Platform 2: 618 Departing for ' ||
'Miami........');
--
	applet.put('password.scr',
'Sub Main ()' || crlf ||
'	if iuser = "" then' || crlf ||
'		MsgBox("You need to enter your name")' || crlf ||
'		Exit Sub' || crlf ||
'	End If' || crlf ||
crlf ||	
'	if ipasswd = "" then' || crlf ||
'		MsgBox("You need to enter a password")' || crlf ||
'		Exit Sub' || crlf ||
'	End If' || crlf ||
'	' || crlf ||
'	if LEN(ipasswd) < 4 then' || crlf ||
'		MsgBox("Your password must be at least 4 characters")' || crlf ||
'		Exit Sub' || crlf ||
'	End If' || crlf ||
crlf ||
crlf ||	
'	call BROWSER_SubmitForm()' || crlf ||
'' || crlf ||
'End Sub');
--
	applet.put('travdate.scr',
'Sub Main ()' || crlf ||
crlf ||
'	if ifrom = "" then' || crlf ||
'		MsgBox("You need to enter a start date")' || crlf ||
'		Exit Sub' || crlf ||
'	End If' || crlf ||
	
'	if ito = "" then' || crlf ||
'		MsgBox("You need to enter an end date")' || crlf ||
'		Exit Sub' || crlf ||
'	End If' || crlf ||
crlf ||	
'	call BROWSER_SubmitForm()' || crlf ||

'End Sub');
--
	applet.put('travpref.scr',
'Sub Main ()' || crlf ||
crlf ||
'	if iname = "" then' || crlf ||
'		MsgBox("You need to enter your name")' || crlf ||
'		Exit Sub' || crlf ||
'	End If' || crlf ||
crlf ||	
'	if iaddress = "" then' || crlf ||
'		MsgBox("You need to enter your address")' || crlf ||
'		Exit Sub' || crlf ||
'	End If' || crlf ||
crlf ||
'	if icity = "" then' || crlf ||
'		MsgBox("You need to enter your city")' || crlf ||
'		Exit Sub' || crlf ||
'	End If' || crlf ||
crlf ||	
'	if izip = "" then' || crlf ||
'		MsgBox("You need to enter your ZIP")' || crlf ||
'		Exit Sub' || crlf ||
'	End If' || crlf ||
crlf ||	
'	if icountry = "" then' || crlf ||
'		MsgBox("You need to enter your country")' || crlf ||
'		Exit Sub' || crlf ||
'	End If' || crlf ||
crlf ||	
'	if ibalance = "" then' || crlf ||
'		MsgBox("You need to enter your balance")' || crlf ||
'		Exit Sub' || crlf ||
'	End If' || crlf ||
crlf ||	
'	DIM numBalance As Single' || crlf ||
crlf ||	
'	numBalance = VAL(ibalance)' || crlf ||
crlf ||	
'	call BROWSER_SubmitForm()' || crlf ||
crlf ||
'End Sub');
end;
/
show errors
--
create or replace package random is 
--
function rndint(r in number) return number; 
-- 
function rndflt return number; 
-- 
end;
/
show errors
-- 
-- /********** the package body: **********/
-- 
create or replace package body random is 
--/* Linear congruential random number generator */ 
-- 
m constant number:=100000000;  
m1 constant number:=10000;     
b constant number:=31415821;   
-- 
a number;                      
-- 
the_date date;                 
days number;                   
secs number;                   
--
--/*-------------------------- mult ---------------------------*/ 
--/* Private utility function */ 
-- 
function mult(p in number, q in number) return number is 
   p1 number; 
   p0 number; 
   q1 number; 
   q0 number; 
begin 
   p1:=trunc(p/m1); 
   p0:=mod(p,m1); 
   q1:=trunc(q/m1); 
   q0:=mod(q,m1); 
   return(mod((mod(p0*q1+p1*q0,m1)*m1+p0*q0),m)); 
end;   /* mult */ 
-- 
--/*-------------------------- rndint --------------------------*/ 
--/* Returns random integer between [0, r-1] */ 
-- 
function rndint (r in number) return number is 
begin 
--   /* generate a random number and set it to be the new seed */ 
   a:=mod(mult(a,b)+1,m); 
-- 
--   /* convert it to integer between [0, r-1] and return it */ 
   return(trunc((trunc(a/m1)*r)/m1)); 
end; 
--  /* rndint */ 
-- 
--/*-------------------------- rndflt --------------------------*/ 
--/* Returns random real between [0, 1] */ 
-- 
function rndflt return number is 
begin 
--   /* generate a random number and set it to be the new seed */ 
   a:=mod(mult(a,b)+1,m); 
 
--   /* return it */ 
   return(a/m); 
end;
--   /* rndflt */ 
--
-- 
begin   
--/* package body random */ 
--   /* Generate an initial seed "a" based on system date */ 
--   /* (Must be connected to database.)                  */ 
   the_date:=sysdate; 
   days:=to_number(to_char(the_date, 'J')); 
   secs:=to_number(to_char(the_date, 'SSSSS')); 
   a:=days*24*3600+secs; 
end; 
--  /* package body random */ 
/
show errors





