REM imagemap.sql
REM Version 1.0, last updated 6/24/97
REM The Imagemap package demonstrates one way of handling image maps, using
REM the OWA_IMAGE package, as described in Chapter 19 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PACKAGE Imagemap AS
  PROCEDURE Go;
  PROCEDURE Process(p_Img IN OWA_IMAGE.POINT);
END Imagemap;
/

CREATE OR REPLACE PACKAGE BODY Imagemap AS
  -- Set c_ImagePath to the virtual path on your server where the
  -- boxes.gif file has been stored.
  c_ImagePath CONSTANT VARCHAR2(50) := '/ows-img/boxes.gif';

  -- Set c_OWAPath to the virtual path (including the DCD) where
  -- the Oracle Web Agent is installed.
  c_OWAPath CONSTANT VARCHAR2(50) := '/example/owa/';

  PROCEDURE ShowBoxes IS
  BEGIN
    HTP.p('Click anywhere on the image below.' || HTF.para);

    -- Set up a form with one clickable image.  The target of this
    -- image is the Process procedure.  Since the type of this form
    -- field is an image, the p_Img parameter will be passed a
    -- value of type OWA_IMAGE.POINT.
    HTP.formOpen(curl => c_OWAPath || 'Imagemap.Process');
    HTP.formImage(cname => 'p_Img',
                  csrc => c_ImagePath,
                  cattributes => 'BORDER=0');
    HTP.formClose;
  END ShowBoxes;

  PROCEDURE Go IS
  BEGIN
    HTP.htmlOpen;
    HTP.headOpen;
    HTP.title('Imagemap test');
    HTP.headClose;

    HTP.bodyOpen;
    ShowBoxes;
    HTP.bodyClose;
    HTP.htmlClose;
  END Go;

  PROCEDURE Process(p_Img IN OWA_IMAGE.POINT) IS
    v_x INTEGER := OWA_IMAGE.GET_X(p_Img);
    v_y INTEGER := OWA_IMAGE.GET_Y(p_Img);
    v_Color VARCHAR2(5);
  BEGIN
    IF v_x < 200 THEN
      IF v_y < 100 THEN
        v_Color := 'Blue';
      ELSE
        v_Color := 'Red';
      END IF;
    ELSE
      IF v_y < 100 THEN
        v_Color := 'Green';
      ELSE
        v_Color := 'Black';
      END IF;
    END IF;

    HTP.htmlOpen;
    HTP.headOpen;
    HTP.title('Imagemap results');
    HTP.headClose;

    HTP.bodyOpen;
    HTP.print('Processed.  X = ' || v_x || ' and Y = ' || v_y);
    HTP.print('.  This means that you selected the ' || v_Color);
    HTP.print(' box.' || HTF.para);

    ShowBoxes;
    HTP.bodyClose;
    HTP.htmlClose;
  END Process;

END Imagemap;
/
