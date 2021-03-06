Notas da vers�o revista do Oracle WebServer para Windows NT

Vers�o 2.1.0.3.1 Produ��o
Janeiro de 1997

A vers�o revista 2.1 do Oracle WebServer suporta bases de dados Oracle vers�o 7.2 e posteriores, e est� certificada para ser usada com o Windows NT vers�o 3.51 e 4.0.

Os t�picos que se seguem s�o abordados neste documento:

o  Novidades nesta vers�o revista 
o  Correc��es de bugs
o  Problemas conhecidos, restri��es e solu��es alternativas
o  Os seus coment�rios s�o bem-vindos 

Novidades nesta vers�o revista

Servidores HTTP de outros fornecedores suportados

O Oracle WebServer vers�o 2.1 suporta servidores da Web de outros fornecedores. Os utilizadores podem actualizar estes servidores para utilizarem o Oracle Web Request Broker (WRB) que oferece uma maior fiabilidade e capacidade de adapta��o. O Oracle WebServer 2.1 suporta estes servidores HTTP:

o  Netscape FastTrack vers�o 2.0 e 2.1
o  Netscape Enterprise Server vers�o 2.0
o  Microsoft Internet Information Server vers�o 2.0 (s� para Windows NT vers�o 4.0)

Vers�es futuras do Oracle WebServer suportar�o a integra��o noutros servidores HTTP populares.

Actualiza��o do Netscape FastTrack

O Oracle WebServer efectua automaticamente uma c�pia de seguran�a das defini��es originais do servidor da Web Netscape FastTrack durante o processo de actualiza��o. O nome do novo ficheiro � OBJ.CONF.SAV e � gravado no mesmo direct�rio que o ficheiro OBJ.SAV original.

Utilit�rio de melhoramento da seguran�a

Esta vers�o revista cont�m um utilit�rio de melhoramento da seguran�a para ser utilizado com vers�es anteriores do Oracle WebServer (anteriores � vers�o revista 2.1.0.3.1). Este utilit�rio de seguran�a, distribu�do como uma correc��o, automatiza os ajustamentos necess�rios ao WebServer para desenvolver aplica��es de PL/SQL seguras para a Web.

Para ter acesso e instalar este utilit�rio:

Abra o ficheiro a partir de qualquer navegador da Web:

file: //<unidade de cd-rom>:/owspatch/security.htm

Siga as instru��es neste ficheiro de HTML.

Correc��es de bugs

o  A administra��o do WRB em conjunto com o servidor da Web Netscape FastTrack s� � poss�vel com um servidor administrativo Oracle.

o  O WRB e o listener da Web est�o sincronizados.

o  Os utilizadores remotos n�o perdem as liga��es ao utilizar o utilit�rio OWA_UTIL.REDIRECT_URL.

o  Os utilizadores n�o conseguem ignorar a autentica��o b�sica com a seguran�a do WRB.

o  Est� dispon�vel um processo de limpeza para erros da rede.

o  Quando /SAMPLE/SSI � seleccionado, SAMPLE/SSI/INDEX.HTML aparece por omiss�o.

o  Um novo par�metro, que permite aos administradores da Web controlar o acesso directo a partir do navegador da Web de qualquer cliente aos pacotes Oracle Web Agent (OWA) fornecidos pela Oracle est� inclu�do nesta vers�o revista do Oracle WebServer para Windows NT. O par�metro PROTECT_OWA_PKG est� localizado no ficheiro SV<LISTENER>.APP. Qualquer URL (Uniform Resource Locator) com o formato //hostname:port//DCD/owa/<OWA_PACKAGE>.<OWA.PROCEDURE> ser� rejeitado se o par�metro for definido para qualquer valor excepto FALSE. Uma entrada com o pacote ofensivo ser� registada no ficheiro de di�rio do servidor.

Por exemplo, o URL http://www.a-site.com/owa_default/owa/owa_util.print_cgi_env ser� rejeitado e a p�gina de erros standard ("Request Failed") aparecer� ao cliente. Visto que muitas aplica��es dependem deste tipo de acesso directo, definir o par�metro explicitamente como FALSE permitir� ao Oracle Web Server aceitar este tipo de pedido.

Problemas conhecidos, restri��es e solu��es alternativas

o  Esta vers�o revista do Oracle WebServer funciona com as vers�es 7.2.2, 7.2.3 e 7.3.2 do Oracle7 Server. Esta vers�o n�o inclui o exemplo "Blob" referenciado na p�gina Samples.

o N�o podem existir correspond�ncias de direct�rios id�nticas no ficheiro de configura��o do listener e no OWS_APPFILE. As informa��es de seguran�a para a protec��o utilizada no OWS_APPFILE t�m de existir no ficheiro de configura��o do servidor correspondente.

o  A autentica��o de dom�nio para o Microsoft Internet Information Server (IIS) n�o � suportada.

Administra��o do agente de PL/SQL 

O par�metro CGITimeout do listener de administra��o poder� esgotar o tempo de espera da cria��o ou modifica��o de Data Connector Descriptor, se o pacote de PL/SQL estiver a ser instalado. Se isto acontecer, o servidor devolver� o erro "The server had an internal error and could not process the request".
Aumente o par�metro CGITimeout de forma adequada para assegurar a conclus�o da execu��o dentro do per�odo de tempo.

Iniciar

Durante a cria��o dos DCDs OWA_DEFAULT_SERVICE e OWA_DBA, o pacote de
PL/SQL e a demonstra��o com comboios s�o automaticamente instalados. A base de dados ORACLE poder� ser executada fora da mem�ria partilhada durante esta opera��o, se o par�metro da dimens�o do conjunto partilhado para a base de dados for demasiado pequeno. Aumente o par�metro de inicializa��o SHARED_POOL_SIZE (edite o ficheiro ORANT\DATABASE\INITORCL.ORA e, em seguida, reinicialize a base de dados) para que as altera��es tenham efeito.

Demonstra��o com comboios

o  Se a consulta para um bilhete de comboio entre duas datas n�o conseguir encontrar hor�rios de comboio dispon�veis, a p�gina seguinte apresentar� uma lista de selec��o vazia. Esta ac��o provoca um n�mero incorrecto de argumentos que ser�o passados para tr.purchase, que � a chamada de procedimento seguinte. A p�gina de erro � apresentada.

o  Adicione ao Passo 2 das instru��es de instala��o do Oracle Travel Demo
(\ows-adoc\demos.html).

o  Se estiver a executar os Oracle Web Agents atrav�s da CGI, acrescente a seguinte entrada � sec��o Directory Mappings da Advanced Listener Configuration:

ORANT\OWS21\BIN  CR  /demo/

o  Partindo do princ�pio de que j� tem uma demonstra��o da base de dados e que est� a executar os Oracle Web Agents como uma cartridge, acrescente a seguinte entrada � sec��o Applications and Directories da WRB
Configuration:

 /DEMO/OWA  OWA  ORANT\OWS21\BIN

Despachante

O n�mero m�ximo e m�nimo de inst�ncias de cartridge segundo a especifica��o da sec��o [Apps] do ficheiro de configura��o do WRB (SV<listener>.APP) significa o n�mero m�ximo e m�nimo de inst�ncias da cartridge por processo de listener. Esta distin��o � significativa no caso do Netscape FastTrack Server, no qual pode haver v�rios processos de listener. O Oracle Web Listener suporta um �nico processo de listener, e assim a defini��o anterior � irrelevante.
O n�mero m�nimo de inst�ncias de cada cartridge � inicializado por cada processo de listener no fim da primeira transac��o tratada pelo processo de listener, por oposi��o � inicializa��o no momento da inicializa��o do servidor.

Os seus coment�rios s�o bem-vindos 

Contacte o Oracle WebServer Feedback em owshelp@us.oracle.com. Indique:

o  Vers�o do RDBMS 
o  Vers�o do WebServer 
o  Uma descri��o do problema, incluindo os testes e os ficheiros de erros/di�rio 

Para fazer coment�rios sobre a documenta��o, contacte ntdoc@us.oracle.com. Indique o t�tulo da documenta��o, a plataforma do produto, o n�mero da vers�o do produto e o n�mero da pe�a da documenta��o, se poss�vel.
