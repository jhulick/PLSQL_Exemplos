Notas da versão revista do Oracle WebServer para Windows NT

Versão 2.1.0.3.1 Produção
Janeiro de 1997

A versão revista 2.1 do Oracle WebServer suporta bases de dados Oracle versão 7.2 e posteriores, e está certificada para ser usada com o Windows NT versão 3.51 e 4.0.

Os tópicos que se seguem são abordados neste documento:

o  Novidades nesta versão revista 
o  Correcções de bugs
o  Problemas conhecidos, restrições e soluções alternativas
o  Os seus comentários são bem-vindos 

Novidades nesta versão revista

Servidores HTTP de outros fornecedores suportados

O Oracle WebServer versão 2.1 suporta servidores da Web de outros fornecedores. Os utilizadores podem actualizar estes servidores para utilizarem o Oracle Web Request Broker (WRB) que oferece uma maior fiabilidade e capacidade de adaptação. O Oracle WebServer 2.1 suporta estes servidores HTTP:

o  Netscape FastTrack versão 2.0 e 2.1
o  Netscape Enterprise Server versão 2.0
o  Microsoft Internet Information Server versão 2.0 (só para Windows NT versão 4.0)

Versões futuras do Oracle WebServer suportarão a integração noutros servidores HTTP populares.

Actualização do Netscape FastTrack

O Oracle WebServer efectua automaticamente uma cópia de segurança das definições originais do servidor da Web Netscape FastTrack durante o processo de actualização. O nome do novo ficheiro é OBJ.CONF.SAV e é gravado no mesmo directório que o ficheiro OBJ.SAV original.

Utilitário de melhoramento da segurança

Esta versão revista contém um utilitário de melhoramento da segurança para ser utilizado com versões anteriores do Oracle WebServer (anteriores à versão revista 2.1.0.3.1). Este utilitário de segurança, distribuído como uma correcção, automatiza os ajustamentos necessários ao WebServer para desenvolver aplicações de PL/SQL seguras para a Web.

Para ter acesso e instalar este utilitário:

Abra o ficheiro a partir de qualquer navegador da Web:

file: //<unidade de cd-rom>:/owspatch/security.htm

Siga as instruções neste ficheiro de HTML.

Correcções de bugs

o  A administração do WRB em conjunto com o servidor da Web Netscape FastTrack só é possível com um servidor administrativo Oracle.

o  O WRB e o listener da Web estão sincronizados.

o  Os utilizadores remotos não perdem as ligações ao utilizar o utilitário OWA_UTIL.REDIRECT_URL.

o  Os utilizadores não conseguem ignorar a autenticação básica com a segurança do WRB.

o  Está disponível um processo de limpeza para erros da rede.

o  Quando /SAMPLE/SSI é seleccionado, SAMPLE/SSI/INDEX.HTML aparece por omissão.

o  Um novo parâmetro, que permite aos administradores da Web controlar o acesso directo a partir do navegador da Web de qualquer cliente aos pacotes Oracle Web Agent (OWA) fornecidos pela Oracle está incluído nesta versão revista do Oracle WebServer para Windows NT. O parâmetro PROTECT_OWA_PKG está localizado no ficheiro SV<LISTENER>.APP. Qualquer URL (Uniform Resource Locator) com o formato //hostname:port//DCD/owa/<OWA_PACKAGE>.<OWA.PROCEDURE> será rejeitado se o parâmetro for definido para qualquer valor excepto FALSE. Uma entrada com o pacote ofensivo será registada no ficheiro de diário do servidor.

Por exemplo, o URL http://www.a-site.com/owa_default/owa/owa_util.print_cgi_env será rejeitado e a página de erros standard ("Request Failed") aparecerá ao cliente. Visto que muitas aplicações dependem deste tipo de acesso directo, definir o parâmetro explicitamente como FALSE permitirá ao Oracle Web Server aceitar este tipo de pedido.

Problemas conhecidos, restrições e soluções alternativas

o  Esta versão revista do Oracle WebServer funciona com as versões 7.2.2, 7.2.3 e 7.3.2 do Oracle7 Server. Esta versão não inclui o exemplo "Blob" referenciado na página Samples.

o Não podem existir correspondências de directórios idênticas no ficheiro de configuração do listener e no OWS_APPFILE. As informações de segurança para a protecção utilizada no OWS_APPFILE têm de existir no ficheiro de configuração do servidor correspondente.

o  A autenticação de domínio para o Microsoft Internet Information Server (IIS) não é suportada.

Administração do agente de PL/SQL 

O parâmetro CGITimeout do listener de administração poderá esgotar o tempo de espera da criação ou modificação de Data Connector Descriptor, se o pacote de PL/SQL estiver a ser instalado. Se isto acontecer, o servidor devolverá o erro "The server had an internal error and could not process the request".
Aumente o parâmetro CGITimeout de forma adequada para assegurar a conclusão da execução dentro do período de tempo.

Iniciar

Durante a criação dos DCDs OWA_DEFAULT_SERVICE e OWA_DBA, o pacote de
PL/SQL e a demonstração com comboios são automaticamente instalados. A base de dados ORACLE poderá ser executada fora da memória partilhada durante esta operação, se o parâmetro da dimensão do conjunto partilhado para a base de dados for demasiado pequeno. Aumente o parâmetro de inicialização SHARED_POOL_SIZE (edite o ficheiro ORANT\DATABASE\INITORCL.ORA e, em seguida, reinicialize a base de dados) para que as alterações tenham efeito.

Demonstração com comboios

o  Se a consulta para um bilhete de comboio entre duas datas não conseguir encontrar horários de comboio disponíveis, a página seguinte apresentará uma lista de selecção vazia. Esta acção provoca um número incorrecto de argumentos que serão passados para tr.purchase, que é a chamada de procedimento seguinte. A página de erro é apresentada.

o  Adicione ao Passo 2 das instruções de instalação do Oracle Travel Demo
(\ows-adoc\demos.html).

o  Se estiver a executar os Oracle Web Agents através da CGI, acrescente a seguinte entrada à secção Directory Mappings da Advanced Listener Configuration:

ORANT\OWS21\BIN  CR  /demo/

o  Partindo do princípio de que já tem uma demonstração da base de dados e que está a executar os Oracle Web Agents como uma cartridge, acrescente a seguinte entrada à secção Applications and Directories da WRB
Configuration:

 /DEMO/OWA  OWA  ORANT\OWS21\BIN

Despachante

O número máximo e mínimo de instâncias de cartridge segundo a especificação da secção [Apps] do ficheiro de configuração do WRB (SV<listener>.APP) significa o número máximo e mínimo de instâncias da cartridge por processo de listener. Esta distinção é significativa no caso do Netscape FastTrack Server, no qual pode haver vários processos de listener. O Oracle Web Listener suporta um único processo de listener, e assim a definição anterior é irrelevante.
O número mínimo de instâncias de cada cartridge é inicializado por cada processo de listener no fim da primeira transacção tratada pelo processo de listener, por oposição à inicialização no momento da inicialização do servidor.

Os seus comentários são bem-vindos 

Contacte o Oracle WebServer Feedback em owshelp@us.oracle.com. Indique:

o  Versão do RDBMS 
o  Versão do WebServer 
o  Uma descrição do problema, incluindo os testes e os ficheiros de erros/diário 

Para fazer comentários sobre a documentação, contacte ntdoc@us.oracle.com. Indique o título da documentação, a plataforma do produto, o número da versão do produto e o número da peça da documentação, se possível.
