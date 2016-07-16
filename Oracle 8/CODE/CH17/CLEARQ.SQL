REM clearq.sql
REM Version 1.0, last updated 8/14/97
REM This procedure will remove all the messages in a queue, as described in
REM Chapter 17 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE ClearQueue(p_QueueName IN VARCHAR2) AS
  v_Message MessageObj;
  v_DequeueOptions DBMS_AQ.DEQUEUE_OPTIONS_T;
  v_MessageProperties DBMS_AQ.MESSAGE_PROPERTIES_T;
  v_MsgID RAW(16);

  e_QTimeOut EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_QTimeOut, -25228);
BEGIN
  -- Loop until there are no more messages to dequeue.
  BEGIN
    LOOP
      -- Dequeue the first message into v_Message, waiting a maximum of 1
      -- second.
      v_DequeueOptions.wait := 1;
      DBMS_AQ.DEQUEUE(
        queue_name => 'SimpleQ',
        dequeue_options => v_DequeueOptions,
        message_properties => v_MessageProperties,
        payload => v_Message,
        msgid => v_MsgID);
    END LOOP;
  EXCEPTION
    WHEN e_QTimeOut THEN
      -- End of the queue reached.
      NULL;
  END;

  -- Commit all the dequeues.
  COMMIT;
END;
/

