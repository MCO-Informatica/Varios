#include "protheus.ch"


/**************************************************************************************************
Função:
PrintPDF

Autor:
Tiago Bandeira Brasiliano

Data:
03/06/2011

Descrição:
Imprime o relatório em uma impressora PDF.
Para isto o programa Doro PDF Writer precisa ser instalado dentro do Root Path do servidor do
Protheus na pasta DoroPDFWriter.
Isto irá criar uma nova impressora no servidor, que será utilizada para a criação dos relatórios
em PDF.

Parâmetros:
oPrint        -> Objeto de impressão do tipo TMSPrinter
cPath         -> Pasta onde será gerado o arquivo PDF
cFile         -> Nome do arquivo que será gerado
cTitle        -> Título do PDF
cSubject      -> Assunto do arquivo
cKeyWords     -> Palavras chaves
cAuthor       -> Autor do PDF
cProducer     -> Criador do PDF
cLaunchViewer -> Abre depois de gerar o arquivo
cAutoStart    -> Inicia a geração do PDF automaticamente
cOverwrite    -> Sobrescreve arquivo caso o mesmo já exista
cResolution   -> Resolução do PDF
cPDFVersion   -> Versão do PDF

Retorno:
Nenhum
**************************************************************************************************/
User Function PrintPDF(oPrint, cPath, cFile, cTitle, cSubject, cKeyWords, cAuthor, cProducer, cLaunchViewer, cAutoStart, cOverwrite, cResolution, cPDFVersion)

Private cPDFFolder    := GetNewPar("SY_PDFFLDR", "\DoroPDFWriter")  // Diretório padrão onde a impressora está instalada (abaixo do Root Path)
Private cPrinterName  := GetNewPar("SY_PRTNAME", "Doro PDF Writer") // Nome de instalação da impressora (nome que aparece na lista de impressoras no momento da impressão)
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
//| Valida a instalação da impressora PDF.                |
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
//| Executa a impressão do relatório na impressora PDF    |
//+-------------------------------------------------------+

SendPDF(oPrint)

Return .T.


/**************************************************************************************************
Função:
ChangePDFIni

Autor:
Tiago Bandeira Brasiliano

Data:
03/06/2011

Descrição:
Altera o contúdo do arquivo Doro.ini.
Este arquivo contém informações de configuração da impressora virtual PDF.
Através dele é possível definir por exemplo qual será a pasta onde o arquivo PDF será gerado,
e qual o nome do mesmo.

Parâmetros:
cPath         -> Pasta onde será gerado o arquivo PDF
cFile         -> Nome do arquivo que será gerado
cTitle        -> Título do PDF
cSubject      -> Assunto do arquivo
cKeyWords     -> Palavras chaves
cAuthor       -> Autor do PDF
cProducer     -> Criador do PDF
cLaunchViewer -> Abre depois de gerar o arquivo
cAutoStart    -> Inicia a geração do PDF automaticamente
cOverwrite    -> Sobrescreve arquivo caso o mesmo já exista
cResolution   -> Resolução do PDF
cPDFVersion   -> Versão do PDF

Retorno:
Nenhum
**************************************************************************************************/
Static Function ChangePDFIni(cPath, cFile, cTitle, cSubject, cKeyWords, cAuthor, cProducer, cLaunchViewer, cAutoStart, cOverwrite, cResolution, cPDFVersion)

Local cTexto			:= ""
Local nIniFile			:= 0      
Local cProfString 	:= AllTrim(GetSrvProfString("RootPath",""))

//+-------------------------------------------------------+
//| Valida se o diretório onde o PDF será salvo existe.   |
//+-------------------------------------------------------+
If !File(cPath)
	MsgAlert("Não foi localizado o diretório onde o arquivo PDF será salvo: " + cPath + CRLF + "Favor criar este diretório", "Atenção")
    Return .F.
EndIf

//+-------------------------------------------------------+
//| Define o Título do arquivo PDF                        |
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
//| Define o diretório onde o arquivo será gerado         |
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
//| Define o nome do arquivo PDF que será gerado          |
//+-------------------------------------------------------+
cTexto += "File=" + cFile + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Define se o PDF será exibido após a criação (1)       |
//| ou se o mesmo será apenas gerado (0).                 |
//+-------------------------------------------------------+
cTexto += "LaunchViewer=" + cLaunchViewer + CRLF
cTexto += CRLF

//+-------------------------------------------------------+
//| Define se o programa irá iniciar automaticamente,     |
//| ou seja, sem a janela de configuração (1), ou não (0) |
//+-------------------------------------------------------+
cTexto += "AutoStart=" + cAutoStart + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Define se sobrepõe o arquivo automaticamente          |
//+-------------------------------------------------------+
cTexto += "'0 - ask if file exist" + CRLF
cTexto += "'1 - always overwrite" + CRLF
cTexto += "'2 - rename new files adding 1, 2, 3..." + CRLF
cTexto += "Overwrite=" + cOverwrite + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Opções de compressão do arquivo.                      |
//+-------------------------------------------------------+
cTexto += "' use 72 for better picture compression" + CRLF
cTexto += "'ColorImageResolution=" + cResolution + CRLF
cTexto += CRLF
//+-------------------------------------------------------+
//| Define a versão do PDF que será gerado.               |
//+-------------------------------------------------------+
cTexto += "' 3 - set pdf version to 1.3" + CRLF
cTexto += "' 4 - set pdf version to 1.4" + CRLF
cTexto += "' 5 - set pdf version to 1.5" + CRLF
cTexto += "'Version=" + cPDFVersion + CRLF

//+-------------------------------------------------------+
//| Deleta, se houver, arquivo de                         |
//| configuração do programa Doro                         |
//+-------------------------------------------------------+
If File(cPDFFolder + "\Doro.ini") 
    Ferase(cPDFFolder + "\Doro.ini") 
Endif

//+-------------------------------------------------------+
//| Geração de novo arquivo de configuração do Doro       |
//+-------------------------------------------------------+
nIniFile   := FCreate(cPDFFolder + "\Doro.ini")
If nIniFile < 0
	MsgAlert("Não foi possível gerar o arquivo de configuração da impressora (Doro.ini)", "Atenção")
	Return .F.
Else
	FWrite(nIniFile, cTexto )
	FClose(nIniFile)
Endif

Return .T.


/**************************************************************************************************
Função:
CheckPDFDriver

Autor:
Tiago Bandeira Brasiliano

Data:
03/06/2011

Descrição:
Efetua algumas validações básicas para ver se o driver para impressão PDF estão instalado no server.
O programa DoroPDFWriter deve ser instalado no server no RootPath do Protheus ao invés da pasta
de Arquivo de Programas.
Isto é necessário, pois desta forma é possível editar o arquivo INI diretamente no server.
Caso a aplicação tentasse por exemplo alterar o programa C:\Program Files\DOROPDFWriter\Doro.ini,
isto seria feito no computador onde está rodando o smartclient, e não no server.
Este arquivo é utilizado pelo programa no momento da impressão para efetuar algumas ações, como
por exemplo alterar a pasta e o nome do PDF que será criado.

Parâmetros:
Nenhum

Retorno:
lRet   -> .T. caso o programa de impressora PDF esteja localizado abaixo do RootPath.
**************************************************************************************************/
Static Function CheckPDFDriver()

Local lRet := .T.

//+------------------------------------------------------+
//| Verifica se existe a pasta de instalação             |
//| do DORO PDF no Root Path                             |
//+------------------------------------------------------+
If !File(cPDFFolder)
	lRet := .F.
EndIf

//+------------------------------------------------------+
//| Verifica se existe o arquivo executável do programa  |
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
	MsgAlert("O programa Doro PDF Writer, ou um de seus componentes não está instalado corretamente." + CRLF +;
	         "Este programa deve ser instalado no Root Path do Protheus (Protheus_Data) na pasta \DoroPDFWriter.", "Atenção")
EndIf

Return lRet


/**************************************************************************************************
Função:
SendPDF

Autor:
Tiago Bandeira Brasiliano

Data:
03/06/2011

Descrição:
Altera as configurações de impressão para a impressora PDF do server, envia a impressão, e depois
retorna as configurações de impressão ao padrão.
Estas configurações ficam armazenadas em um arquivo INI na estação do usuário, e contém por exemplo
as configurações da última impressora utilizada pelo mesmo.
Nas versões anteriores do Protheus, estas informações eram armazenadas em um arquivo chamado win.ini
que ficava dentro da pasta C:\Windows\
Porém atualmente estas informações ficam armazenadas dentro da pasta do usuário. Ex.:
C:\Users\Jose\AppData\Local\Temp\totvssmartclient_user_Jose_48853.ini

Parâmetros:
Nenhum

Retorno:
Nenhum
**************************************************************************************************/
Static Function SendPDF(oPrint)

//+--------------------------------------------------------+
//| Grava na variável a impressora configurada atualmente  |
//| para restaura-la no término da impressão               |
//+--------------------------------------------------------+
Local cPrintPad := GetProfString( "PRINTER_" + GetComputerName(), "DEFAULT","",.T.)
Local cLocalPad := GetProfString( "PRINTER_" + GetComputerName(), "LOCAL","",.T.)

//+--------------------------------------------------------+
//| Altera as configurações de impressão para local e      |
//| impressora Doro PDF                                    |
//+--------------------------------------------------------+
WriteProfString( "PRINTER_"+ GetComputerName(), "DEFAULT", cPrinterName, .T. )   
WriteProfString( "PRINTER_"+ GetComputerName(), "LOCAL"  , "SERVER"    , .T. )

//+--------------------------------------------------------+
//| Manda o relatório para a impressora. Impressao em PDF  |
//+--------------------------------------------------------+
If Upper(cPrinterName) $ Upper(GetProfString( "PRINTER_"+ GetComputerName(), "DEFAULT","",.T.))
    
   // oPrint:SetCurrentPrinterInUse()
    oPrint:Print()

Endif

//+--------------------------------------------------------+
//| Restauração da impressora padrão utilizada pelo        |
//| sistema operacional / instancia do microsiga           |
//+--------------------------------------------------------+
WriteProfString( "PRINTER_"+ GetComputerName(), "DEFAULT", cPrintPad, .T. )   
WriteProfString( "PRINTER_"+ GetComputerName(), "LOCAL"  , cLocalPad, .T. )   
          
//oPrn := FWMSPrinter():New(cTitle, IMP_PDF, .T.,cPath,.T.)

Sleep(6000) //Aguarda 4 segundos - tempo necessario para que o Doro crie o arquivo PDF

Return .T.