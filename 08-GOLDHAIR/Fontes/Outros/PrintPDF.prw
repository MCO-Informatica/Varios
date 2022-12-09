#include "protheus.ch"


/**************************************************************************************************
Fun��o:
PrintPDF

Autor:
Tiago Bandeira Brasiliano

Data:
03/06/2011

Descri��o:
Imprime o relat�rio em uma impressora PDF.
Para isto o programa Doro PDF Writer precisa ser instalado dentro do Root Path do servidor do
Protheus na pasta DoroPDFWriter.
Isto ir� criar uma nova impressora no servidor, que ser� utilizada para a cria��o dos relat�rios
em PDF.

Par�metros:
oPrint        -> Objeto de impress�o do tipo TMSPrinter
cPath         -> Pasta onde ser� gerado o arquivo PDF
cFile         -> Nome do arquivo que ser� gerado
cTitle        -> T�tulo do PDF
cSubject      -> Assunto do arquivo
cKeyWords     -> Palavras chaves
cAuthor       -> Autor do PDF
cProducer     -> Criador do PDF
cLaunchViewer -> Abre depois de gerar o arquivo
cAutoStart    -> Inicia a gera��o do PDF automaticamente
cOverwrite    -> Sobrescreve arquivo caso o mesmo j� exista
cResolution   -> Resolu��o do PDF
cPDFVersion   -> Vers�o do PDF

Retorno:
Nenhum
**************************************************************************************************/
User Function PrintPDF(oPrint, cPath, cFile, cTitle, cSubject, cKeyWords, cAuthor, cProducer, cLaunchViewer, cAutoStart, cOverwrite, cResolution, cPDFVersion)

Private cPDFFolder    := GetNewPar("SY_PDFFLDR", "\DoroPDFWriter")  // Diret�rio padr�o onde a impressora est� instalada (abaixo do Root Path)
Private cPrinterName  := GetNewPar("SY_PRTNAME", "Doro PDF Writer") // Nome de instala��o da impressora (nome que aparece na lista de impressoras no momento da impress�o)
Private cPathPDF      := "D:\TOTVS11\Microsiga\Protheus_data\Images"
Default cPath         := "Images"//"D:\"
Default cFile         := "Protheus.pdf"
Default cTitle        := ""
Default cSubject      := ""
Default cKeyWords     := ""
Default cAuthor       := ""
Default cProducer     := ""
Default cLaunchViewer := "1"
Default cAutoStart    := "1"
Default cOverwrite    := "1"
Default cResolution   := "300"
Default cPDFVersion   := "5"

//+-------------------------------------------------------+
//| Valida a instala��o da impressora PDF.                |
//+-------------------------------------------------------+
If !CheckPDFDriver()
	Return .F.
EndIf

//+-------------------------------------------------------+
//| Altera o arquivo INI da impressora PDF.               |
//+-------------------------------------------------------+
If !ChangePDFIni(cPath, cFile, cTitle, cSubject, cKeyWords, cAuthor, cProducer, cLaunchViewer, cAutoStart, cOverwrite, cResolution, cPDFVersion)
	Return .F.
EndIf

//+-------------------------------------------------------+
//| Executa a impress�o do relat�rio na impressora PDF    |
//+-------------------------------------------------------+

SendPDF(oPrint)

Return .T.


/**************************************************************************************************
Fun��o:
ChangePDFIni

Autor:
Tiago Bandeira Brasiliano

Data:
03/06/2011

Descri��o:
Altera o cont�do do arquivo Doro.ini.
Este arquivo cont�m informa��es de configura��o da impressora virtual PDF.
Atrav�s dele � poss�vel definir por exemplo qual ser� a pasta onde o arquivo PDF ser� gerado,
e qual o nome do mesmo.

Par�metros:
cPath         -> Pasta onde ser� gerado o arquivo PDF
cFile         -> Nome do arquivo que ser� gerado
cTitle        -> T�tulo do PDF
cSubject      -> Assunto do arquivo
cKeyWords     -> Palavras chaves
cAuthor       -> Autor do PDF
cProducer     -> Criador do PDF
cLaunchViewer -> Abre depois de gerar o arquivo
cAutoStart    -> Inicia a gera��o do PDF automaticamente
cOverwrite    -> Sobrescreve arquivo caso o mesmo j� exista
cResolution   -> Resolu��o do PDF
cPDFVersion   -> Vers�o do PDF

Retorno:
Nenhum
**************************************************************************************************/
Static Function ChangePDFIni(cPath, cFile, cTitle, cSubject, cKeyWords, cAuthor, cProducer, cLaunchViewer, cAutoStart, cOverwrite, cResolution, cPDFVersion)

Local cTexto			:= ""
Local nIniFile			:= 0      
Local cProfString 	:= AllTrim(GetSrvProfString("RootPath",""))

//+-------------------------------------------------------+
//| Valida se o diret�rio onde o PDF ser� salvo existe.   |
//+-------------------------------------------------------+
If !File(cPath)
	MsgAlert("N�o foi localizado o diret�rio onde o arquivo PDF ser� salvo: " + cPath + CRLF + "Favor criar este diret�rio", "Aten��o")
    Return .F.
EndIf

//+-------------------------------------------------------+
//| Define o T�tulo do arquivo PDF                        |
//+-------------------------------------------------------+
cTexto += "[Values]" + CRLF
cTexto += "'{save} - use last title instead of document name" + CRLF
cTexto += "Title=" + cTitle + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Define o assunto do arquivo PDF                       |
//+-------------------------------------------------------+
cTexto += "'{save} - use last title instead of document name" + CRLF
cTexto += "Subject=" + cSubject + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Define a palavra chave do PDF                         |
//+-------------------------------------------------------+
cTexto += "'{save} - use last title instead of document name" + CRLF
cTexto += "Keywords=" + cKeywords + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Define o autor do arquivo PDF                         |
//+-------------------------------------------------------+
cTexto += "Author=" + cAuthor + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Define o criador do arquivo PDF                       |
//+-------------------------------------------------------+
cTexto += "Producer=" + cProducer + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Define o diret�rio onde o arquivo ser� gerado         |
//+-------------------------------------------------------+
If Left(cPath,1) == "\" 
	If Right(cProfString,1) == "\" 
		cProfString := Left(cProfString,len(cProfString)-1)
	EndIf
	cPath := cProfString + cPath
EndIf
cTexto += "Path=" + cPath + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Define o nome do arquivo PDF que ser� gerado          |
//+-------------------------------------------------------+
cTexto += "File=" + cFile + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Define se o PDF ser� exibido ap�s a cria��o (1)       |
//| ou se o mesmo ser� apenas gerado (0).                 |
//+-------------------------------------------------------+
cTexto += "LaunchViewer=" + cLaunchViewer + CRLF
cTexto += CRLF

//+-------------------------------------------------------+
//| Define se o programa ir� iniciar automaticamente,     |
//| ou seja, sem a janela de configura��o (1), ou n�o (0) |
//+-------------------------------------------------------+
cTexto += "AutoStart=" + cAutoStart + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Define se sobrep�e o arquivo automaticamente          |
//+-------------------------------------------------------+
cTexto += "'0 - ask if file exist" + CRLF
cTexto += "'1 - always overwrite" + CRLF
cTexto += "'2 - rename new files adding 1, 2, 3..." + CRLF
cTexto += "Overwrite=" + cOverwrite + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Op��es de compress�o do arquivo.                      |
//+-------------------------------------------------------+
cTexto += "' use 72 for better picture compression" + CRLF
cTexto += "'ColorImageResolution=" + cResolution + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Define a vers�o do PDF que ser� gerado.               |
//+-------------------------------------------------------+
cTexto += "' 3 - set pdf version to 1.3" + CRLF
cTexto += "' 4 - set pdf version to 1.4" + CRLF
cTexto += "' 5 - set pdf version to 1.5" + CRLF
cTexto += "'Version=" + cPDFVersion + CRLF

//+-------------------------------------------------------+
//| Deleta, se houver, arquivo de                         |
//| configura��o do programa Doro                         |
//+-------------------------------------------------------+
If File(cPDFFolder + "\Doro.ini") 
    Ferase(cPDFFolder + "\Doro.ini") 
Endif

//+-------------------------------------------------------+
//| Gera��o de novo arquivo de configura��o do Doro       |
//+-------------------------------------------------------+
nIniFile   := FCreate(cPDFFolder + "\Doro.ini")
If nIniFile < 0
	MsgAlert("N�o foi poss�vel gerar o arquivo de configura��o da impressora (Doro.ini)", "Aten��o")
	Return .F.
Else
	FWrite(nIniFile, cTexto )
	FClose(nIniFile)
Endif

Return .T.


/**************************************************************************************************
Fun��o:
CheckPDFDriver

Autor:
Tiago Bandeira Brasiliano

Data:
03/06/2011

Descri��o:
Efetua algumas valida��es b�sicas para ver se o driver para impress�o PDF est�o instalado no server.
O programa DoroPDFWriter deve ser instalado no server no RootPath do Protheus ao inv�s da pasta
de Arquivo de Programas.
Isto � necess�rio, pois desta forma � poss�vel editar o arquivo INI diretamente no server.
Caso a aplica��o tentasse por exemplo alterar o programa C:\Program Files\DOROPDFWriter\Doro.ini,
isto seria feito no computador onde est� rodando o smartclient, e n�o no server.
Este arquivo � utilizado pelo programa no momento da impress�o para efetuar algumas a��es, como
por exemplo alterar a pasta e o nome do PDF que ser� criado.

Par�metros:
Nenhum

Retorno:
lRet   -> .T. caso o programa de impressora PDF esteja localizado abaixo do RootPath.
**************************************************************************************************/
Static Function CheckPDFDriver()

Local lRet := .T.

//+------------------------------------------------------+
//| Verifica se existe a pasta de instala��o             |
//| do DORO PDF no Root Path                             |
//+------------------------------------------------------+
If !File(cPDFFolder)
	lRet := .F.
EndIf

//+------------------------------------------------------+
//| Verifica se existe o arquivo execut�vel do programa  |
//+------------------------------------------------------+
If lRet .And. !File(cPDFFolder + "\Doro.exe")
	lRet := .F.
EndIf

//+------------------------------------------------------+
//| Verifica se existe a DLL do Programa                 |
//+------------------------------------------------------+
If lRet .And. !File(cPDFFolder + "\Doro.dll")
	lRet := .F.
EndIf

If !lRet
	MsgAlert("O programa Doro PDF Writer, ou um de seus componentes n�o est� instalado corretamente." + CRLF +;
	         "Este programa deve ser instalado no Root Path do Protheus (Protheus_Data) na pasta \DoroPDFWriter.", "Aten��o")
EndIf

Return lRet


/**************************************************************************************************
Fun��o:
SendPDF

Autor:
Tiago Bandeira Brasiliano

Data:
03/06/2011

Descri��o:
Altera as configura��es de impress�o para a impressora PDF do server, envia a impress�o, e depois
retorna as configura��es de impress�o ao padr�o.
Estas configura��es ficam armazenadas em um arquivo INI na esta��o do usu�rio, e cont�m por exemplo
as configura��es da �ltima impressora utilizada pelo mesmo.
Nas vers�es anteriores do Protheus, estas informa��es eram armazenadas em um arquivo chamado win.ini
que ficava dentro da pasta C:\Windows\
Por�m atualmente estas informa��es ficam armazenadas dentro da pasta do usu�rio. Ex.:
C:\Users\Jose\AppData\Local\Temp\totvssmartclient_user_Jose_48853.ini

Par�metros:
Nenhum

Retorno:
Nenhum
**************************************************************************************************/
Static Function SendPDF(oPrint)

//+--------------------------------------------------------+
//| Grava na vari�vel a impressora configurada atualmente  |
//| para restaura-la no t�rmino da impress�o               |
//+--------------------------------------------------------+
Local cPrintPad := GetProfString( "PRINTER_" + GetComputerName(), "DEFAULT","",.T.)
Local cLocalPad := GetProfString( "PRINTER_" + GetComputerName(), "LOCAL","",.T.)

//+--------------------------------------------------------+
//| Altera as configura��es de impress�o para local e      |
//| impressora Doro PDF                                    |
//+--------------------------------------------------------+
WriteProfString( "PRINTER_"+ GetComputerName(), "DEFAULT", cPrinterName, .T. )   
WriteProfString( "PRINTER_"+ GetComputerName(), "LOCAL"  , "SERVER"    , .T. )

//+--------------------------------------------------------+
//| Manda o relat�rio para a impressora. Impressao em PDF  |
//+--------------------------------------------------------+
If Upper(cPrinterName) $ Upper(GetProfString( "PRINTER_"+ GetComputerName(), "DEFAULT","",.T.))
    
   // oPrint:SetCurrentPrinterInUse()
    oPrint:Print()

Endif

//+--------------------------------------------------------+
//| Restaura��o da impressora padr�o utilizada pelo        |
//| sistema operacional / instancia do microsiga           |
//+--------------------------------------------------------+
WriteProfString( "PRINTER_"+ GetComputerName(), "DEFAULT", cPrintPad, .T. )   
WriteProfString( "PRINTER_"+ GetComputerName(), "LOCAL"  , cLocalPad, .T. )   
          
//oPrn := FWMSPrinter():New(cTitle, IMP_PDF, .T.,cPath,.T.)

Sleep(6000) //Aguarda 4 segundos - tempo necessario para que o Doro crie o arquivo PDF

Return .T.