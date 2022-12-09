#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAPAPC    º Autor ³ Totvs              º Data ³  17/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Detalhes POLICIA CIVIL                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MAPAPC                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function MAPAPC()
	Local cString		:= ""
	Local cPerg			:= "MAPAPC"
	Local cTitulo  		:= "MOVIMENTO GERAL (ANEXO I)"
	Local cDesc1  		:= "Relatorio de movimentacoes de Produtos Controlados"
	Private nLarpag 	:= 3400
	Private aDelArqs	:= {}
	Private aPrdCiv 	:= {}
	Private olReport

	Pergunte(cPerg,.T.)
	olReport := PERGRelat(cPerg)
	olReport:SetParam(cPerg)
	olReport:PrintDialog()

	M947DelArq(aDelArqs)

	MS_FLUSH()

Return Nil


Static Function PERGRelat( cPerg )

	Local clNomProg		:= FunName()
	Local clTitulo 		:= "RELATÓRIO DA POLICIA CIVIL"
	Local clDesc   		:= "RELATÓRIO DA POLICIA CIVIL"

	olReport := TReport():New(clNomProg,clTitulo,cPerg,{|olReport| ProcRel(olReport,lEnd,.T.,@aDelArqs)},clDesc)

	olReport:SetLandscape()				// Formato paisagem
	olReport:DisableOrientation()		// Formato paisagem
	olReport:oPage:nPaperSize	:=  9 	// Impressão em papel A4
	olReport:lHeaderVisible 	:= .F.	// Não imprime cabeçalho do protheus
	olReport:lFooterVisible 	:= .F.	// Não imprime rodapé do protheus
	olReport:lParamPage			:= .F.	// Não imprime pagina de parametros
	olReport:SetEdit(.F.)				// Não permite personilizar o relatório, desabilitando o botão <Personalizar>

Return olReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ProcRel   ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 13.01.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Processa o relatorio                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ProcRel(olReport,lEnd,lPrint,aDelArqs)

	Local lQuery	:= .F.
	Local cQuery	:= ""
	Local cAliasSD1	:= "SD1"
	Local cAliasSD2	:= "SD2"
	Local cAliasSD3	:= "SD3"
	Local cAliasSB1	:= "SB1"

	Local nX		:= 0
	Local aStru		:= {}
	Local cIndex	:= ""
	Local nIndex	:= 0
	Local cProduto	:= Alltrim(mv_par01)
	Local dDtIni	:= mv_par02
	Local dDtFim	:= mv_par03
	Local cEmp		:= ""
	Local cEnd		:= ""
	Local cMun		:= ""
	Local cUF		:= ""
	Local cBairro	:= ""
	Local cDDD		:= ""
	Local cNome		:= ""
	Local cTel		:= ""
	Local lGrava	:= .T.
	Local nEstqAnt	:= 0
	Local nProduz 	:= 0
	Local nUtiliza 	:= 0
	Local cTipo		:= ""
	Local cOrdem	:= ""
	Local aCampos	:= {}
	Local cCmpQry	:= ""
	Local cTransp	:= ""
	Local cNomTran  := ""
	Local cEndTran  := ""
	Local cCepTran  := ""
	Local cCidTran  := ""
	Local cUfTran   := ""
	Local cTelTran  := ""

	Private oTmpTable 
	Private lAglutina 	:= IIf(MV_PAR12 == 1,.T.,.F.)

	Default lPrint	:= .T.
	Default lEnd	:= .F.

	#IFDEF TOP
	If TcSrvType()<>"AS/400"
		lQuery := .T.
	Endif
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera arquivo temporarios                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If oTmpTable <> Nil
		oTmpTable:Delete()
		oTmpTable := Nil
	Endif

	aDelArqs := GeraTemp()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o estoque de todos os produtos controlados.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MAPAEST(1,dDtIni,dDtFim,cProduto)

	ANT->(dbGoTop())
	Do While !ANT->(Eof())
		If !Empty(cProduto)
			cQuery += "SB1.B1_XPRDCIV='"+cProduto+"' AND "
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ T01 - Sintetico                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("T01")
		dbSetOrder(1)
		If !dbSeek(ANT->CODIGO)
			CPRODCIV := Posicione("SB1",1,XFILIAL("SB1")+ANT->CODIGO,'B1_XPRDCIV')
			RecLock("T01",.T.)
			T01->CODPROD	:= ANT->CODIGO
			T01->DESCPROD	:= IIF(MV_PAR12 == 1,Alltrim(Posicione("SX5",1,XFILIAL("SX5")+'ZZ'+CPRODCIV,'X5_DESCRI')), ANT->DESC_PRD )
			T01->SLDANT		:= ANT->QUANT
			T01->XPRDCIV := CPRODCIV
		Else

			RecLock("T01",.F.)
			T01->SLDANT		+= ANT->QUANT
		Endif
		MsUnlock()
		ANT->(dbSkip())
	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa Entradas                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("SD1")
	dbSetOrder(1)

	dbSelectArea("SA2")
	dbSetOrder(1)
	If lQuery
		cAliasSD1	:= "TopSD1"
		aStru		:= SD1->(dbStruct())
		cQuery 		:= "SELECT SD1.D1_COD, SD1.D1_LOCAL, SD1.D1_QUANT, SD1.D1_DTDIGIT, SD1.D1_DOC, SD1.D1_SERIE, "
		cQuery 		+= "SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_TIPO, SB1.B1_XPRDCIV,SD1.D1_UM,SB1.B1_CONV,SB1.B1_TIPCONV, SB1.B1_UM "
		cQuery 		+= "FROM "+RetSqlName("SD1")+" SD1,"+RetSqlName("SB1")+" SB1,"+RetSqlName("SF4")+" SF4 "
		cQuery 		+= "WHERE D1_QUANT > 0 AND "
		cQuery 		+= "SD1.D1_DTDIGIT>='"+Dtos(dDtIni)+"' AND "
		cQuery 		+= "SD1.D1_DTDIGIT<='"+Dtos(dDtFim)+"' AND "
		cQuery 		+= "SD1.D1_CF NOT IN('000','999','0000','9999') AND "
		cQuery 		+= "SD1.D1_CF IN ( '1918','1102', '2102', '3102', '1202', '2202', '1917', '2917', '1910', '2910', '1401', '2402', '2202' ) AND "
		cQuery 		+= " D1_FILIAL='"+xFilial("SD1")+"' AND "
		cQuery 		+= "SD1.D_E_L_E_T_=' ' AND "
		cQuery 		+= "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
		cQuery 		+= "SB1.B1_COD=SD1.D1_COD AND "

		If Empty(cProduto)
			cQuery += "SB1.B1_XPRDCIV <> ' ' AND "
		Else
			cQuery += "SB1.B1_XPRDCIV ='"+cProduto+"' AND "
		Endif

		cQuery 		+= "SB1.D_E_L_E_T_ = ' ' AND "
		cQuery 		+= "F4_FILIAL='"+xFilial("SF4")+"' AND "
		cQuery 		+= "SF4.F4_CODIGO=SD1.D1_TES AND "
		cQuery 		+= "SF4.F4_ESTOQUE = 'S' AND "
		cQuery 		+= "SF4.D_E_L_E_T_=' ' "

		cQuery 		+= "ORDER BY "+SqlOrder(SD1->(IndexKey()))

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)


		For nX := 1 To len(aStru)
			If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1])<>0
				TcSetField(cAliasSD1,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
	Else
		cIndex	:= CriaTrab(NIL,.F.)
		cQuery 	:= "D1_FILIAL=='"+xFilial("SD1")+"' .AND. "
		cQuery 	+= "Dtos(D1_DTDIGIT)>='"+Dtos(dDtIni)+"' .AND. "
		cQuery 	+= "Dtos(D1_DTDIGIT)<='"+Dtos(dDtFim)+"' .AND. "

		If !Empty(cProduto)
			cQuery += "D1_COD=='"+cProduto+"' .AND. "
		Endif

		cQuery 	+= "!(D1_CF$'000/999/0000/9999') "

		IndRegua(cAliasSD1,cIndex,SD1->(IndexKey()),,cQuery)
		nIndex := RetIndex("SD1")
		dbSetIndex(cIndex+OrdBagExt())
		dbSelectArea("SD1")
		dbSetOrder(nIndex+1)
	EndIf

	SF4->(dbSetOrder(1))
	dbSelectArea(cAliasSD1)
	dbGoTop()
	While !Eof()
		cNomTran  := ""
		cEndTran  := ""
		cCepTran  := ""
		cCidTran  := ""
		cUfTran   := ""
		cTelTran  := ""
		cTransp	  := ""

		If Interrupcao(@lEnd)
			Return Nil
		Endif

		If !lQuery
			lGrava := (Posicione("SB1",1,xFilial("SB1")+(cAliasSD1)->D1_COD,SB1->B1_XPRDCIV) == ' ' )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona o TES do movimento³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SF4->(dbSetOrder(1))
			If !(SF4->(MsSeek(xFilial("SF4")+(cAliasSD1)->D1_TES)))
				(cAliasSD1)->(DbSkip())
				Loop
			Endif
			If SF4->F4_ESTOQUE <> "S"
				(cAliasSD1)->(DbSkip())
				Loop
			Endif
		Endif

		If lGrava
			If (cAliasSD1)->D1_TIPO$"D/B"
				dbSelectArea("SA1")
				dbSetOrder(1)
				If dbSeek(xFilial("SA1")+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)
					cEmp	:= SA1->A1_NOME
					cEnd	:= Alltrim(SA1->A1_END)+Alltrim(SA1->A1_BAIRRO)
					cMun	:= SA1->A1_MUN
					cUF		:= SA1->A1_EST
					cCEP    := SA1->A1_CEP
					cFone   := SA1->A1_TEL
				Endif
			Else
				dbSelectArea("SA2")
				dbSetOrder(1)
				If dbSeek(xFilial("SA2")+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)
					cEmp	:= SA2->A2_NOME
					cEnd	:= Alltrim(SA2->A2_END)+Alltrim(SA2->A2_BAIRRO)
					cMun	:= SA2->A2_MUN
					cUF		:= SA2->A2_EST
					cCEP    := SA2->A2_CEP
					cFone   := SA2->A2_TEL
					cBairro := SA2->A2_BAIRRO
					cDDD	:= SA2->A2_DDD
					cTel	:= SA2->A2_TEL
					cNome	:= SA2->A2_NREDUZ
				Endif
			Endif

			dbSelectArea("SF1")
			dbSetOrder(1)
			If dbSeek(xFilial("SF1")+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)
				cTransp	:= &(GetNewPar("MV_TRANSF1",""))
			EndIf

			If !Empty(cTransp) .and. (cTransp <> '000988') // Junior - 28/03/2016 - Não aparecer Proprio
				dbSelectArea("SA4")
				dbSetOrder(1)
				If dbSeek(xFilial("SA4") + cTransp)
					cNomTran  := SA4->A4_NOME
					cEndTran  := Alltrim(SA4->A4_END)+Alltrim(SA4->A4_BAIRRO)
					cCepTran  := SA4->A4_CEP
					cCidTran  := SA4->A4_MUN
					cUfTran   := SA4->A4_EST
					cTelTran  := SA4->A4_TEL
				EndIf
			Else
				dbSelectArea("SA2")
				dbSetOrder(1)
				If dbSeek(xFilial("SA2")+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)
					cNomTran  := SA2->A2_NOME
					cEndTran  := Alltrim(SA2->A2_END)+Alltrim(SA2->A2_BAIRRO)
					cCepTran  := SA2->A2_CEP
					cCidTran  := SA2->A2_MUN
					cUfTran   := SA2->A2_EST
					cTelTran  := SA2->A2_TEL
				Endif
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ T01 - Sintetico                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("T01")
			dbSetOrder(1)
			If !dbSeek((cAliasSD1)->D1_COD)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica o saldo anterior dos produtos de acordo com as movimentacoes de estoque.         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nEstqAnt := 0
				If ANT->(dbSeek((cAliasSD1)->D1_COD))
					nEstqAnt := ANT->QUANT
				Endif

				RecLock("T01",.T.)
				T01->CODPROD	:= (cAliasSD1)->D1_COD
				T01->DESCPROD	:= IIF(MV_PAR12 == 1,Alltrim(Posicione("SX5",1,XFILIAL("SX5")+'ZZ'+(cAliasSD1)->B1_XPRDCIV,'X5_DESCRI')), Posicione("SB1",1,xFilial("SB1")+(cAliasSD1)->D1_COD,"B1_DESC"))
				T01->SLDANT		:= ANT->QUANT //nEstqAnt
				T01->UM         := Posicione("SB1",1,xFilial("SB1")+(cAliasSD1)->D1_COD,"B1_UM")
			Else
				RecLock("T01",.F.)
			Endif
			IF (cAliasSD1)->B1_CONV > 0 .AND. ALLTRIM((cAliasSD1)->D1_UM) = 'L' .AND. ((cAliasSD1)->D1_UM  <> (cAliasSD1)->B1_UM)
				IF (cAliasSD1)->B1_TIPCONV = 'M'
					T01->COMPRAS	+= (cAliasSD1)->D1_QUANT * (cAliasSD1)->B1_CONV
				ELSEIF (cAliasSD1)->B1_TIPCONV = 'D'
					T01->COMPRAS += (cAliasSD1)->D1_QUANT / (cAliasSD1)->B1_CONV
				ELSE
					T01->COMPRAS	+= (cAliasSD1)->D1_QUANT
				ENDIF
			ELSE
				T01->COMPRAS	+= (cAliasSD1)->D1_QUANT
			ENDIF
			T01->UM  := 'KG'
			MsUnlock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ T02 - Analitico  COMPRAS         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("T02")
			dbSetOrder(1)
			If (cAliasSD1)->D1_TIPO <> "C"
				If !dbSeek((cAliasSD1)->D1_COD+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)
					RecLock("T02",.T.)
					T02->CODPROD	:= (cAliasSD1)->D1_COD
					T02->EMISSAO	:= (cAliasSD1)->D1_DTDIGIT
					T02->EMPRESA	:= cEmp
					T02->ENDE		:= cEnd
					T02->MUN		:= cMun
					T02->UF			:= cUF
					T02->NF			:= (cAliasSD1)->D1_DOC
					T02->SERIE		:= (cAliasSD1)->D1_SERIE
					T02->CLIEFOR	:= (cAliasSD1)->D1_FORNECE
					T02->LOJA		:= (cAliasSD1)->D1_LOJA
					T02->CEP		:= cCEP
					T02->FONE		:= STRTRAN(STRTRAN(cFone,"-","")," ","")
					T02->NTRANSP    := cNomTran
					T02->ENDTRAN    := cEndTran
					T02->CEPTRAN    := cCepTran
					T02->MUNTRAN    := cCidTran
					T02->ESTTRAN    := cUfTran
					T02->TELTRAN	:= STRTRAN(STRTRAN(cTelTran,"-","")," ","")
				Else
					RecLock("T02",.F.)
				Endif
				IF (cAliasSD1)->B1_CONV > 0 .AND. aLLTRIM((cAliasSD1)->D1_UM) = 'L'  .AND. ((cAliasSD1)->D1_UM <> (cAliasSD1)->B1_UM)
					IF (cAliasSD1)->B1_TIPCONV = 'M'
						T02->QUANT	+= (cAliasSD1)->D1_QUANT * (cAliasSD1)->B1_CONV
					ELSEIF (cAliasSD1)->B1_TIPCONV = 'D'
						T02->QUANT	+= (cAliasSD1)->D1_QUANT / (cAliasSD1)->B1_CONV
					ELSE
						T02->QUANT	+= (cAliasSD1)->D1_QUANT
					ENDIF
				ELSE
					T02->QUANT	+= (cAliasSD1)->D1_QUANT
				ENDIF
				T02->UM  := 'KG'
				MsUnlock()
			EndIf

			dbSelectArea("T05")
			dbSetOrder(1)
			If !dbSeek((cAliasSD1)->D1_COD+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)
				RecLock("T05",.T.)
				T05->CODPROD	:= (cAliasSD1)->D1_COD
				T05->DESCPROD	:= Posicione("SB1",1,xFilial("SB1")+(cAliasSD1)->D1_COD,"B1_DESC")
				T05->SLDANT		:= nEstqAnt
				T05->UM		    := Posicione("SB1",1,xFilial("SB1")+(cAliasSD1)->D1_COD,"B1_UM")
				T05->BAIRRO		:= cBairro
				T05->CEP		:= cCEP
				T05->NREDUZ		:= cNome
				T05->ENDE		:= cEnd
				T05->MUN		:= cMun
				T05->UF			:= cUF
			Else
				RecLock("T02",.F.)
			Endif
			MsUnlock()
		Endif

		dbSelectArea(cAliasSD1)
		dbSkip()
	Enddo

	If lQuery
		dbSelectArea(cAliasSD1)
		dbCloseArea()
	Else
		dbSelectArea("SD1")
		RetIndex("SD1")
		dbClearFilter()
		Ferase(cIndex+OrdBagExt())
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa Saidas                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD2")
	dbSetOrder(1)
	If lQuery
		cAliasSD2	:= "TopSD2"
		aStru		:= SD2->(dbStruct())
		cQuery 		:= "SELECT SD2.D2_COD, SD2.D2_LOCAL, SD2.D2_QUANT, SD2.D2_EMISSAO, SD2.D2_DOC, SD2.D2_SERIE, "
		cQuery 		+= "SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_TIPO, SB1.B1_XPRDCIV,SD2.D2_UM,SB1.B1_CONV,SB1.B1_TIPCONV, B1_UM "
		cQuery 		+= "FROM "+RetSqlName("SD2")+" SD2,"+RetSqlName("SB1")+" SB1,"+RetSqlName("SF4")+" SF4 "
		cQuery 		+= "WHERE "
		cQuery 		+= "D2_QUANT > 0  AND "
		cQuery 		+= "SD2.D2_EMISSAO BETWEEN '"+Dtos(dDtIni)+"' AND '"+Dtos(dDtFim)+"' AND "
		cQuery 		+= "SD2.D2_CF IN ( '5102', '6102', '5123', '6123', '5949','6949',"
		cQuery 		+= "'5917', '6917', '5910', '6910', '5401', '6402', '6202', '6106' ) AND "
		cQuery 		+= "D2_FILIAL='"+xFilial("SD2")+"' AND "
		cQuery 		+= "SD2.D_E_L_E_T_ = ' ' AND "
		If Empty(cProduto)
			cQuery += "SB1.B1_XPRDCIV <> ' ' AND "
		Else
			cQuery += "SB1.B1_XPRDCIV = '"+cProduto+"' AND "
		Endif
		cQuery 		+= "SB1.B1_COD=SD2.D2_COD AND "
		cQuery 		+= "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
		cQuery 		+= "SB1.D_E_L_E_T_ = ' ' AND "
		cQuery 		+= "F4_FILIAL='"+xFilial("SF4")+"' AND "
		cQuery 		+= "SF4.F4_CODIGO=SD2.D2_TES AND "
		cQuery 		+= "( SF4.F4_ESTOQUE = 'S'  OR  ( SF4.F4_CODIGO = '770' AND SF4.F4_ESTOQUE = 'N')) AND "
		cQuery 		+= "SF4.D_E_L_E_T_=' ' "
		cQuery 		+= "ORDER BY "+SqlOrder(SD2->(IndexKey()))

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)

		For nX := 1 To len(aStru)
			If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1])<>0
				TcSetField(cAliasSD2,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
	Else
		cIndex	:= CriaTrab(NIL,.F.)
		cQuery 	:= "D2_FILIAL=='"+xFilial("SD2")+"' .AND. "
		cQuery 	+= "Dtos(D2_EMISSAO)>='"+Dtos(dDtIni)+"' .AND. "
		cQuery 	+= "Dtos(D2_EMISSAO)<='"+Dtos(dDtFim)+"' .AND. "

		If !Empty(cProduto)
			cQuery += "D2_COD=='"+cProduto+"' .AND. "
		Endif

		cQuery 	+= "!(D2_CF$'000/999/0000/9999') "

		IndRegua(cAliasSD2,cIndex,SD2->(IndexKey()),,cQuery)
		nIndex := RetIndex("SD2")
		dbSetIndex(cIndex+OrdBagExt())
		dbSelectArea("SD2")
		dbSetOrder(nIndex+1)
	EndIf

	dbSelectArea(cAliasSD2)
	dbGoTop()
	While !Eof()
		If Interrupcao(@lEnd)
			Return Nil
		Endif

		If !lQuery
			lGrava := (Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,SB1->B1_XPRDCIV) <> ' ')
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona o TES do movimento³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SF4->(dbSetOrder(1))
			If !(SF4->(MsSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)))
				(cAliasSD2)->(DbSkip())
				Loop
			Endif
			If SF4->F4_ESTOQUE <> "S"
				(cAliasSD2)->(DbSkip())
				Loop
			Endif
		Endif

		If lGrava
			If (cAliasSD2)->D2_TIPO$"D/B"
				dbSelectArea("SA2")
				dbSetOrder(1)
				If dbSeek(xFilial("SA2")+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
					cEmp	:= SA2->A2_NOME
					cEnd	:= SA2->A2_END
					cMun	:= SA2->A2_MUN
					cUF		:= SA2->A2_EST
				Endif
			Else
				dbSelectArea("SA1")
				dbSetOrder(1)
				If dbSeek(xFilial("SA1")+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
					cEmp	:= SA1->A1_NOME
					cEnd	:= SA1->A1_END
					cMun	:= SA1->A1_MUN
					cUF		:= SA1->A1_EST
					cBairro := SA1->A1_BAIRRO
					cCEP	:= SA1->A1_CEP
					cDDD	:= SA1->A1_DDD
					cTel	:= STRTRAN(STRTRAN(SA1->A1_TEL,"-","")," ","")
					cNome	:= SA1->A1_NREDUZ
				Endif
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ T01 - Sintetico                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("T01")
			dbSetOrder(1)
			If !dbSeek((cAliasSD2)->D2_COD)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica o saldo anterior dos produtos de acordo com as movimentacoes de estoque.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nEstqAnt := 0
				If ANT->(dbSeek((cAliasSD2)->D2_COD))
					nEstqAnt := ANT->QUANT
				Endif

				RecLock("T01",.T.)
				T01->CODPROD	:= (cAliasSD2)->D2_COD
				T01->DESCPROD	:= IIF(MV_PAR12 == 1,Alltrim(Posicione("SX5",1,XFILIAL("SX5")+'ZZ'+(cAliasSD2)->B1_XPRDCIV,'X5_DESCRI')),Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,"B1_DESC"))

				T01->SLDANT		:= nEstqAnt
			Else
				RecLock("T01",.F.)
			Endif
			IF (cAliasSD2)->B1_CONV > 0 .AND. aLLTRIM((cAliasSD2)->D2_UM) = 'L'  .AND. (cAliasSD2)->B1_XPRDCIV == '000038'
				IF (cAliasSD2)->B1_TIPCONV = 'M'
					T01->VENDAS	+= (cAliasSD2)->D2_QUANT * (cAliasSD2)->B1_CONV
				ELSEIF (cAliasSD2)->B1_TIPCONV = 'D'
					T01->VENDAS	+= (cAliasSD2)->D2_QUANT / (cAliasSD2)->B1_CONV
				ELSE
					T01->VENDAS	+= (cAliasSD2)->D2_QUANT
				ENDIF
			ELSE
				T01->VENDAS	+= (cAliasSD2)->D2_QUANT
				T01->UM := Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,"B1_UM")
			ENDIF
			T01->UM  := 'KG'
			MsUnlock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ T03 - Analitico  VENDAS          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("T03")
			dbSetOrder(1)
			dbSeek((cAliasSD2)->D2_COD+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
			RecLock("T03",.T.)

			IF (cAliasSD2)->B1_CONV > 0 .AND. aLLTRIM((cAliasSD2)->D2_UM) = 'L'  .AND. ( (cAliasSD2)->D2_UM <> (cAliasSD2)->B1_UM)
				IF (cAliasSD2)->B1_TIPCONV = 'M'
					T03->QUANT	:= (cAliasSD2)->D2_QUANT * (cAliasSD2)->B1_CONV
				ELSEIF (cAliasSD2)->B1_TIPCONV = 'D'
					T03->QUANT := (cAliasSD2)->D2_QUANT / (cAliasSD2)->B1_CONV
				ELSE
					T03->QUANT	:= (cAliasSD2)->D2_QUANT
				ENDIF
			ELSE
				T03->QUANT	:= (cAliasSD2)->D2_QUANT
				//T03->UM  :=  Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,"B1_UM")
			ENDIF
			T03->UM  := 'KG'

			T03->CODPROD	:= (cAliasSD2)->D2_COD
			T03->DOC		:= (cAliasSD2)->D2_DOC
			T03->DESCPROD	:= Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,"B1_DESC")
			T03->EMISSAO	:= (cAliasSD2)->D2_EMISSAO
			T03->EMPRESA	:= cEmp
			T03->ENDE		:= cEnd
			T03->MUN		:= cMun
			T03->UF			:= cUF
			T03->NF			:= (cAliasSD2)->D2_DOC
			T03->SERIE		:= (cAliasSD2)->D2_SERIE
			T03->CLIEFOR	:= (cAliasSD2)->D2_CLIENTE
			T03->LOJA		:= (cAliasSD2)->D2_LOJA
			T03->BAIRRO		:= cBairro
			T03->CEP		:= cCEP
			T03->TEL		:= STRTRAN(STRTRAN(cTel,"-","")," ","")
			T03->DDD		:= cDDD
			T03->NREDUZ		:= cNome

			MsUnlock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ T04 - Analitico  VENDAS          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("T04")
			dbSetOrder(1)
			If !dbSeek((cAliasSD2)->D2_COD+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
				RecLock("T04",.T.)
				T04->CODPROD	:= (cAliasSD2)->D2_COD
				T04->DESCPROD	:= Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,"B1_DESC")
				T04->SLDANT		:= nEstqAnt
				T04->UM		    := Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,"B1_UM")
				T04->BAIRRO		:= cBairro
				T04->CEP		:= cCEP
				T04->NREDUZ		:= cNome
				T04->ENDE		:= cEnd
				T04->MUN		:= cMun
				T04->UF			:= cUF
			Else
				RecLock("T04",.F.)
			Endif
			MsUnlock()
		Endif
		dbSelectArea(cAliasSD2)
		dbSkip()
	Enddo

	If lQuery
		dbSelectArea(cAliasSD2)
		dbCloseArea()
	Else
		dbSelectArea("SD2")
		RetIndex("SD2")
		dbClearFilter()
		Ferase(cIndex+OrdBagExt())
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa os movimentos de Producao.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If TcSrvType()<>"AS/400"

		lQuery 		:= .T.
		aStruSD3	:= {}
		cAliasSD3	:= GetNextAlias()
		cAliasSB1	:= cAliasSD3
		cCmpQry		:= ""

		aAdd(aCampos,{"SD3","D3_FILIAL"})
		aAdd(aCampos,{"SD3","D3_EMISSAO"})
		aAdd(aCampos,{"SD3","D3_COD"})
		aAdd(aCampos,{"SD3","D3_QUANT"})
		aAdd(aCampos,{"SD3","D3_CF"})
		aAdd(aCampos,{"SD3","D3_UM"})
		aAdd(aCampos,{"SB1","B1_UM"})
		aAdd(aCampos,{"SB1","B1_DESC"})
		aAdd(aCampos,{"SB1","B1_XPRDCIV"})
		aAdd(aCampos,{"SB1","B1_CONV"})
		aAdd(aCampos,{"SB1","B1_TIPCONV"})


		aStruSD3  := Mtr947Str(aCampos,@cCmpQry)

		cQuery    := "SELECT "
		cQuery    += cCmpQry
		cQuery    += "FROM " + RetSqlName("SD3") + " SD3, "
		cQuery    += RetSqlName("SB1") + " SB1 "
		cQuery    += "WHERE SD3.D3_FILIAL = '" + xFilial("SD3") + "' AND "
		cQuery    += "SD3.D3_EMISSAO >= '" + dtOs(dDtIni) + "' AND "
		cQuery    += "SD3.D3_EMISSAO <= '" + dtOs(dDtFim) + "' AND "

		//		If !Empty(cProduto)
		//			cQuery    += "SD3.D3_COD = '" + cProduto + "' AND "
		//		Endif

		If !Empty(cProduto)
			cQuery    += "SB1.B1_XPRDCIV = '" + cProduto + "' AND "
		Endif



		cQuery    += "SD3.D3_ESTORNO <> 'S' AND "
		cQuery    += "SD3.D3_CF IN('PR0','PR1','ER0','ER1','DE0','DE1','DE2','DE3','DE5','RE0','RE1','RE2','RE3','RE5') AND "
		cQuery    += "SD3.D_E_L_E_T_ = '' AND "
		cQuery    += "SD3.D3_COD = SB1.B1_COD AND "
		cQuery    += "SB1.B1_XPRDCIV <> ' ' AND "
		cQuery    += "SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
		cQuery    += "SB1.D_E_L_E_T_ = '' "

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD3,.T.,.T.)

		For nX := 1 To len(aStruSD3)
			If aStruSD3[nX][2] <> "C"
				TcSetField(cAliasSD3,aStruSD3[nX][1],aStruSD3[nX][2],aStruSD3[nX][3],aStruSD3[nX][4])
			EndIf
		Next nX

		dbSelectArea(cAliasSD3)

	Endif


	Do While !((cAliasSD3)->(Eof()))

		If Interrupcao(@lEnd)
			Return Nil
		Endif

		If !lQuery

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Checa o grupo do produto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SB1->(dbSetOrder(1))
			If !(SB1->(MsSeek(xFilial("SB1")+(cAliasSD3)->D3_COD)))
				(cAliasSD3)->(DbSkip())
				Loop
			Endif
			// Indicacao de produto controlado ou nao
			If SB1->B1_XPRDCIV <> ' '
				(cAliasSD3)->(DbSkip())
				Loop
			Endif

		Endif

		nProduz 	:= 0
		nUtiliza 	:= 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Producao Manual e Automatica  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSD3)->D3_CF == "PR0" .Or. (cAliasSD3)->D3_CF == "PR1"
			nProduz	:= (cAliasSD3)->D3_QUANT
			cTipo 	:= "P" // Producao
			cOrdem	:= "2"
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Estorno de producao Manual e Automatico³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSD3)->D3_CF == "ER0" .Or. (cAliasSD3)->D3_CF == "ER1"
			nProduz := (cAliasSD3)->D3_QUANT
			cTipo 	:= "EP" // Estorno de Producao
			cOrdem	:= "8"
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Requisicao Manual e Automatica³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSD3)->D3_CF $ "RE0/RE1/RE2/RE3/RE5"
			nUtiliza 	:= (cAliasSD3)->D3_QUANT
			cTipo 		:= "U" // Utilizacao
			cOrdem		:= "6"
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Devolucao Manual e Automatica ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSD3)->D3_CF $ "DE0/DE1/DE2/DE3/DE5"
			nUtiliza 	:= (cAliasSD3)->D3_QUANT
			cTipo 		:= "EU" // Estorno de Utilizacao
			cOrdem		:= "4"
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ T01 - Sintetico                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		dbSelectArea("T01")
		dbSetOrder(1)
		If !dbSeek((cAliasSD3)->D3_COD)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica o saldo anterior dos produtos de acordo com as movimentacoes de estoque.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nEstqAnt := 0
			If ANT->(dbSeek((cAliasSD3)->D3_COD))
				nEstqAnt := ANT->QUANT
			Endif

			RecLock("T01",.T.)
			T01->CODPROD	:= (cAliasSD3)->D3_COD
			T01->DESCPROD	:= IIF(MV_PAR12 == 1,Alltrim(Posicione("SX5",1,XFILIAL("SX5")+'ZZ'+(cAliasSD3)->B1_XPRDCIV,'X5_DESCRI')),(cAliasSB1)->B1_DESC )
			T01->SLDANT		:= nEstqAnt
		Else
			RecLock("T01",.F.)
		Endif

		IF cTipo == "U" .OR. cTipo 	== "P"
			IF (cAliasSD3)->B1_CONV > 0 .AND. aLLTRIM((cAliasSD3)->D3_UM) = 'L'
				IF (cAliasSD3)->B1_TIPCONV = 'M'
					T01->CONSUMO	-= nProduz * (cAliasSD3)->B1_CONV
					T01->CONSUMO	+= nUtiliza * (cAliasSD3)->B1_CONV
				ELSEIF (cAliasSD3)->B1_TIPCONV = 'D'
					T01->CONSUMO	-= nProduz / (cAliasSD3)->B1_CONV
					T01->CONSUMO	+= nUtiliza / (cAliasSD3)->B1_CONV
				ELSE
					T01->CONSUMO	-= nProduz
					T01->CONSUMO	+= nUtiliza
					T01->UM		    := Posicione("SB1",1,xFilial("SB1")+(cAliasSD3)->D3_COD,"B1_UM")
				ENDIF
			ELSE
				T01->CONSUMO	-= nProduz
				T01->CONSUMO	+= nUtiliza
				T01->UM		    := Posicione("SB1",1,xFilial("SB1")+(cAliasSD3)->D3_COD,"B1_UM")
			ENDIF
		ELSE

			IF (cAliasSD3)->B1_CONV > 0 .AND. aLLTRIM((cAliasSD3)->D3_UM) = 'L'
				IF (cAliasSD3)->B1_TIPCONV = 'M'
					T01->COMPRAS	+= nProduz * (cAliasSD3)->B1_CONV
					T01->COMPRAS	+= nUtiliza * (cAliasSD3)->B1_CONV
				ELSEIF (cAliasSD3)->B1_TIPCONV = 'D'
					T01->COMPRAS	+= nProduz / (cAliasSD3)->B1_CONV
					T01->COMPRAS	+= nUtiliza / (cAliasSD3)->B1_CONV
				ELSE
					T01->COMPRAS	+= nProduz
					T01->COMPRAS	+= nUtiliza
				ENDIF
				T01->UM  := 'KG'

			ELSE
				T01->COMPRAS	+= nProduz
				T01->COMPRAS	+= nUtiliza
				T01->UM		    := Posicione("SB1",1,xFilial("SB1")+(cAliasSD3)->D3_COD,"B1_UM")
			ENDIF
			MsUnlock()
		ENDIF

		// ALTERAR SE FOR PRECISO -  CRIAR UMA TABELA PARA OS DADOS NECESSARIOS DO NOVO RELATORIO
		/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ T02 - Analitico                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("T02")
		dbSetOrder(3)
		If !dbSeek((cAliasSD3)->D3_COD+dTos((cAliasSD3)->D3_EMISSAO)+cTipo)
		RecLock("T02",.T.)
		T02->CODPROD	:= (cAliasSD3)->D3_COD
		T02->EMISSAO	:= (cAliasSD3)->D3_EMISSAO
		T02->EMPRESA	:= SM0->M0_NOMECOM
		T02->ENDE		:= SM0->M0_ENDENT
		T02->MUN		:= SM0->M0_CIDENT
		T02->UF			:= SM0->M0_ESTENT
		T02->NF			:= "-"
		T02->UM		    := (cAliasSB1)->B1_UM
		Else
		RecLock("T02",.F.)
		Endif
		T02->QUANT += (cAliasSD3)->D3_QUANT
		MsUnlock()
		*/

		(cAliasSD3)->(dbSkip())
	EndDo

	If !lQuery
		RetIndex("SD3")
		dbClearFilter()
		Ferase(cArqInd+OrdBagExt())
	Else
		dbSelectArea(cAliasSD3)
		dbCloseArea()
	Endif
	//QUEBRA

	cAliasSD12	:= "TopSD12"
	cQuery 		:= " SELECT D1_COD, D1_QUANT, B1_XPRDCIV "
	cQuery 		+= " FROM "+RetSqlName("SF1")+" SF1,"+RetSqlName("SD1")+" SD1,"+RetSqlName("SB1")+" SB1 "
	cQuery 		+= " WHERE B1_COD = D1_COD AND SB1.D_E_L_E_T_ <> '*' "
	cQuery 		+= " AND D1_TES = '100' "
	cQuery 		+= " AND D1_SERIE = F1_SERIE "
	cQuery 		+= " AND D1_LOJA = F1_LOJA "
	cQuery 		+= " AND D1_FORNECE = F1_FORNECE "
	cQuery 		+= " AND D1_DOC = F1_DOC "
	cQuery 		+= " AND D1_FILIAL = '"+xFilial("SD1")+"'  AND SD1.D_E_L_E_T_ <> '*' "
	cQuery 		+= " AND F1_SERIE = 'RET' "
	cQuery 		+= " AND F1_ESPECIE = 'REC' "
	cQuery 		+= " AND F1_EMISSAO BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFim)+" ' "
	cQuery 		+= " AND F1_FILIAL = '"+xFilial("SF1")+"' AND SF1.D_E_L_E_T_ <> '*' "
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD12,.T.,.T.)

	dbSelectArea(cAliasSD12)
	dbGoTop()
	While !Eof()

		If Interrupcao(@lEnd)
			Return Nil
		Endif

		dbSelectArea("T01")
		dbSetOrder(1)
		If dbSeek((cAliasSD12)->D1_COD)
			RecLock("T01",.F.)
			T01->VENDAS	+= (cAliasSD12)->D1_QUANT
			MsUnlock()
		Endif

		dbSelectArea(cAliasSD12)
		DBSKIP()
		LOOP
	EndDo

	dbSelectArea(cAliasSD12)
	dbCloseArea()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica os produtos em estoque, mas sem movimentacao no periodo.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ATU->(dbGoTop())
	Do While !ATU->(Eof())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ T01 - Sintetico                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("T01")
		dbSetOrder(1)
		If !dbSeek(ATU->CODIGO)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Procura o saldo anterior³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nEstqAnt := 0
			If ANT->(dbSeek(ATU->CODIGO))
				nEstqAnt := ANT->QUANT
			Endif
			CPRODCIV := Posicione("SB1",1,XFILIAL("SB1")+ATU->CODIGO,'B1_XPRDCIV')
			RecLock("T01",.T.)
			T01->CODPROD	:= ATU->CODIGO
			T01->DESCPROD	:= IIF(MV_PAR12 == 1,Alltrim(Posicione("SX5",1,XFILIAL("SX5")+'ZZ'+CPRODCIV,'X5_DESCRI')), ATU->DESC_PRD )
			T01->SLDANT		:= nEstqAnt
			MsUnlock()
		Endif
		ATU->(dbSkip())
	Enddo

	if MV_PAR11 = 1 //olReport:NDEVICE == 4

		RELPCEXCEL(olReport)

		lPrint := .F.

	endif
	If lPrint
		PrintRel(olReport)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exclui os arquivo de estoque inicial/final.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MAPAEST(2,dDtIni,dDtFim,cProduto)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PrintRel  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 13.01.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Imprime o relatorio                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PrintRel(olReport)

	Local cTrimestre := mv_par04
	Local cVistoria  := mv_par05
	Local cAlvara    := mv_par06
	Local cValidade	 := mv_par07
	Local dDtIni   	 := mv_par02
	Local dDtFim	 := mv_par03
	Local lMov 		 := .F.
	Local nX := 0

	Private cNome  	:= Alltrim(mv_par08)
	Private cCargo 	:= Alltrim(mv_par09)
	Private cRg    	:= Alltrim(mv_par10)
	Private cCompl 	:= (cNome+" - "+cCargo+" - "+cRg)
	Private nPos 	:= 20
	Private oFont7b := TFont():New( "Courier New",, 07,,.T. )
	Private oFont8	:= TFont():New( "Courier New",, 08 )
	Private oFont10	:= TFont():New( "Courier New",, 10 )

	Private aPosCab01  := {120,1200,1500,1800,2100,2500,2900,3300}
	Private aPosCab02  := {120,280,440,620,780,1480,2440}
	Private aPosCab03  := {120,320,2120,2300,3020,3220}
	//Private aPosCab03  := {120,320,620,1220,1520,1820,1920,2120,2320,2820,3020}

	if lAglutina

		dbSelectArea("T01")
		dbSetOrder(1)
		dbGoTop()

		While !Eof()

			dbSelectArea("T01AG")
			dbSetOrder(1)
			cCodPrdCiv := Posicione("SB1",1,xFilial("SB1")+T01->CODPROD,"B1_XPRDCIV")
			If !MsSeek(cCodPrdCiv)

				RecLock("T01AG",.T.)

				T01AG->CODPROD	:=	T01->CODPROD
				T01AG->XPRDCIV	:=	cCodPrdCiv
				T01AG->DESCPROD	:=	T01->DESCPROD
				T01AG->UM	 	:=	T01->UM
				T01AG->ENDE	 	:=	T01->ENDE
				T01AG->BAIRRO	:=	T01->BAIRRO
				T01AG->CEP	 	:=	T01->CEP
				T01AG->MUN	 	:=	T01->MUN
				T01AG->UF	 	:=	T01->UF
				T01AG->NREDUZ	:=	T01->NREDUZ
			Else
				RecLock("T01AG",.F.)
			Endif
			T01AG->SLDANT	 +=	T01->SLDANT
			T01AG->COMPRAS	 +=	T01->COMPRAS
			T01AG->CONSUMO	 +=	T01->CONSUMO
			T01AG->VENDAS	 +=	T01->VENDAS

			MsUnlock()

			dbSelectArea("T01")
			RecLock("T01")
			DbDelete()
			MsUnlock()
			dbSkip()
			Loop
		Enddo
		dbSelectArea("T01")
		Do While !Eof()
			RecLock("T01")
			DbDelete()
			MsUnlock()
			DbSkip()
		Enddo

		aPrdCiv := {}

		dbSelectArea("T01AG")

		DBGOTOP()
		While T01AG->(!Eof())
			RecLock("T01",.T.)
			T01->CODPROD	:= T01AG->CODPROD
			T01->XPRDCIV	:= T01AG->XPRDCIV
			T01->DESCPROD	:= T01AG->DESCPROD
			T01->SLDANT	 	:= T01AG->SLDANT
			T01->COMPRAS	:= T01AG->COMPRAS
			T01->CONSUMO	:= T01AG->CONSUMO
			T01->VENDAS	 	:= T01AG->VENDAS
			T01->UM	 		:= T01AG->UM
			T01->ENDE	 	:= T01AG->ENDE
			T01->BAIRRO	 	:= T01AG->BAIRRO
			T01->CEP	 	:= T01AG->CEP
			T01->MUN	 	:= T01AG->MUN
			T01->UF	 		:= T01AG->UF
			T01->NREDUZ	 	:= T01AG->NREDUZ
			MSUNLOCK()

			if AScan( aPrdCiv , T01AG->XPRDCIV) == 0
				aAdd(aPrdCiv, T01AG->XPRDCIV)
			Endif

			dbSelectArea("T01AG")
			dbSkip()
			LOOP
		ENDDO
	ENDIF

	cChave := ''
	For nX := 1 to Len(aPrdCiv)
		cChave += aPrdCiv[nX]+"/"
	Next Nx
	cChave := SUBSTR(cChave,1, lEN(cChave)-1)

	cAliasSX5	:= GetNextAlias()
	cQuery := " SELECT SX5.X5_CHAVE AS CHAVE, SX5.X5_DESCRI AS DESCRI,  SX5.* FROM "+RetSqlName("SX5")+ "  SX5 " 
	cQuery += " WHERE X5_FILIAL = '" + xFilial("SX5") + "' AND SX5.X5_TABELA = 'ZZ' AND SX5.X5_CHAVE NOT IN "+FormatIn(cChave,"/")
	cQuery += " AND SX5.D_E_L_E_T_ <> '*' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSX5,.T.,.T.)
	DbGoTop()
	While !((cAliasSX5)->(Eof()))

		RecLock("T01",.T.)
		T01->CODPROD	:= (cAliasSX5)->CHAVE
		T01->XPRDCIV	:= (cAliasSX5)->CHAVE
		T01->DESCPROD	:= Substr((cAliasSX5)->DESCRI,1,78)
		T01->SLDANT	 	:= 0
		T01->COMPRAS	:= 0
		T01->CONSUMO	:= 0
		T01->VENDAS	 	:= 0
		T01->UM	 		:= "KG"
		T01->ENDE	 	:= ""
		T01->BAIRRO	 	:= ""
		T01->CEP	 	:= ""
		T01->MUN	 	:= ""
		T01->UF	 		:= ""
		T01->NREDUZ	 	:= ""
		MSUNLOCK()
		(cAliasSX5)->(dbSkip())
		LOOP
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimindo o Relatorio           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aStru := {}
	AADD(aStru,{"CODPROD"	,"C",TamSX3("B1_COD")[01],0})		//Codigo do Produto
	AADD(aStru,{"XPRDCIV"	,"C",TamSX3("B1_XPRDCIV")[01],0})	//Codigo do Produto
	AADD(aStru,{"DESCPROD"	,"C",TamSX3("B1_DESC")[01],0})		//Descricao do Produto
	AADD(aStru,{"SLDANT"	,"N",TamSX3("B9_QINI")[01],TamSX3("B9_QINI")[02]})	//Saldo Anterior
	AADD(aStru,{"COMPRAS"	,"N",015,2})						//Total de Compras
	AADD(aStru,{"CONSUMO"	,"N",015,2})						//
	AADD(aStru,{"VENDAS"	,"N",015,2})						//Total de Vendas, Perdas ou transferências
	AADD(aStru,{"UM"	    ,"C",002,0})						//Unidade de Medida
	AADD(aStru,{"ENDE"		,"C",TamSX3("A1_END")[01],0})		//Endereco
	AADD(aStru,{"BAIRRO"	,"C",TamSX3("A1_BAIRRO")[01],0})	//Bairro
	AADD(aStru,{"CEP"    	,"C",TamSX3("A1_CEP")[01],0})		//Cep
	AADD(aStru,{"MUN"		,"C",TamSX3("A1_MUN")[01],0})		//Municipio
	AADD(aStru,{"UF"		,"C",TamSX3("A1_EST")[01],0})		//UF
	AADD(aStru,{"NREDUZ"	,"C",TamSX3("A1_NREDUZ")[01],0})	//Cliente/Fornecedor

	If oTmpTable <> Nil
		oTmpTable:Delete()
		oTmpTable := Nil
	Endif
		
	oTmpTable := FWTemporaryTable():New( "T01" )  
	oTmpTable:SetFields(aStru) 
	oTmpTable:AddIndex("1", {"DESCPROD"})
	oTmpTable:Create()  

	dbSelectArea("T01")
	dbSetOrder(1)
	dbGoTop()

	While !Eof()
		If Interrupcao(@lEnd)
			Return Nil
		Endif

		If olReport:Row() == 0
			PRTCABEC01()
		Elseif olReport:Row() >= 2050
			olReport:Line(olReport:Row() ,100  ,olReport:Row() ,nLarpag  )
			PRTRDP01()
			PRTCABEC01()
		Endif

		If lAglutina
			cCodPrd :=  SubStr(Posicione("SX5",1,XFILIAL("SX5")+'ZZ'+T01->XPRDCIV,'X5_DESCRI'),1,78)
		Else
			cCodPrd := SubStr(Alltrim(T01->CODPROD)+" - "+T01->DESCPROD,1,78)
		EndIf
		nCompras := T01->COMPRAS
		nSoma 	 := T01->SLDANT+T01->COMPRAS
		nConsumo := T01->CONSUMO

		IF nConsumo < 0
			nSoma	 +=	(nConsumo * -1)
			nConsumo := 0
		Endif

		olReport:Say( olReport:Row(), aPosCab01[1]+nPos,cCodPrd, oFont8 )
		olReport:Say( olReport:Row(), aPosCab01[2]+nPos,Transform(T01->SLDANT,"@R 999,999,999,999.99"), oFont8 )
		olReport:Say( olReport:Row(), aPosCab01[3]+nPos,Transform(nCompras,"@R 999,999,999,999.99"), oFont8 )
		olReport:Say( olReport:Row(), aPosCab01[4]+nPos,Transform(nSoma,"@R 999,999,999,999.99"), oFont8 )
		olReport:Say( olReport:Row(), aPosCab01[5]+nPos,Transform(nConsumo,"@R 999,999,999,999.99"), oFont8 )
		olReport:Say( olReport:Row(), aPosCab01[6]+nPos,Transform(T01->VENDAS,"@R 999,999,999,999.99"), oFont8 )
		olReport:Say( olReport:Row(), aPosCab01[7]+nPos,Transform(T01->SLDANT+T01->COMPRAS-T01->VENDAS-T01->CONSUMO,"@R 999,999,999,999.99"), oFont8 )
		olReport:Say( olReport:Row(), aPosCab01[8]+nPos,SPACE(1)+Iif(Empty(T01->UM),'KG',T01->UM), oFont8 )
		FR031Col( olReport,aPosCab01)
		olReport:Line(olReport:Row() ,100  ,olReport:Row() ,nLarpag  )  // Linha final
		olReport:SkipLine( 1 )

		lMov := .T.

		dbSelectArea("T01")
		dbSkip()
	Enddo

	If !lMov

		PRTCABEC01()

		olReport:Say( olReport:Row(), 0150, "NÃO HOUVE COMPRA(OU VENDA)NO TRIMESTRE ACIMA ESPECIFICADO ", oFont8 )
		olReport:endpage()

	EndiF

	olReport:Line(olReport:Row() ,100  ,olReport:Row() ,nLarpag  )  // Linha final

	IF olReport:nRow >= 2050
		PRTCABEC01()
	Endif
	PRTRDP01()

	cTitulo	 := "MAPA TRIMESTRAL REFERENTE A COMPRAS (ANEXO II)"
	lMov	 := .F.

	dbSelectArea("T02")
	dbSetOrder(1)
	dbGoTop()

	While !Eof()
		If Interrupcao(@lEnd)
			Return Nil
		Endif

		If olReport:Row() == 0
			PRTCABEC02()
		Elseif olReport:Row() >= 2050
			PRTRDP01()
			PRTCABEC02()
		Endif

		cCodPrdCiv := Posicione("SB1",1,xFilial("SB1")+T02->CODPROD,"B1_XPRDCIV")

		If lAglutina
			cCodPrd :=  SubStr(Posicione("SX5",1,XFILIAL("SX5")+'ZZ'+cCodPrdCiv,'X5_DESCRI'),1,55)
		Else
			cCodPrd :=  SubStr(Alltrim(T02->CODPROD)+" - "+Posicione("SB1",1,xFilial("SB1")+T02->CODPROD,"B1_DESC"),1,55)
		EndIF

		olReport:Say( olReport:Row(), aPosCab02[1]+10, (StrZero (Day(T02->EMISSAO), 2)+"/"+StrZero (Month (T02->EMISSAO), 2)+"/"+StrZero (Year (T02->EMISSAO), 4)), oFont8 )
		olReport:Say( olReport:Row(), aPosCab02[2]+nPos, PADC(T02->NF,10), oFont8 )
		olReport:Say( olReport:Row(), aPosCab02[3]+nPos, Transform(T02->QUANT,"9999999.99"), oFont8 )
		olReport:Say( olReport:Row(), aPosCab02[4]+nPos, Space(4)+T02->UM, oFont8 )
		olReport:Say( olReport:Row(), aPosCab02[5]+5,  cCodPrd  , oFont8 )


		olReport:Say( olReport:Row(), aPosCab02[6]+5, Alltrim(T02->EMPRESA), oFont8 )
		olReport:Say( olReport:Row(), aPosCab02[7]+5, Alltrim(T02->NTRANSP), oFont8 )
		FR031Col( olReport,aPosCab02)
		olReport:SkipLine( 1 )
		cEndForn := Substr(Alltrim(T02->ENDE)+' '+T02->CEP+' '+Alltrim(T02->FONE)+' '+Alltrim(T02->MUN)+' '+T02->UF,1,67)
		cEndTran := Substr(Alltrim(T02->ENDTRAN)+' '+T02->CEPTRAN+' '+Alltrim(T02->TELTRAN)+' '+Alltrim(T02->MUNTRAN)+' '+T02->ESTTRAN,1,67)

		olReport:Say( olReport:Row(), aPosCab02[6]+5, Alltrim(cEndForn), oFont8 )
		olReport:Say( olReport:Row(), aPosCab02[7]+5, Alltrim(cEndTran), oFont8 )
		FR031Col( olReport,aPosCab02)
		olReport:SkipLine( 1 )
		/*
		olReport:Say( olReport:Row(), aPosCab02[6]+nPos, Substr(T02->ENDE,1,26)+' '+T02->CEP, oFont8 )
		olReport:Say( olReport:Row(), aPosCab02[7]+nPos, Substr(T02->ENDTRAN,1,26)+' '+T02->CEPTRAN, oFont8 )
		FR031Col( olReport,aPosCab02)

		olReport:SkipLine( 1 )
		olReport:Say( olReport:Row(), aPosCab02[6]+nPos, T02->MUN+' '+T02->UF, oFont8 )
		olReport:Say( olReport:Row(), aPosCab02[7]+nPos, T02->MUNTRAN+' '+T02->ESTTRAN, oFont8 )
		FR031Col( olReport,aPosCab02)
		olReport:SkipLine( 1 )
		olReport:Say( olReport:Row(), aPosCab02[6]+nPos, T02->FONE, oFont8 )
		olReport:Say( olReport:Row(), aPosCab02[7]+nPos, T02->TELTRAN, oFont8 )
		FR031Col( olReport,aPosCab02)
		olReport:SkipLine( 1 )
		*/
		olReport:Line(olReport:Row() ,100  ,olReport:Row() ,nLarpag  )  // Linha final

		lMov	 := .T.
		dbSelectArea("T02")
		dbSkip()
	Enddo

	If !lMov

		PRTCABEC02()

		olReport:Say( olReport:Row(), 0150, "NÃO HOUVE COMPRA(OU VENDA)NO TRIMESTRE ACIMA ESPECIFICADO ", oFont8 )
		olReport:endpage()

	EndiF

	if olReport:Row() >= 2050
		PRTCABEC02()
	Endif
	PRTRDP01()


	cTitulo	 := "MAPA TRIMESTRAL DE VENDA DE PRODUTOS CONTROLADOS (ANEXO III)"
	lMov	 := .F.

	olReport:endpage()
	dbSelectArea("T03")
	dbSetOrder(1)
	dbGoTop()

	While !Eof()
		If Interrupcao(@lEnd)
			Return Nil
		Endif

		If olReport:Row() == 0
			PRTCABEC03()
		Elseif olReport:Row() >= 2050
			PRTRDP01()
			PRTCABEC03()
		Endif

		cCodPrdCiv := Posicione("SB1",1,xFilial("SB1")+T03->CODPROD,"B1_XPRDCIV")

		If lAglutina
			cCodPrd :=  Alltrim(Posicione("SX5",1,XFILIAL("SX5")+'ZZ'+cCodPrdCiv,'X5_DESCRI'))
		Else
			cCodPrd :=  Alltrim(Alltrim(T03->CODPROD)+" - "+T03->DESCPROD)
		EndIF
		cCliente := Alltrim(T03->EMPRESA)+' '+Alltrim(T03->ENDE)+' - '+T03->CEP+' '+Alltrim(T03->BAIRRO)+' '+Alltrim(T03->MUN)+' '+T03->UF


		olReport:Say( olReport:Row(), aPosCab03[1]+nPos, (StrZero (Day(T03->EMISSAO), 2)+"/"+StrZero (Month (T03->EMISSAO), 2)+"/"+StrZero (Year (T03->EMISSAO), 4)), oFont8 )
		olReport:Say( olReport:Row(), aPosCab03[2]+nPos, cCliente , oFont8 )

		/*olReport:Say( olReport:Row(), aPosCab03[2]+nPos, T03->NREDUZ, oFont8 )
		olReport:Say( olReport:Row(), aPosCab03[3]+nPos, Substr(T03->ENDE,1,29)+' - '+T03->CEP, oFont8 )
		olReport:Say( olReport:Row(), aPosCab03[4]+nPos, Substr(T03->BAIRRO,1,15), oFont8 )
		olReport:Say( olReport:Row(), aPosCab03[5]+nPos, Substr(T03->MUN,1,15), oFont8 )
		olReport:Say( olReport:Row(), aPosCab03[6]+nPos, T03->UF, oFont8 )
		olReport:Say( olReport:Row(), aPosCab03[7]+nPos, T03->DOC, oFont8 )
		olReport:Say( olReport:Row(), aPosCab03[8]+nPos, Substr(T03->DDD,1,3)+' '+Substr(T03->TEL,1,8), oFont8 )
		*/
		olReport:Say( olReport:Row(), aPosCab03[3]+nPos, T03->DOC, oFont8 )
		olReport:Say( olReport:Row(), aPosCab03[4]+nPos, cCodPrd , oFont8 )
		olReport:Say( olReport:Row(), aPosCab03[5]+nPos, PADC(T03->UM,10), oFont8 )
		olReport:Say( olReport:Row(), aPosCab03[6]+nPos, Transform(T03->QUANT,"99999999.99"), oFont8 )
		olReport:Line(olReport:Row() ,100  ,olReport:Row() ,nLarpag  )  // Linha final

		FR031Col( olReport,aPosCab03)
		olReport:SkipLine( 1 )
		olReport:Line(olReport:Row() ,100  ,olReport:Row() ,nLarpag  )  // Linha final


		lMov	 := .T.
		dbSelectArea("T03")
		dbSkip()
	Enddo

	If !lMov

		PRTCABEC03()
		olReport:Say( olReport:Row(), 0150, "NÃO HOUVE COMPRA(OU VENDA)NO TRIMESTRE ACIMA ESPECIFICADO ", oFont8 )

	EndiF

	If olReport:Row() >= 2050
		PRTCABEC03()
	Endif

	PRTRDP01()

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GeraTemp  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 13.01.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Processa o relatorio                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraTemp()

	Local aStru 	:= {}
	Local cArq1 	:= ""
	Local aDelArqs 	:= {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ T01 - Relatorio Sintetico COMPRAS          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru,{"CODPROD"	,"C",TamSX3("B1_COD")[01],0})	//Codigo do Produto
	AADD(aStru,{"XPRDCIV"	,"C",TamSX3("B1_XPRDCIV")[01],0})	//Codigo do Produto
	AADD(aStru,{"DESCPROD"	,"C",TamSX3("B1_DESC")[01],0})	//Descricao do Produto
	AADD(aStru,{"SLDANT"	,"N",TamSX3("B9_QINI")[01],TamSX3("B9_QINI")[02]})	//Saldo Anterior
	AADD(aStru,{"COMPRAS"	,"N",015,2})					//Total de Compras
	AADD(aStru,{"CONSUMO"	,"N",015,2})					//
	AADD(aStru,{"VENDAS"	,"N",015,2})					//Total de Vendas, Perdas ou transferências
	AADD(aStru,{"UM"	    ,"C",002,0})					//Unidade de Medida
	AADD(aStru,{"ENDE"		,"C",TamSX3("A1_END")[01],0})							//Endereco
	AADD(aStru,{"BAIRRO"	,"C",TamSX3("A1_BAIRRO")[01],0})						//Bairro
	AADD(aStru,{"CEP"    	,"C",TamSX3("A1_CEP")[01],0})						    //Cep
	AADD(aStru,{"MUN"		,"C",TamSX3("A1_MUN")[01],0})							//Municipio
	AADD(aStru,{"UF"		,"C",TamSX3("A1_EST")[01],0})							//UF
	AADD(aStru,{"NREDUZ"	,"C",TamSX3("A1_NREDUZ")[01],0})						//Cliente/Fornecedor


	oTmpTable := FWTemporaryTable():New( "T01" )  
	oTmpTable:SetFields(aStru) 
	oTmpTable:AddIndex("1", {"CODPROD"})
	oTmpTable:Create() 
	aAdd(aDelArqs,{cArq1,"T01"})
	
	IF (MV_PAR12 == 1)

		oTmpTable := FWTemporaryTable():New( "T01AG" )  
		oTmpTable:SetFields(aStru) 
		oTmpTable:AddIndex("1", {"XPRDCIV"})
		oTmpTable:Create()  
		aAdd(aDelArqs,{cArq1,"T01AG"})
	Endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ T02 - Relatorio Analitico COMPRAS          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aStru := {}
	cArq1 := ""
	AADD(aStru,{"CODPROD"	,"C",TamSX3("B1_COD")[01],0})							//Codigo do Produto
	AADD(aStru,{"EMISSAO"	,"D",TamSX3("F3_EMISSAO")[01],0})  						//Data
	AADD(aStru,{"EMPRESA"	,"C",TamSX3("A1_NOME")[01],0})							//Cliente e/ou Fornecedor
	AADD(aStru,{"ENDE"		,"C",TamSX3("A1_END")[01],0})							//Endereco
	AADD(aStru,{"MUN"		,"C",TamSX3("A1_MUN")[01],0})							//Municipio
	AADD(aStru,{"UF"		,"C",TamSX3("A1_EST")[01],0})							//UF
	AADD(aStru,{"NF"		,"C",TamSX3("F3_NFISCAL")[01],0})						//Nota Fiscal
	AADD(aStru,{"SERIE"		,"C",TamSX3("F3_SERIE")[01],0})							//Seria da NF
	AADD(aStru,{"CLIEFOR"	,"C",TamSX3("A1_COD")[01],0})							//Cliente/Fornecedor
	AADD(aStru,{"LOJA"		,"C",TamSX3("A1_LOJA")[01],0})							//Loja
	AADD(aStru,{"QUANT"		,"N",TamSX3("D1_QUANT")[01],TamSX3("D1_QUANT")[02]})	//Quantidade
	AADD(aStru,{"UM"	    ,"C",002,0})											//Unidade de Medida
	AADD(aStru,{"CEP"		,"C",TamSX3("A1_CEP")[01],0})							//CEP
	AADD(aStru,{"FONE"		,"C",TamSX3("A1_TEL")[01],0})							//Telefone
	AADD(aStru,{"NTRANSP"	,"C",TamSX3("A4_NREDUZ")[01],0})					//Nome transportadora
	AADD(aStru,{"ENDTRAN"	,"C",TamSX3("A4_END")[01],0})				   		//Endereco da Transportadora
	AADD(aStru,{"CEPTRAN"	,"C",TamSX3("A4_CEP")[01],0})				   		//Cep da Transportadora
	AADD(aStru,{"MUNTRAN"	,"C",TamSX3("A4_MUN")[01],0})						//Municipio da Transportadora
	AADD(aStru,{"ESTTRAN"	,"C",TamSX3("A4_EST")[01],0})				 		//Estado da Transportadora
	AADD(aStru,{"TELTRAN"	,"C",TamSX3("A4_TEL")[01],0})				   		//Telefone da Transportadora

	oTmpTable := FWTemporaryTable():New( "T02" )  
	oTmpTable:SetFields(aStru) 
	oTmpTable:AddIndex("1", {"CODPROD","NF","SERIE","CLIEFOR","LOJA"})
	oTmpTable:Create()  
	aAdd(aDelArqs,{cArq1,"T02"})


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ T03 - Relatorio Analitico VENDAS           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aStru := {}
	cArq1 := ""
	AADD(aStru,{"CODPROD"	,"C",TamSX3("B1_COD")[01],0})							//Codigo do Produto
	AADD(aStru,{"DESCPROD"	,"C",TamSX3("B1_DESC")[01],0})							//Descricao do Produto
	AADD(aStru,{"EMISSAO"	,"D",TamSX3("F3_EMISSAO")[01],0})  						//Data
	AADD(aStru,{"EMPRESA"	,"C",TamSX3("A1_NOME")[01],0})							//Cliente e/ou Fornecedor
	AADD(aStru,{"ENDE"		,"C",TamSX3("A1_END")[01],0})							//Endereco
	AADD(aStru,{"BAIRRO"	,"C",TamSX3("A1_BAIRRO")[01],0})						//Bairro
	AADD(aStru,{"CEP"    	,"C",TamSX3("A1_CEP")[01],0})						    //Cep
	AADD(aStru,{"MUN"		,"C",TamSX3("A1_MUN")[01],0})							//Municipio
	AADD(aStru,{"UF"		,"C",TamSX3("A1_EST")[01],0})							//UF
	AADD(aStru,{"DDD"   	,"C",TamSX3("A1_DDD")[01],0})						    //DDD
	AADD(aStru,{"TEL"   	,"C",TamSX3("A1_TEL")[01],0})						    //Telefonte
	AADD(aStru,{"NF"		,"C",TamSX3("F3_NFISCAL")[01],0})						//Nota Fiscal
	AADD(aStru,{"SERIE"		,"C",TamSX3("F3_SERIE")[01],0})							//Seria da NF
	AADD(aStru,{"CLIEFOR"	,"C",TamSX3("A1_COD")[01],0})							//Cliente/Fornecedor
	AADD(aStru,{"NREDUZ"	,"C",TamSX3("A1_NREDUZ")[01],0})						//Cliente/Fornecedor
	AADD(aStru,{"LOJA"		,"C",TamSX3("A1_LOJA")[01],0})							//Loja
	AADD(aStru,{"QUANT"		,"N",TamSX3("D1_QUANT")[01],TamSX3("D1_QUANT")[02]})	//Quantidade
	AADD(aStru,{"UM"	    ,"C",002,0})											//Unidade de Medida
	AADD(aStru,{"DOC"		,"C",TamSX3("D2_DOC")[01],0})							//Numero da NF.

	
	oTmpTable := FWTemporaryTable():New( "T03" )  
	oTmpTable:SetFields(aStru) 
	oTmpTable:AddIndex("1", {"CODPROD","NF","SERIE","CLIEFOR","LOJA"})
	oTmpTable:Create()  
	aAdd(aDelArqs,{cArq1,"T03"})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ T04 - MAPA TRIMESTRAL DE TRANSPORTES       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aStru := {}
	cArq1 := ""
	AADD(aStru,{"CODPROD"	,"C",TamSX3("B1_COD")[01],0})	//Codigo do Produto
	AADD(aStru,{"DESCPROD"	,"C",TamSX3("B1_DESC")[01],0})	//Descricao do Produto
	AADD(aStru,{"SLDANT"	,"N",TamSX3("B9_QINI")[01],TamSX3("B9_QINI")[02]})	//Saldo Anterior
	AADD(aStru,{"COMPRAS"	,"N",015,2})					//Total de Compras
	AADD(aStru,{"CONSUMO"	,"N",015,2})					//
	AADD(aStru,{"VENDAS"	,"N",015,2})					//Total de Vendas, Perdas ou transferências
	AADD(aStru,{"UM"	    ,"C",002,0})					//Unidade de Medida
	AADD(aStru,{"NF"		,"C",TamSX3("F3_NFISCAL")[01],0})						//Nota Fiscal
	AADD(aStru,{"SERIE"		,"C",TamSX3("F3_SERIE")[01],0})							//Seria da NF
	AADD(aStru,{"CLIEFOR"	,"C",TamSX3("A1_COD")[01],0})							//Cliente/Fornecedor
	AADD(aStru,{"LOJA"		,"C",TamSX3("A1_LOJA")[01],0})							//Loja
	AADD(aStru,{"ENDE"		,"C",TamSX3("A1_END")[01],0})							//Endereco
	AADD(aStru,{"TEL"   	,"C",TamSX3("A1_TEL")[01],0})						    //Telefonte
	AADD(aStru,{"BAIRRO"	,"C",TamSX3("A1_BAIRRO")[01],0})						//Bairro
	AADD(aStru,{"CEP"    	,"C",TamSX3("A1_CEP")[01],0})						    //Cep
	AADD(aStru,{"MUN"		,"C",TamSX3("A1_MUN")[01],0})							//Municipio
	AADD(aStru,{"UF"		,"C",TamSX3("A1_EST")[01],0})							//UF
	AADD(aStru,{"NREDUZ"	,"C",TamSX3("A1_NREDUZ")[01],0})						//Cliente/Fornecedor

	
	oTmpTable := FWTemporaryTable():New( "T04" )  
	oTmpTable:SetFields(aStru) 
	oTmpTable:AddIndex("1", {"CODPROD","NF","SERIE","CLIEFOR","LOJA"})
	oTmpTable:Create()  
	aAdd(aDelArqs,{cArq1,"T04"})


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ T05 - MAPA TRIMESTRAL DE TRANSPORTES          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aStru := {}
	cArq1 := ""
	AADD(aStru,{"CODPROD"	,"C",TamSX3("B1_COD")[01],0})	//Codigo do Produto
	AADD(aStru,{"DESCPROD"	,"C",TamSX3("B1_DESC")[01],0})	//Descricao do Produto
	AADD(aStru,{"SLDANT"	,"N",TamSX3("B9_QINI")[01],TamSX3("B9_QINI")[02]})	//Saldo Anterior
	AADD(aStru,{"COMPRAS"	,"N",015,2})					//Total de Compras
	AADD(aStru,{"CONSUMO"	,"N",015,2})					//
	AADD(aStru,{"VENDAS"	,"N",015,2})					//Total de Vendas, Perdas ou transferências
	AADD(aStru,{"UM"	    ,"C",002,0})					//Unidade de Medida
	AADD(aStru,{"NF"		,"C",TamSX3("F3_NFISCAL")[01],0})						//Nota Fiscal
	AADD(aStru,{"SERIE"		,"C",TamSX3("F3_SERIE")[01],0})							//Seria da NF
	AADD(aStru,{"CLIEFOR"	,"C",TamSX3("A1_COD")[01],0})							//Cliente/Fornecedor
	AADD(aStru,{"LOJA"		,"C",TamSX3("A1_LOJA")[01],0})							//Loja
	AADD(aStru,{"ENDE"		,"C",TamSX3("A1_END")[01],0})							//Endereco
	AADD(aStru,{"TEL"   	,"C",TamSX3("A1_TEL")[01],0})						    //Telefonte
	AADD(aStru,{"BAIRRO"	,"C",TamSX3("A1_BAIRRO")[01],0})						//Bairro
	AADD(aStru,{"CEP"    	,"C",TamSX3("A1_CEP")[01],0})						    //Cep
	AADD(aStru,{"MUN"		,"C",TamSX3("A1_MUN")[01],0})							//Municipio
	AADD(aStru,{"UF"		,"C",TamSX3("A1_EST")[01],0})							//UF
	AADD(aStru,{"NREDUZ"	,"C",TamSX3("A1_NREDUZ")[01],0})						//Cliente/Fornecedor

		
	oTmpTable := FWTemporaryTable():New( "T05" )  
	oTmpTable:SetFields(aStru) 
	oTmpTable:AddIndex("1", {"CODPROD","NF","SERIE","CLIEFOR","LOJA"})
	oTmpTable:Create()  
	aAdd(aDelArqs,{cArq1,"T05"})


Return(aDelArqs)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Mtr947Est ³ Autor ³ Mary C. Hergert       ³ Data ³28/03/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera os arquivos temporarios com os movimentos de estoque   ³±±
±±³          ³no inicio e no final do periodo.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 = Tipo (1 - gera arquivos / 2 - deleta gerados)       ³±±
±±³          ³ExpD2 = Data inicial de geracao das informacoes             ³±±
±±³          ³ExpD3 = Data final de geracao das informacoes               ³±±
±±³          ³ExpC4 = Produto a ser filtrado                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Matr947                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MAPAEST(nTipo,dDtIni,dDtFim,cProduto)

	Local dData		 :=DTOS(mv_par03)
	Local dDtAnt    := FirstDay(dDtIni)-1

	Local cCpoB5	:= " "

	Local cArqAnt    := ""
	Local cArqAtu 	 := ""
	Local cFiltraB5	 := ""
	Local cTrimestre := mv_par04

	Local aProd      :=Array(8)
	Local aFiltraB5	:= {}

	Local nX		:= 0

	aProd[1] := Replicate("",TamSx3("B1_COD")[1])
	aProd[2] := Replicate("Z",TamSx3("B1_COD")[1])
	aProd[3] := Replicate("",TamSx3("B1_LOCPAD")[1])
	aProd[4] := Replicate("Z",TamSx3("B1_LOCPAD")[1])
	aProd[5] := 2
	aProd[6] := 1
	aProd[7] := 2
	aProd[8] := 2

	If cTrimestre == 1
		dDataIni := Stod('20130101')
		dDataFin := CToD("31/12/"+Substr(Alltrim(Str(Year(MV_PAR03)-1)),3))
	ElseIf cTrimestre == 2
		dDataIni := Stod('20130101')
		dDataFin := CToD("31/03/"+Substr(Alltrim(Str(Year(MV_PAR03))),3))
	ElseIf cTrimestre == 3
		dDataIni := Stod('20130101')
		dDataFin := CToD("30/06/"+Substr(Alltrim(Str(Year(MV_PAR03))),3))
	ElseIf cTrimestre == 4
		dDataIni := Stod('20130101')
		dDataFin := CToD("30/09/"+Substr(Alltrim(Str(Year(MV_PAR03))),3))
	Endif

	// Indicacao de produto controlado ou nao
	If Empty(cProduto)
		cFiltraB5 += " AND SB1.B1_XPRDCIV <> ' ' "
	else
		cFiltraB5 += " AND SB1.B1_XPRDCIV = '" + cProduto + "'"
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria os arquivos temporarios com o estoque inicial/final dos produtos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTipo == 1 // Gera os temporarios com o estoque inicial/final


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ANT - Estoque Anterior                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FsEstInv({"ANT",""},1,.T.,.F.,dDtAnt,.F.,,.T.,cFiltraB5,,,,aProd)

		dbSelectArea("ANT")
		cArqAnt := CriaTrab(NIL,.F.)
		IndRegua("ANT",cArqAnt,"CODIGO")

		dbSelectArea("ANT")
		Zap

		CQUERY := ' SELECT B9_FILIAL, B9_COD,  B9_DATA,SUM( B9_QINI) AS "B9_QINI" '
		CQUERY += " FROM SB9010 EST , SB1010 SB1 "
		CQUERY += " WHERE SB1.B1_COD = B9_COD "
		cQuery += cFiltraB5
		CQUERY += " AND SB1.D_E_L_E_T_ <> '*'     "
		CQUERY += " AND B9_QINI > 0 "
		CQUERY += " AND B9_DATA = '"+DTOS(dDtAnt)+"' "
		CQUERY += " AND EST.D_E_L_E_T_ <> '*'    "
		CQUERY += " GROUP BY B9_FILIAL, B9_COD, B9_DATA "

		DBUSEAREA( .T., "TOPCONN", TCGENQRY( NIL, NIL, CQUERY ), "TMP_SB9", .T., .F. )

		DBGOTOP()
		WHILE !EOF()

			DBSELECTAREA("ANT")

			RECLOCK("ANT",.T.)
			ANT->CODIGO 	:= TMP_SB9->B9_COD
			ANT->CODPRD 	:= TMP_SB9->B9_COD
			ANT->QUANT 		:= TMP_SB9->B9_QINI
			MSUNLOCK()

			DBSELECTAREA("TMP_SB9")
			DBSKIP()
			LOOP
		ENDDO

		If Select( "TMP_SB9" ) > 0
			TMP_SB9->( dbCloseArea() )
		Endif

		cQuery := " SELECT B6_PRODUTO,B6_CLIFOR,B6_LOJA,B6_IDENT,B6_TES, B6_TIPO, B1_XPRDCIV "
		cQuery += " FROM  SB6010 SB6, SB1010 SB1 "
		cQuery += " WHERE "
		cQuery += " B1_COD = B6_PRODUTO  "
		cQuery += cFiltraB5
		cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
		cQuery += " AND B6_FILIAL  = '02'  "
		cQuery += " AND B6_DTDIGIT BETWEEN  '"+DtoS(dDataIni)+"' AND '"+DtoS(dDataFin)+"' "
		if !EMPTY(MV_PAR13)
			cQuery += " AND B6_TES IN " + FormatIn(MV_PAR13,";")
		endif
		cQuery += " AND B6_TIPO    = 'E'  "
		cQuery += " AND B6_PODER3  = 'R'  "
		cQuery += " AND SB6.D_E_L_E_T_ <> '*' "
		cQuery += " ORDER BY SB6.B6_IDENT "
		If Select( "TMP_SB6" ) > 0
			TMP_SB6->( dbCloseArea() )
		Endif

		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SB6", .T., .F. )

		dbGoTop()

		olReport:SetMeter(LastRec())

		While !Eof()
			olReport:IncMeter()

			dbSelectArea("SF4")
			MsSeek(cFilial+TMP_SB6->B6_TES)
			If SF4->F4_PODER3 == "D"
				dbselectArea(TMP_SB6)
				dbSkip()
				loop
			Endif

			dbSelectArea("TMP_SB6")
			aSaldo  := CalcTerc(TMP_SB6->B6_PRODUTO,TMP_SB6->B6_CLIFOR,TMP_SB6->B6_LOJA,TMP_SB6->B6_IDENT,TMP_SB6->B6_TES,,dDataIni,dDataFin)
			dbSelectArea("TMP_SB6")
			nSaldo  := aSaldo[1]
			If nSaldo <= 0
				dbSkip()
				Loop
			ElseIf B6_TIPO != "E"
				dbSkip()
				Loop
			Endif

			DBSELECTAREA("ANT")

			If ANT->(dbSeek(TMP_SB6->B6_PRODUTO))
				RecLock("ANT",.F.)
				ANT->QUANT += nSaldo
				MsUnLock()
			Else
				RecLock("ANT",.T.)
				ANT->CODIGO := TMP_SB6->B6_PRODUTO
				ANT->CODPRD := TMP_SB6->B6_PRODUTO
				ANT->QUANT := nSaldo
				MsUnLock()
			Endif

			dbselectArea("TMP_SB6")
			dbSkip()
			loop
		Enddo

		If Select( "TMP_SB6" ) > 0
			TMP_SB6->( dbCloseArea() )
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ATU - Estoque Atual                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FsEstInv({"ATU",""},1,.T.,.F.,dDtFim,.F.,,.T.,cFiltraB5,,,,aProd)
		dbSelectArea("ATU")
		cArqAtu := CriaTrab(NIL,.F.)
		IndRegua("ATU",cArqAtu,"CODIGO")

	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Exclui os temporarios criados com o estoque final e inicial³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FsEstInv({"ANT",""},2,,,dDtAnt,.F.,,.T.,cFiltraB5,,,,aProd)	//Estoque Anterior
		FsEstInv({"ATU",""},2,,,dDtFim,.F.,,.T.,cFiltraB5,,,,aProd)	//Estoque Atual
	Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Mtr947Str ºAutor  ³Mary Hergert        º Data ³ 03/04/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Montar um array apenas com os campos utiLizados na query    º±±
±±º          ³para passagem na funcao TCSETFIELD                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Array com os campos da query                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³aCampos: campos a serem tratados na query                   º±±
±±º          ³cCmpQry: string contendo os campos para select na query     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MATR948                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Mtr947Str(aCampos,cCmpQry)

	Local	aRet		:=	{}
	Local	nX			:=	0
	Local	aTamSx3		:=	{}
	Local	cFieldPos	:= ""

	For nX := 1 To Len(aCampos)
		cFieldPos := aCampos[nX][01] + '->' + '(FieldPos("' + aCampos[nX][02] + '"))'
		If &(cFieldPos) > 0
			aTamSx3 := TamSX3(aCampos[nX][02])
			aAdd (aRet,{aCampos[nX][02],aTamSx3[3],aTamSx3[1],aTamSx3[2]})
			cCmpQry	+=	aCampos[nX][01] + "." + aCampos[nX][02] + ", "
		EndIf
	Next(nX)

	If(Len(cCmpQry)>0)
		cCmpQry	:=	" " + SubStr(cCmpQry,1,Len(cCmpQry)-2) + " "
	EndIf

Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M947DelArqºAutor  ³Mary Hergert        º Data ³ 03/04/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclui tabelas e indices temporarios criados.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³aDelArqs : array com o alias e os arquivos                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MATR947                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function M947DelArq(aDelArqs)

	Local ni := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Fechando as tabelas temporarias                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For ni := 1 to Len(aDelArqs)
		If File(aDelArqs[ni,1]+GetDBExtension())
			dbSelectArea(aDelArqs[ni,2])
			dbCloseArea()
			Ferase(aDelArqs[ni,1]+GetDBExtension())
			Ferase(aDelArqs[ni,1]+OrdBagExt())
		Endif
		If File(aDelArqs[ni,1]+OrdBagExt())
			Ferase(aDelArqs[ni,1]+OrdBagExt())
		Endif
	Next

Return

Static Function PRTCABEC01()
	Local cTitulo	:= "MOVIMENTO GERAL (ANEXO I)"

	Local aCol01 := {}
	Local aCol02 := {}
	Local nInc := 0

	AAdd(aCol01,"")
	AAdd(aCol01,Space(1)+"Saldo Trimestre")
	AAdd(aCol01,Space(5)+"Compras")
	AAdd(aCol01,"")
	AAdd(aCol01,"")
	AAdd(aCol01,Space(3)+"Vendas, perdas ou")
	AAdd(aCol01,Space(3)+"Saldo que passa para")
	AAdd(aCol01,"")

	AAdd(aCol02,Space(25)+"Produto Controlado")
	AAdd(aCol02,Space(5)+"Anterior")
	AAdd(aCol02,Space(4)+"Fabricação")
	AAdd(aCol02,Space(7)+"Somas")
	AAdd(aCol02,Space(7)+"Consumo")
	AAdd(aCol02,Space(5)+"Transferencia")
	AAdd(aCol02,Space(5)+"o Trimestre Seguinte ")
	AAdd(aCol02,Space(1)+"UN")


	If olReport:nRow > 1900
		olReport:Endpage()
	Endif
	olReport:StartPage()
	olReport:SkipLine( 1 )

	olReport:Box (olReport:Row() ,0100  ,olReport:Row()+240 ,nLarpag )  // Retangulo Cabeçalho
	olReport:Line(olReport:Row() ,1200  ,olReport:Row()+240 ,1200  )  // 01 Coluna Cabeçalho
	olReport:Line(olReport:Row() ,2100  ,olReport:Row()+240 ,2100  )  // 02 Coluna Cabeçalho

	olReport:SkipLine( 1 )
	olReport:Say( olReport:Row(), 0150,"Empresa "+ SM0->M0_NOMECOM, oFont8 )
	olReport:Say( olReport:Row(), 1450, cTitulo, oFont8 )
	olReport:Say( olReport:Row(), 2140,"Certificado de Vistoria nº" +mv_par05 +"   , expedido ", oFont10 )
	olReport:SkipLine( 1 )
	olReport:Say( olReport:Row(), 1500,"MAPA TRIMESTRAL", oFont8 )
	olReport:Say( olReport:Row(), 2140,"pela SSP/Policia Civil Estadual.", oFont10 )

	olReport:SkipLine( 1 )
	olReport:Say( olReport:Row(), 0150, "Estabelecimento Licenciado: "+SM0->M0_ENDENT, oFont8 )
	olReport:Say( olReport:Row(), 1400, "PRODUTOS QUÍMICOS CONTROLADOS", oFont8 )
	olReport:SkipLine( 1 )

	cEndEmp := "Bairro "+AllTrim(SM0->M0_BAIRENT)+ " - Cidade "+AllTrim(SM0->M0_CIDENT)+" - Estado "+AllTrim(SM0->M0_ESTENT)+" - CEP "+Transform(SM0->M0_CEPENT,"@R 99999-999")

	olReport:Say( olReport:Row(), 0150, cEndEmp , oFont8 )
	olReport:Say( olReport:Row(), 1570, "DIRD ", oFont8 )
	olReport:Say( olReport:Row(), 2140, "Alvará nº "+mv_par06+" Expedido pela Secretaria da", oFont10 )
	olReport:SkipLine( 1 )
	olReport:Say( olReport:Row(), 0150, "TELEFONE "+SM0->M0_TEL, oFont8 )
	olReport:Say( olReport:Row(), 1370, "DPC - DIVISÃO DE PRODUTOS CONTROLADOS", oFont8 )
	olReport:Say( olReport:Row(), 2140, "Segurança Pública/Polícia Civil Estadual.", oFont10 )
	olReport:SkipLine( 1 )
	olReport:Say( olReport:Row(), 0150, "CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+Space(10)+"Insc. Est.: "+Transform(SM0->M0_INSC,"@R 999.999.999.999"), oFont8 )
	olReport:Say( olReport:Row(), 1400, "Referente ao  "+	Transform(mv_par04,"9")+"º trimestre de "+Transform(Year(mv_par02),"9999"), oFont8 )

	olReport:SkipLine( 2 )

	For nInc := 1 To Len( aCol01 )
		olReport:Say( olReport:Row(), aPosCab01[nInc]+nPos , aCol01[nInc], oFont8 )
	Next
	FR031Col( olReport,aPosCab01)

	olReport:SkipLine( 1 )

	// Segunda linha
	For nInc := 1 To Len( aCol02 )
		olReport:Say( olReport:Row(), aPosCab01[nInc]+nPos, aCol02[nInc], oFont8 )
	Next
	FR031Col( olReport,aPosCab01)
	olReport:SkipLine( 1 )

	olReport:Line(olReport:Row() ,100  ,olReport:Row() ,nLarpag  )  // Linha final
Return()


Static Function PRTRDP01()

	olReport:nRow := 2100

	olReport:Say( olReport:Row(), 2320, PADL(UPPER("O que declaro é verdade, sob as penas da lei."),60)   , oFont10 )
	olReport:SkipLine( 2 )
	//olReport:Say( olReport:Row(), 0150, "A não entrega deste até dez dias após o término   " , oFont8 )
	cDia := STRZERO(Day(mv_par14),2)
	cMes := MesExtenso(Month(mv_par14))
	cAno := STRZERO(Year(mv_par14),4)

	olReport:Say( olReport:Row(), 2320, PADL("Diadema, "+cDia+" de "+cMes+" de "+cAno+".",60) , oFont10 )
	olReport:SkipLine( 2 )
	//olReport:Say( olReport:Row(), 0150, "de cada trimestre pode implicar à empresa severas", oFont8 )
	olReport:Say( olReport:Row(), 2320, PADL("ASSINATURA"+"______________________________",60), oFont10 )
	olReport:SkipLine( 2 )
	//olReport:Say( olReport:Row(), 0150,"penalidades", oFont8 )
	olReport:Say( olReport:Row(), 2320,PADL("NOME/CARGO/RG:",60) , oFont10 )
	olReport:SkipLine( 2 )
	olReport:Say( olReport:Row(), 1400,Str(olReport:OPRINT:NPAGE), oFont10 )
	olReport:Say( olReport:Row(), 2320,PADL(cCompl,60) , oFont10 )

	olReport:endpage()

Return()

Static Function PRTCABEC02()

	Local aCol01 := {"DATA", " Nº NOTA " , " QUANTIDADE "  ," UNIDADE  " ,"NOME DOS PRODUTOS COMPRADOS","RAZÃO SOCIAL COMPLETA/ENDEREÇO COMPLETO"  ,"RAZÃO SOCIAL COMPLETA/ENDEREÇO COMPLETO"}
	Local aCol02 := {""    , " FISCAL  " ,     " "         ,"DE MEDIDA " ,         "    "              ,"CEP/FONE/CIDADE/UF DO FORNECEDOR/REMETENTE","CEP/FONE/CIDADE/UF DO TRANSPORTADOR"}
	Local nInc := 0

	If olReport:Row() >= 2300
		olReport:endpage()
	Endif
	olReport:StartPage()

	olReport:SkipLine( 1 )

	olReport:Box (olReport:Row() ,0100  ,olReport:Row()+150 ,nLarpag )  // Retangulo Cabeçalho
	olReport:Line(olReport:Row() ,1480  ,olReport:Row()+150 ,1480  )  // 01 Coluna Cabeçalho
	olReport:Line(olReport:Row() ,2440  ,olReport:Row()+150 ,2440  )  // 02 Coluna Cabeçalho

	olReport:SkipLine( 1 )
	olReport:Say( olReport:Row(), 0150, "Razão Social: "+SM0->M0_NOMECOM, oFont8 )
	olReport:Say( olReport:Row(), 1480, PADC(cTitulo,70), oFont8 )
	olReport:SkipLine( 1 )
	olReport:Say( olReport:Row(), 1480, PADC("RELATÓRIO DO "+Transform(mv_par04,"9")+"º TRIMESTRE DE "+Transform(Year(mv_par02),"9999"),70), oFont8 )
	olReport:Say( olReport:Row(), 0150, "Local Licenciado: "+Alltrim(SM0->M0_ENDENT) , oFont8 )
	olReport:Say( olReport:Row(), 2700, PADC("CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),30), oFont8 )
	olReport:SkipLine( 1 )
	olReport:Say( olReport:Row(), 1480, PADC("Número do Alvará: "+mv_par06,70), oFont8 )
	cEndEmp := AllTrim(SM0->M0_BAIRENT)+ " - "+AllTrim(SM0->M0_CIDENT)+" - "+AllTrim(SM0->M0_ESTENT)
	olReport:Say( olReport:Row(), 0150, cEndEmp , oFont8 )


	olReport:SkipLine( 2 )
	FR031Col( olReport,aPosCab02)
	olReport:SkipLine( 1 )
	For nInc := 1 To Len( aCol01 )
		olReport:Say( olReport:Row(), aPosCab02[nInc]+nPos , aCol01[nInc], oFont8 )
	Next
	FR031Col( olReport,aPosCab02)
	olReport:SkipLine( 1 )
	For nInc := 1 To Len( aCol02 )
		olReport:Say( olReport:Row(), aPosCab02[nInc]+nPos , aCol02[nInc], oFont8 )
	Next
	FR031Col( olReport,aPosCab02)
	olReport:SkipLine( 1 )
	olReport:Line(olReport:Row() ,100  ,olReport:Row() ,nLarpag  )  // Linha final

Return()


Static Function PRTCABEC03()

	Local aCol01 :={"DATA","RAZAO SOCIAL COMPLETA / ENDEREÇO COMPLETO / CEP / CIDADE / UF","N.F.N","DESCRIÇÃO","UNID. MEDIDA","QUANTIDADE"}
	Local nInc := 0

	If olReport:Row() >= 2300
		olReport:endpage()
	Endif
	olReport:StartPage()

	olReport:SkipLine( 1 )

	olReport:Box (olReport:Row() ,0100  ,olReport:Row()+150 ,nLarpag )  // Retangulo Cabeçalho
	olReport:Line(olReport:Row() ,1000  ,olReport:Row()+150 ,1000  )  // 01 Coluna Cabeçalho
	olReport:Line(olReport:Row() ,2300  ,olReport:Row()+150 ,2300  )  // 02 Coluna Cabeçalho

	olReport:SkipLine( 1 )
	olReport:Say( olReport:Row(), 0150, SM0->M0_NOMECOM, oFont8 )
	olReport:Say( olReport:Row(), 1250, cTitulo , oFont8 )
	olReport:SkipLine( 1 )
	olReport:Say( olReport:Row(), 0150, "Local Licenciado: "+Alltrim(SM0->M0_ENDENT), oFont8 )
	olReport:Say( olReport:Row(), 1450," RELATÓRIO DO "+Transform(mv_par04,"9")+"º TRIMESTRE DE "+Transform(Year(mv_par02),"9999"), oFont8 )
	olReport:Say( olReport:Row(), 2700, "CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont8 )

	olReport:SkipLine( 1 )
	cEndEmp := AllTrim(SM0->M0_BAIRENT)+ " - "+AllTrim(SM0->M0_CIDENT)+" - "+AllTrim(SM0->M0_ESTENT)
	olReport:Say( olReport:Row(), 0150, cEndEmp , oFont8 )
	olReport:Say( olReport:Row(), 1500, "Número do Alvará: "+mv_par06, oFont8 )
	olReport:SkipLine( 2 )


	FR031Col( olReport,aPosCab03)
	olReport:SkipLine( 1 )
	For nInc := 1 To Len( aCol01 )
		olReport:Say( olReport:Row(), aPosCab03[nInc]+nPos , aCol01[nInc], oFont8 )
	Next
	FR031Col( olReport,aPosCab03)
	olReport:SkipLine( 1 )

Return()


Static Function FR031Col( olReport,aPosCab)
Local nX := 0
	nCol1 := olReport:NROW
	olReport:Line(nCol1 ,0100  ,nCol1+30 ,0100  )  // 01 Inicial

	For nX := 2 to Len(aPosCab)
		olReport:Line(nCol1 ,aPosCab[nX] ,nCol1+30 ,aPosCab[nX]  )
	Next nX

	olReport:Line(nCol1 ,nLarpag  ,nCol1+30 ,nLarpag )
	nCol1  += 30

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELPCEXCEL ºAutor  ³Microsiga           º Data ³ 26/12/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Policia Civil em Excel                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RELPCEXCEL()
	Local oExcel := FWMSEXCEL():New()

	Local cTrimestre := mv_par04
	Local cVistoria  := mv_par05
	Local cAlvara    := mv_par06
	Local cValidade	 := mv_par07
	Local dDtIni   	 := mv_par02
	Local dDtFim	:= mv_par03
	Local lMov 		:= .F.

	Local cArq := ""
	Local cDir := GetSrvProfString("Startpath","")
	Local cWorkSheet := ""
	Local cTable := ""
	Local cDirTmp := GetTempPath()
	Local nX := 0

	Private cNome  := Alltrim(mv_par08)
	Private cCargo := Alltrim(mv_par09)
	Private cRg    := Alltrim(mv_par10)
	Private cCompl := (cNome+" - "+cCargo+" - "+cRg)
	Private nPos := 20
	Private oFont7b := TFont():New( "Courier New",, -06,,.T. )

	Private oFont8	:= TFont():New( "Courier New",, 08 )

	Private aPosCab01  := {120,1200,1500,1800,2100,2400,2700,3000}
	Private aPosCab02  := {120,300,600,1000,1200,1800,2600}
	Private aPosCab03  := {120,320,620,1220,1520,1820,1920,2120,2320,2820,3020}
	Private cCadastro := "Policia Civil"

	if lAglutina

		dbSelectArea("T01")
		dbSetOrder(1)
		dbGoTop()

		While !Eof()

			dbSelectArea("T01AG")
			dbSetOrder(1)
			cCodPrdCiv := Posicione("SB1",1,xFilial("SB1")+T01->CODPROD,"B1_XPRDCIV")
			If !MsSeek(cCodPrdCiv)

				RecLock("T01AG",.T.)

				T01AG->CODPROD	:=	T01->CODPROD
				T01AG->XPRDCIV	:=	cCodPrdCiv
				T01AG->DESCPROD	:=	T01->DESCPROD
				T01AG->UM	 	:=	T01->UM
				T01AG->ENDE	 	:=	T01->ENDE
				T01AG->BAIRRO	:=	T01->BAIRRO
				T01AG->CEP	 	:=	T01->CEP
				T01AG->MUN	 	:=	T01->MUN
				T01AG->UF	 	:=	T01->UF
				T01AG->NREDUZ	:=	T01->NREDUZ
			Else
				RecLock("T01AG",.F.)
			Endif
			T01AG->SLDANT	 +=	T01->SLDANT
			T01AG->COMPRAS	 +=	T01->COMPRAS
			T01AG->CONSUMO	 +=	T01->CONSUMO
			T01AG->VENDAS	 +=	T01->VENDAS

			MsUnlock()

			dbSelectArea("T01")
			RecLock("T01")
			DbDelete()
			MsUnlock()
			dbSkip()
			Loop
		Enddo

		dbSelectArea("T01")
		Do While !Eof()
			RecLock("T01")
			DbDelete()
			MsUnlock()
			DbSkip()
		Enddo

		dbSelectArea("T01AG")
		DBGOTOP()
		While T01AG->(!Eof())
			RecLock("T01",.T.)
			T01->CODPROD	:= T01AG->CODPROD
			T01->XPRDCIV	:= T01AG->XPRDCIV
			T01->DESCPROD	:= T01AG->DESCPROD
			T01->SLDANT	 	:= T01AG->SLDANT
			T01->COMPRAS	:= T01AG->COMPRAS
			T01->CONSUMO	:= T01AG->CONSUMO
			T01->VENDAS		:= T01AG->VENDAS
			T01->UM	 		:= T01AG->UM
			T01->ENDE	 	:= T01AG->ENDE
			T01->BAIRRO	 	:= T01AG->BAIRRO
			T01->CEP	 	:= T01AG->CEP
			T01->MUN	 	:= T01AG->MUN
			T01->UF	 		:= T01AG->UF
			T01->NREDUZ	 	:= T01AG->NREDUZ
			MSUNLOCK()

			dbSelectArea("T01AG")
			dbSkip()
			Loop
		EndDo
	EndIf

	dbSelectArea("T01")
	dbSetOrder(1)
	dbGoTop()

	cPlanilha := "ANEXO I"
	cTitulo   := "MOVIMENTO GERAL (ANEXO I)"
	aCol01 := {"Produto Controlado","Saldo Trimestre Anterior","Compras / Fabricação"   ,"Somas","Consumo","Vendas, perdas ou Transferencia","Saldo que passa para Para o Trimestre Seguinte","UN" }

	oExcel:AddworkSheet(cPlanilha)
	oExcel:AddTable (cPlanilha,cTitulo)

	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[1],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[2],3,2)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[3],3,2)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[4],3,2)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[5],3,2)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[6],3,2)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[7],3,2)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[8],2,2)

	While !Eof()
		If Interrupcao(@lEnd)
			Return Nil
		Endif

		cCodPrdCiv := Posicione("SB1",1,xFilial("SB1")+T01->CODPROD,"B1_XPRDCIV")
		IF lAglutina
			cCodPrd :=  SubStr(Posicione("SX5",1,XFILIAL("SX5")+'ZZ'+cCodPrdCiv,'X5_DESCRI'),1,78)
		ELSE
			cCodPrd := SubStr(Alltrim(T01->CODPROD)+" - "+T01->DESCPROD,1,78)
		ENDIF

		cSaldoAnt := T01->SLDANT
		cCompras := T01->COMPRAS
		cSoma := T01->SLDANT+T01->COMPRAS
		cConsumo := T01->CONSUMO
		cVendas := T01->VENDAS
		cUso :=  T01->SLDANT+T01->COMPRAS-T01->VENDAS-T01->CONSUMO
		cUn := PADC(T01->UM,10)

		oExcel:AddRow(cPlanilha,cTitulo,{cCodPrd,cSaldoAnt,cCompras,cSoma,cConsumo,cVendas,cUso,cUn})

		if AScan( aPrdCiv , cCodPrdCiv) == 0
			aAdd(aPrdCiv, cCodPrdCiv)
		Endif


		lMov := .T.
		dbSelectArea("T01")
		dbSkip()
	Enddo

	If !lMov
		oExcel:AddRow(cPlanilha,cTitulo,{ "NÃO HOUVE COMPRA(OU VENDA)NO TRIMESTRE ACIMA ESPECIFICADO ","","","","","","",""})
	ELSE
		cChave := ''
		For nX := 1 to Len(aPrdCiv)
			cChave += aPrdCiv[nX]+"/"
		Next nX

		cChave := SUBSTR(cChave,1, lEN(cChave)-1)

		cAliasSX5	:= GetNextAlias()
		cQuery := " SELECT SX5.X5_DESCRI AS DESCRI,  SX5.* FROM "+RetSqlName("SX5")+ " SX5 "
		cQuery += " WHERE X5_FILIAL = '" + xFilial("SX5") + "' AND SX5.X5_TABELA = 'ZZ' AND SX5.X5_CHAVE NOT IN "+FormatIn(cChave,"/")
		cQuery += " AND SX5.D_E_L_E_T_ <> '*' "

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSX5,.T.,.T.)
		DBGOTOP()

		While !((cAliasSX5)->(Eof()))

			oExcel:AddRow(cPlanilha,cTitulo,{(cAliasSX5)->DESCRI,0,0,0,0,0,0,''})

			DBSKIP()
			LOOP

		EndDo

	EndiF

	lMov := .F.

	cPlanilha := "ANEXO II"
	cTitulo	 := "MAPA TRIMESTRAL REFERENTE A COMPRAS (ANEXO II)"
	aCol01 := {"DATA","Nº NOTA FISCAL","QUANTIDADE ","UNIDADE DE MEDIDA","CODIGO","NOME DOS PRODUTOS COMPRADOS","RAZÃO SOCIAL COMPLETA/ENDEREÇO COMPLETO CEP/FONE/CIDADE/UF DO FORNECEDOR/REMETENTE" ,"RAZÃO SOCIAL COMPLETA/ENDEREÇO COMPLETO CEP/FONE/CIDADE/UF DO TRANSPORTADOR","PRDCIV"}

	oExcel:AddworkSheet(cPlanilha)
	oExcel:AddTable (cPlanilha,cTitulo)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[1],2,4)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[2],2,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[3],3,2)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[4],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[5],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[6],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[7],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[8],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[9],1,1)

	dbSelectArea("T02")
	dbSetOrder(1)
	dbGoTop()

	While !Eof()
		If Interrupcao(@lEnd)
			Return Nil
		Endif

		cData   := (StrZero (Day(T02->EMISSAO), 2)+"/"+StrZero (Month (T02->EMISSAO), 2)+"/"+StrZero (Year (T02->EMISSAO), 4))
		cNota   := T02->NF
		cQuant  := T02->QUANT
		cUnid   := Space(3)+T02->UM
		cXPrdCiv := Posicione("SB1",1,xFilial("SB1")+T02->CODPROD,"B1_XPRDCIV")
		cDescr	:= SubStr(Posicione("SX5",1,XFILIAL("SX5")+'ZZ'+cXPrdCiv,'X5_DESCRI'),1,78)
		cForn 	 := Substr(T02->EMPRESA,1,36)+' '+Substr(T02->ENDE,1,26)+' '+T02->CEP +' '+T02->MUN+' '+T02->UF +' '+T02->FONE
		cTransp  := Substr(T02->NTRANSP,1,36)+' '+Substr(T02->ENDTRAN,1,26)+' '+T02->CEPTRAN +T02->MUNTRAN+' '+T02->ESTTRAN+ ' '+T02->TELTRAN
		cCodPrd := T02->CODPROD +" - "+ SUBSTR(Posicione("SB1",1,xFilial("SB1")+T02->CODPROD,"B1_DESC"),40)

		oExcel:AddRow(cPlanilha,cTitulo,{cData,cNota,cQuant,cUnid,cCodPrd,cDescr,cForn,cTransp,cXPrdCiv })

		lMov	 := .T.
		dbSelectArea("T02")
		dbSkip()
	Enddo

	If !lMov
		oExcel:AddRow(cPlanilha,cTitulo,{'' ,"NÃO HOUVE COMPRA(OU VENDA)NO TRIMESTRE ACIMA ESPECIFICADO",'','','','','','', '' })
	EndiF

	lMov	 := .F.
	cPlanilha := "ANEXO III"
	cTitulo	 := "MAPA TRIMESTRAL DE VENDA DE PRODUTOS CONTROLADOS (ANEXO III)"
	aCol01 :={"DATA","CLIENTE","ENDEREÇO/CEP","BAIRRO","CIDADE","UF","N.F.N","DDD/FONE","PRODUTO","DESCRICAO","UNID. MEDIDA","QUANTIDADE","PRDCIV"}

	oExcel:AddworkSheet(cPlanilha)
	oExcel:AddTable (cPlanilha,cTitulo)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[1],2,4)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[2],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[3],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[4],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[5],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[6],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[7],2,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[8],2,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[9],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[10],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[11],1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[12],3,2)
	oExcel:AddColumn(cPlanilha,cTitulo,aCol01[13],1,1)

	dbSelectArea("T03")
	dbSetOrder(1)
	dbGoTop()

	While !Eof()
		If Interrupcao(@lEnd)
			Return Nil
		Endif

		cData := (StrZero (Day(T03->EMISSAO), 2)+"/"+StrZero (Month (T03->EMISSAO), 2)+"/"+StrZero (Year (T03->EMISSAO), 4))
		cNome := T03->NREDUZ
		cEnd := Substr(T03->ENDE,1,29)+' - '+T03->CEP
		cBairro := Substr(T03->BAIRRO,1,15)
		cCidade := Substr(T03->MUN,1,15)
		cUF := T03->UF
		cNota := T03->DOC
		cTel := Substr(T03->DDD,1,3)+' '+Substr(T03->TEL,1,8)
		cXPrdCiv := Posicione("SB1",1,xFilial("SB1")+T03->CODPROD,"B1_XPRDCIV")
		cDescr	:= SubStr(Posicione("SX5",1,XFILIAL("SX5")+'ZZ'+cXPrdCiv,'X5_DESCRI'),1,78)
		cUn := PADC(T03->UM,10)
		cQuant := T03->QUANT
		cCodPrd := T03->CODPROD +" - "+T03->DESCPROD

		oExcel:AddRow(cPlanilha,cTitulo,{cData,cNome, cEnd,cbairro, cCidade, cUF, cNota, cTel, cCodPrd,cDescr, cUN, cQuant,cXPrdCiv })

		lMov	 := .T.
		dbSelectArea("T03")
		dbSkip()
	Enddo

	If !lMov
		oExcel:AddRow(cPlanilha,cTitulo,{"","NÃO HOUVE COMPRA(OU VENDA)NO TRIMESTRE ACIMA ESPECIFICADO ","","","","", "", "", "", "", "", "", ""})
	EndiF

	oExcel:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xml"
	LjMsgRun( "Gerando o arquivo, aguarde...", cCadastro, {|| oExcel:GetXMLFile( cArq ) } )
	If __CopyFile( cArq, cDirTmp + cArq )

		MsgInfo( "Arquivo " + cArq + " gerado com sucesso no diretório " + cDir )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cArq )
		oExcelApp:SetVisible(.T.)
	Else
		MsgInfo( "Arquivo não copiado para temporário do usuário." )
	Endif

	/*
	If Empty(olReport:CFILE)

	cArq := "C:\temp\PoliciaCivil.xml"
	oExcel:GetXMLFile(cArq)

	Else

	cArq := olReport:CFILE
	oExcel:GetXMLFile(cArq)
	MsgInfo("Arquivo "+cArq +" gerado com sucesso. No Diretorio Pasta C:\ ")

	Endif

	MsgInfo("Arquivo gerado com sucesso, "+cArq)

	oExcelApp:= MsExcel():New()
	oExcelApp:WorkBooks:Open(cArq)
	oExcelApp:SetVisible(.T.)
	*/
Return()