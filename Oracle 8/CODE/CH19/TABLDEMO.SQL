REM tabldemo.sql
REM Version 1.0, last updated 7/17/97
REM This procedure outputs the data in students in an HTML table, as
REM described in Chapter 19 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE TableDemo AS
  CURSOR c_Students IS
    SELECT *
      FROM students
      ORDER BY ID;
BEGIN
  HTP.htmlOpen;
  HTP.headOpen;
  HTP.title('Table Demo');
  HTP.headClose;

  HTP.bodyOpen;
  HTP.tableOpen(cborder => 'BORDER=1');

  -- Loop over the students, and for each one output two table
  -- rows, which look something like:
  -- +--------------------------------+
  -- |    |   first_name last_name    |
  -- | ID +---------+-----------------+
  -- |    | major   | current_credits |
  -- +----+---------+-----------------+
  FOR v_StudentRec in c_Students LOOP
    HTP.tableRowOpen;
    HTP.tableData(crowspan => 2,
                  cvalue => HTF.bold(v_StudentRec.ID));
    HTP.tableData(ccolspan => 2,
                  calign => 'CENTER',
                  cvalue => v_StudentRec.first_name || ' ' ||
                            v_StudentRec.last_name);
    HTP.tableRowClose;
    HTP.tableRowOpen;
    HTP.tableData(cvalue => 'Major: ' || v_StudentRec.major);
    HTP.tableData(cvalue => 'Credits: ' || v_StudentRec.current_credits);
    HTP.tableRowClose;
  END LOOP;

  HTP.tableClose;
  OWA_UTIL.signature('TableDemo');
  HTP.bodyClose;
  HTP.htmlClose;
END TableDemo;
/
