
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFAT093   � Autor � Giane              � Data �  06/09/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Pedidos a Faturar                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Makeni                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RFAT093

	If cEmpAnt $ '02|04'
		U_RFAT093B()
	Else
		RFAT093()
	Endif

Return()
Static Function RFAT093
	Local aArea := GetArea()
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Relat�rio de Pedidos a Faturar."

	Local titulo         := "Relatorio de Pedidos a Faturar"
	Local nLin           := 80
	Local cQuery         := ""

	Local Cabec1         := "Pedido TP Cliente  Nome Fantasia        Emiss�o  Usu�rio Emitente                 Vendedor                         Cond.Pagamento                           Entrega            Grupo Vendas"
	Local Cabec2         := "  Item Produto                                                                                    Quantidade     Estoque Disp.        Saldo Estoque        Moeda     Valor Unit�rio              Valor total"
//123456 123456 99 12345678901234567890 99/99/99 000002 1234567890123456789012345 000002 1234567890123456789012345 1234567890123456789012345678901234567890 99/99/99            123456789012345678901234567890
//    99 123456789012345 1234567890123456789012345678901234567890123456789012345678901234567890   999,999.99   99,999,999,999.99   99,999,999,999.99          uSS   99,999,999.999999           999,999,999.99
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
//         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16         17        18        19

	Local aOrd           := {"Nr.Pedido + Item","Data Entrega + Nr.Pedido + Item"}
	Local cPerg          := "RFAT093"

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
	Private wnrel        := "RFAT093" // Coloque aqui o nome do arquivo usado para impressao em disco

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
MsgStop("USUARIO SEM PERMISSAO - REGRA DE CONFIDENCIALIDADE","Aten��o!")
RestArea( aArea )
Return
	Endif

lGerente := aConf[2]
lVendedor := aConf[4]

*/
//============================================================================

	//If MV_PAR25 <> 2
	wnrel := SetPrint(cAlias,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.f.)
	If nLAstKey == 27
		Return
	Endif
	//Endif

	cAlias := GetNextAlias()

	cQuery := "SELECT DISTINCT"
	cQuery += "  SC5.C5_NUM, C5_TIPO, SC5.C5_CLIENTE, SC5.C5_LOJACLI, "

	cQuery += " CASE WHEN C5_TIPO NOT IN ('B','D') "
	cQuery += " THEN SA1.A1_NREDUZ "
	cQuery += " ELSE SA2.A2_NREDUZ "
	cQuery += ' END "A1_NREDUZ", '

	cQuery += "  SC5.C5_EMISSAO, SC5.C5_USERLGI, SC5.C5_VEND1, SA3.A3_NREDUZ, "
	cQuery += "  SE4.E4_DESCRI, SC5.C5_XENTREG, C5_GRPVEN, C5_DGRPVEN, SC6.C6_ITEM, SC6.C6_PRODUTO, SB1.B1_DESC, SC6.C6_QTDVEN, "
	cQuery += "  SC6.C6_XMOEDA, SC6.C6_PRCVEN, SC6.C6_VALOR, SF4.F4_IPI, SB1.B1_IPI, SC6.C6_LOCAL, SB2.B2_QATU, SB2.B2_RESERVA, SC6.C6_XPRUNIT, "
	cQuery += "  SC6.C6_XICMEST, SC6.C6_XPISCOF, SC6.C6_XMEDIO, SC6.C6_XTAXA, SB1.B1_CUSTD, SC6.C6_XVLRINF, ZA0.ZA0_NAME,SC6.C6_NUMPCOM,SC6.C6_ITEMPC , SC6.C6_PEDCLI , SC6.C6_ITEMPED "
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

	cQuery += "  LEFT JOIN " + RetSqlName("SA2") + " SA2 ON "
	cQuery += "    SA2.A2_FILIAL = '" + xFilial("SA2") + "' AND "
	cQuery += "    SA2.A2_COD = SC5.C5_CLIENTE AND "
	cQuery += "    SA2.A2_LOJA = SC5.C5_LOJACLI AND "
	cQuery += "    SA2.D_E_L_E_T_ = ' ' "

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

	cQuery += "WHERE "

	cQuery += "  SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.C6_BLQ <> 'R' AND "
	cQuery += "  SC6.C6_NOTA = ' ' AND SC6.C6_SERIE = '  '  AND "
	cQuery += "  SC6.D_E_L_E_T_ = ' '  AND "
	cQuery += "  SC5.C5_X_CANC = ' '  AND  SC5.C5_X_REP = ' '   AND "

	cQuery += "  SC5.C5_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "
	cQuery += "  SC6.C6_ENTREG BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' AND "
	cQuery += "  SC6.C6_PRODUTO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "
	cQuery += "  SB1.B1_GRUPO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' AND "
	cQuery += "  SC5.C5_GRPVEN BETWEEN '" + MV_par09 + "' AND '" + MV_par10 + "' AND "
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
		cQuery += "ORDER BY SC5.C5_NUM, SC6.C6_ITEM	"
	Else
		cQuery += "ORDER BY SC5.C5_XENTREG, SC5.C5_NUM, SC6.C6_ITEM"
	Endif

	cQuery := ChangeQuery(cQuery)

//memowrite('c:\cfat030.sql',cquery)

	MsgRun("Selecionando registros, aguarde...","Relat�rio Pedidos a Faturar", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })

	DbSelectArea("SA3")
	DbSetOrder(7) //filial + cod.usuario

	DbSelectArea("SM2")
	DbSetOrder(1)

	dbSelectArea(cAlias)
	DbGotop()

	If nLastKey == 27
		Return
	Endif

	If MV_PAR25 == 1
		//EXPORTAR PARA EXCEL
		MsgRun("Processando relat�rio em Excel, aguarde...","Relat�rio Pedidos a Faturar",{|| R093Excel()}  )

	Else

		SetDefault(aReturn,cAlias)

		If nLastKey == 27
			Return
		Endif

		nTipo := If(aReturn[4]==1,15,18)

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

	Endif

	(cAlias)->(DbCloseArea())

	RestArea(aArea)
Return

/*/
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  04/03/10   ���
	�������������������������������������������������������������������������͹��
	���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
	���          � monta a janela com a regua de processamento.               ���
	�������������������������������������������������������������������������͹��
	���Uso       � Programa principal                                         ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local cEmitente := ""
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
			@nLin,000 PSAY (cAlias)->C5_NUM+" "+(cAlias)->C5_TIPO
			@nLin,007 Psay (cAlias)->C5_CLIENTE + space(01)  +(cAlias)->C5_LOJACLI + space(01) + (cAlias)->A1_NREDUZ
			@nLin,038 Psay STOD((calias)->C5_EMISSAO)
			If !Empty(cNomeEmi)
				@nLin,047 Psay cCodVend + space(01) + cNomeEmi
			Else
				@nLin,047 Psay cCodVend + space(01) + cEmitente
			EndIf
			@nLin,080 Psay (cAlias)->C5_VEND1 + space(01) + (cAlias)->A3_NREDUZ
			@nLin,113 Psay (cAlias)->E4_DESCRI
			@nLin,154 Psay STOD((cAlias)->C5_XENTREG)
			IF Empty((cAlias)->C6_PEDCLI)
				@nLin,174 Psay Alltrim((cAlias)->C6_NUMPCOM)
			ELSE
				@nLin,174 Psay Alltrim((cAlias)->C6_PEDCLI)
			ENDIF
			@nLin,194 Psay (cAlias)->C5_DGRPVEN
			nLin++
			cNum := (cAlias)->C5_NUM

		Endif

		nPrdUnit := (cAlias)->C6_PRCVEN
		CalcItem(@nVlrItem,@nPrdUnit )
		CalcCS(@nVlrCS)

		@nLin,004 Psay (cAlias)->C6_ITEM
		@nLin,007 Psay (cAlias)->C6_PRODUTO + SPACE(01) + (cAlias)->B1_DESC
		@nLin,098 Psay Transform((cAlias)->C6_QTDVEN,"@E 999,999.99" )

		@nLin,110 Psay Transform( (B2_QATU - B2_RESERVA), "@E 99,999,999,999.99")

		@nLin,130 Psay Transform( B2_QATU, "@E 99,999,999,999.99")
		@nLin,156 Psay IIf( MV_PAR22 == 1, ' R$', 'US$')
		@nLin,162 Psay Transform(nPrdUnit,"@E 99,999,999.999999" )
		@nLin,190 Psay Transform(nVlrItem,"@E 999,999,999.99" )
		@nLin,206 PSAY (cAlias)->ZA0_NAME
		//@nLin,206 Psay Transform(nVlrItem,"@E 999,999,999.99" )

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �R093Excel �Autor  �Giane               � Data �  20/07/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta o arquivo excel com todos os registros referente aos  ���
���          �parametros digitados pelo usu�rio.                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R093Excel()

	Local nHandle   := 0
	Local cArquivo  := ""
	Local cDirDocs  := MsDocPath()
	Local cPath     := AllTrim(GetTempPath())
	Local aCabec := {}
	Local cBuffer
	Local nQtdReg
	Local titulo
	Local nVlrItem := 0
	Local nVlrSite := 0
	Local nVlrCS := 0

//Local aUsu := AllUsers()
	Local cCod := ""
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

	Acabec := {"Pedido","Tipo","Cliente","Loja","Nome Fantasia","Emiss�o", "Usu�rio Emitente","Nome Usu�rio", "Cod.Vendedor","Nome Vendedor","Cond.Pagamento",;
		"Data Entrega","Numero da OC","Grupo Vendas","Item","Produto","Descri��o","Quantidade","Estoque Disponivel","Saldo em Estoque","Moeda","Valor Unitario","Valor Total","Pricipal"}
	IF (__cUserId $ cXUSRCUS)
		aAdd(Acabec, "Valor sem Impostos")
		aAdd(Acabec, "Taxa Moeda Pedido")
		aAdd(Acabec, "% ICMS")
		aAdd(Acabec, "% PIS/COF")
		aAdd(Acabec, "Custo Produto")
		aAdd(Acabec, "Margem")
		aAdd(Acabec, "Valor sem Impostos")
		aAdd(Acabec, "Taxa Moeda Atual")
		aAdd(Acabec, "Custo Produto")
		aAdd(Acabec, "Margem")

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
		cBuffer +=  '="' + (cAlias)->C5_TIPO + '"' +  ";"
		cBuffer +=  '="' + (cAlias)->C5_CLIENTE + '"' +  ";"
		cBuffer +=  '="' + (cAlias)->C5_LOJACLI + '"' + ";"
		cBuffer +=  (cAlias)->A1_NREDUZ + ";"

		cBuffer += DTOC( stod((cAlias)->C5_EMISSAO) ) + ";"

		cBuffer +=  '="' + cCodVend  + '"' + ";"
		If !Empty(cNomeEmi)
			cBuffer += cNomeEmi + ";"
		EndIf
		cBuffer +=  '="' + (cAlias)->C5_VEND1 + '"' +  ";"
		cBuffer += (cAlias)->A3_NREDUZ + ";"
		cBuffer += (cAlias)->E4_DESCRI + ";"
		cBuffer += DTOC( stod((cAlias)->C5_XENTREG) ) + ";"
		IF EMPTY((cAlias)->C6_PEDCLI)
			cBuffer += (cAlias)->C6_NUMPCOM + " ; "
		ELSE
			cBuffer += (cAlias)->C6_PEDCLI + " ; "
		ENDIF

		cBuffer += (cAlias)->C5_DGRPVEN + ";"
		cBuffer +=  '="' + (cAlias)->C6_ITEM + '"' +  ";"
		cBuffer +=  '="' + (cAlias)->C6_PRODUTO + '"' +  ";"
		cBuffer += (cAlias)->B1_DESC + ";"

		cBuffer += Transform( (cAlias)->C6_QTDVEN ,"@E  999,999.99" ) + ";"
		cBuffer += Transform( (B2_QATU - B2_RESERVA), "@E 99,999,999,999.99")+ ";"
		cBuffer += Transform( B2_QATU, "@E 99,999,999,999.99")  + ";"

		nPrdUnit := (cAlias)->C6_PRCVEN
		CalcItem(@nVlrItem,@nPrdUnit )
		CalcCS(@nVlrCS)

		cBuffer += IIf( MV_PAR22 == 1, ' R$', 'US$' ) + ";"
		cBuffer += Transform(nPrdUnit,"@E 99,999,999.999999" ) + ";"

		cBuffer += Transform(nVlrItem,"@E 999,999,999.99" ) + ";"

		cBuffer +=  '="' + (cAlias)->ZA0_NAME + '"' +  ";"

		IF (__cUserId $ cXUSRCUS)
			CalcSIte(@nVlrSIte)
			cBuffer += Transform(nVlrSIte,"@E 999,999,999.9999" ) + ";"

			cBuffer += Transform((cAlias)->C6_XTAXA,"@E 999.9999" ) + ";"

			cBuffer += Transform((cAlias)->C6_XICMEST,"@E 99,999,999.999999" ) + ";"

			cBuffer += Transform((cAlias)->C6_XPISCOF,"@E 99,999,999.999999" ) + ";"

			CalcCS(@nVlrCS)
			cBuffer += Transform(nVlrCS,"@E 999,999,999.9999" ) + ";"

			cBuffer += Transform((nVlrSIte-nVlrCS),"@E 99,999,999.999999" ) + ";"


			///14/09/2018 - solicita��o Denis

			if (cAlias)->C6_XMEDIO == 'N'
				nTaxa := (cAlias)->C6_XTAXA
			else
				nTaxa := U_BSCTAXAPV(2, 'D') //moeda 2 Diaria
				dbSelectArea(cAlias)
			endif

			nVlrSIteNV := iif(nTaxa > 0, (nVlrSIte / (cAlias)->C6_XTAXA)* nTaxa ,nVlrSIte )
			cBuffer += Transform(nVlrSIteNV,"@E 999,999,999.9999" ) + ";"

			cBuffer += Transform(nTaxa,"@E 999.9999" ) + ";"

			nCalcCSNv := iif(nTaxa > 0, (nVlrCS / (cAlias)->C6_XTAXA)* nTaxa ,nVlrCS )
			cBuffer += Transform( nCalcCSNv ,"@E 999,999,999.9999" ) + ";"

			nCustoNV := ((nVlrSIte-nVlrCS)/(cAlias)->C6_XTAXA) * nTaxa
			cBuffer += Transform(nCustoNV,"@E 99,999,999.999999" ) + ";"

		Endif
		FWrite(nHandle, cBuffer)
		FWrite(nHandle, CRLF)

		Dbskip()
	Enddo

	FClose(nHandle)

// copia o arquivo do servidor para o remote
	CpyS2T(cDirDocs + "\" + cArquivo, cPath, .T.)

	IF ! ApOleClient("MsExcel")
		alert ( "EXCEL n�o localizado. Abra o arquivo em:"+CRLF+cPath + cArquivo )
	else

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cPath + cArquivo)
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()

		MSGINFO(  "Arquivo gerado em:"+cPath + cArquivo,"RFAT093B" )

	Endif

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcItem  �Autor  � Giane              � Data � 10/09/2010  ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula valor total do item caso tenha conversao de moeda  ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

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
		//usar database do sistema para a convers�o do valor
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
		nVlrItem := ((cAlias)->C6_PRCVEN /nTaxa)  * (cAlias)->C6_QTDVEN
		nPrdUnit := iif(nTaxa > 0, round(nPrdUnit / nTaxa,2), nPrdUnit )
		Else
		nVlrItem := iif(nTaxa > 0, round(nVlrItem / nTaxa,2), nVlrItem )
		nPrdUnit := iif(nTaxa > 0, round(nPrdUnit / nTaxa,2), nPrdUnit )
		Endif

	Endif

Return


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcItem  �Autor  � Giane              � Data � 10/09/2010  ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula valor total SEM IMPOSTOS  ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

Static Function CalcSIte(nVlrSIte)

//C6_XICMEST, C6_XPISCOF, C6_XMEDIO, C6_XTAXA

nVlrSIte  := (cAlias)->C6_VALOR -  (cAlias)->C6_VALOR * (((cAlias)->C6_XICMEST +  (cAlias)->C6_XPISCOF)/100)

Return


Static Function CalcCS(nVlrCS)
//C6_XICMEST, C6_XPISCOF, C6_XMEDIO, C6_XTAXA , B1_CUSTD

nVlrCS  := ((cAlias)->B1_CUSTD *  (cAlias)->C6_XTAXA) * (cAlias)->C6_QTDVEN

Return
