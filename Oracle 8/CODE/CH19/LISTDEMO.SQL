REM listdemo.sql
REM Version 1.0, last updated 7/15/97
REM This package illustrates different kinds of HTML lists, as described in
REM Chapter 19 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PACKAGE ListDemo AS
  PROCEDURE Go;
  PROCEDURE ShowList(p_ListType IN CHAR);
END ListDemo;
/

CREATE OR REPLACE PACKAGE BODY ListDemo AS
  -- Set c_OWAPath to the virtual path (including the DCD) where
  -- the Oracle Web Agent is installed.
  c_OWAPath CONSTANT VARCHAR2(50) := '/example/owa/';

  -- Presents the user with the available list types.
  PROCEDURE ShowChoices IS
    c_ListPath VARCHAR2(100) := c_OWAPATH || 'ListDemo.ShowList?p_ListType=';
  BEGIN
    HTP.line;
    HTP.p('Click on any of the following links to see the students ');
    HTP.p('in the specified list type.' || HTF.para);

    HTP.anchor(c_ListPath || 'U', 'Unordered');
    HTP.anchor(c_ListPath || 'O', 'Ordered');
    HTP.anchor(c_ListPath || 'M', 'Menu');
    HTP.anchor(c_ListPath || 'D', 'Directory');
  END ShowChoices;

  -- Presents the first and last names of the students in the specified
  -- list type.
  PROCEDURE ShowList(p_ListType IN CHAR) IS
    v_Title VARCHAR2(20);
    v_ListOpen VARCHAR2(10);
    v_ListClose VARCHAR2(10);
    CURSOR c_Names IS
      SELECT first_name || ' ' || last_name name
        FROM students
        ORDER BY last_name;
  BEGIN
    IF p_ListType = 'U' THEN
      v_Title := 'Unordered List';
      v_ListOpen := HTF.ulistOpen;
      v_ListClose := HTF.ulistClose;
    ELSIF p_ListType = 'O' THEN
      v_Title := 'Ordered List';
      v_ListOpen := HTF.olistOpen;
      v_ListClose := HTF.olistClose;
    ELSIF p_ListType = 'M' THEN
      v_Title := 'Menu List';
      v_ListOpen := HTF.menulistOpen;
      v_ListClose := HTF.menulistClose;
    ELSIF p_ListType = 'D' THEN
      v_Title := 'Directory List';
      v_ListOpen := HTF.dirlistOpen;
      v_ListClose := HTF.dirlistClose;
    END IF;
    HTP.htmlOpen;
    HTP.headOpen;
    HTP.title(v_Title);
    HTP.headClose;

    HTP.bodyOpen;
    -- Output the list itself.
    HTP.p(v_ListOpen);
    FOR v_NamesRec IN c_Names LOOP
      HTP.listItem(v_NamesRec.name);
    END LOOP;
    HTP.p(v_ListClose);

    -- Output the choices.
    ShowChoices;

    OWA_UTIL.signature('ListDemo.ShowList');
    HTP.bodyClose;
  END ShowList;


  PROCEDURE Go IS
  BEGIN
    HTP.htmlOpen;
    HTP.headOpen;
    HTP.title('List Demo');
    HTP.headClose;

    HTP.bodyOpen;
    HTP.header(2, 'Welcome to the list demo');
    ShowChoices;
    OWA_UTIL.signature('ListDemo.Go');
    HTP.bodyClose;
    HTP.htmlClose;
  END Go;
END ListDemo;
/
