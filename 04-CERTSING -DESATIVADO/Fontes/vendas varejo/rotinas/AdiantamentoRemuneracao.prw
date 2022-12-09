#include 'protheus.ch'

#DEFINE SEPARADOR 			";"

//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CRPA078  |Autor: | Yuri Volpe            |Data: |15/07/2020   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Rotina de chamada do Menu para execução dos títulos de        |
//|             |adiantamentos de comissão realizados aos parceiros.           |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CRPA078()

	Local oAdtoFun 	:= Nil
	Local Ni		:= 0

	oAdtoFun := AdiantamentoRemuneracao():New()
	
	If oAdtoFun:nOpc == 2
		MsgInfo("O processamento foi cancelado.")
		Return
	EndIf
	
	If Len(oAdtoFun:aArquivos) == 0
		MsgInfo("Não há arquivos a serem processados.")
		Return
	EndIf
		
	For Ni := 1 To Len(oAdtoFun:aArquivos)
		Processa({|| oAdtoFun:processaArquivo(oAdtoFun:cDiretorio + oAdtoFun:aArquivos[Ni][1])}, "Adiantamento Parceiros", "Processando arquivo " + oAdtoFun:aArquivos[Ni][1], .F. )
	Next
	

Return

/*/{Protheus.doc} AdiantamentoRemuneracao
//Classe que controla a geração e consulta de títulos para Adiantamento de Parceiros.
@author    yuri.volpe
@since     13/07/2020
@version   1.0
/*/
class AdiantamentoRemuneracao 

	Data cDiretorio 
	Data aArquivos 
	Data nOpc 
	Data aDirIn
	Data cDirIn

	method new() constructor
	Method createScreen()
	Method processaArquivo(cArquivo)  

endclass

/*/{Protheus.doc} new
Metodo construtor
@author    yuri.volpe
@since     13/07/2020
/*/
Method new() class AdiantamentoRemuneracao

	::cDiretorio	:= Space(256)
	::aArquivos		:= {}
	::createScreen()
	
Return

/*/{Protheus.doc} createScreen
//Método para apresentação da tela de importação do arquvivo
@author yuri.volpe
@since 16/07/2020
@version 1.0

@type function
/*/
Method createScreen() Class AdiantamentoRemuneracao

	Local cTitle 	:= "Adiantamento de Parceiros - Integração de Arquivos"
	Local cLabelArq := "Dir. Arq. de Entrada"
	Local cBtArq	:= "Arquivo"
	Local cBtOk		:= "OK"
	Local cBtCancel := "Cancelar"
	Local Ni		:= 0
	Local cDirIn	:= Space(256)
	Local aDirIn	:= {}

	DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE cTitle PIXEL
	
	@ 10,10 SAY cLabelArq OF oDlg PIXEL
	@ 10,70 MSGET cDirIn SIZE 200,5 OF oDlg PIXEL
	
	@ 45,010 BUTTON cBtArq		SIZE 40,13 OF oDlg PIXEL ACTION CRPA078A(@aDirIn,@cDirIn)
	@ 45,060 BUTTON cBtOk		SIZE 40,13 OF oDlg PIXEL ACTION (!Empty(cDirIn) .And. ExistDir(cDirIn),::nOpc := 1,oDlg:End())
	@ 45,230 BUTTON cBtCancel	SIZE 40,13 OF oDlg PIXEL ACTION (::nOpc := 2,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	::aArquivos := aDirIn
	::cDiretorio:= cDirIn
			
Return

/*/{Protheus.doc} processaArquivo
//Rotina responsável por processar o arquivo e realizar as devidas
//operações para gerar o título e o log final de processamento.
@author yuri.volpe
@since 16/07/2020
@version 1.0
@param cArquivo, characters, Caminho e nome do arquivo
@type function
/*/
Method processaArquivo(cArquivo) Class AdiantamentoRemuneracao

	Local oArquivo 	:= Nil
	Local oTitulo	:= Nil
	Local oLog  	:= Nil
	Local aLinha	:= {}
	Local aProcRet	:= {}

	oLog := Log():New()
	oLog:cTitulo := "Títulos de Adiantamento de Parceiros"
	oLog:setHeader(TituloRemuneracao():toArrayHeader())
	
	oArquivo := FileInputStream():New(cArquivo)
	
	ProcRegua(oArquivo:nTotalLines)
	
	While oArquivo:hasNext()
		
		IncProc("Processando linha " + cValToChar(oArquivo:nLine)) 
		ProcessMessage()
	
		aLinha := oArquivo:readLineToArray(SEPARADOR)
		
		oTitulo := TituloRemuneracao():New()
		oTitulo:loadFromArray(aLinha)
				
		If !oTitulo:save()
			oLog:addLog(oTitulo:toArray(oLog:LOG_ERRO + oTitulo:mensagemSave))
		Else
			oLog:addLog(oTitulo:toArray(oTitulo:mensagemSave))
		EndIf
		
		FreeObj(oTitulo)
		oTitulo := Nil
		
	EndDo

	oArquivo:close()
	
	oLog:dumpToExcel()
	//oLog:end()
	
	FreeObj(oArquivo)
	FreeObj(oTitulo)
	FreeObj(oLog)

Return

/*/{Protheus.doc} CRPA078A
//Função estática para controlar interface de abertura do arquivo
@author yuri.volpe
@since 16/07/2020
@version 1.0
@param aDirIn, array, descricao
@param cDirIn, characters, descricao
@type function
/*/
Static Function CRPA078A(aDirIn,cDirIn)

	cDirIn := cGetFile("\", "Diretórios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ) 
	aDirIn := Directory(cDirIn+"*.CSV")

Return(.T.)