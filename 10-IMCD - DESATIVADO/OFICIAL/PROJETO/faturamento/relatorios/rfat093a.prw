#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT093A  บ Autor ณ Giane              บ Data ณ  06/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Pedidos de Venda                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Makeni                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RFAT093A

	Local aArea := GetArea()
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Relat๓rio de Pedidos de Venda IMCD"
	Local nLin           := 80
	Local cQuery         := ""

	Local Cabec1         := "Pedido Status     Cliente   Nome Fantasia        Emissใo  Usuแrio Emitente                 Vendedor                         Cond.Pagamento                           Entrega            Grupo Vendas"
	Local Cabec2         := "  Item Produto                                                                                    Quantidade     Estoque Disp.        Saldo Estoque        Moeda     Valor Unitแrio              Valor total"
//123456 123456 99 12345678901234567890 99/99/99 000002 1234567890123456789012345 000002 1234567890123456789012345 1234567890123456789012345678901234567890 99/99/99            123456789012345678901234567890
//    99 123456789012345 1234567890123456789012345678901234567890123456789012345678901234567890   999,999.99   99,999,999,999.99   99,999,999,999.99          uSS   99,999,999.999999           999,999,999.99
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
//         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16         17        18        19
	Local aOrd           := {"Nr.Pedido + Item","Data Entrega + Nr.Pedido + Item"}
	Local cPerg          := "RFAT093A"
/*
Local aConf          := {}
Local lGerente       := .f.
Local lVendedor      := .f.
Local cGrpAcesso     := ""
*/
	Private cTitulo         := cDesc3
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RFAT093A" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RFAT093A" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cAlias       := "SC6"

	Private cXUSRCUS := GetMv("ES_RFAT093")

	if !Pergunte(cPerg)
		return
	Endif

	if MV_PAR22 = 1
		cTitulo += " - Em Reais"
	Else
		cTitulo += " - Em Dolar"
	Endif

	Cabec2 += "  Pedido Cliente   Num.Ped.Comp   Item.Ped.Com "

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

	If MV_PAR25 <> 2
		wnrel := SetPrint(cAlias,NomeProg,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.f.)
		If nLAstKey == 27
			Return
		Endif
	Endif

	cAlias := "XSC6"

	cQuery := "SELECT DISTINCT"
	cQuery += "  SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SA1.A1_NREDUZ, SC5.C5_EMISSAO, SC5.C5_USERLGI,  "
	cQuery += "  SC5.C5_VEND1, SA3.A3_NREDUZ, SE4.E4_DESCRI, SC5.C5_XENTREG, C5_GRPVEN, C5_DGRPVEN, SC6.C6_ITEM, "
	cQuery += "  SC6.C6_PRODUTO, SB1.B1_DESC, SC6.C6_QTDVEN, SC6.C6_XMOEDA, SC6.C6_PRCVEN, SC6.C6_VALOR, "
	cQuery += "  SF4.F4_IPI, SB1.B1_IPI, SC6.C6_LOCAL, SB2.B2_QATU, SB2.B2_RESERVA, SC6.C6_XPRUNIT, "
	cQuery += "  SC6.C6_XICMEST, SC6.C6_XPISCOF, SC6.C6_XMEDIO, SC6.C6_XTAXA, SB1.B1_CUSTD "
	cQuery += "  , SC6.C6_XVLRINF, C6_BLQ,SC6.C6_NOTA,SC5.C5_X_CANC, C5_X_REP, ZA0.ZA0_NAME "
	cQuery += "  , C5_XPEDCLI, C6_NUMPCOM, C6_ITEMPC , C5_NOTA "
	cQuery += "FROM " + RetSqlName("SC6") + " SC6 "
	cQuery += "  JOIN " + RetSqlName("SC5") + " SC5 ON "
	cQuery += "    SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND "
	cQuery += "    SC5.C5_NUM = SC6.C6_NUM AND  "
	cQuery += "    SC5.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "    SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cQuery += "    SB1.B1_COD = SC6.C6_PRODUTO AND "
	cQuery += "    SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQuery += "    SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "
	cQuery += "    SA1.A1_COD = SC5.C5_CLIENTE AND "
	cQuery += "    SA1.A1_LOJA = SC5.C5_LOJACLI AND "
	cQuery += "    SA1.D_E_L_E_T_ = ' ' "
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
	cQuery += "   LEFT JOIN "+ RetSqlName("ZA0") + " ZA0 ON "
	cQuery += "		ZA0.ZA0_FILIAL = '" + xFilial( "ZA0" ) + "' AND "
	cQuery += "		SB1.B1_X_PRINC = ZA0.ZA0_CODPRI AND "
	cQuery += "		ZA0.D_E_L_E_T_ = ' ' "

	cQuery += " WHERE "

	cQuery += "  SC6.C6_FILIAL = '" + xFilial("SC6") + "' "
//cQuery += "  AND SC6.C6_BLQ <> 'R' AND SC6.C6_NOTA = '         ' AND SC6.C6_SERIE = '  '  AND SC5.C5_X_CANC = ' '
	cQuery += "  AND SC6.D_E_L_E_T_ <> '*' AND "
	cQuery += "  SC5.C5_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "
	cQuery += "  SC5.C5_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' AND "
	cQuery += "  SC6.C6_PRODUTO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "
	cQuery += "  SB1.B1_GRUPO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' AND "
	cQuery += "  SC5.C5_GRPVEN BETWEEN  '" + MV_par09 + "' AND '" + MV_par10 + "' AND "
	cQuery += "  SC5.C5_CLIENTE BETWEEN  '"  + MV_PAR11 + "' AND  '"  + MV_PAR13 + "' AND "
	cQuery += "  SC5.C5_LOJACLI BETWEEN  '" + MV_PAR12 + "' AND '" + MV_PAR14 + "' AND "
	cQuery += "  SC5.C5_VEND1 BETWEEN  '" + MV_PAR15 + "' AND  '" + MV_PAR16 + "' AND "
	cQuery += "  SB1.B1_SEGMENT BETWEEN '" + MV_PAR19 + "' AND '" + MV_PAR20 + "' AND "
	cQuery += "  SB1.B1_X_PRINC BETWEEN '" + MV_PAR26 + "' AND '" + MV_PAR27 + "' "
	If MV_PAR24 == 1 //tes que gera duplicata
		cQuery += "  AND SF4.F4_DUPLIC = 'S'  "
	Elseif MV_PAR24 == 2
		cQuery += "  AND SF4.F4_DUPLIC = 'N'  "
	Endif

//	cQuery += "  and  C5_NUM in ('003112','001585','007379','004283','010784','000058') "

	cQuery += "  AND SC5.C5_GRPVEN BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "

	If aReturn[8] == 1
		cQuery += "ORDER BY C5_NUM, C6_ITEM	"
	Else
		cQuery += "ORDER BY C5_XENTREG, C5_NUM, C6_ITEM"
	Endif

	cQuery := ChangeQuery(cQuery)

//memowrite('c:\cfat030.sql',cquery)

	MsgRun("Selecionando registros, aguarde...",cTitulo, {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })

	DbSelectArea("SA3")
	DbSetOrder(7) //filial + cod.usuario

	DbSelectArea("SM2")
	DbSetOrder(1)

	dbSelectArea(cAlias)
	DbGotop()

	If MV_PAR25 == 1

		If nLastKey == 27
			Return
		Endif

		SetDefault(aReturn,cAlias)

		If nLastKey == 27
			Return
		Endif

		nTipo := If(aReturn[4]==1,15,18)

		RptStatus({|| RunReport(Cabec1,Cabec2,cTitulo,nLin) },cTitulo)

	Else
		//EXPORTAR PARA EXCEL
		MsgRun("Processando relat๓rio em Excel, aguarde...",cTitulo,{|| R093Excel()}  )
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

Static Function RunReport(Cabec1,Cabec2,cTitulo,nLin)
//Local aUsu := AllUsers()
	Local cCod := ""
	Local cCodVend := SPACE(6)
	Local cNum := ""
	Local nVlrItem := 0
	Local nVlrSIte := 0
	Local nVlrCS := 0

	dbSelectArea(cAlias)
	SetRegua(RecCount())

	dbGoTop()
	While !EOF()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//cEmitente :=  Left(Embaralha((cAlias)->C5_USERLGI,1),15)
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
			Cabec(cTitulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin:= 9
		Endif

		If (cAlias)->C5_NUM <> cNum  .or. nLin == 9
			if nLin > 9
				nLin++
			endif

			cStatus := " "
			If !Empty(aLLTRIM((cAlias)->C6_NOTA))
				cStatus := "Faturado"
			Elseif (cAlias)->C5_X_CANC == "C"
				cStatus := "Cancelado"
			Elseif (cAlias)->C5_X_REP == "R"
				cStatus := "Rejeitado"
			ElseIF  AllTrim((cAlias)->C6_BLQ) == 'R' .AND. 'X' $ (cAlias)->C5_NOTA
				cStatus := "Eliminado Residuo"
			Else
				cStatus := "Em Aberto"
			Endif

			@nLin,000 PSAY (cAlias)->C5_NUM
			@nLin,007 PSAY cStatus
			@nLin,017 Psay (cAlias)->C5_CLIENTE + space(01) + (cAlias)->C5_LOJACLI + space(01) + (cAlias)->A1_NREDUZ
			@nLin,049 Psay STOD((calias)->C5_EMISSAO)
			@nLin,058 Psay cNomeEmi
			@nLin,091 Psay (cAlias)->C5_VEND1 + space(01) + (cAlias)->A3_NREDUZ
			@nLin,124 Psay (cAlias)->E4_DESCRI
			@nLin,165 Psay STOD((cAlias)->C5_XENTREG)
			@nLin,175 Psay (cAlias)->C5_DGRPVEN
			nLin++
			cNum := (cAlias)->C5_NUM
		Endif

		CalcItem(@nVlrItem)
		CalcItem(@nVlrCS)

		@nLin,000 Psay (cAlias)->C6_ITEM
		@nLin,004 Psay (cAlias)->C6_PRODUTO + SPACE(01) + (cAlias)->B1_DESC
		@nLin,07 Psay Transform((cAlias)->C6_QTDVEN,"@E 999,999.99" )

		@nLin,098 Psay Transform( (B2_QATU - B2_RESERVA), "@E 99,999,999,999.99")

		@nLin,110 Psay Transform( B2_QATU, "@E 99,999,999,999.99")
		@nLin,130 Psay IIf( (cAlias)->C6_XMOEDA ==1, ' R$', 'US$')
		@nLin,156 Psay Transform((cAlias)->C6_PRCVEN,"@E 99,999,999.999999" )
		@nLin,162 Psay Transform(nVlrItem,"@E 999,999,999.99" )
		@nLin,206 PSAY (cAlias)->C5_ZA0_NAME
		@nLin,230 PSAY (cAlias)->C5_XPEDCLI
		@nLin,250 PSAY (cAlias)->C6_NUMPCOM
		@nLin,270 PSAY (cAlias)->C6_ITEMPC
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
	Local cArquivo  := CriaTrab(,.F.)
	Local cDirDocs  := MsDocPath()
	Local cPath     := AllTrim(GetTempPath())
	Local aCabec := {}
	Local cBuffer
	Local nQtdReg
	Local nVlrItem := 0
	Local nVlrSite := 0
	Local nVlrCS := 0

//Local aUsu := AllUsers()
	Local cCod := ""
	Local nX := 0

	cArquivo += ".CSV"

	nHandle := FCreate(cDirDocs + "\" + cArquivo)

	If nHandle == -1
		MsgStop("Erro na criacao do arquivo na estacao local. Contate o administrador do sistema")
		Return
	EndIf

	DbSelectArea(cAlias)
	COUNT TO nQtdReg
	ProcRegua(nQtdReg)
	dbGotop()

	If MV_PAR22 == 1
		cTitulo += " - Em Reais"
	Else
		cTitulo += " - Em Dolar"
	Endif

	Acabec := {"Pedido","Status","Cliente","Loja","Nome Fantasia","Emissใo", "Usuแrio Emitente","Nome Usuแrio", "Cod.Vendedor","Nome Vendedor","Cond.Pagamento",;
		"Data Entrega","Grupo Vendas","Item","Produto","Descri็ใo","Quantidade","Estoque Disponivel","Saldo em Estoque","Moeda","Valor Unitario","Valor Total","Pricipal"}

	IF (__cUserId $ cXUSRCUS)
		aAdd(Acabec, "Valor sem Impostos")
		aAdd(Acabec, "Taxa Moeda Pedido")
		aAdd(Acabec, "% ICMS")
		aAdd(Acabec, "% PIS/COF")
		aAdd(Acabec, "Custo Produto")
		aAdd(Acabec, "Margem")
	Endif
	aAdd(Acabec, "Pedido Cliente ")
	aAdd(Acabec, "Num.Ped.Comp")
	aAdd(Acabec, "Item.Ped.Com")

	FWrite(nHandle, cTitulo) //imprime titulo do relatorio
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

		//cEmitente :=  Left(Embaralha((cAlias)->C5_USERLGI,1),15)
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

		if (.not.(cCodVend >= MV_PAR17 .and. cCodVend <= MV_PAR18)) .and. !EMPTY(cCodVend)
			DbSkip()
			loop
		endif

		cStatus := " "
		If !Empty(aLLTRIM((cAlias)->C6_NOTA))
			cStatus := "Faturado"
		Elseif (cAlias)->C5_X_CANC == "C"
			cStatus := "Cancelado"
		Elseif (cAlias)->C5_X_REP == "R"
			cStatus := "Rejeitado"
		ElseIF  AllTrim((cAlias)->C6_BLQ) == 'R' .AND. 'X' $ (cAlias)->C5_NOTA
			cStatus := "Eliminado Residuo"
		Else
			cStatus := "Em Aberto"
		Endif

		cBuffer :=  '="' + (cAlias)->C5_NUM + '"' +  ";"
		cBuffer +=  '="' + cStatus + '"' +  ";
			cBuffer +=  '="' + (cAlias)->C5_CLIENTE + '"' +  ";"
		cBuffer +=  '="' + (cAlias)->C5_LOJACLI + '"' + ";"
		cBuffer +=  (cAlias)->A1_NREDUZ + ";"

		cBuffer += DTOC( stod((cAlias)->C5_EMISSAO) ) + ";"

		cBuffer +=  '="' + cCodVend  + '"' + ";"
		cBuffer += cNomeEmi + ";"
		cBuffer +=  '="' + (cAlias)->C5_VEND1 + '"' +  ";"
		cBuffer += (cAlias)->A3_NREDUZ + ";"
		cBuffer += (cAlias)->E4_DESCRI + ";"
		cBuffer += DTOC( stod((cAlias)->C5_XENTREG) ) + ";"

		cBuffer += (cAlias)->C5_DGRPVEN + ";"
		cBuffer +=  '="' + (cAlias)->C6_ITEM + '"' +  ";"
		cBuffer +=  '="' + (cAlias)->C6_PRODUTO + '"' +  ";"
		cBuffer += (cAlias)->B1_DESC + ";"

		cBuffer += Transform( (cAlias)->C6_QTDVEN ,"@E  999,999.99" ) + ";"
		cBuffer += Transform( (B2_QATU - B2_RESERVA), "@E 99,999,999,999.99")+ ";"
		cBuffer += Transform( B2_QATU, "@E 99,999,999,999.99")  + ";"

		cBuffer += IIf( (cAlias)->C6_XMOEDA ==1, ' R$', IIF((cAlias)->C6_XMOEDA ==2,'US$',"EUR")) + ";"
		cBuffer += Transform((cAlias)->C6_PRCVEN,"@E 99,999,999.999999" ) + ";"

		CalcItem(@nVlrItem)
		cBuffer += Transform(nVlrItem,"@E 999,999,999.99" ) + ";"

		cBuffer +=  '="' + (cAlias)->ZA0_NAME + '"' +  ";"

		IF (__cUserId $ cXUSRCUS)
			CalcSIte(@nVlrSIte)
			cBuffer += Transform(nVlrSIte,"@E 999,999,999.99" ) + ";"

			cBuffer += Transform((cAlias)->C6_XTAXA,"@E 999.999" ) + ";"

			cBuffer += Transform((cAlias)->C6_XICMEST,"@E 99,999,999.999999" ) + ";"

			cBuffer += Transform((cAlias)->C6_XPISCOF,"@E 99,999,999.999999" ) + ";"

			CalcCS(@nVlrCS)
			cBuffer += Transform(nVlrCS,"@E 999,999,999.99" ) + ";"

			cBuffer += Transform((nVlrSIte-nVlrCS),"@E 99,999,999.999999" ) + ";"

		Endif
		cBuffer += (cAlias)->C5_XPEDCLI+";"
		cBuffer += (cAlias)->C6_NUMPCOM+";"
		cBuffer += (cAlias)->C6_ITEMPC+";"

		FWrite(nHandle, cBuffer)
		FWrite(nHandle, CRLF)

		Dbskip()
	Enddo

	FClose(nHandle)

// copia o arquivo do servidor para o remote
	CpyS2T(cDirDocs + "\" + cArquivo, cPath, .T.)

	IF ! ApOleClient("MsExcel")
		alert ("EXCEL nใo localizado. Abra o arquivo em:" + CRLF+cPath + cArquivo )
	else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cPath + cArquivo)
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
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

Static Function CalcItem(nVlrItem)
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

		If SM2->(DbSeek(dData))
		nTaxa := SM2->M2_MOEDA2
		endif

		if (cAlias)->C6_XMOEDA == 2 //dolar //14/09/2018
		nVlrItem := iif((cAlias)->C6_XVLRINF >0 ,C6_XVLRINF,(cAlias)->C6_XPRUNIT) * (cAlias)->C6_QTDVEN
		Else
		nVlrItem := iif(nTaxa > 0, round(nVlrItem / nTaxa,2), nVlrItem )
		Endif

	Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcItem  บAutor  ณ Giane              บ Data ณ 10/09/2010  บฑฑ
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

//C6_XICMEST, C6_XPISCOF, C6_XMEDIO, C6_XTAXA ,

// MUDAR PARA TAXA DO DIA
nVlrCS  := ((cAlias)->B1_CUSTD *  (cAlias)->C6_XTAXA) * (cAlias)->C6_QTDVEN

Return
