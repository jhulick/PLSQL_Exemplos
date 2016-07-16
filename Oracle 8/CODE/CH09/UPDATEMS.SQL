REM updateMS.sql
REM Version 1.0, last updated 5/1/97
REM This trigger will keep the major_stats table in sync with the
REM students table, as described in Chapter 9 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE TRIGGER UpdateMajorStats
  /* Keeps the major_stats table up-to-date with changes made
     to the students table. */
  AFTER INSERT OR DELETE OR UPDATE ON students
DECLARE
  CURSOR c_Statistics IS
    SELECT major, COUNT(*) total_students,
           SUM(current_credits) total_credits
      FROM students
      GROUP BY major;
BEGIN
  /* Loop through each major. Attempt to update the statistics
     in major_stats corresponding to this major. If the row
     doesn't exist, create it. */
  FOR v_StatsRecord in c_Statistics LOOP
    UPDATE major_stats
      SET total_credits = v_StatsRecord.total_credits,
          total_students = v_StatsRecord.total_students
      WHERE major = v_StatsRecord.major;
    /* Check to see if the row exists. */
    IF SQL%NOTFOUND THEN
      INSERT INTO major_stats (major, total_credits, total_students)
        VALUES (v_StatsRecord.major, v_StatsRecord.total_credits,
                v_StatsRecord.total_students);
    END IF;
  END LOOP;
END UpdateMajorStats;
/
