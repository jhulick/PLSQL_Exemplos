DROP TABLE multi_alert_tab;

CREATE TABLE multi_alert_tab (
  sequence_no NUMBER,
  alert_name VARCHAR2(30),
  time_sent DATE,
  message_element1 VARCHAR2(500),
  message_element2 NUMBER
  );

DROP SEQUENCE multi_alert_seq;

CREATE SEQUENCE multi_alert_seq
  START WITH 1
  INCREMENT BY 1;

Idea here: on each call to signal, insert a row into table indexed by alert name.
Then on each call to wait, query the table first, and return that row if exists (then
delete), otherwise call dbms_alert.wait.  Problems:
- have to lock the rows by selecting for update on a wait
- want to preserve the behavior that an alert can be received by multiple waiters
   - this possibly requires a reference count in the table, which means that the
     wait call may have to commit.  Hm...


CREATE OR REPLACE PACAKGE MultiAlert AS
  TYPE t_AlertMessage IS RECORD (
    message_element1 multi_alert_tab.message_element1%TYPE,
    messate_element2 multi_alert_tab.message_element2%TYPE
  );

  PROCEDURE Register(p_AlertName IN VARCHAR2);
  PROCEDURE Remove(p_AlertName IN VARCHAR2);
  PROCEDURE RemoveAll;
  PROCEDURE WaitAny(p_AlertName OUT VARCHAR2,
                    p_Message OUT t_AlertMessage,
                    p_TimeSent OUT DATE,
                    p_Status OUT INTEGER,
                    p_Timeout IN NUMBER DEFAULT DBMS_ALERT.MAXWAIT);
  PROCEDURE WaitOne(p_AlertName IN VARCHAR2,
                    p_Message OUT t_AlertMessage,
                    p_TimeSent OUT DATE,
                    p_Status OUT INTEGER,
                    p_Timeout IN NUMBER DEFAULT DBMS_ALERT.MAXWAIT);
  PROCEDURE Signal(p_AlertName IN VARCHAR2,
                   p_Message IN t_AlertMessage);
END MultiAlert;
/

CREATE OR REPLACE PACKAGE BODY MultiAlert AS

  PROCEDURE Register(p_AlertName IN VARCHAR2) IS
  BEGIN
    DBMS_ALERT.REGISTER(p_AlertName);
  END Register;

  PROCEDURE Remove(p_AlertName IN VARCHAR2) IS
  BEGIN
    DBMS_ALERT.REMOVE(p_AlertName);
  END Remove;

  PROCEDURE RemoveAll IS
  BEGIN
    DBMS_ALERT.REMOVEALL;
  END RemoveAll;

  PROCEDURE WaitAny(p_AlertName OUT VARCHAR2,
                    p_Message OUT t_AlertMessage,
                    p_TimeSent OUT DATE,
                    p_Status OUT INTEGER,
                    p_Timeout IN NUMBER DEFAULT DBMS_ALERT.MAXWAIT) IS
  BEGIN

  END WaitAny;

  PROCEDURE WaitOne(p_AlertName IN VARCHAR2,
                    p_Message OUT t_AlertMessage,
                    p_TimeSent OUT DATE,
                    p_Status OUT INTEGER,
                    p_Timeout IN NUMBER DEFAULT DBMS_ALERT.MAXWAIT);
  PROCEDURE Signal(p_AlertName IN VARCHAR2,
                   p_Message IN t_AlertMessage);
END MultiAlert;
/
