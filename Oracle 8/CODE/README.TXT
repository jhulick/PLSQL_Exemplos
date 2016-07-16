Este directório contém os exemplos de código utilizados no Oracle8: Programação em PL/SQL.
O conteúdo deste directório é o seguinte:

ch01: Introdução
  3gl_4gl.sql:  Algumas funcionalidades de 3GL e 4GL do PL/SQL
  error.sql:    Tratamento de erros
  simple.sql:   Um ciclo simples
  numeric.sql:  Um ciclo FOR numérico
  tables.sql:   Cria as tabelas utilizadas nos exemplos
  tables8.sql:  Cria as tabelas necessárias para os exemplos do Oracle8

ch02: Conceitos básicos de PL/SQL
  anon.sql:     Um bloco de PL/SQL anónimo
  labeled.sql:  Um bloco de PL/SQL nomeado
  proc.sql:     Um procedimento armazenado
  trigger.sql:  Um trigger da base de dados
  allthree.sql: Um bloco anónimo com as três secções
  comments.sql: Diferentes tipos de comentários
  if1.sql:      Utilização da instrução IF THEN
  if2.sql:      Uma instrução IF THEN com instruções de procedimentos >1
  simple.sql:   Um ciclo simples
  exitwhen.sql: Utilização de EXIT WHEN para sair de um ciclo
  while1.sql:   Um ciclo WHILE
  forloop.sql:  Um ciclo FOR
  forscope.sql: Regras de âmbito num ciclo FOR
  goto.sql:     Utilização de GOTO para implementar um ciclo
  null.sql:     Utilização de NULL como instrução

ch03: Registos e tabelas
  assign.sql:   Ilustra atribuições de registos legais e ilegais
  select.sql:   Atribuição a um registo com uma instrução SELECT
  tabrec.sql:   Uma tabela de registos
  count.sql:    Utilização do atributo de tabela COUNT
  delete.sql:   Utilização do atributo de tabela DELETE
  exists.sql:   Utilização do atributo de tabela EXISTS
  frstlast.sql: Utilização dos atributos de tabela FIRST e LAST
  nxtprior.sql: Utilização dos atributos de tabela NEXT e PRIOR
  nulltab.sql:  Apagamento de uma tabela atribuindo-lhe uma tabela NULL

ch04: SQL no PL/SQL
  bindvar.sql:  Uma instrução de SQL com uma variável de associação
  select.sql:   Algumas instruções SELECT
  insert.sql:   Algumas instruções INSERT
  update.sql:   Uma instrução UPDATE
  1trans.sql:   Uma transacção com início antes de um bloco de PL/SQL
  1block.sql:   Um bloco de PL/SQL com várias transacções

ch05: Funções de SQL integradas
  spelchek.sql: PL/SQL em funcionamento: Imprimir números como palavras de texto

ch06: Cursores
  curexamp.sql: Primeiro exemplo de cursor
  binds.sql:    Ilustra o modo como são utilizadas as variáveis de associação
  badfetch.sql: Instruções FETCH legais e ilegais
  nomatch1.sql: Utilização de SQL%NOTFOUND para um UPDATE que não corresponde a nenhuma linha
  nomatch2.sql: Utilização de SQL%ROWCOUNT para um UPDATE que não corresponde a nenhuma linha
  nodata.sql:   SQL%NOTFOUND versus NO_DATA_FOUND
  simple.sql:   Um ciclo de extracção simples
  exitwhen.sql: Utilização incorrecta da cláusula EXIT WHEN
  while.sql:    Um ciclo de extracção utilizando a sintaxe WHILE..LOOP
  forloop.sql:  Um ciclo FOR do cursor
  forupdat.sql: Utilização de SELECT..FOR UPDATE
  commit1.sql:  ORA-1002 com COMMIT dentro de um ciclo SELECT..FOR UPDATE
  commit2.sql:  Evitar o erro ORA-1002
  cursor1.pc:   Programa Pro*C ilustrando as variáveis de cursor
  cursor2.sql:  Programa de PL/SQL ilustrando as variáveis de cursor

ch07: Subprogramas: Procedimentos e funções
  addstud.sql:  O procedimento de exemplo AddNewStudent
  callproc.sql: Chamada de AddNewStudent
  modetest.sql: O procedimento ModeTest, que ilustra os modos de parâmetros
  plength.sql:  Procedimento ParameterLength, que ilustra as restrições de parâmetros 
  callme.sql:   Procedimento CallMe, que ilustra a notação posicional e nomeada
  default.sql:  Utilização de valores por omissão para parâmetros formais
  almostfl.sql: A função AlmostFull
  callfunc.sql: Chamada de AlmostFull
  clasinfo.sql: A função ClassInfo, que ilustra várias instruções RETURN
  error.sql:    Comportamento dos parâmetros se um procedimento abrir uma excepção não tratada
  local.sql:    Um bloco com um subprograma local
  local2.sql:   Um bloco com um subprograma local numa posição ilegal
  mutual.sql:   Um bloco com subprogramas mutuamente referenciais
  forward.sql:  Utilização de declarações de encaminhamento
  rfclass.sql:  O procedimento RecordFullClasses

ch08: Pacotes
  clpack.sql:   O exemplo de pacote ClassPackage
  cllist.sql:   Chamada do procedimento empacotado ClassPackage.ClassList
  overload.sql: ClassPackage com um procedimento sobrecarregado
  random.sql:   Um gerador de números não sequenciais, que ilustra a inicialização de pacotes
  depend.sql:   Ficheiro de comandos que ilustra as dependências entre objectos schema
  fullname.sql: Função que pode ser chamada a partir de instruções de SQL
  studops.sql:  Pacote StudentOps que ilustra RESTRICT_REFERENCES
  export.sql:   PL/SQL em funcionamento: Um exportador de schemas de PL/SQL

ch09: Triggers
  updateMS.sql: Trigger que mantém major_stats em sincronia com students
  samename.sql: Trigger com o mesmo nome que uma tabela
  instead.sql:  Um trigger instead-of
  order.sql:    Demonstra a ordem de disparo dos triggers
  pseudo.sql:   Exemplo que mostra que :new e :old são pseudo-registos
  studID.sql:   O trigger GenerateStudentID
  RSchange.sql: Trigger que utiliza INSERTING, UPDATING e DELETING
  RSinsert.sql: Trigger legal que modifica uma tabela referencial
  mutating.sql: Evitar o erro da tabela mutante

ch10: Tratamento de erros 
  raise.sql:    Abertura de uma excepção definida pelo utilizador
  handle.sql:   Tratamento de uma excepção definida pelo utilizador 
  others.sql:   A rotina de tratamento de excepções WHEN OTHERS
  sqlerrm.sql:  Utilização de SQLERRM e SQLCODE dentro de uma rotina de tratamento WHEN OTHERS
  sqlerrm2.sql: Diferentes utilizações de SQLERRM
  pragma.sql:   Utilização da pragma EXCEPTION_INIT
  register.sql: Procedimento Register, que demonstra RAISE_APPLICATION_ERROR
  abc1.sql:     Utilização inicial de DBMS_UTILITY.FORMAT_CALL_STACK
  e_pkg.sql:    PL/SQL em funcionamento: Uma rotina de tratamento de erros geral
  e_tables.sql: Tabelas necessárias para o pacote ErrorPkg
  abc2.sql:     Exemplo de utilização de ErrorPkg

ch11: Objectos
  objinit.sql:  Criação e inicialização de objectos
  aname.sql:    Procedimento AssignName, que demonstra a presença de NULL nos objectos
  mcall.sql:    Chamada de métodos de objectos
  prcnttyp.sql: Utilização de %TYPE com objectos
  error.sql:    O objecto ErrorObj, que demonstra as excepções com objectos
  alter.sql:    Utilização de ALTER TYPE em tipos de objecto
  odepend.sql:  Alguns objectos dependentes
  update.sql:   Utilização de objectos numa instrução UPDATE
  colsel.sql:   Utilização de objectos de coluna em instruções SELECT
  valueop.sql:  Utilização do operador VALUE
  refop.sql:    Utilização dos operadores REF e DEREF
  return.sql:   Utilização da cláusula RETURNING

ch12: Recolhas
  nested.sql:   Algumas declarações de tabelas encadeadas
  tconstr.sql:  Criadores de tabelas encadeadas
  nulltab.sql:  Comportamento das tabelas encadeadas NULL
  tassign.sql:  Atribuição a elementos de tabelas encadeadas
  tinsert.sql:  Utilização de uma tabela encadeada numa instrução INSERT
  tupdate.sql:  Utilização de uma tabela encadeada numa instrução UPDATE 
  tdelete.sql:  Utilização de uma tabela encadeada numa instrução DELETE
  tselect.sql:  Utilização de uma tabela encadeada numa instrução SELECT
  vconstr.sql:  Criadores de matrizes v 
  vassign.sql:  Atribuição a elementos de matrizes v 
  checkout.sql: O procedimento CheckOut, que demonstra as matrizes v em SQL
  co.sql:       Exemplo de utilização de CheckOut
  exists.sql:   O método de recolha EXISTS
  count.sql:    O método de recolha COUNT
  limit.sql:    O método de recolha LIMIT
  loops.sql:    Os métodos de recolha FIRST, LAST, NEXT e PRIOR
  extend.sql:   O método de recolha EXTEND
  extdel.sql:   Interacção entre EXTEND e DELETE
  trim.sql:     O método de recolha TRIM
  delete.sql:   O método de recolha DELETE

ch13: Ambientes de execução de PL/SQL
  call_reg.sql: Ficheiro de comandos de SQL*Plus para chamar Register
  call_reg.pc:  Fragmento de Pro*C para chamar Register
  indicator.pc: Fragmento de Pro*C que ilustra as variáveis de indicador
  error.pc:     Fragmento de Pro*C que ilustra o tratamento de erros 
  oci.c:        Programa da OCI que chama o Register

ch14: Testar e depurar
  avgrade1.sql: Primeira versão da função AverageGrade
  debug1.sql:   Pacote Debug que insere numa tabela
  avgrade2.sql: Segunda versão de AverageGrade, com alguma depuração
  avgrade3.sql: Terceira versão de AverageGrade, com mais depuração
  avgrade4.sql: Versão final da função AverageGrade
  output.sql:   Utilização de DBMS_OUTPUT.PUT_LINE e DBMS_OUTPUT.GET_LINES
  cntcred1.sql: Primeira versão da função CountCredits
  debug2.sql:   Pacote Debug que utiliza DBMS_OUTPUT
  cntcred2.sql: Segunda versão de CountCredits, com alguma depuração
  cntcred3.sql: Terceira versão de CountCredits, com mais depuração
  cntcred4.sql: Versão final da função CountCredits
  crloop1.sql:  Primeira versão do procedimento CreditLoop

ch15: PL/SQL dinâmico
  recrtemp.sql: Procedimento RecreateTempTable,que demonstra o DBMS_SQL
  updclass.sql: UpdateClasses, que demonstra o DBMS_SQL para instruções de DML
  recrtmp2.sql: RecreateTempTable, que demonstra o DBMS_SQL para instruções de DDL
  dquery.sql:   DynamicQuery, que demonstra o DBMS_SQL para consultas
  dynPLSQL.sql: DynamicPLSQL que demonstra o DBMS_SQL para blocos
  execany.sql:  PL/SQL em funcionamento: Executar procedimentos armazenados arbitrários
  testpkg.sql:  Pacote de teste para o pacote ExecuteAny
  anyexamp.sql: Exemplo de ficheiro de comandos para o pacote ExecuteAny
  copyRS.sql:   CopyRegisteredStudents, que demonstra o processamento matricial do DBMS_SQL 
  descrtab.sql: DescribeTable, que demonstra DBMS_SQL.DESCRIBE_TABLE
  dumplong.sql: PL/SQL em funcionamento: Escrever um LONG num FILE

ch16: Comunicação entre sessões
  logRSins.sql: Trigger LogRSInserts
  RSinsert.sql: Leitor de Pro*C que funciona com LogRSInserts
  debug.pc:     Daemon de Pro*C para o pacote Debug
  debug.sql:    Um pacote de depuração que utiliza o DBMS_PIPE

ch17: Advanced Queuing
  createq.sql:  Cria as estruturas de dados necessárias para os exemplos
  simple.sql:   Colocação e remoção simples numa fila de espera FIFO
  clearq.sql:   O procedimento ClearQueue retira todas as mensagens da fila de espera
  priority.sql: Colocação e remoção numa fila de espera com prioridades
  ident.sql:    Utilização de identificadores de mensagem e de correlação
  searchq.sql:  A função SearchQueue, que demonstra como percorrer uma fila de espera 
  except.sql:   Demonstra a utilização de filas de espera de excepções
  dropq.sql:    Suprime as estruturas de dados utilizadas nos exemplos

ch18: Tarefas da base de dados e E/S de ficheiros
  tmpins.sql:   O procedimento TempInsert utilizado para os exemplos de DBMS_JOB
  tmpins1.sql:  Versão alternativa do TempInsert que modifica next_date
  debug.sql:    Pacote Debug que utiliza o UTL_FILE
  loadstud.sql: O procedimento LoadStudents
  calcGPA.sql:  O procedimento CalculateGPA

ch19: O programa Oracle WebServer
  bodydemo.sql: Demonstra alguns dos procedimentos de formatação do corpo 
  hello.sql:    Um exemplo simples
  prntdemo.sql: Demonstra como utilizar o procedimento HTP.PRINT
  listdemo.sql: O pacote ListDemo, que demonstra diferentes listas de HTML
  chardemo.sql: O procedimento CharDemo, que demonstra os identificadores de formatação de caracteres
  formdemo.sql: O pacote FormDemo, que demonstra as fichas de HTML
  tabldemo.sql: O procedimento TableDemo, que demonstra as tabelas de HTML
  utildemo.sql: O procedimento UtilDemo, que demonstra os utilitários de HTML do OWA_UTIL
  dyndemo.sql:  O pacote DynamicDemo, que demonstra o SQL dinâmico do OWA_UTIL
  imagemap.sql: Um pacote que processa mapas de imagens
  boxes.gif:    Ficheiro gráfico para utilizar com o pacote Imagemap
  cookie.sql:   O procedimento CookieDemo, que demonstra o OWA_COOKIE

ch20: Procedimentos externos 
  listener.ora: Ficheiro listener.ora exemplificativo para o listener de SQL*Net
  tnsnames.ora: Ficheiro tnsnames.ora exemplificativo que especifica a cadeia de caracteres de ligação extproc
  outstr.sql:   Procedimentos do wrapper para todas as versões de OutputString
  outstr.c:     Implementação de C para todas as versões de OutputString
  dbgextp.sql:  Pacote debug_extproc, que ajuda na depuração de procedimentos externos

ch21: Large Objects
  lobdml.sql:   Demonstra algumas operações de DML em LOBs internos
  bfiledml.sql: Demonstra algumas operações de DML em LOBs externos
  lobtest.sql:  Preenche a tabela lobdemo para os exemplos de DBMS_LOB
  lobcopy.sql:  Demonstra a rotina DBMS_LOB.COPY
  fileexec.sql: O procedimento FileExec, que demonstra operações BFILE
  inserts.sql:  Ficheiro exemplificativo para FileExec
  lobprint.sql: O procedimento LOBPrint, que demonstra DBMS_LOB.READ
  lobtrim.sql:  Demonstra a rotina DBMS_LOB.TRIM 
  long2lob.sql: PL/SQL em funcionamento: Copiar dados LONG para um LOB
  l2ltest.sql:  Dados exemplificativos e exemplo de Long2Lob
