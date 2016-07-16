REM logRSins.sql
REM Version 1.0, last updated 5/3/97
REM This trigger uses the DBMS_PIPE package to log the inserts to the 
REM registered_students table.  It is described in Chapter 16
REM of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE TRIGGER LogRSInserts
  BEFORE INSERT ON registered_students
  FOR EACH ROW
DECLARE
  v_Status     INTEGER;
BEGIN

  /* Pack the description into the buffer first. */
  DBMS_PIPE.PACK_MESSAGE('I');

  /* Pack the current user and the timestamp. */
  DBMS_PIPE.PACK_MESSAGE(user);
  DBMS_PIPE.PACK_MESSAGE(sysdate);

  /* Pack the new values. */
  DBMS_PIPE.PACK_MESSAGE(:new.student_ID);
  DBMS_PIPE.PACK_MESSAGE(:new.department);
  DBMS_PIPE.PACK_MESSAGE(:new.course);
  DBMS_PIPE.PACK_MESSAGE(:new.grade);

  /* Send the message over the 'RSInserts' pipe. */
  v_Status := DBMS_PIPE.SEND_MESSAGE('RSInserts');

  /* If the send is unsuccessful, raise an error so the change
     doesn't go through. */
  IF v_Status != 0 THEN
    RAISE_APPLICATION_ERROR(-20010, 'LogRSInserts trigger ' ||
      'couldn''t send the message, status = ' || v_Status);
  END IF;
  
END LogRSInserts;
/
