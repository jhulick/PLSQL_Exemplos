rem 
rem $Header: exampbld.sql,v 1.1 1992/12/02 16:27:31 GCLOSSMA Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      exampbld.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     gclossma   12/02/92 -  Creation 
set compatibility V6
/
drop table accounts
/
create table accounts(
    account_id  number(4) not null,
    bal         number(11,2))
/
create unique index accounts_index on accounts (account_id)
/
drop table action
/
create table action(
    account_id  number(4) not null,
    oper_type   char(1) not null,
    new_value   number(11,2),
    status      char(45),
    time_tag    date not null)
/
drop table bins
/
create table bins(
    bin_num     number(2) not null,
    part_num    number(4),
    amt_in_bin  number(4))
/
drop table data_table
/
create table data_table(
    exper_num  number(2),
    n1         number(5),
    n2         number(5),
    n3         number(5))
/
drop table emp
/
create table emp(
    empno      number(4) not null,
    ename      char(10),
    job        char(9),
    mgr        number(4),
    hiredate   date,
    sal        number(7,2),
    comm       number(7,2),
    deptno     number(2))
/
drop table inventory
/
create table inventory(
    prod_id     number(5) not null,
    product     char(15),
    quantity    number(5))
/
drop table journal
/
create table journal(
    account_id   number(4) not null,
    action       char(45) not null,
    amount       number(11,2),
    date_tag     date not null)
/
drop table num1_tab
/
create table num1_tab(
    sequence   number(3) not null,
    num        number(4))
/
drop table num2_tab
/
create table num2_tab(
    sequence   number(3) not null,
    num        number(4))
/
drop table purchase_record
/
create table purchase_record(
    mesg        char(45),
    purch_date  date)
/
drop table ratio
/
create table ratio(
    sample_id  number(3) not null,
    ratio      number)
/
drop table result_table
/
create table result_table(
    sample_id  number(3) not null,
    x          number,
    y          number)
/
drop table sum_tab
/
create table sum_tab(
    sequence   number(3) not null,
    sum        number(5))
/
drop table temp
/
create table temp(
    num_col1   number(9,4),
    num_col2   number(9,4),
    char_col   char(55))
/
create or replace package personnel as
    type charArrayTyp is table of varchar2(10)
        index by binary_integer;
    type numArrayTyp is table of float
        index by binary_integer;
    procedure get_employees(
        dept_number in     integer,
        batch_size  in     integer,
        found       in out integer,
        done_fetch  out    integer,
        emp_name    out    charArrayTyp,
        job_title   out    charArrayTyp,
        salary      out    numArrayTyp);
end personnel;
/
create or replace package body personnel as
    cursor get_emp (dept_number integer) is
        select ename, job, sal from emp
            where deptno = dept_number;
    procedure get_employees(
        dept_number in     integer,
        batch_size  in     integer,
        found       in out integer,
        done_fetch  out    integer,
        emp_name    out    charArrayTyp,
        job_title   out    charArrayTyp,
        salary      out    numArrayTyp) is
    begin
        if not get_emp%isopen then
            open get_emp(dept_number);
        end if;
        done_fetch := 0;
        found := 0;
        for i in 1..batch_size loop
            fetch get_emp into emp_name(i),
                    job_title(i), salary(i);
            if get_emp%notfound then
                close get_emp;
                done_fetch := 1;
                exit;
            else
                found := found + 1;
            end if;
        end loop;
    end get_employees;
end personnel;
/
