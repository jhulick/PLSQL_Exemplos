rem 
rem $Header: cat70101.sql,v 1.1 1993/08/09 20:27:37 rjenkins Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      cat70101.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      Upgrade script from 7.0 to 7.1
Rem    RETURNS
Rem 
Rem    NOTES
Rem      You must connect internal to run this script
Rem    MODIFIED   (MM/DD/YY)
Rem     rjenkins   08/09/93 -  Creation
alter table snap$ add (
  refgroup        number,                    /* group for consistent refresh */
  ustrg           varchar2(30),           /* trigger for updatable snapshots */
  uslog           varchar2(30),               /* log for updatable snapshots */
  field1          number,                                  /* for future use */
  field2          varchar2(30),                            /* for future use */
  flag            number                      /* 0x01, can use master log    */
                                              /* 0x02, snapshot is updatable */
)
/
update snap$ set flag = 0 where flag is null
/
update snap$ set flag = 1 where can_use_log is not null
/
