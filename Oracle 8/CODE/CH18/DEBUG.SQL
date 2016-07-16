REM debug.sql
REM Version 1.0, last updated 7/13/97
REM This is the final implementation of the Debug package, using UTL_FILE, as
REM described in Chapter 18 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PACKAGE Debug AS
  /* Global variables to hold the name of the debugging file and
     directory. */
  v_DebugDir VARCHAR2(50);
  v_DebugFile VARCHAR2(20);
  PROCEDURE Debug(p_Description IN VARCHAR2,
                  p_Value IN VARCHAR2);
  PROCEDURE Reset(p_NewFile IN VARCHAR2 := v_DebugFile,
                  p_NewDir IN VARCHAR2 := v_DebugDir) ;
  /* Closes the debugging file. */
  PROCEDURE Close;
END Debug;
/

CREATE OR REPLACE PACKAGE BODY Debug AS
  v_DebugHandle UTL_FILE.FILE_TYPE;

  PROCEDURE Debug(p_Description IN VARCHAR2,
                  p_Value IN VARCHAR2) IS
  BEGIN
    /* Output the info, and flush the file. */
    UTL_FILE.PUTF(v_DebugHandle, '%s: %s\n', p_Description, p_Value);
    UTL_FILE.FFLUSH(v_DebugHandle);
  EXCEPTION
    WHEN UTL_FILE.INVALID_OPERATION THEN
      RAISE_APPLICATION_ERROR(-20102,
                              'Debug: Invalid Operation');
    WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      RAISE_APPLICATION_ERROR(-20103,
                              'Debug: Invalid File Handle');
    WHEN UTL_FILE.WRITE_ERROR THEN
      RAISE_APPLICATION_ERROR(-20104,
                              'Debug: Write Error');
  END Debug;

  PROCEDURE Reset(p_NewFile IN VARCHAR2 := v_DebugFile,
                  p_NewDir IN VARCHAR2 := v_DebugDir) IS
  BEGIN

    /* Make sure the file is closed first. */
    IF UTL_FILE.IS_OPEN(v_DebugHandle) THEN
      UTL_FILE.FCLOSE(v_DebugHandle);
    END IF;

    /* Open the file for writing. */
    v_DebugHandle := UTL_FILE.FOPEN(p_NewDir, p_NewFile, 'w');

    /* Set the packaged variables to the values just passed in. */
    v_DebugFile := p_NewFile;
    v_DebugDir := p_NewDir;
  EXCEPTION
    WHEN UTL_FILE.INVALID_PATH THEN
      RAISE_APPLICATION_ERROR(-20100, 'Reset: Invalid Path');
    WHEN UTL_FILE.INVALID_MODE THEN
      RAISE_APPLICATION_ERROR(-20101, 'Reset: Invalid Mode');
    WHEN UTL_FILE.INVALID_OPERATION THEN
      RAISE_APPLICATION_ERROR(-20101, 'Reset: Invalid Operation');
  END Reset;

  PROCEDURE Close IS
  BEGIN
    UTL_FILE.FCLOSE(v_DebugHandle);
  END Close;

BEGIN
  v_DebugDir := '/tmp';
  v_DebugFile := 'debug.out';
  Reset;
END Debug;
/
