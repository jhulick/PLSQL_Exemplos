Rem  Copyright (c) 1996 by Oracle Corp.  All Rights Reserved.
Rem
Rem   NAME
Rem     dbpkdins.sql - DataBase PacKage De-INStall
Rem   PURPOSE
Rem     Drop the database package installed with pl2java.
Rem   NOTES
Rem
Rem     This script should be run by SYS user.
Rem   HISTORY
Rem     rpang     03/25/96 -  Creation
Rem

drop package dbms_package;
drop public synonym dbms_package;

exit
