#Include "Protheus.ch" 
#Include "TBIConn.ch" 
#Include "Colors.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"

User Function zGerDanfe(cTab)
	Local aArea     := GetArea()
	Local cIdent    := ""
	Local oDanfe    := Nil
	Local cArquivo  	:= "Danfe"+ALLTRIM(Iif(cTab$"SF2",SF2->F2_SERIE,SC5->C5_SERIE))+ALLTRIM(Iif(cTab$"SF2",SF2->F2_DOC,SC5->C5_NOTA))
	Local lEnd      := .F.
	Local nTamNota  := TamSX3('F2_DOC')[1]
	Local nTamSerie := TamSX3('F2_SERIE')[1]
	Local cCriaPasta := MakeDir("C:\DANFES\")
	Local cNota   		:= Iif(cTab$"SF2",SF2->F2_DOC,SC5->C5_NOTA)
	Local cSerie  		:= Iif(cTab$"SF2",SF2->F2_SERIE,SC5->C5_SERIE)	
	Private PixelX
	Private PixelY
	Private nConsNeg
	Private nConsTex
	Private oRetNF
	Private lPtImpBol
	Private aNotasBol
	Private nColAux
	Default cPasta  := "C:\DANFES\"
	
	
	//se nota nao autorizada fecha a tela
	If !SF2->F2_FIMP$"S"
		MsgAlert("Nota fiscal não autorizada. Favor verificar o MONITOR.", "DANFE")
		Return
	EndIf
		
	//Se existir nota
	If !Empty(cNota)
		//Pega o IDENT da empresa
		cIdent := RetIdEnti()
		
		//Se o último caracter da pasta não for barra, será barra para integridade
		If SubStr(cPasta, Len(cPasta), 1) != "\"
			cPasta += "\"
		EndIf
		
		//Gera o XML da Nota
		//cArquivo := cNota + "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")
		//u_zSpedXML(cNota, cSerie, cPasta + cArquivo  + ".xml", .F.)
		
		/*if cCriaPasta != 0
    		Alert( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
  		endif*/
		
		//Define as perguntas da DANFE
		Pergunte("NFSIGW",.F.)
		MV_PAR01 := PadR(cNota,  nTamNota)     //Nota Inicial
		MV_PAR02 := PadR(cNota,  nTamNota)     //Nota Final
		MV_PAR03 := PadR(cSerie, nTamSerie)    //Série da Nota
		MV_PAR04 := 2                          //NF de Saida
		MV_PAR05 := 1                          //Frente e Verso = Sim
		MV_PAR06 := 2                          //DANFE simplificado = Nao
		
		//Cria a Danfe
		oDanfe := FWMSPrinter():New(cArquivo, IMP_SPOOL, .F.,cPasta, .T.)
		
		//Propriedades da DANFE
		oDanfe:SetResolution(78)
		oDanfe:SetPortrait()
		oDanfe:SetPaperSize(DMPAPER_A4)
		oDanfe:SetMargin(60, 60, 60, 60)
		
		//Força a impressão em PDF
		oDanfe:nDevice  := 6
		oDanfe:cPathPDF := cPasta				
		oDanfe:lServer  := .F.
		oDanfe:lViewPDF := .T.
		
		//Variáveis obrigatórias da DANFE
		PixelX    := oDanfe:nLogPixelX()
		PixelY    := oDanfe:nLogPixelY()
		nConsNeg  := 0.4
		nConsTex  := 0.5
		oRetNF    := Nil
		lPtImpBol := .F.
		aNotasBol := {}
		nColAux   := 0
		
		//Chamando a impressão da danfe no RDMAKE
		RptStatus({|lEnd| U_DANFEProc(@oDanfe, @lEnd, cIdent, , , .F.)}, "Imprimindo Danfe...")
		//RptStatus({|lEnd| StaticCall(DANFEII, DanfeProc, @oDanfe, @lEnd, cIdent, , , .F.)}, "Imprimindo Danfe...")
				 // {|lEnd| U_DANFEProc(@oDanfe, @lEnd, cIDEnt, Nil, Nil, @lExistNFe, lIsLoja,,lAutomato )}, "Imprimindo DANFE..." )
		oDanfe:Preview()
	EndIf
	
	
	RestArea(aArea)
Return
