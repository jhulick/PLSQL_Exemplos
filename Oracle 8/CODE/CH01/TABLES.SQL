REM tables.sql
REM This file will drop and create all of the tables used
REM for the examples in "Oracle8 PL/SQL Programming", by
REM Scott Urman.  Data is inserted into the students,
REM rooms, classes, and registered_students tables.

REM This script can be run from SQL*Plus.


PROMPT student_sequence...
DROP SEQUENCE student_sequence;

CREATE SEQUENCE student_sequence
  START WITH 10000
  INCREMENT BY 1;

PROMPT students table...
DROP TABLE students CASCADE CONSTRAINTS;

CREATE TABLE students (
  id               NUMBER(5) PRIMARY KEY,
  first_name       VARCHAR2(20),
  last_name        VARCHAR2(20),
  major            VARCHAR2(30),
  current_credits  NUMBER(3)
  );

INSERT INTO students (id, first_name, last_name, major, current_credits)
  VALUES (student_sequence.NEXTVAL, 'Scott', 'Smith', 'Computer Science', 0);

INSERT INTO students (id, first_name, last_name, major, current_credits)
  VALUES (student_sequence.NEXTVAL, 'Margaret', 'Mason', 'History', 0);

INSERT INTO students (id, first_name, last_name, major, current_credits)
  VALUES (student_sequence.NEXTVAL, 'Joanne', 'Junebug', 'Computer Science', 0);

INSERT INTO students (id, first_name, last_name, major, current_credits)
  VALUES (student_sequence.NEXTVAL, 'Manish', 'Murgratroid', 'Economics', 0);

INSERT INTO students(id, first_name, last_name, major, current_credits)
  VALUES(student_sequence.NEXTVAL, 'Patrick', 'Poll', 'History', 0);

INSERT INTO students(id, first_name, last_name, major, current_credits)
  VALUES (student_sequence.NEXTVAL, 'Timothy', 'Taller', 'History', 0);

INSERT INTO students(id, first_name, last_name, major, current_credits)
  VALUES (student_sequence.NEXTVAL, 'Barbara', 'Blues', 'Economics', 0);

INSERT INTO students(id, first_name, last_name, major, current_credits)
  VALUES (student_sequence.NEXTVAL, 'David', 'Dinsmore', 'Music', 0);

INSERT INTO students(id, first_name, last_name, major, current_credits)
  VALUES (student_sequence.NEXTVAL, 'Ester', 'Elegant', 'Nutrition', 0);

INSERT INTO students(id, first_name, last_name, major, current_credits)
  VALUES (student_sequence.NEXTVAL, 'Rose', 'Riznit', 'Music', 0);

INSERT INTO STUDENTS(id, first_name, last_name, major, current_credits)
  VALUES (student_sequence.NEXTVAL, 'Rita', 'Razmataz', 'Nutrition', 0);

PROMPT major_stats...
DROP TABLE major_stats;

CREATE TABLE major_stats (
  major          VARCHAR2(30),
  total_credits  NUMBER,
  total_students NUMBER);

PROMPT rooms table...
DROP TABLE rooms CASCADE CONSTRAINTS;

CREATE TABLE rooms (
  room_id          NUMBER(5) PRIMARY KEY,
  building         VARCHAR2(15),
  room_number      NUMBER(4),
  number_seats     NUMBER(4),
  description      VARCHAR2(50)
  );

INSERT INTO rooms (room_id, building, room_number, number_seats, description)
  VALUES (99999, 'Building 7', 310, 1000, 'Large Lecture Hall');

INSERT INTO rooms (room_id, building, room_number, number_seats, description)
  VALUES (99998, 'Building 6', 101, 500, 'Small Lecture Hall');

INSERT INTO rooms (room_id, building, room_number, number_seats, description)
  VALUES (99997, 'Building 6', 150, 50, 'Discussion Room A');

INSERT INTO rooms (room_id, building, room_number, number_seats, description)
  VALUES (99996, 'Building 6', 160, 50, 'Discussion Room B');

INSERT INTO rooms (room_id, building, room_number, number_seats, description)
  VALUES (99995, 'Building 6', 170, 50, 'Discussion Room C');

INSERT INTO rooms (room_id, building, room_number, number_seats, description)
  VALUES (99994, 'Music Building', 100, 10, 'Music Practice Room');

INSERT INTO rooms (room_id, building, room_number, number_seats, description)
  VALUES (99993, 'Music Building', 200, 1000, 'Concert Room');

INSERT INTO rooms (room_id, building, room_number, number_seats, description)
  VALUES (99992, 'Building 7', 300, 75, 'Discussion Room D');

INSERT INTO rooms (room_id, building, room_number, number_seats, description)
  VALUES (99991, 'Building 7', 310, 50, 'Discussion Room E');


PROMPT classes table...
DROP TABLE classes CASCADE CONSTRAINTS;

CREATE TABLE classes (
  department       CHAR(3),
  course           NUMBER(3),
  description      VARCHAR2(2000),
  max_students     NUMBER(3),
  current_students NUMBER(3),
  num_credits      NUMBER(1),
  room_id          NUMBER(5),
  CONSTRAINT classes_department_course
    PRIMARY KEY (department, course),
  CONSTRAINT classes_room_id
    FOREIGN KEY (room_id) REFERENCES rooms (room_id)
  );

INSERT INTO classes(department, course, description, max_students,
                     current_students, num_credits, room_id)
  VALUES ('HIS', 101, 'History 101', 30, 0, 4, 99999);

INSERT INTO classes(department, course, description, max_students,
                     current_students, num_credits, room_id)
  VALUES ('HIS', 301, 'History 301', 30, 0, 4, 99995);

INSERT INTO classes(department, course, description, max_students,
                     current_students, num_credits, room_id)
  VALUES ('CS', 101, 'Computer Science 101', 50, 0, 4, 99998);

INSERT INTO classes(department, course, description, max_students,
                     current_students, num_credits, room_id)
  VALUES ('ECN', 203, 'Economics 203', 15, 0, 3, 99997);

INSERT INTO classes(department, course, description, max_students,
                     current_students, num_credits, room_id)
  VALUES ('CS', 102, 'Computer Science 102', 35, 0, 4, 99996);

INSERT INTO classes(department, course, description, max_students,
                     current_students, num_credits, room_id)
  VALUES ('MUS', 410, 'Music 410', 5, 0, 3, 99994);

INSERT INTO classes(department, course, description, max_students,
                     current_students, num_credits, room_id)
  VALUES ('ECN', 101, 'Economics 101', 50, 0, 4, 99992);

INSERT INTO classes(department, course, description, max_students,
                     current_students, num_credits, room_id)
  VALUES ('NUT', 307, 'Nutrition 307', 20, 0, 4, 99991);

PROMPT registered_students table...
DROP TABLE registered_students CASCADE CONSTRAINTS;

CREATE TABLE registered_students (
  student_id NUMBER(5) NOT NULL,
  department CHAR(3)   NOT NULL,
  course     NUMBER(3) NOT NULL,
  grade      CHAR(1),
  CONSTRAINT rs_grade
    CHECK (grade IN ('A', 'B', 'C', 'D', 'E')),
  CONSTRAINT rs_student_id
    FOREIGN KEY (student_id) REFERENCES students (id),
  CONSTRAINT rs_department_course
    FOREIGN KEY (department, course)
    REFERENCES classes (department, course)
  );

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10000, 'CS', 102, 'A');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10002, 'CS', 102, 'B');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10003, 'CS', 102, 'C');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10000, 'HIS', 101, 'A');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10001, 'HIS', 101, 'B');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10002, 'HIS', 101, 'B');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10003, 'HIS', 101, 'A');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10004, 'HIS', 101, 'C');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10005, 'HIS', 101, 'C');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10006, 'HIS', 101, 'E');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10007, 'HIS', 101, 'B');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10008, 'HIS', 101, 'A');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10009, 'HIS', 101, 'D');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10010, 'HIS', 101, 'A');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10008, 'NUT', 307, 'A');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10010, 'NUT', 307, 'A');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10009, 'MUS', 410, 'B');

INSERT INTO registered_students (student_id, department, course, grade)
  VALUES (10006, 'MUS', 410, 'E');

PROMPT RS_audit...
DROP TABLE RS_audit;

CREATE TABLE RS_audit (
  change_type    CHAR(1)     NOT NULL,
  changed_by     VARCHAR2(8) NOT NULL,
  timestamp      DATE        NOT NULL,
  old_student_id NUMBER(5),
  old_department CHAR(3),
  old_course     NUMBER(3),
  old_grade      CHAR(1),
  new_student_id NUMBER(5),
  new_department CHAR(3),
  new_course     NUMBER(3),
  new_grade      CHAR(1)
  );

PROMPT log_table...
DROP TABLE log_table;

CREATE TABLE log_table (
  code             NUMBER,
  message          VARCHAR2(200),
  info             VARCHAR2(100)
  );

PROMPT temp_table...
DROP TABLE temp_table;

CREATE TABLE temp_table (
  num_col    NUMBER,
  char_col   VARCHAR2(60)
  );

PROMPT debug_table...
DROP TABLE debug_table;

CREATE TABLE debug_table (
  linecount  NUMBER,
  debug_str  VARCHAR2(100)
  );

PROMPT exception_table...
DROP TABLE exception_table;

CREATE TABLE exception_table (
  exception      VARCHAR2(20),
  date_occurred  DATE);

PROMPT exception_view...
DROP VIEW exception_view;

CREATE VIEW exception_view AS
  SELECT exception  exception_description,
         date_occurred
    FROM exception_table;

PROMPT source...
DROP TABLE source;

CREATE TABLE source (
  key NUMBER(5),
  value VARCHAR2(50)
  );

PROMPT destination...
DROP TABLE destination;

CREATE TABLE destination (
  key NUMBER(5),
  value NUMBER
  );
