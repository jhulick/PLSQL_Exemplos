rem
rem  $Header: pupbld.sql 3020101.1 94/09/28 17:47:13 jathomps Generic<base> $
rem  Copyright (c) Oracle Corporation 1988, 1994.  All Rights Reserved.
rem
rem  +---------------------------------------------------------------------+
rem  |  PUPBLD.SQL -- CREATE PRODUCT AND USER PROFILE TABLES               |
rem  |                                                                     |
rem  |  Connect as SYSTEM before running this script                       |
rem  |                                                                     |
rem  |  This script is used by the DBA to create the product_profile and   |
rem  |  user_profile tables in the SYSTEM account.                         |
rem  |  There are two views, product_privs and user_privs, which are what  |
rem  |  a user will see as product_profile and user_profile.  They allow   |
rem  |  the user to see (and in the case of user_profile, modify) only     |
rem  |  their own privileges or profiles.                                  |
rem  +---------------------------------------------------------------------+

rem  +---------------------------------------------------------------+
rem  |  If PRODUCT_USER_PROFILE existed, use its values and drop it  |
rem  +---------------------------------------------------------------+

drop synonym product_user_profile;

create table product_profile as
  select product, userid, attribute, scope, numeric_value, char_value,
  date_value from product_user_profile;

drop table product_user_profile;

alter table product_profile add (long_value long);

rem  +---------------------------------------+
rem  |  Create PRODUCT_PROFILE from scratch  |
rem  +---------------------------------------+

create table product_profile
(
  product        varchar2 (30) not null,
  userid         varchar2 (30),
  attribute      varchar2 (240),
  scope          varchar2 (240),
  numeric_value  decimal (15,2),
  char_value     varchar2 (240),
  date_value     date,
  long_value     long
);

rem  +----------------------------------------------------------+
rem  |  Create the view PRODUCT_PRIVS and grant access to that  |
rem  +----------------------------------------------------------+

create view product_privs as
  select product, userid, attribute, scope,
         numeric_value, char_value, date_value, long_value
  from product_profile
  where userid = 'PUBLIC' or user like userid;

grant select on product_privs to public;
create public synonym product_profile for system.product_privs;
create synonym product_user_profile for system.product_profile;
create public synonym product_user_profile for system.product_privs;

rem  +---------------------------------+
rem  |  Create the table USER_PROFILE  |
rem  +---------------------------------+

create table user_profile
(
  product        varchar2 (30),
  userid         varchar2 (30),
  profile        varchar2 (240),
  attribute      varchar2 (240),
  numeric_value  decimal (15,2),
  char_value     varchar2 (240),
  date_value     date,
  long_value     long
);

grant select on user_profile to public;

rem  +-------------------------------------------------------+
rem  |  Create the view USER_PRIVS and grant access to that  |
rem  +-------------------------------------------------------+

create view user_privs as
  select product, userid, profile, attribute,
         numeric_value, char_value, date_value, long_value
  from user_profile
  where userid = user
  with check option;

grant select, update, insert, delete on user_privs to public;
create public synonym user_profile for system.user_privs;

rem  +-------------------------------------------------------------+
rem  |  Update the one SRW attribute in the PRODUCT_PROFILE table  |
rem  +-------------------------------------------------------------+

update system.product_profile set attribute = 'PAGE_LIMIT'
  where product = 'SQL*ReportWriter' and attribute = 'LIMIT';

rem  +--------------------+
rem  |  End of pupbld.sql |
rem  +--------------------+
