#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ RFAT061  ∫ Autor ≥ Eneovaldo Roveri Jr∫ Data ≥  21/12/09   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Relatorio de Faturamento por Grupo de Vendas               ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function RFAT061()
Local cPerg := 'RFAT061'
Local aArea := GetArea()

PRIVATE cAdmVnds := GetMv("MV_XUSRCUS")
Private cSegResp  := ""
/*
//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RFAT061" , __cUserID )

PRIVATE cGrpAcesso:=""
Private lGerente  := .f.
Private lVendedor := .f.
*/

if .not. Pergunte( cPerg, .T.)
	return
endif
/*
//=========== Regra de Confidencialidade =====================================
aConf := U_ChkConfig(__cUserId)
cGrpAcesso:= aConf[1]

If Empty(cGrpAcesso)
MsgStop("USUARIO SEM PERMISSAO - REGRA DE CONFIDENCIALIDADE","AtenÁ„o!")
Return
Endif

lGerente := aConf[2]
cSegResp := aConf[3]
lVendedor := aConf[4]
*/
//cExprGer := U_fSqlGer( cMVpar11, cMVpar04, cMVpar05 ) //monta o filtro para o gerente, verificando preenchimento dos parametros
//============================================================================

If MV_PAR17 == 1
	MsgRun("Processando RelatÛrio de Margem em excel, aguarde...","",{|| U_ImpR061() })
Else
	MsgRun("Processando RelatÛrio de Margem em excel, aguarde...","",{|| ImpR061G() })
Endif

If Select("XSD2") > 0
	XSD2->( dbCloseArea() )
EndIf


RestArea(aArea)

Return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ IMPR061  ∫ Autor ≥ Eneovaldo Roveri Jr∫ Data ≥  21/12/09   ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function IMPR061()
Local cAlias, cQuery
Local aCabec := {}
Local aDados := {}
Local dEmissao, nVlrImp, nPerImp, nLiquido
Local nCstTot , nPerBrut, nCusto,  nVlBrut
Local nPrcSeg, nMrgSeg
Local cObs := ""
Local _lSeg := .f.
Local nIcmOri := 0
Local nPeso, nTotFrete, nUniFrete, nFrete, nTotPeso

DbSelectArea("SB1")
DbSetOrder(1)

cAlias:= "XSD2"

cQuery := "SELECT DISTINCT "
cQuery += " SC5.C5_GRPVEN, SA3.A3_NREDUZ, SD2.D2_DOC, SD2.D2_ITEM, SD2.D2_EMISSAO, SD2.D2_CLIENTE, SA1.A1_NREDUZ, "
cQuery += " SD2.D2_COD, SD2.D2_FILIAL, SB1.B1_DESC, SD2.D2_QUANT, SD2.D2_VALBRUT , SD2.D2_IPI, SD2.D2_PICM, SD2.D2_ALQIMP5, "
cQuery += " SD2.D2_ALQIMP6, SA1.A1_SATIV1, SD2.D2_VALIPI, SD2.D2_VALICM, SD2.D2_VALIMP5, SD2.D2_VALIMP6, SD2.D2_PRCVEN, "
cQuery += " SD2.D2_LOJA, SD2.D2_NFORI, SD2.D2_SERIORI, SB1.B1_SEGMENT, SA3.A3_NOME, SB1.B1_CUSTD, SD2.D2_PEDIDO, "
cQuery += " SD2.D2_ITEMPV, SC6.C6_COMIS1, SD2.D2_CUSTO1, SD2.D2_EST, SC5.C5_TPFRETE, SC5.C5_XPEDCLI,TRIM(ZA0_NAME) AS PRINCIPAL, "
cQuery += " SD1.D1_DOC , SD1.D1_SERIE , SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_TOTAL,  SA2.A2_NREDUZ, 
cQuery += " SD2.D2_CF,  XORI.D2_PICM AS PICMORI, XORI.D2_CUSTO1 AS CUSTOORI, XORI.D2_VALICM AS VICMORI, "
cQuery += " XORI.D2_PEDIDO AS XPEDIDO, XORI.D2_ITEMPV XITEMPV, XORI.D2_QUANT AS XQUANT, SD2.D2_XNFORI,SD2.D2_XSERORI"

cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
cQuery += " JOIN " + RetSqlName("SB1") + " SB1 ON "
cQuery += "   SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
cQuery += "   SD2.D2_COD = SB1.B1_COD AND "
cQuery += "   SB1.D_E_L_E_T_ = ' ' "
cQuery += " JOIN " + RetSqlName("SA1") + " SA1 ON "
cQuery += "   SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += "   SD2.D2_CLIENTE = SA1.A1_COD AND "
cQuery += "   SD2.D2_LOJA = SA1.A1_LOJA AND "
cQuery += "   SA1.D_E_L_E_T_ = ' ' "
//cQuery += "  JOIN " + RetSqlName("ACY") + " ACY ON "
//cQuery += "    ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
//cQuery += "    ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
//cQuery += "    ACY.D_E_L_E_T_ = ' ' "
cQuery += " JOIN " + RetSqlName("SF2") + " SF2 ON "
cQuery += "   SF2.F2_FILIAL = SD2.D2_FILIAL AND "
cQuery += "   SD2.D2_DOC = SF2.F2_DOC AND "
cQuery += "   SD2.D2_SERIE = SF2.F2_SERIE AND "
cQuery += "   SF2.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN " + RetSqlName("SA3") + " SA3 ON "
cQuery += "   SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND "
cQuery += "   SF2.F2_VEND1 = SA3.A3_COD AND "
cQuery += "   SA3.D_E_L_E_T_ = ' ' "
cQuery += " JOIN " + RetSqlName("SF4") + " SF4 ON "
cQuery += "   SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND "
cQuery += "   SD2.D2_TES = SF4.F4_CODIGO AND "
cQuery += "   SF4.D_E_L_E_T_ = ' ' "
cQuery += "  LEFT JOIN " + RetSqlName("SC6") + " SC6 ON "
cQuery += "    SC6.C6_FILIAL = SD2.D2_FILIAL AND "
cQuery += "    SC6.C6_NUM = SD2.D2_PEDIDO AND "
cQuery += "    SC6.C6_ITEM = SD2.D2_ITEMPV AND "
cQuery += "    SC6.C6_PRODUTO = SD2.D2_COD AND "
cQuery += "    SC6.C6_NOTA = SD2.D2_DOC AND "
cQuery += "    SC6.D_E_L_E_T_ = ' ' "
cQuery += "  LEFT JOIN " + RetSqlName("SD1") + " SD1 ON "
cQuery += "    SD1.D1_FILIAL = SD2.D2_FILIAL AND "
cQuery += "    SD1.D1_NFRSAI = SD2.D2_DOC AND "
cQuery += "    SD1.D1_SERSAI = SD2.D2_SERIE AND "
cQuery += "    SD1.D_E_L_E_T_ = ' ' "
cQuery += "  LEFT JOIN " + RetSqlName("SA2") + " SA2 ON "
cQuery += "    SA2.A2_FILIAL = '"+xFilial("SA2")+"' AND "
cQuery += "    SA2.A2_COD = SD1.D1_FORNECE AND "
cQuery += "    SA2.A2_LOJA = SD1.D1_LOJA AND "
cQuery += "    SA2.D_E_L_E_T_ = ' ' "														 								 
cQuery += "  JOIN " + RetSqlName("SC5") + " SC5 ON "
cQuery += "    SD2.D2_FILIAL = SC5.C5_FILIAL AND "
cQuery += "    SD2.D2_PEDIDO = SC5.C5_NUM AND "
cQuery += "    SC5.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN "+RetSQLName('ZA0')+" ZA0 "
cQuery += " ON  ZA0_CODPRI = B1_X_PRINC AND ZA0.D_E_L_E_T_ <> '*' " 


// JOIN COM O PROPRIO SD2 LOCALIZANDO DADOS DA NOTA DE REMESSA LIGADA A NF VENDA CONSIGNACAO
cQuery += "  LEFT JOIN ( SELECT DISTINCT D2_FILIAL, D2_DOC, D2_SERIE, D2_COD, SUM( D2_CUSTO1 ) D2_CUSTO1, "
cQuery += "  AVG( D2_PICM ) D2_PICM, AVG( D2_VALICM ) D2_VALICM, SUM( D2_QUANT ) D2_QUANT,  "
cQuery += "  MAX( D2_PEDIDO ) D2_PEDIDO, MAX( D2_ITEMPV ) D2_ITEMPV "
cQuery += "  FROM " + RetSQLName( "SD2" )
cQuery += "  WHERE D_E_L_E_T_ = ' ' "
cQuery += "  GROUP BY D2_FILIAL, D2_DOC, D2_SERIE, D2_COD ) XORI "
cQuery += "  ON XORI.D2_FILIAL = '" + xFilial( "SD2" ) + "' "
cQuery += "  AND SC6.C6_XNFORIG = XORI.D2_DOC "
cQuery += "  AND SC6.C6_XSERORI = XORI.D2_SERIE "
cQuery += "  AND SC6.C6_PRODUTO = XORI.D2_COD "
cQuery += "  AND SC6.C6_CF IN('5112','6112') "


cQuery += "WHERE "
cQuery += "  SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
cQuery += "  AND SD2.D2_EMISSAO >= '" + DTOS(MV_PAR01) + "' AND SD2.D2_EMISSAO <= '" + DTOS(MV_PAR02) + "' "
cQuery += "  AND SD2.D2_CLIENTE >= '" + MV_PAR03 +"' AND SD2.D2_CLIENTE <= '" + MV_PAR05 + "' "
cQuery += "  AND SD2.D2_LOJA >= '" + MV_PAR04 + "' AND SD2.D2_LOJA <= '" + MV_PAR06 + "'"
cQuery += "  AND SF2.F2_VEND1 >= '" + MV_PAR09 + "' AND SF2.F2_VEND1 <= '" + MV_PAR10 + "'"
cQuery += "  AND SD2.D2_COD >= '" + MV_PAR11 + "' AND SD2.D2_COD <= '" + MV_PAR12 + "'"
cQuery += "  AND SA1.A1_SATIV1 >= '" + MV_PAR07 + "' AND SA1.A1_SATIV1 <='" + MV_PAR08 + "' "
cQuery += "  AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "  //somente notas fiscais que geram duplicatas e nao de SERVI«O
cQuery += "  AND SD2.D_E_L_E_T_ = ' ' AND SD2.D2_TIPO IN ('N','C','I','P') "
cQuery += "  AND SC5.C5_GRPVEN >= '" + MV_PAR18 + "' AND SC5.C5_GRPVEN <= '" + MV_PAR19 + "' "
cQuery += "  AND SC5.C5_GRPVEN BETWEEN '" + MV_PAR15 + "' AND '" + MV_PAR16 + "' "  + CHR(13) + CHR(10)
//If lVendedor .Or. (lGerente .And. Empty(MV_PAR13))
//	cQuery += "  AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
//Endif

If !Empty(MV_PAR13)
	cQuery += "  AND SB1.B1_SEGMENT = '" + MV_PAR13 + "' " + CHR(13) + CHR(10)
	//		If lGerente
	//			cQuery += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
	//		Endif
Endif

cQuery += "ORDER BY SD2.D2_DOC, SD2.D2_COD "

//SA1.A1_SATIV1 -> SEGMENTO DE VENDAS
//SB1.B1_SEGMENT -> SEGMENTO DE RESPONSABILIDADE

cQuery := ChangeQuery(cQuery)
//memowrite("c:\rfat061.sql",cquery)

If Select("XSD2") > 0
	XSD2->( dbCloseArea() )
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

dbSelectArea(cAlias)

aadd(aCabec, "Status"  )
aadd(aCabec, "Grupo Superior"  )	//ACRESCENTADO EM 17/01/2014 PELO ANALISTA MARCUS BARROS
aadd(aCabec, "Grupo Vendas" )
aadd(aCabec, "Segto. Vendas" )
aadd(aCabec, "Nome do Representante" )
aadd(aCabec, "Nr. Nota" )
aadd(aCabec, "Data Emiss„o" )
aadd(aCabec, "Cliente" )
aadd(aCabec, "Loja" )
aadd(aCabec, "Nome Fantasia" )
aadd(aCabec, "Estado" )
aadd(aCabec, "Tipo Frete" )
aadd(aCabec, "Item" )
aadd(aCabec, "DescriÁ„o Item" )
aadd(aCabec, "Quantidade" )
aadd(aCabec, "Valor Total" )
aadd(aCabec, "PreÁo Unitario" )
aadd(aCabec, "Impostos" )
aadd(aCabec, "%Impostos" )
aadd(aCabec, "Valor Liquido" )
aadd(aCabec, "Custo Unit.Sem Imp" ) //20
aadd(aCabec, "Custo Total" )
aadd(aCabec, "Margem Bruta" )
aadd(aCabec, "%Margem Bruta" )
aadd(aCabec, "NF Origem" )
aadd(aCabec, "Serie Orig" )
aadd(aCabec, "%ICMS Orig" )
aadd(aCabec, "Seg.Responsavel" )
aadd(aCabec, "Valor Frete" )
aadd(aCabec, "Numero CTE" )
aadd(aCabec, "Fornecedor Frete" )
aadd(aCabec, "Cod.Forn. Frete" )
aadd(aCabec, "Comissao Repr.")
aadd(aCabec, "PreÁo Seg." )
aadd(aCabec, "Margem Seg." )
aadd(aCabec, "Obs Aprovador" )
aadd(aCabec, "Num Pedido Cliente" )
aadd(aCabec, "Principal" )

dbGoTop()
While !EOF()
	
	If (MV_PAR14 == 3 .and. nMrgBrut <= 0) .or.; //imprimir somente os registros com margem bruta negativa
		(MV_PAR14 == 2 .and. _lSeg ) .or.; // imprimir somente os registro com valor abaixo da margem de seguranÁa
		MV_PAR14 == 1  //todos os registros
		
		cGrpVen    := ""
		cGrpSupVen := ""
		DbSelectArea("ACY")
		DbSetOrder(1)
		//If DbSeek(xFilial("ACY")+(cAlias)->A1_GRPVEN)
		If DbSeek(xFilial("ACY")+(cAlias)->C5_GRPVEN)
			cGrpVen    := ACY->ACY_DESCRI
			cGrpSupVen := ACY->ACY_XDESC
		endif
		
		cSegVen := ""
		DbSelectArea("SX5")
		DbSetOrder(1)
		If DbSeek(xFilial("SX5")+"T3"+(cAlias)->A1_SATIV1)
			cSegVen := X5DESCRI()
		Endif
		
		cSegResp := ""
		DbSelectArea("ACY")
		DbSetOrder(1)
		If DbSeek(xFilial("ACY")+(cAlias)->B1_SEGMENT)
			cSegResp := ACY->ACY_DESCRI
		endif
		
		DbSelectArea(cAlias)
		
		dEmissao := strzero(val( right((cAlias)->D2_EMISSAO,2)), 2) + '/' + ;
		strzero(val( substr((cAlias)->D2_EMISSAO,5,2)),2)  + '/'+  left((cAlias)->D2_EMISSAO,4)
		nVlrImp := (cAlias)->D2_VALICM + (cAlias)->D2_VALIPI + (cAlias)->D2_VALIMP5 + (cAlias)->D2_VALIMP6
		nPerImp := (cAlias)->D2_IPI + (cAlias)->D2_PICM + (cAlias)->D2_ALQIMP5 + (cAlias)->D2_ALQIMP6
		nLiquido := (cAlias)->D2_VALBRUT - nVlrImp

		If ALLTRIM((cAlias)->D2_CF) $ '5112/6112' .and. (!empty((cAlias)->D2_XNFORI) )
			nCusto := ((cAlias)->CUSTOORI / (cAlias)->XQUANT) //nota de venda em consignacao, pegar o custo da nota de origem
			nCstTot := ( (cAlias)->CUSTOORI / (cAlias)->XQUANT ) * (cAlias)->D2_QUANT
		Else
			nCusto := ( (cAlias)->D2_CUSTO1 / (cAlias)->D2_QUANT  )
			nCstTot := (cAlias)->D2_CUSTO1
		Endif

		nMrgBrut := nLiquido - nCstTot
		nPerBrut := (nMrgBrut / nLiquido) * 100
		
		//verificar se o item esteve abaixo da margem de seguranÁa e foi aprovado na liberaÁ„o do pedido:
		cObs := ""
		nPrcSeg := 0
		nMrgSeg := 0
		_lSeg := .f.
		DbSelectArea("ZA4")
		DbSetOrder(1)
		If DbSeek( (cAlias)->D2_FILIAL + (cAlias)->D2_PEDIDO + (cAlias)->D2_ITEMPV + (cAlias)->D2_COD )
			_lSeg := .t.
			nPrcSeg := ZA4->ZA4_VMSEG
			nMrgSeg := ZA4->ZA4_MSEG
			cObs := alltrim(ZA4->ZA4_MOTIVO)
		Endif
		//=================================================================================================
		
		//se tem nf origem È porque È venda consignacao, entao buscar o icms que est· na nf de origem
		nIcmOri := 0
		if !empty((cAlias)->D2_NFORI )
			DbSelectArea("SD2")
			DbSetorder(3)
			If DbSeek((cAlias)->D2_FILIAL + (cAlias)->D2_NFORI + (cAlias)->D2_SERIORI )
				nIcmOri := SD2->D2_PICM
			Endif
		Endif

		
		dbSelectArea(cAlias)
		
		//===================================================
		//fazer rateio do valor do frete :
		nTotFrete := iif(empty((cAlias)->D1_TOTAL),0, (cAlias)->D1_TOTAL)

	
												
							   
	   
		
		//somar os pesos dos itens do pedido, para depois dividir pelo total do frete:
		DbSelectArea("SC9")
		DbSetOrder(1)
		DbSeek(xFilial("SC9")+(cAlias)->D2_PEDIDO)
		nTotPeso := 0
		nPeso := 0
		Do While SC9->(!EOF()) .and. SC9->C9_FILIAL + SC9->C9_PEDIDO == xFilial("SC9")+(cAlias)->D2_PEDIDO
			If SC9->C9_NFISCAL == (cAlias)->D2_DOC
				nPeso := Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_PESO")
				nTotPeso += (nPeso * SC9->C9_QTDLIB)
			Endif
			SC9->(DbSkip())
		Enddo
		
		//nUniFrete := (nTotFrete / (cAlias)->F2_PBRUTO)
		nUniFrete := (nTotFrete / nTotPeso )
		nFrete := nUniFrete * (cAlias)->D2_QUANT
		//====================================================
		
		If !__cUserId $ cAdmVnds
			nCusto :=0
			nCstTot :=0
			nMrgBrut :=0
			nPerBrut :=0
		Endif
		
		
		DbSelectArea(cAlias)
		aadd(aDados, {"Venda",;
		cGrpSupVen,;
		cGrpVen,;
		cSegVen,;
		(cAlias)->A3_NOME,;
		'="' + (cAlias)->D2_DOC + '"',;
		ctod(dEmissao),;
		'="' + (cAlias)->D2_CLIENTE + '"',;
		'="' + (cAlias)->D2_LOJA + '"',;
		(cAlias)->A1_NREDUZ,;
		(cAlias)->D2_EST,;
		(cAlias)->C5_TPFRETE,;
		(cAlias)->D2_COD,;
		(cAlias)->B1_DESC,;
		transform((cAlias)->D2_QUANT,"@E 9,999,999.9999"),;
		transform((cAlias)->D2_VALBRUT,"@E 999,999,999.99"),;
		transform((cAlias)->D2_PRCVEN,"@E 99,999.999999"),;
		transform(nVlrImp,"@E 999,999,999.99"),;
		transform(nPerImp,"@E 999.99" ),;
		transform(nLiquido,"@E 999,999,999.99" ),;
		transform(nCusto,"@E 999,999.9999" ),;
		transform(nCstTot, "@E 999,999,999.99"),;
		transform(nMrgBrut, "@E 999,999,999.99"),;
		transform(nPerBrut, "@E 999.99"),;
		'="' + (cAlias)->D2_NFORI + '"',;
		'="' +(cAlias)->D2_SERIORI + '"', ;
		iif(nIcmOri > 0, transform(nIcmOri, "@E 999.99"),"" ),;
		cSegResp,;
		transform(nFrete, "@E 999,999,999.99"),;
		iif(!empty((cAlias)->D1_DOC),(cAlias)->D1_DOC+"/"+(cAlias)->D1_SERIE,""),;
		(cAlias)->A2_NREDUZ,;
		iif(!empty((cAlias)->D1_FORNECE),(cAlias)->D1_FORNECE+"/"+(cAlias)->D1_LOJA,""),;					   
		transform((cAlias)->C6_COMIS1,"@E 999.99" ),;
		iif(nPrcSeg > 0 ,transform(nPrcSeg, "@E 999,999.99"),""),;
		iif(nMrgSeg > 0, transform(nMrgSeg, "@E 999.99"),"") ,;
		cObs,;
		(cAlias)->C5_XPEDCLI,;
		(cAlias)->PRINCIPAL} )
		
	Endif
	
	dbSkip()
EndDo

(cAlias)->(DbCloseArea())

/* =========================================================================================================
// Emitir tambem as notas de devoluÁ„o:
// ========================================================================================================*/

cQuery := "SELECT DISTINCT "
cQuery += "  SC5.C5_GRPVEN, SA3.A3_NREDUZ, SD1.D1_DOC, SD1.D1_ITEM, SD1.D1_EMISSAO, SD1.D1_DTDIGIT, SD1.D1_FORNECE, SF1.F1_LOJA,  "
cQuery += "  SA1.A1_NREDUZ, SD1.D1_COD, SB1.B1_DESC,SD1.D1_QUANT,  SD1.D1_TOTAL, SD1.D1_IPI, SD1.D1_PICM, SD1.D1_ALQIMP5,  "
cQuery += "  SD1.D1_ALQIMP6, SA1.A1_SATIV1, SD1.D1_VALIPI, SD1.D1_VALICM, SD1.D1_VALIMP5, SD1.D1_VALIMP6, SD1.D1_VUNIT , "
cQuery += "  SD1.D1_LOJA, SD1.D1_NFORI, SD1.D1_SERIORI, SF1.F1_EST, SB1.B1_SEGMENT,SA3.A3_NOME, SD1.D1_CUSTO, TRIM(ZA0_NAME) AS PRINCIPAL "
cQuery += "FROM " + RetSqlName("SD1") + " SD1 "
cQuery += "  JOIN " + RetSqlName("SB1") + " SB1 ON "
cQuery += "    SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
cQuery += "    SD1.D1_COD = SB1.B1_COD AND "
cQuery += "    SB1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSqlName("SA1") + " SA1 ON "
cQuery += "    SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += "    SD1.D1_FORNECE = SA1.A1_COD AND "
cQuery += "    SD1.D1_LOJA = SA1.A1_LOJA AND "
cQuery += "    SA1.D_E_L_E_T_ = ' ' "
//cQuery += "  JOIN " + RetSqlName("ACY") + " ACY ON "
//cQuery += "    ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
//cQuery += "    ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
//cQuery += "    ACY.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSqlName("SF1") + " SF1 ON "
cQuery += "    SF1.F1_FILIAL = SD1.D1_FILIAL AND "
cQuery += "    SD1.D1_DOC = SF1.F1_DOC AND "
cQuery += "    SF1.F1_LOJA = SA1.A1_LOJA AND  "
cQuery += "    SD1.D1_SERIE = SF1.F1_SERIE AND "
cQuery += "    SF1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSqlName("SF2") + " SF2 ON "
cQuery += "    SF1.F1_FILIAL = SF2.F2_FILIAL AND "
cQuery += "    SD1.D1_NFORI = SF2.F2_DOC AND "
cQuery += "    SD1.D1_SERIORI = SF2.F2_SERIE AND "
cQuery += "    SF2.D_E_L_E_T_ = ' ' "
cQuery += "  LEFT JOIN " + RetSqlName("SA3") + " SA3 ON "
cQuery += "    SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND "
cQuery += "    SF2.F2_VEND1 = SA3.A3_COD AND "
cQuery += "    SA3.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSqlName("SD2") + " SD2 ON "
cQuery += "    SD2.D2_FILIAL = SD1.D1_FILIAL AND "
cQuery += "    SD1.D1_NFORI = SD2.D2_DOC AND "
cQuery += "    SD1.D1_SERIORI = SD2.D2_SERIE AND "
cQuery += "    SD1.D1_ITEMORI = SD2.D2_ITEM AND "
cQuery += "    SD2.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSqlName("SF4") + " SF4 ON "
cQuery += "    SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND "
cQuery += "    SF4.D_E_L_E_T_ = ' ' AND "
cQuery += "    SD1.D1_TES = SF4.F4_CODIGO "
cQuery += "  JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
cQuery += "    SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
cQuery += "    SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
cQuery += "    SC5.C5_NUM = SD2.D2_PEDIDO " + CHR(13) + CHR(10)
cQuery += " LEFT JOIN "+RetSQLName('ZA0')+" ZA0 "
cQuery += " ON  ZA0_CODPRI = SB1.B1_X_PRINC AND ZA0.D_E_L_E_T_ <> '*' " 

cQuery += "WHERE "
cQuery += "  SD1.D1_FILIAL = '" + xFilial("SD1") + "' "
cQuery += "  AND SD1.D1_DTDIGIT >= '" + DTOS(MV_PAR01) + "' AND SD1.D1_DTDIGIT <= '" + DTOS(MV_PAR02) + "' "
cQuery += "  AND SD1.D1_FORNECE >= '" + MV_PAR03 +"' AND SD1.D1_FORNECE <= '" + MV_PAR05 + "' "
cQuery += "  AND SD1.D1_LOJA >= '" + MV_PAR04 + "' AND SD1.D1_LOJA <= '" + MV_PAR06 + "'"
cQuery += "  AND SF2.F2_VEND1 >= '" + MV_PAR09 + "' AND SF2.F2_VEND1 <= '" + MV_PAR10 + "'"
cQuery += "  AND SD1.D1_COD >= '" + MV_PAR11 + "' AND SD1.D1_COD <= '" + MV_PAR12 + "'"
cQuery += "  AND SA1.A1_SATIV1 >= '" + MV_PAR07 + "' AND SA1.A1_SATIV1 <='" + MV_PAR08 + "' "
cQuery += "  AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "  //somente notas fiscais que geram duplicatas e nao de SERVI«O
cQuery += "  AND SD1.D_E_L_E_T_ = ' '  AND SD1.D1_TIPO = 'D' "
cQuery += "  AND SC5.C5_GRPVEN >= '" + MV_PAR18 + "' AND SC5.C5_GRPVEN <= '" + MV_PAR19 + "' "
cQuery += "  AND SC5.C5_GRPVEN BETWEEN '" + MV_PAR15 + "' AND '" + MV_PAR16 + "' "  + CHR(13) + CHR(10)
//If lVendedor .Or. (lGerente .And. Empty(MV_PAR13))
//	cQuery += "  AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
//Endif

If !Empty(MV_PAR13)
	cQuery += "  AND SB1.B1_SEGMENT = '" + MV_PAR13 + "' " + CHR(13) + CHR(10)
	//		If lGerente
	//			cQuery += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
	//		Endif
Endif

cQuery += "ORDER BY SD1.D1_DOC, SD1.D1_COD "

cAlias := "XSD1"
cQuery := ChangeQuery(cQuery)

//memowrite('c:\rfat061.sql',cquery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

dbSelectArea(cAlias)
dbGoTop()
While !EOF()
	
	If (MV_PAR14 == 3 .and. nMrgBrut <= 0) .or.; //imprimir somente os registros com margem bruta negativa
		MV_PAR14 == 1  //todos os registros
		
		cGrpVen    := ""
		cGrpSupVen := ""
		DbSelectArea("ACY")
		DbSetOrder(1)
		If DbSeek(xFilial("ACY")+(cAlias)->C5_GRPVEN)
			cGrpVen    := ACY->ACY_DESCRI
			cGrpSupVen := ACY->ACY_XDESC
		ENDIF
		
		cSegVen := ""
		DbSelectArea("SX5")
		DbSetOrder(1)
		If DbSeek(xFilial("SX5")+"T3"+(cAlias)->A1_SATIV1)
			cSegVen := X5DESCRI()
		Endif
		
		cSegResp := ""
		DbSelectArea("ACY")
		DbSetOrder(1)
		If DbSeek(xFilial("ACY")+(cAlias)->B1_SEGMENT)
			cSegResp := ACY->ACY_DESCRI
		endif
		
		DbSelectArea(cAlias)
		
		dEmissao := strzero(val( right((cAlias)->D1_DTDIGIT,2)), 2) + '/' + ;
		strzero(val( substr((cAlias)->D1_DTDIGIT,5,2)),2)  + '/'+  left((cAlias)->D1_DTDIGIT,4)
		nVlrImp  := (cAlias)->D1_VALICM  + (cAlias)->D1_VALIMP5 + (cAlias)->D1_VALIMP6    // + (cAlias)->D1_VALIPI, ipi nao esta embutido no d1_total
		nPerImp  := (cAlias)->D1_IPI + (cAlias)->D1_PICM + (cAlias)->D1_ALQIMP5 + (cAlias)->D1_ALQIMP6
		nLiquido := ( (cAlias)->D1_TOTAL - nVlrImp ) * -1
		nCusto   := ( (cAlias)->D1_CUSTO / (cAlias)->D1_QUANT )  //(cAlias)->B2_CM1
		nVlBrut  := ( (cAlias)->D1_TOTAL + (cAlias)->D1_VALIPI ) * (-1)
		
		nCstTot  := ((cAlias)->D1_CUSTO * -1) //*  nCusto
		nMrgBrut := nLiquido - nCstTot
		nPerBrut := (nMrgBrut / nLiquido) * 100
		
		If !__cUserId $ cAdmVnds
			nCusto :=0
			nCstTot :=0
			nMrgBrut :=0
			nPerBrut :=0
		Endif
		
		aadd(aDados, {"DevoluÁ„o",;
		cGrpSupVen,;
		cGrpVen ,;
		cSegVen,;
		(cAlias)->A3_NOME,;
		'="' +(cAlias)->D1_DOC + '"',;
		ctod(dEmissao),;
		'="' +(cAlias)->D1_FORNECE + '"',;
		'="' +(cAlias)->F1_LOJA+ '"',;
		(cAlias)->A1_NREDUZ,;
		(cAlias)->F1_EST,;
		" ",;
		(cAlias)->D1_COD,;
		(cAlias)->B1_DESC,;
		transform((cAlias)->D1_QUANT * (-1),"@E 9,999,999.9999"),;
		transform(nVlBrut,"@E 999,999,999.99"),;
		transform((cAlias)->D1_VUNIT,"@E 99,999.999999"),;
		transform(nVlrImp * (-1),"@E 999,999,999.99"),;
		transform(nPerImp,"@E 999.99" ),;
		transform(nLiquido ,"@E 999,999,999.99" ),;
		transform(nCusto,"@E 999,999.9999" ),;
		transform(nCstTot, "@E 999,999,999.99"),;
		transform(nMrgBrut, "@E 999,999,999.99"),;
		transform(nPerBrut, "@E 999.99"),;
		'="' +(cAlias)->D1_NFORI + '"',;
		'="' +(cAlias)->D1_SERIORI + '"',;
		"",;
		cSegResp,;
		"","","" ,"", "","",;
		(cAlias)->PRINCIPAL} )
		
	Endif
	
	dbSelectArea(cAlias)
	dbSkip()
EndDo

If len(aDados) == 0
	MsgInfo("N„o existem notas a serem impressas, de acordo com os par‚metros informados!","AtenÁ„o")
Else
	DlgToExcel({ {"ARRAY", "Relatorio de Margem", aCabec, aDados} })
Endif

(cAlias)->(DbCloseArea())

Return


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ IMPR061G ∫ Autor ≥ Giane              ∫ Data ≥  25/11/10   ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function IMPR061G()
Local cAlias, cQuery
Local aCabec := {}
Local aDados := {}
Local aAux, aAux2, aAux3, aAux4, aAux5
Local nTotal, nTotMarg, nTotPer, nTotLiq
Local nGerQtd := 0
Local nGerTot := 0
Local nGerMrg := 0
Local nGerLiq := 0
Local aQtd := {}
Local aTot := {}
Local aMrg := {}
Local aLiq := {}
Local nX := 0
Local i := 0
cAlias:= "XSD2"

cQuery := "SELECT "
cQuery += "  XFAT.B1_GRUPO B1_GRUPO, XFAT.EMISSAO EMISSAO, SUM(XFAT.VLRLIQ) VLRLIQ,  "
cQuery += "  SUM(XFAT.QUANT) QUANT, SUM(XFAT.VLRTOTAL) VLRTOTAL, SUM(XFAT.VLRUNIT) VLRUNIT, SUM(XFAT.MARGEM) MARGEM, "
cQuery += "  ( ( SUM(XFAT.MARGEM) / CASE WHEN (SUM(XFAT.VLRLIQ) = 0) THEN 1 ELSE  SUM(XFAT.VLRLIQ) END ) * 100 ) PERMARGEM "
cQuery += "FROM ( "
cQuery += "  SELECT DISTINCT "
cQuery += "    SB1.B1_GRUPO, SUBSTR(SD2.D2_EMISSAO,5,2) EMISSAO, SUM(SD2.D2_QUANT) QUANT , "
cQuery += "    SUM(SD2.D2_VALBRUT) VLRTOTAL , SUM(SD2.D2_PRCVEN) VLRUNIT, "
cQuery += "    SUM( ( SD2.D2_VALBRUT - (SD2.D2_VALICM + SD2.D2_VALIPI + SD2.D2_VALIMP5 + SD2.D2_VALIMP6 )) - SD2.D2_CUSTO1 ) MARGEM, "
cQuery += "    SUM( SD2.D2_VALBRUT - (SD2.D2_VALICM + SD2.D2_VALIPI + SD2.D2_VALIMP5 + SD2.D2_VALIMP6 ) ) VLRLIQ "
cQuery += "  FROM " + RetSqlName("SD2") + " SD2 "
cQuery += "    JOIN " + RetSqlName("SB1") + " SB1 ON "
cQuery += "      SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
cQuery += "      SD2.D2_COD = SB1.B1_COD AND "
cQuery += "      SB1.D_E_L_E_T_ = ' ' "
cQuery += "    JOIN " + RetSqlName("SA1") + " SA1 ON "
cQuery += "      SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += "      SD2.D2_CLIENTE = SA1.A1_COD AND "
cQuery += "      SD2.D2_LOJA = SA1.A1_LOJA AND "
cQuery += "      SA1.D_E_L_E_T_ = ' ' "
//cQuery += "    JOIN " + RetSqlName("ACY") + " ACY ON "
//cQuery += "      ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
//cQuery += "      ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
//cQuery += "      ACY.D_E_L_E_T_ = ' ' "
cQuery += "    JOIN " + RetSqlName("SF2") + " SF2 ON "
cQuery += "      SF2.F2_FILIAL = SD2.D2_FILIAL AND "
cQuery += "      SD2.D2_DOC = SF2.F2_DOC AND "
cQuery += "      SD2.D2_SERIE = SF2.F2_SERIE AND "
cQuery += "      SF2.D_E_L_E_T_ = ' ' "
cQuery += "    JOIN " + RetSqlName("SF4") + " SF4 ON "
cQuery += "      SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND "
cQuery += "      SD2.D2_TES = SF4.F4_CODIGO AND "
cQuery += "      SF4.D_E_L_E_T_ = ' ' "
cQuery += "    JOIN " + RetSqlName("SC5") + " SC5 ON "
cQuery += "      SD2.D2_FILIAL = SC5.C5_FILIAL AND "
cQuery += "      SD2.D2_PEDIDO = SC5.C5_NUM AND "
cQuery += "      SC5.D_E_L_E_T_ = ' ' "
cQuery += "  WHERE "
cQuery += "    SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
cQuery += "    AND SD2.D2_EMISSAO >= '" + DTOS(MV_PAR01) + "' AND SD2.D2_EMISSAO <= '" + DTOS(MV_PAR02) + "' "
cQuery += "    AND SD2.D2_CLIENTE >= '" + MV_PAR03 +"' AND SD2.D2_CLIENTE <= '" + MV_PAR05 + "' "
cQuery += "    AND SD2.D2_LOJA >= '" + MV_PAR04 + "' AND SD2.D2_LOJA <= '" + MV_PAR06 + "'"
cQuery += "    AND SF2.F2_VEND1 >= '" + MV_PAR09 + "' AND SF2.F2_VEND1 <= '" + MV_PAR10 + "'"
cQuery += "    AND SD2.D2_COD >= '" + MV_PAR11 + "' AND SD2.D2_COD <= '" + MV_PAR12 + "'"
cQuery += "    AND SA1.A1_SATIV1 >= '" + MV_PAR07 + "' AND SA1.A1_SATIV1 <='" + MV_PAR08 + "' "
cQuery += "    AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "  //somente notas fiscais que geram duplicatas e nao de SERVI«O
cQuery += "    AND SC5.C5_GRPVEN >= '" + MV_PAR18 + "' AND SC5.C5_GRPVEN <= '" + MV_PAR19 + "' "
cQuery += "    AND SD2.D_E_L_E_T_ = ' ' AND SD2.D2_TIPO IN ('N','C','I','P') "

cQuery += "    AND SC5.C5_GRPVEN BETWEEN '" + MV_PAR15 + "' AND '" + MV_PAR16 + "' "  + CHR(13) + CHR(10)
//If lVendedor .Or. (lGerente .And. Empty(MV_PAR13))
//	cQuery += "  AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
//Endif

If !Empty(MV_PAR13)
	cQuery += "  AND SB1.B1_SEGMENT = '" + MV_PAR13 + "' " + CHR(13) + CHR(10)
	//		If lGerente
	//			cQuery += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
	//		Endif
Endif
cQuery += "  GROUP BY B1_GRUPO, SUBSTR(SD2.D2_EMISSAO,5,2) "

cQuery += "  UNION "

cQuery += "  SELECT  DISTINCT"
cQuery += "    SB1.B1_GRUPO,  SUBSTR(SD1.D1_DTDIGIT,5,2) EMISSAO, SUM(SD1.D1_QUANT * -1) QUANT, "
cQuery += "    SUM((SD1.D1_TOTAL + SD1.D1_VALIPI) * -1) VLRTOTAL, "
cQuery += "    SUM(SD1.D1_VUNIT * -1) VLRUNIT, "
cQuery += "    SUM(( ( SD1.D1_TOTAL - (SD1.D1_VALICM  + SD1.D1_VALIMP5 + SD1.D1_VALIMP6) ) -  SD1.D1_CUSTO ) * -1 ) MARGEM, "
cQuery += "    SUM( (SD1.D1_TOTAL - (SD1.D1_VALICM  + SD1.D1_VALIMP5 + SD1.D1_VALIMP6))* -1 ) VLRLIQ "
cQuery += "  FROM " + RetSqlName("SD1") + " SD1 "
cQuery += "    JOIN " + RetSqlName("SB1") + " SB1 ON "
cQuery += "      SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
cQuery += "      SD1.D1_COD = SB1.B1_COD AND "
cQuery += "      SB1.D_E_L_E_T_ = ' ' "
cQuery += "    JOIN " + RetSqlName("SA1") + " SA1 ON "
cQuery += "      SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += "      SD1.D1_FORNECE = SA1.A1_COD AND "
cQuery += "      SD1.D1_LOJA = SA1.A1_LOJA AND "
cQuery += "      SA1.D_E_L_E_T_ = ' ' "
//cQuery += "    JOIN " + RetSqlName("ACY") + " ACY ON "
//cQuery += "      ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
//cQuery += "      ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
//cQuery += "      ACY.D_E_L_E_T_ = ' ' "
cQuery += "    JOIN " + RetSqlName("SF2") + " SF2 ON "
cQuery += "      SD1.D1_FILIAL = SF2.F2_FILIAL AND "
cQuery += "      SD1.D1_NFORI = SF2.F2_DOC AND "
cQuery += "      SD1.D1_SERIORI = SF2.F2_SERIE AND "
cQuery += "      SF2.D_E_L_E_T_ = ' ' "
cQuery += "    JOIN " + RetSqlName("SF4") + " SF4 ON "
cQuery += "      SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND "
cQuery += "      SF4.D_E_L_E_T_ = ' ' AND "
cQuery += "      SD1.D1_TES = SF4.F4_CODIGO "
cQuery += "    JOIN " + RetSqlName("SD2") + " SD2 ON "
cQuery += "      SD2.D2_FILIAL = SD1.D1_FILIAL AND "
cQuery += "      SD1.D1_NFORI = SD2.D2_DOC AND "
cQuery += "      SD1.D1_SERIORI = SD2.D2_SERIE AND "
cQuery += "      SD1.D1_ITEMORI = SD2.D2_ITEM AND "
cQuery += "      SD2.D_E_L_E_T_ = ' ' "
cQuery += "    JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
cQuery += "      SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
cQuery += "      SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
cQuery += "      SC5.C5_NUM = SD2.D2_PEDIDO " + CHR(13) + CHR(10)
cQuery += "  WHERE "
cQuery += "    SD1.D1_FILIAL = '" + xFilial("SD1") + "' "
cQuery += "    AND SD1.D1_DTDIGIT >= '" + DTOS(MV_PAR01) + "' AND SD1.D1_DTDIGIT <= '" + DTOS(MV_PAR02) + "' "
cQuery += "    AND SD1.D1_FORNECE >= '" + MV_PAR03 +"' AND SD1.D1_FORNECE <= '" + MV_PAR05 + "' "
cQuery += "    AND SD1.D1_LOJA >= '" + MV_PAR04 + "' AND SD1.D1_LOJA <= '" + MV_PAR06 + "'"
cQuery += "    AND SF2.F2_VEND1 >= '" + MV_PAR09 + "' AND SF2.F2_VEND1 <= '" + MV_PAR10 + "'"
cQuery += "    AND SD1.D1_COD >= '" + MV_PAR11 + "' AND SD1.D1_COD <= '" + MV_PAR12 + "'"
cQuery += "    AND SA1.A1_SATIV1 >= '" + MV_PAR07 + "' AND SA1.A1_SATIV1 <='" + MV_PAR08 + "' "
cQuery += "    AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "  //somente notas fiscais que geram duplicatas e nao de SERVI«O
cQuery += "    AND SD1.D_E_L_E_T_ = ' '  AND SD1.D1_TIPO = 'D' "
cQuery += "    AND SC5.C5_GRPVEN >= '" + MV_PAR18 + "' AND SC5.C5_GRPVEN <= '" + MV_PAR19 + "' "
cQuery += "    AND SC5.C5_GRPVEN BETWEEN '" + MV_PAR15 + "' AND '" + MV_PAR16 + "' "
//If lVendedor .Or. (lGerente .And. Empty(MV_PAR13))
//	cQuery += "  AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/")
//Endif

If !Empty(MV_PAR13)
	cQuery += "  AND SB1.B1_SEGMENT = '" + MV_PAR13 + "' "
	//		If lGerente
	//			cQuery += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/")
	//		Endif
Endif

cQuery += "    GROUP BY B1_GRUPO, SUBSTR(SD1.D1_DTDIGIT,5,2) "
cQuery += ") XFAT "
cQuery += "GROUP BY B1_GRUPO, EMISSAO "
cQuery += " ORDER BY B1_GRUPO, EMISSAO "

cQuery := ChangeQuery(cQuery)
//memowrite("c:\rfat061.sql",cquery)

If Select("XSD2") > 0
	XSD2->( dbCloseArea() )
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

dbSelectArea(cAlias)
dbgotop()

aadd(aCabec, "Grupo Produto"  )
aadd(aCabec, "Dados" )

aMes := CalcMeses('A')
For i:= 1 to len(aMes)
	aadd(aCabec, UPPER(aMes[i]) )
Next
aadd(aCabec, "Total Geral")

aMes := CalcMeses()

nTam := 2 + len(aMes) + 1

//monta arrays para guardar totais gerais de cada mes
For i:= 1 to len(aMes)
	aadd(aQtd, {aMes[i],0} )
	aadd(aTot, {aMes[i],0} )
	aadd(aMrg, {aMes[i],0} )
	aadd(aLiq, {aMes[i],0} )
next

Do While !eof()
	
	aAux := {}
	aAux2 := {}
	aAux3 := {}
	aAux4 := {}
	aAux5 := {}
	nTotQtd  := 0
	nTotal   := 0
	nTotMarg := 0
	nTotPer  := 0
	nTotLiq  := 0
	cGrupo   := (cAlias)->B1_GRUPO
	
	aadd(aAux, Posicione("SBM",1,xFilial("SBM")+(cAlias)->B1_GRUPO,"BM_DESC") )
	aadd(aAux, "Quantidade" )
	
	aadd(aAux2, "" )
	aadd(aAux2,"PreÁo MÈdio Unit." )
	
	aadd(aAux3, "" )
	aadd(aAux3,"Valor Total" )
	
	aadd(aAux4, "" )
	aadd(aAux4,"Margem Bruta" )
	
	aadd(aAux5, "" )
	aadd(aAux5,"% Margem" )
	
	For i:= 1 to len(aMes)
		aadd(aAux,0)
		aadd(aAux2, 0)
		aadd(aAux3, 0)
		aadd(aAux4, 0)
		aadd(aAux5, 0)
	Next
	
	
	(cAlias)->(DbEval( {||  aAux := fMontaLinha(aAux, aMes, (cAlias)->QUANT, @aQtd )    , fCalcUnit(@aAux2, aMes), nTotLiq += (cAlias)->VLRLIQ, ;
	aAux3:= fMontaLinha(aAux3, aMes, (cAlias)->VLRTOTAL, @aTot ), aAux4 := fMontaLinha(aAux4, aMes, (cAlias)->MARGEM, @aMrg ),;
	fMontaLinha( , , (cAlias)->VLRLIQ, @aLiq),;
	aAux5:= fMontaLinha(aAux5, aMes, (cAlias)->PERMARGEM), nTotQtd += (cAlias)->QUANT , nTotMarg += (cAlias)->MARGEM, ;
	nTotal += (cAlias)->VLRTOTAL,   fCalcMrg(@aAux5, aMes, @nTotPer) } ,,{|| (cAlias)->B1_GRUPO == cGrupo}  ))
	
	
	// nGerQtd += nTotQtd
	aadd(aAux, nTotQtd)
	aadd(aDados, aAux)
	
	aadd(aAux2, round(nTotal / nTotQtd,2) )
	aadd(aDados, aAux2)
	
	//nGerTot += nTotal
	aadd(aAux3, nTotal )
	aadd(aDados, aAux3)
	
	//nGerMarg += nTotMarg
	aadd(aAux4, nTotMarg )
	aadd(aDados, aAux4)
	
	//nGerLiq += nTotLiq
	nTotPer := round ((nTotMarg / nTotLiq) * 100, 2)
	aadd(aAux5, nTotPer )
	aadd(aDados, aAux5)
	
Enddo

//imprime os totais das quantidades de cada mes:
aadd(aDados, "")
aadd(aDados, "")
aAux := {}
aadd(aAux, "TOTAIS")
aadd(aAux, "Quantidade")
For nx:= 1 to len(aQtd)
	aadd(aAux, aQTd[nx,2])
	nGerQTd += aQTd[nx,2]
Next
aadd(aAux, nGerQtd)
aadd(aDados, aAux )

//imprime os totais do preÁo medio de cada mes:
aAux := {}
aadd(aAux, "")
aadd(aAux, "PreÁo MÈdio Unit.")
For nx:= 1 to len(aTot)
	aadd(aAux, round( aTot[nx,2] / aQtd[nx,2], 2) )
	nGerTot += aTot[nx,2]
Next
aadd(aAux, round( nGerTot / nGerQtd, 2) )
aadd(aDados, aAux )

//imprime os totais do valor total de cada mes:
aAux := {}
aadd(aAux, "")
aadd(aAux, "Valor Total")
For nx:= 1 to len(aTot)
	aadd(aAux, aTot[nx,2])
	// nGetTot += aTot[nx,2]
Next
aadd(aAux, nGerTot)
aadd(aDados, aAux )

//imprime os totais da margem bruta de cada mes:
aAux := {}
aadd(aAux, "")
aadd(aAux, "Margem Bruta")
For nx:= 1 to len(aMrg)
	aadd(aAux, aMrg[nx,2])
	nGerMrg += aMrg[nx,2]
Next
aadd(aAux, nGerMrg)
aadd(aDados, aAux )

//imprime os totais da % margem de cada mes:
aAux := {}
aadd(aAux, "")
aadd(aAux, "%Margem")
For nx:= 1 to len(aLiq)
	aadd(aAux, round( (aMrg[nx,2] / aLiq[nx,2]) * 100,2 ) )
	nGerLiq += aLiq[nx,2]
Next
aadd(aAux, round( (nGerMrg / nGerLiq) * 100,2 ) )
aadd(aDados, aAux )

DlgToExcel({ {"ARRAY", "Relatorio de Margem", aCabec, aDados} })

Return

Static Function fCalcUnit(aAux2, aMes)
nPos := Ascan(aMes,  XSD2->EMISSAO)

if nPos != 0
	aAux2[nPos + 2] := round( XSD2->VLRTOTAL / XSD2->QUANT ,2 )
Endif

Return

Static function fCalcMrg(aAux5, aMes, nTotPer)

nPos := Ascan(aMes,  XSD2->EMISSAO)

if nPos != 0
	aAux5[nPos + 2] := round( (XSD2->MARGEM / XSD2->VLRLIQ)* 100 ,2 )
Endif

Return

Static Function fMontaLinha(aLinha, aMes, nValor, aTotMes)

If aLinha != Nil
	nPos := Ascan(aMes,  XSD2->EMISSAO)
	
	if nPos != 0
		aLinha[nPos + 2] := nValor
	Endif
Endif

If aTotMes != Nil
	//giane
	nPos := Ascan(aTotMes,{ |x| x[1] == XSD2->EMISSAO} )
	if nPos != 0
		aTotMes[nPos,2] += nValor
	Endif
Endif

Return aLinha


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funcao    ≥CalcMeses * Autor* Giane                ≥ Data ≥26.02.2010≥  ±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥Calcula meses existentes no periodo digitado nos parametros ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥   DATA   ≥                                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function CalcMeses(Tipo)

Local nDif    := MV_PAR02 - MV_PAR01
Local cAux    := ""
Local aRet    := {}
Local nLoop   := 0

If nDif < 0
	MsgStop( "Parametros Informados de Forma Incorreta" )
ElseIf nDif == 0
	cAux :=   SubStr( Dtos( MV_PAR01 ), 5, 2 )
	if Tipo == 'A'
		cAux += "/" + SubStr( Dtos( MV_PAR01 ), 1, 4 )
	endif
	aAdd( aRet, cAux )
Else
	For nLoop := 0 To nDif
		
		cAux :=  SubStr( Dtos( MV_PAR01 + nLoop ), 5, 2 )
		if Tipo == 'A'
			cAux += "/" + SubStr( Dtos( MV_PAR01 + nLoop ), 1, 4 )
		endif
		
		If aScan( aRet, cAux ) == 0
			aAdd( aRet, cAux )
		Endif
	Next nLoop
	
Endif

Return aRet
