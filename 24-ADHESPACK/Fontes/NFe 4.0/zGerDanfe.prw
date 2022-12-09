#Include "Protheus.ch" 
#Include "TopConn.ch"
#Include "TBIConn.ch" 
#Include "Colors.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"

User Function zGerDanfe()
	Local aArea     	:= GetArea()
	Local cIdent    	:= ""
	Local oDanfe    	:= Nil
	Local cArquivo  	:= ""
	Local lEnd      	:= .F.
	Local nTamNota  	:= TamSX3('F2_DOC')[1]
	Local nTamSerie 	:= TamSX3('F2_SERIE')[1]
	Local cCriaPasta 	:= MakeDir("C:\DANFES\")
	Local cQuery		:= ""
	Private PixelX
	Private PixelY
	Private nConsNeg
	Private nConsTex
	Private oRetNF
	Private lPtImpBol
	Private aNotasBol
	Private nColAux
	Default cPasta  := "C:\DANFES\"
	
	
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
		IF Pergunte("NFSIGW",.T.)			

			MV_PAR04 := 2                          //NF de Saida
			MV_PAR05 := 1                          //Frente e Verso = Sim
			MV_PAR06 := 2                          //DANFE simplificado = Nao

			cQuery := " SELECT F2_DOC, F2_SERIE "
			cQuery += " FROM "+RetSqlName("SF2")+" AS SF2 "
			//cQuery += " WHERE F2_DOC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
			cQuery += " WHERE F2_DOC >= '"+MV_PAR01+"' AND "
			cQuery += " F2_DOC <= '"+MV_PAR02+"' AND "
			cQuery += " F2_SERIE = '"+MV_PAR03+"' AND "
			cQuery += " F2_FILIAL = '"+xFilial("SF2")+"' AND "
			cQuery += " SF2.D_E_L_E_T_ <> '*' "
			cQuery += " ORDER BY F2_DOC "

			TCQUERY cQuery NEW ALIAS QUERY
			DbSelectArea("QUERY")
			QUERY->(DbGoTop())

			WHILE QUERY->(!EOF())

				MV_PAR01 := QUERY->F2_DOC
				MV_PAR02 := QUERY->F2_DOC

				cArquivo  	:= "Danfe"+Alltrim(QUERY->F2_SERIE)+Alltrim(QUERY->F2_DOC)
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
				oDanfe:lViewPDF := .F.
				
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
				oDanfe:Print()
				DbSelectArea("QUERY")
				QUERY->(DbSkip())
				FreeObj(oDanfe)
				oDanfe := Nil
				cArquivo := NIL
			ENDDO
			DbSelectArea("QUERY")
			DbCloseArea("QUERY")
			MsgInfo("As Exportações de DANFES foram concluídos com sucesso!","SUCESSO!")
		ENDIF

RestArea(aArea)
Return
