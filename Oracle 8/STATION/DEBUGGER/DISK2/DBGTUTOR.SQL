/* dbgtutor.sql 
** tutorial file: 
**   contains definition of tables, insert statements for filling the 
**   tables and procedures which rely upon these tables
**  date: April 20th, 1996.
**  author : Dan Y. Wang
*/
drop table sqldebug.ptsql_courses;
create table sqldebug.ptsql_courses 
(course_name varchar2(30),
 course_load number);
grant all on sqldebug.ptsql_courses to public;

drop table sqldebug.ptsql_student_registration;
create table sqldebug.ptsql_student_registration
 (last_name varchar2(30),
 course_name varchar2(30),
 reg_date date);
grant all on sqldebug.ptsql_student_registration to public;

drop index sqldebug.i_reg_course_name;
create index sqldebug.i_reg_course_name 
on sqldebug.ptsql_student_registration(course_name);

drop table sqldebug.ptsql_students;
create table sqldebug.ptsql_students
(last_name varchar2(30),
 gender integer
 check (gender in (0,1)) );
grant all on sqldebug.ptsql_students to public;

/* insert into sqldebug.ptsql_courses */
insert  into sqldebug.ptsql_courses (course_name, course_load)
values ('CHEMISTRY', 10);                                  
insert  into sqldebug.ptsql_courses  (course_name, course_load)
values ('BIOLOGY',  7);                                  
insert  into sqldebug.ptsql_courses  (course_name, course_load) 
values ('MATH',  7);                                  
insert  into sqldebug.ptsql_courses (course_name, course_load)
values ('ART',  5);
                                  
insert  into sqldebug.ptsql_courses  (course_name, course_load)
values ('PHYSICS',  10);                                  
insert  into sqldebug.ptsql_courses  (course_name, course_load)
values ('GEOLOGY', 5);                                  
insert  into sqldebug.ptsql_courses  (course_name, course_load) 
values ('ACCOUNTING',  10);                                  
insert  into sqldebug.ptsql_courses  (course_name, course_load)
values ('HISTORY',  7);                                  

insert  into sqldebug.ptsql_courses  (course_name, course_load)
values ('ENGLISH',  12); 
insert  into sqldebug.ptsql_courses  (course_name, course_load)
values ('LAW',  9); 

/* insert into students */
insert into sqldebug.ptsql_students values ('CHEN', 0);
insert into sqldebug.ptsql_students values ('MORRISON', 1);
insert into sqldebug.ptsql_students values ('FARLEY', 0);
insert into sqldebug.ptsql_students values ('JONES', 1);
insert into sqldebug.ptsql_students values ('ZEDIG', 0);
insert into sqldebug.ptsql_students values ('TANNER', 1);
insert into sqldebug.ptsql_students values ('RUIZ', 0);
insert into sqldebug.ptsql_students values ('HAUSER', 1);
insert into sqldebug.ptsql_students values ('MCKAY', 1);
insert into sqldebug.ptsql_students values ('ALIOTO', 1);

/* insert into student_registration */
-- first
 insert into sqldebug.ptsql_student_registration values ('CHEN', 'ACCOUNTING', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('CHEN', 'MATH', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('CHEN', 'ENGLISH', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('CHEN', 'PHYSICS', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('CHEN', 'MATH', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('CHEN', 'GEOLOGY', '3-SEP-96');
-- second
 insert into sqldebug.ptsql_student_registration values ('MORRISON', 'HISTORY', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('MORRISON', 'MATH', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('MORRISON', 'BIOLOGY', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('MORRISON', 'PHYSICS', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('MORRISON', 'MATH', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('MORRISON', 'GEOLOGY', '3-SEP-96');
--third
 insert into sqldebug.ptsql_student_registration values ('FARLEY', 'LAW', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('FARLEY', 'ART', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('FARLEY', 'ENGLISH', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('FARLEY', 'PHYSICS', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('FARLEY', 'LAW', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('FARLEY', 'GEOLOGY', '3-SEP-96');
--fourth
 insert into sqldebug.ptsql_student_registration values ('JONES', 'BIOLOGY', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('JONES', 'ART', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('JONES', 'ENGLISH', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('JONES', 'PHYSICS', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('JONES', 'HISTORY', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('JONES', 'CHEMISTRY', '3-SEP-96');
--fifth
 insert into sqldebug.ptsql_student_registration values ('ZEDIG', 'MATH', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('ZEDIG', 'ART', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('ZEDIG', 'CHEMISTRY', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('ZEDIG', 'PHYSICS', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('ZEDIG', 'ART', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('ZEDIG', 'HISTORY', '3-SEP-96');
--sixth
 insert into sqldebug.ptsql_student_registration values ('TANNER', 'LAW', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('TANNER', 'ART', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('TANNER', 'ACCOUNTING', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('TANNER', 'BIOLOGY', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('TANNER', 'LAW', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('TANNER', 'GEOLOGY', '3-SEP-96');
--seventh
 insert into sqldebug.ptsql_student_registration values ('RUIZ', 'BIOLOGY', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('RUIZ', 'ART', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('RUIZ', 'CHEMISTRY', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('RUIZ', 'PHYSICS', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('RUIZ', 'MATH', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('RUIZ', 'CHEMISTRY', '3-SEP-96');
--eighth
 insert into sqldebug.ptsql_student_registration values ('HAUSER', 'BIOLOGY', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('HAUSER', 'ART', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('HAUSER', 'CHEMISTRY', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('HAUSER', 'ENGLISH', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('HAUSER', 'MATH', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('HAUSER', 'HISTORY', '3-SEP-96');
--nineth
 insert into sqldebug.ptsql_student_registration values ('MCKAY', 'ENGLISH', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('MCKAY', 'GEOLOGY', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('MCKAY', 'CHEMISTRY', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('MCKAY', 'ENGLISH', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('MCKAY', 'MATH', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('MCKAY', 'HISTORY', '3-SEP-96');
--tenth
 insert into sqldebug.ptsql_student_registration values ('ALIOTO', 'BIOLOGY', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('ALIOTO', 'ART', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('ALIOTO', 'LAW', '3-MAR-96');
 insert into sqldebug.ptsql_student_registration values ('ALIOTO', 'ENGLISH', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('ALIOTO', 'LAW', '3-SEP-96');
 insert into sqldebug.ptsql_student_registration values ('ALIOTO', 'HISTORY', '3-SEP-96');

/* package StudentStatistics  */
create or replace package sqldebug.StudentStatistics 
as
  male_word varchar2(30) := 'MALE';
  female_word varchar2(30) := 'FEMALE'; 
  sem1_date constant date := '3-MAR-96';
  sem2_date constant date := '3-SEP-96';
  function GetStudentGender ( student_surname varchar2) return varchar2;
  function GetStudentLoad (course_id varchar2) return number;
  /* First instance of AnalyzeStudentLoad : for a given date, find for all students the average total course
  ** load and the standard deviation.  */
  procedure AnalyzeStudentLoad ( in_date date,
											  ave_total_load out number,
											  std_load out number) ;
  /*  Second instance of AnalyzeStudentLoad : for a given date, find for a given student his course load 
  ** and the average load per class */
  procedure AnalyzeStudentLoad ( student_surname varchar2,
											  in_date date,
											  total_load out number,
											  number_of_courses out number,
											  load_per_course out number);
 end;
/

create or replace package body sqldebug.StudentStatistics
as
  male_code integer := 0;
  female_code integer := 1;

 function GetGender( gender_code number) return varchar2
 is
  gender_word varchar2(30);
 begin
    if gender_code = 0 then
       gender_word := male_word;
    else
       gender_word := female_word;
    end if;
    return gender_word;
  end;

  function GetStudentGender ( student_surname varchar2) return varchar2
  is
   sex_code integer;
   sex_id varchar2(30);
   begin 
     select gender into sex_code from sqldebug.ptsql_students
       where last_name = student_surname;
     sex_id := GetGender (sex_code); 
     return sex_id;
  end;


  function GetStudentLoad (course_id varchar2) return number
  is 
  crse_hours number;
  begin
    select course_load into crse_hours from sqldebug.ptsql_courses
     where course_name = course_id;
    return crse_hours;
  end;

 function GetOneStudentLoad ( student_surname varchar2,
									     in_date date := sem1_date)
   return number
   is 
   cursor get_course_names is
    select course_name from sqldebug.ptsql_student_registration
     where last_name = student_surname
     and trunc(reg_date) = trunc(in_date);
   this_crse_load number;
   crse_name varchar2(30);
   tot_load number;
   begin
      tot_load := 0;
      open get_course_names;
      loop
        fetch get_course_names into crse_name;
        exit when get_course_names%NOTFOUND;
        this_crse_load := GetStudentLoad (crse_name);
        tot_load := tot_load + this_crse_load;
      end loop;
      return tot_load;
   end;

  /* First instance of AnalyzeStudentLoad : for a given date, find for all students the average total course
  ** load and the standard deviation.  */
  procedure AnalyzeStudentLoad ( in_date date := sem1_date,
											  ave_total_load out number,
											  std_load out number)
  is
  cursor get_student_names is 
    select last_name from sqldebug.ptsql_student_registration
     where trunc(reg_date) = trunc(in_date);
  this_name varchar2(30);
  this_load number;
  tot_load number := 0;
  ave_load number;
  sum_square number := 0;
  number_of_students number := 0;
  begin
     open get_student_names;
     loop
        fetch get_student_names into this_name;
        exit when get_student_names%NOTFOUND;
        number_of_students := number_of_students +1 ;
        this_load := GetOneStudentLoad (this_name, in_date);
        tot_load := tot_load + this_load;
        sum_square := sum_square + this_load * this_load;
     end loop;
     ave_load := tot_load / number_of_students;
     ave_total_load := ave_load;
     std_load := sqrt ( sum_square/number_of_students - ave_load * ave_load);
  end;

  
 

  /*  Second instance of AnalyzeStudentLoad : for a given date, find for a given student his course load 
  ** and the average load per class */
  procedure AnalyzeStudentLoad ( student_surname varchar2,
											  in_date date := sem1_date,
											  total_load out number,
											  number_of_courses out number,
											  load_per_course out number)
   is 
   cursor get_course_names is
    select course_name from sqldebug.ptsql_student_registration
     where last_name = student_surname
     and trunc(reg_date) = trunc(in_date);
   this_crse_load number;
   crse_name varchar2(30);
   num_courses number;
   tot_load number;
   begin
      tot_load := 0;
      num_courses := 0;
      open get_course_names;
      loop
        fetch get_course_names into crse_name;
        exit when get_course_names%NOTFOUND;
        num_courses := num_courses + 1;
        this_crse_load := GetStudentLoad (crse_name);
        tot_load := tot_load + this_crse_load;
      end loop;
      total_load := tot_load;
      number_of_courses := num_courses;
      load_per_course := tot_load / num_courses;
   end;
 
end StudentStatistics;
/

/* procedure CourseGenderDistribution */
create or replace procedure sqldebug.CourseGenderDistribution 
 (course varchar2, 
  spec_date date default StudentStatistics.sem2_date, 
  percent_male out number)
as
cursor get_students is
 select last_name from sqldebug.ptsql_student_registration
  where course_name = course
  and trunc(reg_date) = trunc(spec_date);
st_name varchar2(30);
st_gender varchar2(30);
num_tot number := 0 ;
num_male number  := 0 ;
begin
  percent_male := 0; -- default value
  open get_students;
  loop
     fetch get_students into st_name;
     exit when get_students%NOTFOUND;
     num_tot := num_tot + 1;
     st_gender := sqldebug.StudentStatistics.GetStudentGender( st_name);
     if (st_gender = sqldebug.StudentStatistics.male_word) then
        num_male := num_male + 1;
     end if;
  end loop;
  if  (num_tot > 0) then 
    percent_male := num_male / num_tot;
  end if ;
end;
/

/* function CheckGenderEquality   */
create or replace function sqldebug.CheckGenderEquality 
( reg_date date)
return number
 is
 cursor get_courses is
  select course_name from sqldebug.ptsql_courses;  
 this_course varchar2(30);
 num_courses number := 0;
 tmp_percent number ;
 ave_pct number := 0;
 percent_sum number := 0;
 begin
    open get_courses;
    loop
      fetch get_courses into this_course;
      exit when get_courses%NOTFOUND;
      sqldebug.CourseGenderDistribution ( this_course, reg_date, tmp_percent);
      dbms_output.put_line(tmp_percent);
      num_courses := num_courses + 1; 
      percent_sum := percent_sum + tmp_percent;
    end loop;
    if (num_courses > 0) then 
      ave_pct :=  percent_sum / num_courses; 
    else
       dbms_output.put_line ('Data access Problem');
    end if;  
    return ave_pct;
end;
/

/* procedure AnalyzeStudentLoad  */
create or replace procedure sqldebug.AnalyzeStudentLoad ( student_surname varchar2,
											  in_date date,
											  total_load out number,
											  number_of_courses out number,
											  load_per_course out number)
   is 
   cursor get_course_names is
    select course_name from sqldebug.ptsql_student_registration
     where last_name = student_surname
     and trunc(reg_date) = trunc(in_date);
   this_crse_load number;
   crse_name varchar2(30);
   num_courses number;
   tot_load number;
   begin
      tot_load := 0;
      num_courses := 0;
      open get_course_names;
      loop
        fetch get_course_names into crse_name;
        exit when get_course_names%NOTFOUND;
        num_courses := num_courses + 1;
        select course_load into this_crse_load from sqldebug.ptsql_courses
          where course_name = crse_name;
        tot_load := tot_load + this_crse_load;
      end loop;
      total_load := tot_load;
      number_of_courses := num_courses;
      load_per_course := tot_load / num_courses;
   end;
/

/* trigger after_reg_insert  */
CREATE OR REPLACE TRIGGER sqldebug.after_reg_insert

before insert on sqldebug.ptsql_student_registration for each row
                                                                                                            declare
  a_count number ;
  tst_name varchar2(30);
  tst_course varchar2(30);
 begin
   dbms_output.put_line('after_reg_insert trigger fired');
   tst_name := :new.last_name;
  select count(*) into a_count from sqldebug.ptsql_students
   where last_name = tst_name;
  if (a_count <= 0) then
      raise_application_error (-20350, 'NO STUDENT BY THE NAME OF  ' || tst_name);
  end if;

   a_count := 0;
    tst_course := :new.course_name;
   select count(*) into a_count from sqldebug.ptsql_courses
   where course_name = tst_course;
  if (a_count <= 0) then
     raise_application_error (-20351, 'NO COURSE BY THE NAME OF  ' || tst_course);
  end if;

end;
/

/* function: GetNumberTakingHisGeo  */
CREATE OR REPLACE function sqldebug.GetNumberTakingHisGeo
return integer 
as
cursor GetStudent is
  select last_name from 
  sqldebug.ptsql_student_registration reg, sqldebug.ptsql_courses crs
  where upper(reg.course_name) = crs.course_name
  and (crs.course_name like 'H%'
  or   crs.course_name like 'G%' )
      and reg_date < '3-SEP-96';
  this_student_name varchar2(30);
  number_of_students integer;
begin
  number_of_students := 0;
  open GetStudent;
  loop
    fetch GetStudent into    this_student_name;
    exit when GetStudent%notfound;
    number_of_students := number_of_students + 1;
  end loop;
  close    GetStudent;
  return number_of_students;
end;
  





