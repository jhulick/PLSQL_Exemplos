REM dumplong.sql
REM Version 1.0, last updated 5/21/97
REM This procedure demonstrates using DBMS_SQL and UTL_FILE to dump the
REM contents of a LONG column to a file, as described in
REM Chapter 15 of _Oracle8 PL/SQL Programming_ by Scott Urman.

PROMPT acsii_docs table...
DROP TABLE ascii_docs;

CREATE TABLE ascii_docs (
  document LONG,
  ID       NUMBER
  );

PROMPT dump_doc function...
CREATE OR REPLACE FUNCTION dump_doc(docid    IN NUMBER,
                                    filename IN VARCHAR2)
                           RETURN VARCHAR2
  IS
    data_chunk          VARCHAR2(254);
    chunk_size          NUMBER:=254;
    chunk_size_returned NUMBER;
    location            VARCHAR2(20) := '/tmp';
    mycursor            NUMBER;
    stmt                VARCHAR2(1024);
    cur_pos             NUMBER:=0;
    rows                NUMBER;
    dummy               NUMBER;
    file_handle         UTL_FILE.FILE_TYPE;
    status              VARCHAR2(50);
  BEGIN
     file_handle:=utl_file.fopen(location,filename,'w');
         -- open the file for writing

     stmt:='SELECT DOCUMENT FROM ASCII_DOCS WHERE ID = :doctoget';

     mycursor:=dbms_sql.open_cursor;
     dbms_sql.parse(mycursor, stmt, dbms_sql.v7);
     dbms_sql.bind_variable(mycursor, ':doctoget', docid);
         -- bind the doctoget host variable with the plsql parameter docid
         -- which is passed into the function

     dbms_sql.define_column_long(mycursor,1);
     dummy:=dbms_sql.execute(mycursor);
     rows:=dbms_sql.fetch_rows(mycursor);
         -- only doing one fetch for the primary key as assuming the whole
         -- document is stored in one row
     loop
         -- fetch 'chunks' of the long until we have got the lot
       dbms_sql.column_value_long(mycursor,
                                  1,
                                  chunk_size,
                                  cur_pos,
                                  data_chunk,
                                  chunk_size_returned);
       utl_file.put(file_handle, data_chunk);
       cur_pos:=cur_pos + chunk_size;
       exit when chunk_size_returned = 0;
     end loop;
     dbms_sql.close_cursor(mycursor);
     utl_file.fclose(file_handle);
     return('Success');
  EXCEPTION
    WHEN OTHERS THEN
       utl_file.fclose(file_handle);
       return ('Failure');
  END dump_doc;
/
