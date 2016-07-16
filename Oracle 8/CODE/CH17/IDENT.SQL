REM ident.sql
REM Version 1.0, last updated 8/14/97
REM This block demonstrates the use of correlation and message identifiers,
REM as discussed in Chapter 17 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET SERVEROUTPUT on
DECLARE
  v_Message MessageObj;
  v_EnqueueOptions DBMS_AQ.ENQUEUE_OPTIONS_T;
  v_DequeueOptions DBMS_AQ.DEQUEUE_OPTIONS_T;
  v_MessageProperties DBMS_AQ.MESSAGE_PROPERTIES_T;
  v_MsgID RAW(16);
  v_TigerMsgID RAW(16);

  c_NumMessages CONSTANT INTEGER := 10;

  TYPE t_Correlations IS TABLE OF VARCHAR2(30)
    INDEX BY BINARY_INTEGER;
  v_Correlations t_Correlations;

  e_QTimeOut EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_QTimeOut, -25228);
BEGIN
  -- Initialize the array of correlation identifiers.
  -- There will be a total of 5 different correlation IDs, with two messages
  -- getting each one.
  FOR v_Counter IN 1..c_NumMessages LOOP
    IF MOD(v_Counter, 5) = 1 THEN
      v_Correlations(v_Counter) := 'Lion';
    ELSIF MOD(v_Counter, 5) = 2 THEN
      v_Correlations(v_Counter) := 'Tiger';
    ELSIF MOD(v_Counter, 5) = 3 THEN
      v_Correlations(v_Counter) := 'Bear';
    ELSIF MOD(v_Counter, 5) = 4 THEN
      v_Correlations(v_Counter) := 'Fish';
    ELSE
      v_Correlations(v_Counter) := 'Horse';
    END IF;
  END LOOP;

  FOR v_Counter IN 1..c_NumMessages LOOP
    -- Create a message to enqueue.
    v_Message :=
      MessageObj('Message ' || v_Counter, v_Counter * 10,
                 'abcdefghijklmnopqrstuvwxyz', SYSDATE + v_Counter);

    v_MessageProperties.correlation := v_Correlations(v_Counter);
    DBMS_OUTPUT.PUT_LINE('Enqueing message ' || v_Counter ||
      ' with correlation ID ' || v_Correlations(v_Counter));
    DBMS_AQ.ENQUEUE(
      queue_name => 'SimpleQ',
      enqueue_options => v_EnqueueOptions,
      message_properties => v_MessageProperties,
      payload => v_Message,
      msgid => v_MsgID);

    -- Save one of the tiger message ID's.
    IF v_Correlations(v_Counter) = 'Tiger' THEN
      v_TigerMsgID := v_MsgID;
    END IF;
  END LOOP;

  -- Commit all the enqueues.
  COMMIT;

  -- Dequeue only the messages with correlation ID 'Fish'.
  BEGIN
    LOOP
      -- Dequeue the first message into v_Message, waiting a maximum of 1
      -- second.
      v_DequeueOptions.wait := 1;
      v_DequeueOptions.correlation := 'Fish';
      DBMS_AQ.DEQUEUE(
        queue_name => 'SimpleQ',
        dequeue_options => v_DequeueOptions,
        message_properties => v_MessageProperties,
        payload => v_Message,
        msgid => v_MsgID);

      -- And print it.
      v_Message.Print('After dequeue with correlation ID Fish');
    END LOOP;
  EXCEPTION
    WHEN e_QTimeOut THEN
      -- End of the queue reached.
      NULL;
  END;

  -- Dequeue only the message with the saved message ID.
  v_DequeueOptions.correlation := NULL;
  v_DequeueOptions.msgid := v_TigerMsgID;
  DBMS_AQ.DEQUEUE(
    queue_name => 'SimpleQ',
    dequeue_options => v_DequeueOptions,
    message_properties => v_MessageProperties,
    payload => v_Message,
    msgid => v_MsgID);

  -- And print it.
  v_Message.Print('After dequeue with saved message ID');

  -- Clear all the remaining messages.
  ClearQueue('SimpleQ');

  -- Commit all the dequeues.
  COMMIT;
END;
/

