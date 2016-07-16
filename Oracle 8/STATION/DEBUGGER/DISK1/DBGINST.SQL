/*********************************************************************************
** This file is for server-side install of tables, views, procedures, functions 
** and packages, which WATCH_PL needs for it's debugger and maintenance.
** All non-sys owned objects should go into this file.
** Since this account is configurable, "sqldebug" prefix before any name
** has to be substituted with the real user name by install program.
**********************************************************************************/

/********************************************************************************* 
**	This table is for holding original trigger's text, while it's being 
**  substituted with debugging version.
**  Note that the structure of this table resembles ptsql_triggers'.
**********************************************************************************/

drop table PTSQL_DBG_TRIGGERS; 

CREATE TABLE PTSQL_DBG_TRIGGERS
(
 OWNER VARCHAR2(30) NOT NULL,
 NAME VARCHAR2(30) NOT NULL,
 TEXT LONG NULL,
 PRIMARY KEY ( OWNER, NAME )
);

comment on table PTSQL_DBG_TRIGGERS is 
'Holds original triggers'' texts, while they are substituted with debugging versions';

grant insert, delete, select on PTSQL_DBG_TRIGGERS to public;

/********************************************************************************* 
**	This table holds objects which were excluded by user.
**********************************************************************************/
drop table PTSQL_DBG_IGNORE; 

create table  PTSQL_DBG_IGNORE
(
 name varchar2(30),
 owner varchar2(30),
 igntype number
);

comment on table PTSQL_DBG_IGNORE is 
'Holds objects which were excluded by user';

grant select, insert, delete on PTSQL_DBG_IGNORE to public;

/********************************************************************************* 
**	This sequence is for generating unique sequence numbers for debuggable
**	with long ( > 30 characters) names.
**********************************************************************************/
drop sequence PTSQL_DBG_SEQ; 

create sequence PTSQL_DBG_SEQ
increment by 1 
minvalue 1 
nocycle 
cache 20 
noorder;

grant select on PTSQL_DBG_SEQ to public;

/********************************************************************************* 
**	This table is for holding debuggable objects' names and their sequence #,
**  which have long names (prefix + name is over 30 characters).
**********************************************************************************/

drop table PTSQL_DBG_OBJS; 

CREATE TABLE PTSQL_DBG_OBJS
(
 OWNER VARCHAR2(30) NOT NULL,
 NAME VARCHAR2(30) NOT NULL,
 DBGNAME VARCHAR2(30) NOT NULL,
 SEQID NUMBER NOT NULL,
 PRIMARY KEY ( OWNER, NAME ),
 UNIQUE (DBGNAME),
 UNIQUE (SEQID)
);

comment on table PTSQL_DBG_OBJS is 
'Holds names, debug names, owners and seq# of objects with long ( > 30 characters ) names';

grant select, insert, delete on PTSQL_DBG_OBJS to public;


/********************************************************************************* 
**	This table is for holding free sequence numbers for debuggable objects
**  which have long names (prefix + name is over 30 characters).
**********************************************************************************/

drop table PTSQL_FREE_SEQ_NUMS; 

create table PTSQL_FREE_SEQ_NUMS
( 
 free_seq_num number(6,0) NOT NULL, 
 primary key (free_seq_num)
);

comment on table PTSQL_FREE_SEQ_NUMS is 
'Holds seq# for objects with long ( > 30 characters ) names which were freed up';

grant insert, delete, select on PTSQL_FREE_SEQ_NUMS to public;

/********************************************************************************* 
**	This trigger maintains PTSQL_FREE_SEQ_NUMS to have freed seq #.
**********************************************************************************/

CREATE OR REPLACE TRIGGER PTSQL_DBG_OBJS_AFTER_DELETE 
after delete on PTSQL_DBG_OBJS for each row
 begin
	insert into PTSQL_FREE_SEQ_NUMS values (:old.SEQID);
end;
/
/********************************************************************************* 
**	This package is for managing all debugger needs 
**********************************************************************************/

CREATE OR REPLACE package PTSQL_DBG_MAINT
as

	procedure ManageSequenceNum (			owner_in IN VARCHAR2,
											object_name_in IN VARCHAR2,
											 prefix_in IN VARCHAR2,
											seqNum_out OUT NUMBER);

	procedure  dbg_obj_table_cleanup;

	procedure clnup (obj_owner IN ptsql_objects.owner%TYPE);

	procedure dba_clnup;

	procedure in_sync_clnup (obj_owner IN ptsql_objects.owner%TYPE,
							obj_type IN ptsql_objects.object_type%TYPE);
end PTSQL_DBG_MAINT;
/

CREATE OR REPLACE package body PTSQL_DBG_MAINT
as
	procedure ManageSequenceNum (owner_in IN VARCHAR2, object_name_in IN VARCHAR2,
								 prefix_in IN VARCHAR2, seqNum_out OUT NUMBER)
	is
		theNum ptsql_free_seq_nums.free_seq_num%TYPE;

		CURSOR free_num_cur IS
		select free_seq_num from PTSQL_free_seq_nums where rownum < 2;

	begin

		open free_num_cur;
		fetch free_num_cur into theNum;
		
		if free_num_cur%NOTFOUND
		then
			insert into PTSQL_dbg_objs values 
			(owner_in, object_name_in, prefix_in || to_char(PTSQL_dbg_seq.nextval), PTSQL_dbg_seq.nextval);
			
			select seqid into seqNum_out from PTSQL_dbg_objs where
			owner = owner_in and name = object_name_in;
		else
			insert into PTSQL_dbg_objs values 
			(owner_in, object_name_in, prefix_in || to_char(theNum), theNum);

			delete from PTSQL_free_seq_nums WHERE free_seq_num = theNum;
			
			seqNum_out := theNum;
		end if;
		
		close free_num_cur;

		commit;		
			
	end ManageSequenceNum;

	procedure  dbg_obj_table_cleanup
	is
		/* This cursor finds all debug object names of objects, which length is > 26 characters,
		**and  which are in ptsql_dbg_obj table, but do not exist in system catalogs.
		*/
	
		CURSOR in_table_no_cat_cur IS 
		select dbgname from PTSQL_dbg_objs
			where dbgname not in 
			(select OBJECT_NAME from ptsql_objects
			where OBJECT_NAME like 'X#Z$%' or OBJECT_NAME like 'X#X$%');
                                 
	BEGIN
		FOR debugName in in_table_no_cat_cur
		LOOP
			delete from PTSQL_dbg_objs where dbgname = debugName.dbgname;	
		END LOOP;
		commit;

	END	dbg_obj_table_cleanup;

	procedure dyndrop(object_owner IN varchar2, dbg_object_name IN varchar2, object_type IN varchar2)
	is
		drop_cur integer;
		tmp_int integer;
	begin
		
		drop_cur := dbms_sql.open_cursor;
		dbms_sql.parse( drop_cur, 'drop ' || object_type || ' ' || object_owner ||
											'.' || dbg_object_name, dbms_sql.v7);
		dbms_sql.close_cursor(drop_cur);

		
		/* If the debug name is found in PTSQL_DBG_OBJS, must do clean up here as well */
		
		select count(*) into tmp_int from PTSQL_DBG_OBJS
		where dbgname = dbg_object_name; 

		if (tmp_int > 0) then
			delete from PTSQL_DBG_OBJS where dbgname = dbg_object_name;
		end if;
	end dyndrop;

	procedure clnup(obj_owner IN ptsql_objects.owner%TYPE) 
	is
		cursor get_dbg is
		select object_name, object_type, timestamp from ptsql_objects
			where owner = obj_owner
			and (object_name like 'X#Z$%'
			or object_name like 'X#X$%')
			and object_type in ('PROCEDURE','PACKAGE','FUNCTION');

		dbg_name all_objects.object_name%TYPE;
		rel_name all_objects.object_name%TYPE;
		dbg_timestamp all_objects.timestamp%TYPE;
		rel_timestamp all_objects.timestamp%TYPE;
		obj_type  all_objects.object_type%TYPE;
		tmp_count NUMBER;

	begin
		open get_dbg;
		loop 
			fetch get_dbg into dbg_name, obj_type, dbg_timestamp;
			exit when get_dbg%NOTFOUND;

			/* This section for obtaining the release version name */

			select count(*) into tmp_count from PTSQL_DBG_OBJS
				where DBGNAME = dbg_name;

			if (tmp_count = 0)  then			  
				rel_name := substr(dbg_name,5);	  --short names	go here
			else          
				select name into rel_name from PTSQL_DBG_OBJS
					where dbgname = dbg_name;
			end if;
			
			/* Here to determine if the release version exists and if it does,
			** check whether its timestamp is earlier than that of the debug version.
			*/

			select count(*) into tmp_count from ptsql_objects
				where owner = obj_owner
				and object_name = rel_name
				and object_type = obj_type;

			if ( tmp_count = 0 ) then
				dyndrop (obj_owner, dbg_name, obj_type);
			else 
				select timestamp into rel_timestamp from ptsql_objects
					where owner = obj_owner
					and object_name = rel_name
					and object_type = obj_type;

				if (rel_timestamp > dbg_timestamp) then
					dyndrop (obj_owner, dbg_name, obj_type);
				end if;
			end if;
		end loop;
	end clnup;

  
	procedure dba_clnup		  
	is
		cursor get_owners is
		select distinct owner from ptsql_objects
			where object_type in ('PROCEDURE', 'FUNCTION', 'PACKAGE')
			and object_name like 'X#Z$%' or object_name like 'X#X$%'
			order by owner;

		owner_name ptsql_objects.owner%TYPE;
	begin
		open get_owners;
		loop
			fetch get_owners into owner_name;

			exit when get_owners%NOTFOUND;

			clnup(owner_name);
		end loop;
	end dba_clnup;

	procedure in_sync_clnup (obj_owner IN ptsql_objects.owner%TYPE,
							 obj_type IN ptsql_objects.object_type%TYPE)
	is
		cursor get_dbg is
		select object_name,  timestamp from all_objects
			where owner = obj_owner
			and (object_name like 'X#Z$%'
			or object_name like 'X#X$%')
			and object_type = obj_type;
			   
		dbg_name  all_objects.object_name%TYPE;
		rel_name  all_objects.object_name%TYPE;
		dbg_timestamp  all_objects.timestamp%TYPE;
		rel_timestamp  all_objects.timestamp%TYPE;
		tmp_count number;

	begin
		open get_dbg;
		loop 
			fetch get_dbg into dbg_name,  dbg_timestamp;
			exit when get_dbg%NOTFOUND;

			/* This section for obtaining the release version name */

			select count(*) into tmp_count from PTSQL_DBG_OBJS where dbgname = dbg_name;
			
			if (tmp_count = 0)  then
				rel_name := substr(dbg_name,5);
			else          
				select name into rel_name from PTSQL_DBG_OBJS where dbgname = dbg_name;
			end if;

			/* Here to determine if the release version exists and if it does,
			** check whether its timestamp is earlier than that of the debug version 
			*/

			select count(*) into tmp_count from ptsql_objects
				where owner = obj_owner
				and object_name = rel_name
				and object_type = obj_type;

			if ( tmp_count > 0 ) then
				select timestamp into rel_timestamp from ptsql_objects
					where owner = obj_owner
					and object_name = rel_name
					and object_type = obj_type;

				if (rel_timestamp <= dbg_timestamp) then
					dyndrop (obj_owner, dbg_name, obj_type);
				end if;
			end if;
		end loop;
	end in_sync_clnup;

end PTSQL_DBG_MAINT;
/

grant execute on PTSQL_DBG_MAINT to public;


create or replace package PTSQL_DEBUG as
	type idholder is table of varchar2(30) index by binary_integer;
	type extidholder is table of varchar2(100) index by binary_integer; 
	type valueholder is table of varchar2(2000) index by binary_integer;
	type linenoholder is table of varchar2(30) index by binary_integer;
	type boolholder is table of varchar2(30) index by binary_integer;
	sessionid number;
	currentpos number;
	continueflag boolean;
	currentprocname varchar2(30);
	currentmodname varchar2(30);
	currentproctype varchar2(30);
	currentprocowner varchar2(30);
	stepintoflag boolean;
	stepoutflag boolean;
	stepoverflag boolean;
	exprname varchar2(100);
	exprvalue varchar2(2000);
	evalname varchar2(100);
	evalvalue varchar2(2000);
	msgClientStop constant number := -200;
	msgClientContinue constant number := -100;
	msgClientStepover constant number := -300;
	msgClientStepinto constant number := -400;
	msgClientStepout constant number := -500;
	msgClientStart constant number := -600;
	msgClientTimeout constant number := -800;
	proTerminate constant varchar2(10) := 'TPR';
	proClient constant varchar2(10) := 'CPR';
	
	/***** should update this and sync with dbgorcon whenever this package or the body is modified *******/
	versionnumber varchar2(10) := '2.0';

	d boolean;
	procedure GetVersionNumber(vnum out varchar2);
	procedure CleanAllDebugTables;
	procedure ClientTerminationCleanup;
	procedure RemoveDebugJob(uniqueid number);
	procedure ReceiveServerMessage(messageid out varchar2);
	procedure RetreiveBreakPosition(recbreakline out varchar2, recbreakname out varchar2, recbreaktype out varchar2, recbreakowner out varchar2 ); 
	procedure RetreiveWatchValues(recwatchname out extidholder, recwatchtype out idholder, recwatchvalue out valueholder, recwatchmodify out boolholder, r_objects in out number, status in out varchar2);
	procedure RetreiveCallstack(recprocname out idholder, recproctype out idholder, recprocowner out idholder, r_objects in out number, status in out varchar2);
	procedure SendClientMessage(messageid number);
	procedure SendServerStoppedMessage;

	procedure SetSessionID(uniqueid number);
	procedure PrepareClient(errorno number, uClientTimeout number);
	procedure ResetClient;
	procedure PrepareServer(uniqueid number, errorno number, uServerTimeout number, procname varchar2, modname varchar2, proctype varchar2, procowner varchar2);
	procedure ClientThreadStopProcessor;
	procedure ClientJobStopProcessor;
	procedure PW(watchname varchar2, watchtype varchar2, watchvalue varchar2, bwatchmodify number);
	procedure PW(watchname varchar2, watchtype varchar2, watchvalue boolean, bWatchmodify number);
	procedure GWV(iName varchar2, iRet in out varchar2);
	procedure GWV(iName varchar2, iRet in out boolean);
	procedure SetWatchValue(iName varchar2, iValue varchar2);
	procedure SetWatchValue(iName varchar2, iValue boolean);
	function IsSteppable return boolean;
	procedure DSC;
	function PI(iPosition number, procname varchar2, procmodname varchar2, proctype varchar2, procowner varchar2) return boolean;
	procedure ClientEvaluateProcessor(sndname varchar2, recvalue out varchar2);
	procedure SetBreakpoint(iLine number, iName varchar2, iType varchar2, iOwner varchar2);
	procedure ResetBreakpoint(iLine number, iName varchar2, iType varchar2, iOwner varchar2);
	procedure SetServerTimeOutMinutes ( iMinutes number);
	procedure PrepareClientThread(uniqueid number);
end PTSQL_DEBUG;
/

create or replace package body PTSQL_DEBUG as
	procnametable idholder;
	procmodtable idholder;
	proctypetable idholder;
	procownertable idholder;
	-- server and client package watch variable set/reset table
	watchnametable extidholder;
	watchtypetable idholder;
	watchvaluetable valueholder;
	watchmodifytable boolholder;
	-- break point info table
	breakproctable idholder;
	breaktypetable idholder;
	breakownertable idholder;
	breaklinetable  linenoholder;
	dummyidtable idholder;
	dummyextidtable extidholder;
	dummyvaluetable valueholder;
	dummylinenotable linenoholder;
	lengthstack number;
	watchcount number;
	breakcount number;
	raiseno number;
	clientraiseno number;
	bBreakModify boolean;
	nInitTime  number ;	
	pipClient constant varchar2(10) := 'CP';
	pipServer constant varchar2(10) := 'SP';
	proServer constant varchar2(10) := 'SPR';
	proEval constant varchar2(10) := 'EPR';
	proWatch constant varchar2(10) := 'WPR';
	msgClientWatch constant number := -3000;
	msgServerWatch constant number := -3001;
	msgClientEval constant number := -2000;
	msgServerEval constant number := -2001;
	msgServerInterrupt constant number := -1000;
	msgClientInterrupt constant number := -1001;
	msgServer constant number := -701;
	msgTimeout number;


    tot_rows     NUMBER;  
    rows_sent    NUMBER;  

	Minutes_conv constant number := 6000;	
	timeOut_minutes 	       number  default  10;	 
	timeOut                      number  default  60000; 
	procedure  CheckTimeOut ;

	temppos number;
	tempname varchar2(30);
	tempmodname varchar2(30);
	temptype varchar2(30);
	tempowner varchar2(30);

	function SendMessage(uniqueid varchar2) return integer;
	procedure SendServerMessage;
	procedure ReceiveClientMessage(messageid out number);

	procedure SendClientIntrMessage;
	procedure SendServerIntrMessage;
	procedure ReceiveServerIntrMessage;
	procedure ReceiveClientIntrMessage(messageid out number);

	procedure SendClientEvalMessage(sndname varchar2);
	procedure SendServerEvalMessage;
	procedure ReceiveServerEvalMessage(recvalue out varchar2);

	procedure SendServerWatchMessage;
	procedure SendClientWatchMessage;
	procedure ReceiveServerWatchMessage;

	procedure SetTimer;
	procedure ResetCallstack;
	procedure Push;
	procedure Pop;
	procedure ResetWatches;
	function IsBreakpoint return boolean;
	function IsPop return boolean;
	function IsCurrentSame return boolean;
	function IsStepoutProcessor return boolean;
	function IsStepoverProcessor return boolean;
	function IsStepintoProcessor return boolean;
	function IsContinueProcessor return boolean;
	procedure ProcessClientMessage;
	procedure CheckClientInterrupt;
	procedure ProcessEvalMessage;
	procedure ProcessWatchMessage;
	procedure EvaluateGlobalVariable;
	procedure PackCallstack;
	procedure UnpackCallstack;

	m_sndname varchar2(30);
	procedure GetVersionNumber(vnum out varchar2)
	as
	begin
	 vnum := versionnumber;
	end GetVersionNumber;
	procedure CleanAllDebugTables
	as
	begin
	 null;
	end CleanAllDebugTables;
	procedure ClientTerminationCleanup
	as
	begin
	dbms_pipe.purge(concat(to_char(sessionid), pipServer));
	 dbms_pipe.purge(concat(to_char(sessionid), pipClient));
	end ClientTerminationCleanup;
	procedure PackBreakMessages
	as
	begin
	 if (bBreakModify = FALSE) then
		-- sent -1 as the message count to indicate breakpoints have not been modified
		dbms_pipe.pack_message(-1);
	   return;
	 end if;
	-- pack the number of breaks count
	 dbms_pipe.pack_message(breakcount);
	 -- now pack all the breaks
	 for i in 1.. breakcount loop
	   dbms_pipe.pack_message(breakproctable(i));
	   dbms_pipe.pack_message(breaktypetable(i));
	   dbms_pipe.pack_message(breakownertable(i));
	   dbms_pipe.pack_message(breaklinetable(i));
	 end loop;
	end PackBreakMessages;
	procedure SendClientMessage(messageid number)
	as
	iRet number;
	begin
	dbms_pipe.pack_message(proClient);
	dbms_pipe.pack_message(messageid);
	PackBreakMessages;
	iRet := SendMessage(concat(to_char(sessionid), pipClient));
	bBreakModify := FALSE;
	end SendClientMessage;
	function ReceiveMessage(uniqueid varchar2) return boolean
	as
	nMes integer;
	begin
	nMes := dbms_pipe.receive_message(uniqueid, 0);
	 if (nMes <> 0) then
		return FALSE;
	 elsif ( nMes = 0 ) then
		SetTimer ;
		return TRUE;
	 end if;
	 return FALSE;
	end ReceiveMessage;
	function ReceiveMessageBlocking(uniqueid varchar2) return boolean
	as
	nMes integer;
	begin
	nMes := dbms_pipe.receive_message(uniqueid, msgTimeout); 
	 if (nMes <> 0) then
		return FALSE;
	 elsif ( nMes = 0 ) then
		SetTimer ;
		return TRUE;
	 end if;
	  return FALSE;
	end ReceiveMessageBlocking;
	procedure UnpackBreakMessages
	as
	tempcount number;
	begin
	-- unpack the number of breaks count
	dbms_pipe.unpack_message(tempcount);
	if (tempcount = -1) then
	   return;
	end if;
	breakcount := tempcount;
	-- now unpack all the breaks
	for i in 1.. breakcount loop
	   dbms_pipe.unpack_message(breakproctable(i));
	   dbms_pipe.unpack_message(breaktypetable(i));
	   dbms_pipe.unpack_message(breakownertable(i));
	   dbms_pipe.unpack_message(breaklinetable(i));
	end loop;
	end UnpackBreakMessages;
	procedure ReceiveClientMessage(messageid out number)
	as
	i number;
	uniqueid varchar2(30);
	 nMes integer;
	 nProtocol varchar2(10);
	bRet boolean;
	begin
	 uniqueid := concat(to_char(sessionid), pipClient);
	 messageid := -2;
	<<RECEIVE_AGAIN>>
	 bRet := ReceiveMessageBlocking(uniqueid);
	 if (bRet = FALSE) then
	    raise_application_error( raiseno, 'debug procedure timeout');
		return;
	end if;
	dbms_pipe.unpack_message(nProtocol);
	if (nProtocol = proEval) then
	 ProcessEvalMessage;
	 goto RECEIVE_AGAIN;
	end if;
	if (nProtocol = proWatch) then
	 ProcessWatchMessage;
	 goto RECEIVE_AGAIN;
	end if;
	if (nProtocol = proTerminate) then
	  messageid := msgClientInterrupt;
	  sendserverintrmessage;
	   -- force termination of the procedure.
	   raise_application_error( clientraiseno, 'client message to exit'); 
	  return;
	end if;
	dbms_pipe.unpack_message(messageid);
	UnpackBreakMessages;
	end ReceiveClientMessage;
	procedure SendServerWatchMessage
	as
	uniqueid varchar2(30);
	iRet integer;
	begin
	uniqueid := concat(to_char(sessionid), pipServer);
	dbms_pipe.pack_message(proWatch);
	iRet := SendMessage(uniqueid);
	end SendServerWatchMessage;
	procedure SendServerEvalMessage
	as
	uniqueid varchar2(30);
	iRet integer;
	begin
	uniqueid := concat(to_char(sessionid), pipServer);
	dbms_pipe.pack_message(proEval);
	dbms_pipe.pack_message(evalvalue);
	iRet := SendMessage(uniqueid);
	end SendServerEvalMessage;
	procedure SendServerIntrMessage
	as
	iRet integer;
	begin
	iRet := SendMessage(concat(to_char(sessionid), pipServer));
	end SendServerIntrMessage;
	procedure SendServerMessage
	as
	uniqueid varchar2(30);
	iRet number;
	messageid number;
	begin
	messageid := msgServer;
	uniqueid := concat(to_char(sessionid), pipServer);
	dbms_pipe.pack_message(proServer);
	dbms_pipe.pack_message(messageid);
	dbms_pipe.pack_message(currentpos);
	dbms_pipe.pack_message(currentprocname);
	dbms_pipe.pack_message(currentproctype);
	dbms_pipe.pack_message(currentprocowner);
	dbms_pipe.pack_message(watchcount);
	for i in 1.. watchcount loop
	   dbms_pipe.pack_message(watchnametable(i));
	   dbms_pipe.pack_message(watchtypetable(i));
	   dbms_pipe.pack_message(watchvaluetable(i));
	   dbms_pipe.pack_message(watchmodifytable(i));
	end loop;
	PackCallStack;
	iRet := SendMessage(uniqueid);
	end SendServerMessage;
	procedure PackCallstack 
	as
	begin
	 dbms_pipe.pack_message(lengthstack);
	 for i in 1..lengthstack loop
	   dbms_pipe.pack_message(procnametable(i));
	   dbms_pipe.pack_message(proctypetable(i));
	   dbms_pipe.pack_message(procownertable(i));
	 end loop;
	end PackCallstack;
	procedure UnpackCallstack
	as
	begin
	 dbms_pipe.unpack_message(lengthstack);
	 for i in 1..lengthstack loop
		dbms_pipe.unpack_message(procnametable(i));
		dbms_pipe.unpack_message(proctypetable(i));
		dbms_pipe.unpack_message(procownertable(i));
	 end loop;
	end UnpackCallstack;
	procedure SendClientWatchMessage
	as
	uniqueid varchar2(30);
	iRet integer;
	begin
	uniqueid := concat(to_char(sessionid), pipClient);
	dbms_pipe.pack_message(proWatch);
	dbms_pipe.pack_message(exprname);
	dbms_pipe.pack_message(exprvalue);
	iRet := SendMessage(uniqueid);
	end SendClientWatchMessage;
	procedure SendClientEvalMessage(sndname varchar2)
	as
	uniqueid varchar2(30);
	iRet integer;
	begin
	uniqueid := concat(to_char(sessionid), pipClient);
	dbms_pipe.pack_message(proEval);
	dbms_pipe.pack_message(sndname);
	iRet := SendMessage(uniqueid);
	end SendClientEvalMessage;
	procedure SendClientIntrMessage
	as
	iRet integer;
	begin
	 dbms_pipe.pack_message(proTerminate);
	 iRet := SendMessage(concat(to_char(sessionid), pipClient));
	end SendClientIntrMessage;
	procedure ReceiveClientIntrMessage(messageid out number)
	as
	 bRet boolean;
	 nProtocol varchar2(10);
	begin 
	 messageid := -2; 
	 bRet := ReceiveMessage(concat(to_char(sessionid), pipClient));
	 if (bRet = TRUE) then
	   dbms_pipe.unpack_message(nProtocol); 
	   messageid := msgClientInterrupt;
	 end if;
	end ReceiveClientIntrMessage;
	procedure ReceiveServerWatchMessage
	as
	nProtocol varchar2(10);
	bRet boolean;
	uniqueid varchar2(30);
	begin
	 uniqueid := concat(to_char(sessionid), pipServer);
	 nProtocol := '';
	 bRet := ReceiveMessageBlocking(uniqueid);
	 if (bRet = FALSE) then
		return;
	 end if;
	dbms_pipe.unpack_message(nProtocol);
	end ReceiveServerWatchMessage;
	procedure ReceiveServerEvalMessage(recvalue out varchar2)
	as
	nProtocol varchar2(10);
	bRet boolean;
	uniqueid varchar2(30);
	begin
	 uniqueid := concat(to_char(sessionid), pipServer);
	 nProtocol := '';
	 bRet := ReceiveMessageBlocking(uniqueid);
	 if (bRet = FALSE) then
	   return;
	 end if;
	dbms_pipe.unpack_message(nProtocol);
	dbms_pipe.unpack_message(recvalue);
	end ReceiveServerEvalMessage;
	procedure ReceiveServerIntrMessage
	as
	 bRet boolean;
	begin
	bRet := ReceiveMessageBlocking(concat(to_char(sessionid), pipServer));
	end ReceiveServerIntrMessage;
	procedure RetreiveCallstack(recprocname out idholder, recproctype out idholder, recprocowner out idholder, r_objects in out number, status in out varchar2)
	as
	tmp_cntr number;
	begin
	if status = 'NEW' 
	then
		tot_rows := lengthstack;
		rows_sent := 0;
	end if;

	-- return rows
	tmp_cntr := 0;
	for i IN 1+rows_sent .. LEAST(rows_sent+r_objects,tot_rows) LOOP
	   recprocname(tmp_cntr+1) := procnametable(i);
	   recproctype(tmp_cntr+1) := proctypetable(i);
	   recprocowner(tmp_cntr+1) := procownertable(i);
	   tmp_cntr := tmp_cntr + 1;
	end loop;

	-- update counters
	r_objects := tmp_cntr; -- no. rows actually returned on this call
	rows_sent := rows_sent + tmp_cntr;

	-- set return status
	status := 'MOR';
	IF rows_sent = tot_rows 
	THEN
	  status := 'DON';
	END IF;

	end RetreiveCallstack;

	procedure RetreiveWatchValues(recwatchname out extidholder, recwatchtype out idholder, recwatchvalue out valueholder, recwatchmodify out boolholder, r_objects in out number, status in out varchar2)
	as
	tmp_cntr number;
	begin
	if status = 'NEW' 
	then
		tot_rows := watchcount;
		rows_sent := 0;
	end if;

	-- return rows
	tmp_cntr := 0;
	FOR i IN 1+rows_sent .. LEAST(rows_sent+r_objects,tot_rows) LOOP
	  recwatchname(tmp_cntr + 1) := watchnametable(i);
	  recwatchtype(tmp_cntr + 1) := watchtypetable(i);
	  if watchvaluetable(i) IS NULL THEN
	   recwatchvalue(tmp_cntr + 1) := 'NULL';
	  else
	   recwatchvalue(tmp_cntr + 1) := watchvaluetable(i);
	  end if;
	  recwatchmodify(tmp_cntr+1) := watchmodifytable(i);
	  tmp_cntr := tmp_cntr + 1;
	END LOOP;

	-- update counters
	r_objects := tmp_cntr; -- no. rows actually returned on this call
	rows_sent := rows_sent + tmp_cntr;

	-- set return status
	status := 'MOR';
	IF rows_sent = tot_rows 
	THEN
	  status := 'DON';
	END IF;

	end RetreiveWatchValues;
	procedure RetreiveBreakPosition(recbreakline out varchar2, recbreakname out varchar2, recbreaktype out varchar2, recbreakowner out varchar2)
	as
	begin
	recbreakline := currentpos;
	recbreakname := currentprocname;
	recbreaktype := currentproctype;
	recbreakowner := currentprocowner;
	end;
	procedure ReceiveServerMessage(messageid out varchar2)
	as
	uniqueid varchar2(30);
	iRet number;
	tmpmsg number;
	nMes integer;
	nProtocol varchar2(10);
	bRet boolean;
	begin
	 messageid := -2;
	 tmpmsg := -2;
	 nProtocol := -2;
	uniqueid := concat(to_char(sessionid), pipServer);
	bRet := ReceiveMessageBlocking (uniqueid);
	if (bRet = FALSE) then
	  messageid := msgClientTimeout;
	  return;
	end if; 
	dbms_pipe.unpack_message(nprotocol);
	if (nProtocol = proTerminate) then
	   dbms_pipe.unpack_message(currentpos);
	   dbms_pipe.unpack_message(currentprocname);
	   dbms_pipe.unpack_message(currentproctype);
	   dbms_pipe.unpack_message(currentprocowner); 
	   return;
	end if;
	dbms_pipe.unpack_message(tmpmsg);
	dbms_pipe.unpack_message(currentpos);
	dbms_pipe.unpack_message(currentprocname);
	dbms_pipe.unpack_message(currentproctype);
	dbms_pipe.unpack_message(currentprocowner);
	dbms_pipe.unpack_message(watchcount);
	for i in 1.. watchcount loop
	   dbms_pipe.unpack_message(watchnametable(i));
	   dbms_pipe.unpack_message(watchtypetable(i));
	   dbms_pipe.unpack_message(watchvaluetable(i));
	   dbms_pipe.unpack_message(watchmodifytable(i));
	end loop;
	UnpackCallStack;
	messageid := tmpmsg;
	end ReceiveServerMessage;
	procedure RemoveDebugJob(uniqueid number)
	as
	icount number;
	begin
	select count(*) into icount from user_jobs where job = uniqueid;
	if (icount > 0) then
	  dbms_job.remove(uniqueid);
	end if;
	end RemoveDebugJob;
	procedure SetSessionID(uniqueid number)
	as
	begin
	 sessionid := uniqueid;
	end SetSessionID;
	procedure PrepareClientThread(uniqueid number)
	as
	begin
	 sessionid := uniqueid;
	end PrepareClientThread;
	procedure PrepareServer(
	uniqueid number,
	errorno number,
	uServerTimeout number,
	procname varchar2,
	modname varchar2,
	proctype varchar2,
	procowner varchar2)
	as
	ctrlmsg number;
	begin
	 sessionid := uniqueid;
	 raiseno := errorno;
	 clientraiseno := raiseno + 1;
	 SetServerTimeoutMinutes(uServerTimeout);
	 msgTimeout := uServerTimeout * 60;
	 dbms_pipe.purge(concat(to_char(sessionid), pipServer));
	 currentpos := 0;
	 continueflag := TRUE;
	 stepintoflag := FALSE;
	 stepoutflag := FALSE;
	 currentprocname := procname;
	 currentmodname := modname;
	 currentproctype := proctype;
	 currentprocowner := procowner;
	 breakcount := 0;
	 ResetCallstack;
	 ResetWatches;
	 ctrlmsg := -2;
	ReceiveClientMessage(ctrlmsg);
	end PrepareServer;
	procedure ResetClient
	as
	begin
	 currentpos := 0;
	 breakcount := 0;
	 sessionid := USERENV('SESSIONID');
	end ResetClient;
	procedure PrepareClient( 
	errorno number,
	uClientTimeout number)
	as
	begin
	 ResetWatches;
	bBreakModify := TRUE;  
	dbms_pipe.purge(concat(to_char(sessionid), pipClient));
	msgTimeout := uClientTimeout; 
	raiseno :=errorno;
	clientraiseno := raiseno+1;
	end PrepareClient;
	procedure ResetCallstack 
	as
	begin
	 procnametable := dummyidtable;
	 procmodtable := dummyidtable;
	 proctypetable := dummyidtable;
	 procownertable := dummyidtable;
	 lengthstack := 0;
	end ResetCallstack;
	procedure ResetWatches
	as
	begin
	 watchnametable := dummyextidtable;
	 watchtypetable := dummyidtable;
	 watchvaluetable := dummyvaluetable;
	 watchcount := 0;
	end ResetWatches;
	procedure PW(
	watchname varchar2,
	watchtype varchar2,
	watchvalue  varchar2,
	bWatchModify number)
	as
	begin
	 watchcount := watchcount + 1; 
	 watchnametable(watchcount) := watchname;
	 watchtypetable(watchcount) := watchtype;
	 watchvaluetable(watchcount) := watchvalue;
  	 watchmodifytable(watchcount) := bWatchModify;
	end PW;
	procedure PW(
	watchname varchar2,
	watchtype varchar2,
	watchvalue  boolean,
	bWatchModify number)
	as
	begin
	 watchcount := watchcount + 1; 
	 watchnametable(watchcount) := watchname;
	 watchtypetable(watchcount) := watchtype;
	 if (watchvalue = TRUE) then
	  watchvaluetable(watchcount) := 'TRUE';
	 elsif (watchvalue = FALSE) then
	   watchvaluetable(watchcount) := 'FALSE';
	 else
	   watchvaluetable(watchcount) := 'NULL';
	 end if;
	 watchmodifytable(watchcount) := bWatchModify;
	end PW;
	procedure SetWatchValue(iName varchar2, iValue varchar2)
	as
	begin
	  exprname := iName;
	  exprvalue := iValue;
	  SendClientWatchMessage;
	  ReceiveServerWatchMessage;
	end SetWatchValue;
	procedure SetWatchValue(iName varchar2, iValue boolean)
	as
	begin
	  exprname := iName;
	  if (iValue = TRUE) then
	   exprvalue := 'TRUE';
	  elsif (iValue = FALSE) then
		exprvalue := 'FALSE';
	  else
	    exprvalue := 'NULL';
	  end if;
	  SendClientWatchMessage;
	  ReceiveServerWatchMessage;
	end SetWatchValue;
	procedure GWV(iName varchar2, iRet in out varchar2) 
	as
	i number;
	begin
	  for i in 1 .. watchcount loop
		if ((watchnametable(i) = iName) AND (watchmodifytable(i) = 1)) then
			iRet := watchvaluetable(i);
 			return;
		end if;
	  end loop; 
	end GWV;
	procedure GWV(iName varchar2, iRet in out boolean) 
	as
	i number;
	bRet varchar2(10);
	begin
	  for i in 1 .. watchcount loop
		if (watchnametable(i) = iName) then
			bRet := watchvaluetable(i);
			if (bRet = 'TRUE') then
				iRet := TRUE;
			elsif (bRet = 'FALSE') then
				iRet := FALSE;
			else
				iRet := NULL;
			end if;
			return;
		end if;
	  end loop; 
	end GWV;
	procedure ClientThreadStopProcessor
	as
	icount integer;
	begin
	SendClientIntrMessage;
	ReceiveServerIntrMessage;
	end ClientThreadStopProcessor;
	procedure ClientJobStopProcessor
	as
	begin
	 sendclientIntrmessage;
	 ReceiveServerIntrMessage;
	 dbms_job.remove(sessionid);
	end ClientJobStopProcessor;
	procedure Push
	as
	begin
	 lengthstack := lengthstack + 1;
	 procnametable(lengthstack) := currentprocname;
	 procmodtable(lengthstack) := currentmodname;
	 proctypetable(lengthstack) := currentproctype;
	 procownertable(lengthstack) := currentprocowner;
	 currentprocname := tempname;
	 currentmodname := tempmodname;
	 currentproctype := temptype;
	 currentprocowner := tempowner;
	end Push;
	procedure Pop
	as
	begin
	 if (lengthstack = 0) then
	  return;
	end if;
	currentprocname := procnametable(lengthstack);
	currentmodname := procmodtable(lengthstack);
	currentproctype := proctypetable(lengthstack);
	currentprocowner := procownertable(lengthstack);
	lengthstack := lengthstack - 1;
	end Pop;
	function IsPop return boolean 
	as
	begin
	 if (lengthstack = 0) then
		return FALSE;
	 end if;
	 if (tempname = procnametable(lengthstack) and
		 tempmodname = procmodtable(lengthstack) and
		 temptype = proctypetable(lengthstack) and
		 tempowner = procownertable(lengthstack)) then
	  return TRUE;
	end if;
	return FALSE;
	end IsPop;
	function IsBreakpoint return boolean
	as
	acount number;
	i number;
	begin
			-- check whether this was a break point location 
			 for i in 1..breakcount loop
			  if (breakproctable(i) = tempname and breaktypetable(i) = temptype and
				  breakownertable(i) = tempowner and breaklinetable(i) = temppos) then
			return TRUE;
		   end if;
		end loop;
		return FALSE;
	end IsBreakpoint;
	function IsCurrentSame return boolean
	as
	begin
	if (currentprocname = tempname and
		(currentmodname = tempmodname or
		 tempmodname = 'ANON') and
		currentproctype = temptype and
		currentprocowner = tempowner) then
	  return TRUE;
	end if;
	return FALSE;
	end IsCurrentSame;
	function IsStepoutProcessor return boolean
	as
	begin
	if (IsCurrentSame) then
	return FALSE;
	end if;
	if (IsPop) then
	  Pop;
	  stepoutflag := FALSE;
	  return TRUE;
	end if;
	return FALSE;
	end IsStepoutProcessor;
	function IsStepoverProcessor return boolean
	as
	begin
	stepoverflag := FALSE;
	if (IsCurrentSame) then
		return TRUE;
	end if;
	if (IsPop) then
		Pop;
		return TRUE;
	else
		if (IsBreakpoint) then
			Push;
			return TRUE;
		end if;
	end if;	
	stepoverflag := TRUE;
	return FALSE;
	end IsStepoverProcessor;
	function IsStepintoProcessor return boolean
	as
	begin
	stepintoflag := FALSE;
	if (IsCurrentSame) then
	  return TRUE;
	end if;
	if (IsPop) then
	  Pop;
	  return TRUE;
	else
	  Push;
	  return TRUE;
	end if;
	end IsStepintoProcessor;
	function IsContinueProcessor return boolean
	as
	begin
	if (IsBreakpoint) then
		continueflag := FALSE;
		if (IsPop) then
			Pop;
		elsif (IsCurrentSame) then
			null; -- do nothing
		else
			Push;
		end if;
		return TRUE;
	end if;
	return FALSE;
	end IsContinueProcessor;
	function IsSteppable return boolean
	as
	bReturn boolean;
	begin
	currentpos := temppos;
	if (stepoutflag = TRUE) then
	  return IsStepoutProcessor;
	end if;
	if (stepoverflag = TRUE) then
	  return IsStepoverProcessor;
	end if;
	if (stepintoflag = TRUE) then
	  return IsStepintoProcessor;
	end if;
	if (continueflag = TRUE) then
		return IsContinueProcessor;
	end if;
	return FALSE;
	end IsSteppable;
	procedure DSC 
	as
	begin
	SendServerMessage; 
	 ProcessClientMessage;
	end DSC;
	procedure ModifyServerWatchValue
	as
	begin
	  for i in 1..watchcount loop
		if (watchnametable(i) = exprname) then
			watchvaluetable(i) := exprvalue;
		end if;
	 end loop;
	end ModifyServerWatchValue;
	procedure ProcessWatchMessage
	as
	begin
	 dbms_pipe.unpack_message(exprname);
	 dbms_pipe.unpack_message(exprvalue);
	 ModifyServerWatchValue;
	 SendServerWatchMessage;
	end ProcessWatchMessage;
	procedure ProcessClientMessage
	as
	ctrlmsg number;
	bRet boolean;
	begin
	 ctrlmsg := 0; 
	-- wait for message from the control side of the debugger 
	SetTimer;
	ReceiveClientMessage(ctrlmsg);
	if (ctrlmsg = msgClientContinue) then
		continueflag := TRUE;
	else
		continueflag := FALSE;
	end if;
	if (ctrlmsg = msgClientStepinto) then
	stepintoflag := TRUE;
	end if;
	if (ctrlmsg = msgClientStepout) then
	stepoutflag := TRUE;
	end if;
	if (ctrlmsg = msgClientStepover) then
	stepoverflag := TRUE;
	end if;
	end ProcessClientMessage;
	function PI(
	iPosition number, 
	procname varchar2, 
	procmodname varchar2,
	proctype varchar2, 
	procowner varchar2)  return boolean
	as
	begin
	temppos := iPosition;
	if (procmodname IS NOT NULL) then
		tempname := procname;
		tempmodname := procmodname;
		temptype := proctype;
		tempowner := procowner;
	end if;
	CheckTimeOut;
	CheckClientInterrupt;
	if (IsSteppable != TRUE) then 
		return FALSE; 
	 end if; 
	ResetWatches; 
	 if sql%found then 
 		 PW('SQL%FOUND', 'boolean', 1, 0); 
	 else 
		PW('SQL%FOUND', 'boolean', 0, 0); 
	 end if; 
	 PW('SQL%ROWCOUNT', 'number', sql%rowcount, 0); 
	return TRUE;
	end PI;
	procedure CheckClientInterrupt
	as
	ctrlmsg number;
	begin
	 ctrlmsg := -2;
	ReceiveClientIntrMessage(ctrlmsg);
	 if (ctrlmsg = msgClientInterrupt) then 
		  SendServerIntrMessage;
		  raise_application_error( clientraiseno, 'client message to exit'); 
	  end if; 
	end CheckClientInterrupt;
	procedure ProcessEvalMessage
	as
	uniqueid varchar2(30);
	begin
	uniqueid := concat(to_char(sessionid), pipClient);
	dbms_pipe.unpack_message(evalname);
	EvaluateGlobalVariable;
	SendServerEvalMessage;
	end ProcessEvalMessage;
	procedure EvaluateGlobalVariable
	as
	begin
	declare
	icursor number;
	globaleval varchar2(1000);
	begin
	 icursor := dbms_sql.open_cursor;
	 evalvalue := '';
	 globaleval := 'begin PTSQL_DEBUG.evalvalue := ' || PTSQL_DEBUG.evalname || ';  end;';
	 dbms_sql.parse(icursor, globaleval, dbms_sql.v7);
	 icursor := dbms_sql.execute(icursor);
	end;
	 exception when others then
		 null;
	end EvaluateGlobalVariable;
	procedure ClientEvaluateProcessor(sndname varchar2, recvalue out varchar2)
	as
	begin
	 SendClientEvalMessage(sndname);
	 ReceiveServerEvalMessage(recvalue); 
	end ClientEvaluateProcessor;
	procedure SetBreakpoint(iLine number, iName varchar2, iType varchar2, iOwner varchar2)
	as
	begin
	breakcount := breakcount + 1;
	breakproctable(breakcount) := iName;
	breaktypetable(breakcount) := iType;
	breakownertable(breakcount) := iOwner;
	breaklinetable(breakcount) := iLine;
	bBreakModify := TRUE;
	end SetBreakpoint;
	procedure ResetBreakpoint(iLine number, iName varchar2, iType varchar2, iOwner varchar2)
	as
	begin
	for i in 1..breakcount loop
	  if (breakproctable(i) = iName and breaktypetable(i) = iType and breakownertable(i) = iOwner
			and breaklinetable(i) = iLine) then
			breakproctable(i) := NULL;
	  end if;
	end loop;
	 -- set the modify breakpoint flag for the messaging interface
	 bBreakModify := TRUE;
	end ResetBreakpoint;

	procedure SetTimer
	is
	begin
	   nInitTime := dbms_utility.get_time;
	end SetTimer;
	procedure CheckTimeOut
	is
	  nNowTime number;
	  nElapsedTime number;
	begin
	   nNowTime := dbms_utility.get_time;
	   nElapsedTime  := nNowTime - nInitTime;
	   if  (nElapsedTime >  timeOut ) THEN
		   raise_application_error ( raiseno,  ' Debug Procedure Aborted.  No Input From User for more than ' ||
										 TimeOut_Minutes || ' minutes ');
	   end if;
	end CheckTimeOut;
	procedure SetServerTimeOutMinutes (iMinutes number)
	as
	begin
	timeOut_minutes := iMinutes;
	timeOut :=  timeOut_minutes * Minutes_conv;
	end SetServerTimeOutMinutes; 
	procedure SendServerStoppedMessage
	as
	iRet integer;
	uniqueid varchar2(30);
	begin
	uniqueid := concat(to_char(sessionid), pipServer);
	 dbms_pipe.pack_message(proTerminate);
	 dbms_pipe.pack_message(currentpos);
	 dbms_pipe.pack_message(currentprocname);
	 dbms_pipe.pack_message(currentproctype);
	 dbms_pipe.pack_message(currentprocowner);
	 iRet := SendMessage(uniqueid);
	end SendServerStoppedMessage;
	function SendMessage(uniqueid varchar2) return integer
	as
	iRet integer;
	begin
	dbms_pipe.purge(uniqueid);
	 return  dbms_pipe.send_message(uniqueid, 0);
	end SendMessage;
end PTSQL_DEBUG;
/
grant execute on PTSQL_DEBUG to public;
grant execute on PTSQL_DBG_MAINT to public;



/******************************************************************
** PTSQL_DEPEND package
*******************************************************************/


CREATE OR REPLACE PACKAGE ptsql_depend AS

  TYPE varchar2_30_arr IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
  TYPE number_arr IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;


  PROCEDURE browser_objs (obj_owner IN VARCHAR2, obj_name IN VARCHAR2,
                obj_type IN VARCHAR2, r_objects IN OUT NUMBER, 
                status IN OUT VARCHAR2,
                r_obj_owner OUT varchar2_30_arr, 
                r_obj_name OUT varchar2_30_arr, 
                r_obj_type OUT varchar2_30_arr,
                r_level  OUT number_arr,
                r_remote OUT number_arr,
                up_down IN VARCHAR2 DEFAULT 'DOWN', ret_levels IN NUMBER DEFAULT -1);

  PROCEDURE plsql_objs (obj_owner IN VARCHAR2, obj_name IN VARCHAR2,
                obj_type IN VARCHAR2, r_objects IN OUT NUMBER,
                status IN OUT VARCHAR2,
                r_obj_owner OUT varchar2_30_arr, 
                r_obj_name OUT varchar2_30_arr, 
                r_obj_type OUT varchar2_30_arr,
                r_level  OUT number_arr,
                r_remote OUT number_arr,
                syn_owner OUT varchar2_30_arr,
                syn_name OUT varchar2_30_arr);

  PROCEDURE sys_debug_privs (debug_proc_priv OUT CHAR, view_proc_priv OUT CHAR,
                                                                  select_any_seq OUT CHAR, select_any_tab OUT CHAR);

END ptsql_depend;
/
CREATE OR REPLACE PACKAGE BODY         ptsql_depend AS

  owner_arr       varchar2_30_arr;
  name_arr         varchar2_30_arr;
  type_arr           varchar2_30_arr;
  level_arr           number_arr;
  remote_arr      number_arr;
  syn_own_arr   varchar2_30_arr;
  syn_name_arr varchar2_30_arr;

  obj_id       NUMBER;  -- numeric object ID
  own_id       NUMBER;  -- numeric owner ID
  type_id      NUMBER;  -- numeric object type ID (7=Procedure, 8=Function, 9=Package)

  tot_rows     NUMBER;  -- tot dependencies in arrays
  rows_sent    NUMBER;  -- tot dependencies returned to client

  last_owner   VARCHAR2(30);  -- object owner on last call
  last_name    VARCHAR2(30);  -- object name on last call

 root_name VARCHAR2(30);

  user_has_debug_any_proc_priv BOOLEAN;  -- sys priv for debugging proc
  user_has_view_any_proc_priv BOOLEAN;  -- sys priv to view proc
  user_has_sel_any_seq_priv BOOLEAN;  -- sys priv to select any sequence
  user_has_sel_any_table_priv BOOLEAN;  -- sys priv to select any table or view
-- Forward calls

  PROCEDURE get_proc_dependencies (obj_id IN NUMBER);
  FUNCTION debug_privileged(own_id IN NUMBER, obj_id IN NUMBER) RETURN BOOLEAN;
  FUNCTION view_proc_privileged(own_id IN NUMBER, obj_id IN NUMBER) RETURN BOOLEAN;
  FUNCTION select_privileged(own_id IN NUMBER, obj_id IN NUMBER) RETURN BOOLEAN;
  PROCEDURE get_object_ids (obj_owner IN VARCHAR2, obj_name IN VARCHAR2,
                obj_type IN VARCHAR2);
  PROCEDURE translate_synonym (syn_owner IN VARCHAR2, syn_name VARCHAR2,  
                               base_owner OUT VARCHAR2, base_name OUT VARCHAR2, 
                               base_type OUT VARCHAR2, base_remote OUT NUMBER);

-- End of Forward Calls

/*****************************  SYS_DEBUG_PRIVS   ************************/
  PROCEDURE sys_debug_privs (debug_proc_priv OUT CHAR, view_proc_priv OUT CHAR,
                                                                  select_any_seq OUT CHAR, select_any_tab OUT CHAR) IS
  BEGIN
    IF user_has_debug_any_proc_priv 
    THEN debug_proc_priv := 'Y';
    ELSE debug_proc_priv := 'N';
    END IF;
    IF user_has_view_any_proc_priv 
    THEN view_proc_priv := 'Y';
    ELSE view_proc_priv := 'N';
    END IF;
    IF user_has_sel_any_seq_priv 
    THEN select_any_seq := 'Y';
    ELSE select_any_seq := 'N';
    END IF;
    IF user_has_sel_any_table_priv 
    THEN select_any_tab := 'Y';
    ELSE select_any_tab := 'N';
    END IF;
  END sys_debug_privs;
/*****************************   PLSQL_OBJS   ************************/
  PROCEDURE plsql_objs (obj_owner IN VARCHAR2, obj_name IN VARCHAR2,
                obj_type IN VARCHAR2, r_objects IN OUT NUMBER,
                status IN OUT VARCHAR2,
                r_obj_owner OUT varchar2_30_arr, 
                r_obj_name OUT varchar2_30_arr, 
                r_obj_type OUT varchar2_30_arr,
                r_level  OUT number_arr,
                r_remote OUT number_arr,
                syn_owner OUT varchar2_30_arr,
                syn_name OUT varchar2_30_arr) IS
    tmp_cntr NUMBER;
  BEGIN
    root_name := obj_name;
    IF UPPER(obj_type) NOT IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE','FUNCTION')
    THEN
      raise_application_error (-20005, 'Invalid object type');
    END IF;
    IF status = 'NEW'
    THEN
        tot_rows := 0;
        rows_sent := 0;
        last_owner := obj_owner;
        last_name := obj_name;
        get_object_ids (obj_owner, obj_name, obj_type);
-- check if user has privileges
--        IF NOT user_has_debug_any_proc_priv
--        THEN
--          IF NOT debug_privileged(own_id, obj_id)
--          THEN
--            raise_application_error (-20001, 'You do not have privileges on object.');
--          END IF;
--        END IF;
        get_proc_dependencies ( obj_id);
    ELSIF status = 'OLD'
    THEN
      IF last_owner != obj_owner
      THEN
        raise_application_error (-20002, 'Requested more rows but changed the object owner');
       ELSIF  last_owner IS NULL
       THEN
        raise_application_error (-20002, 'Requested more rows but procedure was not used before.');
      ELSIF last_name != obj_name
      THEN 
        raise_application_error (-20003, 'Requested MORE rows but changed the object name');
      END IF;
    ELSE
       raise_application_error (-20004, 'Invalid status value of '||status||'. Valid values are: NEW and OLD.');
    END IF;
-- return rows
    tmp_cntr := 0;
    FOR i IN 1+rows_sent .. LEAST(rows_sent+r_objects,tot_rows) LOOP
      r_obj_owner(tmp_cntr+1) := owner_arr(i);
      r_obj_name(tmp_cntr+1) := name_arr(i);
      r_obj_type(tmp_cntr+1) := type_arr(i);
      r_level(tmp_cntr+1) := level_arr(i);
      r_remote(tmp_cntr+1) := remote_arr(i);
      syn_owner(tmp_cntr+1) := syn_own_arr(i);
      syn_name(tmp_cntr+1) := syn_name_arr(i);
      tmp_cntr := tmp_cntr + 1;
    END LOOP;
-- update counters
    r_objects := tmp_cntr; -- no. rows actually returned on this call
    rows_sent := rows_sent + tmp_cntr;

    status := 'MOR';
    IF rows_sent = tot_rows 
    THEN
      status := 'DON';
    END IF;
  END plsql_objs;

/**********************************  GET_OBJECT_IDS  *********************/

  PROCEDURE get_object_ids (obj_owner IN VARCHAR2, obj_name IN VARCHAR2,
                obj_type IN VARCHAR2) IS
  BEGIN
-- get owner id
    BEGIN
      SELECT user# INTO own_id FROM sys.user$ WHERE name = obj_owner;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error (-20006, 'Invalid object owner.');
    END;
-- get object ID
    BEGIN
      SELECT obj#, type INTO obj_id, type_id
      FROM sys.obj$ WHERE name = obj_name AND owner# = own_id
      AND type = DECODE(obj_type,  'PROCEDURE',7,  'FUNCTION',8, 'PACKAGE',9,
                         'PACKAGE BODY', 11, 'VIEW',4,  'SYNONYM',5, 'SEQUENCE',6, 
                         'TABLE',2 );
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error (-20007, 'Object does not exist.');
    END;
  END get_object_ids;

/*****************************  GET_PROC_DEPENDENCIES  ************************/

  PROCEDURE get_proc_dependencies (obj_id IN NUMBER) IS
    CURSOR get_objs (start_obj_id NUMBER) IS SELECT p_obj#, level 
                                              FROM sys.dependency$
                                              START WITH d_obj# = start_obj_id
                                               CONNECT BY PRIOR  p_obj# = d_obj#;
    tmp_owner  VARCHAR2(30);
    tmp_name    VARCHAR2(30);
    tmp_type      VARCHAR2(30);
    tmp_remote NUMBER;
    base_owner VARCHAR2(30);
    base_name  VARCHAR2(30);
    base_type    VARCHAR2(30);
  BEGIN
    FOR i_rec IN get_objs(obj_id) LOOP
      BEGIN
      SELECT u.name, o.name, decode(linkname,NULL,0,1),
            decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                                          4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
                                          7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                  12, 'TRIGGER', 'UNDEFINED')
      INTO tmp_owner, tmp_name, tmp_remote, tmp_type
      FROM sys.obj$ o, sys.user$ u
      WHERE o.owner# = u.user#
      AND o.obj# = i_rec.p_obj#
      AND o.name != root_name;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        tmp_type := 'UNDEFINED';
      END;
-- don't store UNDEFINED objects because we don't know what the hell they are!
        IF tmp_type != 'UNDEFINED'
        THEN
          IF tmp_type = 'SYNONYM' AND  tmp_remote = 0
          THEN
              translate_synonym (tmp_owner, tmp_name,  base_owner, base_name, base_type, tmp_remote);
              IF base_type IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY', 'VIEW')
              THEN
                  tot_rows := tot_rows + 1;
                  level_arr(tot_rows) := i_rec.level;
                  syn_own_arr(tot_rows) := tmp_owner;
                  syn_name_arr(tot_rows) := tmp_name;
                  owner_arr(tot_rows) := base_owner;
                  name_arr(tot_rows) := base_name;
                  type_arr(tot_rows) := base_type;
                  remote_arr(tot_rows) := tmp_remote;
             END IF;
          ELSIF tmp_type IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY', 'VIEW')
          THEN
               tot_rows := tot_rows + 1;
               level_arr(tot_rows) := i_rec.level;
               owner_arr(tot_rows) := tmp_owner;
               name_arr(tot_rows) := tmp_name;
               type_arr(tot_rows) := tmp_type;
               remote_arr(tot_rows) := tmp_remote;
               syn_own_arr(tot_rows) := NULL;
               syn_name_arr(tot_rows) := NULL;
        END IF;
      END IF;
   dbms_output.put_line('I = '||tot_rows||'     OBJ_ID = '||i_rec.p_obj#);
  END LOOP;

  END get_proc_dependencies;

/*****************************  GET_BROWSER_DEPENDENCIES  ************************/

  PROCEDURE get_browser_dependencies (obj_id IN NUMBER, up_down IN VARCHAR2, n_levels IN NUMBER) IS
    tmp_levels    NUMBER;
    CURSOR get_n_levels_down (tmp_levels NUMBER, start_obj_id NUMBER) IS 
                                              SELECT p_obj#, level 
                                              FROM sys.dependency$
                                              WHERE level <= tmp_levels
                                              START WITH d_obj# = start_obj_id
                                               CONNECT BY PRIOR  p_obj# = d_obj#;
    CURSOR get_n_levels_up (tmp_levels NUMBER, start_obj_id NUMBER) IS 
                                              SELECT d_obj#, level
                                              FROM sys.dependency$
                                              WHERE level <= tmp_levels
                                              START WITH p_obj# = start_obj_id
                                               CONNECT BY PRIOR  d_obj# = p_obj#;
    tmp_owner  VARCHAR2(30);
    tmp_name    VARCHAR2(30);
    tmp_type      VARCHAR2(30);
    tmp_remote NUMBER;
    base_owner VARCHAR2(30);
    base_name  VARCHAR2(30);
    base_type    VARCHAR2(30);
    down BOOLEAN;
    ref_obj NUMBER;
    ref_level NUMBER;
  BEGIN
dbms_output.put_line('UP_DOWN = '||up_down||'  Levels = '||n_levels);

    tmp_levels := n_levels;
    IF n_levels = -1
    THEN
      tmp_levels := 1000;  -- basically requests all levels
    END IF;
    IF up_down = 'DOWN' 
    THEN
      OPEN get_n_levels_down (tmp_levels, obj_id);
      down := TRUE;
    ELSIF up_down = 'UP'
    THEN
      OPEN get_n_levels_up (tmp_levels, obj_id);
      down := FALSE;
    ELSE raise_application_error (-20010, 'Invalid direction: Valid values are UP and DOWN.');
    END IF;

    LOOP
       IF down THEN
         FETCH get_n_levels_down INTO ref_obj, ref_level;
         IF get_n_levels_down%NOTFOUND THEN 
            CLOSE get_n_levels_down;
            RETURN;
          END IF;
      ELSE
         FETCH get_n_levels_up INTO ref_obj, ref_level;
         IF get_n_levels_up%NOTFOUND THEN 
             CLOSE get_n_levels_up;
             RETURN;
         END IF;
      END IF;
      SELECT u.name, o.name, decode(linkname,NULL,0,1),
            decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                                          4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
                                          7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                                       11, 'PACKAGE BODY', 12, 'TRIGGER', 'UNDEFINED')
      INTO tmp_owner, tmp_name, tmp_remote, tmp_type
      FROM sys.obj$ o, sys.user$ u
      WHERE o.owner# = u.user#
      AND o.obj# = ref_obj;
-- don't store UNDEFINED objects because we don't know what the hell they are!
        IF tmp_type != 'UNDEFINED'
        THEN
            tot_rows := tot_rows + 1;
            level_arr(tot_rows) := ref_level;
            owner_arr(tot_rows) := tmp_owner;
            name_arr(tot_rows) := tmp_name;
            type_arr(tot_rows) := tmp_type;
            remote_arr(tot_rows) := tmp_remote;
        END IF;
dbms_output.put_line('I = '||tot_rows||'     OBJ_ID = '||ref_obj);
  END LOOP;

  END get_browser_dependencies;


/********************************* TRANSLATE_SYNONYM  ***********************/

PROCEDURE translate_synonym (syn_owner IN VARCHAR2, syn_name VARCHAR2,  
                                                                 base_owner OUT VARCHAR2, base_name OUT VARCHAR2, 
                                                                 base_type OUT VARCHAR2, base_remote OUT NUMBER) IS
  tmp_owner VARCHAR2(30);
  tmp_name   VARCHAR2(30);
  tmp_type      VARCHAR2(30);
  tmp_remote NUMBER;
BEGIN
  tmp_owner := syn_owner;
  tmp_name := syn_name;
  LOOP
    SELECT table_owner, table_name, decode(db_link,NULL,0,1)
    INTO tmp_owner, tmp_name, tmp_remote
    FROM sys.dba_synonyms
    WHERE owner = tmp_owner
    AND synonym_name = tmp_name;
    IF tmp_remote = 1 -- remote object
    THEN
      base_owner := tmp_owner;
      base_name := tmp_name;
      base_remote := tmp_remote;
      base_type := 'REMOTE';  -- can use DBMS_SQL to query the remote db for real type
      RETURN;
    END IF;
    SELECT  decode(linkname, NULL, 0, 1),
               decode(o.type, 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                                          4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
                                          7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                                         12, 'TRIGGER')
    INTO tmp_remote, tmp_type
    FROM sys.obj$ o, sys.user$ u
    WHERE o.owner# = u.user#
    AND o.name = tmp_name
    AND u.name = tmp_owner
    AND o.type in (1, 2, 3, 4, 5, 6, 7, 8, 9, 12);
    IF tmp_type != 'SYNONYM'
    THEN
       base_owner := tmp_owner;
      base_name := tmp_name;
      base_remote := tmp_remote;
      base_type := tmp_type;
      RETURN;
    END IF;
  END LOOP;
  
END translate_synonym;
/********************************  DEBUG_PRIVILEGED ****************************/

  FUNCTION debug_privileged(own_id IN NUMBER, obj_id IN NUMBER) RETURN BOOLEAN IS
    dummy NUMBER;
  BEGIN
-- is user owner?
    IF own_id = uid
    THEN RETURN TRUE;
    END IF;
  END debug_privileged;

/********************************  VIEW_PROC_PRIVILEGED ****************************/

  FUNCTION view_proc_privileged(own_id IN NUMBER, obj_id IN NUMBER) RETURN BOOLEAN IS
    dummy NUMBER;
  BEGIN
-- is user owner?
    IF own_id = uid
    THEN RETURN TRUE;
    END IF;

-- has object privs

    SELECT count(*) INTO dummy
    FROM sys.objauth$ oa, sys.user$ ue, table_privilege_map tpm
    WHERE  oa.grantee# = ue.user#
    AND oa.col# is null
    AND oa.privilege# = tpm.privilege
    AND (oa.grantor# = uid OR oa.grantee# in (1,uid))
    AND oa.obj# = obj_id
    AND tpm.name = 'EXECUTE';
dbms_output.put_line ('DUMMY = '||dummy);
    IF dummy != 0
    THEN RETURN TRUE;
     END IF;

-- has role object privs


    SELECT count(*) INTO dummy
    FROM  sys.table_privilege_map tpm, sys.objauth$ oa
    WHERE grantee# in
         (SELECT DISTINCT(privilege#)
          FROM sys.sysauth$ sa
          WHERE privilege# > 0
         CONNECT BY PRIOR sa.privilege# = sa.grantee#
         START WITH grantee#=uid OR grantee#=1)
    AND oa.privilege#=tpm.privilege
    AND oa.obj# = obj_id
    AND tpm.name = 'EXECUTE';
    IF dummy != 0
    THEN RETURN TRUE;
     END IF;

    RETURN FALSE;
  
  END view_proc_privileged;

/********************************  SELECT_PRIVILEGED ****************************/

  FUNCTION select_privileged(own_id IN NUMBER, obj_id IN NUMBER) RETURN BOOLEAN IS
    dummy NUMBER;
  BEGIN
-- is user owner?
    IF own_id = uid
    THEN RETURN TRUE;
    END IF;

-- has object privs

    SELECT count(*) INTO dummy
    FROM sys.objauth$ oa, sys.user$ ue, table_privilege_map tpm
    WHERE  oa.grantee# = ue.user#
    AND oa.col# is null
    AND oa.privilege# = tpm.privilege
    AND (oa.grantor# = uid OR oa.grantee# in (1,uid))
    AND oa.obj# = obj_id
    AND tpm.name = 'SELECT';
dbms_output.put_line ('DUMMY = '||dummy);
    IF dummy != 0
    THEN RETURN TRUE;
     END IF;

-- has role object privs


    SELECT count(*) INTO dummy
    FROM  sys.table_privilege_map tpm, sys.objauth$ oa
    WHERE grantee# in
         (SELECT DISTINCT(privilege#)
          FROM sys.sysauth$ sa
          WHERE privilege# > 0
         CONNECT BY PRIOR sa.privilege# = sa.grantee#
         START WITH grantee#=uid OR grantee#=1)
    AND oa.privilege#=tpm.privilege
    AND oa.obj# = obj_id
    AND tpm.name = 'SELECT';
    IF dummy != 0
    THEN RETURN TRUE;
     END IF;

    RETURN FALSE;
  
  END select_privileged;

/******************************   BROWSER_OBJS  *******************************/
  PROCEDURE browser_objs (obj_owner IN VARCHAR2, obj_name IN VARCHAR2,
                obj_type IN VARCHAR2, r_objects IN OUT NUMBER, 
                status IN OUT VARCHAR2,
                r_obj_owner OUT varchar2_30_arr, 
                r_obj_name OUT varchar2_30_arr, 
                r_obj_type OUT varchar2_30_arr,
                r_level  OUT number_arr,
                r_remote OUT number_arr,
                up_down IN VARCHAR2 DEFAULT 'DOWN', ret_levels IN NUMBER DEFAULT -1) IS
    tmp_cntr NUMBER;
    base_owner VARCHAR2(30);
    base_name  VARCHAR2(30);
    base_type    VARCHAR2(30);
    base_remote  NUMBER;
  BEGIN
    IF UPPER(obj_type) NOT IN ('PACKAGE', 'PROCEDURE', 'FUNCTION', 'VIEW', 'SYNONYM', 'SEQUENCE', 'TABLE')
    THEN
      raise_application_error (-20005, 'Invalid object type');
    END IF;
-- translate synonym
    IF UPPER(obj_type) = 'SYNONYM'
    THEN
            translate_synonym (obj_owner, obj_name,  base_owner, base_name, base_type, base_remote);
             owner_arr(1) := base_owner;
             name_arr(1) := base_name;
             type_arr(1) := base_type;
             level_arr(1) := 1;
             remote_arr(1) := base_remote;
     ELSE
            base_owner := obj_owner;
            base_name := obj_name;
            base_type := obj_type;
    END IF;
    IF status = 'NEW'
    THEN
        tot_rows := 0;
        rows_sent := 0;
        last_owner := base_owner;
        last_name := base_name;
        get_object_ids (base_owner, base_name, base_type);
-- check if user has privileges
        IF UPPER(base_type) IN  ('PACKAGE', 'PROCEDURE', 'FUNCTION')
        THEN
            IF NOT user_has_view_any_proc_priv
            THEN
                IF NOT view_proc_privileged(own_id, obj_id)
                THEN
                    raise_application_error (-20001, 'You do not have privileges on object.');
                END IF;
            END IF;
      ELSIF UPPER(base_type) IN  ('TABLE', 'VIEW')
        THEN
            IF NOT user_has_sel_any_table_priv
            THEN
                IF NOT select_privileged(own_id, obj_id)
                THEN
                    raise_application_error (-20001, 'You do not have privileges on object.');
                END IF;
            END IF;
      ELSIF UPPER(base_type) = 'SEQUENCE'
        THEN
            IF NOT user_has_sel_any_seq_priv
            THEN
                IF NOT select_privileged(own_id, obj_id)
                THEN
                    raise_application_error (-20001, 'You do not have privileges on object.');
                END IF;
            END IF;
      END IF;
        get_browser_dependencies ( obj_id, up_down, ret_levels);
    ELSIF status = 'OLD'
    THEN
      IF last_owner != base_owner
      THEN
        raise_application_error (-20002, 'Requested more rows but changed the object owner');
       ELSIF  last_owner IS NULL
       THEN
        raise_application_error (-20002, 'Requested more rows but procedure was not used before.');
      ELSIF last_name != obj_name
      THEN 
        raise_application_error (-20003, 'Requested MORE rows but changed the object name');
      END IF;
    ELSE
       raise_application_error (-20004, 'Invalid status value of '||status||'. Valid values are: NEW and OLD.');
    END IF;
-- return rows
    tmp_cntr := 0;
    FOR i IN 1+rows_sent .. LEAST(rows_sent+r_objects,tot_rows) LOOP
dbms_output.put_line('In loop at i = '||i);
      r_obj_owner(tmp_cntr+1) := owner_arr(i);
      r_obj_name(tmp_cntr+1) := name_arr(i);
      r_obj_type(tmp_cntr+1) := type_arr(i);
      r_level(tmp_cntr+1) := level_arr(i);
      r_remote(tmp_cntr+1) := remote_arr(i);
      tmp_cntr := tmp_cntr + 1;
    END LOOP;
-- update counters
    r_objects := tmp_cntr; -- no. rows actually returned on this call
    rows_sent := rows_sent + tmp_cntr;

    status := 'MOR';
    IF rows_sent = tot_rows 
    THEN
      status := 'DON';
    END IF;
  END browser_objs;

/*
 ************************** INITIALIZATION SECTION ************************
BEGIN -- initialization section
--
--                                                                                         1st Check Sys Privs
--
  user_has_debug_any_proc_priv := FALSE;                                              -- CREATE ANY PROCEDURE
  DECLARE                                                                                                             -- ALTER ANY PROCEDURE
     priv_cnt NUMBER;                                                                                          -- DROP ANY PROCEDURE
  BEGIN
    SELECT count(distinct spm.name)l INTO priv_cnt
    FROM  sys.system_privilege_map spm, sys.sysauth$ sa
    WHERE (sa.grantee#=uid or sa.grantee#=1)
    AND sa.privilege#=spm.privilege
    AND spm.name IN  ('CREATE ANY PROCEDURE','ALTER ANY PROCEDURE','DROP ANY PROCEDURE');
    IF priv_cnt = 3
    THEN
        dbms_output.put_line ('User DOES  have debug sys priv');
         user_has_debug_any_proc_priv := TRUE;
    ELSE
        dbms_output.put_line ('User DOES NOT have debug sys priv');
        user_has_debug_any_proc_priv := FALSE;
    END IF;
  END;
  user_has_view_any_proc_priv := FALSE;                                             -- EXECUTE ANY PROCEDURE
  DECLARE
     priv_cnt NUMBER;
  BEGIN
    SELECT count(distinct spm.name)l INTO priv_cnt
    FROM  sys.system_privilege_map spm, sys.sysauth$ sa
    WHERE (sa.grantee#=uid or sa.grantee#=1)
    AND sa.privilege#=spm.privilege
    AND spm.name = 'EXECUTE ANY PROCEDURE';
    IF priv_cnt = 1
    THEN
        dbms_output.put_line ('User DOES  have view sys priv');
         user_has_view_any_proc_priv := TRUE;
    ELSE
        dbms_output.put_line ('User DOES NOT have view sys priv');
        user_has_view_any_proc_priv := FALSE;
    END IF;
  END;
  user_has_sel_any_seq_priv := FALSE;                                                    -- SELECT ANY SEQUENCE
  DECLARE
     priv_cnt NUMBER;
  BEGIN
    SELECT count(distinct spm.name)l INTO priv_cnt
    FROM  sys.system_privilege_map spm, sys.sysauth$ sa
    WHERE (sa.grantee#=uid or sa.grantee#=1)
    AND sa.privilege#=spm.privilege
    AND spm.name = 'SELECT ANY SEQUENCE';
    IF priv_cnt = 1
    THEN
        dbms_output.put_line ('User DOES  have sel any seq sys priv');
         user_has_sel_any_seq_priv := TRUE;
    ELSE
        dbms_output.put_line ('User DOES NOT have sel any seq sys priv');
        user_has_sel_any_seq_priv := FALSE;
    END IF;
  END;
  user_has_sel_any_table_priv := FALSE;                                                 -- SELECT ANY TABLE
  DECLARE
     priv_cnt NUMBER;
  BEGIN
    SELECT count(distinct spm.name)l INTO priv_cnt
    FROM  sys.system_privilege_map spm, sys.sysauth$ sa
    WHERE (sa.grantee#=uid or sa.grantee#=1)
    AND sa.privilege#=spm.privilege
    AND spm.name = 'SELECT ANY TABLE';
    IF priv_cnt = 1
    THEN
        dbms_output.put_line ('User DOES  have sel any tab sys priv');
         user_has_sel_any_table_priv := TRUE;
    ELSE
        dbms_output.put_line ('User DOES NOT have sel any tab sys priv');
        user_has_sel_any_table_priv := FALSE;
    END IF;
  END;
--
--                                                                                               2nd Check For Role Privs
--
  IF NOT user_has_debug_any_proc_priv   -- performed only if priv not found     CREATE ANY PROCEDURE
  THEN                                                                                                                                           -- ALTER ANY PROCEDURE
    DECLARE                                                                                                                                 -- DROP ANY PROCEDURE
      priv_cnt NUMBER;
    BEGIN
       SELECT count(distinct spm.name) INTO priv_cnt
       FROM sys.system_privilege_map spm, sys.sysauth$ sa
       WHERE grantee# IN
            (SELECT DISTINCT(privilege#)
             FROM sys.sysauth$ sa
             WHERE privilege# > 0
             CONNECT BY PRIOR sa.privilege# = sa.grantee#
             START WITH grantee#=uid or grantee#=1)
       AND sa.privilege#=spm.privilege
       AND spm.name IN  ('CREATE ANY PROCEDURE','ALTER ANY PROCEDURE','DROP ANY PROCEDURE');
      IF priv_cnt = 3
      THEN
           dbms_output.put_line('User has debug sysrole priv');
           user_has_debug_any_proc_priv := TRUE;
      ELSE
          dbms_output.put_line ('User DOES NOT have debug sysrole priv');
          user_has_debug_any_proc_priv := FALSE;
      END IF;
    END;
  END IF;
  IF NOT user_has_view_any_proc_priv   -- performed only if priv not found                           EXECUTE ANY PROCEDURE
  THEN
    DECLARE 
      priv_cnt NUMBER;
    BEGIN
       SELECT count(distinct spm.name) INTO priv_cnt
       FROM sys.system_privilege_map spm, sys.sysauth$ sa
       WHERE grantee# IN
            (SELECT DISTINCT(privilege#)
             FROM sys.sysauth$ sa
             WHERE privilege# > 0
             CONNECT BY PRIOR sa.privilege# = sa.grantee#
             START WITH grantee#=uid or grantee#=1)
       AND sa.privilege#=spm.privilege
       AND spm.name  = 'EXECUTE ANY PROCEDURE';
      IF priv_cnt = 1
      THEN
           dbms_output.put_line('User has view sysrole priv');
           user_has_view_any_proc_priv := TRUE;
      ELSE
          dbms_output.put_line ('User DOES NOT have view sysrole priv');
          user_has_view_any_proc_priv := FALSE;
      END IF;
    END;
  END IF;
  IF NOT user_has_sel_any_seq_priv   -- performed only if priv not found                 SELECT ANY SEQUENCE
  THEN
    DECLARE 
      priv_cnt NUMBER;
    BEGIN
       SELECT count(distinct spm.name) INTO priv_cnt
       FROM sys.system_privilege_map spm, sys.sysauth$ sa
       WHERE grantee# IN
            (SELECT DISTINCT(privilege#)
             FROM sys.sysauth$ sa
             WHERE privilege# > 0
             CONNECT BY PRIOR sa.privilege# = sa.grantee#
             START WITH grantee#=uid or grantee#=1)
       AND sa.privilege#=spm.privilege
       AND spm.name  = 'SELECT ANY SEQUENCE';
      IF priv_cnt = 1
      THEN
           dbms_output.put_line('User has sel any seq sysrole priv');
           user_has_sel_any_seq_priv := TRUE;
      ELSE
          dbms_output.put_line ('User DOES NOT have sel any seq sysrole priv');
          user_has_sel_any_seq_priv := FALSE;
      END IF;
    END;
  END IF;
  IF NOT user_has_sel_any_table_priv   -- performed only if priv not found                 SELECT ANY TABLE
  THEN
    DECLARE 
      priv_cnt NUMBER;
    BEGIN
       SELECT count(distinct spm.name) INTO priv_cnt
       FROM sys.system_privilege_map spm, sys.sysauth$ sa
       WHERE grantee# IN
            (SELECT DISTINCT(privilege#)
             FROM sys.sysauth$ sa
             WHERE privilege# > 0
             CONNECT BY PRIOR sa.privilege# = sa.grantee#
             START WITH grantee#=uid or grantee#=1)
       AND sa.privilege#=spm.privilege
       AND spm.name  = 'SELECT ANY TABLE';
      IF priv_cnt = 1
      THEN
           dbms_output.put_line('User has sel any tab sysrole priv');
           user_has_sel_any_table_priv := TRUE;
      ELSE
          dbms_output.put_line ('User DOES NOT have sel any tab sysrole priv');
          user_has_sel_any_table_priv := FALSE;
      END IF;
    END;
  END IF;
*************************** INITIALIZATION SECTION END *******************************************
*/
END ptsql_depend;
/
grant execute on ptsql_depend to public;

commit;