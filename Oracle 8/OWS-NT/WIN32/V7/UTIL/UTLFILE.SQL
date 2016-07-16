Rem 
Rem $Header: utlfile.sql  13-mar-95.02:36:39 dposner Exp $
Rem
Rem utlfile.sql
Rem 
Rem
rem
rem $Header: utlfile.sql  13-mar-95.02:36:39 dposner Exp $
rem
rem  Copyright (c) 1995 by Oracle Corporation
rem    NAME
rem      utlfile.sql - PL/SQL Package of File I/O routines
rem                    Package spec of UTL_FILE
rem
rem    DESCRIPTION
rem      Routines to perform File I/O
rem
rem    NOTES
rem      The procedural option is needed to use this facility.
rem
Rem    MODIFIED   (MM/DD/YY)
Rem    dposner     03/13/95 - Changing integer to binary
Rem    dposner     03/10/95 - UTL_FILE package, icds
Rem    dposner     03/10/95 - Created

REM ********************************************************************
REM THE FUNCTIONS SUPPLIED BY THIS PACKAGE AND ITS EXTERNAL INTERFACE
REM ARE RESERVED BY ORACLE AND ARE SUBJECT TO CHANGE IN FUTURE RELEASES.
REM ********************************************************************

REM ********************************************************************
REM THIS PACKAGE MUST NOT BE MODIFIED BY THE CUSTOMER.  DOING SO
REM THIS PACKAGE MUST NOT BE    dposner    03/13/95 - Changing integer to binar
REM THIS PACKAGE MUST NOT BE    dposner    03/10/95 - UTL_FILE package, icds
REM COULD CAUSE INTERNAL ERRORS AND SECURITY VIOLATIONS IN THE
REM RDBMS.  SPECIFICALLY, THE PSD* ROUTINES MUST NOT BE CALLED
REM DIRECTLY BY ANY CLIENT AND MUST REMAIN PRIVATE TO THE PACKAGE BODY.
REM ********************************************************************

set echo on

CREATE OR REPLACE PACKAGE utl_file AS

  /*
  ** FILE_TYPE - File handle
  */
  TYPE file_type IS RECORD (id BINARY_INTEGER);

  /*
  ** Exceptions
  */
  invalid_path       EXCEPTION;
  invalid_mode       EXCEPTION;
  invalid_filehandle EXCEPTION;
  invalid_operation  EXCEPTION;
  read_error         EXCEPTION;
  write_error        EXCEPTION;
  internal_error     EXCEPTION;


  /*
  ** FOPEN - open file
  **
  ** IN
  **   location  - directory location of file
  **   filename  - file name (including extention)
  **   open_mode - open mode ('r', 'w', 'a')
  ** RETURN
  **   file_type handle to open file
  ** EXCEPTIONS
  **   invalid_path      - file location or name was invalid
  **   invalid_mode      - the open_mode string was invalid
  **   invalid_operation - file could not be opened as requested
  */
  FUNCTION fopen(location  IN VARCHAR2,
                 filename  IN VARCHAR2,
                 open_mode IN VARCHAR2) RETURN file_type;

  /*
  ** IS_OPEN - Test if file handle is open
  **
  ** IN
  **   file - File handle
  ** RETURN
  **   BOOLEAN - Is file handle open/valid?
  */
  FUNCTION is_open(file IN file_type) RETURN BOOLEAN;

  /*
  ** FCLOSE - close an open file
  **
  ** IN
  **   file - File handle (open)
  ** EXCEPTIONS
  **   invalid_filehandle - not a valid file handle
  **   write_error        - OS error occured during write operation
  */
  PROCEDURE fclose(file IN OUT file_type);

  /*
  ** FCLOSE_ALL - close all open files for this session
  **
  ** For Emergency/Cleanup use only.  FILE_TYPE handles will not be
  ** cleared (IS_OPEN will still indicate they are valid)
  **
  ** IN
  **   file - File handle (open)
  ** EXCEPTIONS
  **   write_error        - OS error occured during write operation
  */
  PROCEDURE fclose_all;

  /*
  ** GET_LINE - Get (read) a line of text from the file
  **
  ** IN
  **   file - File handle (open in read mode)
  ** OUT
  **   buffer - next line of text in file
  ** EXCEPTIONS
  **   no_data_found      - reached the end of file
  **   value_error        - line to long to store in buffer
  **   invalid_filehandle - not a valid file handle
  **   invalid_operation  - file is not open for reading
  **   read_error         - OS error occurred during read
  */
  PROCEDURE get_line(file   IN file_type,
                     buffer OUT VARCHAR2);

  /*
  ** PUT - Put (write) text to file
  **
  ** IN
  **   file   - File handle (open in write/append mode)
  **   buffer - Text to write
  ** EXCEPTIONS
  **   invalid_filehandle - not a valid file handle
  **   invalid_operation  - file is not open for writing/appending
  **   write_error        - OS error occured during write operation
  */
  PROCEDURE put(file   IN file_type,
                buffer IN VARCHAR2);

  /*
  ** NEW_LINE - Write line terminators to file
  **
  ** IN
  **   file - File handle (open in write/append mode)
  **   lines - Number of newlines to write (default 1)
  ** EXCEPTIONS
  **   invalid_filehandle - not a valid file handle
  **   invalid_operation  - file is not open for writing/appending
  **   write_error        - OS error occured during write operation
  */
  PROCEDURE new_line(file  IN file_type,
                     lines IN NATURAL := 1);

  /*
  ** PUT_LINE - Put (write) line to file
  **
  ** IN
  **   file   - File handle (open in write/append mode)
  **   buffer - Text to write
  ** EXCEPTIONS
  **   invalid_filehandle - not a valid file handle
  **   invalid_operation  - file is not open for writing/appending
  **   write_error        - OS error occured during write operation
  */
  PROCEDURE put_line(file   IN file_type,
                     buffer IN VARCHAR2);

  /*
  ** PUTF - Put (write) formatted text to file
  **
  ** Format string special characters
  **     '%s' - substitute with next argument
  **     '\n' - newline (line terminator)
  **
  ** IN
  **   file - File handle (open in write/append mode)
  **   format - Formatting string
  **   arg1 - Substitution argument #1
  **   ...
  ** EXCEPTIONS
  **   invalid_filehandle - not a valid file handle
  **   invalid_operation  - file is not open for writing/appending
  **   write_error        - OS error occured during write operation
  */
  procedure putf(file   IN file_type,
                 format IN VARCHAR2,
                 arg1   IN VARCHAR2 DEFAULT NULL,
                 arg2   IN VARCHAR2 DEFAULT NULL,
                 arg3   IN VARCHAR2 DEFAULT NULL,
                 arg4   IN VARCHAR2 DEFAULT NULL,
                 arg5   IN VARCHAR2 DEFAULT NULL);

  /*
  ** FFLUSH - Force physical write of buffered output
  **
  ** IN
  **   file - File handle (open in write/append mode)
  ** EXCEPTIONS
  **   invalid_filehandle - not a valid file handle
  **   invalid_operation  - file is not open for writing/appending
  **   write_error        - OS error occured during write operation
  */
  PROCEDURE fflush(file IN file_type);

END utl_file;
/
show errors
 
