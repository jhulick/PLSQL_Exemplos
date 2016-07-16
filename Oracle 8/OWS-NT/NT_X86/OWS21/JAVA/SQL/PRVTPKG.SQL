Rem
Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved.
Rem    NAME
Rem      prvtpkg.sql - describe server-side packages
Rem    DESCRIPTION
Rem      These are private functions of DBMS_PACKAGE.
Rem
Rem      Given a stored package, list the procedures defined in the package.
Rem      Given a procedure, return a description of the arguments required
Rem      to call that procedure.
Rem    RETURNS
Rem 
Rem    NOTES
Rem      1. The procedural option is needed to use this facility.
Rem      2. This package is derived from dbms_describe package.
Rem      3. This package should be created by user SYS.
Rem      4. Use dbpkins.sql and dbpkdins.sql to install and deinstall
Rem         this package.
Rem    MODIFIED   (MM/DD/YY)
Rem     rpang      01/27/96 -  Creation

REM ********************************************************************
REM THIS PACKAGE MUST NOT BE MODIFIED BY THE CUSTOMER.  DOING SO
REM COULD CAUSE INTERNAL ERRORS AND SECURITY VIOLATIONS IN THE
REM RDBMS.  SPECIFICALLY, THE PSD* ROUTINES MUST NOT BE CALLED
REM DIRECTLY BY ANY CLIENT AND MUST REMAIN PRIVATE TO THE PACKAGE BODY.
REM ********************************************************************

create or replace package body dbms_package is 

    -------------------------------------------------------------------------
    function count_procedures (
	package_name	in	varchar2
    ) return number is
      cursor get_package_proc_names(package_name varchar2) is
	select distinct a.procedure$, a.OVERLOAD#
	from   sys.obj$ o, sys.argument$ a, sys.dual
	where  (o.obj#   = a.obj#) and
	       (o.type   = 9 /* PACKAGE */) and
	       (o.owner# = uid) and
	       (o.name   = package_name);
      cursor get_procedure_names is
	select distinct o.name, a.OVERLOAD#
	from   sys.obj$ o, sys.argument$ a, sys.dual
	where  (o.obj# = a.obj#) and
	       (o.type in (7 /* PROCEDURE */, 8 /* FUNCTION */)) and
	       (o.owner# = uid);
      package_count	number;
      procedure_count	number;
      procedure_name	argument$.procedure$%TYPE;
      overload_number	argument$.overload#%TYPE;
    begin

      if (package_name is not NULL) then

	-- make sure the package exists
	select count(*)
	into   package_count
	from   obj$ o, sys.dual
	where  (o.owner# = uid) and
	       (o.type   = 9 /* PACKAGE */) and
	       (o.name   = upper(package_name));

	if (package_count = 0) then
	  raise_application_error(-20001, 'package ' || upper(package_name) ||
	    ' does not exist');
	end if;

	-- count no. of procedures and functions in package
	open get_package_proc_names(upper(package_name));
	loop
	  fetch get_package_proc_names into  procedure_name, overload_number;
	  exit when get_package_proc_names%NOTFOUND;
	end loop;
	procedure_count :=
	  get_package_proc_names%ROWCOUNT;
	close get_package_proc_names;

      else

	-- count no. of standalone procedures and functions
	open get_procedure_names;
	loop
	  fetch get_procedure_names into  procedure_name, overload_number;
	  exit when get_procedure_names%NOTFOUND;
	end loop;
	procedure_count :=
	  get_procedure_names%ROWCOUNT;
	close get_procedure_names;

      end if;

      return procedure_count;

    end count_procedures;

    -------------------------------------------------------------------------
    procedure list_procedures(
	package_name		in	varchar2,
	procedure_count		out	number,
	procedure_names		out	varchar2_table,
	overload_numbers	out	number_table
    ) is

      cursor get_package_proc_names(package_name varchar2) is
	select distinct a.procedure$, a.OVERLOAD#
	from   sys.obj$ o, sys.argument$ a, sys.dual
	where  (o.obj#   = a.obj#) and
	       (o.type   = 9 /* PACKAGE */) and
	       (o.owner# = uid) and
	       (o.name   = package_name);
      cursor get_procedure_names is
	select distinct o.name, a.OVERLOAD#
	from   sys.obj$ o, sys.argument$ a, sys.dual
	where  (o.obj# = a.obj#) and
	       (o.type in (7 /* PROCEDURE */, 8 /* FUNCTION */)) and
	       (o.owner# = uid);

      package_count	number;
      i			integer := 0;
    begin


      if (package_name is not NULL) then

	-- make sure the package exists
	select count(*)
	into   package_count
	from   obj$ o, sys.dual
	where  (o.owner# = uid) and
	       (o.type   = 9 /* PACKAGE */) and
	       (o.name   = upper(package_name));

	if (package_count = 0) then
	  raise_application_error(-20001, 'package ' || upper(package_name) ||
	    ' does not exist');
	end if;

	-- list procedures and functions in package
	for proc_rec in get_package_proc_names(upper(package_name)) loop
	  i := i + 1;
	  procedure_names(i)  := proc_rec.procedure$;
	  overload_numbers(i) := proc_rec.overload#;
	end loop;

      else

	-- list standalone procedures and functions

	for proc_rec in get_procedure_names loop
	  i := i + 1;
	  procedure_names(i)  := proc_rec.name;
	  overload_numbers(i) := proc_rec.overload#;
	end loop;

      end if;

      procedure_count := i;

    end list_procedures;

    -------------------------------------------------------------------------
    function count_arguments (
	package_name	in	varchar2,
	procedure_name	in	varchar2,
	overload_number	in	number
    ) return number is

      argument_count	number;
      i			binary_integer := 0;

    begin 
        
      if (package_name is NULL) then
          
        -- count the procedure's arguments 
        select count(*)
	into   argument_count
        from   obj$ o, argument$ a, dual
        where (o.owner# = uid) and
	      (o.type in (7 /* PROCEDURE */, 8 /* FUNCTION */)) and
	      (o.name = upper(procedure_name)) and
	      (o.obj# = a.obj#) and
	      (a.overload# = overload_number);
      else 
        -- count the procedure's arguments 
        select count(*)
	into   argument_count
        from   obj$ o, argument$ a, dual
        where (o.owner# = uid) and
	      (o.type = 9 /* PACKAGE */) and
	      (o.name = upper(package_name)) and
	      (a.procedure$ = upper(procedure_name)) and
	      (o.obj# = a.obj#) and
	      (a.overload# = overload_number);
      end if;

      return argument_count;

    end count_arguments;

    -------------------------------------------------------------------------
    procedure describe_procedure (package_name in varchar2,
	procedure_name in varchar2, overload_number in number,
        argument_count out number, position out number_table,
        level out number_table, argument_name out varchar2_table,
        datatype out number_table, default_value out number_table,
        in_out out number_table, length out number_table,
        precision out number_table, scale out number_table,
        radix out number_table, spare out number_table) is

      cursor get_procedure_args(proc_name	varchar2,
				overload_number	binary_integer) is
        select argument, position, a.type,
               nvl(default#,0) default#, nvl(in_out,0) in_out,
               nvl(level#,0) level#, nvl(length,0) length, 
               nvl(precision,0) precision, nvl(scale,0) scale, 
               nvl(radix,0) radix
        from obj$ o, argument$ a, dual
        where (o.owner# = uid) and
	      (o.type in (7 /* PROCEDURE */, 8 /* FUNCTION */)) and
	      (o.name = proc_name) and
	      (o.obj# = a.obj#) and
	      (a.overload# = overload_number)
        order by procedure$,sequence#;

      cursor get_package_args(package_name	varchar2,
			      proc_name		varchar2,
			      overload_number	binary_integer) is 
        select argument, position, a.type,
               nvl(default#,0) default#, nvl(in_out,0) in_out,
               nvl(level#,0) level#, nvl(length,0) length, 
               nvl(precision,0) precision, nvl(scale,0) scale, 
               nvl(radix,0) radix
        from obj$ o, argument$ a, dual
        where (o.owner# = uid) and
	      (o.type = 9 /* PACKAGE */) and
	      (o.name = package_name) and
	      (a.procedure$ = proc_name) and
	      (o.obj# = a.obj#) and
	      (a.overload# = overload_number)
        order by procedure$,sequence#;

      i      binary_integer := 0;
      
    begin 
        
      if (package_name is NULL) then
          
        -- load the procedure's arguments 
        for tab_rec in get_procedure_args(upper(procedure_name),
					  overload_number) loop
          i := i + 1;
          argument_name(i) := tab_rec.argument;
          position(i)      := tab_rec.position;
          /* program interface does not support type 29 (SB4) yet so
             don't give impression that it does, map to DTYINT instead.
             We can get rid of this mapping later when the program
             interface is enhanced.  For compatibility, this mapping
             could be controlled by the future use of one of the
             'reserved' argments */
          if tab_rec.type = 29 then     -- internal sb4
            datatype(i)    := 3;        -- external native int
          elsif tab_rec.type = 69 then  -- internal rowid
            datatype(i)    := 11;       -- external rowid
          else
            datatype(i)    := tab_rec.type;
          end if;
          default_value(i) := tab_rec.default#;
          level(i)         := tab_rec.level#;
          in_out(i)        := tab_rec.in_out;
          length(i)        := tab_rec.length;
          precision(i)     := tab_rec.precision;
          scale(i)         := tab_rec.scale;
          radix(i)         := tab_rec.radix;
          spare(i)         := 0;
        end loop;
      else 

        -- get the procedure's arguments from within the package
        for tab_rec in get_package_args(upper(package_name),
					upper(procedure_name),
					overload_number) loop
          i := i + 1;
          argument_name(i) := tab_rec.argument;
          position(i)      := tab_rec.position;
          /* see comment above */
          if tab_rec.type = 29 then    -- internal sb4
            datatype(i)    := 3;       -- external native int
          elsif tab_rec.type = 69 then -- internal rowid
            datatype(i)    := 11;      -- external rowid
          else
            datatype(i)    := tab_rec.type;
          end if;
          default_value(i) := tab_rec.default#;
          in_out(i)        := tab_rec.in_out;
          level(i)         := tab_rec.level#;
          length(i)        := tab_rec.length;
          precision(i)     := tab_rec.precision;
          scale(i)         := tab_rec.scale;
          radix(i)         := tab_rec.radix;
          spare(i)         := 0;
        end loop;

        -- if no rows returned then the package did not have the procedure
        if i = 0 then
          raise_application_error(-20002, 
            'procedure ' || procedure_name || '(overload number ' ||
	    overload_number || ') within package ' || package_name ||
	    ' does not exist');
        end if;
      end if;

      argument_count := i;

    end describe_procedure;
 
end dbms_package;
/
