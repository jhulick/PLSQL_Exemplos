rem 
rem $Header: dbmsmail.sql,v 1.11 1993/04/20 18:38:36 RKOOI Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      dbmsmail.sql - send ora*mail
Rem    DESCRIPTION
Rem
Rem    RETURNS
Rem 
Rem    NOTES
Rem      The procedural option is needed to use this facility.
Rem
Rem      NOTE for Upgrade from versions prior to 7.0.14:
Rem	 	You will need to create the view 'dbms_mail.v$myclientinfo'
Rem		under schema 'sys' as described in step (3) belo.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     rkooi      04/20/93 -  merge changes from branch 1.10.312.1 
Rem     rkooi      04/07/93 -  security improvements 
Rem     rkooi      09/30/92 -  add some comments 
Rem     rkooi      09/02/92 -  change ORU errors 
Rem     rkooi      06/10/92 -  add rae errors 
Rem     rkooi      01/10/92 -  Creation 
rem

create or replace package dbms_mail as

  -----------
  --  OVERVIEW
  --
  --  This package is an interface to the Oracle*Mail product.  You can 
  --  send an Oracle*Mail message by calling the 'send' procedure.  The mail
  --  will be sent when the transaction is committed.  This procedure
  --  can be called from a trigger.  This package will work with Version 1.1
  --  of Oracle*Mail.

  ---------
  --  SETUP
  --
  --  Before creating this package, you must 
  --
  --  1) Run the 'utlmail.sql' script on the mail database (with
  --     Oracle*Mail Version 1.1 installed) as user 'email'. Then create 
  --     a special database account in the mail database,
  --     <mailuser>/<mailpassword>, with connect privilege only:
  --
  --        create user <mailuser> identified by <mailpassword>;
  --        grant connect to <mailuser>;
  --
  --     Then make <mailuser> a valid Oracle*Mail user.
  --
  --  2) Create a database account in the database from which you wish
  --     to send email.  This is so the following database link is not
  --     widely accessible and so that you can control who has access
  --     to this package.  Assume this account is named <localmailacct>.
  --  
  --     Connect to <localmailacct> and create a database link named 
  --     <mailnode> which points to the mail database:
  --
  --        create database link <mailnode> connect to <mailuser> identified by
  --          <mailpassword> using '...';
  --
  --     As mentioned in step (1), <mailuser> must be a valid Oracle*Mail 
  --     user for the mail database AND <mailuser>/<mailpassword> must be 
  --     a valid DATABASE user in the mail database (but should only have 
  --     "connect" permission).
  --
  --     In order for "global naming" to be enabled, the node name must be
  --     the same as the name of the database.  See the DBA Guide for
  --     more information on global naming.  If global naming is
  --     disabled for this database, then the name of the database link 
  --     is not important.
  --
  --  3) In the database from which you wish to send email, create the 
  --     dbms_mail$myclientinfo view:
  --
  --       connect sys/chg_on_install
  --       create or replace view dbms_mail$myclientinfo as
  --         select ' [SENDER=(' ||
  --           substr(osuser || ',' || user || ',' || machine || ',' ||
  --                  program || ',' || terminal || ',' || process, 1, 58)
  --                  || ')]' clientinfo
  --         from v$session where sid =
  --           (select sid from v$mystat where rownum = 1);
  --       grant select on dbms_mail$myclientinfo to <localmailacct>;
  --         
  --  4) Using the database link name chosen in step (2), create the 
  --     following synonyms for use by this package:
  --        create synonym mail_info     for email.s_sender_info@<mailnode>;
  --        create synonym mail_header   for email.s_send_header@<mailnode>;
  --        create synonym mail_instance for email.s_send_instance@<mailnode>;
  --        create synonym mail_body     for email.s_send_body@<mailnode>;
  --        create synonym mail_name     for email.s_user_name@<mailnode>;
  --        create synonym mail_seq      for email.m_id_seq@<mailnode>;
  --
  --  5) Do a "select * from dual@<mailnode>;" to make sure the node is
  --     reachable.
  --
  --  6) Run this script
  --
  --  If your account does not have the privileges to create the public 
  --  synonym at the end of this script then connect as internal or 'sys'
  --  to create the synonym.  If the public synonym is not created then 
  --  the user must invoke the package as
  --       <localmailacct>.dbms_mail.send(...)
  --  rather than
  --       dbms_mail.send(...)
  --  where <localmailacct> is the <user> name chosen above.
  --
  --  If <mailnode> points to a V6 database then you cannot call this
  --  procedure from a trigger since that requires distributed transactions.
  --
  --  The distributed and procedural extensions are required to use this
  --  feature.

  ------------------------
  --  EXAMPLE INSTALLATION
  --
  --  You need to substitute appropriate values wherever you see <>'s.
  --
  --  ***Do this for the mail database***
  --  connect email/<password>
  --  @ora_system:utlmail.sql
  --  connect sys/chg_on_install
  --  grant connect to sp_mailer identified by <mailpassword>;
  --  <also make 'sp_mailer' a valid Oracle*Mail user>
  --
  --  ***Do this for each database from which you want to send mail***
  --  connect <localmailacct>/<password>
  --  create database link maildb connect to sp_mailer identified by
  --    <mailpassword> using '<connect string>';
  --  select * from dual@maildb;
  --  create synonym mail_info     for email.s_sender_info@maildb;
  --  create synonym mail_header   for email.s_send_header@maildb;
  --  create synonym mail_instance for email.s_send_instance@maildb;
  --  create synonym mail_body     for email.s_send_body@maildb;
  --  create synonym mail_name     for email.s_user_name@maildb;
  --  create synonym mail_seq      for email.m_id_seq@maildb;
  --  connect sys/chg_on_install
  --  create or replace view dbms_mail$myclientinfo as
  --    select ' [SENDER=(' ||
  --      substr(osuser || ',' || user || ',' || machine || ',' ||
  --             program || ',' || terminal || ',' || process, 1, 58)
  --             || ')]' clientinfo
  --    from v$session where sid =
  --      (select sid from v$mystat where rownum = 1);
  --  grant select on dbms_mail$myclientinfo to <localmailacct>;
  --  connect <localmailacct>/<password>
  --  @ora_system:dbmsmail.sql
  --  execute dbms_mail.send('test-from', '<to-string>', 'cc-str', 'bcc-str', 
  --    'test subject', '', 'test body');
  --  commit
  --  ***<to-string> should now receive the mail!

  ---------------------------
  --  PROCEDURES AND FUNCTIONS
  --
  procedure send(from_str in varchar2, 
                 to_str in varchar2, 
                 cc in varchar2,
                 bcc in varchar2,
                 subject in varchar2, 
                 reply_to in varchar2, 
                 body in varchar2);
  --  The send procedure sends and Oracle*Mail message to the specified
  --    recipients.  The message is actually sent when the transaction
  --    in which this call is made commits.  Consult the ORA*MAIL product
  --    form information on size limits for the following arguments.
  --  Input parameters:
  --    from_str
  --      This is the alternate name for the sender of this message.  Must
  --      be <= 10 bytes long.  May be null.  Information about the client
  --      process is also included as part of the sender information.
  --    to_str
  --      A comma or space separated list of Oracle*Mail users to send this
  --      message to.
  --    cc
  --      A comma or space separated list of Oracle*Mail users to copy.
  --    bcc
  --      A comma or space separated list of Oracle*Mail users to blind copy.
  --    subject
  --      The subject heading for this message.
  --    reply_to
  --      The reply-to line for this message.
  --    body
  --      The message body, up to 2000 bytes.
  --  Errors raised:
  --    -20000, ORU-10014: user <username> does not have an Oracle*Mail
  --	    account on the mail node.
  --      Cause: The user named in the 'maildb' database link must have
  --        been given an Oracle*Mail account on the mail database.  The 
  --        account need have no privileges other than 'connect'.
  --

end;
/
create or replace package body dbms_mail as
  user_id 	   number;
  user_node	   number;
  msg_node	   number;
  sender_name	   varchar(81);
  name_at_mailnode varchar2(30);
  client_id        varchar2(70);

  procedure send(from_str varchar2, to_str varchar2, cc varchar2, bcc varchar2,
      subject varchar2, reply_to varchar2, body varchar2) is
    order_no    number;
    pos         number;
    bsize       number;
    len         number;
    smallbody   varchar2(240);
    f_str	varchar2(80) := from_str;
  begin
    -- Accurately (as possible) identify the real user based on the actual
    -- client process.  It is easy for dba's to create database accounts
    -- with arbitrary names so don't rely on those.
    f_str := substr(f_str,1,10) || client_id;

    begin
      if user_id IS NULL then
        select sender_name, msg_node, user_id, user_node
          into sender_name, msg_node, user_id, user_node
          from mail_info;
      end if;
    exception when no_data_found then
      raise_application_error(-20000, 'ORU-10014: user "' || name_at_mailnode
         || '" does not have an Oracle*Mail account on the mail node');

    end;

    insert into mail_header (msg_id, msg_node, type, part_type, 
        hdr_flags, sender_id, sender_node, sender_date, reply_to, to_str, 
        cc_str, bcc_str, subject, from_str, sender_name, deferred, 
        inclusion_id, inclusion_node)
      values (mail_seq.nextval, msg_node, 1, 0, 0, user_id, user_node, sysdate,
        reply_to, to_str, cc, bcc, subject, f_str, sender_name, 'N', 0, 0);

    insert into mail_instance (msg_id, msg_node, node_id, msg_owner,
      folder_id, retention_date, unread_flag, flags)
    values (mail_seq.currval, msg_node, user_node, user_id, 2, sysdate,
      'Y', 0);

    order_no := 1;
    pos := 1;
    bsize := length(body);
    while bsize > 0 loop
      if bsize > 240 then 
        len := 240;
      else
        len := bsize;
      end if;
      -- compute substr here because the entire query below is sent
      -- to the remote site, and V6 can't handle longs (body is a long)
      smallbody := substr(body,pos,len);
      insert into mail_body (msg_id, msg_node, part, order_no, msg_line)
        values (mail_seq.currval, msg_node, 0, order_no, smallbody);
      order_no := order_no + 1;
      pos := pos + len;
      bsize := bsize - len;
    end loop;
  end;

begin
  -- for error messages
  select user_name into name_at_mailnode from mail_name;

  -- get client info to more accurately identify who is sending this email
  select clientinfo into client_id
    from sys.dbms_mail$myclientinfo;
end;
/
drop public synonym dbms_mail
/
create public synonym dbms_mail for dbms_mail
/
