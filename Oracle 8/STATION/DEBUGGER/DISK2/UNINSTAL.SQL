  drop TABLE sqldebug.PTSQL_DBG_TRIGGERS;
  drop table sqldebug.PTSQL_DBG_IGNORE;
  drop sequence sqldebug.PTSQL_DBG_SEQ;
  drop TABLE sqldebug.PTSQL_DBG_OBJS;
  drop table sqldebug.PTSQL_FREE_SEQ_NUMS;
  /* drop TRIGGER sqldebug.PTSQL_DBG_OBJS_AFTER_DELETE; */
  drop package sqldebug.PTSQL_DBG_MAINT;
  drop package sqldebug.PTSQL_DEBUG;
  drop PACKAGE sqldebug.ptsql_depend;
  drop table sqldebug.ptsql_courses;
  drop table sqldebug.ptsql_student_registration;
  drop table sqldebug.ptsql_students;
  drop package sqldebug.StudentStatistics;
  drop procedure sqldebug.CourseGenderDistribution;
  drop function sqldebug.CheckGenderEquality;
  drop procedure sqldebug.AnalyzeStudentLoad;
  drop TRIGGER sqldebug.after_reg_insert;
  commit;