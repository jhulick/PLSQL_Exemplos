Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved.
Rem    NAME
Rem      employee.sql
Rem    DESCRIPTION
Rem      demo for PL/SQL access in Java
Rem    RETURNS
Rem 
Rem    NOTES
Rem      
Rem    MODIFIED   (MM/DD/YY)
Rem     rpang      02/11/96 -  Creation 

PROMPT Create employee table EMP

DROP TABLE EMP
/

CREATE TABLE EMP (
  emp_name	VARCHAR2(30),
  emp_number	NUMBER(10),
  emp_dept	VARCHAR2(30)
)
/

PROMPT Populate employee table

insert into EMP values ('Mary Smith', 1001, 'HR')
/
insert into EMP values ('James Green', 1002, 'HR')
/
insert into EMP values ('Susan Moore', 1003, 'HR')
/
insert into EMP values ('Thomas Bird', NULL, 'HR')
/
insert into EMP values ('Robin Preston', 1004, 'Sales')
/
insert into EMP values ('David Jones', 1005, 'Sales')
/
insert into EMP values ('Tom Lee', 1006, 'Recruiting')
/
insert into EMP values ('Rosemary Turner', 1007, 'Recruiting')
/
insert into EMP values ('John Steel', 1008, 'Sales')
/

PROMPT Create Employee package

CREATE OR REPLACE package Employee as

  type string_table is table of varchar2(30) index by binary_integer;
  type number_table is table of number(10) index by binary_integer;

  function count_employees(
    dept_name	in	varchar2
  ) return number;

  procedure list_employees(
    dept_name		in	varchar2,
    employee_name	out	string_table,
    employee_no		out	number_table
  );

end;
/

CREATE OR REPLACE package body Employee as

  function count_employees(
    dept_name	in	varchar2
  ) return number as
    employee_count	number;
  begin

    select count(*)
    into   employee_count
    from   EMP
    where  EMP_DEPT = dept_name;

    return employee_count;

  end;

  procedure list_employees(
    dept_name		in	varchar2,
    employee_name	out	string_table,
    employee_no		out	number_table
  ) as
    i	number;
    cursor employee_rec(dept_name varchar2) is
    select EMP_NAME, EMP_NUMBER
    from   EMP
    where  EMP_DEPT = dept_name;
  begin

    i := 1;
    for employee in employee_rec(dept_name) loop
      employee_name(i) := employee.EMP_NAME;
      employee_no(i)   := employee.EMP_NUMBER;
      i := i + 1;
    end loop;
    
  end;

end;
/

exit
