Versão de correcção do Oracle WebServer 2.1.0.3.2 no NT
--------------------------------------------------
Instalação
------------
1. Pare todos os Listeners Oracle da Web e todos os outros listeners que estejam ligados ao Oracle WRB.
2. Execute o programa patch.exe que se encontra neste directório.
   Ao fazer isto terá o seguinte resultado:
   i. É criado um directório original abaixo de ORACLE_HOME\OWS21\bin e ORACLE_HOME\OWS21\admin
   ii. Os ficheiros originais são copiados para os directórios originais.
   iii. Os ficheiros executáveis/de configuração existentes nos respectivos directórios são substituídos.

Alterações aos ficheiros de configuração 
----------------------------------------
Faça as seguintes alterações aos seus ficheiros sv<listener>.APP (Bug#474557) - 

Na secção APP, altere o nome da cartridge JAVA (wrbjava.dll) para javai.dll.
A secção APP passará a ter o seguinte aspecto:

[Apps]
#
# APP   Object Path                                Entry POint  Min     Max
# ===   ===========                                ===========  ===     ===
OWA     C:\ORANT\OWS21\bin\owa.dll                         ndwoadinit  0       100
SSI     C:\ORANT\OWS21\bin\ssi.dll                         ndwussinit  0       100
JAVA    C:\ORANT\OWS21\bin\javai.dll                         ojsdinit  0       100
HELLO   C:\ORANT\OWS21\sample\wrbsdk\helloworld.dll         testentry  0       100
MYAPP   C:\ORANT\OWS21\sample\wrbsdk\mywrbapp\mywrbapp.dll MyWRBApp_Entry 0 100

Bugs corrigidos
---------------
Os bugs que se seguem foram corrigidos nesta versão de correcção.
464113 - Modelo T com listeners de Netscape/IIS corrigidos.
465466 - Processos de WRB de limpeza de erros da rede quando se utiliza um listener de Spylass.
465470 - Processos de WRB de limpeza de erros da rede quando se utiliza um listener Netscape.
465501 - Processos de WRB de limpeza de erros da rede quando se utiliza um listener IIS.
464777 - Falta de memória no adaptador ISAPI corrigida.
460067 - O despachante já não é sensível a maiúsculas e minúsculas.
474557 - Foram acrescentadas DLLs nativas de Java (incluindo net.dll).
