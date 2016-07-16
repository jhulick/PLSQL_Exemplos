REM priority.sql
REM Version 1.0, last updated 8/14/97
REM This block demonstrates enqueue and dequeue operations on a priority
REM queue, as described in Chapter 17 of _Oracle8 PL/SQL Programming_
REM by Scott Urman.

SET SERVEROUTPUT on
DECLARE
  v_Message MessageObj;
  v_EnqueueOptions DBMS_AQ.ENQUEUE_OPTIONS_T;
  v_DequeueOptions DBMS_AQ.DEQUEUE_OPTIONS_T;
  v_MessageProperties DBMS_AQ.MESSAGE_PROPERTIES_T;
  v_MsgID RAW(16);

  c_NumMessages CONSTANT INTEGER := 10;

  e_QTimeOut EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_QTimeOut, -25228);
BEGIN
  FOR v_Counter IN 1..c_NumMessages LOOP
    -- Create a message to enqueue.
    v_Message :=
      MessageObj('Message ' || v_Counter, v_Counter * 10,
                 'zyxwvutsrqponmlkjihgfedcba', SYSDATE + v_Counter);

    -- Enqueue it with priority equal to -v_Counter.  Thus the last message
    -- to be enqueued will have the highest priority.
    v_MessageProperties.priority := -v_Counter;
    DBMS_AQ.ENQUEUE(
      queue_name => 'PriorityQ',
      enqueue_options => v_EnqueueOptions,
      message_properties => v_MessageProperties,
      payload => v_Message,
      msgid => v_MsgID);
  END LOOP;

  -- Commit all the enqueues.
  COMMIT;

  -- Loop until there are no more messages to dequeue.
  BEGIN
    LOOP
      -- Dequeue the first message into v_Message, waiting a maximum of 1
      -- second.
      v_DequeueOptions.wait := 1;
      DBMS_AQ.DEQUEUE(
        queue_name => 'PriorityQ',
        dequeue_options => v_DequeueOptions,
        message_properties => v_MessageProperties,
        payload => v_Message,
        msgid => v_MsgID);

      -- And print it.
      v_Message.Print('After dequeue');
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

