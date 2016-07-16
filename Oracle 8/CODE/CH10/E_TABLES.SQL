REM e_tables.sql
REM Version 1.0, last updated 4/8/97
REM This file creates the tables for the "PL/SQL at Work" example in
REM Chapter 10 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DROP TABLE errors CASCADE CONSTRAINTS;

CREATE TABLE errors (
  module       VARCHAR2(50),
  seq_number   NUMBER,
  error_number NUMBER,
  error_mesg   VARCHAR2(100),
  error_stack  VARCHAR2(2000),
  call_stack   VARCHAR2(2000),
  timestamp    DATE,
  PRIMARY KEY (module, seq_number));

DROP TABLE call_stacks;

CREATE TABLE call_stacks (
  module        VARCHAR2(50),
  seq_number    NUMBER,
  call_order    NUMBER,
  object_handle VARCHAR2(10),
  line_num      NUMBER,
  object_name   VARCHAR2(80),
  PRIMARY KEY (module, seq_number, call_order),
  FOREIGN KEY (module, seq_number) REFERENCES errors ON DELETE CASCADE);

DROP TABLE error_stacks;

CREATE TABLE error_stacks (
  module        VARCHAR2(50),
  seq_number    NUMBER,
  error_order   NUMBER,
  facility      CHAR(3),
  error_number  NUMBER(5),
  error_mesg    VARCHAR2(100),
  PRIMARY KEY (module, seq_number, error_order),
  FOREIGN KEY (module, seq_number) REFERENCES errors ON DELETE CASCADE);

DROP SEQUENCE error_seq;

CREATE SEQUENCE error_seq
  START WITH 1
  INCREMENT BY 1;
