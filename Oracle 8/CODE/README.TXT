Este direct�rio cont�m os exemplos de c�digo utilizados no Oracle8: Programa��o em PL/SQL.
O conte�do deste direct�rio � o seguinte:

ch01: Introdu��o
  3gl_4gl.sql:  Algumas funcionalidades de 3GL e 4GL do PL/SQL
  error.sql:    Tratamento de erros
  simple.sql:   Um ciclo simples
  numeric.sql:  Um ciclo FOR num�rico
  tables.sql:   Cria as tabelas utilizadas nos exemplos
  tables8.sql:  Cria as tabelas necess�rias para os exemplos do Oracle8

ch02: Conceitos b�sicos de PL/SQL
  anon.sql:     Um bloco de PL/SQL an�nimo
  labeled.sql:  Um bloco de PL/SQL nomeado
  proc.sql:     Um procedimento armazenado
  trigger.sql:  Um trigger da base de dados
  allthree.sql: Um bloco an�nimo com as tr�s sec��es
  comments.sql: Diferentes tipos de coment�rios
  if1.sql:      Utiliza��o da instru��o IF THEN
  if2.sql:      Uma instru��o IF THEN com instru��es de procedimentos >1
  simple.sql:   Um ciclo simples
  exitwhen.sql: Utiliza��o de EXIT WHEN para sair de um ciclo
  while1.sql:   Um ciclo WHILE
  forloop.sql:  Um ciclo FOR
  forscope.sql: Regras de �mbito num ciclo FOR
  goto.sql:     Utiliza��o de GOTO para implementar um ciclo
  null.sql:     Utiliza��o de NULL como instru��o

ch03: Registos e tabelas
  assign.sql:   Ilustra atribui��es de registos legais e ilegais
  select.sql:   Atribui��o a um registo com uma instru��o SELECT
  tabrec.sql:   Uma tabela de registos
  count.sql:    Utiliza��o do atributo de tabela COUNT
  delete.sql:   Utiliza��o do atributo de tabela DELETE
  exists.sql:   Utiliza��o do atributo de tabela EXISTS
  frstlast.sql: Utiliza��o dos atributos de tabela FIRST e LAST
  nxtprior.sql: Utiliza��o dos atributos de tabela NEXT e PRIOR
  nulltab.sql:  Apagamento de uma tabela atribuindo-lhe uma tabela NULL

ch04: SQL no PL/SQL
  bindvar.sql:  Uma instru��o de SQL com uma vari�vel de associa��o
  select.sql:   Algumas instru��es SELECT
  insert.sql:   Algumas instru��es INSERT
  update.sql:   Uma instru��o UPDATE
  1trans.sql:   Uma transac��o com in�cio antes de um bloco de PL/SQL
  1block.sql:   Um bloco de PL/SQL com v�rias transac��es

ch05: Fun��es de SQL integradas
  spelchek.sql: PL/SQL em funcionamento: Imprimir n�meros como palavras de texto

ch06: Cursores
  curexamp.sql: Primeiro exemplo de cursor
  binds.sql:    Ilustra o modo como s�o utilizadas as vari�veis de associa��o
  badfetch.sql: Instru��es FETCH legais e ilegais
  nomatch1.sql: Utiliza��o de SQL%NOTFOUND para um UPDATE que n�o corresponde a nenhuma linha
  nomatch2.sql: Utiliza��o de SQL%ROWCOUNT para um UPDATE que n�o corresponde a nenhuma linha
  nodata.sql:   SQL%NOTFOUND versus NO_DATA_FOUND
  simple.sql:   Um ciclo de extrac��o simples
  exitwhen.sql: Utiliza��o incorrecta da cl�usula EXIT WHEN
  while.sql:    Um ciclo de extrac��o utilizando a sintaxe WHILE..LOOP
  forloop.sql:  Um ciclo FOR do cursor
  forupdat.sql: Utiliza��o de SELECT..FOR UPDATE
  commit1.sql:  ORA-1002 com COMMIT dentro de um ciclo SELECT..FOR UPDATE
  commit2.sql:  Evitar o erro ORA-1002
  cursor1.pc:   Programa Pro*C ilustrando as vari�veis de cursor
  cursor2.sql:  Programa de PL/SQL ilustrando as vari�veis de cursor

ch07: Subprogramas: Procedimentos e fun��es
  addstud.sql:  O procedimento de exemplo AddNewStudent
  callproc.sql: Chamada de AddNewStudent
  modetest.sql: O procedimento ModeTest, que ilustra os modos de par�metros
  plength.sql:  Procedimento ParameterLength, que ilustra as restri��es de par�metros 
  callme.sql:   Procedimento CallMe, que ilustra a nota��o posicional e nomeada
  default.sql:  Utiliza��o de valores por omiss�o para par�metros formais
  almostfl.sql: A fun��o AlmostFull
  callfunc.sql: Chamada de AlmostFull
  clasinfo.sql: A fun��o ClassInfo, que ilustra v�rias instru��es RETURN
  error.sql:    Comportamento dos par�metros se um procedimento abrir uma excep��o n�o tratada
  local.sql:    Um bloco com um subprograma local
  local2.sql:   Um bloco com um subprograma local numa posi��o ilegal
  mutual.sql:   Um bloco com subprogramas mutuamente referenciais
  forward.sql:  Utiliza��o de declara��es de encaminhamento
  rfclass.sql:  O procedimento RecordFullClasses

ch08: Pacotes
  clpack.sql:   O exemplo de pacote ClassPackage
  cllist.sql:   Chamada do procedimento empacotado ClassPackage.ClassList
  overload.sql: ClassPackage com um procedimento sobrecarregado
  random.sql:   Um gerador de n�meros n�o sequenciais, que ilustra a inicializa��o de pacotes
  depend.sql:   Ficheiro de comandos que ilustra as depend�ncias entre objectos schema
  fullname.sql: Fun��o que pode ser chamada a partir de instru��es de SQL
  studops.sql:  Pacote StudentOps que ilustra RESTRICT_REFERENCES
  export.sql:   PL/SQL em funcionamento: Um exportador de schemas de PL/SQL

ch09: Triggers
  updateMS.sql: Trigger que mant�m major_stats em sincronia com students
  samename.sql: Trigger com o mesmo nome que uma tabela
  instead.sql:  Um trigger instead-of
  order.sql:    Demonstra a ordem de disparo dos triggers
  pseudo.sql:   Exemplo que mostra que :new e :old s�o pseudo-registos
  studID.sql:   O trigger GenerateStudentID
  RSchange.sql: Trigger que utiliza INSERTING, UPDATING e DELETING
  RSinsert.sql: Trigger legal que modifica uma tabela referencial
  mutating.sql: Evitar o erro da tabela mutante

ch10: Tratamento de erros 
  raise.sql:    Abertura de uma excep��o definida pelo utilizador
  handle.sql:   Tratamento de uma excep��o definida pelo utilizador 
  others.sql:   A rotina de tratamento de excep��es WHEN OTHERS
  sqlerrm.sql:  Utiliza��o de SQLERRM e SQLCODE dentro de uma rotina de tratamento WHEN OTHERS
  sqlerrm2.sql: Diferentes utiliza��es de SQLERRM
  pragma.sql:   Utiliza��o da pragma EXCEPTION_INIT
  register.sql: Procedimento Register, que demonstra RAISE_APPLICATION_ERROR
  abc1.sql:     Utiliza��o inicial de DBMS_UTILITY.FORMAT_CALL_STACK
  e_pkg.sql:    PL/SQL em funcionamento: Uma rotina de tratamento de erros geral
  e_tables.sql: Tabelas necess�rias para o pacote ErrorPkg
  abc2.sql:     Exemplo de utiliza��o de ErrorPkg

ch11: Objectos
  objinit.sql:  Cria��o e inicializa��o de objectos
  aname.sql:    Procedimento AssignName, que demonstra a presen�a de NULL nos objectos
  mcall.sql:    Chamada de m�todos de objectos
  prcnttyp.sql: Utiliza��o de %TYPE com objectos
  error.sql:    O objecto ErrorObj, que demonstra as excep��es com objectos
  alter.sql:    Utiliza��o de ALTER TYPE em tipos de objecto
  odepend.sql:  Alguns objectos dependentes
  update.sql:   Utiliza��o de objectos numa instru��o UPDATE
  colsel.sql:   Utiliza��o de objectos de coluna em instru��es SELECT
  valueop.sql:  Utiliza��o do operador VALUE
  refop.sql:    Utiliza��o dos operadores REF e DEREF
  return.sql:   Utiliza��o da cl�usula RETURNING

ch12: Recolhas
  nested.sql:   Algumas declara��es de tabelas encadeadas
  tconstr.sql:  Criadores de tabelas encadeadas
  nulltab.sql:  Comportamento das tabelas encadeadas NULL
  tassign.sql:  Atribui��o a elementos de tabelas encadeadas
  tinsert.sql:  Utiliza��o de uma tabela encadeada numa instru��o INSERT
  tupdate.sql:  Utiliza��o de uma tabela encadeada numa instru��o UPDATE 
  tdelete.sql:  Utiliza��o de uma tabela encadeada numa instru��o DELETE
  tselect.sql:  Utiliza��o de uma tabela encadeada numa instru��o SELECT
  vconstr.sql:  Criadores de matrizes v 
  vassign.sql:  Atribui��o a elementos de matrizes v 
  checkout.sql: O procedimento CheckOut, que demonstra as matrizes v em SQL
  co.sql:       Exemplo de utiliza��o de CheckOut
  exists.sql:   O m�todo de recolha EXISTS
  count.sql:    O m�todo de recolha COUNT
  limit.sql:    O m�todo de recolha LIMIT
  loops.sql:    Os m�todos de recolha FIRST, LAST, NEXT e PRIOR
  extend.sql:   O m�todo de recolha EXTEND
  extdel.sql:   Interac��o entre EXTEND e DELETE
  trim.sql:     O m�todo de recolha TRIM
  delete.sql:   O m�todo de recolha DELETE

ch13: Ambientes de execu��o de PL/SQL
  call_reg.sql: Ficheiro de comandos de SQL*Plus para chamar Register
  call_reg.pc:  Fragmento de Pro*C para chamar Register
  indicator.pc: Fragmento de Pro*C que ilustra as vari�veis de indicador
  error.pc:     Fragmento de Pro*C que ilustra o tratamento de erros 
  oci.c:        Programa da OCI que chama o Register

ch14: Testar e depurar
  avgrade1.sql: Primeira vers�o da fun��o AverageGrade
  debug1.sql:   Pacote Debug que insere numa tabela
  avgrade2.sql: Segunda vers�o de AverageGrade, com alguma depura��o
  avgrade3.sql: Terceira vers�o de AverageGrade, com mais depura��o
  avgrade4.sql: Vers�o final da fun��o AverageGrade
  output.sql:   Utiliza��o de DBMS_OUTPUT.PUT_LINE e DBMS_OUTPUT.GET_LINES
  cntcred1.sql: Primeira vers�o da fun��o CountCredits
  debug2.sql:   Pacote Debug que utiliza DBMS_OUTPUT
  cntcred2.sql: Segunda vers�o de CountCredits, com alguma depura��o
  cntcred3.sql: Terceira vers�o de CountCredits, com mais depura��o
  cntcred4.sql: Vers�o final da fun��o CountCredits
  crloop1.sql:  Primeira vers�o do procedimento CreditLoop

ch15: PL/SQL din�mico
  recrtemp.sql: Procedimento RecreateTempTable,que demonstra o DBMS_SQL
  updclass.sql: UpdateClasses, que demonstra o DBMS_SQL para instru��es de DML
  recrtmp2.sql: RecreateTempTable, que demonstra o DBMS_SQL para instru��es de DDL
  dquery.sql:   DynamicQuery, que demonstra o DBMS_SQL para consultas
  dynPLSQL.sql: DynamicPLSQL que demonstra o DBMS_SQL para blocos
  execany.sql:  PL/SQL em funcionamento: Executar procedimentos armazenados arbitr�rios
  testpkg.sql:  Pacote de teste para o pacote ExecuteAny
  anyexamp.sql: Exemplo de ficheiro de comandos para o pacote ExecuteAny
  copyRS.sql:   CopyRegisteredStudents, que demonstra o processamento matricial do DBMS_SQL 
  descrtab.sql: DescribeTable, que demonstra DBMS_SQL.DESCRIBE_TABLE
  dumplong.sql: PL/SQL em funcionamento: Escrever um LONG num FILE

ch16: Comunica��o entre sess�es
  logRSins.sql: Trigger LogRSInserts
  RSinsert.sql: Leitor de Pro*C que funciona com LogRSInserts
  debug.pc:     Daemon de Pro*C para o pacote Debug
  debug.sql:    Um pacote de depura��o que utiliza o DBMS_PIPE

ch17: Advanced Queuing
  createq.sql:  Cria as estruturas de dados necess�rias para os exemplos
  simple.sql:   Coloca��o e remo��o simples numa fila de espera FIFO
  clearq.sql:   O procedimento ClearQueue retira todas as mensagens da fila de espera
  priority.sql: Coloca��o e remo��o numa fila de espera com prioridades
  ident.sql:    Utiliza��o de identificadores de mensagem e de correla��o
  searchq.sql:  A fun��o SearchQueue, que demonstra como percorrer uma fila de espera 
  except.sql:   Demonstra a utiliza��o de filas de espera de excep��es
  dropq.sql:    Suprime as estruturas de dados utilizadas nos exemplos

ch18: Tarefas da base de dados e E/S de ficheiros
  tmpins.sql:   O procedimento TempInsert utilizado para os exemplos de DBMS_JOB
  tmpins1.sql:  Vers�o alternativa do TempInsert que modifica next_date
  debug.sql:    Pacote Debug que utiliza o UTL_FILE
  loadstud.sql: O procedimento LoadStudents
  calcGPA.sql:  O procedimento CalculateGPA

ch19: O programa Oracle WebServer
  bodydemo.sql: Demonstra alguns dos procedimentos de formata��o do corpo 
  hello.sql:    Um exemplo simples
  prntdemo.sql: Demonstra como utilizar o procedimento HTP.PRINT
  listdemo.sql: O pacote ListDemo, que demonstra diferentes listas de HTML
  chardemo.sql: O procedimento CharDemo, que demonstra os identificadores de formata��o de caracteres
  formdemo.sql: O pacote FormDemo, que demonstra as fichas de HTML
  tabldemo.sql: O procedimento TableDemo, que demonstra as tabelas de HTML
  utildemo.sql: O procedimento UtilDemo, que demonstra os utilit�rios de HTML do OWA_UTIL
  dyndemo.sql:  O pacote DynamicDemo, que demonstra o SQL din�mico do OWA_UTIL
  imagemap.sql: Um pacote que processa mapas de imagens
  boxes.gif:    Ficheiro gr�fico para utilizar com o pacote Imagemap
  cookie.sql:   O procedimento CookieDemo, que demonstra o OWA_COOKIE

ch20: Procedimentos externos 
  listener.ora: Ficheiro listener.ora exemplificativo para o listener de SQL*Net
  tnsnames.ora: Ficheiro tnsnames.ora exemplificativo que especifica a cadeia de caracteres de liga��o extproc
  outstr.sql:   Procedimentos do wrapper para todas as vers�es de OutputString
  outstr.c:     Implementa��o de C para todas as vers�es de OutputString
  dbgextp.sql:  Pacote debug_extproc, que ajuda na depura��o de procedimentos externos

ch21: Large Objects
  lobdml.sql:   Demonstra algumas opera��es de DML em LOBs internos
  bfiledml.sql: Demonstra algumas opera��es de DML em LOBs externos
  lobtest.sql:  Preenche a tabela lobdemo para os exemplos de DBMS_LOB
  lobcopy.sql:  Demonstra a rotina DBMS_LOB.COPY
  fileexec.sql: O procedimento FileExec, que demonstra opera��es BFILE
  inserts.sql:  Ficheiro exemplificativo para FileExec
  lobprint.sql: O procedimento LOBPrint, que demonstra DBMS_LOB.READ
  lobtrim.sql:  Demonstra a rotina DBMS_LOB.TRIM 
  long2lob.sql: PL/SQL em funcionamento: Copiar dados LONG para um LOB
  l2ltest.sql:  Dados exemplificativos e exemplo de Long2Lob
