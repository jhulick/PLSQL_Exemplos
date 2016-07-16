REM searchq.sql
REM Version 1.0, last updated 8/14/97
REM This function demonstrates how to browse a queue, as described in
REM Chapter 17 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE FUNCTION SearchQueue(
  /* Searches the queue for the first occurrence of a message with title
     p_MessageTitle, and returns the message ID for that occurrence.  If there
     is no match, returns NULL. */
  p_QueueName IN VARCHAR2,
  p_MessageTitle IN VARCHAR2)
  RETURN RAW AS

  v_Message MessageObj;
  v_DequeueOptions DBMS_AQ.DEQUEUE_OPTIONS_T;
  v_MessageProperties DBMS_AQ.MESSAGE_PROPERTIES_T;
  v_MsgID RAW(16);

  e_QTimeOut EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_QTimeOut, -25228);
BEGIN
  -- Loop until there are no more messages to dequeue, or we have found the
  -- desired message.
  BEGIN
    LOOP
      -- Dequeue (in browse mode) the first message into v_Message, waiting a
      -- maximum of 1 second.  Since we are browsing, the message will not be
      -- removed from the queue.
      v_DequeueOptions.wait := 1;
      v_DequeueOptions.dequeue_mode := DBMS_AQ.BROWSE;
      DBMS_AQ.DEQUEUE(
        queue_name => p_QueueName,
        dequeue_options => v_DequeueOptions,
        message_properties => v_MessageProperties,
        payload => v_Message,
        msgid => v_MsgID);

      -- Check the message titles.
      IF v_Message.title = p_MessageTitle THEN
        -- Found a match, return the message ID.
        COMMIT;
        RETURN v_MsgID;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN e_QTimeOut THEN
      -- End of the queue reached.
      NULL;
  END;

  -- Commit all the dequeues and return NULL, indicating no match.
  COMMIT;
  RETURN NULL;
END;
/

-- Example of using SearchQueue.
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
                 'abcdefghijklmnopqrstuvwxyz', SYSDATE + v_Counter);

    -- Enqueue it with the default options.
    DBMS_AQ.ENQUEUE(
      queue_name => 'SimpleQ',
      enqueue_options => v_EnqueueOptions,
      message_properties => v_MessageProperties,
      payload => v_Message,
      msgid => v_MsgID);
  END LOOP;

  -- Commit all the enqueues.
  COMMIT;

  -- Search for message 4
  v_MsgID := SearchQueue('SimpleQ', 'Message 4');

  -- If found, dequeue and print.
  IF v_MsgID IS NOT NULL THEN
    v_DequeueOptions.wait := 1;
    v_DequeueOptions.msgid := v_MsgID;
    DBMS_AQ.DEQUEUE(
      queue_name => 'SimpleQ',
      dequeue_options => v_DequeueOptions,
      message_properties => v_MessageProperties,
      payload => v_Message,
      msgid => v_MsgID);
    v_Message.Print('After search');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Message 4 not found');
  END IF;

  -- Clear the queue.
  ClearQueue('SimpleQ');
END;
/

