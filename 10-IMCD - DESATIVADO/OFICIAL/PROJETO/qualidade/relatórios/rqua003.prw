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

User Function RQUA003(aEnsaios,aDadosPro)

	Local cDotRede		:= "word\Certificado de Analise.dotm"     //criar a pasta WORD debaixo do \system
	Local cIniFile		:= GetADV97()
	Local cStartPath	:= GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )
	Local cDocsCQPath	:= Alltrim(GetMv("MV_QIEDOC",,"\DocsCQ"))
	Local cDotLocal		:= "C:\temp"												//	Alltrim(GetMv("MV_PATHCER",,"C:\temp"))
	Local cAnexLoc		:= Alltrim(GetMv("MV_PATHCER",,"C:\temp"))
	Local cArqDot		:= "Certificado de Analise.dotm"
	Local cPerg			:= 'RQUA003'
	Local nDelay		:= 100 //Delay entre as macro execucoes do Word
	//Local lNum		:= .T.
	Local nX			:= 0

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RQUA003" , __cUserID )

	Private	 hWord

	//Conecta ao word
	hWord	:= OLE_CreateLink()
	if hWord == "-1"
		u_MsgHBox("Impossível estabelecer comunicação com o Microsoft Word.", "RFAT035")
		Return Nil
	Endif

	MontaDir(cDotLocal)
	MontaDir(cAnexLoc)

	If File(cDotLocal+'\'+ cArqDot)
		FErase(cDotLocal+'\'+ cArqDot)
	EndIf

	If !CpyS2T( cStartPath + cDotRede, cDotLocal+'\', .T. )
		MsgBox("Impossível copiar modelo word para o disco local!", "STOP")
		return nil
	endif                                               

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando novo documento do Word na estacao                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_NewFile( hWord, Alltrim( cDotLocal +'\'+ cArqDot ) )

	//OLE_NewFile(hWord, cPathDot )
	OLE_SetProperty( hWord, oleWdVisible, .T. )

	OLE_SetDocumentVar(hWord, 'Prt_nroitens',str(Len(aEnsaios)))	// variavel para identificar o numero total de linhas na parte variavel
	// Sera utilizado na macro do documento para execucao do for next

	//Aadd(aDadosPro,{cDescProd,cDCB,cCAS, cLoteForn, dDataFab, dDataVal, cFornecedor, cObservacoes, cCodCliente, aDocLaudoOri, cNFSaida})

	OLE_SetDocumentVar(hWord, 'Produto'		, aDadosPro[1,1]  )
	OLE_SetDocumentVar(hWord, 'DCB'			, aDadosPro[1,2]  )
	OLE_SetDocumentVar(hWord, 'CAS'			, aDadosPro[1,3]  )
	//OLE_SetDocumentVar(hWord, 'LoteFornec'	, aDadosPro[1,4]  )
	OLE_SetDocumentVar(hWord, 'DataFabric'	, DtoC(aDadosPro[1,5])  )
	OLE_SetDocumentVar(hWord, 'DataValid'	, DtoC(aDadosPro[1,6])  )
	OLE_SetDocumentVar(hWord, 'Fornecedor'	, aDadosPro[1,7]  )
	OLE_SetDocumentVar(hWord, 'Observacoes'	, aDadosPro[1,8]  )
	OLE_SetDocumentVar(hWord, 'CodCliente'	, aDadosPro[1,9]  )
	OLE_SetDocumentVar(hWord, 'NotaFiscal'	, aDadosPro[1,11]  )
	OLE_SetDocumentVar(hWord, 'LoteFornec'	, aDadosPro[1,12]  )   

	// Lote fornecedor - solicitado por Rafael, implementado por Daniel em 19/09/11
	// Definido em 20/09/11 que se o lote do fornecedor estiver em branco, utilizar o lote interno.
	OLE_SetDocumentVar(hWord, 'Loteint'		, IIF(Empty(aDadosPro[1,14]),AllTrim(aDadosPro[1,12])+".",aDadosPro[1,14]) ) 

	// Observações adicionais farma solicitado por Rafael em 04/07/11, implementado by Daniel
	OLE_SetDocumentVar(hWord, 'obsca'		, aDadosPro[1,13]  )

	For nX := 1 to Len(aEnsaios)

		cEnsaio  := "'cEnsaio"  + Alltrim(str(nX)) + "'"
		cEspecif := "'cEspecif" + Alltrim(str(nX)) + "'"
		cMetodo  := "'cMetodo"  + Alltrim(str(nX)) + "'"
		cResult  := "'cResult"  + Alltrim(str(nX)) + "'"

		OLE_SetDocumentVar(hWord, &cEnsaio  , aEnsaios[nX,1]  )    
		OLE_SetDocumentVar(hWord, &cEspecif , aEnsaios[nX,2]  )
		OLE_SetDocumentVar(hWord, &cMetodo  , aEnsaios[nX,3]  ) 
		OLE_SetDocumentVar(hWord, &cResult  , aEnsaios[nX,4]  )

		//  Retirar da rotina solicitacao abaixo por Emerson em 07/10/10 by Daniel
		//	lNum := .T.                                                     
		//	
		//	For kkk := 1 to Len(AllTrim(aEnsaios[nX,4]))
		//		If Substr(aEnsaios[nX,4],kkk,1) $ "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz<=>!?/|\[]()*@#$%&{}"
		//			lNum := .F.
		//			Exit
		//		Endif
		//	Next
		//	OLE_SetDocumentVar(hWord, &cResult  , IIF(!lNum, aEnsaios[nx,4], AllTrim( StrTran( Str( Val( StrTran( aEnsaios[nX,4],",","." ) ) , 20 , 4 ),".","," ) ) )  )

	Next nX

	OLE_ExecuteMacro(hWord,"TabEnsaios")

	If ! Empty(aDadosPro[1,10])
		For nX := 1 to Len(aDadosPro[1,10])
			//If Right(Upper(Alltrim(aDadosPro[1,10,nX])),3) = "JPG"
				CpyS2T( cDocsCQPath+"\"+aDadosPro[1,10,nX], cDotLocal+'\', .T. )
				Frename(cDotLocal+'\'+aDadosPro[1,10,nX], cDotLocal+"\anexocq.jpg")
				OLE_ExecuteMacro(hWord,"AnexaDoc")
				Ferase(cDotLocal+"\anexocq.jpg")
			//Endif
		Next nX
	EndIf

	OLE_UpdateFields(hWord)
	cSaveFile := 'Certificado_Analise_' + DtoS(dDataBase) + If(Empty(Alltrim(aDadosPro[1,11])),"","_" + Alltrim(aDadosPro[1,11])) + If(Empty(Alltrim(aDadosPro[1,12])),"","_" + Alltrim(aDadosPro[1,12])) + "_" + Alltrim(aDadosPro[1,1]) +".docx"
	cSaveFile := StrTran(cSaveFile,"/","-")

	If File(cAnexLoc+"\"+ cSaveFile)
		FErase(cAnexLoc+"\"+ cSaveFile)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva o arquivo em arquivo do disco rigido para envio do email        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_SaveAsFile(hWord, cAnexLoc+"\"+ cSaveFile )
	Sleep(4000)	// Espera 2 segundos pra dar tempo de imprimir.

	OLE_PrintFile( hWord,"ALL",,,1 )
	Sleep(4000)	// Espera 2 segundos pra dar tempo de imprimir.

	OLE_CloseFile( hWord )
	OLE_CloseLink( hWord )

Return()
