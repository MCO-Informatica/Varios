#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ M460MARK ³ Autor ³ Junior Carvalho       ³Data  ³27/08/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Valida geracao de nota apos confirmacao de estoque do      ³±±
±±³          ³ produto.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Solic.    ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ M460MARK                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Sem parƒmetros.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ponto de Entrada na geracao da nota fiscal.                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M460MARK()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva Integridade dos Dados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local	_aArea		:= GetArea()
	Local	_aArSA1		:= SA1->(GetArea())
	Local	_aArSC5		:= SC5->(GetArea())
	Local	_aArSC6		:= SC6->(GetArea())
	Local	_aArDAK		:= DAK->(GetArea())
	Local	_aArSC9		:= SC9->(GetArea())
	Local	_cQuery     := ""

	Local cMarca        := PARAMIXB[1]
	Local lInverte      := PARAMIXB[2]
	Local lRet          :=.T.
	Local lMarcado      :=.T.
	Local lFatPrev      := SuperGetMV("MV_FATFTPR",.F.,.T.) //Indica se permite faturar itens previstos (C9_TPOP = P)
	Local cRotFat       := FunName()
	Local 	nTotReg		:= 0
	Local 	bQuery		:= {|| Iif(Select("TMP1") > 0, TMP1->(dbCloseArea()), Nil) , dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TMP1",.F.,.T.), dbSelectArea("TMP1"), TMP1->(dbEval({|| nTotReg++ })), TMP1->(dbGoTop())  }
	Local _ui := 0
	Local _cAlias := GetNextAlias()
	Local _aArray := {}
	Local nX := 0
// Salva Parametros Utilizados Pela Rotina
	For _ui := 1 To 20
		&("MV_OLD" + StrZero(_ui,2)) := &("MV_PAR" + StrZero(_ui,2))
	Next _ui

// Valida se o cliente fatura com lotes unicos

	_cQuery := " SELECT CONCAT(TRIM(SC9.C9_LOTECTL), TRIM(SC9.C9_PRODUTO)) AS PROD "
	_cQuery += " FROM " + RetSqlName("SC9")+" SC9 "
	_cQuery += " WHERE SC9.C9_PEDIDO  = '"+SC9->C9_PEDIDO+"' "
	_cQuery += " AND SC9.C9_FILIAL='"+xFilial("SC9")+"'"
	_cQuery += " AND D_E_L_E_T_ <> '*' "
	_cQuery += " GROUP BY CONCAT(TRIM(SC9.C9_LOTECTL), TRIM(SC9.C9_PRODUTO)) "


	dbUseArea(.T.,"TOPCONN", TcGenQry(,,_cQuery ), _cAlias, .T., .F.)

	while !(_cAlias)->(EOF())

		Aadd(_aArray, ALLTRIM((_cAlias)->PROD) )

		(_cAlias)->(DbSkip())
	end

	DbSelectArea("SA1")
	DbSetOrder(1)
	if SA1->(dbSeek(xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA))
		If Posicione("SA1",1,xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA,"A1_LOTEUNI") == "2"
			if len(_aArray) > 1
				for nX := 2 to len(_aArray)
					if _aArray[nX] != _aArray[nX-1]
						Alert("Cliente não permite lotes diferentes para o mesmo produto! ")
						Return
					endif
				next
			endif
		Endif
	Endif

	If cRotFat == "MATA460A"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ mv_par01     // Filtra j  emitidas     - Sim/Nao             ³
		//³ mv_par02     // Estorno da Liberacao   - Posic./Marcados     ³
		//³ mv_par03     // Cons. Param. Abaixo    - Sim/Nao             ³
		//³ mv_par04     // Trazer Ped. Marc       - Sim/Nao             ³
		//³ mv_par05     // De  Pedido                                   ³
		//³ mv_par06     // Ate Pedido                                   ³
		//³ mv_par07     // De  Cliente                                  ³
		//³ mv_par08     // Ate Cliente                                  ³
		//³ mv_par09     // De  Loja                                     ³
		//³ mv_par10     // Ate Loja                                     ³
		//³ mv_par11     // De  Liberacao                                ³
		//³ mv_par12     // Ate Liberacao                                ³
		//³ mv_par13     // Mostra Itens Previstos - Sim/Não             ³
		//³ mv_par14     // De  Entrega                                  ³
		//³ mv_par15     // Ate Entrega                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Pergunte("MT461A",.F.)
		_cQuery := "SELECT SC9.R_E_C_N_O_ C9RECNO, SC9.C9_OK "
		_cQuery += " FROM " + RetSqlName("SC9")+" SC9 "
		_cQuery += " WHERE SC9.C9_FILIAL='"+xFilial("SC9")+"'"
		If ( MV_PAR01 == 1 )
			_cQuery += " And SC9.C9_BLEST<>'10'"
			_cQuery += " And SC9.C9_BLEST<>'ZZ'"
		EndIf
		If ( !lFatPrev )	//Indica se permite faturar itens Previstos (Campo C6_TPOP)
			If ( SC9->(FieldPos('C9_TPOP')) > 0 )
				//Filtra apenas itens com Tipo de Ordem de Produção Firmes (C6_TPOP = 'F' | C9_TPOP = '1')
				_cQuery += " And SC9.C9_TPOP != '2' "
			EndIf
		EndIf
		If ( MV_PAR03 == 1 )
			_cQuery += " And SC9.C9_PEDIDO  >='"+MV_PAR05+"'"
			_cQuery += " And SC9.C9_PEDIDO  <='"+MV_PAR06+"'"
			_cQuery += " And SC9.C9_CLIENTE >='"+MV_PAR07+"'"
			_cQuery += " And SC9.C9_CLIENTE <='"+MV_PAR08+"'"
			_cQuery += " And SC9.C9_LOJA    >='"+MV_PAR09+"'"
			_cQuery += " And SC9.C9_LOJA    <='"+MV_PAR10+"'"
			_cQuery += " And SC9.C9_DATALIB >='"+Dtos(MV_PAR11)+"'"
			_cQuery += " And SC9.C9_DATALIB <='"+Dtos(MV_PAR12)+"'"
			If ( SC9->(FieldPos('C9_TPOP')) > 0 )
				//Mostra itens previstos?
				If ( !Empty( MV_PAR13 ) ) .And. ( ValType(MV_PAR13) == 'N' )
					If ( MV_PAR13 == 2 ) .And. ( lFatPrev )
						_cQuery += " And SC9.C9_TPOP <> '2'"
					EndIf
				EndIf
			EndIf

			If ( !Empty( MV_PAR14 ) ) .And. ( ValType(MV_PAR14) == 'D' )
				_cQuery += " And SC9.C9_DATENT >= '" + DToS(MV_PAR14) + "'"
			EndIf

		EndIf

	ElseIf cRotFat == "MATA460B"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ mv_par01     // Filtra j  emitidas     - Sim/Nao             ³
		//³ mv_par02     // Trazer Carga Marcada   - Sim/Nao             ³
		//³ mv_par03     // Carga Inicial                                ³
		//³ mv_par04     // Carga Final                                  ³
		//³ mv_par05     // Caminhao Inicial                             ³
		//³ mv_par06     // Caminhao Final                               ³
		//³ mv_par07     // Dt de Liberacao Inicial                      ³
		//³ mv_par08     // Dt de Liberacao Final                        ³
		//³ mv_par09     // Fatura Pedidos c/Bloqueio WMS? Sim/Nao       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Pergunte("MT461B",.F.)
		_cQuery := "SELECT SC9.R_E_C_N_O_ C9RECNO, DAK.R_E_C_N_O_ DAKRECNO, DAK.DAK_OK"
		_cQuery += " FROM "       + RetSqlName("SC9")+" SC9 "
		_cQuery += " INNER JOIN " + RetSqlName("DAK")+" DAK "
		_cQuery += "  ON DAK.DAK_FILIAL = '"+xFilial("DAK")+"'"
		_cQuery += " AND DAK.DAK_COD   >= '"+MV_PAR03+"'"
		_cQuery += " AND DAK.DAK_COD   <= '"+MV_PAR04+"'"
		_cQuery += " AND DAK.DAK_CAMINH>= '"+MV_PAR05+"'"
		_cQuery += " AND DAK.DAK_CAMINH<= '"+MV_PAR06+"'"
		_cQuery += " AND DAK.DAK_COD    = SC9.C9_CARGA"
		_cQuery += " AND DAK.DAK_SEQCAR = SC9.C9_SEQCAR"
		_cQuery += " AND DAK_FEZNF <> '1' "
		_cQuery += " AND DAK.D_E_L_E_T_ <> '*' "
	/*
		If lInverte
		_cQuery += " AND DAK.DAK_OK<>'"+cMarca+"'"
		Else
		_cQuery += " AND DAK.DAK_OK='"+cMarca+"'"
		EndIf
	*/

		_cQuery += " WHERE SC9.C9_FILIAL  = '"+xFilial("SC9")+"'"
		_cQuery += " AND SC9.C9_DATALIB >= '"+Dtos(MV_PAR07)+"'"
		_cQuery += " AND SC9.C9_DATALIB <= '"+Dtos(MV_PAR08)+"'"


	EndIf
	_cQuery += " AND SC9.C9_NFISCAL  IS NOT NULL  "
	If lInverte
		_cQuery += " AND SC9.C9_OK<>'"+cMarca+"'"
	Else
		_cQuery += " AND SC9.C9_OK='"+cMarca+"'"
	EndIf
	_cQuery +=	" AND SC9.D_E_L_E_T_  <> '*' "

	_cQuery := ChangeQuery(_cQuery)

	Eval(bQuery)

// Ajusta Campos Da View
	TcSetField("TMP1","C9_QTDLIB"	,"N",TamSX3("C9_QTDLIB")[1]	,TamSX3("C9_QTDLIB")[2]	)
	TcSetField("TMP1","C9_PRCVEN"	,"N",TamSX3("C9_PRCVEN")[1]	,TamSX3("C9_PRCVEN")[2]	)

	If Select("TMP1") > 0 .And. (nTotReg > 0 )

		DbSelectArea("TMP1")
		TMP1->(DbGoTop())
		While !Eof()
			lMarcado := .T.
		/*
			If cRotFat == "MATA460A"
				If !((TMP1->C9_OK <> cMarca .And. lInverte) .Or. (TMP1->C9_OK == cMarca .And. !lInverte))
					lMarcado := .F.
				EndIf
			ElseIf cRotFat == "MATA460B"
			DAK->(dbGoTo(TMP1->DAKRECNO))
				If !((DAK->DAK_OK <> cMarca .And. lInverte) .Or. (DAK->DAK_OK == cMarca .And. !lInverte))
				lMarcado := .F.
				EndIf
			EndIf
		*/
			DbSelectArea("SC9")
			SC9->(dbGoTo(TMP1->C9RECNO))

			If (lInverte) // "CHECK ALL" OPTION SELECTED
				If SC9->(IsMark("C9_OK"))
					lMarcado := .F.
				EndIf
			Else // "CHECK ALL" OPTION NOT SELECTED
				If !(SC9->(IsMark("C9_OK")))
					lMarcado := .F.
				EndIf
			EndIf

			if lMarcado

				DbSelectArea("SC5")
				DbSetOrder(1)
				SC5->(dbSeek(xFilial()+SC9->C9_PEDIDO))

				DbSelectArea("SC6")
				DbSetOrder(1)
				SC6->(dbSeek(xFilial()+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))

				AJUSTPV( )

			EndIf
			DbSelectArea("TMP1")
			TMP1->(DbSkip())
		EndDo
	EndIf

// Devolve Parametros Utilizados Pela Rotina
	For _ui := 1 To 20
		&("MV_PAR" + StrZero(_ui,2)) := &("MV_OLD" + StrZero(_ui,2))
	Next _ui

// Fecha Arquivo Temporario
	If Select("TMP1") > 0
		TMP1->(DbCloseArea())
	EndIf

	RestArea(_aArSA1)
	RestArea(_aArSC5)
	RestArea(_aArSC6)
	RestArea(_aArDAK)
	RestArea(_aArSC9)
	RestArea(_aArea)
Return(lRet)


Static Function AJUSTPV()

	If SC6->C6_XMOEDA > 1
		IF SC6->C6_XMEDIO != 'S' .AND. SC5->C5_CONDPAG != '000'
			nTaxa := 0

			if SC5->C5_TIPOCLI == 'X' .and. cEmpAnt == '01'
				nTaxa       := u_ptaxCompra(alltrim(str(SC6->C6_XMOEDA,1)))
				nTaxaExp    := u_ptaxCompra(alltrim(str(SC5->C5_XMOEDA,1)))
				reclock("SC5", .F.)
				SC5->C5_XTAXA := nTaxaExp
				SC5->C5_FRETE  := SC5->C5_XFRETE * nTaxaExp
				SC5->C5_SEGURO := SC5->C5_XSEGURO * nTaxaExp
				SC5->(msUnlock())

			else
				cCampo := 'M2_MOEDA' + alltrim(str(SC6->C6_XMOEDA,1))
				//msgAlert("Variavel da Moeda " + cCampo,"ATENÇÃO")
				DbSelectArea("SM2")
				DbSetOrder(1)
				If DbSeek(dDataBase)
					nTaxa := &cCampo
				endif
			endif

			if nTaxa > 0

				nAliqIMP := SC6->C6_XICMEST + SC6->C6_XPISCOF

				IF(nAliqIMP > 0)
					nAliqIMP := ( nAliqImp / 100 )
				Endif

				if SC6->C6_XVLRINF > 0
					nPreco :=  SC6->C6_XVLRINF
				else
					nPreco := MaTabPrVen(SC5->C5_TABELA,SC6->C6_PRODUTO,SC6->C6_QTDVEN,SC5->C5_CLIENTE, SC5->C5_LOJACLI, SC6->C6_XMOEDA ,dDataBase)
				endif

				nPrc 	:= Round( (nPreco / (1- nAliqImp)) * nTaxa, TamSx3("C6_PRCVEN")[2] )
				nVlrTt	:= A410Arred( nPrc * SC6->C6_QTDVEN ,"C6_VALOR")


				cAltera := 'Taxa de: ' + alltrim(str(SC6->C6_XTAXA)) + ' Para: ' + alltrim( STR(nTaxa ) )
				cAltera += ' - Preço Unitario ' + alltrim( STR(nPrc))

				Reclock("SC6")
				SC6->C6_XTAXA  := nTaxa
				SC6->C6_PRCVEN := nPrc
				SC6->C6_PRUNIT := nPrc
				SC6->C6_VALOR  := nVlrTt
				MsUnlock()

				//msgAlert("Alterei o Pedido SC6 " + Str(SC6->C6_PRCVEN),"ATENÇÃO")
				//	cAltera += 'Liberado estava ' + alltrim(str(SC9->C9_PRCVEN)) + CRLF

				RecLock("SC9")
				SC9->C9_PRCVEN := nPrc
				MsUnlock()
				//MsgAlert("Alterei o Pedido SC9 " + Str(SC9->C9_PRCVEN),"ATENÇÃO")
				U_GrvLogPd(SC6->C6_NUM,SC6->C6_CLI,SC6->C6_LOJA,'Geração NF','Atualizou Taxa Moeda - P.E. M460MARK',SC6->C6_ITEM,cAltera)
			endif

		Endif
	Endif

Return()
