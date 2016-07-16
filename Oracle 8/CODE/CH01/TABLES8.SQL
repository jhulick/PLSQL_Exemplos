REM tables8.sql
REM Version 1.0, last updated 4/27/97
REM This script will drop and recreate the tables used in the Oracle8
REM chapters of _Oracle8 PL/SQL Programming_ by Scott Urman.  It will only
REM work on an Oracle8 database, not Oracle7.

PROMPT Dropping tables...
DROP TABLE classes CASCADE CONSTRAINTS;

DROP TABLE rooms CASCADE CONSTRAINTS;

DROP TABLE students CASCADE CONSTRAINTS;

DROP TABLE course_material CASCADE CONSTRAINTS;

DROP TABLE checked_out;

DROP TABLE lobdemo;

DROP TABLE lobdemo2;

PROMPT Dropping types...

DROP TYPE StudentObj FORCE;

DROP TYPE ClassObj FORCE;

DROP TYPE RoomObj FORCE;

DROP TYPE BookList FORCE;

DROP TYPE BookList2 FORCE;

DROP TYPE BookObj FORCE;

PROMPT Type RoomObj...
CREATE OR REPLACE TYPE RoomObj AS OBJECT (
  ID           NUMBER(5),
  building     VARCHAR2(15),
  room_number  NUMBER(4),
  number_seats NUMBER(4),
  description  VARCHAR2(50),
  MEMBER PROCEDURE Print,
  MAP MEMBER FUNCTION ReturnID RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY RoomObj AS
  MEMBER PROCEDURE Print IS
  BEGIN
    DBMS_OUTPUT.PUT('Room ID:' || ID || ' is located in ');
    DBMS_OUTPUT.PUT(building || ', room ' || room_number);
    DBMS_OUTPUT.PUT(', and has ' || number_seats || ' seats.');
    DBMS_OUTPUT.NEW_LINE;
  END Print;

  MAP MEMBER FUNCTION ReturnID RETURN NUMBER IS
  BEGIN
    RETURN SELF.ID;
  END ReturnID;
END;
/

PROMPT Type ClassObj...
CREATE OR REPLACE TYPE ClassObj AS OBJECT (
  department       CHAR(3),
  course           NUMBER(3),
  description      VARCHAR2(2000),
  max_students     NUMBER(3),
  current_students NUMBER(3),
  num_credits      NUMBER(1),
  room             REF RoomObj
);
/

PROMPT Type StudentObj...
CREATE OR REPLACE TYPE StudentObj AS OBJECT (
  ID               NUMBER(5),
  first_name       VARCHAR2(20),
  last_name        VARCHAR2(20),
  major            VARCHAR2(30),
  current_credits  NUMBER(3),

  -- Returns the first and last names, separated by a space.
  MEMBER FUNCTION FormattedName
    RETURN VARCHAR2,
  PRAGMA RESTRICT_REFERENCES(FormattedName, RNDS, WNDS, RNPS, WNPS),

  -- Updates the major to the specified value in p_NewMajor.
  MEMBER PROCEDURE ChangeMajor(p_NewMajor IN VARCHAR2),
  PRAGMA RESTRICT_REFERENCES(ChangeMajor, RNDS, WNDS, RNPS, WNPS),

  -- Updates the current_credits by adding the number of
  -- credits in p_CompletedClass to the current value.
  MEMBER PROCEDURE UpdateCredits(p_CompletedClass IN ClassObj),
  PRAGMA RESTRICT_REFERENCES(UpdateCredits, RNDS, WNDS, RNPS, WNPS),

  -- ORDER function used to sort students.
  ORDER MEMBER FUNCTION CompareStudent(p_Student IN StudentObj)
    RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY StudentObj AS
  MEMBER FUNCTION FormattedName
    RETURN VARCHAR2 IS
  BEGIN
    RETURN SELF.first_name || ' ' || SELF.last_name;
  END FormattedName;

  MEMBER PROCEDURE ChangeMajor(p_NewMajor IN VARCHAR2) IS
  BEGIN
    major := p_NewMajor;
  END ChangeMajor;

  MEMBER PROCEDURE UpdateCredits(p_CompletedClass IN ClassObj) IS
  BEGIN
    current_credits := current_credits + p_CompletedClass.num_credits;
  END UpdateCredits;

  ORDER MEMBER FUNCTION CompareStudent(p_Student IN StudentObj)
    RETURN NUMBER IS
  BEGIN
    IF p_Student.last_name = SELF.last_name THEN
      IF p_Student.first_name < SELF.first_name THEN
        RETURN 1;
      ELSIF p_Student.first_name > SELF.first_name THEN
        RETURN -1;
      ELSE
        RETURN 0;
      END IF;
    ELSE
      IF p_Student.last_name < SELF.last_name THEN
        RETURN 1;
      ELSIF p_Student.last_name > SELF.last_name THEN
        RETURN -1;
      ELSE
        RETURN 0;
      END IF;
    END IF;
  END CompareStudent;
END;
/

PROMPT Type AddressObj...
CREATE OR REPLACE TYPE AddressObj AS OBJECT (
  line1    VARCHAR2(40),
  line2    VARCHAR2(40),
  city     VARCHAR2(30),
  state    CHAR(2),
  zipcode  NUMBER(5)
);
/

PROMPT student_sequence...
DROP SEQUENCE student_sequence;

CREATE SEQUENCE student_sequence
  START WITH 10000
  INCREMENT BY 1;

PROMPT students table...

CREATE TABLE students (
  student StudentObj,
  address AddressObj
);

INSERT INTO students VALUES
  (StudentObj(student_sequence.NEXTVAL, 'Scott', 'Smith',
              'Computer Science', 0),
   AddressObj('100 Main St', NULL, 'East Brunswick', 'CA', 91234));

INSERT INTO students VALUES
  (StudentObj(student_sequence.NEXTVAL, 'Margaret', 'Mason',
             'History', 0),
   AddressObj('350 Sorority Row', 'Apt# 2B', 'East Brunswick', 'CA', 91234));

INSERT INTO students VALUES
  (StudentObj(student_sequence.NEXTVAL, 'Joanne', 'Junebug',
              'Computer Science', 0),
   NULL);

INSERT INTO students VALUES
  (StudentObj(student_sequence.NEXTVAL, 'Manish', 'Murgratroid',
              'Economics', 0),
   NULL);

INSERT INTO students VALUES
  (StudentObj(student_sequence.NEXTVAL, 'Patrick', 'Poll',
              'History', 0),
   NULL);

INSERT INTO students VALUES
  (StudentObj(student_sequence.NEXTVAL, 'Timothy', 'Taller',
              'History', 0),
   NULL);

INSERT INTO students VALUES
  (StudentObj(student_sequence.NEXTVAL, 'Barbara', 'Blues',
              'Economics', 0),
   NULL);

INSERT INTO students VALUES
  (StudentObj(student_sequence.NEXTVAL, 'David', 'Dinsmore',
              'Music', 0),
   NULL);

INSERT INTO students VALUES
  (StudentObj(student_sequence.NEXTVAL, 'Ester', 'Elegant',
              'Nutrition', 0),
   NULL);

INSERT INTO students VALUES
  (StudentObj(student_sequence.NEXTVAL, 'Rose', 'Riznit',
              'Music', 0),
   NULL);

INSERT INTO students VALUES
  (StudentObj(student_sequence.NEXTVAL, 'Rita', 'Razmataz',
              'Nutrition', 0),
   NULL);

PROMPT rooms table...
CREATE TABLE rooms OF RoomObj;

INSERT INTO rooms VALUES
  (RoomObj(99999, 'Building 7', 310, 1000, 'Large Lecture Hall'));

INSERT INTO rooms VALUES
  (RoomObj(99998, 'Building 6', 101, 500, 'Small Lecture Hall'));

INSERT INTO rooms VALUES
  (RoomObj(99997, 'Building 6', 150, 50, 'Discussion Room A'));

INSERT INTO rooms VALUES
  (RoomObj(99996, 'Building 6', 160, 50, 'Discussion Room B'));

INSERT INTO rooms VALUES
  (RoomObj(99995, 'Building 6', 170, 50, 'Discussion Room C'));

INSERT INTO rooms VALUES
  (RoomObj(99994, 'Music Building', 100, 10, 'Music Practice Room'));

INSERT INTO rooms VALUES
  (RoomObj(99993, 'Music Building', 200, 1000, 'Concert Room'));

INSERT INTO rooms VALUES
  (RoomObj(99992, 'Building 7', 300, 75, 'Discussion Room D'));

INSERT INTO rooms VALUES
  (RoomObj(99991, 'Building 7', 310, 50, 'Discussion Room E'));

PROMPT classes table...
CREATE TABLE classes OF ClassObj;

INSERT INTO CLASSES VALUES
  (ClassObj('HIS', 101, 'History 101', 30, 0, 4, NULL));

INSERT INTO CLASSES VALUES
  (ClassObj('HIS', 301, 'History 301', 30, 0, 4, NULL));

INSERT INTO CLASSES VALUES
  (ClassObj('CS', 101, 'Computer Science 101', 50, 0, 4, NULL));

INSERT INTO CLASSES VALUES
  (ClassObj('ECN', 203, 'Economics 203', 15, 0, 3, NULL));

INSERT INTO CLASSES VALUES
  (ClassObj('CS', 102, 'Computer Science 102', 35, 0, 4, NULL));

INSERT INTO CLASSES VALUES
  (ClassObj('MUS', 410, 'Music 410', 5, 0, 3, NULL));

INSERT INTO CLASSES VALUES
  (ClassObj('ECN', 101, 'Economics 101', 50, 0, 4, NULL));

INSERT INTO CLASSES VALUES
  (ClassObj('NUT', 307, 'Nutrition 307', 20, 0, 4, NULL));

COMMIT;

PROMPT Type BookObj...
CREATE TYPE BookObj AS OBJECT (
  title          VARCHAR2(40),
  author         VARCHAR2(40),
  catalog_number NUMBER(4)
);
/

PROMPT Type BookList...
CREATE TYPE BookList AS TABLE OF BookObj;
/

PROMPT Table course_material...
CREATE TABLE course_material (
  department       CHAR(3),
  course           NUMBER(3),
  required_reading BookList)
  NESTED TABLE required_reading STORE AS required_tab;

PROMPT Type BookList2...
CREATE OR REPLACE TYPE BookList2 AS VARRAY(10) OF BookObj;
/

PROMPT Table checked_out...
CREATE TABLE checked_out (
  student_id number(5),
  books BookList2
);
  
CREATE OR REPLACE TYPE NumTab AS TABLE OF NUMBER;
/

CREATE OR REPLACE TYPE NumVar AS VARRAY(25) OF NUMBER;
/

CREATE TABLE lobdemo (
  key NUMBER PRIMARY KEY,
  clob_col  CLOB,
  blob_col  BLOB,
  bfile_col BFILE
);

CREATE TABLE lobdemo2 (
  key NUMBER PRIMARY KEY,
  clob_col  CLOB,
  blob_col  BLOB,
  bfile_col BFILE
);
