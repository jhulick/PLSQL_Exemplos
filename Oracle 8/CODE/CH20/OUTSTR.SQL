REM outstr.sql
REM Version 1.0, last updated 8/12/97
REM This file contains the wrapper procedures for all the versions of
REM OutputString, as described in Chapter 20 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE OutputString(
  p_Path IN VARCHAR2,
  p_Message IN VARCHAR2) AS EXTERNAL

  LIBRARY stringlib
  NAME "OutputString"
  PARAMETERS (p_Path STRING,
              p_Message STRING);
/

CREATE OR REPLACE PROCEDURE OutputString2(
  p_Path IN VARCHAR2,
  p_Message IN VARCHAR2,
  p_NumLines IN BINARY_INTEGER) AS EXTERNAL

  LIBRARY stringlib
  NAME "OutputString2"
  PARAMETERS (p_Path STRING,
              p_Message STRING,
              p_NumLines INT);
/

CREATE OR REPLACE PROCEDURE OutputString3(
  p_Path IN VARCHAR2,
  p_Message IN VARCHAR2,
  p_NumLines IN BINARY_INTEGER,
  p_NumLinesWritten OUT NATURAL) AS EXTERNAL

  LIBRARY stringlib
  NAME "OutputString3"
  PARAMETERS (p_Path STRING,
              p_Message STRING,
              p_NumLines INT,
              p_NumLinesWritten UB2);
/

CREATE OR REPLACE PROCEDURE OutputString4(
  p_Path IN VARCHAR2,
  p_Message IN VARCHAR2,
  p_NumLines IN BINARY_INTEGER,
  p_NumLinesWritten OUT NATURAL) AS EXTERNAL

  LIBRARY stringlib
  NAME "OutputString4"
  PARAMETERS (p_Path STRING,
              p_Path INDICATOR,
              p_Message STRING,
              p_Message INDICATOR,
              p_NumLines INT,
              p_NumLines INDICATOR,
              p_NumLinesWritten UB2);
/

CREATE OR REPLACE FUNCTION OutputString5(
  p_Path IN VARCHAR2,
  p_Message IN VARCHAR2,
  p_NumLines IN BINARY_INTEGER)
  RETURN NATURAL AS EXTERNAL

  LIBRARY stringlib
  NAME "OutputString5"
  PARAMETERS (p_Path STRING,
              p_Path INDICATOR,
              p_Message STRING,
              p_Message INDICATOR,
              p_NumLines INT,
              p_NumLines INDICATOR,
              RETURN INDICATOR,
              RETURN UB2);
/

CREATE OR REPLACE FUNCTION OutputString6(
  p_Path IN VARCHAR2,
  p_Message IN VARCHAR2,
  p_NumLines IN BINARY_INTEGER)
  RETURN NATURAL AS EXTERNAL

  LIBRARY stringlib
  NAME "OutputString6"
  WITH CONTEXT
  PARAMETERS (CONTEXT,
              p_Path STRING,
              p_Path INDICATOR,
              p_Message STRING,
              p_Message INDICATOR,
              p_NumLines INT,
              p_NumLines INDICATOR,
              RETURN INDICATOR,
              RETURN UB2);
/

CREATE OR REPLACE FUNCTION OutputString7(
  p_Path IN VARCHAR2,
  p_Message IN VARCHAR2,
  p_NumLines IN BINARY_INTEGER)
  RETURN NATURAL AS EXTERNAL

  LIBRARY stringlib
  NAME "OutputString7"
  WITH CONTEXT
  PARAMETERS (CONTEXT,
              p_Path STRING,
              p_Path INDICATOR,
              p_Message STRING,
              p_Message INDICATOR,
              p_NumLines INT,
              p_NumLines INDICATOR,
              RETURN INDICATOR,
              RETURN UB2);
/

