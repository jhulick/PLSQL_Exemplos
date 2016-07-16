rem 
rem $Header: utlmail.sql,v 1.3 1993/04/20 18:43:03 RKOOI Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      utlmail.sql - upgrade mail database for access from rpc
Rem    DESCRIPTION
Rem      Upgrade the mail database with the appropriate user, views and
Rem      privs so that the dbms_mail pl/sql package can be used to send email.
Rem
Rem	NOTE: Run this script as user "email".
Rem
Rem      The password of the email account of this database need not 
Rem      be divulged.
Rem   
Rem      There needs to be an user in this database (e.g., rmail/rmail)
Rem      so that the package "dbms_mail" can be created.
Rem	 This account should only have "connect" privilege.  This account
Rem	 name and password will need to be given to the installer of the
Rem	 "dbms_mail" package so that they can create appropriate database
Rem	 links.
Rem
Rem      This user also needs to be a valid Oracle*Mail user.  For example,
Rem      create user rmail as follows:
Rem
Rem         create user rmail identified by rmail;
Rem         grant connect to rmail;
Rem
Rem	    <now add rmail as a valid Oracle*Mail user>
Rem	
Rem     NOTE:  If you run this script multiple times, you will get an error
Rem	regarding the creation of the sequence "m_id_seq" since it already
Rem	exists.  This error message is *OK*.  Do NOT drop this sequence 
Rem	once created.  If you do, and recreate it, you will then get 
Rem	DUPLICATE mail ids.
Rem
Rem    RETURNS
Rem 
Rem    NOTES
Rem      
Rem    MODIFIED   (MM/DD/YY)
Rem     rkooi      04/20/93 -  various P3 and P4 bugs (improved comments)
Rem     mmoore     02/05/93 - #(149230) use create user instead of grant 
Rem     glumpkin   10/20/92 -  Renamed from MAILUPGD.SQL 
Rem     rkooi      09/30/92 -  add s_user_name view
Rem     fnazem,rkooi  01/22/92 -  Creation 

Rem ===== S_SENDER_INFO =====

Rem  "s_user_name" is used by the client to determine if it is using an 
Rem  anoymous dblink, or a dblink with name and password.

drop view s_user_name
/
create view s_user_name (user_name) as select user from dual
/
grant select on s_user_name to public
/

drop view s_sender_info
/

Rem  Provide sender information to the remote sending database. 
Rem  This view is also used by the views defined below to ensure that
Rem  sender_id corresponds the the actual sender.

create view s_sender_info (name, sender_name, msg_node, user_id, 
    user_node) as
  select user_name, user_name||'.'||domain_name, node_id+1000000000,
    user_id, user_node
  from email.m_user_info u, email.m_domain d, email.m_cur_node c
  where d.domain_id=c.domain_id and u.domain_id=c.domain_id 
    and user_name=user and ua_node=node_id
/
grant select on s_sender_info to public
/

Rem ====== V_SEND_HEADER, S_SEND_HEADER ======

drop view s_send_header
/
drop view v_send_header
/

Rem  v_send_header enforces various integrity constraints
Rem  s_send_header disallows selects while still allowing the
Rem 	"select */describe" needed for access from remote database

create view v_send_header (msg_id, msg_node, type, part_type, hdr_flags,
    sender_id, sender_node, sender_date, reply_to, to_str, cc_str, bcc_str,
    subject, from_str, sender_name, deferred, inclusion_id, inclusion_node)
  as
  select msg_id, msg_node, type, part_type, hdr_flags, sender_id,
    sender_node, sender_date, reply_to, to_str, cc_str, bcc_str, subject,
    from_str, sender_name, deferred, inclusion_id, inclusion_node
  from email.m_header h
  where type=1 and part_type=0 and hdr_flags=0 and inclusion_id=0
    and inclusion_node=0 and deferred='N' and exists
    (select 1 from email.s_sender_info s
     where s.sender_name=h.sender_name and s.msg_node=h.msg_node
       and s.user_id=h.sender_id and s.user_node=h.sender_node)
  with check option
/
create view s_send_header as select * from v_send_header where 1=0
/
Rem need select in order to be able to insert from remote node
grant select,insert on s_send_header to public
/

Rem ====== V_SEND_BODY, S_SEND_BODY ======

drop view s_send_body
/
drop view v_send_body
/

Rem  v_send_body enforces various integrity constraints
Rem  s_send_body disallows selects while still allowing the
Rem 	"select */describe" needed for access from remote database

create view v_send_body (msg_id, msg_node, part, order_no, msg_line) as
  select msg_id, msg_node, part, order_no, msg_line
  from email.m_body b
  where part=0 and exists
    (select 1
      from email.m_instance i, email.m_header h, email.s_sender_info s
      where h.msg_id=b.msg_id and h.msg_node=b.msg_node
       and i.msg_id=b.msg_id and i.msg_node=b.msg_node and folder_id=2
       and s.user_id=h.sender_id and s.user_node=h.sender_node)
  with check option
/
create view s_send_body as select * from v_send_body where 1=0
/
Rem need select in order to be able to insert from remote node
grant select,insert on s_send_body to public
/

Rem ====== V_SEND_INSTANCE, S_SEND_INSTANCE ======

drop view s_send_instance
/
drop view v_send_instance
/

Rem  v_send_instance enforces various integrity constraints
Rem  s_send_instance disallows selects while still allowing the
Rem 	"select */describe" needed for access from remote database

create view v_send_instance (msg_id, msg_node, node_id, msg_owner,
    folder_id, retention_date, unread_flag, flags) as
  select msg_id, msg_node, node_id, msg_owner, folder_id, retention_date,
    unread_flag, flags
  from email.m_instance i
  where folder_id=2 and unread_flag='Y' and flags=0 and exists
    (select 1 from email.m_header h, email.s_sender_info s
      where h.msg_id=i.msg_id and h.msg_node=i.msg_node
       and s.user_id=h.sender_id and s.user_node=h.sender_node
       and s.user_id=i.msg_owner and s.user_node=i.node_id)
  with check option
/
create view s_send_instance as select * from v_send_instance where 1=0
/
Rem need select in order to be able to insert from remote node
grant select,insert on s_send_instance to public
/

Rem ====== M_ID_SEQ ======

Rem  use sequence to get the mail id.  This is because the updates to 
Rem  this database may be part of a distributed transaction and we don't want
Rem  to lock out other mail senders for the duration of that transaction
Rem  NOTE:  Do NOT drop this sequence once created.  If you do, and
Rem  recreate it, you will then get DUPLICATE mail ids.

create sequence email.m_id_seq start with 10000
/
grant select on email.m_id_seq to public
/
