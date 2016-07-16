REM createq.sql
REM Version 1.0, last updated 8/14/97
REM This file will create the data structures necessary to run the examples
REM in Chapter 17 of _Oracle8 PL/SQL Programming_ by Scott Urman.

PROMPT MessageObj...
-- First create a message type.
CREATE OR REPLACE TYPE MessageObj AS OBJECT (
  title  VARCHAR2(30),
  data1  NUMBER,
  data2  VARCHAR2(100),
  data3  DATE,

  MEMBER PROCEDURE Print(v_Message IN VARCHAR2)
);
/

CREATE OR REPLACE TYPE BODY MessageObj AS
  MEMBER PROCEDURE Print(v_Message IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(v_Message || ': ' || title);
    DBMS_OUTPUT.PUT('Data 1: ' || data1);
    DBMS_OUTPUT.PUT(' Data 2: ' || data2);
    DBMS_OUTPUT.PUT_LINE(' Data 3: ' || data3);
  END Print;
END;
/

PROMPT SimpleQ...
BEGIN
  -- Create a simple table, with all of the defaults.  This will allow FIFO
  -- queues, with no message grouping or multiple consumers.
  DBMS_AQADM.CREATE_QUEUE_TABLE(
    queue_table => 'SimpleQTab',
    queue_payload_type => 'MessageObj',
    comment => 'Simple Queue Table');

  -- Create a simple queue contained within SimpleQTab.  Again, use the default
  -- parameters.
  DBMS_AQADM.CREATE_QUEUE(
    queue_name => 'SimpleQ',
    queue_table => 'SimpleQTab',
    comment => 'Simple Queue');

  -- Enable enqueue and dequeue operations for SimpleQ.
  DBMS_AQADM.START_QUEUE('SimpleQ');

  -- Create an exception queue within SimpleQTab.
  DBMS_AQADM.CREATE_QUEUE(
    queue_name => 'ExceptionQ',
    queue_table => 'SimpleQTab',
    queue_type => DBMS_AQADM.EXCEPTION_QUEUE,
    comment => 'Exception Queue');

  -- Enable dequeue operations for ExceptionQ.
  DBMS_AQADM.START_QUEUE('ExceptionQ', FALSE, TRUE);
END;
/

PROMPT PriorityQ...
BEGIN
  -- Create a priority queue table, by specifying the sort order.  This queue has
  -- no message grouping or multiple consumers.
  DBMS_AQADM.CREATE_QUEUE_TABLE(
    queue_table => 'PriorityQTab',
    queue_payload_type => 'MessageObj',
    sort_list => 'priority,enq_time',
    comment => 'Priority Queue Table');

  -- Create a priority queue contained within PriorityQTab.  Again, use the default
  -- parameters.
  DBMS_AQADM.CREATE_QUEUE(
    queue_name => 'PriorityQ',
    queue_table => 'PriorityQTab',
    comment => 'Priority Queue');

  -- Enable enqueue and dequeue operations for PriorityQ.
  DBMS_AQADM.START_QUEUE('PriorityQ');
END;
/


