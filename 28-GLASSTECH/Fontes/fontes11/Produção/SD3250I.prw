#Include 'Protheus.ch'

User Function SD3250I()
	Local aAreaSD3    := SD3->(GetArea())
	Local aAreaSDA    := SDA->(GetArea())
	Local aAreaSDB    := SDB->(GetArea())
	Local aAreaSC2    := SC3->(GetArea())
	Local aAreaSB2    := SB2->(GetArea())
	Local aAreaSBF    := SBF->(GetArea())
	Local aAreaSB5    := SB5->(GetArea())
	Local aAreaSB8    := SB8->(GetArea())

	local lRet := .F.
	Private oObj05	:= TWAC002():New()
	Private oObjAC	:= TWAC002():New()
	Private oObjFC  := TWFC002():New()
	Private cChavC2 := SD3->D3_OP
	Private cNumSeq := SD3->D3_NUMSEQ
	Private cLote   := SD3->D3_LOTECTL
	Private cLocal  := SD3->D3_LOCAL
	Private cEmpOri := cEmpAnt
	Private cFilOri := cFilAnt

	Public cErroTw    := ''

	oObj05:lGera := .F.
	oObjFC:lTroca := .F.

	If cFilAnt == '0101'
		lRet := TWFATPDV()
	EndIf

	If lRet
		oObjFC:cEmpOri := '01'
		oObjFC:cFilOri := '0202'
		TWARNFE(oObjFC:cDoc,oObjFC:cSerie,oObjFC:cCliente,oObjFC:cLoja)
	EndIf


	RestArea(aAreaSD3)
	RestArea(aAreaSDA)
	RestArea(aAreaSDB)
	RestArea(aAreaSC2)
	RestArea(aAreaSB2)
	RestArea(aAreaSBF)
	RestArea(aAreaSB5)
	RestArea(aAreaSB8)

	Return .T.

Static Function TWFATPDV()
	Local aArea    := GetArea()
	Local aPvlNfs		:= {}
	Local lRet			:= .F.
	Local aSerNf		:= {}
	Local cItem      := ''
	Local lGera      := .F.
	Local lPrdAuto   := ''
	Local lRet       := .F.

	Public cNotaA  	:= ''
	Public cSerieA 	:= oObjFC:cSerie
	Private cDoc

	SC2->(DbSetOrder(1))
	If SC2->(DbSeek(xFilial('SC2') + cChavC2))
		oObjFC:cNumPDx := SC2->C2_PEDIDO
		cItem := SC2->C2_ITEM
	EndIF


	SC5->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SC5 -> Cabeçalho do Pedido de Venda.
	SC6->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SC6 -> Itens do Pedido de Venda.
	SC9->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SC9 -> Pedidos Liberados.
	SE4->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SE4 -> Condição de Pagamento.
	SB1->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SB1 -> Cadastro de Produtos.
	SB2->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SB2 -> Saldos Físico e Financeiro.
	SF4->(dbSetOrder(1)) //Posicionando o primeiro registro na tabela SF4 -> Tipos de Entrada e Saída.

	SC5->(dbSeek(xFilial("SC5")+oObjFC:cNumPDx))

	lPrdAuto  := SC5->C5_PRDAUTO

	SA1->(DbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI)))

	If lPrdAuto = '1'
		lGera := .T.
		lRet := .F.
	EndIF

	SE4->(dbSeek(xFilial("SE4")+SC5->C5_CONDPAG))

	If lGera
		TWLIBPD(oObjFC:cNumPDx,cItem)

		SC9->(dbSeek(xFilial("SC9")+oObjFC:cNumPDx+cItem))

		Do While !SC9->(EOF()) .and. SC9->C9_FILIAL == xFilial("SC9") .and. SC9->C9_PEDIDO == oObjFC:cNumPDx .And. SC9->C9_ITEM == cItem
			If !Empty(SC9->C9_NFISCAL)
				SC9->(dbSkip())
				Loop
			Endif

			SC6->(dbSeek(xFilial("SC6")+SC9->(C9_PEDIDO+C9_ITEM)))
			SB1->(dbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
			SB2->(dbSeek(xFilial("SB2")+SC9->(C9_PRODUTO+C9_LOCAL)))

			Aadd(aPvlNfs, {	SC9->C9_PEDIDO,;	&& 01- No. Pedido
			SC9->C9_ITEM  ,;	&& 02- Item Pedido
			SC9->C9_SEQUEN,;	&& 03- Sequencia Liberação
			SD3->D3_QUANT,;	&& 04- Qtde. Liberada
			SC6->C6_PRCVEN,;	&& 05- Preço de Venda
			SC9->C9_PRODUTO,;	&& 06- Cód. do Produto
			.F.,;				&& 07- Valor Lógico
			SC9->(RecNo()),;	&& 08- Posição do Arquivo de Pedidos Liberados
			SC5->(RecNo()),;	&& 09- Posição do Arquivo de Pedidos de Venda
			SC6->(RecNo()),;	&& 10- Posição do Arquivo de Itens dos Pedidos de Venda
			SE4->(RecNo()),;	&& 11- Posição do Arquivo de Condição de Pagamento
			SB1->(RecNo()),;	&& 12- Posição do Arquivo de Produtos
			SB2->(RecNo()),;	&& 13- Posição do Arquivo de Saldo em Estoque
			SF4->(RecNo())})	&& 14- Posição do Arquivo de TES


			lRet := oObj05:TWENDPRD(SC9->C9_PRODUTO,SC9->C9_ITEM,SD3->D3_QUANT,cNumSeq,cLote,'PALLETS','','',cLocal)

			SC9->(dbSkip())
		Enddo

		If Len(aPvlNfs) > 0
			&& Chama Rotina/Função de Inclusão da NF de Saída
			oObjFC:cDoc    := MaPvlNfs(aPvlNfs,'X  ',.F.,.F.,.F.,.T.,.F.,0,0,.T.,.F.)
			oObjFC:cSerie  := SF2->F2_SERIE
			oObjFC:cCliente:= SF2->F2_CLIENTE
			oObjFC:cLoja   := SF2->F2_LOJA
			oObjFC:cTes    := '101'
		EndIf

		If Empty(oObjFC:cDoc)
			Alert("Erro na Geração da Nota Fiscal de Saida !!!")
			cErroTw += "Erro na Geração da Nota Fiscal de Saida !!!"
			DisarmTransaction()
		EndIf

		If Empty(oObjFC:cDoc)
			lRet := .F.
		ElseIf !Empty(oObjFC:cDoc)
			lRet := .T.
		Endif

		cNotaA := Nil
		cSeriA := Nil

	EndIf
	RestArea(aArea)
	Return(lRet)


Static Function TWLIBPD(cPed,cItem)
	Local lRet := .F.

	SC6->(dbSetOrder(1))
	If SC6->(DbSeek(xFilial('SC6') + cPed + cItem))
		SC9->(DbSetOrder(1))
		If SC9->(DbSeek(xFilial('SC9') + cPed + cItem))
			While SC6->(!EOF()).And.  SC6->C6_FILIAL == xFilial('SC6') .And. SC6->C6_NUM == cPed .And. SC6->C6_ITEM == cItem
				If !Empty(SC9->C9_NFISCAL)
					SC9->(dbSkip())
					Loop
				Endif
				MaLibDoFat(SC6->(RecNo()),SD3->D3_QUANT,,,.T.,.T.,.F.,.F.)
				SC6->(dBSkip())
				lRet := .T.
			EndDo
		Else
			MaLibDoFat(SC6->(RecNo()),SD3->D3_QUANT,,,.T.,.T.,.F.,.F.)
			lRet := .T.
		EndIf
	EndIF
Return lRet

Static Function TWARNFE(cDoc,cSerie,cCliente,cLoja)
	Local aArea    := GetArea()
	Local nX			:= 0
	Local aM140i		:= {}
	Local lRet   := .F.
	Local cAlias   := GetNextAlias()

	BeginSql Alias cAlias
		SELECT D2_ITEM,D2_COD,D2_QUANT,D2_PRCVEN,D2_TOTAL
		FROM %TABLE:SF2% SF2,%TABLE:SD2% SD2
		WHERE
		SF2.F2_FILIAL = SD2.D2_FILIAL AND
		SF2.F2_DOC = SD2.D2_DOC AND
		SF2.F2_SERIE = SD2.D2_SERIE AND
		SF2.F2_CLIENTE = %Exp:cCliente% AND
		SF2.F2_LOJA = %Exp:cLoja% AND
		SF2.F2_DOC = %Exp:cDoc% AND
		SF2.F2_SERIE = %Exp:cSerie% AND
		SF2.%notDel% AND
		SD2.%notDel%
	EndSql

	oObjFC:aDataCabec := {}

	cCodFor 	:= ""
	cLojaFor	:= ""
	cEstado	:= ""

	cCodFor 	:= '000040'
	cLojaFor	:= '01'
	cEstado	:= 'SP'

	AADD(oObjFC:aDataCabec,	{"F1_TIPO"		,"N"				,NIL})
	AADD(oObjFC:aDataCabec,	{"F1_FORMUL"	,"N"				,NIL})
	AADD(oObjFC:aDataCabec,	{"F1_DOC"		,cDoc       		,NIL})
	AADD(oObjFC:aDataCabec,	{"F1_SERIE"		,cSerie			,NIL})
	AADD(oObjFC:aDataCabec,	{"F1_EMISSAO"	,dDataBase			,NIL})
	AADD(oObjFC:aDataCabec,	{"F1_FORNECE"	,cCodFor			,NIL})
	AADD(oObjFC:aDataCabec,	{"F1_LOJA"		,cLojaFor			,NIL})
	AADD(oObjFC:aDataCabec,	{"F1_ESPECIE"	,"NF"			,NIL})
	AADD(oObjFC:aDataCabec,	{"F1_COND"		,'001' 			,NIL})
	AADD(oObjFC:aDataCabec,	{"F1_DTDIGIT"	,dDataBase			,NIL})

	oObjFC:aDataItem := {}


	nX := 1
	While 	!(cAlias)->(EOF())

		oObjFC:aMata410i := {}
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+(cAlias)->D2_COD))

		AADD(oObjFC:aMata410i,	{"D1_COD"		, SB1->B1_COD			,NIL})
		AADD(oObjFC:aMata410i,	{"D1_QUANT" 	,(cAlias)->D2_QUANT		,NIL})
		AADD(oObjFC:aMata410i,	{"D1_VUNIT" 	,(cAlias)->D2_PRCVEN	,NIL})
		AADD(oObjFC:aMata410i,	{"D1_TOTAL"  	,(cAlias)->D2_TOTAL		,NIL})
		AADD(oObjFC:aMata410i,	{"D1_TES"  		,'417'					,NIL})
		AADD(oObjFC:aMata410i,	{"D1_LOTECTL"  	,cLote					,NIL})
		AADD(oObjFC:aMata410i,	{"D1_DTVALID"  	,SD3->D3_DTVALID 		,NIL})

		SBZ->(DbSetOrder(1))
		If SBZ->(DbSeek(xFilial('SBZ') + SB1->B1_COD ))
			AADD(oObjFC:aMata410i,	{"D1_LOCAL"  	,SBZ->BZ_LOCAL		,NIL})
		Else
			AADD(oObjFC:aMata410i,	{"D1_LOCAL"  	,SB1->B1_LOCPAD			,NIL})
		EndIF
		AADD(oObjFC:aDataItem,oObjFC:aMata410i)
		nX		+= 1

		(cAlias)->(DbSkip())
	EndDo


	oObj05:cProcessEmp	:= oObjFC:cEmpOri
	oObj05:cProcessFil	:= oObjFC:cFilOri
	oObj05:changeEmpFil()

	lRet := oObjFC:TWGERNFE()

	oObj05:cProcessEmp	:= cEmpOri
	oObj05:cProcessFil	:= cFilOri
	oObj05:changeEmpFil()


	RestArea(aArea)

	Return lRet

