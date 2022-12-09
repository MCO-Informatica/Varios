#include "rwmake.ch"
#include "msole.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RQUA003   ºAutor  ³Richard Nahas Cabralº Data ³  30/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao Certificado de Analise - Via Integracao Word	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RQUA008(CodProd, Produto, aEnsaios, cRev, cDtVige)

	Local cDotRede		:= "word\EspecificacaoProduto2.dotm"     //criar a pasta WORD debaixo do \system
	Local cIniFile		:= GetADV97()
	Local cStartPath	:= GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )
	Local cDocsCQPath	:= Alltrim(GetMv("MV_QIEDOC",,"\DocsCQ"))
	Local cDotLocal		:= "C:\temp"												//	Alltrim(GetMv("MV_PATHCER",,"C:\temp"))
	Local cAnexLoc		:= Alltrim(GetMv("MV_PATHCER",,"C:\temp"))
	Local cArqDot		:= "EspecificacaoProduto2.dotm"
	Local cPerg			:= 'RQUA007'
	Local nDelay		:= 100 //Delay entre as macro execucoes do Word
	Local nX := 0
	///oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RQUA008" , __cUserID )

	Private	 hWord

	MontaDir(cDotLocal)
	MontaDir(cAnexLoc)

	If File(cDotLocal+"\"+ cArqDot)
		FErase(cDotLocal+"\"+ cArqDot)
	EndIf

	Copy File ( cStartPath +  cDotRede ) to ( cDotLocal +"\"+ cArqDot )


	//Conecta ao word
	hWord	:= OLE_CreateLink()
	if hWord == "-1"
		u_MsgHBox("Impossível estabelecer comunicação com o Microsoft Word.", "RFAT035")
		Return Nil
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando novo documento do Word na estacao                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_SetProperty( hWord, oleWdVisible, .T. )

	OLE_OpenFile( hWord, Alltrim( cDotLocal +"\"+ cArqDot ) )

	OLE_SetDocumentVar(hWord, 'Prt_nroitens',str(Len(aEnsaios)))	// variavel para identificar o numero total de linhas na parte variavel
	// Sera utilizado na macro do documento para execucao do for next

	//Aadd(aDadosPro,{cDescProd,cDCB,cCAS, cLoteForn, dDataFab, dDataVal, cFornecedor, cObservacoes, cCodCliente, aDocLaudoOri, cNFSaida})

	OLE_SetDocumentVar(hWord, 'Produto'		, Produto  )       
	OLE_SetDocumentVar(hWord, 'Observacoes'	, ""  )                
	OLE_SetDocumentVar(hWord, 'REV'	, cRev  )                
	OLE_SetDocumentVar(hWord, 'DTVIGE'	, cDtVige  )                

	For nX := 1 to Len(aEnsaios)

		cEnsaio  := "'cEnsaio"  + Alltrim(str(nX)) + "'"
		cEspecif := "'cEspecif" + Alltrim(str(nX)) + "'"


		OLE_SetDocumentVar(hWord, &cEnsaio  , aEnsaios[nX,1]  )
		OLE_SetDocumentVar(hWord, &cEspecif , aEnsaios[nX,2]  )

	Next nX

	OLE_ExecuteMacro(hWord,"TabEnsaios")

	OLE_UpdateFields(hWord)

	cSaveFile := 'Especificacao_Produto_' + DtoS(dDataBase) + "_" + alltrim( CodProd ) + "_" + alltrim( Produto ) + ".docx"
	cSaveFile := StrTran(cSaveFile,"/","-")

	If File(cAnexLoc+"\"+ cSaveFile)
		FErase(cAnexLoc+"\"+ cSaveFile)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva o arquivo em arquivo do disco rigido para envio do email        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//OLE_SaveAsFile(hWord, cAnexLoc+"\"+ cSaveFile )

	OLE_SaveFile( hWord )
	Sleep(4000)	// Espera 2 segundos pra dar tempo de imprimir.

	OLE_PrintFile( hWord )
	Sleep(4000)	// Espera 2 segundos pra dar tempo de imprimir.

	OLE_CloseFile( hWord )
	OLE_CloseLink( hWord )

Return()
