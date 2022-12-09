#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FC010BTN บ Autor ณ Giane/Fabricio     บ Data ณ 17/04/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada, cria botao na tela de Consulta Cliente,  บฑฑ
ฑฑบ          ณ botao "Financ" do Televendas                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especefico MAKENI: Televendas / Orcamento                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function FC010BTN()
	Local aButtons 	:= {}
	Local _aArea 	:= GetArea() 
	Local cRetorna 	:= ""
	Local aAreaSCJ  := SCJ->(GetArea())
	Local aAreaSCK  := SCK->(GetArea())	

	If (Paramixb[1] == 1)
		cRetorna := "Itens Or็amento"
	ElseIf (Paramixb[1] == 2)
		cRetorna := "Consulta Itens do Or็amento"
	ElseIf (Paramixb[1] == 3)
		U_AFAT009(M->CJ_CLIENTE,M->CJ_LOJA)
	EndIf

	RestArea(_aArea) 
	RestArea(aAreaSCJ)
	RestArea(aAreaSCK)

Return(cRetorna)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FC010CON บ Autor ณ Giane/Fabricio     บ Data ณ 17/04/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada, cria botao na tela de Consulta Cliente,  บฑฑ
ฑฑบ          ณ botao "Financ" do Televendas                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especefico MAKENI: televendas/orcamento                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function FC010CON
	Local aAreaAtu      := GetArea()
	Local _aIndexSC6    := {}
	Local cQuery        := ""
	Local _cFiltro      := ""
	Local aField        := {}
	Local nX            := 0
	Local nY            := 0
	Local aHead         := {}
	Local aAuxHead      := {}
	Local aList         := {}
	Local aSize         := MsAdvSize(.T.)
	Local aTela         := {}
	Local cLine         := ""
	Local bLine         := {||}
	Local nTipo         := Aviso( "Tipo de Consulta", "Consulta de Or็amento ou Pedido?", { "Or็amento", "Pedido"} )
	Local uCpo   
	Local aButtons      := {}
	Local aHeaderSC6    := {}
	Local aHeader       := {}  	
	Local aHeader2      := {}  	
	Local aSC5CpoS 		:= {}
	Local aSC6CpoS 		:= {} 
	Local aOrdem		:= {} 
	Local aAux			:= {} 
	Local aAreaSCJ  := SCJ->(GetArea())
	Local aAreaSCK  := SCK->(GetArea())	

	Local oList, oDlgCon

	Private oGrid := Nil

	If (nTipo == 1)
		// Orcamento
		U_AFAT009( SA1->A1_COD, SA1->A1_LOJA )
	Else
		// Pedido
		DEFINE MSDIALOG oDlgCon TITLE "Consulta de Pedido de Venda" From aSize[7],0 To aSize[6],aSize[5] of oMainWnd PIXEL
		oDlgCon:lMaximized := .T.

		aTela := { aSize[1]+4, aSize[2]+13, aSize[5], aSize[6]-5 }

		aSC5CpoS := {"C5_NUM", "C5_EMISSAO",  "C5_XNOMCON"} //, "C5_VEND2"}			

		aSC6CpoS := {"C6_ENTREG", "C6_ITEM", "C6_DESCRI", "C6_UM", "C6_QTDVEN", "C6_XPRUNIT", "C6_PRCVEN",; 
		"C6_VALOR", "C6_XOPER", "C6_NOTA", "C6_XTAXA", "C6_NUMPCOM"}            

		aOrdem   := {"_LEG01", "CK_NUM", "C5_NUM", "C5_EMISSAO", "C6_ENTREG", "C6_ITEM", "C6_DESCRI", "C6_UM", "C6_QTDVEN",;
		"_LEGMOE", "C6_XPRUNIT", "C6_XTAXA", "C6_PRCVEN", "E4_DESCRI", "C6_VALOR", "C6_XOPER", "C5_XNOMCON", "USUARIO", "C6_NOTA", "C6_PEDCLI","C6_NUMPCOM" }                                                                                                                                          

		//CriaHeader(cAlias, aCamposS(im), aCamposN(ao), aCheck, lRecno)		
		aHeader := CriaHeader("SC5", aSC5CpoS, ,{{" ", "_LEG01"}})

		aHeaderSC6 := CriaHeader("SC6", aSC6CpoS)
		aEval(aHeaderSC6, {|aItem| aAdd(aHeader, aClone(aItem))})   

		aHeaderSC6 := CriaHeader("SE4", {"E4_DESCRI"})
		aEval(aHeaderSC6, {|aItem| aAdd(aHeader, aClone(aItem))})

		// Campos adicionais, nใo se encontram no SX3
		aAux := Array(17)   //35
		aFill(aAux, " ")
		aAux[01] := "Or็amento"
		aAux[02] := "CK_NUM"
		aAux[03] := "@!"
		aAux[04] := 10
		aAux[05] := 00
		aAux[08] := "C"
		aAux[10] := "V"
		aAux[14] := "V"
		aAdd(aHeader, aClone(aAux))

		aAux := Array(17)  
		aFill(aAux, " ")
		aAux[01] := "Moeda"
		aAux[02] := "_LEGMOE"
		aAux[03] := "@!"
		aAux[04] := 06
		aAux[05] := 00
		aAux[08] := "C"
		aAux[10] := "V"
		aAux[14] := "V"
		aAdd(aHeader, aClone(aAux))

		/*aAux := Array(17)
		aFill(aAux, " ")
		aAux[01] := "Cond.Pagto"
		aAux[02] := "E4_DESCRI"
		aAux[03] := "@!"
		aAux[04] := 20
		aAux[05] := 00
		aAux[08] := "C"
		aAux[10] := "V"
		aAux[14] := "V"
		aAdd(aHeader, aClone(aAux))
		*/			                 
		aAux := Array(17)
		aFill(aAux, " ")
		aAux[01] := "Usuario"
		aAux[02] := "USUARIO"
		aAux[03] := "@!"
		aAux[04] := 15
		aAux[05] := 00
		aAux[08] := "C"
		aAux[10] := "V"
		aAux[14] := "V"
		aAdd(aHeader, aClone(aAux))


		aHeader2 := ASORT(aHeader,,,{|x, y| aScan(aOrdem, x[2]) < aScan(aOrdem, y[2])})

		oGrid := MsNewGetDados():New(0, 0, 1, 1, 0,,,,,,,,,, oDlgCon, aHeader2, {})
		oGrid:aCols := {}
		oGrid:oBrowse:nTop       := aTela[2]
		oGrid:oBrowse:nLeft      := aTela[1]
		oGrid:oBrowse:nHeight    := aTela[4] - aTela[2]
		oGrid:oBrowse:nWidth     := aTela[3] - aTela[1]
		oGrid:oBrowse:bLDblClick := {|| } 
		oGrid:oBrowse:lColDrag   := .T.
		oGrid:oBrowse:lAdjustColSize := .T.

		LoadDados()

		// Botoes
		AAdd(aButtons,{'ENABLE'		,{ || A410Legend() }, "Legenda", "Legenda"})
		AAdd(aButtons,{'PEDIDO'		,{ || F010Vis(oGrid:aCols[oGrid:nAt,GdFieldPos("C5_NUM", oGrid:aHeader)]) }, "Pedido", "Pedido"})
		AAdd(aButtons,{'PESQUISA'	,{ || F010Pesq(oGrid:aCols, oGrid, aHeader) }, "Pesquisa", "Pesquisa"})
		AAdd(aButtons,{'AUTOM'		,{ || F010Ord(oGrid:aCols, oGrid, aHeader) }, "Ordenar", "Ordenar"})
		AAdd(aButtons,{'FILTRO'		,{ || CriaFiltro() }, "Filtro", "Filtro"})		    
		ACTIVATE MSDIALOG oDlgCon CENTERED ON INIT EnchoiceBar( oDlgCon, {||oDlgCon:End()},{||oDlgCon:End()},,aButtons)	
	Endif

	If (Select("TSC6") > 0)
		TSC6->( dbCloseArea() )
	EndIf

	RestArea( aAreaAtu ) 
	RestArea(aAreaSCJ)
	RestArea(aAreaSCK)
Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaFiltroบAutor  ณMicrosiga           บ Data ณ  17/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Procedure CriaFiltro()
	Local cFiltro 	:= ""
	Local cSql    	:= ""
	Local cAlias  	:= "" 
	Local cLegFil 	:= ""
	Local nPosLeg 	:= 0
	Local aItem		:= {}	
	Local nItem		:= 1
	Local nTamanho 	:= 0

	/*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณBuildExpr ( cAlias, |oWnd|, |cFilter|, |lTopFilter|, |bOk|, |oDlg|, |aUsado|, |cDesc|) --> cRet   ณ
	ณcAlias 		- Tabela do SX2 onde sera executada a expressใo de filtro                          ณ
	ณoWnd 			- Objeto que chamou a funcao                                                       ณ
	ณcFilter		- String contendo a expressao de filtro                                            ณ
	ณlTopFilter 	- Se .T. retorna Expressao SQL (Default .F.)                                       ณ
	ณbOk 			- Bloco de codigo a ser executado no botao OK                                      ณ
	ณoDlg 			- Janela onde sera apresentada o construtor de expressoes                          ณ
	ณaUsado 		- Array com os campos que poderao ser apresentados no construtor                   ณ
	ณcDesc 			- Titulo da janela a ser apresentada                                               ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
	If (oGrid:oBrowse:nColPos == 1)
		nPosLeg := GdFieldPos("_LEG01", oGrid:aHeader)
		cLegFil := oGrid:aCols[oGrid:nAt, oGrid:oBrowse:nColPos]:cName
		aEVal(oGrid:aCols, {|aItem| IIf(Valtype(aItem) == "A" .And. aItem[nPosLeg]:cName <> cLegFil, aDel(oGrid:aCols, nItem), nTamanho++), nItem++}) 
		aSize(oGrid:aCols, nTamanho)
	Else
		cAlias 	:= "S" + Left(oGrid:aHeader[oGrid:oBrowse:nColPos, 2], 2)	
		cFiltro := BuildExpr( cAlias, , , .T., , , , "Defina o filtro para a consulta..." )
		LoadDados(cFiltro)
	EndIf
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณLoadDados บAutor  ณFabricio E. da Costaบ Data ณ 17/04/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera a query dos Pedidos de Venda                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ  oGetDados: Objeto NewGetDados que ira receber os resgitrosบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณ   Nil                                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณObservacao:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FC010BTN                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function LoadDados(cFiltro)
	Local cSql    := ""
	Local cCampos := ""
	Local aCpoExtra := {}

	Default cFiltro := ""

	// gera a lista de campos da select
	aEval(oGrid:aHeader, {|aItem| cCampos += IIf(Left(aItem[2],3) $ "_CHK/_LEG/USU", "", aItem[2] + ", ")}, 1, Len(oGrid:aHeader) - 1) 
	cComple := aTail(oGrid:aHeader)[2]
	if cComple == "C6_NUMPCOM"
		cComple := " CASE WHEN C6_PEDCLI = ' ' THEN C6_NUMPCOM ELSE C6_PEDCLI  END AS C6_NUMPCOM "
	endif	
	cCampos += cComple
	cCampos += ", C5_NOTA, C5_BLQ, C6_XMOEDA, CK_XMOEDA, C5_USERLGI, C5_CONDPAG, C5_X_CANC, C5_X_REP, C5_LIBEROK  " // Campos exce็ใo que nใo vใo pro aHeader    

	cSql := "SELECT DISTINCT "
	cSql += "  " + cCampos + " "
	cSql += "FROM "
	cSql += "  " + RetSqlName("SC5") + " SC5 JOIN " + RetSqlName("SC6") + " SC6 ON "
	cSql += "    C5_FILIAL = '" + xFilial("SC5") + "' AND "
	cSql += "    C6_FILIAL = '" + xFilial("SC6") + "' AND "
	cSql += "    C5_NUM = C6_NUM "  
	cSql += "  LEFT JOIN " + RetSqlName("SCK") + " SCK ON "
	cSql += "    CK_FILIAL = '" + xFilial("SCK") + "' AND "
	cSql += "    CK_NUM || CK_ITEM = C6_NUMORC "
	cSql += "    AND SCK.D_E_L_E_T_ <> '*' " 
	cSql += "  LEFT JOIN " + RetSqlName("SE4") + " SE4 ON "
	cSql += "    E4_FILIAL = '" + xFilial("SE4") + "' AND "
	cSql += "    C5_CONDPAG = E4_CODIGO AND SE4.D_E_L_E_T_ = ' ' "  		
	cSql += "WHERE "
	cSql += "  SC5.C5_TIPO IN ('N','C','I','P') AND "
	cSql += "  SC5.D_E_L_E_T_ = ' ' AND "            
	cSql += "  SUBSTR(SC6.C6_PRODUTO,5,4) <> '0099' AND "
	cSql += "  SC6.D_E_L_E_T_ = ' ' AND "
	cSql += "  C6_CLI    = '" + SA1->A1_COD + "' AND "
	cSql += "  C6_LOJA   = '" + SA1->A1_LOJA + "' "
	If !Empty(cFiltro)
		cSql += " AND " + cFiltro
	EndIf

	aAdd(aCpoExtra, {"_LEG01" ,"FC10Leg(C5_LIBEROK, C5_NOTA, C5_BLQ, C5_X_CANC, C5_X_REP)"})
	aAdd(aCpoExtra, {"_LEGMOE","IIF(C6_XMOEDA == 1, 'R$ ', IIF(C6_XMOEDA == 2 , 'US$', 'EUR'))"})
	aAdd(aCpoExtra, {"USUARIO", "Left(Embaralha(C5_USERLGI,1),15)"})
	//aAdd(aCpoExtra, {"E4_DESCRI", "Posicione('SE4',1,xFilial('SE4')+C5_CONDPAG,'E4_DESCRI')"})
	//	aAdd(aCpoExtra, {"_LEGCOT","FC10Cot(C5_MOEDA, C5_EMISSAO, C6_PRCVEN)"})   
	//	MEMOWRITE('C:\QUERYF.SQL',cSql) 
	//aadd(aCpoExtra, {"_TAXA", "AtuMoeda(C6_XMOEDA, C6_XTAXA, C6_NOTA)"})

	Load_Grid(cSql, oGrid, , aCpoExtra)	
Return .T.

/*
Static Function AtuMoeda(nMoeda, nTaxa1, cNota)  
Local _nTaxa
Local cCampo  
Local _aArea:= GetArea()


If !Empty(cNota)
cCampo := 'M2_MOEDA' + ALLTRIM(STR(nMoeda,1))

_nTaxa := nTaxa1  
DbSelectArea("SM2")
DbSetOrder(1)
If DbSeek(dDataBase)
_nTaxa := &cCampo          
endif     

//altera valores no pedido de vendas
if _nTaxa != 0 .and. (_nTaxa != nTaxa1)         
endif 

else
_nTaxa := nTaxa1
endif

RestArea(_aArea)   
return _nTaxa
*/


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFC10Leg   บAutor  ณMicrosiga           บ Data ณ 17/04/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria legenda                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function FC10Leg(cC5_LIBEROK, cC5_NOTA, cC5_BLQ, X_CANC, X_REP)
	Local oRet
	Local oBrVerde     := LoadBitmap(GetResources(), "BR_VERDE")
	Local oBrVermelho  := LoadBitmap(GetResources(), "BR_VERMELHO")
	Local oBrAmarelo   := LoadBitMap(GetResources(), "BR_AMARELO")
	Local oBrAzul      := LoadBitmap(GetResources(), "BR_AZUL")
	//	Local oBrLaranja   := LoadBitMap(GetResources(), "BR_LARANJA")
	Local oBrCinza	   := LoadBitMap(GetResources(), "BR_CINZA")
	Local oBrPink	   := LoadBitMap(GetResources(), "BR_PINK")

	If AllTrim(cC5_NOTA)=='REMITO' .or. X_CANC == 'C'
		oRet := oBrCinza
	elseif X_REP == 'R'
		oRet := oBrPink
	ELSEIF Empty(cC5_LIBEROK) .And. Empty(cC5_NOTA) .And. Empty(cC5_BLQ)
		oRet := oBrVerde
	ElseIf !Empty(cC5_NOTA) .Or. cC5_LIBEROK=='E' .And. Empty(cC5_BLQ)
		oRet := oBrVermelho
	ElseIf !Empty(cC5_LIBEROK) .And. Empty(cC5_NOTA) .And. Empty(cC5_BLQ)
		oRet := oBrAmarelo
	ElseIf cC5_BLQ == '1'
		oRet := oBrAzul
		//	ElseIf cC5_BLQ == '2' .or. (cC5_LIBCRED == 'X' .AND. Empty(cC5_NOTA))
		//		oRet := oBrLaranja
	EndIf	
Return oRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FC10Cot  บAutor  ณMicrosiga           บ Data ณ 17/04/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cotacao da moeda                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function FC10Cot(nMoeda, dData, nPreco)
	Local nValor := 0

	If (nMoeda <> 1)
		nValor := nPreco / RecMoeda(dData, 	nMoeda)
	EndIf
Return nValor


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF010Vis   บAutor  ณMicrosiga           บ Data ณ  17/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function F010Vis(cPedido)
	Local aArea := GetArea()

	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek( xFilial("SC5") + cPedido )
		a410Visual("SC5", SC5->(Recno()), 2)
	EndIf

	RestArea( aArea )
Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF010Ord   บAutor  ณMicrosiga           บ Data ณ  17/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function F010Ord(aList, oGrid, aHeader)
	Local aComboBx1		:= {}
	Local cComboBx1		:= "Pedido de Venda"
	Local oRadioGrp1
	Local nRadioGrp1	:= 1
	Local nOption       := 0
	Local oCombo
	Local _aArea		:= {}
	Local nPosCbx 		:= 1
	Local _aAlias		:= {}

	// Dialog Principal
	Private _oDlg 

	aEval(oGrid:aHeader, {|aItem| aAdd(aComboBx1, IIf(aItem[2]=="_LEG01","Legenda",aItem[1]))})		

	DEFINE MSDIALOG _oDlg TITLE "Ordenar" FROM 284,269 TO 438,764 PIXEL
	// Cria Componentes Padroes do Sistema
	@ 003,148 TO 058,240 LABEL "" PIXEL OF _oDlg

	oCombo 			:= TComboBox():Create(_oDlg)
	oCombo:nTop 	:= 004
	oCombo:nLeft 	:= 004
	oCombo:nHeight 	:= 015
	oCombo:nWidth 	:= 137
	oCombo:aItems	:= aClone(aComboBx1)
	oCombo:nAt      := 1

	@ 007,151 Radio oRadioGrp1 Var nRadioGrp1 Items "Crescente","Decrescente" 3D Size 056,010 PIXEL OF _oDlg
	@ 059,202 Button "Ordenar" Size 037,012 ACTION (nPosCbx:=oCombo:nAt,_oDlg:End()) PIXEL OF _oDlg			
	ACTIVATE MSDIALOG _oDlg CENTERED 

	If !Empty(cComboBx1)
		If (nPosCbx == 1) 
			// Legenda
			aList := aSort( aList,,,{|x,y| IIf( nRadioGrp1 == 1,x[nPosCbx]:cName < y[nPosCbx]:cName,x[nPosCbx]:cName > y[nPosCbx]:cName) } )			
		Else
			// outros...
			aList := aSort( aList,,,{|x,y| IIf( nRadioGrp1 == 1,x[nPosCbx] < y[nPosCbx],x[nPosCbx] > y[nPosCbx]) } )
		EndIf

		oGrid:Refresh()
	EndIf		
Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF010Pesq  บAutor  ณMicrosiga           บ Data ณ  17/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                  
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function F010Pesq(aList, oGrid, aHeader)
	Local aComboBx1	:= {"Por Produto", "Por Pedido", "Por Data de Entrega"}
	Local cComboBx1 := "Por Produto"
	Local _aArea	:= {}
	Local cPesq 	:= Space(500)
	Local oPesq
	Local nPesq 	:= 0
	Local nPosCbx 	:= 0
	Local _aAlias	:= {}
	Local nPos 		:= 0
	Local nPos2 	:= 0

	Private _oDlg	// Dialog Principal

	DEFINE MSDIALOG _oDlg TITLE "Pesquisar" FROM 284,269 TO 438,560 PIXEL
	// Cria Componentes Padroes do Sistema (Coluna, Linha)
	@ 004,004 ComboBox cComboBx1 Items aComboBx1 Size 137,010 PIXEL OF _oDlg
	@ 024,004 MsGet oPesq Var cPesq Size 137,010 Pixel Of _oDlg
	@ 059,102 Button "Pesquisar" Size 037,012 ACTION (_oDlg:End()) PIXEL OF _oDlg
	ACTIVATE MSDIALOG _oDlg CENTERED 

	If !Empty(cPesq)
		nPosCbx := aScan( aComboBx1, cComboBx1 )
		If (nPosCbx == 1)
			nPos := aScan( aHeader,{|x| ALLTRIM(X[2])=="C6_PRODUTO"} )   
		ElseIf (nPosCbx == 2)
			nPos := aScan( aHeader,{|x| ALLTRIM(X[2])=="C5_NUM"} )
		ElseIf (nPosCbx == 3)
			nPos := aScan( aHeader,{|x| ALLTRIM(X[2])=="C6_ENTREGA"} )
		EndIf

		nPos2 := aScan( aList, {|x| AllTrim(x[nPos]) == AllTrim(cPesq)} )
		If (nPos2 > 0)
			oGrid:oBrowse:GoPosition(nPos2)
		EndIf
	EndIf		
Return Nil  


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProcedure ณLoad_Grid บAutor  ณFabricio E. da Costaบ Data ณ  11/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega o grid passado em oGetDados, com os registros       บฑฑ
ฑฑบ          ณretornados pela query passada em cSql.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ  cSql.....: Query que retorna os registros para o grid     บฑฑ
ฑฑบ          ณ  oGetDados: Objeto NewGetDados que ira receber os resgitrosบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณ   Nil                                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณObservacao:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GERAL                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Procedure Load_Grid(cSql, oGetDados, aCheck, aLegenda)
	Local i			:= 0
	Local cAction   := ""
	Local cAux      := ""
	Local bAddDados := "{|| AAdd(oGetDados:aCols, {"
	Local lCheck    := .F.
	Local nPosChk   := 0
	Local cAliasTMP := GetNextAlias()
	Default aCheck   := {}
	Default aLegenda := {}   


	TCQuery cSql NEW ALIAS (cAliasTMP)
	For i := 1 To Len(oGetDados:aHeader)
		If ("_CHK" $ oGetDados:aHeader[i,2])
			nPosChk   := aScan(aCheck, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
			bAddDados += aCheck[nPosChk, 2] + ", "
		ElseIf ("_LEG" $ oGetDados:aHeader[i,2])
			nPosChk   := aScan(aLegenda, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
			bAddDados += aLegenda[nPosChk, 2] + ", "     
		ElseIf ("USUA" $ oGetDados:aHeader[i,2])
			nPosChk   := aScan(aLegenda, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
			bAddDados += aLegenda[nPosChk, 2] + ", "			
		Else
			// Acerta campos numericos e datas na query
			If (oGetDados:aHeader[i,8] $ "N/D") 
				TCSetField((cAliasTMP), oGetDados:aHeader[i,2], oGetDados:aHeader[i,8], oGetDados:aHeader[i,4],oGetDados:aHeader[i,5])
			EndIf
			bAddDados += oGetDados:aHeader[i,2] + ", "
		EndIf
	Next	
	bAddDados += ".F.})}"

	bAddDados := &bAddDados.
	oGetDados:aCols := {}	
	(cAliasTMP)->(DbEval(bAddDados))
	(cAliasTMP)->(DbCloseArea())

	// Define a a็ใo lDblClick da getdados para marcar e desmarcar os checkboxs
	/*
	For i := 1 To Len(aCheck)
	nPosChk  := aScan(aCheck, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
	cMultSel += Iif(aCheck[i,3], StrZero(nPosChk,3) + "/", "")
	cSingSel += Iif(!aCheck[i,3], StrZero(nPosChk,3) + "/", "")
	Next
	cBloco  := "{|aItem| oGetDados:aCols[i,oGetDados:oBrowse:nColPos] := Iif(i == oGetDados:nAt, Iif(aItem[oGetDados:oBrowse:nColPos] == 'LBNO', 'LBTIK', 'LBNO'), 'LBNO')}"
	cInicio := "Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ " + cMultSel + ", oGetDados:nAt, 1)"
	cCont   := "Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ " + cMultSel + ", 1, Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ " + cSingSel + ", Len(oGetDados:aCols), 0))"
	aEval(oGetDados:aCols, {|aItem| oGetDados:aCols[i,oGetDados:oBrowse:nColPos] := Iif(i == oGetDados:nAt, Iif(aItem[oGetDados:oBrowse:nColPos] == 'LBNO', 'LBTIK', 'LBNO'), 'LBNO')}, Iif('_CHK' $ oGetDados:aHeader[oGetDados:oBrowse:nColPos,2]))
	*/

	cAction := "oGetDados:aCols[oGetDados:nAt,oGetDados:oBrowse:nColPos] := Iif('_CHK' $ oGetDados:aHeader[oGetDados:oBrowse:nColPos,2], Iif(oGetDados:aCols[oGetDados:nAt,oGetDados:oBrowse:nColPos] == 'LBNO', 'LBTIK', 'LBNO'),oGetDados:aCols[oGetDados:nAt,oGetDados:oBrowse:nColPos])"
	If (Len(aCheck) > 0 .And. Len(oGetDados:aCols) > 0 .And. At(Upper(cAction), GetCbSource(oGetDados:oBrowse:bLDblClick)) == 0)
		oGetDados:oBrowse:bLDblClick := &(BAddExp(oGetDados:oBrowse:bLDblClick, cAction))
	EndIf
	oGetDados:oBrowse:Refresh()		
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCriaHeaderบAutor  ณFabricio E. da Costaบ Data ณ  12/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria o aHeader que serแ utilizado pela NewGetDados.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ  cAlias...: Alias que sera criado o aHeader                บฑฑ
ฑฑบ          ณ  aCamposS.: Array contendo os campos do Alias a serem      บฑฑ
ฑฑบ          ณ             exibidos.                                      บฑฑ
ฑฑบ          ณ  aCamposN.: Array contendo os campos do Alias a serem      บฑฑ
ฑฑบ          ณ             suprimidos do Alias.                           บฑฑ
ฑฑบ          ณ  lCheck...: Indica se o grid terแ checkbox (.T.Sim/.F.Nใo).บฑฑ
ฑฑบ          ณ  lRecno...: Indica se o grid terแ Recno dos registros      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณ  aHeader..: aHeader contendo os campos do Alias            บฑฑ
ฑฑบ          ณ             especificado.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณObservacao:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GERAL                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CriaHeader(cAlias, aCamposS, aCamposN, aCheck, lRecno)
	Local i       := 0
	Local nx      := 0
	Local aHeader := {}
	Local aSX3 := {}

	Default aCamposS := {}
	Default aCamposN := {}
	Default aCheck   := {}
	Default lRecno   := .F.

	For i := 1 To Len(aCheck)
		Aadd(aHeader, Nil)
		aHeader[Len(aHeader)] := Array(17)
		aFill(aHeader[Len(aHeader)], " ")
		aHeader[Len(aHeader), 01] := AllTrim(aCheck[i,1])
		aHeader[Len(aHeader), 02] := AllTrim(aCheck[i,2])
		aHeader[Len(aHeader), 03] := "@BMP"
		aHeader[Len(aHeader), 04] := 05
		aHeader[Len(aHeader), 05] := 00
		aHeader[Len(aHeader), 08] := "C"
		aHeader[Len(aHeader), 10] := "V"
		aHeader[Len(aHeader), 14] := "V"
	Next	
   	
	aSX3 := FWSX3Util():GetAllFields( cAlias , .F. )
	for nX:= 1  to len(aSX3)
		If X3Uso(GetSx3Cache(aSx3[nX],"X3_USADO")) .And. GetSx3Cache(aSx3[nX],"X3_TIPO") <> "M" .And. cNivel >= GetSx3Cache(aSx3[nX],"X3_NIVEL");
		.And. GetSx3Cache(aSx3[nX],"X3_CONTEXT") <> 'V' .And.;
		(aScan(aCamposS, AllTrim(GetSx3Cache(aSx3[nX],"X3_CAMPO"))) > 0 .Or. Len(aCamposS) == 0) .And.;
		(aScan(aCamposN, AllTrim(GetSx3Cache(aSx3[nX],"X3_CAMPO"))) == 0 .Or. Len(aCamposN) == 0)
			
		
		Aadd(aHeader, {})                      

			If AllTrim(GetSx3Cache(aSx3[nX],"X3_CAMPO")) == 'C5_NUM'                 
				Aadd(aHeader[Len(aHeader)], 'Pedido')
			Elseif AllTrim(GetSx3Cache(aSx3[nX],"X3_CAMPO")) == 'C6_PRCVEN'
				Aadd(aHeader[Len(aHeader)], 'Prc.Unitario R$') 
			Elseif AllTrim(GetSx3Cache(aSx3[nX],"X3_CAMPO")) == 'E4_DESCRI'
				Aadd(aHeader[Len(aHeader)], 'Cond.Pagto')								   
			Else
				Aadd(aHeader[Len(aHeader)], AllTrim(GetSx3Cache(aSx3[nX],"X3_TITULO")))
			Endif
			Aadd(aHeader[Len(aHeader)], AllTrim(GetSx3Cache(aSx3[nX],"X3_CAMPO")))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_PICTURE"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_TAMANHO"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_DECIMAL"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_VALID"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_USADO"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_TIPO"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_F3"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_CONTEXT"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_CBOX"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_RELACAO"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_WHEN"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_VISUAL"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_VLDUSER"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSx3[nX],"X3_PICTVAR"))
			Aadd(aHeader[Len(aHeader)], X3Obrigat(GetSx3Cache(aSx3[nX],"X3_CAMPO")))
		EndIf
	Next nX
	If lRecno
		Aadd(aHeader, Nil)
		aHeader[Len(aHeader)] := Array(17)
		aFill(aHeader[Len(aHeader)], " ")
		aHeader[Len(aHeader),01] := "RECNO"
		aHeader[Len(aHeader),02] := "R_E_C_N_O_"
		aHeader[Len(aHeader),03] := "99999999999"
		aHeader[Len(aHeader),04] := 10
		aHeader[Len(aHeader),05] := 00
		aHeader[Len(aHeader),08] := "N"
		aHeader[Len(aHeader),10] := "V"
		aHeader[Len(aHeader),14] := "V"
	EndIf
Return aClone(aHeader)
