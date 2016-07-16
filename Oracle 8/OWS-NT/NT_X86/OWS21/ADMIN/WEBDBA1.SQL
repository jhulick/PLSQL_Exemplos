REM Copyright (c) 1995 by Oracle Corporation
REM
REM NAME
REM   webdbademo.sql
REM FUNCTION
REM   Creates the Web*DBA demo tables and constraints.
REM NOTES
REM   Must be run when connected as the Web*DBA owner.
REM
REM MODIFIED
REM   kireland   02/21/96 - Creation

drop table emps cascade constraints;
drop table depts cascade constraints;
drop table suppliers cascade constraints;
drop table items cascade constraints;
drop table orders cascade constraints;
drop table customers cascade constraints;
drop table supplies cascade constraints;
drop table includes cascade constraints;

