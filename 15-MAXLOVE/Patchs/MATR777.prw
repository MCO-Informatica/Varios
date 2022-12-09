#Include 'Protheus.ch'
#Include 'Rwmake.ch'
#INCLUDE 'TOPCONN.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELNEGOCIaº Autor ³ MCINFOTECº Data ³  2017       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório dos titulos renegociados                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MATR777()

	Local oReport
	Local cPerg		:= Padr( "MTR777", LEN( SX1->X1_GRUPO ) )
	Local cAlias 	:= "SC9"

	Pergunte(cPerg,.f. )

	oReport := reportDef(cAlias, cPerg)
	oReport:printDialog()

return


//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

	local cTitle  := "Pick-List  (Expedicao)"
	local cHelp   := "Emissao de produtos a serem separados pela expedicao, para determinada faixa de pedidos."
	local oReport
	local oSection1

	oReport := TReport():New('MATR777',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	//Primeira seção
	oSection1 := TRSection():New(oReport,"Pick-List",{"TMPSC9","SC5"})

	TRCell():New(oSection1,"C9_PRODUTO"		, "TMPSC9", "Codigo"			,"@!"				,15		)
	TRCell():New(oSection1,"B1_DESC"		, "TMPSC9", "Desc.Material"	,"@!"				,100		)
	TRCell():New(oSection1,"B1_UM"			, "TMPSC9", "UM"				,"@!"				,02		)
	TRCell():New(oSection1,"NQTDE"			, "TMPSC9", "Quantidade"		,PesqPict('SC6','C6_QTDVEN'),10	)
	TRCell():New(oSection1,"C9_LOCAL"		, "TMPSC9", "Amz"				,"@!"				,02		)
	TRCell():New(oSection1,"C9_LOTECTL"		, "TMPSC9", "Lote"				,"@!"				,10		)
	TRCell():New(oSection1,"C9_DTVALID"		, "TMPSC9", "Dat.Validade"	,PesqPict("SC9","C9_DTVALID")	,10	)
	TRCell():New(oSection1,"C9_PEDIDO"		, "TMPSC9", "Pedido"			,"@!"				,06		)
	TRCell():New(oSection1,"A1_NOME"		, "TMPSC9", "Cliente"			,"@!"				,30		)
                                   
	oReport:SetTotalInLine(.F.)

	TRFunction():New(oSection1:Cell("NQTDE"),"QTD GERAL" ,"SUM",,,"@E 999,999,999.99",,.F.,.T.)  

	TRPosition():New(oSection1,"SC5",1,{|| xFilial("SC5")+TMPSC9->C9_PEDIDO})


Return(oReport)

        
//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)
              
	Local oSection1 	:= oReport:Section(1)
	Local cQuery			:= ""
	Local cRepTit		:= oReport:Title()
	Local cTitulo		:= oReport:Title() 

	Local lUsaLocal  	:= (SuperGetMV("MV_LOCALIZ") == "S")
	Local cAliasNew		:= "TMPSC9"
	Local aStruSC9 		:= SC9->(dbStruct())
	Local cEndereco 	:= ""
	Local nQtde     	:= 0

	cQuery := "SELECT SC9.R_E_C_N_O_ SC9REC,"
	cQuery += "SC9.C9_PEDIDO,SC9.C9_FILIAL,SC9.C9_QTDLIB,SC9.C9_PRODUTO, "
	cQuery += "SC9.C9_LOCAL,SC9.C9_LOTECTL,SC9.C9_POTENCI,"
	cQuery += "SC9.C9_NUMLOTE,SC9.C9_DTVALID,SC9.C9_NFISCAL"
	If cPaisLOC <> "BRA" 	
		cQuery += ",SC9.C9_REMITO " 
	EndIf	

	If lUsaLocal
		cQuery += ",SDC.DC_LOCALIZ,SDC.DC_QUANT,SDC.DC_QTDORIG"
	EndIf
	cQuery += " FROM "
	cQuery += RetSqlName("SC9") + " SC9 "
	If lUsaLocal
		cQuery += "LEFT JOIN "+RetSqlName("SDC") + " SDC "
		cQuery += "ON SDC.DC_PEDIDO=SC9.C9_PEDIDO AND SDC.DC_ITEM=SC9.C9_ITEM AND SDC.DC_SEQ=SC9.C9_SEQUEN AND SDC.D_E_L_E_T_ = ' '"
	EndIf
	cQuery += "WHERE SC9.C9_FILIAL  = '"+xFilial("SC9")+"'"
	cQuery += " AND  SC9.C9_PEDIDO >= '"+mv_par01+"'"
	cQuery += " AND  SC9.C9_PEDIDO <= '"+mv_par02+"'"
	If mv_par03 == 1 .Or. mv_par03 == 3
		cQuery += " AND SC9.C9_BLEST  = '  '"
	EndIf
	If mv_par03 == 2 .Or. mv_par03 == 3
		cQuery += " AND SC9.C9_BLCRED = '  '"
	EndIf
	If cPaisLOC <> "BRA"
		cQuery += " AND SC9.C9_REMITO = '" +Space(Len(SC9->C9_REMITO))+"' "
	EndIf	
	cQuery += " AND SC9.D_E_L_E_T_ = ' '"
	cQuery += "ORDER BY SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_CLIENTE,SC9.C9_LOJA,SC9.C9_PRODUTO,SC9.C9_LOTECTL,"
	cQuery += "SC9.C9_NUMLOTE,SC9.C9_DTVALID"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)

	For nX := 1 To Len(aStruSC9)
		If aStruSC9[nX][2] <> "C" .and.  FieldPos(aStruSC9[nX][1]) > 0
			TcSetField(cAliasNew,aStruSC9[nX][1],aStruSC9[nX][2],aStruSC9[nX][3],aStruSC9[nX][4])
		EndIf
	Next nX

	oReport:SetMeter((cAliasNew)->(LastRec()))

	oReport:SetTitle(cTitulo)

	(cAliasNew)->(dbGoTop())
	While (cAliasNew)->(!Eof())
	
		If oReport:Cancel()
			Exit
		EndIf
   
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
	
		IncProc("Imprimindo Pick List ")


		If lUsaLocal
			cEndereco := (cAliasNew)->DC_LOCALIZ
			nQtde     := Iif((cAliasNew)->DC_QUANT>0,(cAliasNew)->DC_QUANT,(cAliasNew)->C9_QTDLIB)
		Else
			cEndereco := ""
			nQtde     := (cAliasNew)->C9_QTDLIB
		EndIf

		SB1->(dbSeek(xFilial("SB1")+(cAliasNew)->C9_PRODUTO))
	
		oSection1:Cell("C9_PRODUTO"):SetValue((cAliasNew)->C9_PRODUTO)
		oSection1:Cell("B1_DESC"):SetValue(Subs(SB1->B1_DESC,1,100))
		oSection1:Cell("B1_UM"):SetValue(SB1->B1_UM)
		oSection1:Cell("NQTDE"):SetValue(nQtde)
		oSection1:Cell("C9_LOCAL"):SetValue((cAliasNew)->C9_LOCAL)
		oSection1:Cell("C9_LOTECTL"):SetValue((cAliasNew)->C9_LOTECTL)
		oSection1:Cell("C9_DTVALID"):SetValue((cAliasNew)->C9_DTVALID)
		oSection1:Cell("C9_PEDIDO"):SetValue((cAliasNew)->C9_PEDIDO)
		oSection1:Cell("A1_NOME"):SetValue(SUBS(SA1->A1_NOME,1,30))

		oSection1:Printline()

		DbSelectArea(cAliasNew)
		(cAliasNew)->(dbSkip())

	End

	oReport:ThinLine()

	//finalizo a primeira seção
	oSection1:Finish()
	
	IF Select(cAliasNew) <> 0
		DbSelectArea(cAliasNew)
		DbCloseArea()
	ENDIF

	
return

