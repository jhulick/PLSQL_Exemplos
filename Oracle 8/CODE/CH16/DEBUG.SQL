REM debug.sql
REM Version 1.0, last updated 5/3/97
REM This package implements the Debug package, as described in
REM Chapter 16 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PACKAGE Debug AS
  -- Maximum number of seconds to wait for a handshake message.
  v_TimeOut NUMBER := 10;

  -- Main Debug procedure.
  PROCEDURE Debug(p_Description IN VARCHAR2, p_Value IN
VARCHAR2);

  -- Sets up the Debug environment.
  PROCEDURE Reset;

  -- Causes the daemon to exit.
  PROCEDURE Exit;
END Debug;
/

CREATE OR REPLACE PACKAGE BODY Debug as

  v_CurrentPipeName VARCHAR2(30);

  PROCEDURE Debug(p_Description IN VARCHAR2, p_Value IN
VARCHAR2) IS
    v_ReturnCode NUMBER;
    v_Handshake  VARCHAR2(10);
  BEGIN
    /* If we don't already have a pipe name, determine one. */
    IF v_CurrentPipeName IS NULL THEN
      v_CurrentPipeName := DBMS_PIPE.UNIQUE_SESSION_NAME;
    END IF;

    /* Send the 'DEBUG' message, along with:
         - pipe name for the handshake
         - description
         - value
    */
    DBMS_PIPE.PACK_MESSAGE('DEBUG');
    DBMS_PIPE.PACK_MESSAGE(v_CurrentPipeName);
    DBMS_PIPE.PACK_MESSAGE(p_Description);
    DBMS_PIPE.PACK_MESSAGE(p_Value);
    v_ReturnCode := DBMS_PIPE.SEND_MESSAGE('DebugPipe');

    IF v_ReturnCode != 0 THEN
      RAISE_APPLICATION_ERROR(-20210,
        'Debug.Debug: SEND_MESSAGE failed with ' || v_ReturnCode);
    END IF;

    /* Wait for the handshake message on the return pipe. */
    v_ReturnCode := DBMS_PIPE.RECEIVE_MESSAGE(v_CurrentPipeName);

    IF v_ReturnCode = 1 THEN
       -- Timeout
      RAISE_APPLICATION_ERROR(-20211,
        'Debug.Debug: No handshake message received');
    ELSIF v_ReturnCode != 0 THEN
      -- Other error
      RAISE_APPLICATION_ERROR(-20212,
        'Debug.Debug: RECEIVE_MESSAGE failed with ' ||
        v_ReturnCode);
    ELSE
      -- Check for the handshake message.
      DBMS_PIPE.UNPACK_MESSAGE(v_Handshake);
      IF v_Handshake = 'Processed' THEN
        -- Output processed.
        NULL;
      ELSE
        -- No handshake
        RAISE_APPLICATION_ERROR(-20213,
          'Debug.Debug: Incorrect handshake message received');
      END IF;
    END IF;
  END Debug;

  PROCEDURE Reset IS
    /* Check to make sure the daemon is running by sending the test
       message over the pipe.  If not, raise an error. */
    v_ReturnCode NUMBER;
  BEGIN
    DBMS_PIPE.PACK_MESSAGE('TEST');
    v_ReturnCode := DBMS_PIPE.SEND_MESSAGE('DebugPipe');

    IF v_ReturnCode != 0 THEN
      RAISE_APPLICATION_ERROR(-20200,
        'Debug.Reset: SEND_MESSAGE failed with ' || v_ReturnCode);
    END IF;

    /* The daemon will respond over the same pipe.  If this call
       times out, then the daemon isn't ready and we should raise
       an error. */
    v_ReturnCode := 
      DBMS_PIPE.RECEIVE_MESSAGE('DebugPipe', v_TimeOut);
    IF v_ReturnCode = 1 THEN
      -- Timeout
      RAISE_APPLICATION_ERROR(-20201,
        'Debug.Reset: Daemon not ready');
    ELSIF v_ReturnCode != 0 THEN
      -- Other error
      RAISE_APPLICATION_ERROR(-20202,
        'Debug.Reset: RECEIVE_MESSAGE failed with ' ||
        v_ReturnCode);
    ELSE
      -- Daemon is ready.
      NULL;
    END IF;
  END Reset;

  PROCEDURE Exit IS
    v_ReturnCode NUMBER;
  BEGIN
    -- Send the 'STOP' message.
    DBMS_PIPE.PACK_MESSAGE('STOP');
    v_ReturnCode := DBMS_PIPE.SEND_MESSAGE('DebugPipe');

    IF v_ReturnCode != 0 THEN
      RAISE_APPLICATION_ERROR(-20230,
        'Debug.Exit: SEND_MESSAGE failed with ' || v_ReturnCode);
    END IF;
  END Exit;

END Debug;
/
