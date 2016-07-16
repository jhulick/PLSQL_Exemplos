This directory contains the example code used in Oracle8 PL/SQL Programming.
The contents of this directory are:

ch01: Introduction
  3gl_4gl.sql:  Some 3GL and 4GL features of PL/SQL
  error.sql:    Error handling
  simple.sql:   A simple loop
  numeric.sql:  A numeric FOR loop
  tables.sql:   Creates the tables used in the examples
  tables8.sql:  Creates the tables necessary for the Oracle8 examples

ch02: PL/SQL Basics
  anon.sql:     An anonymous PL/SQL block
  labeled.sql:  A named PL/SQL block
  proc.sql:     A stored procedure
  trigger.sql:  A database trigger
  allthree.sql: An anonymous block with all three sections
  comments.sql: Different types of comments
  if1.sql:      Using the IF THEN statement
  if2.sql:      An IF THEN statement with >1 procedural statements within it
  simple.sql:   A simple loop
  exitwhen.sql: Using EXIT WHEN to break out of a loop
  while1.sql:   A WHILE loop
  forloop.sql:  A FOR loop
  forscope.sql: Scoping rules in a FOR loop
  goto.sql:     Using GOTO to implement a loop
  null.sql:     Using NULL as a statement

ch03: Records & Tables
  assign.sql:   Illustrates legal and illegal record assignments
  select.sql:   Assigning to a record with a SELECT statement
  tabrec.sql:   A table of records
  count.sql:    Using the COUNT table attribute
  delete.sql:   Using the DELETE table attribute
  exists.sql:   Using the EXISTS table attribute
  frstlast.sql: Using the FIRST and LAST table attributes
  nxtprior.sql: Using the NEXT and PRIOR table attributes
  nulltab.sql:  Deleting a table by assigning a NULL table to it

ch04: SQL Within PL/SQL
  bindvar.sql:  A SQL statement with a bind variable
  select.sql:   Some SELECT statements
  insert.sql:   Some INSERT statements
  update.sql:   An UPDATE statement
  1trans.sql:   A transaction starting before a PL/SQL block
  1block.sql:   A PL/SQL block with multiple transctions

ch05: Builtin SQL Functions
  spelchek.sql: PL/SQL At Work: Printing numbers as text words

ch06: Cursors
  curexamp.sql: First cursor example
  binds.sql:    Illustrates how bind variables are used
  badfetch.sql: Legal and illegal FETCH statements
  nomatch1.sql: Using SQL%NOTFOUND for an UPDATE which matches no rows
  nomatch2.sql: Using SQL%ROWCOUNT for an UPDATE which matches no rows
  nodata.sql:   SQL%NOTFOUND vs. NO_DATA_FOUND
  simple.sql:   A simple fetch loop
  exitwhen.sql: Incorrect usage of the EXIT WHEN clause
  while.sql:    A fetch loop using WHILE..LOOP syntax
  forloop.sql:  A cursor FOR loop
  forupdat.sql: Using SELECT..FOR UPDATE
  commit1.sql:  ORA-1002 with COMMIT inside SELECT..FOR UPDATE loop
  commit2.sql:  Avoiding the ORA-1002 error
  cursor1.pc:   Pro*C program illustrating cursor variables
  cursor2.sql:  PL/SQL program illustrating cursor variables

ch07: Subprograms: Procedures and Functions
  addstud.sql:  The AddNewStudent example procedure
  callproc.sql: Calling AddNewStudent
  modetest.sql: The ModeTest procedure, illustrating parameter modes
  plength.sql:  ParameterLength procedure, illustrating parameter constraints
  callme.sql:   CallMe procedure, illustrating positional and named notation
  default.sql:  Using default values for formal parameters
  almostfl.sql: The AlmostFull function
  callfunc.sql: Calling AlmostFull
  clasinfo.sql: The ClassInfo function, illustrating multiple RETURN statements
  error.sql:    Parameter behavior if a procedure raises an unhandled exception
  local.sql:    A block with a local subprogram
  local2.sql:   A block with a local subprogram in an illegal position
  mutual.sql:   A block with mutually referential subprograms
  forward.sql:  Using forward declarations
  rfclass.sql:  The RecordFullClasses procedure

ch08: Packages
  clpack.sql:   The ClassPackage package example
  cllist.sql:   Calling the packaged procedure ClassPackage.ClassList
  overload.sql: ClassPackage with an overloaded procedure
  random.sql:   A random number generator illustrating package initialization
  depend.sql:   Script which illustrates dependencies among schema objects
  fullname.sql: Function which can be called from SQL statements
  studops.sql:  StudentOps package which illustrates RESTRICT_REFERENCES
  export.sql:   PL/SQL at Work: A PL/SQL schema exporter

ch09: Triggers
  updateMS.sql: Trigger which keeps major_stats in sync with students
  samename.sql: Trigger with the same name as a table
  instead.sql:  An instead-of trigger
  order.sql:    Demonstrates the order of trigger firing
  pseudo.sql:   Example which shows that :new and :old are pseudo records
  studID.sql:   The GenerateStudentID trigger
  RSchange.sql: Trigger which uses INSERTING, UPDATING & DELETING
  RSinsert.sql: Legal trigger which modifies a referential table
  mutating.sql: Avoiding the mutating table error

ch10: Error Handling
  raise.sql:    Raising a user-defined exception
  handle.sql:   Handling a user-defined exception
  others.sql:   The WHEN OTHERS exception handler
  sqlerrm.sql:  Using SQLERRM and SQLCODE inside a WHEN OTHERS handler
  sqlerrm2.sql: Different uses of SQLERRM
  pragma.sql:   Using the EXCEPTION_INIT pragma
  register.sql: Register procedure, demonstrates RAISE_APPLICATION_ERROR
  abc1.sql:     Initial usage of DBMS_UTILITY.FORMAT_CALL_STACK
  e_pkg.sql:    PL/SQL at Work: A general error handler
  e_tables.sql: Tables necessary for the ErrorPkg package
  abc2.sql:     Example of using ErrorPkg

ch11: Object Types
  objinit.sql:  Creating and initializing objects
  aname.sql:    AssignName procedure, demonstrates NULL-ness of objects
  mcall.sql:    Calling object methods
  prcnttyp.sql: Using %TYPE with objects
  error.sql:    The ErrorObj object, demonstrates exceptions with objects
  alter.sql:    Using ALTER TYPE on object types
  odepend.sql:  Some dependent objects
  update.sql:   Using objects in an UPDATE statement
  colsel.sql:   Using column objects in SELECT statements
  valueop.sql:  Using the VALUE operator
  refop.sql:    Using the REF and DEREF operators
  return.sql:   Using the RETURNING clause

ch12: Collections
  nested.sql:   Some nested table declarations
  tconstr.sql:  Nested table constructors
  nulltab.sql:  Behavior of NULL nested tables
  tassign.sql:  Assigning to elements of nested tables
  tinsert.sql:  Using a nested table in an INSERT statement
  tupdate.sql:  Using a nested table in an UPDATE statement
  tdelete.sql:  Using a nested table in a DELETE statement
  tselect.sql:  Using a nested table in a SELECT statement
  vconstr.sql:  Varray constructors
  vassign.sql:  Assigning to varray elements
  checkout.sql: The CheckOut procedure, demonstrating varrays in SQL
  co.sql:       Example of using CheckOut
  exists.sql:   The EXISTS collection method
  count.sql:    The COUNT collection method
  limit.sql:    The LIMIT collection method
  loops.sql:    The FIRST, LAST, NEXT, and PRIOR collection methods
  extend.sql:   The EXTEND collection method
  extdel.sql:   Interaction between EXTEND and DELETE
  trim.sql:     The TRIM collection method
  delete.sql:   The DELETE collection method

ch13: PL/SQL Execution Environments
  call_reg.sql: SQL*Plus script for calling Register
  call_reg.pc:  Pro*C fragment for calling Register
  indicator.pc: Pro*C fragment illustrating indicator variables
  error.pc:     Pro*C fragment illustrating error handling
  oci.c:        OCI program which calls Register

ch14: Testing and Debugging
  avgrade1.sql: First version of the AverageGrade function
  debug1.sql:   Debug package which inserts into a table
  avgrade2.sql: Second version AverageGrade, with some debugging
  avgrade3.sql: Third version AverageGrade, with more debugging
  avgrade4.sql: Final version of the AverageGrade function
  output.sql:   Using DBMS_OUTPUT.PUT_LINE and DBMS_OUTPUT.GET_LINES
  cntcred1.sql: First version of the CountCredits function
  debug2.sql:   Debug package which uses DBMS_OUTPUT
  cntcred2.sql: Second version of CountCredits, with some debugging
  cntcred3.sql: Third version of CountCredits, with more debugging
  cntcred4.sql: Final vesrion of the CountCredits function
  crloop1.sql:  First version of the CreditLoop procedure

ch15: Dynamic PL/SQL
  recrtemp.sql: RecreateTempTable procedure, demonstrating DBMS_SQL
  updclass.sql: UpdateClasses, demonstrating DBMS_SQL for DML statements
  recrtmp2.sql: RecreateTempTable demonstrating DBMS_SQL for DDL statements
  dquery.sql:   DynamicQuery demonstrating DBMS_SQL for queries
  dynPLSQL.sql: DynamicPLSQL demonstrating DBMS_SQL for blocks
  execany.sql:  PL/SQL at Work: Executing arbitrary stored procedures
  testpkg.sql:  Test package for the ExecuteAny package
  anyexamp.sql: Example script for the ExecuteAny package
  copyRS.sql:   CopyRegisteredStudents, demonstrates DBMS_SQL array processing
  descrtab.sql: DescribeTable, demonstrates DBMS_SQL.DESCRIBE_TABLE
  dumplong.sql: PL/SQL at Work: Writing a LONG to a File

ch16: Intersession Communication
  logRSins.sql: LogRSInserts trigger
  RSinsert.sql: Pro*C reader which works with LogRSInserts
  debug.pc:     Pro*C deamon for the Debug package
  debug.sql:    A debugging package using DBMS_PIPE

ch17: Advanced Queuing
  createq.sql:  Creates the data structures necessary for the examples
  simple.sql:   Simple enqueueing and dequeing on a FIFO queue
  clearq.sql:   The ClearQueue procedure, dequeues all the messages
  priority.sql: Enqueuing and Dequeing on a priority queue
  ident.sql:    Using correlation and message identifiers
  searchq.sql:  The SearchQueue function, demonstrates queue browsing
  except.sql:   Demonstrates the use of exception queues
  dropq.sql:    Drops the data structures used in the examples

ch18: Database Jobs and File I/O
  tmpins.sql:   The TempInsert procedure, used for DBMS_JOB examples
  tmpins1.sql:  Alternate version of TempInsert which modifies next_date
  debug.sql:    Debug package which uses UTL_FILE
  loadstud.sql: The LoadStudents procedure
  calcGPA.sql:  The CalculateGPA procedure

ch19: The Oracle Web Server
  bodydemo.sql: Demonstrates some of the body formatting procedures
  hello.sql:    A simple example
  prntdemo.sql: Demonstrates how to use the HTP.PRINT procedure
  listdemo.sql: The ListDemo package, demonstrates different HTML lists
  chardemo.sql: The CharDemo procedure, demonstrates character formatting tags
  formdemo.sql: The FormDemo package, demonstrates HTML forms
  tabldemo.sql: The TableDemo procedure, demonstrates HTML tables
  utildemo.sql: The UtilDemo procedure, demonstrates OWA_UTIL HTML utilities
  dyndemo.sql:  The DynamicDemo package, demonstrates OWA_UTIL dynamic SQL
  imagemap.sql: A package which processes image maps
  boxes.gif:    Graphic file for use with the Imagemap package
  cookie.sql:   The CookieDemo procedure, demonstrates OWA_COOKIE

ch20: External Procedures
  listener.ora: Sample listener.ora file for the SQL*Net listener
  tnsnames.ora: Sample tnsnames.ora file specifying extproc connect string
  outstr.sql:   Wrapper procedures for all versions of OutputString
  outstr.c:     C implementation for all versions of OutputString
  dbgextp.sql:  Package debug_extproc, aids in debugging external procedures

ch21: Large Objects
  lobdml.sql:   Demonstrates some DML operations on internal LOBs
  bfiledml.sql: Demonstrates some DML operations on external LOBs
  lobtest.sql:  Populates the lobdemo table for the DBMS_LOB examples
  lobcopy.sql:  Demonstrates the DBMS_LOB.COPY routine
  fileexec.sql: The FileExec procedure, demonstrates BFILE operations
  inserts.sql:  Sample file for FileExec
  lobprint.sql: The LOBPrint procedure, demonstrates DBMS_LOB.READ
  lobtrim.sql:  Demonstrates the DBMS_LOB.TRIM routine
  long2lob.sql: PL/SQL at Work: Copying LONG data into a LOB
  l2ltest.sql:  Sample data and example of Long2Lob
