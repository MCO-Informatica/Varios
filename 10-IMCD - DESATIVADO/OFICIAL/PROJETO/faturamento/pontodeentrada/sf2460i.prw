#INCLUDE "TOPCONN.CH"
#include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SF2460I  ³ Autor ³ Giane - ADV Brasil    ³ Data ³ 27/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de entrada executado após a inclusão da NF de saída. ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Específico MAKENI  - faturamento                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ GAP  ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Giane       ³27/11/09³      ³ Gravar o log de pedido faturado          ³±±
±±³Fabricio    ³17/03/11³ 167  ³ Operação triangular                      ³±±
±±³Daniel      ³01/11/11³      ³ Data de entrega                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2460I()
	Local cChave := SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM

	Local aCabP     := {}
	Local aItensP   := {}
	Local aCposC5   := {}
	Local aCposC6   := {}
	Local aPvsLib   := {}
	Local cTitulo   := "Remessa conta e ordem (SF2460I)"
	Local cNumPed   := ""
	Local cCampos   := ""
	Local cSql      := ""
	Local cCondCO   := ""
	Local cBlqC9    := ""
	Local cF2_Doc   := ""
	Local cF2_Serie := ""
	Local cAux      := ""
	Local lPrdContr := .F.
	Local lQtdNf := .F.
	local lForDanfe := .F.
	local cForDanfe := superGetMv("ES_FORDANF", .F., "")
	local cEmailFor := ""
	local aAreaSA2  := {}
	Local nVolume := 0
	Local cEsp := ""
//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "SF2460I" , __cUserID )

	U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Pedido Faturado')

	RecLock("SF2",.F.)
	SF2->F2_NOMCLI := POSICIONE("SA1",1,XFILIAL("SA1")+F2_CLIENTE+F2_LOJA,"A1_NOME")
	SF2->F2_XVENDOR := SC5->C5_XVENDOR
	SF2->F2_XGRPVEN := SC5->C5_GRPVEN
	msUnlock()


//Alterado em 18-01-18
//Atualiza os a taxa e moeda no item da nota com base no pedido de venda

	DbSelectArea("SD2")
	DbSetOrder(3)
	If DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)

		While 	SD2->(!EOF())	.AND.;
				SD2->D2_DOC 	== SF2->F2_DOC		.AND.;
				SD2->D2_SERIE	== SF2->F2_SERIE	.AND.;
				SD2->D2_CLIENTE == SF2->F2_CLIENTE	.AND.;
				SD2->D2_LOJA 	== SF2->F2_LOJA

			If SD2->D2_QUANT > 0
				lQtdNf := .T.
			EndIf

			DbSelectArea("SC6")
			DbSetOrder(1)
			If DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
				RecLock("SD2",.F.)
				SD2->D2_XTAXA	:= SC6->C6_XTAXA
				SD2->D2_XMOEDA	:= SC6->C6_XMOEDA
				SD2->(MsUnlock())
			Endif
			SB1->(DbSeek(xFilial("SB1") + SD2->D2_COD, .F.))

			IF cEmpAnt == '02'
				If SB1->B1_MINEXEC == 'S' .OR. SB1->B1_POLCIV == 'S' .OR. SB1->B1_POLFED == 'S'
					lPrdContr :=.T.
				Endif
			elseif  cEmpAnt == '04'
				nVolume += (SD2->D2_QUANT / SB1->B1_QE)
				cEsp := "VOLUME(S)"
			Endif

			RecLock("SF2",.F.)
			SF2->F2_VOLUME1 := nVolume
			SF2->F2_ESPECI1 := cEsp
			msUnlock()

			if SF2->(F2_CLIENTE+F2_LOJA) $ cForDanfe .and. alltrim(SD2->D2_CF) == '5915'

				aAreaSA2 := SA2->(getArea())
				dbSelectArea("SA2")
				SA2->(dbSetOrder(1))
				if SA2->(dbSeek(xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA) )) .and. !empty(SA2->A2_EMAIL)
					lForDanfe  := .T.
					cEmailFor  :=  SA2->A2_EMAIL
				endif

				restArea(aAreaSA2)
				aSize(aAreaSA2,0)
			endif
			SD2->(DbSkip())
		End
	Endif

	IF 	(lPrdContr .AND. lQtdNf) .or. (lForDanfe .and. lQtdNf)
		U_GravaZF1(SF2->F2_DOC,SF2->F2_SERIE,'S','I',SF2->F2_CLIENTE, SF2->F2_LOJA,iif((lForDanfe .and. lQtdNf) , cEmailFor, ""))
	ENDIF


	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSeek(cChave)
	do While !Eof() .and. SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM) == cChave
		RecLock("SE1",.F.)
		SE1->E1_MUN := Posicione("SA1",1,XFILIAL("SA1") +E1_CLIENTE+E1_LOJA,"A1_MUN")
		SE1->E1_EST := Posicione("SA1",1,XFILIAL("SA1") +E1_CLIENTE+E1_LOJA,"A1_EST")
		SE1->E1_XVENDOR := SC5->C5_XVENDOR
		msUnlock()
		SE1->(dbSkip())
	Enddo

	DbSelectArea("SF2")

// GAP 167
	cCondCO := GetMv("MV_MKCPCO")
	If Empty(cCondCO)
		MsgAlert("Parametro MV_MKCPCO não existe ou não preenchido. NF de remessa conta e ordem não será gerada.", cTitulo)
		Return
	EndIf

	aAdd(aCposC5, "C5_FILIAL")
//	aAdd(aCposC5, "C5_XENTREG")
	aAdd(aCposC5, "C5_TIPOCLI")
	aAdd(aCposC5, "C5_TRANSP")
	aAdd(aCposC5, "C5_VEND1")
	aAdd(aCposC5, "C5_EMISSAO")
	aAdd(aCposC5, "C5_NATUREZ")
	aAdd(aCposC5, "C5_GRPVEN")
	cCampos := aCposC5[1]
	aEval(aCposC5, {|xItem| cCampos += ", " + xItem}, 2)

	aAdd(aCposC6, "C6_FILIAL")
	aAdd(aCposC6, "C6_PRODUTO")
	aAdd(aCposC6, "C6_XMOEDA")
	aAdd(aCposC6, "C6_PRCVEN")
	aAdd(aCposC6, "C6_EMBRET")
	aEval(aCposC6, {|xItem| cCampos += ", " + xItem}, 1)

	cF2_Doc   := SF2->F2_DOC
	cF2_Serie := SF2->F2_SERIE

	cSql := "SELECT "
	cSql += "  C5_CLIENTE, C5_LOJACLI, C5_CENT, C5_LENT, C5_NOMECLI, F4_TESCO, D2_QUANT, " + cCampos + " "
	cSql += "FROM "
	cSql += "  " + RetSqlName("SD2") + " SD2 JOIN " + RetSqlName("SC6") + " SC6 ON "
	cSql += "    SD2.D_E_L_E_T_ = ' '  AND "
	cSql += "    SC6.D_E_L_E_T_ = ' '  AND "
	cSql += "    SD2.D2_FILIAL  = '" + xFilial("SD2") + "' AND "
	cSql += "    SC6.C6_FILIAL  = '" + xFilial("SC6") + "' AND "
	cSql += "    SD2.D2_PEDIDO  = SC6.C6_NUM  AND "
	cSql += "    SD2.D2_ITEMPV  = SC6.C6_ITEM "
	cSql += "  JOIN " + RetSqlName("SC5") + " SC5 ON "
	cSql += "    SC5.D_E_L_E_T_ = ' '  AND "
	cSql += "    SC5.C5_FILIAL  = '" + xFilial("SC5") + "' AND "
	cSql += "    SC5.C5_NUM     = SC6.C6_NUM "
	cSql += "  JOIN " + RetSqlName("SF4") + " SF4 ON "
	cSql += "    SF4.D_E_L_E_T_ = ' '  AND "
	cSql += "    SF4.F4_FILIAL  = '" + xFilial("SF4") + "' AND "
	cSql += "    SF4.F4_CODIGO  = SD2.D2_TES "
	cSql += "WHERE "
	cSql += "  SD2.D2_DOC = '" + SF2->F2_DOC   + "' "
	cSql += "  AND SD2.D2_SERIE =  '" + SF2->F2_SERIE + "' "
	cSql += "  AND SD2.D2_TIPO  =  'N' "
	cSql += "  AND SF4.F4_TESCO <> '" + Space(Len(SF4->F4_TESCO)) + "'"
	TcQuery cSql New Alias "TMP1"

	If !TMP1->(Eof()) .And. !TMP1->(Bof())
		QSetField("TMP1")
		// Cabecalho do pedido
		aCabP   := {}
		cNumPed := CriaVar("C5_NUM")
		aAdd(aCabP, {"C5_NUM"    , cNumPed         , Nil})   // Numero do pedido
		aAdd(aCabP, {"C5_TIPO"   , "N"             , Nil})   // Tipo de pedido
		aAdd(aCabP, {"C5_CLIENTE", TMP1->C5_CENT   , Nil})   // Codigo do cliente
		aAdd(aCabP, {"C5_LOJACLI", TMP1->C5_LENT   , Nil})   // Loja do cliente
		aAdd(aCabP, {"C5_NOMECLI", TMP1->C5_NOMECLI  , Nil})   // Loja do cliente
		aAdd(aCabP, {"C5_CENT"   , TMP1->C5_CLIENTE, Nil})   // Codigo do cliente
		aAdd(aCabP, {"C5_LENT"   , TMP1->C5_LOJACLI, Nil})   // Loja do cliente
		aAdd(aCabP, {"C5_CONDPAG", cCondCO         , Nil})   // Codigo da condicao de pagamanto
		aAdd(aCabP, {"C5_MENNOTA", "REMESSA DE CONTA ORDEM REF NF " + SF2->F2_DOC + " DE " + DtoC(SF2->F2_EMISSAO), Nil})
		aAdd(aCabP, {"C5_XENTREG", dDataBase	   , Nil})   // Data de entrega - alterado por Daniel em 01/11/11 a pedido de Daisy
		aAdd(aCabP, {"C5_XVENDOR", "N"   , Nil})
		aEval(aCposC5, {|xItem| aAdd(aCabP, {xItem, &("TMP1->" + xItem), Nil})})

		// Itens do pedido
		aItensP  := {}
		cItemPed := Soma1(Replicate("0", TamSX3("C6_ITEM")[1]), TamSX3("C6_ITEM")[1])
		While !TMP1->(Eof())
			IncProc()
			aAdd(aItensP, {})
			aAdd(aItensP[Len(aItensP)], {"C6_ITEM"   , cItemPed         , Nil})
			aAdd(aItensP[Len(aItensP)], {"C6_TES"    , TMP1->F4_TESCO   , Nil})
			aAdd(aItensP[Len(aItensP)], {"C6_QTDLIB" , TMP1->D2_QUANT   , Nil})
			aAdd(aItensP[Len(aItensP)], {"C6_QTDVEN" , TMP1->D2_QUANT   , Nil})
			aEval(aCposC6, {|xItem| aAdd(aItensP[Len(aItensP)], {xItem, &("TMP1->" + xItem), Nil})})
			cItemPed := Soma1(cItemPed, TamSX3("C6_ITEM")[1])
			TMP1->(DbSkip())
		End
		TMP1->(DbCloseArea())
		aOrdAuto(aCabP)
		aOrdAuto(aItensP)

		lMsHelpAuto := .T.
		lMsErroAuto := .F.
		MsExecAuto({|x,y,z| Mata410(x,y,z)}, aCabP, aItensP, 3)  // Inclusao do pedido de venda
		If lMsErroAuto
			MostraErro()
			HS_MsgInf("Houve um problema na geração do pedido da NF " + SF2->F2_DOC + " - " + AllTrim(SF2->F2_SERIE) + ". A operação será interrompida.", "Atenção!!!", cTitulo)
			DisarmTransaction()
			Final()
		Else
			cSql := "SELECT "
			cSql += "  SC9.C9_PEDIDO,  SC9.C9_ITEM,    SC9.C9_SEQUEN,  SC9.C9_QTDLIB,  SC9.C9_PRCVEN,  SC9.C9_PRODUTO, SC9.C9_LOCAL, SF4.F4_ISS, "
			cSql += "  SC9.C9_BLEST, SC9.C9_BLCRED, SC9.R_E_C_N_O_ RECNOC9, SC5.R_E_C_N_O_ RECNOC5, SC6.R_E_C_N_O_ RECNOC6, SE4.R_E_C_N_O_ RECNOE4, "
			cSql += "  SB1.R_E_C_N_O_ RECNOB1, SB2.R_E_C_N_O_ RECNOB2, SF4.R_E_C_N_O_ RECNOF4 "
			cSql += "FROM "
			cSql += "  " + RetSqlName("SC6") + " SC6 JOIN " + RetSqlName("SC5") + " SC5 ON "
			cSql += "    SC6.D_E_L_E_T_ = ' '  AND "
			cSql += "    SC6.C6_FILIAL  = '" + xFilial("SC6") + "' AND "
			cSql += "    SC5.D_E_L_E_T_ = ' '  AND "
			cSql += "    SC5.C5_FILIAL  = '" + xFilial("SC5") + "' AND "
			cSql += "    SC5.C5_NUM     = SC6.C6_NUM "
			cSql += "  JOIN " + RetSqlName("SC9") + " SC9 ON "
			cSql += "    SC9.D_E_L_E_T_ = ' '  AND "
			cSql += "    SC9.C9_FILIAL  = '" + xFilial("SC9") + "' AND "
			cSql += "    SC9.C9_PEDIDO  = SC6.C6_NUM  AND "
			cSql += "    SC9.C9_ITEM    = SC6.C6_ITEM "
			cSql += "  JOIN " + RetSqlName("SF4") + " SF4 ON "
			cSql += "    SF4.D_E_L_E_T_ = ' '  AND "
			cSql += "    SF4.F4_FILIAL  = '" + xFilial("SF4") + "' AND "
			cSql += "    SF4.F4_CODIGO  = SC6.C6_TES "
			cSql += "  JOIN " + RetSqlName("SE4") + " SE4 ON "
			cSql += "    SE4.D_E_L_E_T_ = ' '  AND "
			cSql += "    SE4.E4_FILIAL  = '" + xFilial("SE4") + "' AND "
			cSql += "    SE4.E4_CODIGO  = SC5.C5_CONDPAG "
			cSql += "  JOIN " + RetSqlName("SB1") + " SB1 ON "
			cSql += "    SB1.D_E_L_E_T_ = ' '  AND "
			cSql += "    SB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND "
			cSql += "    SB1.B1_COD     = SC6.C6_PRODUTO "
			cSql += "  JOIN " + RetSqlName("SB2") + " SB2 ON "
			cSql += "    SB2.D_E_L_E_T_ = ' '  AND "
			cSql += "    SB2.B2_FILIAL  = '" + xFilial("SB2") + "' AND "
			cSql += "    SB2.B2_COD     = SC6.C6_PRODUTO AND "
			cSql += "    SB2.B2_LOCAL   = SC6.C6_LOCAL "
			cSql += "WHERE"
			cSql += "  SC5.C5_NUM = '" + cNumPed + "'"
			cSql += "  AND SC9.C9_BLEST  <> '10' "
			cSql += "  AND SC9.C9_BLCRED <> '10'"
			TcQuery cSql New Alias "TMP2"

			While !TMP2->(Eof())
				cBlqC9 := Iif(!Empty(TMP2->C9_BLCRED), "credito", cBlqC9)
				cBlqC9 += Iif(!Empty(cBlqC9), "/", "") + Iif(!Empty(TMP2->C9_BLEST), "estoque", cBlqC9)
				TMP2->(DbSkip())
			End

			If !Empty(cBlqC9)
				cAux := "O pedido de remessa por conta e ordem  foi gerado com bloqueio de " + cBlqC9
				cAux += ", verifique o TES cadastrado para geração do pedido de conta e ordem. A operação será interrompida."
				HS_MsgInf(cAux, "Atenção!!!", cTitulo)
				DisarmTransaction()
				Final()
			Else
				TMP2->(DbGoTop())
				QSetField("TMP2")
				aPvsLib := {}
				While !TMP2->(Eof())
					aAdd(aPvsLib, {})
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->C9_PEDIDO)
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->C9_ITEM)
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->C9_SEQUEN)
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->C9_QTDLIB)
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->C9_PRCVEN)
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->C9_PRODUTO)
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->F4_ISS == "S")
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->RECNOC9)
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->RECNOC5)
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->RECNOC6)
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->RECNOE4)
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->RECNOB1)
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->RECNOB2)
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->RECNOF4)
					aAdd(aPvsLib[Len(aPvsLib)], TMP2->C9_LOCAL)
					TMP2->(DbSkip())
				End
				TMP2->(DbCloseArea())
				cNumNFs := MaPvlNfs(aPvsLib, SF2->F2_SERIE, .F., .F., .T., .T., .F., 0, 0, .T., .F.)
				If Empty(cNumNFs)
					HS_MsgInf("Ocorreu um erro na geração da NF de remessa por conta e ordem. A operação será cancelada.", "Atenção!!!", cTitulo)
					DisarmTransaction()
					Final()
				Else
					cSql := "UPDATE " + RetSqlName("SF2") + " "
					cSql += "SET
					cSql += "  F2_NFCO = '" + cNumNFs + "', F2_SERIECO = '" + cF2_Serie + "' "
					cSql += "WHERE "
					cSql += "  F2_FILIAL = '" + xFilial("SF2") + "' AND F2_DOC = '" + cF2_Doc + "' AND F2_SERIE = '" + cF2_Serie + "'"
					If TcSqlExec(cSql) < 0
						HS_MsgInf("Ocorreu um erro ao gravar o número de NF conta e ordem na NF de venda. A operação será cancelada." + Chr(10) + Chr(13) + TcSqlError(), "Atenção!!!", cTitulo)
						DisarmTransaction()
						Final()
					Else
						MsgInfo("Gerado NF de remessa por conta e ordem número " + cNumNFs + " serie " + SF2->F2_SERIE, cTitulo)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	If Select("TMP1") > 0
		TMP1->(DbCloseArea())
	EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³QSetField ºAutor  ³Fabricio E. da Costaº Data ³  14/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta o tipo de dado dos campos de um recordset, gerado    º±±
±±º          ³pelo TcQuery ou DbUseArea.                                  º±±
±±º          ³                                                            º±±
±±º          ³Parametros:                                                 º±±
±±º          ³  cAlias...: Nome do alias (recordset) a ser ajustado.      º±±
±±º          ³                                                            º±±
±±º          ³Retorno:                                                    º±±
±±º          ³   Nil                                                      º±±
±±º          ³                                                            º±±
±±º          ³Observacao:                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GERAL                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QSetField(cAlias)
	Local aStruct := {}
	Local aAuxCpo := {}
	Local i

	aStruct := (cAlias)->(DbStruct())
	For i := 1 To Len(aStruct)
		aAuxCpo := TamSx3(aStruct[i,1])
		If Len(aAuxCpo) > 0 .And. aAuxCpo[3] $ "D/N"
			TCSetField(cAlias, aStruct[i,1], aAuxCpo[3], aAuxCpo[1], aAuxCpo[2])
		EndIf
	Next
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³aOrdAuto  ºAutor  ³Fabricio E. da Costaº Data ³  14/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ordena os campos, de um array de execauto, de acordo com o  º±±
±±º          ³SX3.                                                        º±±
±±º          ³                                                            º±±
±±º          ³Parametros:                                                 º±±
±±º          ³  aAuto....: Array a ser ordenado.                          º±±
±±º          ³                                                            º±±
±±º          ³Retorno:                                                    º±±
±±º          ³   Nil                                                      º±±
±±º          ³                                                            º±±
±±º          ³Observacao:                                                 º±±
±±º          ³ Não é necessário retornar o array ordenado, pois todo      º±±
±±º          ³ parametro tipo array vem por referencia.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GERAL                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function aOrdAuto(aAuto)
	Local aOrdX3   := {}
	Local cTabAuto := ""
	Local cCpoAux  := ""
	Local nTpAuto  := 0
	Local aAreaX3  := SX3->(GetArea())

	If ValType(aAuto) == "A" .And. Len(aAuto) > 0 .And. ValType(aAuto[1]) == "A"
		nTpAuto := Iif(ValType(aAuto[1,1]) == "C", 1, nTpAuto)
		nTpAuto := Iif(ValType(aAuto[1,1]) == "A", 2, nTpAuto)
	EndIf
	If nTpAuto > 0
		cCpoAux  := Iif(nTpAuto == 1, aAuto[1,1], aAuto[1,1,1])
		cTabAuto := Left(cCpoAux, At("_", cCpoAux) - 1)
		cTabAuto := Iif(Len(cTabAuto) == 2, "S", "") + cTabAuto

		SX3->(DbSetOrder(1))
		SX3->(DbSeek(cTabAuto))
		SX3->(DbEval({|| aAdd(aOrdX3, X3_CAMPO)},, {|| X3_ARQUIVO == cTabAuto}))
		If nTpAuto == 1
			aSort(aAuto,,, {|x,y| aScan(aOrdX3, &("{|xItem| AllTrim(xItem) == '" + AllTrim(x[1]) + "'}")) < aScan(aOrdX3, &("{|xItem| AllTrim(xItem) == '" + AllTrim(y[1]) + "'}"))})
		Else
			aEval(aAuto, {|xItem, nIndex| aSort(xItem,,, {|x,y| aScan(aOrdX3, &("{|xItem| AllTrim(xItem) == '" + AllTrim(x[1]) + "'}")) < aScan(aOrdX3, &("{|xItem| AllTrim(xItem) == '" + AllTrim(y[1]) + "'}"))})})
		EndIf
	Else
		UserException("Estrutura de array não reconhecida com ExecAuto.")
	EndIf
	SX3->(RestArea(aAreaX3))

Return
