REM except.sql
REM Version 1.0, last updated 8/14/97
REM This block demonstrates the use of exception queues, as described in
REM Chapter 17 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET SERVEROUTPUT on
DECLARE
  v_Message MessageObj;
  v_EnqueueOptions DBMS_AQ.ENQUEUE_OPTIONS_T;
  v_DequeueOptions DBMS_AQ.DEQUEUE_OPTIONS_T;
  v_MessageProperties DBMS_AQ.MESSAGE_PROPERTIES_T;
  v_MsgID RAW(16);
  v_NormalCount INTEGER;
  v_ExceptionCount INTEGER;

  c_NumMessages CONSTANT INTEGER := 3;

  e_QTimeOut EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_QTimeOut, -25228);
BEGIN
  -- Enqueue 3 messages with the exception queue set.
  FOR v_Counter IN 1..c_NumMessages LOOP
    -- Create a message to enqueue.
    v_Message :=
      MessageObj('Message ' || v_Counter, v_Counter * 10,
                 'abcdefghijklmnopqrstuvwxyz', SYSDATE + v_Counter);

    -- Enqueue it.
    v_MessageProperties.exception_queue := 'ExceptionQ';
    DBMS_AQ.ENQUEUE(
      queue_name => 'SimpleQ',
      enqueue_options => v_EnqueueOptions,
      message_properties => v_MessageProperties,
      payload => v_Message,
      msgid => v_MsgID);
  END LOOP;

  -- Commit all the enqueues.
  COMMIT;

  -- Verify that there are three messages in the normal queue, and none in
  -- the exception queue.
  SELECT COUNT(*)
    INTO v_NormalCount
    FROM aq$SimpleQTab
    WHERE queue = UPPER('Simpleq');
  SELECT COUNT(*)
    INTO v_ExceptionCount
    FROM aq$SimpleQTab
    WHERE queue = UPPER('ExceptionQ');
  DBMS_OUTPUT.PUT('After initial enqueues, count(simple) = ' || v_NormalCount);
  DBMS_OUTPUT.PUT_LINE(', count(exception) = ' || v_ExceptionCount);

  -- Dequeue the first message, then rollback.  This will rollback the dequeue,
  -- and increase the attempts field in the message properties.  Since the
  -- max_retries for SimpleQ is 0, this will move the message to the
  -- exception queue.
  v_DequeueOptions.wait := 1;
  DBMS_AQ.DEQUEUE(
    queue_name => 'SimpleQ',
    dequeue_options => v_DequeueOptions,
    message_properties => v_MessageProperties,
    payload => v_Message,
    msgid => v_MsgID);
  ROLLBACK;

  -- Verify that there are two messages in the normal queue, and one in
  -- the exception queue.
  SELECT COUNT(*)
    INTO v_NormalCount
    FROM aq$SimpleQTab
    WHERE queue = UPPER('Simpleq');
  SELECT COUNT(*)
    INTO v_ExceptionCount
    FROM aq$SimpleQTab
    WHERE queue = UPPER('ExceptionQ');
  DBMS_OUTPUT.PUT('After dequeue and rollback, count(simple) = ' || v_NormalCount);
  DBMS_OUTPUT.PUT_LINE(', count(exception) = ' || v_ExceptionCount);

  -- Now we can get the message from the exception queue.  Note that we have to
  -- use the message ID, since the state of this message is EXPIRED, and the
  -- dequeue will not normally return any messages with a state other than READY.
  v_DequeueOptions.msgid := v_MsgID;
  DBMS_AQ.DEQUEUE(
    queue_name => 'ExceptionQ',
    dequeue_options => v_DequeueOptions,
    message_properties => v_MessageProperties,
    payload => v_Message,
    msgid => v_MsgID);
  v_Message.Print('After exception dequeuing');

  -- Verify that there are two messages in the normal queue, and none in
  -- the exception queue.
  SELECT COUNT(*)
    INTO v_NormalCount
    FROM aq$SimpleQTab
    WHERE queue = UPPER('Simpleq');
  SELECT COUNT(*)
    INTO v_ExceptionCount
    FROM aq$SimpleQTab
    WHERE queue = UPPER('ExceptionQ');
  DBMS_OUTPUT.PUT('After exception dequeue, count(simple) = ' || v_NormalCount);
  DBMS_OUTPUT.PUT_LINE(', count(exception) = ' || v_ExceptionCount);

  -- Clear the queue, and commit.
  ClearQueue('SimpleQ');
  COMMIT;
END;
/

