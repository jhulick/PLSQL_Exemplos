Vers�o de correc��o do Oracle WebServer 2.1.0.3.2 no NT
--------------------------------------------------
Instala��o
------------
1. Pare todos os Listeners Oracle da Web e todos os outros listeners que estejam ligados ao Oracle WRB.
2. Execute o programa patch.exe que se encontra neste direct�rio.
   Ao fazer isto ter� o seguinte resultado:
   i. � criado um direct�rio original abaixo de ORACLE_HOME\OWS21\bin e ORACLE_HOME\OWS21\admin
   ii. Os ficheiros originais s�o copiados para os direct�rios originais.
   iii. Os ficheiros execut�veis/de configura��o existentes nos respectivos direct�rios s�o substitu�dos.

Altera��es aos ficheiros de configura��o 
----------------------------------------
Fa�a as seguintes altera��es aos seus ficheiros sv<listener>.APP (Bug#474557) - 

Na sec��o APP, altere o nome da cartridge JAVA (wrbjava.dll) para javai.dll.
A sec��o APP passar� a ter o seguinte aspecto:

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
Os bugs que se seguem foram corrigidos nesta vers�o de correc��o.
464113 - Modelo T com listeners de Netscape/IIS corrigidos.
465466 - Processos de WRB de limpeza de erros da rede quando se utiliza um listener de Spylass.
465470 - Processos de WRB de limpeza de erros da rede quando se utiliza um listener Netscape.
465501 - Processos de WRB de limpeza de erros da rede quando se utiliza um listener IIS.
464777 - Falta de mem�ria no adaptador ISAPI corrigida.
460067 - O despachante j� n�o � sens�vel a mai�sculas e min�sculas.
474557 - Foram acrescentadas DLLs nativas de Java (incluindo net.dll).
