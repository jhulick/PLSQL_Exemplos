rem
rem
Rem  Copyright (c) 1995, 1996 by Oracle Corporation. All rights reserved.
Rem    NAME
Rem      objwbkb.sql - database OBJects for the Web Browser Knowledge Base
Rem    DESCRIPTION
Rem
Rem    NOTES
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     mbookman   12/19/95 -  Creation

Rem
Rem NDW_BROWSER_SEQ *** SEQUENCE
Rem
drop sequence ndw_browser_seq;
create sequence ndw_browser_seq;

Rem
Rem NDW__BROWSERS *** TABLE
Rem
drop table ndw__browsers cascade constraints;
create table ndw__browsers
(
   br_id           number,
   http_user_agent varchar2(2000)
);

alter table ndw__browsers
   add constraint ndw__browsers_pk primary key (br_id);

Rem
Rem NDW__BROWSER_ATTRIBUTES *** TABLE
Rem
drop table ndw__browser_attributes;
create table ndw__browser_attributes
(
   br_id  number,
   attrib varchar2(500),
   val    varchar2(500)
);

alter table ndw__browser_attributes
    add constraint ndw__browser_attributes_pk primary key (br_id, attrib);

alter table ndw__browser_attributes
    add constraint ndw__browser_attributes_fk
        foreign key (br_id) references ndw__browsers(br_id);

Rem
Rem NDW_BROWSER_ATTRIBUTES *** VIEW
Rem
create or replace view ndw_browser_attributes as
   select br.http_user_agent USER_AGENT, ba.attrib ATTRIBUTE, ba.val VALUE
      from ndw__browsers br, ndw__browser_attributes ba
   where br.br_id = ba.br_id;
