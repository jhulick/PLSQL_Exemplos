REM dropq.sql
REM Version 1.0, last updated 8/14/97
REM This script will drop the data structures used by the examples in
REM Chapter 17 of _Oracle8 PL/SQL Programming_ by Scott Urman.

PROMPT Stopping, dropping SimpleQ and ExceptionQ...
BEGIN
  DBMS_AQADM.STOP_QUEUE('SimpleQ');
  DBMS_AQADM.DROP_QUEUE('SimpleQ');
  DBMS_AQADM.STOP_QUEUE('ExceptionQ');
  DBMS_AQADM.DROP_QUEUE('ExceptionQ');
  DBMS_AQADM.DROP_QUEUE_TABLE('SimpleQTab');
END;
/

PROMPT Stopping, dropping PriorityQ...
BEGIN
  DBMS_AQADM.STOP_QUEUE('PriorityQ');
  DBMS_AQADM.DROP_QUEUE('PriorityQ');
  DBMS_AQADM.DROP_QUEUE_TABLE('PriorityQTab');
END;
/

PROMPT Dropping MessageObj...
DROP TYPE MessageObj;
