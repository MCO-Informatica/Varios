#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT093   บ Autor ณ Giane              บ Data ณ  06/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Pedidos a Faturar                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Makeni                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RFAT093B()

	Local aArea := GetArea()
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Relat๓rio de Pedidos a Faturar."
	Local titulo         := "Relatorio de Pedidos a Faturar"
	Local nLin           := 80
	Local cQuery         := ""
	Local Cabec1         := "Pedido Cliente   Nome Fantasia                               Entrega     Nr Pedido Cliente Usuแrio Emitente   Vendedor                         Cond.Pagamento                                 Emissao      Grupo Vendas"
	Local Cabec2         := "  Item Produto                                                                                    Quantidade     Estoque Disp.        Saldo Estoque        Moeda     Valor Unitแrio              Valor total"
//123456 123456 99 12345678901234567890 99/99/99 000002 1234567890123456789012345 000002 1234567890123456789012345 1234567890123456789012345678901234567890 99/99/99            123456789012345678901234567890
//    99 123456789012345 1234567890123456789012345678901234567890123456789012345678901234567890   999,999.99   99,999,999,999.99   99,999,999,999.99          uSS   99,999,999.999999           999,999,999.99
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
//         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16         17        18        19
	Local aOrd           := {"Nr.Pedido + Item","Data Entrega + Nr.Pedido + Item"}
	Local cPerg          := "RFAT093B"
/*
Local aConf          := {}
Local lGerente       := .f.
Local lVendedor      := .f.
Local cGrpAcesso     := ""
*/
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RFAT093" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RFAT093B" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cAlias       := "SC6"

	Private cXUSRCUS := GetMv("ES_RFAT093")

	if !Pergunte(cPerg)
		return
	Endif

	if MV_PAR22 = 1
		titulo += " - Em Reais"
	Else
		titulo += " - Em Dolar"
	Endif


//=========== Regra de Confidencialidade =====================================
/*
aConf := U_ChkConfig(__cUserId)
cGrpAcesso:= aConf[1]

	If Empty(cGrpAcesso)
MsgStop("USUARIO SEM PERMISSAO - REGRA DE CONFIDENCIALIDADE","Aten็ใo!")
RestArea( aArea )
Return
	Endif

lGerente := aConf[2]
lVendedor := aConf[4]

*/
//============================================================================

	wnrel := SetPrint(cAlias,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.f.)

	If nLAstKey == 27
		Return
	Endif

	cAlias := GetNextAlias()

	cQuery := "SELECT DISTINCT"
	cQuery += "  SC5.C5_NUM, SC5.C5_TABELA, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SA1.A1_NREDUZ,SA1.A1_LOTEUNI, SA1.A1_FATVALI, SC5.C5_EMISSAO, SC5.C5_USERLGI, SC5.C5_VEND1, SA3.A3_NREDUZ, "
	cQuery += "  SE4.E4_DESCRI, SC5.C5_XENTREG, C5_GRPVEN, C5_DGRPVEN, SC6.C6_ITEM, SC6.C6_PRODUTO, C6_NUMORC, SB1.B1_DESC, SC6.C6_QTDVEN, SC6.C6_XPRUNIT,"
	cQuery += "  SC6.C6_XMOEDA, SC6.C6_PRCVEN, SC6.C6_VALOR, SF4.F4_IPI, SB1.B1_IPI, SC6.C6_LOCAL, SB2.B2_QATU, SB2.B2_RESERVA, SB2.B2_LOCAL, "
	cQuery += "  SC6.C6_XICMEST, SC6.C6_XPISCOF, SC6.C6_XMEDIO, SC6.C6_XTAXA, SC6.C6_XCUSTO, SB1.B1_CUSTD, SC6.C6_XVLRINF ,C6_XVRMARG, C6_NUMPCOM,C6_ITEMPC , C6_PEDCLI , C6_ITEMPED, "
	cQuery += "  ZA0.ZA0_NAME, SB8.B8_LOTECTL, SB8.B8_XOBS ,SB8.B8_LOCAL   "

	cQuery += "  FROM " + RetSqlName("SC6") + " SC6 "
	cQuery += "  JOIN " + RetSqlName("SC5") + " SC5 ON "
	cQuery += "    SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND "
	cQuery += "    SC5.C5_NUM = SC6.C6_NUM AND  "
	cQuery += "    SC5.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQuery += "    SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "
	cQuery += "    SA1.A1_COD = SC5.C5_CLIENTE AND  "
	cQuery += "    SA1.A1_LOJA= SC5.C5_LOJACLI AND  "
	cQuery += "    SA1.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "    SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cQuery += "    SB1.B1_COD = SC6.C6_PRODUTO AND "
	cQuery += "    SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SA3") + " SA3 ON "
	cQuery += "    SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND "
	cQuery += "    SA3.A3_COD = SC5.C5_VEND1 AND "
	cQuery += "    SA3.D_E_L_E_T_ = ' '  "
	cQuery += "  LEFT JOIN " + RetSqlName("SE4") + " SE4 ON "
	cQuery += "    SE4.E4_FILIAL = '" + xFilial("SE4") + "' AND "
	cQuery += "    SE4.E4_CODIGO = SC5.C5_CONDPAG AND "
	cQuery += "    SE4.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SF4") + " SF4 ON "
	cQuery += "    SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "
	cQuery += "    SC6.C6_TES = SF4.F4_CODIGO AND "
	cQuery += "    SF4.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SB2") + " SB2 ON "
	cQuery += "    SB2.B2_FILIAL = '" + xFilial("SB2") + "' AND "
	cQuery += "    SC6.C6_PRODUTO = SB2.B2_COD AND "
	cQuery += "    SC6.C6_LOCAL = SB2.B2_LOCAL AND "
	cQuery += "    SB2.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("ZA0") + " ZA0 ON "
	cquery += "    ZA0.ZA0_FILIAL = '" + xFilial( "ZA0" ) + "' AND "
	cQuery += "    SB1.B1_X_PRINC = ZA0.ZA0_CODPRI AND"
	cQuery += "    ZA0.D_E_L_E_T_ = ' ' "
//
	cQuery += "   LEFT JOIN "+ RetSqlName("SB8") + " SB8 ON "
	cQuery += "    SC6.C6_LOTECTL = SB8.B8_LOTECTL AND "
	cQuery += "    SB8.B8_PRODUTO = SC6.C6_PRODUTO AND "
	cQuery += "    SB8.B8_LOCAL = SC6.C6_LOCAL AND "
	cQuery += "    SB8.D_E_L_E_T_ = ' ' "

	cQuery += "WHERE "

	cQuery += "  SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.C6_BLQ <> 'R' AND "
	cQuery += "  SC6.C6_NOTA = '         ' AND SC6.C6_SERIE = '  '  AND "
	cQuery += "  SC6.D_E_L_E_T_ = ' '  AND "
	cQuery += "  SC5.C5_X_CANC = ' '  AND  SC5.C5_X_REP = ' '   AND "

	cQuery += "  SC5.C5_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "
	cQuery += "  SC6.C6_ENTREG BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' AND "
	cQuery += "  SC6.C6_PRODUTO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "
	cQuery += "  SB1.B1_GRUPO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' AND "
	cQuery += "  SC5.C5_GRPVEN BETWEEN '" + MV_par09 + "' AND '" + MV_PAR10 + "' AND "
	cQuery += "  SC5.C5_CLIENTE BETWEEN '"  + MV_PAR11 + "' AND '"  + MV_PAR13 + "' AND "
	cQuery += "  SC5.C5_LOJACLI BETWEEN '" + MV_PAR12 + "' AND '" + MV_PAR14 + "' AND "
	cQuery += "  SC5.C5_VEND1 BETWEEN '" + MV_PAR15 + "' AND '" + MV_PAR16 + "' AND "
	cQuery += "  SB1.B1_SEGMENT BETWEEN '" + MV_PAR19 + "' AND '" + MV_PAR20 + "' AND "
	cQuery += "  SB1.B1_X_PRINC BETWEEN '" + MV_PAR26 + "' AND '" + MV_PAR27 + "' "

	If MV_PAR24 == 1 //tes que gera duplicata
		cQuery += "  AND SF4.F4_DUPLIC = 'S'  "
	Elseif MV_PAR24 == 2
		cQuery += "  AND SF4.F4_DUPLIC = 'N'  "
	Endif

	cQuery += "  AND SC5.C5_GRPVEN BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "

	If aReturn[8] == 1
		cQuery += "ORDER BY C5_NUM, C6_ITEM	, C6_LOCAL "
	Else
		cQuery += "ORDER BY C5_XENTREG, C5_NUM, C6_ITEM, C6_LOCAL"
	Endif

	cQuery := ChangeQuery(cQuery)

	MsgRun("Selecionando registros, aguarde...","Relat๓rio Pedidos a Faturar", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })

	DbSelectArea("SA3")
	DbSetOrder(7) //filial + cod.usuario

	DbSelectArea("SM2")
	DbSetOrder(1)

	dbSelectArea(cAlias)
	DbGotop()

	If MV_PAR25 == 2

		If nLastKey == 27
			Return
		Endif

		SetDefault(aReturn,cAlias)

		If nLastKey == 27
			Return
		Endif

		nTipo := If(aReturn[4]==1,15,18)

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

	Else
		//EXPORTAR PARA EXCEL
		MsgRun("Processando relat๓rio em Excel, aguarde...","Relat๓rio Pedidos a Faturar",{|| R093Excel()}  )
	Endif

	(cAlias)->(DbCloseArea())

	RestArea(aArea)
Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  04/03/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
	ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ Programa principal                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local cCod := ""
	Local cCodVend := SPACE(6)
	Local cNum := ""
	Local nVlrItem := 0
	Local nVlrSIte := 0
	Local nVlrCS := 0
	Local aEstoque := {}
	Local nPrdUnit := 0

	dbSelectArea(cAlias)
	SetRegua(RecCount())

	dbGoTop()
	While !EOF()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//cEmitente :=  UsrRetName( SubStr( Embaralha( (cAlias)->C5_USERLGI, 1 ), 3, 6 ) )  //Left(Embaralha((cAlias)->C5_USERLGI,1),15)
		cNomeEmi  := UsrRetName( SubStr( Embaralha( (cAlias)->C5_USERLGI, 1 ), 3, 6 ) )  //" "
		cCod := (cAlias)->C5_VEND1 //SPACE(6)
		cCodVend := SPACE(6)
		nVlrSIte :=0
		nVlrItem := 0
		nVlrCS := 0
	/*
	//Procura o codigo do usuario que incluiu o pedido de vendas
		If (cAlias)->C5_EMISSAO <= '20120930'

			For i:= 1 to len(aUsu)
				If LEFT(aUsu[i,1,2],15) == LEFT(cEmitente,15)
	cCod := aUsu[i,1,1]
				Endif
			Next
		Else
			For i:= 1 to len(aUsu)
				If LEFT(aUsu[i,1,1],6) == substr(cEmitente,3,6)
	cCod    := aUsu[i,1,1]
	cNomeEmi:= LEFT(aUsu[i,1,2],15)
				Endif
			Next
		EndIf
	*/
		//procura o codigo do vendedor deste usuario
		If !empty(cCod)
			if SA3->(DbSeek( xFilial("SA3") + cCod ))
				cCodVend := SA3->A3_COD
			Endif
		Endif

		if (.not.(cCodVend >= MV_PAR17 .and. cCodVend <= MV_PAR18)) .AND. !EMPTY(cCodVend)
			DbSkip()
			loop
		endif

		If nLin > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin:= 9
		Endif

		If (cAlias)->C5_NUM <> cNum  .or. nLin == 9
			if nLin > 9
				nLin++
			endif
			@nLin,007 PSAY (cAlias)->C5_NUM
			@nLin,038 Psay (cAlias)->C5_CLIENTE + (cAlias)->C5_LOJACLI + space(01) + (cAlias)->A1_NREDUZ
			@nLin,060 Psay STOD((calias)->C5_XENTREG)
			IF Empty((cAlias)->C6_PEDCLI)
				@nLin,074 Psay Alltrim((cAlias)->C6_NUMPCOM)
			ELSE
				@nLin,074 Psay Alltrim((cAlias)->C6_PEDCLI)
			ENDIF
			@nLin,092 Psay cNomeEmi
			@nLin,110 Psay (cAlias)->C5_VEND1 + space(01) + (cAlias)->A3_NREDUZ
			@nLin,143 Psay (cAlias)->E4_DESCRI
			@nLin,190 Psay STOD((cAlias)->C5_EMISSAO)
			@nLin,203 Psay (cAlias)->C5_DGRPVEN
			nLin++
			cNum := (cAlias)->C5_NUM
		Endif

		nPos := aScan( aEstoque, { |x|   x[01] == (cAlias)->C6_PRODUTO  .AND. x[4] == (cAlias)->B2_LOCAL })
		if nPos > 0
			aEstoque[nPos][3] -= (cAlias)->C6_QTDVEN
		Else
			aAdd(aEstoque,{(cAlias)->C6_PRODUTO ,(cAlias)->B2_QATU, (cAlias)->B2_QATU - (cAlias)->C6_QTDVEN, (cAlias)->B2_LOCAL } )
		Endif
		nPrdUnit := (cAlias)->C6_PRCVEN

		CalcItem(@nVlrItem,@nPrdUnit )
		CalcCS(@nVlrCS)

		@nLin,000 Psay (cAlias)->C6_ITEM
		@nLin,004 Psay (cAlias)->C6_PRODUTO + SPACE(01) + (cAlias)->B1_DESC
		@nLin,007 Psay Transform((cAlias)->C6_QTDVEN,"@E 999,999.99" )

		nPos := aScan( aEstoque, { |x|   x[01] == (cAlias)->C6_PRODUTO  .AND. x[4] == (cAlias)->B2_LOCAL })

		@nLin,098 Psay Transform( aEstoque[nPos][3] , "@E 99,999,999,999.99")
		//	@nLin,110 Psay Transform( (B2_QATU - B2_RESERVA), "@E 99,999,999,999.99")

		@nLin,110 Psay Transform( (cAlias)->B2_QATU, "@E 99,999,999,999.99")
		@nLin,130 Psay IIf( MV_PAR22 == 1, ' R$', 'US$')
		@nLin,156 Psay Transform(nPrdUnit,"@E 99,999,999.999999" )
		@nLin,167 Psay Transform(nVlrItem,"@E 999,999,999.99" )
		@nLin,206 PSAY (cAlias)->ZA0_NAME
		//	@nLin,206 Psay Transform(nVlrItem,"@E 999,999,999.99" )

		nLin++

		dbSkip()
	EndDo

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณR093Excel บAutor  ณGiane               บ Data ณ  20/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o arquivo excel com todos os registros referente aos  บฑฑ
ฑฑบ          ณparametros digitados pelo usuแrio.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function R093Excel()

	Local nHandle   := 0
	Local cArquivo  := " "
	Local cDirDocs  := MsDocPath()
	Local cPath     := AllTrim(GetTempPath())
	Local aCabec := {}
	Local cBuffer
	Local nQtdReg
	Local titulo
	Local nVlrItem := 0
	Local nPrdUnit := 0
	Local nVlrSite := 0
	Local nVlrCS := 0

	//Local aUsu := AllUsers()
	Local cCod := ""

	Local aEstoque := {}
	Local nX := 0

	cArquivo += "REL_PEDIDOS_A_FATURAR_"+DTOS(DATE())+STRTRAN(TIME(),":","")+".CSV"

	nHandle := FCreate(cDirDocs + "\" + cArquivo)

	If nHandle == -1
		MsgStop("Erro na criacao do arquivo na estacao local. Contate o administrador do sistema")
		Return
	EndIf

	DbSelectArea(cAlias)
	COUNT TO nQtdReg
	ProcRegua(nQtdReg)
	dbGotop()

	Titulo := "Relatorio de Pedidos a Faturar"
	If MV_PAR22 == 1
		titulo += " - Em Reais"
	Else
		titulo += " - Em Dolar"
	Endif

	Acabec := {"Pedido","Cliente","Loja","Nome Fantasia","Emissใo", "Nome Usuแrio", "Cod.Vendedor","Nome Vendedor",;
		"Cond.Pagamento","Data Entrega","Grupo Vendas","Item","Produto","Descri็ใo","Quantidade","Estoque Disponivel","Saldo em Estoque",;
		"Moeda","Valor Unitario", "Valor Unit s/IMP","Valor Total","Pedido Cliente","Item Ped Cliente","Pricipal","Lote","Obs Lote",;
		"Perm.Lot.Dif.","Fator Validade"}

	IF (__cUserId $ cXUSRCUS)

		aAdd(Acabec, "% ICMS")
		aAdd(Acabec, "% PIS/COF")
		aAdd(Acabec, "Valor sem Impostos")
		aAdd(Acabec, "Moeda Pedido")
		aAdd(Acabec, "Taxa Moeda Pedido")
		aAdd(Acabec, "Custo Produto Pedido")
		aAdd(Acabec, "Margem % Pedido")

		aAdd(Acabec, "Valor sem Impostos")
		aAdd(Acabec, "Taxa Moeda Atual")
		aAdd(Acabec, "Custo Produto Atual")
		aAdd(Acabec, "Margem % Atual")

	Endif

	FWrite(nHandle, Titulo) //imprime titulo do relatorio
	FWrite(nHandle, CRLF)
	FWrite(nHandle, CRLF)

	cBuffer := ""
	//imprime o cabecalho
	For nx := 1 To Len(aCabec)
		If nx == Len(aCabec)
			cBuffer += aCabec[nx]
		Else
			cBuffer += aCabec[nx] + ";"
		EndIf
	Next nx

	FWrite(nHandle, cBuffer)
	FWrite(nHandle, CRLF)

	dbGoTop()
	While !EOF()

		//cEmitente :=  UsrRetName( SubStr( Embaralha( (cAlias)->C5_USERLGI, 1 ), 3, 6 ) )  //Left(Embaralha((cAlias)->C5_USERLGI,1),15)
		cNomeEmi  := UsrRetName( SubStr( Embaralha( (cAlias)->C5_USERLGI, 1 ), 3, 6 ) )  //" "
		cCod := ""
		cCodVend := ""
		nVlrSIte :=0
		nVlrItem := 0
		nVlrCS := 0
		/*
		//Procura o codigo do usuario que incluiu o pedido de vendas
		If (cAlias)->C5_EMISSAO <= '20120930'

			For i:= 1 to len(aUsu)
				If LEFT(aUsu[i,1,2],15) == LEFT(cEmitente,15)
					cCod := aUsu[i,1,1]
				Endif
			Next
		Else
			For i:= 1 to len(aUsu)
				If LEFT(aUsu[i,1,1],6) == substr(cEmitente,3,6)
					cCod    := aUsu[i,1,1]
					cNomeEmi:= LEFT(aUsu[i,1,2],15)
				Endif
			Next
		EndIf
		*/
		//procura o codigo do vendedor deste usuario
		If !empty(cCod)
			if SA3->(DbSeek( xFilial("SA3") + cCod ))
				cCodVend := SA3->A3_COD
			Endif
		Endif

		if (.not.(cCodVend >= MV_PAR17 .and. cCodVend <= MV_PAR18)) .and. !EMPTY(cCodVend)
			DbSkip()
			loop
		endif

		cBuffer :=  '="' + (cAlias)->C5_NUM + '"' +  ";"
		cBuffer +=  '="' + (cAlias)->C5_CLIENTE + '"' +  ";"
		cBuffer +=  '="' + (cAlias)->C5_LOJACLI + '"' + ";"
		cBuffer +=  (cAlias)->A1_NREDUZ + ";"

		cBuffer += DTOC( stod((cAlias)->C5_EMISSAO) ) + ";"

		//cBuffer +=  '="' + cCodVend  + '"' + ";"
		cBuffer += cNomeEmi + ";"
		cBuffer +=  '="' + (cAlias)->C5_VEND1 + '"' +  ";"
		cBuffer += (cAlias)->A3_NREDUZ + ";"
		cBuffer += (cAlias)->E4_DESCRI + ";"
		cBuffer += DTOC( stod((cAlias)->C5_XENTREG) ) + ";"

		cBuffer += (cAlias)->C5_DGRPVEN + ";"
		cBuffer +=  '="' + (cAlias)->C6_ITEM + '"' +  ";"
		cBuffer +=  '="' + (cAlias)->C6_PRODUTO + '"' +  ";"
		cBuffer += (cAlias)->B1_DESC + ";"

		nPos := aScan( aEstoque, { |x|   x[01] == (cAlias)->C6_PRODUTO  .AND. x[4] == (cAlias)->B2_LOCAL })
		if nPos > 0
			aEstoque[nPos][3] -= (cAlias)->C6_QTDVEN
		Else
			aAdd(aEstoque,{(cAlias)->C6_PRODUTO ,(cAlias)->B2_QATU, (cAlias)->B2_QATU - (cAlias)->C6_QTDVEN, (cAlias)->B2_LOCAL } )
		Endif
		nPrdUnit := (cAlias)->C6_PRCVEN

		CalcItem(@nVlrItem,@nPrdUnit )
		CalcCS(@nVlrCS)

		nPos := aScan( aEstoque, { |x|   x[01] == (cAlias)->C6_PRODUTO .AND. x[4] == (cAlias)->B2_LOCAL })

		cBuffer += Transform( (cAlias)->C6_QTDVEN ,"@E  999,999.99" ) + ";"
		cBuffer += Transform( aEstoque[nPos][3], "@E 99,999,999,999.99")+ ";"
		cBuffer += Transform( (cAlias)->B2_QATU, "@E 99,999,999,999.99")  + ";"

		//	cBuffer += Transform( (cAlias)->C6_QTDVEN ,"@E  999,999.99" ) + ";"
		//	cBuffer += Transform( (B2_QATU - B2_RESERVA), "@E 99,999,999,999.99")+ ";"
		//	cBuffer += Transform( B2_QATU, "@E 99,999,999,999.99")  + ";"
		nimp := ( 100-((cAlias)->C6_XPISCOF+(cAlias)->C6_XICMEST) )/100
		cBuffer += IIf( MV_PAR22 == 1, ' R$', 'US$' ) + ";"
		cBuffer += Transform(nPrdUnit,"@E 99,999,999.999999" ) + ";"
		cBuffer += Transform(round(nPrdUnit*nimp,2)  ,"@E 99,999,999.99" ) + ";"
		cBuffer += Transform(nVlrItem,"@E 999,999,999.99" ) + ";"
		IF EMPTY((cAlias)->C6_PEDCLI)
			cBuffer += (cAlias)->C6_NUMPCOM + " ; "
			cBuffer += (cAlias)->C6_ITEMPC + " ; "
		ELSE
			cBuffer += (cAlias)->C6_PEDCLI + " ; "
			cBuffer += (cAlias)->C6_ITEMPED + " ; "
		ENDIF
		cBuffer += (cAlias)->ZA0_NAME +  " ; "
		cBuffer += (cAlias)->B8_LOTECTL + " ; "
		cBuffer += (cAlias)->B8_XOBS + " ; "
		cBuffer += iif((cAlias)->A1_LOTEUNI=="1", "SIM", "NรO") + " ; "
		cBuffer += Transform((cAlias)->A1_FATVALI, x3Picture("A1_FATVALI")) + " ; "

		IF (__cUserId $ cXUSRCUS)

			cBuffer += Transform((cAlias)->C6_XICMEST,"@E 99,999,999.999999" ) + ";"
			cBuffer += Transform((cAlias)->C6_XPISCOF,"@E 99,999,999.999999" ) + ";"

			CalcSIte(@nVlrSIte)
			cBuffer += Transform(nVlrSIte,"@E 999,999,999.9999" ) + ";"

			cBuffer += Transform((cAlias)->C6_XMOEDA,"@E 9" ) + ";"

			nTaxa := 0
			if MV_PAR22 == 2 //converter para dolar o total do item
				nTaxa := (cAlias)->c6_xtaxa
				if (cAlias)->C6_XMEDIO != 'S'
					if MV_PAR23 == 1 .and. SM2->(DbSeek(dDataBase)) //usar database do sistema para a conversใo do valor
						nTaxa := SM2->M2_MOEDA2
					elseif MV_PAR23 == 2 .and. SM2->(DbSeek(stod((cAlias)->c5_emissao))) //usar data emissใo do pedido para a conversใo do valor
						nTaxa := SM2->M2_MOEDA2
					endif
				endif
			endif

			cBuffer += Transform(nTaxa,"@E 999.9999" ) + ";"

			if (cAlias)->c6_xcusto > 0
				nVlrCS := ( (cAlias)->c6_xcusto / (cAlias)->c6_xtaxa ) * iif(nTaxa > 0, nTaxa, 1 )
			else
				//sck->(DbSetOrder(1))
				//If !empty((cAlias)->c6_numorc) .and. sck->(DbSeek(xFilial()+(cAlias)->c6_numorc+(cAlias)->c6_produto))
				//	nVlrCS	:= SCK->CK_XCUSTO
				//else
				nPrcTot := (cAlias)->c6_prcven * ((1-(((cAlias)->c6_xicmest+(cAlias)->c6_xpiscof)/100)))
				nXVrMarg := (cAlias)->c6_xvrmarg/(cAlias)->c6_qtdven
				nVlrCS := Round( (nPrcTot-nXVrMarg) / iif(nTaxa > 0, nTaxa, 1 ) ,2)
				//Endif
			endif
			nMargem := Round( (((nPrdUnit*((100-((calias)->c6_xicmest+(calias)->c6_xpiscof))/100))-nVlrCS)/(nPrdUnit*((100-((calias)->c6_xicmest+(calias)->c6_xpiscof))/100))/1)*100 ,2)

			cBuffer += Transform( nVlrCS  ,"@E 999,999,999.99" ) + ";"
			cBuffer += Transform( nMargem ,"@E 99,999,999.99" ) + "%;"

			///14/09/2018 - solicita็ใo Denis
			//nTaxa := 0
			//if MV_PAR22 == 2 //converter para dolar o total do item
			nTaxa := (cAlias)->c6_xtaxa
			If (cAlias)->C6_XMEDIO != 'S' .and. SM2->(DbSeek(dDataBase))
				nTaxa := SM2->M2_MOEDA2
			endif
			//endif

			nVlrSIteNV := iif(MV_PAR22 == 2, (nVlrSIte / (cAlias)->C6_XTAXA) * nTaxa ,nVlrSIte )
			cBuffer += Transform(nVlrSIteNV,"@E 999,999,999.9999" ) + ";"
			cBuffer += Transform(nTaxa,"@E 999.9999" ) + ";"

			nPrdUnit := iif(MV_PAR22 == 2, round((cAlias)->C6_PRCVEN / nTaxa,2), (cAlias)->C6_PRCVEN )

			nVlrCS :=  ( (cAlias)->B1_CUSTD / nTaxa ) * iif( MV_PAR22 == 2, nTaxa, 1)
			//aAreaAlias := GetArea()
			//aRet := U_BSCMARG((cAlias)->C5_TABELA,(cAlias)->C6_PRODUTO,(cAlias)->C6_QTDVEN,3)
			//cMoed := aRet[1]  //'USD' dolar 'BRL' real
			//nVlrCS := aRet[3]  //custo
			//RestArea(aAreaAlias)
			nMargem := Round( (((nPrdUnit*((100-((calias)->c6_xicmest+(calias)->c6_xpiscof))/100))-nVlrCS)/(nPrdUnit*((100-((calias)->c6_xicmest+(calias)->c6_xpiscof))/100))/1)*100 ,2)

			cBuffer += Transform( nVlrCS ,"@E 999,999,999.99" ) + ";"
			cBuffer += Transform( nMargem  ,"@E 99,999,999.99" ) + "%;"

		Endif
		FWrite(nHandle, cBuffer)
		FWrite(nHandle, CRLF)

		Dbskip()
	Enddo

	FClose(nHandle)

// copia o arquivo do servidor para o remote
	CpyS2T(cDirDocs + "\" + cArquivo, cPath, .T.)

	IF ! ApOleClient("MsExcel")
		alert ( "EXCEL nใo localizado. Abra o arquivo em:"+CRLF+cPath + cArquivo )
	else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cPath + cArquivo)
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
		MSGINFO(  "Arquivo gerado em:"+cPath + cArquivo,"RFAT093B" )
	Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcItem  บAutor  ณ Giane              บ Data ณ 10/09/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calcula valor total do item caso tenha conversao de moeda  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function CalcItem(nVlrItem,nPrdUnit )
	Local nValorIpi := 0
	Local dData := ctod('')
	Local nTaxa := 0

	nVlrItem := (cAlias)->C6_VALOR
	If MV_PAR21 == 2 //soma ipi ao total do item
		If (cAlias)->F4_IPI == "S"
			nValorIPI := (cAlias)->C6_VALOR * ((cAlias)->B1_IPI / 100)
			nVlrItem  := (cAlias)->C6_VALOR + nValorIPI
		Endif
	Endif

	If MV_PAR22 == 2 //converter para dolar o total do item
		If MV_PAR23 == 1
			//usar database do sistema para a conversใo do valor
			dData := dDataBase
		Else
			//usar data emissao do pedido para a conversao
			dData := STOD((cAlias)->C5_EMISSAO)
		Endif

		if (cAlias)->C6_XMEDIO == 'N'
			nTaxa := (cAlias)->C6_XTAXA
		else
			nTaxa := U_BSCTAXAPV(2, 'D') //moeda 2 Diaria
				dbSelectArea(cAlias)
		endif

		if (cAlias)->C6_XMOEDA == 2 //dolar
			nTaxa := IIF(MV_PAR23 == 1, nTaxa, (cAlias)->C6_XTAXA)
			nVlrItem := ((cAlias)->C6_PRCVEN /nTaxa)  * (cAlias)->C6_QTDVEN
			nPrdUnit := iif(nTaxa > 0, round(nPrdUnit / nTaxa,2), nPrdUnit )
		Else
			nVlrItem := iif(nTaxa > 0, round(nVlrItem / nTaxa,2), nVlrItem )
			nPrdUnit := iif(nTaxa > 0, round(nPrdUnit / nTaxa,2), nPrdUnit )
		Endif

	Endif

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcSIte  บAutor  ณ Giane              บ Data ณ 10/09/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calcula valor total SEM IMPOSTOS  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function CalcSIte(nVlrSIte)

	//C6_XICMEST, C6_XPISCOF, C6_XMEDIO, C6_XTAXA
	nVlrSIte  := (cAlias)->C6_VALOR -  (cAlias)->C6_VALOR * (((cAlias)->C6_XICMEST +  (cAlias)->C6_XPISCOF)/100)

Return


Static Function CalcCS(nVlrCS)

	//C6_XICMEST, C6_XPISCOF, C6_XMEDIO, C6_XTAXA , B1_CUSTD
	nVlrCS  := ((cAlias)->B1_CUSTD * (cAlias)->C6_XTAXA) * (cAlias)->C6_QTDVEN

Return
