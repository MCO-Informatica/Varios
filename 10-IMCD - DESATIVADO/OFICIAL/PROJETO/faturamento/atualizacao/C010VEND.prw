#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

USER Function C010VEND( cProduto, cCliente, cLoja )

	Local _cTit    := "Consulta Preço Histórico"
	Local cQuery := ""
	Local _aAux    := {}
	Local aArea    := GetArea()
	Local cAliasTMP := GetNextAlias()

	Private aHeader2	:= {}
	Private aTamCol		:= {}
	Private aColsTmp	:= {}
	Private aPicture	:= {}
	Private oDlgTMP
	Private oLstBox

	Default cProduto := " "
	Default cCliente := " "
	Default cLoja := " "

	cQuery := "SELECT C6_FILIAL, D2_TIPO, C6_NUM, C6_PRODUTO, C6_QTDVEN, C6_XMOEDA, "
	cQuery += " C6_XTAXA, C6_XPRUNIT, C6_XVLRINF, C6_PRCVEN, D2_DOC, D2_SERIE, "
	cQuery += " D2_EMISSAO, C6_XOBSMAR "
	cQuery += " FROM "+RETSQLNAME("SD2")+" SD2, "
	cQuery += RETSQLNAME("SC6")+" SC6, "
	cQuery += RETSQLNAME("SF4")+" SF4 "

	cQuery += " WHERE D2_COD = '"+cProduto+"' "
	cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery += " AND D2_TIPO = 'N' "
	cQuery += " AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += " AND C6_FILIAL = D2_FILIAL "
	cQuery += " AND C6_NUM = D2_PEDIDO "
	cQuery += " AND C6_ITEM = D2_ITEMPV "
	cQuery += " AND C6_CLI = D2_CLIENTE "
	cQuery += " AND C6_LOJA = D2_LOJA "
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += " AND F4_CODIGO = D2_TES "
	cQuery += " AND F4_ESTOQUE = 'S' "
	cQuery += " AND F4_DUPLIC = 'S' "
	cQuery += " AND F4_FILIAL = '" + xFilial("SF4") + "' "
	cQuery += " AND SF4.D_E_L_E_T_ = ' ' "
	cQuery += " AND C6_CLI = '"+cCliente+"' "
	cQuery += " AND C6_LOJA = '"+cLoja+"' "

	cQuery += " ORDER BY SD2.D2_EMISSAO DESC "
	cQuery += " fetch first 10 rows only "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasTMP,.T.,.F.)
	dbSelectArea(cAliasTMP)

	DbGotop()
	Do While !eof()
		_aAux := {}
		xMoeda := (cAliasTMP)->C6_XMOEDA
		cMoeda := 'BRL'

		Do Case
		Case xMoeda == 1 //REAL
			cMoeda := 'BRL'
		Case xMoeda == 2  //DOLAR
			cMoeda := 'USD'
		Case xMoeda == 3  //UFIR
			cMoeda := 'UFIR'
		Case xMoeda == 4 //EURO
			cMoeda := 'EUR'
		Case xMoeda == 5 //DOLAR CANADENSE
			cMoeda := 'CAD'
		Case xMoeda == 6 // LIBRA
			cMoeda := 'GBP'
		Case xMoeda == 7 //FRANCO SUICO
			cMoeda := 'CHF'
		EndCase

		aadd(_aAux, (cAliasTMP)->D2_TIPO )
		aadd(_aAux, (cAliasTMP)->C6_NUM )
		aadd(_aAux, cMoeda )
		aadd(_aAux, (cAliasTMP)->C6_XTAXA )
		aadd(_aAux, (cAliasTMP)->C6_QTDVEN )

		aadd(_aAux, (cAliasTMP)->C6_XVLRINF )
		aadd(_aAux, (cAliasTMP)->C6_PRCVEN / (cAliasTMP)->C6_XTAXA  )
		aadd(_aAux, (cAliasTMP)->C6_PRCVEN )
		aadd(_aAux, (cAliasTMP)->D2_DOC )
		aadd(_aAux, (cAliasTMP)->D2_SERIE )
		aadd(_aAux, STOD((cAliasTMP)->D2_EMISSAO) )
		aadd(_aAux, ALLTRIM((cAliasTMP)->C6_XOBSMAR)  )

		aadd(aColsTmp,_aAux)

		DbSkip()
	Enddo

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbCloseArea())
	MsErase(cAliasTMP)

//o if abaixo eh para nao dar erro de execucao no ListBox, se o Select nao retornar nenhum registro
	if len(aColsTmp) == 0
		aadd(aColsTmp,{space(2),space(06),space(03),0.00,0.00,0.00,;
			0.00,0.00,space(09),space(02),space(10),space(40)})
	endif

	nAltura := 300
	nLargura := 900

	DEFINE MSDIALOG oDlgTMP FROM  0,0 TO nAltura,nLargura TITLE ( _cTit ) PIXEL

	@ 05,05 TO 030,510  LABEL '' OF oDlgTMP	PIXEL
	@ 10,08 SAY "Código"     SIZE  21,7 OF oDlgTMP PIXEL
	@ 10,40 SAY cProduto     SIZE  49,8 OF oDlgTMP PIXEL COLOR CLR_BLUE
	@ 20,08 SAY "Descrição"  SIZE  32,7 OF oDlgTMP PIXEL
	@ 20,40 SAY Posicione("SB1",1,xFilial("SB1") + cProduto,"B1_DESC") SIZE 140,8 OF oDlgTMP PIXEL COLOR CLR_BLUE

	//aHeader2 := {"Tipo","Pedido","Moeda","Taxa","Quantidade","Prc Neg Net","Preço Unit R$","Nota Fiscal","Serie","Emissão NF","Mensagem"}
	aHeader2 := {"Tipo","Pedido","Moeda","Taxa","Quantidade","Prc Neg Net","Prc Neg Net + IMP","Preço Unit R$","Nota Fiscal","Serie","Emissão NF","Mensagem"}
	aPicture := {"@!","@!","@!","@E 999.9999","@E 999,999.9999","@E 999,999.9999","@E 999,999.9999","@E 999,999.9999","@!","@!","@D","@!"}
	aTamCol := {05,15,10,12,30,30,30,30,30,10,12,40}

	lin := 2.5
	col := 1
	compr := 510
	alt := 080
	oLstBox := RDListBox(lin,col,compr,alt, aColsTmp, aHeader2,aTamCol,aPicture)

	@ 130, 280 BUTTON "Exportar Excel" PIXEL SIZE 40,15 ;
		ACTION MsgRun("Gerando Excel, aguarde...","Preço Historico",{|| GERAEXCEL(cProduto,aHeader2,aColsTmp,aPicture)  }) OF oDlgTMP

	@ 130, 350 BUTTON "Sair" PIXEL SIZE 30,15 ACTION oDlgTMP:End() OF oDlgTMP

	ACTIVATE MSDIALOG oDlgTMP CENTERED

	RestArea(aArea)

	FreeObj(oDlgTMP)

Return( .T. )

Static Function GERAEXCEL(cProduto,aHead,aItens,aFormato)

	local nX := 0
	Local cWSheet := "Historico"
	Local cTab := "Historico Do Produto - "+cProduto
	Local oExcelApp
	Local oExcel

	if !EMPTY(aItens[1,1])
		oExcel := FWMsExcelEx():New()
		//oExcel := FwMsExcelXlsx():New()

		oExcel:AddworkSheet(cWSheet)

		oExcel:AddTable(cWSheet,cTab)

		FOR nX := 1 To Len(aHead)

			IF '9' $ aFormato[nX]
				oExcel:AddColumn(cWSheet,cTab,aHead[nX],2,3,.F., aFormato[nX] )
			ELSEIF 'D' $ aFormato[nX]
				oExcel:AddColumn(cWSheet,cTab,aHead[nX],2,4,.F., "" )
			ELSE
				oExcel:AddColumn(cWSheet,cTab,aHead[nX],2,1,.F., "" )
			ENDIF

		NEXT

		FOR nX := 1 To Len(aItens)
			oExcel:AddRow(cWSheet,cTab,aItens[nX])
		NEXT nX

		oExcel:Activate()

		cPathCli := GetTempPath(.T.)
		//cArqXml := cPathCli+"Historico_Produto_"+cProduto+Dtos(MSDate())+"_"+StrTran(Time(),":","")+".xlsx"
		cArqXml := cPathCli+"Historico_Produto_"+cProduto+Dtos(MSDate())+"_"+StrTran(Time(),":","")+".xml"

		If !Empty(cArqXml)
			oExcel:GetXMLFile(cArqXml)
			If !ApOleClient("MsExcel")
				MsgStop("Microsoft Excel não instalado!","Atencao")
				Return
			EndIf

			oExcelApp:= MsExcel():New()
			oExcelApp:WorkBooks:Open(cArqXml)
			oExcelApp:SetVisible(.T.)

			oExcelApp:Destroy()

			MsgAlert("Arquivo gerado com sucesso!"+CHR(13)+CHR(10)+cArqXml,"PRCHIST")

		ENDIF
	ELSE

		MsgAlert("Não há itens para gerar o Excel","PRCHIST")

	ENDIF

Return Nil
