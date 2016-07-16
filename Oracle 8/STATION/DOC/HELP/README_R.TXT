Bem-vindo ao Adobe Acrobat Reader 2.1 para Windows 

O software Adobe(tm) Acrobat(tm) fornece-lhe acesso imediato aos documentos no seu formato original, independentemente da plataforma do computador. Com o Acrobat Reader, pode visualizar, navegar, imprimir e apresentar qualquer ficheiro Portable Document Format (PDF).

Este ficheiro Read Me contém instruções de instalação e informações de produto para o programa Acrobat Reader. O Online Guide (help_r.pdf) também fornece informações essenciais para ajudá-lo a começar a utilizar o Acrobat Reader 2.1.

Se estiver a redistribuir o Acrobat Reader, coloque este ficheiro Read Me sozinho no directório com o ficheiro acroread.exe para auxiliar o utilizador final na instalação do programa.

Este ficheiro contém os seguintes tópicos:
        Novas funcionalidades no Acrobat Reader 2.1
        Instalação do Acrobat Reader
        Requisitos do sistema 
        Utilização da ferramenta Weblink com o Acrobat Reader
        Problemas conhecidos 
        Criação de documentos PDF
        Assistência técnica 
        Acordo de licença electrónico para o utilizador final

NOVAS FUNCIONALIDADES NO ACROBAT READER 2.1
===========================================
O Acrobat Reader 2.1 é agora executado sob o Windows NT 3.5 (ou posterior), Windows 3.1 e Windows 95, bem como no OS/2 2.11 ou posterior em modo de compatibilidade com o Windows. A tecnologia ATM da Adobe para fornecer tipos de letra de Tipo 1 foi integrada no Acrobat Reader 2.1 para Windows, pelo que já é necessário instalar o ATM nos sistemas Windows. Para o Windows 3.1 e o Windows 95, a instalação do ATM é uma opção (não incluída com o Reader) que poderá melhorar o desempenho dos documentos impressos com os tipos de letra de Tipo 1 para impressoras não PostScript.

O Acrobat Reader 2.1 aceita agora alguns plug-ins especialmente activados, tais como Weblink e Movie. Isto permite que os utilizadores do Acrobat Reader tirem partido das novas capacidades dos ficheiros PDF criados com o Acrobat Exchange, por exemplo, seguir referências (URL) da World Wide Web ou ver filmes QuickTime e AVI (apenas Windows) dentro de um documento PDF.

A qualidade da impressão foi melhorada para as impressoras não PostScript.

Já não existem limitações na impressão em algumas impressoras não Postscript com pixels não quadrados (alguns fax modems e impressoras matriciais).

O Acrobat Reader 2.1 gera PostScript em conformidade com DSC, quando é utilizado com o driver do AdobePS 3.0 (ou posterior).

INSTALAÇÃO DO ACROBAT READER
============================
- Para instalar o Acrobat Reader 2.1 no seu disco rígido, no Program Manager do Windows, escolha Run no menu File; escreva 
  [unidade]:\setup.exe 
- Siga as instruções no ecrã.
- A instalação necessita aproximadamente de 3 MB de espaço livre no disco rígido. 

REQUISITOS DO SISTEMA 
=====================
- Computador pessoal 386 ou 486 (486 recomendado)
- Microsoft Windows 3.1 ou posterior 
- 4 MB de RAM
- 4 MB de espaço no disco rígido 
- Unidade de disquetes de 1.44 MB 3,5 pol 

UTILIZAÇÃO DA FERRAMENTA WEBLINK COM O ACROBAT READER
=====================================================
Para utilizar o plug-in Weblink para seguir referências, deve configurar o seu navegador de modo a reconhecer o Acrobat Reader. Consulte a página principal da Adobe (http://www.adobe.com) para obter informações sobre como configurar o seu navegador para reconhecer documentos PDF.

Para instalar o plug-in Weblink:
        1. Copie o plug-in Weblink para o directório Plug-ins do Adobe 
        Acrobat.
        Se acabou de instalar o Acrobat Reader, é possível que o plug-in
        Weblink já exista no directório Plug-ins.
        2. Reinicialize o Acrobat Reader.

Para seleccionar o navegador da Web:
        1. Escolha Edit>Preferences>Weblink.
        2. Seleccione Browse e, em seguida, seleccione o navegador da Web
        na caixa de diálogo.
        3. Escolha um Connection Type. Standard é o tipo de ligação para 
        os navegadores suportados Netscape 1.1 e Spyglass Mosaic 2.0.

Para abrir o navegador da Web no Acrobat Reader, seleccione o botão do navegador da Web na barra de ferramentas. Por vezes, esta funcionalidade falha no Windows 95.

PROBLEMAS CONHECIDOS
====================
Erros durante a instalação do Acrobat Reader 
Quando é lançado, o programa de instalação do Acrobat Reader (SETUP.EXE) faz uma cópia do ficheiro SETUP.EXE no directório temp especificado no ficheiro AUTOEXEC.BAT. Quando a unidade e o directório indicados na linha "Set temp=" do ficheiro AUTOEXEC.BAT são inválidos ou não tem acesso de escrita a essa unidade e directório, ou espaço suficiente na unidade, a instalação do Acrobat Reader falha e devolve os erros "Cannot load the language library", "Cannot load the license agreement" ou "Not enough free disk space to continue installation".

Efectue um ou mais dos seguintes procedimentos: 
A. Assegure-se de que existem, pelo menos, 4-8MB de espaço livre no disco rígido em que está a ser instalado o Acrobat Reader.
B. Assegure-se de que a linha "Set temp=" no AUTOEXEC.BAT é válida: 
 1. Abra o ficheiro AUTOEXEC.BAT num editor de texto que grave como só de texto (por exemplo, Windows Write, Notepad). 
 2. Localize a linha "Set temp=" e verifique se a unidade e o directório a seguir ao sinal de igual são válidos. Se a linha "Set temp=" apontar para uma unidade ou directório inválido, edite a linha para apontar para uma unidade e directório válidos e, em seguida, grave o ficheiro como só de texto. 
 3. Reinicie o computador.
C. Assegure-se de que tem acesso de escrita à unidade onde está localizado o directório TEMP.

Windows95
Instalação a partir da rede -- Se configurar um servidor de rede com as imagens dos discos de instalação do Acrobat Reader (este problema não ocorre com o programa de instalação do Reader Installer de ficheiro único), para que os utilizadores possam instalar o Acrobat Reader através da rede, o utilizador que instalar o software terá de executar a instalação a partir de uma unidade de rede que esteja ligada e não directamente a partir da Vizinhança na Rede. O modo mais fácil de atribuir (ligar) uma letra de unidade a um computador ou pasta de rede é o seguinte:

1. No ambiente de trabalho do Windows 95, seleccione com o botão direito do rato O Meu Computador e, em seguida, seleccione Ligar Unidade de Rede. Aparece a caixa de diálogo Ligar Unidade de Rede.
2. Seleccione uma letra de Unidade.
3. Seleccione um Caminho para o servidor de rede que pretende. 
Por exemplo:
\\nomecomputador\nomepasta
Se for necessária uma senha, o Windows pedir-lha-á. 

Depois de a unidade ter sido ligada, seleccione duas vezes com o rato O Meu Computador para abrir a janela O Meu Computador. O nome e a letra da unidade que acabou de ligar serão apresentados e poderão ser utilizados para navegar para os discos de instalação do Acrobat Reader.

Plug-in Weblink
- O Spyglass Mosaic no Win32s por vezes "pendura" quando um download é cancelado a partir do Weblink.
- Um URL de gopher inválido (por exemplo, gopher://example.com/pub/test.pdf) efectuará o download de uma mensagem de erro como um ficheiro de texto, com o nome do ficheiro PDF. O Acrobat Reader devolverá a mensagem "There was an error opening this document. File does not begin with %PDF-".
- Se o navegador da Web estiver ocupado a contactar o host durante mais de um minuto, o Weblink devolverá a mensagem "The web browser has not responded to your request for over 1 minute: terminating request". O navegador poderá não responder à tentativa do Weblink de cancelar; utilize o botão do navegador da Web na barra de ferramentas para activar o navegador e cancele manualmente o pedido. 

Impressão de PCL
Os drivers de impressora enviados com o Microsoft Windows 3.1 para as impressoras HP LaserJet III, IIID, IIIP e IIISi poderão não funcionar correctamente com o Acrobat Reader (e outras aplicações para esse efeito). A Adobe recomenda que utilize um driver de impressora PCL baseado no Universal Printer Driver V.3.1.2. Aqui estão quatro modos de obter este driver:

COMPUSERVE. Escreva "GO MSL" para ir para o forum Microsoft Software Library. Efectue o download do ficheiro HPPCL5.EXE. Coloque este ficheiro numa disquete de DOS, formatada e vazia. Em seguida, no DOS execute este ficheiro para extrair o driver e as instruções de instalação que estão no ficheiro printer.txt.

BBS DA MICROSOFT. O serviço de download do BBS da Microsoft pode ser contactado através do 206-936-6735. Suporta até 9600 baud e deve configurar o seu modem para utilizar 8 bits, 1 bit de paragem e nenhuma paridade. Uma vez ligado, um BBS orientado por menus. Efectue o download do ficheiro com o nome "HPPCL5.EXE" e siga as mesmas instruções acima indicadas.

MICROSOFT. Se não tiver um modem, poderá contactar directamente a Microsoft através do 206-637-7098 ou do 800-426-9400 e obter os drivers da impressora LaserJet III em disquete.

HEWLETT PACKARD. Uma vez mais, se não tiver um modem, poderá contactar directamente a Hewlett Packard através do 303-353-7650 e obter os drivers da impressora LaserJet III em disquete. Também poderá utilizar este número para obter os drivers de impressora mais recentes para as famílias de impressoras HP LaserJet 4, DeskJet e PaintJet.

Se tiver problemas a imprimir nas impressoras HP LaserJet no modo de 600 dpi, experimente voltar do modo de 300 dpi, ou, se estiver equipada com uma opção PostScript, utilize o modo PostScript para a impressão de 600 dpi. Este problema de impressão do PCL5 a 600 dpi não parece ser específico do Acrobat.

Se o texto sublinhado estiver a ser impresso incorrectamente numa impressora PCL (o sublinhado é impresso por cima dos caracteres pretos) efectue a seguinte alteração no Control Panel do ATM: seleccione a opção "Print ATM Fonts as Graphics". 

Para imprimir correctamente determinados efeitos de texto especiais (tais como sombreado, texto com zoom ou texto sublinhado) em impressoras não PostScript, poderá ser necessário seleccionar a opção Print ATM Fonts as Graphics no Control Panel do ATM. Determinados drivers de impressora, incluindo o LaserJet PCL4 (Series II e posteriores), o PCL5 (famílias LaserJet III e LaserJet 4) e o Lexmark PPDS (4029 e 4029) imprimem sempre tipos de letra de software pretos por cima das imagens e das cadeias de caracteres de texto que não sejam pretas.
Os documentos com várias imagens gráficas podem não imprimir correctamente na LaserJet 4 no modo PCL a 600 dpi, excepto se a opção Graphics na configuração do driver da impressora no Windows estiver definida para o modo Raster. 

Para aumentar o desempenho de documentos formatados totalmente para orientação horizontal em impressoras não PostScript, o driver da impressora deve ser definido para orientação horizontal na configuração da impressora no Windows. 

Impressão PostScript
Driver AdobePS 3.01   Para obter melhores resultados ao imprimir em impressoras PostScript, a Adobe recomenda que utilize o driver AdobePS 3.01 (ou posterior). O driver e as instruções de instalação estão incluídos no CD do Sampler Acrobat.

Driver AdobePS 2.1.1   Poderá ter problemas ao imprimir a partir do Acrobat Reader 2.1, quando utilizar o driver de impressora AdobePS 2.1.1. Os problemas ocorrem ao imprimir determinados documentos que utilizam tipos de letra TrueType ou caracteres aumentados, tais como aspas tipográficas. Está disponível uma actualização PSPrinter 2.1.2 que resolve estes problemas. A actualização AdobePS 2.1.2 que actualiza uma versão instalada do AdobePS 2.1.1 para o 2.1.2 está disponível nas seguintes origens:

COMPUSERVE.   Escreva GO ADOBE para ir para o forum Adobe.

FTP.  O servidor FTP da Adobe está em ftp.adobe.com. O percurso para a actualização é ftp.adobe.com/pub/adobe/Applications/Drivers/Windows/adobeps.exe

WORLD WIDE WEB. O servidor da World Wide Web da Adobe está em http://www.adobe.com.

TELEFONE.  Marque 800-521-1976 para que lhe seja enviada directamente a disquete com a actualização AdobePS 2.1.2. Poderão ser-lhe cobradas despesas e expedição.

Nota: A actualização não é o driver AdobePS 2.1.2. completo e independente. Só actualizará uma versão previamente instalada do AdobePS 2.1.1.

Problemas de memória. Se tiver problemas, tais como VMerror, ao imprimir em impressoras PostScript de Nível 1 ou 2, é possível que a impressora tenha pouca memória disponível (por exemplo, uma LaserWriter, LaserWriter Plus, LaserWriter II NT ou NTX não actualizada). Há duas soluções possíveis para este problema: 
1/Na caixa de diálogo General Preferences (seleccione no menu Edit/Preferences), poderá escolher só Serif ou só Sans para o tipo de letra de substituição. Isto liberta memória adicional na impressora e o documento será, muito provavelmente, impresso com êxito. 
2/A outra opção é comprar mais memória para a sua impressora.
Apple Personal LaserWriter NT   Se estiver a utilizar uma impressora Apple Personal LaserWriter NT que não foi actualizada para uma Personal LaserWriter NTR, o Acrobat Reader não conseguirá imprimir os tipos de letra de substituição. Contacte o seu concessionário Apple para obter informações sobre a actualização da sua impressora.

Questões diversas
IMPRESSORA CANON BJC 800  Para imprimir correctamente texto, gráficos e imagens nesta impressora, certifique-se de que selecciona a opção Use Print Manager no painel de controlo Printers. 
CANON LBP-8IV  Utilize o modo "bitmap" das impressoras para obter melhores resultados.
DRIVER DE VIDEO MGA8.DRV DA COMPAQ  Utilizar este driver de vídeo (instalado no Compaq DeskproXL 586 (1024x768, 640x480, 256 cores) com a placa Compaq Qvision 2000 board poderá provocar uma falha do Acrobat Reader. Solução: Desactive a opção Page Caching na caixa de diálogo Edit > Preferences > General.
HP DESKJET 500C  Esta impressora tem uma área não imprimível junto à parte superior da página. Certifique-se de que utiliza a opção Shrink to Fit da caixa de diálogo Print do Acrobat Reader.
TIPO DE LETRA NÃO ENCONTRADO  Um erro de tipo de letra não encontrado poderá indicar que o ATM não tinha memória suficiente para criar um tipo de letra de substituição. Consulte a secção Melhorar o Desempenho deste ficheiro para obter informações sobre o modo de aumentar a memória disponível para o ATM (se estiver instalado).
INSTALAR  Devido a problemas com alguns Gestores de Ambiente de Trabalho, durante a instalação o grupo de programas Adobe Acrobat e o item de programa Acrobat Reader poderão não ser criados. Por omissão, o programa é instalado no directório c:\acroread e o executável é c:\acroread\acroread.exe.
LOTUS NOTES  Quando abre um ficheiro PDF incorporado a partir de uma base de dados Notes, a janela do Acrobat Reader parece tremer ligeiramente. Isto porque o Lotus Notes fornece instruções OLE ao Acrobat Reader para Show (Mostrar), Hide (Ocultar) e, depois, Show (Mostrar) o documento PDF.
PLACA DE VÍDEO MACH 32 DA ATI  Se estiver a utilizar a placa MACH 32 da ATI, certifique-se de que utiliza o modo de 256 cores com a Color Pallette activada. Ou seja, não utilize o modo de 256 cores com a Color Pallette desactivada. No Acrobat, certifique-se de que a Pallette está activada. 
DRIVER NEC ULTRALITE VERSA LINEAR  As imagens rodadas poderão ser apresentadas com artefactos quando se utiliza o driver de vídeo UltraLite Versa Linear 640x480 de 256 cores. Solução: Utilize o driver UltraLite Versa 640x480 de 256 cores.
DRIVER DE VIDEO NUMBER 9  Quando a cache de páginas do Acrobat Reader está activada, se lhe aparecerem linhas horizontais na página, experimente desligar o modo turbo no driver de vídeo #9GXE. Poderá fazê-lo através do menu Turbo no programa "#9GXE Status" disponível no "#9 Hawkeye Control Panel".
OLE  Ao visualizar um ficheiro PDF que é um objecto OLE incorporado, pode apenas efectuar uma gravação incremental, e não uma gravação total. As operações que necessitam de uma gravação total são, por exemplo, a inserção de outro ficheiro PDF. Desta forma, não poderá efectuar esta operação num objecto OLE incorporado.
OS/2  O Acrobat Reader deverá ser executado no modo de compatibilidade com o Windows 3.1 do OS/2 2.1 e OS/2 2.1.1.
CACHE DE PÁGINAS  A cache de páginas está desactivada para monitores de 16 bits e de 24 bits e a opção aparece desactivada na caixa de diálogo General Preferences.
PADRÕES  Os ficheiros produzidos pelo Acrobat Distiller que contêm padrões poderão ser apresentados lentamente e provocar insuficiências de memória. Este pode ser muitas vezes o caso quando as aplicações representam os padrões como milhares de caracteres de tipos de letra de Tipo 3 pequenos. Se tiver este problema, recomenda-se que utilize cores, em vez de preenchimentos com padrões.
PC TOOLS PARA WINDOWS 1.0  Não são criados nenhum grupo Adobe Acrobat nem itens/ícones de programa. Consulte o problema INSTALAR acima indicado para obter uma descrição da solução alternativa. 
PHONENET  O PhoneNet não efectua correctamente a correspondência dos nomes de ficheiro de Macintosh que contêm caracteres ASCII maiúsculos. Desta forma, não conseguirá abrir esses ficheiros no Acrobat Reader. Solução: Não utilize caracteres especiais nos nomes dos ficheiros que se destinem a ser acedidos por utilizadores de Macintosh e de Windows numa rede PhoneNet.
IMPRESSÃO A PARTIR DO FILE MANAGER  Só um ficheiro PDF de cada vez pode ser seleccionado e impresso a partir do File Manager.
ROTAÇÃO DE PÁGINAS  A rotação de páginas resulta na perda das imagens miniatura relativas a essas páginas. Pode voltar a gerar as miniaturas escolhendo Edit/Thumbnails/Create All. 
TIPOS DE LETRA TRUETYPE RODADOS/TRANSFORMADOS  Poderá ter alguns problemas em apresentar ou imprimir tipos de letra TrueType rodados ou, de outra forma, transformados. Esta é uma limitação dos tipos de letra TrueType e do Windows. Para obter melhores resultados, recomendamos que utilize os tipos de letra PostScript Tipo 1 da Adobe nos seus documentos. 
MODO STANDARD  O Acrobat Reader 2.1 não funciona em modo standard; tem de executar o Windows 3.1 em modo avançado (enhanced).
SYSHOOK  Syshook é uma aplicação que corrige os menus de sistema das aplicações; não funciona bem com o Acrobat Reader. 
TRUE TYPE  Os tipos de letra TrueType não podem voltar a ser codificados. Devido a esta limitação, os documentos que foram criados utilizando alguns caracteres especiais num tipo de letra de Tipo 1 poderão não ser apresentados correctamente, se uma versão TrueType do tipo de letra com o mesmo nome for instalada no seu sistema. Quando isto acontece, é apresentada a mensagem de erro "Some text in the font and character 'FONTNAME ###' could not be displayed or printed correctly. The font could not be reencoded.". Uma vez que os instaladores do Acrobat não substituem as versões TrueType de Times, Helvetica e Courier, poderá obter esta mensagem com estes tipos de letra. Solução: Utilize a opção Custom Install para instalar uma versão Tipo 1 destes tipos de letra.
WINDOWS FOR WORKGROUPS  As extensões de Netware do Windows for Workgroups (\windows\netx.com) são conhecidas por causarem problemas na caixa de diálogo Open do Acrobat Reader, bem como nas caixas de diálogo Open de outras aplicações. Solução: Contacte a Microsoft.
CORES INCORRECTAS  Se as cores no seu monitor parecem estar completamente erradas, tente o seguinte: no ficheiro ini do Acrobat Reader (c:\windows\acroread.ini), altere a linha 'IS8514=4' para 'IS8514=105'.


CRIAÇÃO DE DOCUMENTOS PDF
=========================
Para tirar partido dos benefícios dos documentos electrónicos, pode comprar o  Acrobat Exchange, o Acrobat Pro ou o Acrobat for Workgroups com o cupão contido no Online Guide do Acrobat Reader (disponível no CD Sampler do Acrobat) ou telefonando para 800-87-ADOBE (800-872-3623). Com os produtos Acrobat completos, pode:

- Criar os documentos electrónicos tão facilmente como quando imprime a partir das suas aplicações com o PDF Writer.
- Proteger os ficheiros com senhas; controlar o acesso, a impressão, a alteração do documento, a adição e alteração de notas, a cópia de texto e gráficos.
- Encontrar exactamente o que precisa em vários ficheiros PDF, pesquisando por palavras-chave, autor, título, sinónimos de assunto, etc.
- Reutilizar informações facilmente através da extracção, cópia, reorganização e substituição de páginas entre ficheiros PDF -- com marcadores, referências e notas preservadas.
- Criar vistas personalizadas das informações.
- Acrescentar valor, definir prioridades e manter uma rede de informações dinâmica com referências, marcadores, notas e ligações a documentos e aplicações externas.
- Tirar partido de plug-ins de outros fornecedores para acrescentar novas funcionalidades ao Acrobat.
- Integrar o Acrobat nas suas aplicações de ambiente de trabalho com o suporte do Acrobat para automatização OLE, Notes F/X, AppleEvents, e muito mais.

ASSISTÊNCIA TÉCNICA
===================
Para obter informações técnicas e respostas, pode tirar partido dos Basic Support Services da Adobe em qualquer altura. É apenas responsável pelas despesas telefónicas. Estes serviços incluem:
- Adobe US Automated Technical Support -- sistema de diagnóstico por computador a tempo inteiro, com respostas às perguntas mais frequentes. Marque 1-206-628-2757 24 horas por dia, 7 dias por semana.
- Adobe US Fax Request Line -- uma forma simples de pedir notas técnicas gratuitas por fax. Marque 1-206-628-5737 24 horas por dia, 7 dias por semana.
- CompuServe Questions and Answers -- um BBS da Adobe para subscritores da CompuServe. Directório: GO ADOBE
- Adobe US Electronic Bulletin Board -- Um banco de informações que funciona 24 horas por dia. Marque 1-206-623-6984.

Apenas para os E.U.A. -- para os utilizadores dos produtos Adobe Acrobat nos E.U.A. e no Canadá, entre as opções de suporte pago incluem-se:
- 900-555-2276 -- este serviço 900 empresa a empresa é uma forma de os utilizadores pouco frequentes obterem ajuda de um Representante da Assistência Técnica da Adobe. 
  Cada minuto custa $2.00 mais a taxa da ligação telefónica, se houver. Os
  custos aparecerão discriminados na sua conta telefónica mensal.

ACORDO DE LICENÇA ELECTRÓNICO PARA O UTILIZADOR FINAL
=====================================================
Adobe Systems Incorporated
Acordo de licença electrónico para o utilizador final

AVISO PARA O UTILIZADOR:
ISTO É UM CONTRATO. INDICANDO A SUA ACEITAÇÃO ABAIXO, ACEITA TODOS  OS TERMOS E CONDIÇÕES DESTE ACORDO.
Este Acordo de Licença para o Utilizador Final da Adobe Systems Incorporated ("Adobe") acompanha um produto de software da Adobe e os materiais explicativos escritos relacionados ("Software"). 

O termo "Software" deverá também incluir quaisquer actualizações, versões modificadas ou actualizações do software para o qual recebeu a licença por parte da Adobe. Como utilizador final, foi-lhe concedida uma licença para esta cópia do Software. Deve ler cuidadosamente este Acordo antes de indicar a sua aceitação no final do respectivo texto. 
Se não concordar com os termos e condições deste Acordo, recuse-o onde for apropriado durante a instalação pelo que não poderá utilizar o Software. A Adobe concede-lhe uma licença não exclusiva para utilizar o Software, desde que concorde com o seguinte: 

1. Utilização do Software. Pode instalar o Software numa única localização no disco rígido ou outro dispositivo de armazenamento; instalar e utilizar o Software num servidor de ficheiros para o poder utilizar numa rede para ser instalado de forma permanente em discos rígidos ou outros dispositivos de armazenamento ou para utilizar o software nessa mesma rede; e fazer cópias de segurança do Software. Pode fazer um número ilimitado de cópias do Software e dar cópias a outras pessoas ou entidades, desde que as cópias contenham este Acordo e os mesmos avisos de propriedade e direitos de autor que aparecem no Software.

2. Direitos de Autor. O Software é propriedade da Adobe e dos seus fornecedores, e a sua estrutura, organização e código constituem valiosos segredos comerciais da Adobe e dos seus fornecedores. O Software está igualmente protegido pelas leis de direitos de autor dos Estados Unidos da América e pelas disposições de tratados internacionais. Concorda em não modificar, adaptar, converter, efectuar reverse-engineering, descompilar, desassemblar ou, de outra forma, tentar descobrir o código de origem do Software. Pode utilizar marcas comerciais apenas para identificar cópias impressas produzidas pelo Software, de acordo com a prática das marcas comerciais aceite, incluindo a identificação do nome do proprietário da marca comercial. Este tipo de utilização de qualquer marca comercial não lhe dá quaisquer direitos de propriedade em relação a essa marca comercial. 
Excepto da forma acima indicada, este Acordo não lhe concede quaisquer direitos de propriedade intelectual em relação ao Software.

3. Transferência. Não pode alugar ou sublicenciar o Software. Contudo, pode transferir todos os seus direitos de utilização do software para outra pessoa ou entidade, desde que transfira este Acordo juntamente com o Software.

4. Exclusão de Garantia. O Software é-lhe entregue TAL COMO ESTÁ e a Adobe não dá qualquer garantia relativa à sua utilização ou desempenho. A ADOBE E OS SEUS FORNECEDORES NÃO GARANTEM E NÃO PODEM GARANTIR O DESEMPENHO OU OS RESULTADOS QUE PODERÁ OBTER AO UTILIZAR A SOFTWARE OU A DOCUMENTAÇÃO. A ADOBE E OS SEUS FORNECEDORES NÃO DÃO QUALQUER GARANTIA, QUER EXPRESSA QUER IMPLÍCITA, NO QUE SE REFERE À INFRACÇÃO DOS DIREITOS DE TERCEIROS, COMERCIALIZAÇÃO OU ADEQUAÇÃO A FINS ESPECÍFICOS. EM CASO ALGUM A ADOBE OU OS SEUS FORNECEDORES SERÃO RESPONSÁVEIS POR QUAISQUER DANOS CONSEQUENCIAIS, ACIDENTAIS OU ESPECIAIS, INCLUINDO QUAISQUER PERDAS DE LUCROS OU RECEITAS, MESMO QUE UM REPRESENTANTE DA ADOBE TENHA SIDO AVISADO DA POSSIBILIDADE DE OCORRÊNCIA DE TAIS DANOS, OU POR QUALQUER RECLAMAÇÃO FEITA POR TERCEIROS.  
Alguns estados ou jurisdições não permitem a exclusão ou limitação de danos acidentais, consequenciais ou especiais, ou a exclusão de garantias implícitas ou limitações sobre a duração de uma garantia implícita, pelo que as limitações acima descritas podem não se aplicar ao seu caso.
 
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
 
Queira indicar a sua aceitação ou recusa deste Acordo seleccionando a caixa apropriada durante a instalação.

Adobe, Acrobat e Adobe Type Manager são marcas comerciais da Adobe Systems,
Incorporated e podem estar registadas em algumas jurisdições. 
(c) 1983-1995 Adobe Systems Incorporated. Todos os direitos reservados.

