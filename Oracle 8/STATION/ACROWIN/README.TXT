Bem-vindo ao Adobe Acrobat Reader 2.1 para Windows 

O software Adobe(tm) Acrobat(tm) fornece-lhe acesso imediato aos documentos no seu formato original, independentemente da plataforma do computador. Com o Acrobat Reader, pode visualizar, navegar, imprimir e apresentar qualquer ficheiro Portable Document Format (PDF).

Este ficheiro Read Me cont�m instru��es de instala��o e informa��es de produto para o programa Acrobat Reader. O Online Guide (help_r.pdf) tamb�m fornece informa��es essenciais para ajud�-lo a come�ar a utilizar o Acrobat Reader 2.1.

Se estiver a redistribuir o Acrobat Reader, coloque este ficheiro Read Me sozinho no direct�rio com o ficheiro acroread.exe para auxiliar o utilizador final na instala��o do programa.

Este ficheiro cont�m os seguintes t�picos:
        Novas funcionalidades no Acrobat Reader 2.1
        Instala��o do Acrobat Reader
        Requisitos do sistema 
        Utiliza��o da ferramenta Weblink com o Acrobat Reader
        Problemas conhecidos 
        Cria��o de documentos PDF
        Assist�ncia t�cnica 
        Acordo de licen�a electr�nico para o utilizador final

NOVAS FUNCIONALIDADES NO ACROBAT READER 2.1
===========================================
O Acrobat Reader 2.1 � agora executado sob o Windows NT 3.5 (ou posterior), Windows 3.1 e Windows 95, bem como no OS/2 2.11 ou posterior em modo de compatibilidade com o Windows. A tecnologia ATM da Adobe para fornecer tipos de letra de Tipo 1 foi integrada no Acrobat Reader 2.1 para Windows, pelo que j� � necess�rio instalar o ATM nos sistemas Windows. Para o Windows 3.1 e o Windows 95, a instala��o do ATM � uma op��o (n�o inclu�da com o Reader) que poder� melhorar o desempenho dos documentos impressos com os tipos de letra de Tipo 1 para impressoras n�o PostScript.

O Acrobat Reader 2.1 aceita agora alguns plug-ins especialmente activados, tais como Weblink e Movie. Isto permite que os utilizadores do Acrobat Reader tirem partido das novas capacidades dos ficheiros PDF criados com o Acrobat Exchange, por exemplo, seguir refer�ncias (URL) da World Wide Web ou ver filmes QuickTime (Macintosh e Windows) e AVI (apenas Windows) dentro de um documento PDF.

A qualidade da impress�o foi melhorada para as impressoras n�o PostScript.

J� n�o existem limita��es na impress�o em algumas impressoras n�o Postscript com pixels n�o quadrados (alguns fax modems e impressoras matriciais).

O Acrobat Reader 2.1 gera PostScript em conformidade com DSC, quando � utilizado com o driver do AdobePS 3.0 (ou posterior).

INSTALA��O DO ACROBAT READER
============================
Instala��o do Acrobat Reader 2.1 no disco r�gido:

1. A partir do Program Manager do Windows, escolha Run no menu File e escreva 

   [unidade de cd-rom]:acro_v2\acrowin\disk1\setup.exe 
  
2. Siga as instru��es apresentadas no ecr�. A instala��o exige aproximadamente 3 MB de espa�o livre no disco r�gido. 
   

REQUISITOS DO SISTEMA 
=====================
- Computador pessoal 386, 486 ou Pentium 
- Microsoft Windows 3.1 ou posterior 
- 4 MB de RAM
- 4 MB de espa�o no disco r�gido 
- Unidade de disquetes de 1.44 MB, 3.5 pol., ou unidade de CD-ROM



UTILIZA��O DA FERRAMENTA WEBLINK COM O ACROBAT READER
=====================================================
Para utilizar o plug-in Weblink para seguir refer�ncias, deve configurar o seu navegador de modo a reconhecer o Acrobat Reader. Consulte a p�gina principal da Adobe (http://www.adobe.com) para obter informa��es sobre como configurar o seu navegador para reconhecer documentos PDF.

Para instalar o plug-in Weblink:
        1. Copie o plug-in Weblink para o direct�rio Plug-ins do Adobe 
        Acrobat.
        Se acabou de instalar o Acrobat Reader, � poss�vel que o plug-in
        Weblink j� exista no direct�rio Plug-ins.
        2. Reinicialize o Acrobat Reader.

Para seleccionar o navegador da Web:
        1. Escolha Edit>Preferences>Weblink.
        2. Seleccione Browse e, em seguida, seleccione o navegador da Web
        na caixa de di�logo.
        3. Escolha um Connection Type. Standard � o tipo de liga��o para 
        os navegadores suportados Netscape 1.1 e Spyglass Mosaic 2.0.

Para abrir o navegador da Web no Acrobat Reader, seleccione o bot�o do navegador da Web na barra de ferramentas. Por vezes, esta funcionalidade falha no Windows 95.


PROBLEMAS CONHECIDOS
====================
Erros durante a instala��o do Acrobat Reader 
Quando � lan�ado, o programa de instala��o do Acrobat Reader (SETUP.EXE) faz uma c�pia do ficheiro SETUP.EXE no direct�rio temp especificado no ficheiro AUTOEXEC.BAT. Quando a unidade e o direct�rio indicados na linha "Set temp=" do ficheiro AUTOEXEC.BAT s�o inv�lidos ou n�o tem acesso de escrita a essa unidade e direct�rio, ou espa�o suficiente na unidade, a instala��o do Acrobat Reader falha e devolve os erros "Cannot load the language library", "Cannot load the license agreement" ou "Not enough free disk space to continue installation".

Efectue um ou mais dos seguintes procedimentos: 
A. Assegure-se de que existem, pelo menos, 4-8MB de espa�o livre no disco r�gido em que est� a ser instalado o Acrobat Reader.
B. Assegure-se de que a linha "Set temp=" no AUTOEXEC.BAT � v�lida: 
 1. Abra o ficheiro AUTOEXEC.BAT num editor de texto que grave como s� de texto (por exemplo, Windows Write, Notepad). 
 2. Localize a linha "Set temp=" e verifique se a unidade e o direct�rio a seguir ao sinal de igual s�o v�lidos. Se a linha "Set temp=" apontar para uma unidade ou direct�rio inv�lido, edite a linha para apontar para uma unidade e direct�rio v�lidos e, em seguida, grave o ficheiro como s� de texto. 
 3. Reinicie o computador.
C. Assegure-se de que tem acesso de escrita � unidade onde est� localizado o direct�rio TEMP.

Windows95
Instala��o a partir da rede -- Se configurar um servidor de rede com as imagens dos discos de instala��o do Acrobat Reader (este problema n�o ocorre com o programa de instala��o do Reader Installer de ficheiro �nico), para que os utilizadores possam instalar o Acrobat Reader atrav�s da rede, o utilizador que instalar o software ter� de executar a instala��o a partir de uma unidade de rede que esteja ligada e n�o directamente a partir da Vizinhan�a na Rede. O modo mais f�cil de atribuir (ligar) uma letra de unidade a um computador ou pasta de rede � o seguinte:

1. No ambiente de trabalho do Windows 95, seleccione com o bot�o direito do rato O Meu Computador e, em seguida, seleccione Ligar Unidade de Rede. Aparece a caixa de di�logo Ligar Unidade de Rede.
2. Seleccione uma letra de Unidade.
3. Seleccione um Caminho para o servidor de rede que pretende. 
Por exemplo:
\\nomecomputador\nomepasta
Se for necess�ria uma senha, o Windows pedir-lha-�. 

Depois de a unidade ter sido ligada, seleccione duas vezes com o rato O Meu Computador para abrir a janela O Meu Computador. O nome e a letra da unidade que acabou de ligar ser�o apresentados e poder�o ser utilizados para navegar para os discos de instala��o do Acrobat Reader.

Plug-in Weblink
- O Spyglass Mosaic no Win32s por vezes "pendura" quando um download � cancelado a partir do Weblink.
- Um URL de gopher inv�lido (por exemplo, gopher://example.com/pub/test.pdf) efectuar� o download de uma mensagem de erro como um ficheiro de texto, com o nome do ficheiro PDF. O Acrobat Reader devolver� a mensagem "There was an error opening this document. File does not begin with %PDF-".
- Se o navegador da Web estiver ocupado a contactar o host durante mais de um minuto, o Weblink devolver� a mensagem "The web browser has not responded to your request for over 1 minute: terminating request". O navegador poder� n�o responder � tentativa do Weblink de cancelar; utilize o bot�o do navegador da Web na barra de ferramentas para activar o navegador e cancele manualmente o pedido. 

Impress�o de PCL
Os drivers de impressora enviados com o Microsoft Windows 3.1 para as impressoras HP LaserJet III, IIID, IIIP e IIISi poder�o n�o funcionar correctamente com o Acrobat Reader (e outras aplica��es para esse efeito). A Adobe recomenda que utilize um driver de impressora PCL baseado no Universal Printer Driver V.3.1.2. Aqui est�o quatro modos de obter este driver:

COMPUSERVE. Escreva "GO MSL" para ir para o forum Microsoft Software Library. Efectue o download do ficheiro HPPCL5.EXE. Coloque este ficheiro numa disquete de DOS formatada e vazia. Em seguida, no DOS, execute este ficheiro para extrair o driver e as instru��es de instala��o que est�o no ficheiro printer.txt.

BBS DA MICROSOFT. O servi�o de download do BBS da Microsoft pode ser contactado atrav�s do 206-936-6735. Suporta at� 9600 baud e deve configurar o seu modem para utilizar 8 bits, 1 bit de paragem e nenhuma paridade. Uma vez ligado, um BBS orientado por menus. Efectue o download do ficheiro com o nome "HPPCL5.EXE" e siga as mesmas instru��es acima indicadas.

MICROSOFT. Se n�o tiver um modem, poder� contactar directamente a Microsoft atrav�s do 206-637-7098 ou do 800-426-9400 e obter os drivers da impressora LaserJet III em disquete.

HEWLETT PACKARD. Uma vez mais, se n�o tiver um modem, poder� contactar directamente a Hewlett Packard atrav�s do 303-353-7650 e obter os drivers da impressora LaserJet III em disquete. Tamb�m poder� utilizar este n�mero para obter os drivers de impressora mais recentes para as fam�lias de impressoras HP LaserJet 4, DeskJet e PaintJet.

Se tiver problemas a imprimir nas impressoras HP LaserJet no modo de 600 dpi, experimente voltar do modo de 300 dpi, ou, se estiver equipada com uma op��o PostScript, utilize o modo PostScript para a impress�o de 600 dpi. Este problema de impress�o do PCL5 a 600 dpi n�o parece ser espec�fico do Acrobat.

Se o texto sublinhado estiver a ser impresso incorrectamente numa impressora PCL (o sublinhado � impresso por cima dos caracteres pretos) efectue a seguinte altera��o no Control Panel do ATM: seleccione a op��o "Print ATM Fonts as Graphics". 

Para imprimir correctamente determinados efeitos de texto especiais (tais como sombreado, texto com zoom ou texto sublinhado) em impressoras n�o PostScript, poder� ser necess�rio seleccionar a op��o Print ATM Fonts as Graphics no Control Panel do ATM. Determinados drivers de impressora, incluindo o LaserJet PCL4 (Series II e posteriores), o PCL5 (fam�lias LaserJet III e LaserJet 4) e o Lexmark PPDS (4029 e 4029) imprimem sempre tipos de letra de software pretos por cima das imagens e das cadeias de caracteres de texto que n�o sejam pretas.
Os documentos com v�rias imagens gr�ficas podem n�o imprimir correctamente na LaserJet 4 no modo PCL a 600 dpi, excepto se a op��o Graphics na configura��o do driver da impressora no Windows estiver definida para o modo Raster. 

Para aumentar o desempenho de documentos formatados totalmente para orienta��o horizontal em impressoras n�o PostScript, o driver da impressora deve ser definido para orienta��o horizontal na configura��o da impressora no Windows. 

Impress�o PostScript
Driver AdobePS 3.01   Para obter melhores resultados ao imprimir em impressoras PostScript, a Adobe recomenda que utilize o driver AdobePS 3.01 (ou posterior). O driver e as instru��es de instala��o est�o inclu�dos no CD do Sampler Acrobat.

Driver AdobePS 2.1.1   Poder� ter problemas ao imprimir a partir do Acrobat Reader 2.1, quando utilizar o driver de impressora AdobePS 2.1.1. Os problemas ocorrem ao imprimir determinados documentos que utilizam tipos de letra TrueType ou caracteres aumentados, tais como aspas tipogr�ficas. Est� dispon�vel uma actualiza��o PSPrinter 2.1.2 que resolve estes problemas. A actualiza��o AdobePS 2.1.2 que actualiza uma vers�o instalada do AdobePS 2.1.1 para o 2.1.2 est� dispon�vel nas seguintes origens:

COMPUSERVE.   Escreva GO ADOBE para ir para o forum Adobe.

FTP.  O servidor FTP da Adobe est� em ftp.adobe.com. O percurso para a actualiza��o � ftp.adobe.com/pub/adobe/Applications/Drivers/Windows/adobeps.exe

WORLD WIDE WEB. O servidor da World Wide Web da Adobe est� em http://www.adobe.com.

TELEFONE.  Marque 800-521-1976 para que lhe seja enviada directamente a disquete com a actualiza��o AdobePS 2.1.2. Poder�o ser-lhe cobradas despesas e expedi��o.

Nota: A actualiza��o n�o � o driver AdobePS 2.1.2. completo e independente. S� actualizar� uma vers�o previamente instalada do AdobePS 2.1.1.

Problemas de mem�ria. Se tiver problemas, tais como VMerror, ao imprimir em impressoras PostScript de N�vel 1 ou 2, � poss�vel que a impressora tenha pouca mem�ria dispon�vel (por exemplo, uma LaserWriter, LaserWriter Plus, LaserWriter II NT ou NTX n�o actualizada). H� duas solu��es poss�veis para este problema: 
1/Na caixa de di�logo General Preferences (seleccione no menu Edit/Preferences), poder� escolher s� Serif ou s� Sans para o tipo de letra de substitui��o. Isto liberta mem�ria adicional na impressora e o documento ser�, muito provavelmente, impresso com �xito. 
2/A outra op��o � comprar mais mem�ria para a sua impressora.
Apple Personal LaserWriter NT   Se estiver a utilizar uma impressora Apple Personal LaserWriter NT que n�o foi actualizada para uma Personal LaserWriter NTR, o Acrobat Reader n�o conseguir� imprimir os tipos de letra de substitui��o. Contacte o seu concession�rio Apple para obter informa��es sobre a actualiza��o da sua impressora.

Quest�es diversas
IMPRESSORA CANON BJC 800  Para imprimir correctamente texto, gr�ficos e imagens nesta impressora, certifique-se de que selecciona a op��o Use Print Manager no painel de controlo Printers. 
CANON LBP-8IV  Utilize o modo "bitmap" das impressoras para obter melhores resultados.
DRIVER DE VIDEO MGA8.DRV DA COMPAQ  Utilizar este driver de v�deo (instalado no Compaq DeskproXL 586 (1024x768, 640x480, 256 cores) com a placa Compaq Qvision 2000 board poder� provocar uma falha do Acrobat Reader. Solu��o: Desactive a op��o Page Caching na caixa de di�logo Edit > Preferences > General.
HP DESKJET 500C  Esta impressora tem uma �rea n�o imprim�vel junto � parte superior da p�gina. Certifique-se de que utiliza a op��o Shrink to Fit da caixa de di�logo Print do Acrobat Reader.
TIPO DE LETRA N�O ENCONTRADO  Um erro de tipo de letra n�o encontrado poder� indicar que o ATM n�o tinha mem�ria suficiente para criar um tipo de letra de substitui��o. Consulte a sec��o Melhorar o Desempenho deste ficheiro para obter informa��es sobre o modo de aumentar a mem�ria dispon�vel para o ATM (se estiver instalado).
INSTALAR  Devido a problemas com alguns Gestores de Ambiente de Trabalho, durante a instala��o o grupo de programas Adobe Acrobat e o item de programa Acrobat Reader poder�o n�o ser criados. Por omiss�o, o programa � instalado no direct�rio c:\acroread e o execut�vel � c:\acroread\acroread.exe.
LOTUS NOTES  Quando abre um ficheiro PDF incorporado a partir de uma base de dados Notes, a janela do Acrobat Reader parece tremer ligeiramente. Isto porque o Lotus Notes fornece instru��es OLE ao Acrobat Reader para Show (Mostrar), Hide (Ocultar) e, depois, Show (Mostrar) o documento PDF.
PLACA DE V�DEO MACH 32 DA ATI  Se estiver a utilizar a placa MACH 32 da ATI, certifique-se de que utiliza o modo de 256 cores com a Color Pallette activada. Ou seja, n�o utilize o modo de 256 cores com a Color Pallette desactivada. No Acrobat, certifique-se de que a Pallette est� activada. 
DRIVER NEC ULTRALITE VERSA LINEAR  As imagens rodadas poder�o ser apresentadas com artefactos quando se utiliza o driver de v�deo UltraLite Versa Linear 640x480 de 256 cores. Solu��o: Utilize o driver UltraLite Versa 640x480 de 256 cores.
DRIVER DE VIDEO NUMBER 9  Quando a cache de p�ginas do Acrobat Reader est� activada, se lhe aparecerem linhas horizontais na p�gina, experimente desligar o modo turbo no driver de v�deo #9GXE. Poder� faz�-lo atrav�s do menu Turbo no programa "#9GXE Status" dispon�vel no "#9 Hawkeye Control Panel".
OLE  Ao visualizar um ficheiro PDF que � um objecto OLE incorporado, pode apenas efectuar uma grava��o incremental, e n�o uma grava��o total. As opera��es que necessitam de uma grava��o total s�o, por exemplo, a inser��o de outro ficheiro PDF. Desta forma, n�o poder� efectuar esta opera��o num objecto OLE incorporado.
OS/2  O Acrobat Reader dever� ser executado no modo de compatibilidade com o Windows 3.1 do OS/2 2.1 e OS/2 2.1.1.
CACHE DE P�GINAS  A cache de p�ginas est� desactivada para monitores de 16 bits e de 24 bits e a op��o aparece desactivada na caixa de di�logo General Preferences.
PADR�ES  Os ficheiros produzidos pelo Acrobat Distiller que cont�m padr�es poder�o ser apresentados lentamente e provocar insufici�ncias de mem�ria. Este pode ser muitas vezes o caso quando as aplica��es representam os padr�es como milhares de caracteres de tipos de letra de Tipo 3 pequenos. Se tiver este problema, recomenda-se que utilize cores, em vez de preenchimentos com padr�es.
PC TOOLS PARA WINDOWS 1.0  N�o s�o criados nenhum grupo Adobe Acrobat nem itens/�cones de programa. Consulte o problema INSTALAR acima indicado para obter uma descri��o da solu��o alternativa. 
PHONENET  O PhoneNet n�o efectua correctamente a correspond�ncia dos nomes de ficheiro de Macintosh que cont�m caracteres ASCII mai�sculos. Desta forma, n�o conseguir� abrir esses ficheiros no Acrobat Reader. Solu��o: N�o utilize caracteres especiais nos nomes dos ficheiros que se destinem a ser acedidos por utilizadores de Macintosh e de Windows numa rede PhoneNet.
IMPRESS�O A PARTIR DO FILE MANAGER  S� um ficheiro PDF de cada vez pode ser seleccionado e impresso a partir do File Manager.
ROTA��O DE P�GINAS  A rota��o de p�ginas resulta na perda das imagens miniatura relativas a essas p�ginas. Pode voltar a gerar as miniaturas escolhendo Edit/Thumbnails/Create All. 
TIPOS DE LETRA TRUETYPE RODADOS/TRANSFORMADOS  Poder� ter alguns problemas em apresentar ou imprimir tipos de letra TrueType rodados ou, de outra forma, transformados. Esta � uma limita��o dos tipos de letra TrueType e do Windows. Para obter melhores resultados, recomendamos que utilize os tipos de letra PostScript Tipo 1 da Adobe nos seus documentos. 
MODO STANDARD  O Acrobat Reader 2.1 n�o funciona em modo standard; tem de executar o Windows 3.1 em modo avan�ado (enhanced).
SYSHOOK  Syshook � uma aplica��o que corrige os menus de sistema das aplica��es; n�o funciona bem com o Acrobat Reader. 
TRUE TYPE  Os tipos de letra TrueType n�o podem voltar a ser codificados. Devido a esta limita��o, os documentos que foram criados utilizando alguns caracteres especiais num tipo de letra de Tipo 1 poder�o n�o ser apresentados correctamente, se uma vers�o TrueType do tipo de letra com o mesmo nome � instalada no seu sistema. Quando isto acontece, � apresentada a mensagem de erro "Some text in the font and character 'FONTNAME ###' could not be displayed or printed correctly. The font could not be reencoded.". Uma vez que os instaladores do Acrobat n�o substituem as vers�es TrueType de Times, Helvetica e Courier, poder� obter esta mensagem com estes tipos de letra. Solu��o: Utilize a op��o Custom Install para instalar uma vers�o Tipo 1 destes tipos de letra.
WINDOWS FOR WORKGROUPS  As extens�es de Netware do Windows for Workgroups (\windows\netx.com) s�o conhecidas por causarem problemas na caixa de di�logo Open do Acrobat Reader, bem como nas caixas de di�logo Open de outras aplica��es. Solu��o: Contacte a Microsoft.
CORES INCORRECTAS  Se as cores no seu monitor parecem estar completamente erradas, tente o seguinte: no ficheiro ini do Acrobat Reader (c:\windows\acroread.ini), altere a linha 'IS8514=4' para 'IS8514=105'.


CRIA��O DE DOCUMENTOS PDF
=========================
Para tirar partido dos benef�cios dos documentos electr�nicos, pode comprar o Acrobat Exchange, o Acrobat Pro ou o Acrobat for Workgroups com o cup�o contido no Online Guide do Acrobat Reader (dispon�vel no CD Sampler do Acrobat) ou telefonando para 800-87-ADOBE (800-872-3623). Com os produtos Acrobat completos, pode:

- Criar os documentos electr�nicos t�o facilmente como quando imprime a partir das suas aplica��es com o PDF Writer.
- Proteger os ficheiros com senhas; controlar o acesso, a impress�o, a altera��o do documento, a adi��o e altera��o de notas, a c�pia de texto e gr�ficos.
- Encontrar exactamente o que precisa em v�rios ficheiros PDF, pesquisando por palavras-chave, autor, t�tulo, sin�nimos de assunto, etc.
- Reutilizar informa��es facilmente atrav�s da extrac��o, c�pia, reorganiza��o e substitui��o de p�ginas entre ficheiros PDF -- com marcadores, refer�ncias e notas preservadas.
- Criar vistas personalizadas das informa��es.
- Acrescentar valor, definir prioridades e manter uma rede de informa��es din�mica com refer�ncias, marcadores, notas e liga��es a documentos e aplica��es externas.
- Tirar partido de plug-ins de outros fornecedores para acrescentar novas funcionalidades ao Acrobat.
- Integrar o Acrobat nas suas aplica��es de ambiente de trabalho com o suporte do Acrobat para automatiza��o OLE, Notes F/X, AppleEvents, e muito mais.

ASSIST�NCIA T�CNICA
===================
Para obter informa��es t�cnicas e respostas, pode tirar partido dos Basic Support Services da Adobe em qualquer altura. � apenas respons�vel pelas despesas telef�nicas. Estes servi�os incluem:
- Adobe US Automated Technical Support -- sistema de diagn�stico por computador a tempo inteiro, com respostas �s perguntas mais frequentes. Marque 1-206-628-2757 24 horas por dia, 7 dias por semana.
- Adobe US Fax Request Line -- uma forma simples de pedir notas t�cnicas gratuitas por fax. Marque 1-206-628-5737 24 horas por dia, 7 dias por semana.
- CompuServe Questions and Answers -- um BBS da Adobe para subscritores da CompuServe. Direct�rio: GO ADOBE
- Adobe US Electronic Bulletin Board -- Um banco de informa��es que funciona 24 horas por dia. Marque 1-206-623-6984.

Apenas para os E.U.A. -- para os utilizadores dos produtos Adobe Acrobat nos E.U.A. e no Canad�, entre as op��es de suporte pago incluem-se:
- 900-555-2276 -- este servi�o 900 empresa a empresa � uma forma de os utilizadores pouco frequentes obterem ajuda de um Representante da Assist�ncia T�cnica da Adobe. 
  Cada minuto custa $2.00 mais a taxa da liga��o telef�nica, se houver. Os
  custos aparecer�o discriminados na sua conta telef�nica mensal.


ACORDO DE LICEN�A ELECTR�NICO PARA O UTILIZADOR FINAL
=====================================================
Adobe Systems Incorporated
Acordo de licen�a electr�nico para o utilizador final

AVISO PARA O UTILIZADOR:
ISTO � UM CONTRATO. INDICANDO A SUA ACEITA��O ABAIXO, ACEITA TODOS OS TERMOS E CONDI��ES DESTE ACORDO.
Este Acordo de Licen�a para o Utilizador Final da Adobe Systems Incorporated ("Adobe") acompanha um produto de software da Adobe e os materiais explicativos escritos relacionados ("Software"). 

O termo "Software" dever� tamb�m incluir quaisquer actualiza��es, vers�es modificadas ou actualiza��es do software para o qual recebeu a licen�a por parte da Adobe. Como utilizador final, foi-lhe concedida uma licen�a para esta c�pia do Software. Deve ler cuidadosamente este Acordo antes de indicar a sua aceita��o no final do respectivo texto. 
Se n�o concordar com os termos e condi��es deste Acordo, recuse-o onde for apropriado durante a instala��o pelo que n�o poder� utilizar o Software. A Adobe concede-lhe uma licen�a n�o exclusiva para utilizar o Software, desde que concorde com o seguinte: 

1. Utiliza��o do Software. Pode instalar o Software numa �nica localiza��o no disco r�gido ou outro dispositivo de armazenamento; instalar e utilizar o Software num servidor de ficheiros para o poder utilizar numa rede para ser instalado de forma permanente em discos r�gidos ou outros dispositivos de armazenamento ou para utilizar o software nessa mesma rede; e fazer c�pias de seguran�a do Software. Pode fazer um n�mero ilimitado de c�pias do Software e dar c�pias a outras pessoas ou entidades, desde que as c�pias contenham este Acordo e os mesmos avisos de propriedade e direitos de autor que aparecem no Software.

2. Direitos de Autor. O Software � propriedade da Adobe e dos seus fornecedores, e a sua estrutura, organiza��o e c�digo constituem valiosos segredos comerciais da Adobe e dos seus fornecedores. O Software est� igualmente protegido pelas leis de direitos de autor dos Estados Unidos da Am�rica e pelas disposi��es de tratados internacionais. Concorda em n�o modificar, adaptar, converter, efectuar reverse-engineering, descompilar, desassemblar ou, de outra forma, tentar descobrir o c�digo de origem do Software. Pode utilizar marcas comerciais apenas para identificar c�pias impressas produzidas pelo Software, de acordo com a pr�tica das marcas comerciais aceite, incluindo a identifica��o do nome do propriet�rio da marca comercial. Este tipo de utiliza��o de qualquer marca comercial n�o lhe d� quaisquer direitos de propriedade em rela��o a essa marca comercial. 
Excepto da forma acima indicada, este Acordo n�o lhe concede quaisquer direitos de propriedade intelectual em rela��o ao Software.

3. Transfer�ncia. N�o pode alugar ou sublicenciar o Software. Contudo, pode transferir todos os seus direitos de utiliza��o do software para outra pessoa ou entidade, desde que transfira este Acordo juntamente com o Software.

4. Exclus�o de Garantia. O Software �-lhe entregue TAL COMO EST� e a Adobe n�o d� qualquer garantia relativa � sua utiliza��o ou desempenho. A ADOBE E OS SEUS FORNECEDORES N�O GARANTEM E N�O PODEM GARANTIR O DESEMPENHO OU OS RESULTADOS QUE PODER� OBTER AO UTILIZAR A SOFTWARE OU A DOCUMENTA��O. A ADOBE E OS SEUS FORNECEDORES N�O D�O QUALQUER GARANTIA, QUER EXPRESSA QUER IMPL�CITA, NO QUE SE REFERE � INFRAC��O DOS DIREITOS DE TERCEIROS, COMERCIALIZA��O OU ADEQUA��O A FINS ESPEC�FICOS. EM CASO ALGUM A ADOBE OU OS SEUS FORNECEDORES SER�O RESPONS�VEIS POR QUAISQUER DANOS CONSEQUENCIAIS, ACIDENTAIS OU ESPECIAIS, INCLUINDO QUAISQUER PERDAS DE LUCROS OU RECEITAS, MESMO QUE UM REPRESENTANTE DA ADOBE TENHA SIDO AVISADO DA POSSIBILIDADE DE OCORR�NCIA DE TAIS DANOS, OU POR QUALQUER RECLAMA��O FEITA POR TERCEIROS.  
Alguns estados ou jurisdi��es n�o permitem a exclus�o ou limita��o de danos acidentais, consequenciais ou especiais, ou a exclus�o de garantias impl�citas ou limita��es sobre a dura��o de uma garantia impl�cita, pelo que as limita��es acima descritas podem n�o se aplicar ao seu caso.
 
5. Governing Law and General Provisions. This Agreement will be governed by 
   the laws of the State of California U.S.A., excluding the application 
   of its conflicts of law rules.  This Agreement will not be governed by 
   the United Nations Convention on Contracts for the International Sale 
   of Goods, the application of which is expressly excluded.  If any part 
   of this Agreement is found void and unenforceable, it will not affect 
   the validity of the balance of the Agreement, which shall remain valid 
   and enforceable according to its terms.  You agree that the Software 
   will not be shipped, transferred or exported into any country or used 
   in any manner prohibited by the United States Export Administration 
   Act or any other export laws, restrictions or regulations.  This 
   Agreement shall automatically terminate upon failure by you to comply 
   with its terms.  This Agreement may only be 
   modified in writing signed by an authorized officer of Adobe.

6. Notice to Government End Users. If this product is acquired under the terms 
   of a:  GSA contract- Use, reproduction or disclosure is subject to the 
   restrictions set forth in the applicable ADP Schedule contract; 
   DoD contract- Use, duplication or disclosure by the Government is subject 
   to restrictions as set forth in subparagraph (c) (1) (ii) of 252.227-7013;
   Civilian agency contract- Use, reproduction, or disclosure is subject 
   to 52.227-19 (a) through (d) and restrictions set forth in the accompanying 
   end user agreement.  Unpublished-rights reserved under the copyright laws 
   of the United States.  Adobe Systems Incorporated, 1585 Charleston Road, 
   P.O. Box 7900, Mountain View, CA 94039-7900.Adobe is a trademark of 
   Adobe Systems Incorporated which may be registered in certain jurisdictions.
 
Queira indicar a sua aceita��o ou recusa deste Acordo seleccionando a caixa apropriada durante a instala��o.

Adobe, Acrobat e Adobe Type Manager s�o marcas comerciais da Adobe Systems,
Incorporated e podem estar registadas em algumas jurisdi��es. 
(c) 1983-1995 Adobe Systems Incorporated. Todos os direitos reservados.
