REM export.sql
REM Version 1.0, last updated 5/9/97
REM This package implements a 'PL/SQL schema exporter'.  It will query
REM the data dictionary views all_source, all_objects and/or all_triggers
REM to determine the source code for PL/SQL objects of type PROCEDURE,
REM FUNCTION, PACKAGE, PACKAGE BODY, or TRIGGER, and then write them out
REM to a file using UTL_FILE.  This file can then be read in using SQL*Plus
REM to recreate the objects.

REM Because this package uses both UTL_FILE and cursor variables, it requires
REM PL/SQL 2.3 (Oracle 7.3) or higher.  For more information, see
REM Chapter 8 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PACKAGE Export AS

  /* Exports one object.  The parameters are used as follows:
   * p_Schema:    Specifies the owner of the object to be exported
   * p_ObjType:   Specifies the type of the object.  Valid values are 'PACKAGE',
   *              'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', or 'TRIGGER'.  If NULL,
   *              then the object type is determined by selecting from all_objects.
   * p_BothTypes: If TRUE, when p_ObjType = 'PACKAGE' both the package and package
   *              body will be exported.
   * p_FileDir:   Directory where the output file should be created.
   * p_FileName:  Name of the output file.
   * p_Mode:      Mode (either 'A' to append or 'W' to write) of the output file.
   */ 
  PROCEDURE OneObj(p_Schema IN VARCHAR2,
                   p_ObjName IN VARCHAR2,
                   p_ObjType IN VARCHAR2 DEFAULT NULL,
                   p_BothTypes IN BOOLEAN DEFAULT TRUE, 
                   p_FileDir IN VARCHAR2,
                   p_FileName IN VARCHAR2,
                   p_Mode IN VARCHAR2);
                   
  /* Exports all objects of a given type.  The parameters are used as follows:
   * p_Schema:    Specifies the owner of the objects to be exported
   * p_ObjType:   Specifies the type of the object.  Valid values are 'PACKAGE',
   *              'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', or 'TRIGGER'.  If
                  specified, than all objects owned by p_Schema of the given type
                  will be exported.  If NULL, then all PL/SQL objects owned by
                  p_Schema will be exported.
   * p_FileDir:   Directory where the output file should be created.
   * p_FileName:  Name of the output file.
   * p_Mode:      Mode (either 'A' to append or 'W' to write) of the output file.
   */
  PROCEDURE AllObjs(p_Schema IN VARCHAR2,
                    p_ObjType IN VARCHAR2 DEFAULT NULL,
                    p_FileDir IN VARCHAR2,
                    p_FileName IN VARCHAR2,
                    p_Mode IN VARCHAR2);
END Export;
/

CREATE OR REPLACE PACKAGE BODY Export AS
  
  /* This is the work horse procedure for the package.  OutputObj will output one
   * object, specified by p_Schema, p_ObjName, and p_ObjType, to the file specified
   * by p_FileHandle.  The file must have already been opened for writing
   * (in 'W' or 'A' mode).
   */
  PROCEDURE OutputObj(p_FileHandle IN OUT UTL_FILE.FILE_TYPE,
                      p_Schema IN VARCHAR2,
                      p_ObjName IN VARCHAR2,
                      p_ObjType IN VARCHAR2) IS

    /* These variables are used to retreive the trigger text. Since all_triggers
     * stores a trigger body as a LONG, we have to use DBMS_SQL to fetch the long
     * in chunks.  */
    v_SQLStmt VARCHAR2(200) :=
      'SELECT description, trigger_body
         FROM all_triggers
         WHERE owner = :v_owner
         AND trigger_name = :v_name';
    v_Cursor         INTEGER;
    v_NumRows        INTEGER;
    v_Dummy          INTEGER;
    v_Description    all_triggers.description%TYPE;
    v_BodyChunk      VARCHAR2(100);
    v_ChunkSize      NUMBER := 100;
    v_CurPos         NUMBER := 0;
    v_ReturnedLength NUMBER := 0;

    /* These variables are used to retrieve the source for other types of objects.
     * DBMS_SQL is not necessary here, since all_source stores each line of source
     * separately.
     */
    v_TextLine all_source.text%TYPE;
    CURSOR c_ObjCur IS
      SELECT text
        FROM all_source
        WHERE owner = p_Schema
        AND name = p_ObjName
        AND type = p_ObjType
        ORDER BY line;

  BEGIN
    -- First, write the 'CREATE OR REPLACE ' to the file.
    UTL_FILE.PUT(p_FileHandle, 'CREATE OR REPLACE ');
    
    IF (p_ObjType = 'TRIGGER') THEN
      BEGIN
        -- Output the object type (TRIGGER in this case) to the file.
        UTL_FILE.PUT(p_FileHandle, 'TRIGGER ');
        
        -- Open the cursor and parse the statement.
        v_Cursor := DBMS_SQL.OPEN_CURSOR;
        DBMS_SQL.PARSE(v_Cursor, v_SQLStmt, DBMS_SQL.V7);
        
        -- Bind the input variables to the placeholders.
        DBMS_SQL.BIND_VARIABLE(v_Cursor, ':v_owner', p_Schema);
        DBMS_SQL.BIND_VARIABLE(v_Cursor, ':v_name', p_Objname);
        
        -- Define the output variables.  Note the use of DEFINE_COLUMN_LONG for
        -- the trigger body text.
        DBMS_SQL.DEFINE_COLUMN(v_Cursor, 1, v_Description, 2000);
        DBMS_SQL.DEFINE_COLUMN_LONG(v_Cursor, 2);
        
        -- Execute the statement, and fetch the row.  We don't have to fetch in a 
        -- loop since there is only one row per trigger.
        v_Dummy := DBMS_SQL.EXECUTE(v_Cursor);
        v_NumRows := DBMS_SQL.FETCH_ROWS(v_Cursor);
        
        -- Retreive the value for the trigger description, and output it to the file.
        -- Note that we can use UTL_FILE.PUT rather than UTL_FILE.PUT_LINE, since the
        -- table contains the trailing newline character.
        DBMS_SQL.COLUMN_VALUE(v_Cursor, 1, v_Description);
        UTL_FILE.PUT(p_FileHandle, v_Description);
        
        -- Loop until we've retreived the entire trigger body.  We will retreive
        -- v_ChunkSize characters each loop iteration.
        LOOP
          DBMS_SQL.COLUMN_VALUE_LONG(v_Cursor, 2, v_ChunkSize, v_CurPos,
                                     v_BodyChunk, v_ReturnedLength);
                                     
          IF v_ReturnedLength < v_ChunkSize THEN
            -- We've just retreived the last chunk.  For some reason, an extra NULL
            -- character is stored in the table after the newline.  So we need to
            -- remove it first.
            v_BodyChunk := SUBSTR(v_BodyChunk, 1, LENGTH(v_BodyChunk) - 1);
            
            -- Output the trimmed chunk, and exit the loop.
            UTL_FILE.PUT(p_FileHandle, v_BodyChunk);
            EXIT;
          ELSE
            -- We've retreived a chunk from the middle of the long.  Output it to the
            -- file, and update the current position for the next loop iteration.
            UTL_FILE.PUT(p_FileHandle, v_BodyChunk);
            v_CurPos := v_CurPos + v_ReturnedLength;
          END IF;
        END LOOP;
        
        -- Close the cursor, since we're finished the processing.
        DBMS_SQL.CLOSE_CURSOR(v_Cursor);
      EXCEPTION
        WHEN OTHERS THEN
          -- For all errors, first close the cursor, then re-raise the exception for
          -- handling in the calling environment.
          DBMS_SQL.CLOSE_CURSOR(v_Cursor);
          RAISE;
        END;
    ELSE
      -- If we get here, we are not outputting a trigger.  So we can just loop through 
      -- the source lines in all_source, and output each one.
      -- Note that the first line will be the type and object name, plus 'IS' or 'AS'.
      OPEN c_ObjCur;
      LOOP
        FETCH c_ObjCur INTO v_TextLine;
        EXIT WHEN c_ObjCur%NOTFOUND;
        
        -- Each line already contains a trailing newline character, so we can just use
        -- UTL_FILE.PUT rather than UTL_FILE.PUT_LINE.
        UTL_FILE.PUT(p_FileHandle, v_TextLine);
      END LOOP;
      CLOSE c_ObjCur;
    END IF;

    -- Output the final '/'.
    UTL_FILE.PUT_LINE(p_FileHandle, '/');
  END OutputObj;  
  
  PROCEDURE OneObj(p_Schema IN VARCHAR2,
                   p_ObjName IN VARCHAR2,
                   p_ObjType IN VARCHAR2 DEFAULT NULL,
                   p_BothTypes IN BOOLEAN DEFAULT TRUE,
                   p_FileDir IN VARCHAR2,
                   p_FileName IN VARCHAR2,
                   p_Mode IN VARCHAR2) IS
    v_FileHandle UTL_FILE.FILE_TYPE;
    v_ObjType all_objects.object_type%TYPE;
  BEGIN
    -- Validate the input parameters.
    IF p_BothTypes AND (p_ObjType != 'PACKAGE') THEN
      RAISE_APPLICATION_ERROR(-20000,
        'Export.OneObj: BothTypes set but type != PACKAGE');
    ELSIF p_ObjType IS NOT NULL AND p_ObjType NOT IN
          ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', 'TRIGGER') THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Export.OneObj: Illegal value ' || p_ObjType || ' for object type');
    ELSIF p_FileDir IS NULL OR p_FileName IS NULL or p_Mode IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002,
        'Export.OneObj: Directory, Filename and Mode must be non-NULL');
    ELSIF p_Mode NOT IN ('A', 'a', 'W', 'w') THEN
      RAISE_APPLICATION_ERROR(-20003,
        'Export.OneObj: Mode ' || p_Mode || ' not ''A'' or ''W''');
    END IF;
    
    -- Determine the correct object type, and insure that the object
    -- exists.
    BEGIN
      IF p_ObjType IS NULL THEN
        -- No object type specified - check for existence whithout 
        -- specifying the type.
        SELECT object_type
          INTO v_ObjType
          FROM all_objects
          WHERE owner = UPPER(p_Schema)
          AND object_name = UPPER(p_Objname)
          AND object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE',
                              'PACKAGE BODY', 'TRIGGER');
      ELSIF p_BothTypes THEN
        -- BothTypes specified - check for existence of package header
        -- first.
        SELECT object_type
          INTO v_ObjType
          FROM all_objects
          WHERE owner = UPPER(p_Schema)
          AND object_name = UPPER(p_Objname)
          AND object_type = 'PACKAGE';
        
        -- Now check for the package body.
        BEGIN
          SELECT object_type
            INTO v_ObjType
            FROM all_objects
            WHERE owner = UPPER(p_Schema)
            AND object_name = UPPER(p_Objname)
            AND object_type = 'PACKAGE BODY';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20006,
              'Export.ObjObj: BothTypes set but package body ' ||
              p_Schema || '.' || p_Objname || ' not found');
        END;
      ELSE
        -- Object type specified, Bothtypes not specified - check for
        -- existence using object type.
        SELECT object_type
          INTO v_ObjType
          FROM all_objects
          WHERE owner = UPPER(p_Schema)
          AND object_name = UPPER(p_Objname)
          AND object_type = p_ObjType;
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004,
          'Export.OneObj: Object ' || p_Schema || '.' || p_Objname || 
          ' not found');
      WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20005,
          'Export.OneObj: More than one match for ' || p_Schema || '.' ||
          p_Objname);
    END;

    -- If we get to this point, we know that the object exists, so we can
    -- open the file and write to it.  If the mode is 'A', then write 2
    -- blank lines first.
    v_FileHandle := UTL_FILE.FOPEN(p_FileDir, p_FileName, p_Mode);
    IF p_Mode IN ('A', 'a') THEN
      UTL_FILE.NEW_LINE(v_FileHandle, 2);
    END IF;
    
    -- Output the object.  
    IF p_ObjType = 'PACKAGE' AND p_BothTypes THEN
      OutputObj(v_FileHandle, p_Schema, p_ObjName, 'PACKAGE');
      UTL_FILE.NEW_LINE(v_FileHandle, 2);
      OutputObj(v_FileHandle, p_Schema, p_ObjName, 'PACKAGE BODY');
    ELSE
      OutputObj(v_FileHandle, p_Schema, p_ObjName, v_ObjType);
    END IF;

    -- Close the output file.    
    UTL_FILE.FCLOSE(v_FileHandle);
  EXCEPTION
    -- Handle the UTL_FILE exceptions meaningfully, and make sure
    -- that the file is properly closed.
    WHEN UTL_FILE.INVALID_PATH THEN
      UTL_FILE.FCLOSE(v_FileHandle);
      RAISE_APPLICATION_ERROR(-20010,
                              'Export.OneObj: Invalid Path');
    WHEN UTL_FILE.INVALID_OPERATION THEN
      UTL_FILE.FCLOSE(v_FileHandle);
      RAISE_APPLICATION_ERROR(-20010,
                              'Export.OneObj: Invalid Operation');
    WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      UTL_FILE.FCLOSE(v_FileHandle);
      RAISE_APPLICATION_ERROR(-20010,
                              'Export.OneObj: Invalid File Handle');
    WHEN UTL_FILE.WRITE_ERROR THEN
      UTL_FILE.FCLOSE(v_FileHandle);
      RAISE_APPLICATION_ERROR(-20010,
                              'Export.OneObj: Write Error');
    WHEN UTL_FILE.INTERNAL_ERROR THEN
      UTL_FILE.FCLOSE(v_FileHandle);
      RAISE_APPLICATION_ERROR(-20010,
                              'Export.OneObj: Internal Error');
    WHEN OTHERS THEN
      UTL_FILE.FCLOSE(v_FileHandle);
      RAISE;
  END OneObj;
  
  PROCEDURE AllObjs(p_Schema IN VARCHAR2,
                    p_ObjType IN VARCHAR2 DEFAULT NULL,
                    p_FileDir IN VARCHAR2,
                    p_FileName IN VARCHAR2,
                    p_Mode IN VARCHAR2) IS
    v_FileHandle UTL_FILE.FILE_TYPE;
    v_ObjName all_objects.object_name%TYPE;
    v_ObjType all_objects.object_type%TYPE;
    v_ObjectFound BOOLEAN := FALSE;
    
    -- Use a cursor variable for the query, since it can take two forms.
    TYPE t_AllObjs IS REF CURSOR;
    c_AllObjsCur t_AllObjs;
    
  BEGIN
    -- Validate the input parameters.
    IF p_ObjType IS NOT NULL AND p_ObjType NOT IN
          ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', 'TRIGGER') THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Export.AllObjs: Illegal value ' || p_ObjType || ' for object type');
    ELSIF p_FileDir IS NULL OR p_FileName IS NULL or p_Mode IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002,
        'Export.AllObjs: Directory, Filename and Mode must be non-NULL');
    ELSIF p_Mode NOT IN ('A', 'a', 'W', 'w') THEN
      RAISE_APPLICATION_ERROR(-20003,
        'Export.AllObjs: Mode ' || p_Mode || ' not ''A'' or ''W''');
    END IF;

    -- If the object type isn't specified, then open the cursor for
    -- querying all objects owned by p_Schema.  If it is, then open the
    -- cursor for querying only that type of object.
    IF p_ObjType IS NULL THEN
      OPEN c_AllObjsCur FOR
        SELECT object_name, object_type
          FROM all_objects
          WHERE owner = UPPER(p_Schema)
          AND object_type in ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION',
                              'TRIGGER');
    ELSE
      OPEN c_AllObjsCur FOR
        SELECT object_name, object_type
          FROM all_objects
          WHERE owner = UPPER(p_Schema)
          AND object_type = p_ObjType;
    END IF;
    
    -- Loop over all objects matching the selection criteria, and output
    -- each one, with 2 blank lines in between.
    LOOP
      FETCH c_AllObjsCur INTO v_ObjName, v_ObjType;
      EXIT WHEN c_AllObjsCur%NOTFOUND;

      IF NOT v_ObjectFound THEN
        -- We've found at least one object matching the input parameters.
        -- Open the file, and if the mode is 'A' write 2
        -- blank lines first.
        v_ObjectFound := TRUE;
        v_FileHandle := UTL_FILE.FOPEN(p_FileDir, p_FileName, p_Mode);
        IF p_Mode IN ('A', 'a') THEN
          UTL_FILE.NEW_LINE(v_FileHandle, 2);
        END IF;
      END IF;
      
      OutputObj(v_FileHandle, p_Schema, v_ObjName, v_ObjType);
      UTL_FILE.NEW_LINE(v_FileHandle, 2);
    END LOOP;
    
    -- Check for a found object, and close the cursor and file handle.
    CLOSE c_AllObjsCur;
    IF NOT v_ObjectFound THEN
      RAISE_APPLICATION_ERROR(-20004,
          'Export.AllObjs: No objects found');
    END IF;
    UTL_FILE.FCLOSE(v_FileHandle);
  EXCEPTION
    -- Handle the UTL_FILE exceptions meaningfully, and make sure
    -- that the file is properly closed.
    WHEN UTL_FILE.INVALID_PATH THEN
      UTL_FILE.FCLOSE(v_FileHandle);
      RAISE_APPLICATION_ERROR(-20010,
                              'Export.AllObjs: Invalid Path');
    WHEN UTL_FILE.INVALID_OPERATION THEN
      UTL_FILE.FCLOSE(v_FileHandle);
      RAISE_APPLICATION_ERROR(-20010,
                              'Export.AllObjs: Invalid Operation');
    WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      UTL_FILE.FCLOSE(v_FileHandle);
      RAISE_APPLICATION_ERROR(-20010,
                              'Export.AllObjs: Invalid File Handle');
    WHEN UTL_FILE.WRITE_ERROR THEN
      UTL_FILE.FCLOSE(v_FileHandle);
      RAISE_APPLICATION_ERROR(-20010,
                              'Export.AllObjs: Write Error');
    WHEN OTHERS THEN
      UTL_FILE.FCLOSE(v_FileHandle);
      RAISE;
  END AllObjs;
END Export;
/
