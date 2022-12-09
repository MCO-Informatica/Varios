#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFAT009   บ Autor ณ Giane              บ Data ณ  18/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Consulta itens do or็amento com legend por item.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Makeni / televendas orcamento                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AFAT009(pCliente,pLoja)

	Local aCores   := {}
	Local _aArea 	:= GetArea()

	Local aAreaSCJ  := SCJ->(GetArea())
	Local aAreaSCK  := SCK->(GetArea())
	Private aRotina   := {}
	Private cCadastro := "Itens do Or็amento"
	Private cArqTrab   := nil
	Private aFixe     := {}
	Private cFilial := xFilial("SCK")
	private oTmpTable := nil
	
	
	CriaTmp(pCliente, pLoja)

	//aAdd(aRotina, {"Pesquisar ", "U_FAT009P"   , 0, 1}) //Pesquisar
	//aAdd(aRotina, {"Visualizar", "U_FAT009V"  , 0, 2}) //Visualizar
	aAdd(aRotina, {"Filtro"    , "U_FAT009F"  , 0, 3}) //FiltrarAD
	aAdd(aRotina, {"Legenda"   , "U_FAT009LG" , 0, 7}) //Legenda

	aCores := {	{ 'CJ_STATUS=="A"' , 'ENABLE' },; 	//Orcamento em Aberto
	{ 'CJ_STATUS=="B"' , 'DISABLE'},;					//Orcamento Baixado
	{ 'CJ_STATUS=="C"' , 'BR_PRETO'},;					//Orcamento Cancelado
	{ 'CJ_STATUS=="D"' , 'BR_AMARELO'},;				//Orcamento nao Orcado
	{ 'CJ_STATUS=="F"' , 'BR_MARROM' }}				//Orcamento bloqueado

	dbSelectArea( cArqTrab)

	mBrowse( 6,1,22,75,cArqTrab, aFixe, , , , , aCores, 'xFilial("SCJ")','xFilial("SCJ")'  )


	(cArqTrab)->(DbCloseArea())

	If oTmpTable <> Nil
		oTmpTable:Delete()
		oTmpTable := Nil
	Endif
		
	//A415Monta(cArqSCK,cArqSCL,.F.)
	RestArea(_aArea)
	RestArea(aAreaSCJ)
	RestArea(aAreaSCK) 

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaTMp   บAutor  ณGiane               บ Data ณ  18/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ cria arquivo temporario e de trabalho para montar a browse บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ makeni                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CriaTmp(pCliente,pLoja)

	Local cQuery as character
	Local nLoop as numeric
	local aStru as array	
	local cTmpAlias as character
	local cFieldX3 as character
	local cTitX3   as character 
    local cCampoX3 as character 
    local cTipoX3  as character 
    local nTamX3   as numeric 
    local nDecX3   as numeric 
	local cPicX3   as character 
	
	aStru  := {}	
	cQuery := ""
	nLoop  := 0
	cTmpAlias := getNextAlias()

	if pCliente == NIL
		pCliente := ""
	endif

	if pLoja == NIL
		pLoja := ""
	endif

	If FunName() == "AFAT009"
		cQuery := "SELECT DISTINCT CK_FILIAL AS TRB_FILIAL, CJ_NUM, CK_ITEM CJ_STATUS , CJ_EMISSAO, CJ_VALIDA, "
		cQuery += " SE4.E4_DESCRI, SB1.B1_DESC,  CK_UM, CK_QTDVEN, CK_XMOEDA, "
		cQuery += " CASE WHEN CK_XMOEDA = 2 THEN 'US$' WHEN CK_XMOEDA = 4 THEN 'EUR' WHEN CK_XMOEDA = 5 THEN 'IEN' ELSE 'R$' END AS CK_XDESMOE, "
		cQuery += " CK_PRUNIT, CK_VALOR, CK_ENTREG, A3_NOME, CK_XPRUNIT SCJRECNO "
	Else
		cQuery := "SELECT DISTINCT CK_FILIAL AS TRB_FILIAL, CJ_NUM, CK_ITEM, CJ_STATUS, CJ_EMISSAO, CJ_VALIDA, "
		cQuery += " SB1.B1_DESC, CK_UM, CK_QTDVEN, CK_XMOEDA, "
		cQuery += " CASE WHEN CK_XMOEDA = 2 THEN 'US$' WHEN CK_XMOEDA = 4 THEN 'EUR' WHEN CK_XMOEDA = 5 THEN 'IEN' ELSE 'R$' END AS CK_XDESMOE, "
		cQuery += " CK_XPRUNIT, CK_PRUNIT, SE4.E4_DESCRI, CK_VALOR, SA1.A1_CONTATO, SA3.A3_NOME,SCJ.R_E_C_N_O_ SCJRECNO "
	Endif
	cQuery += " FROM " + RetSqlName("SCJ") + " SCJ "
	cQuery += " JOIN " + RetSqlName("SCK") + " SCK ON CK_FILIAL = CJ_FILIAL AND CK_NUM = CJ_NUM AND SCK.D_E_L_E_T_ = ' '  "
	cQuery += " JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' AND B1_COD = CK_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " JOIN " + RetSqlName("SA1") + " SA1 ON A1_FILIAL = '" + xFilial("SA1") + "' AND A1_COD = CJ_CLIENTE AND A1_LOJA = CJ_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += " JOIN " + RetSqlName("SE4") + " SE4 ON E4_FILIAL = '" + xFilial("SE4") + "' AND E4_CODIGO = CJ_CONDPAG AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += " JOIN " + RetSqlName("SA3") + " SA3 ON A3_FILIAL = '" + xFilial("SA3") + "' AND A3_COD = CJ_XVEND AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE CK_FILIAL = '" + xFilial("SCK") + "' AND  SCJ.D_E_L_E_T_ <> '*' "
	if !empty(pCliente )
		cQuery += " AND CJ_CLIENTE = '" + pCliente + "' "
	Endif
	if !empty(pLoja)
		cQuery += " AND CJ_LOJA = '" + pLoja + "' "
	Endif
	cQuery += " ORDER BY 1,2,3 "

	cQuery := ChangeQuery( cQuery )

	//MEMOWRITE("C:\QUERY.SQL",CQUERY)

	DbUseArea(.T., "TOPCONN", TcGenQry( , , cQuery ), cTmpAlias, .T., .f.)
	TCSetField(cTmpAlias, "CJ_VALIDA", "D")
	TCSetField(cTmpAlias, "CJ_EMISSAO", "D")
	TCSetField(cTmpAlias, "CK_ENTREG", "D")
	TCSetField(cTmpAlias, "CK_VALOR","N", tamSx3("CK_VALOR")[1], tamSx3("CK_VALOR")[2])

	
	If oTmpTable <> Nil
		oTmpTable:Delete()
		oTmpTable := Nil
	Endif

	cArqTrab := GetNextAlias()
	aStru    := (cTmpAlias)->(DBSTRUCT())	
	(cTmpAlias)->(dbCloseArea())	

	oTmpTable := FWTemporaryTable():New( cArqTrab )  
	oTmpTable:SetFields(aStru) 
	oTmpTable:AddIndex("1", {"TRB_FILIAL","CJ_NUM","CK_ITEM"})

	//------------------
	//Criacao da tabela temporaria
	//------------------
	oTmpTable:Create()  

	Processa({||SqlToTrb(cQuery, aStru, cArqTrab)})	// Cria arquivo temporario

	(cArqTrab)->(dbSetOrder(1))

	For nLoop := 1 To (cArqTrab)->( FCount() )

		cFieldX3 := alltrim((cArqTrab)->( FieldName( nLoop ) ))


		

		If FunName() <> "AFAT009" .And. cFieldX3 $ "CJ_CLIENTE,A1_NREDUZ,CJ_LOJA,SCJRECNO"
			Loop
		EndIf

		
		cTitX3   := getSx3Cache(cFieldX3, "X3_TITULO")  
		cCampoX3 := getSx3Cache(cFieldX3, "X3_CAMPO")  
		cTipoX3  := getSx3Cache(cFieldX3, "X3_TIPO")  
		nTamX3   := getSx3Cache(cFieldX3, "X3_TAMANHO") 
		nDecX3   := getSx3Cache(cFieldX3, "X3_DECIMAL")
		cPicX3   := getSx3Cache(cFieldX3, "X3_PICTURE") 

		If cFieldX3 == 'E4_DESCRI'
			aadd(aFixe,{"Cond.Pagto",cCampoX3,cTipoX3, nTamX3, nDecX3,cPicX3} )
		elseIf cFieldX3 == 'A3_NOME'
			aadd(aFixe,{"Vendedor",cCampoX3,cTipoX3, nTamX3, nDecX3,cPicX3} )
		elseIf cFieldX3 == 'CK_XPRUNIT'
			aadd(aFixe,{"Vlr.Unit Moeda",cCampoX3,cTipoX3, nTamX3, nDecX3,cPicX3} )
		elseIf cFieldX3 == 'CK_XMOEDA'
			aadd(aFixe,{"Moeda","CK_XDESMOE","C", 5, 0,""} )
		elseIf cFieldX3 == 'TRB_FILIAL'
			aadd(aFixe,{"Moeda","TRB_FILIAL","C", 2, 0,""} )
		else
			aadd(aFixe,{cTitX3,cCampoX3,cTipoX3, nTamX3, nDecX3,cPicX3} )
		Endif
		
	Next nLoop


Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT009LG  บAutor  ณGiane               บ Data ณ  18/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Legendas                                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ makeni                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function FAT009LG()

	Local aLegenda := {	{ 'ENABLE'    , 'Orcamento em Aberto'	},;
	{ 'DISABLE'   , 'Orcamento Baixado'		},;
	{ 'BR_PRETO'  , 'Orcamento Cancelado'	},;
	{ 'BR_AMARELO', 'Orcamento nao Orcado'	},;
	{ 'BR_MARROM' , 'Orcamento bloqueado'	}}
	BrwLegenda("Itens do Or็amento", "Legenda", aLegenda)

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT009F   บAutor  ณMicrosiga           บ Data ณ  02/18/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FAT009F

	Local cFiltro := ""

	cFiltro := XBuildEx(cArqTrab)

	If !Empty( cFiltro )
		(cArqTrab)->( MsFilter( cFiltro ) )
	Else
		(cArqTrab)->( DbClearFilter() )
	EndIf

	(cArqTrab)->( dbGoTop() )

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMGAV002   บAutor  ณMicrosiga           บ Data ณ  02/18/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function XBuildEx(cAlias, oWnd, cFilter, lTopFilter, bOk, oDlg, aUsado, cDesc, nRow, nCol )
	Local aCampo := {}, aCpo := {}, oBtnE,oBTNou, oBTNa,oBtnExp
	Local oBtn, cCampo := "", aStrOp, cOper, oExpr, cExpr, oCampo, oBtnOp
	Local cTxtFil := "", cExpFil := "", oTxtFil, oOper, oMatch, nMatch := 0
	Local lOk , lConfirma := .f.	, cRet := ""
	Local oConf
	Local cOperAnd	:= ' .AND. '
	Local cOperOr	:= ' .OR. '
	Local lCreateDlg := (oDlg == Nil)
	Local nColBtn	 := 136
	Local nLoop
	local cFieldX3 as character
	local cTitX3   as character 
    local cCampoX3 as character 
    local cTipoX3  as character 
    local nTamX3   as numeric 
    local nDecX3   as numeric 
	local cPicX3   as character 
	local cUsadoX3 as character
	local cOrdemX3 as character

	DEFAULT cAlias 		:= ALIAS()
	DEFAULT cFilter		:= ""
	DEFAULT oWnd 		:= GetWndDefault()
	DEFAULT lTopFilter	:= .F.
	DEFAULT bOk			:= {|| Nil}
	DEFAULT aUsado		:= {}
	DEFAULT nRow		:= 0
	DEFAULT nCol		:= 0

	#ifdef TOP
	If ( lTopFilter )
		cOperAnd := ' AND '
		cOperOr	 := ' OR '
	EndIf
	#endif

	CursorWait()

	For nLoop := 1 To (cArqTrab)->( fCount() )
		cFieldX3 := (cArqTrab)->( FieldName( nLoop ) )
		cTitX3   := getSx3Cache(cFieldX3, "X3_TITULO")  
		cCampoX3 := getSx3Cache(cFieldX3, "X3_CAMPO")  
		cTipoX3  := getSx3Cache(cFieldX3, "X3_TIPO")  
		nTamX3   := getSx3Cache(cFieldX3, "X3_TAMANHO") 
		nDecX3   := getSx3Cache(cFieldX3, "X3_DECIMAL")
		cPicX3   := getSx3Cache(cFieldX3, "X3_PICTURE") 
		cUsadoX3 := getSx3Cache(cFieldX3, "X3_USADO") 
		cOrdemX3 := getSx3Cache(cFieldX3, "X3_ORDEM") 

		AADD(aCampo,{cFieldX3,cTitX3,If(!x3Uso(cUsadoX3),.f.,.t.),cOrdemX3,nTamX3,Trim(cPicX3),cTipoX3,nDecX3})
		AADD(aCpo,OemtoAnsi(cTitX3))

	Next nLoop

	DbSelectArea(cAlias)

	cExpfil := Iif(Empty(cFilter),dbFilter(),cFilter)
	If !Empty(cExpFil)
		cRet := cExpFil
		cTxtFil := MontDescr(cAlias,cExpfil, lTopFilter)
	EndIf

	CursorArrow()

	cDesc  := OemToAnsi("Expressฦo de Filtro") + If(Empty(cDesc),""," - " + cDesc)	//
	cCampo := aCpo[1]

	If lCreateDlg
		nRow := 0
		nCol := 0
		DEFINE MSDIALOG oDlg FROM	20,10 TO 218, 408 TITLE cDesc PIXEL
	Else
		nColBtn := 166 + nCol
	EndIf

	//Public nLastKey := 0

	DEFINE SBUTTON oConf FROM 78+nRow, nColBtn TYPE 1 DISABLE OF oDlg;
	ACTION ((If(lOk := (nMatch==0),nil,Help("",1,"NOMATCH")),If(lOk,lOk := ValidFilter(@cExpFil, lTopFilter),nil),If(lOk,lConfirma:=.T.,nil), If(lOk,oDlg:End(),nil)),If(!lCreateDlg .And. cExpFil<>Nil,(cFilter:=cExpFil,Eval(bOk),oConf:Disable()),))
	oConf:Cargo := "BUILDEXPR"

	If lCreateDlg
		DEFINE SBUTTON FROM 78, 166 TYPE 2 ENABLE OF oDlg ACTION (oDlg:End())
	EndIf
	aStrOp := { OemToAnsi("Igual a"),OemToAnsi("DIferente de"),OemToAnsi("Menor que"),OemToAnsi("Menor ou igual a"),OemToAnsi("Maior que"),OemToAnsi("Maior ou igual a"),OemToAnsi("Contm a expresso"),OemToANsi("No contm"),OemToANsi("Est  contido em"),OemToAnsi("No est  contido em")}
	//aStrOp := { OemToAnsi(STR0044),OemToAnsi(STR0045),OemToAnsi(STR0046),OemToAnsi(STR0047),OemToAnsi(STR0048),OemToAnsi(STR0049),OemToAnsi(STR0068),OemToANsi(STR0069),OemToANsi(STR0050),OemToAnsi(STR0070)}	// "Igual a" ### "DIferente de"  ### "Menor que"  ### "Menor ou igual a" ### "Maior que" ### "Maior ou igual a" ### "Contm a expresso" ### "No contm" ###"Est  contido em" ### "No est  contido em"

	@ 14+nRow, 04+nCol COMBOBOX oCampo VAR cCampo ITEMS aCpo SIZE 52, 28 OF oDlg PIXEL ;
	ON CHANGE BuildGet(oExpr,@cExpr,aCampo,oCampo,oDlg,,oOper:nAt)
	oCampo:Cargo := "BUILDEXPR"

	cExpr := CalcField(oCampo:nAt,aCampo)
	cOper := aStrOp[1]
	@ 14+nRow, 60+nCol COMBOBOX oOper VAR cOper ITEMS aStrOp SIZE 60, 32 OF oDlg PIXEL ;
	ON CHANGE BuildGet(oExpr,@cExpr,aCampo,oCampo,oDlg,,oOper:nAt)
	oOper:Cargo := "BUILDEXPR"

	@ 14+nRow, 124+nCol GET oExpr VAR cExpr SIZE 73, 9 OF oDlg PIXEL PICTURE AllTrim(aCampo[oCampo:nAt,6]) FONT oDlg:oFont
	oExpr:Cargo := "BUILDEXPR"

	@ 06+nRow, 04+nCol  SAY OemToAnsi("Campos:")  SIZE 39, 7 OF oDlg PIXEL	//
	@ 06+nRow, 60+nCol  SAY OemToAnsi("Operadores:")  SIZE 39, 7 OF oDlg PIXEL	//
	@ 06+nRow, 124+nCol SAY OemToAnsi("Expresso:")  SIZE 53, 7 OF oDlg PIXEL	//
	@ 46+nRow, 05+nCol  SAY OemToAnsi("Expresso:")  SIZE 53, 7 OF oDlg PIXEL	// x

	@ 31+nRow, 04+nCol BUTTON oBtnA PROMPT OemToAnsi("&Adiciona") SIZE 33,11 OF oDlg PIXEL ACTION (oConf:SetEnable(.t.),cTxtFil := BuildTxt(cTxtFil,Trim(cCampo),cOper,cExpr,.t.,@cExpFil,aCampo,oCampo:nAt,oOper:nAt, lTopFilter ),cExpr := CalcField(oCampo:nAt,aCampo),BuildGet(oExpr,@cExpr,aCampo,oCampo,oDlg,,oOper:nAt),oTxtFil:Refresh(),oBtnE:Enable(),oBtnOp:Disable(),oBtnOu:Enable(),oBtne:Refresh(),oBtnOu:Refresh(),oBtnExp:Disable(),oBtna:Disable(),oBtna:Refresh())  //
	oBtnA:oFont := oDlg:oFont
	oBtnA:Cargo := "BUILDEXPR"
	@ 31+nRow, 42+nCol BUTTON oBtn 	 PROMPT OemToAnsi("&Limpa Filtro") SIZE 33,  11 OF oDlg PIXEL ACTION (oConf:SetEnable(.t.),cTxtFil := "",cExpFil := "",nMatch := 0,oTxtFil:Refresh(),oBtnA:Enable(),oBtnE:Disable(),oBtnOU:Disable(),oMatch:Disable(),oBtnOp:Enable(),oConf:Refresh()) ; oBtn:oFont := oDlg:oFont   //
	oBtn:Cargo := "BUILDEXPR"
	@ 31+nRow, 80+nCol BUTTON oBtnExp  PROMPT OemToAnsi("&Expresso") 	SIZE 33,  11 OF oDlg PIXEL ACTION (lRet:=FilterExp(@cTxtFil,@cExpFil),oTxtFil:Refresh(),If(lRet,(oBtnOp:Disable(),oConf:SetEnable(.t.)),(oBtnOp:Enable(),oConf:SetEnable(.F.))),If(lRet,oBtnExp:Disable(),oBtnExp:Enable()) ,If(lRet,oBtna:Disable(),oBtna:Enable()),If(lRet,oBtnE:Enable(),oBtnE:Disable()),If(lRet,oBtnOu:Enable(),oBtnOu:Disable())) ;oBtnExp:oFont := oDlg:oFont  //
	oBtnExp:Cargo := "BUILDEXPR"

	@ 53+nRow, 05+nCol  GET oTxtFil VAR cTxtFil				SIZE 190, 20 OF oDlg PIXEL MEMO COLOR CLR_BLACK,CLR_HGRAY READONLY
	oTxtFil:bRClicked := {||AlwaysTrue()}
	oTxtFil:Cargo := "BUILDEXPR"

	@ 25+nRow, 172+nCol BUTTON oBtnOp PROMPT "("  SIZE 10, 11 OF oDlg PIXEL ACTION (If(nMatch==0,oMatch:Enable(),nil),nMatch++,cTxtFil+= " ( ",cExpFil+="(",oTxtFil:Refresh()) ; oBtnOp:oFont := oDlg:oFont
	oBtnOp:Cargo := "BUILDEXPR"
	@ 25+nRow, 185+nCol BUTTON oMatch PROMPT ")"  SIZE 10, 11 OF oDlg PIXEL ACTION (nMatch--,cTxtFil+= " ) ",cExpFil+=")",If(nMatch==0,oMatch:Disable(),nil),oTxtFil:Refresh()) ; oMatch:oFont := oDlg:oFont
	oMatch:Cargo := "BUILDEXPR"
	@ 38+nRow, 172+nCol BUTTON oBtne	PROMPT OemToAnsi("e")	SIZE 10, 11 OF oDlg PIXEL ACTION (cTxtFil+=".AND.",cExpFil += cOperAnd ,oTxtFil:Refresh(),oBtne:Disable(),oBtnou:Disable(),oBtnExp:Enable(),oBtnA:Enable(),oBtne:Refresh(),oBtnou:Refresh(),oBtnA:Refresh(),oBtnOp:Enable()) ; oBtne:oFont := oDlg:oFont  // "e"
	oBtne:Cargo := "BUILDEXPR"
	@ 38+nRow, 185+nCol BUTTON oBtnOU PROMPT OemToAnsi("ou")	SIZE 10, 11 OF oDlg PIXEL ACTION (cTxtFil+=".OR.",cExpFil += cOperOr ,oTxtFil:Refresh(),oBtne:Disable(),oBtnou:Disable(),oBtnExp:Enable(),oBtnA:Enable(),oBtne:Refresh(),oBtnou:Refresh(),oBtna:Refresh(),oBtnOp:Enable()) ; oBtnou:oFont := oDlg:oFont // "ou"
	oBtnOU:Cargo := "BUILDEXPR"

	If ( ! Empty(cExpFil) )
		oBtnA:Disable()
		oBtn:Enable()
		oBtnExp:Disable()
		oBtnOp:Disable()
		oMatch:Disable()
		oBtnE:Enable()
		oBtnOu:Enable()
	Else
		oMatch:Disable()
		oBtnE:Disable()
		oBtnOu:Disable()
	EndIf

	If lCreateDlg
		ACTIVATE MSDIALOG oDlg CENTERED
		If lConfirma
			If cExpFil # Nil
				cRet := cExpFil
			EndIf
		Else
			//	nLastKey := 27
		EndIf
	EndIf
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCALCFIELD บAutor  ณMicrosiga           บ Data ณ  02/18/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//------------------------------------------------------------------------------------//
Static ;
Function CalcField(nAt,aCampo)
	Local cRet

	If aCampo[nAt,7] == "C"
		cRet := Space(aCampo[nAt,5])
	ElseIf aCampo[nAt,7] == "N"
		cRet := 0
	ElseIf aCampo[nAt,7] == "D"
		cRet := CTOD("  /  /  ")
	EndIf
Return cRet

//------------------------------------------------------------------------------------//
Static Function FilterExp(cTxtFil,cExpFil)

	Local oDlg, oBtn, cExpr := Space(255), oPai
	Local lProcess := .f.

	oPai:= GetWndDefault()

	DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Expressใo" ) FROM 0,0 TO 100,500 OF oPai PIXEL

	@ 10,10 MSGET oExpr VAR cExpr SIZE 230,10 OF oDlg PIXEL

	@ 30,10 TO 30,240 OF oDlg PIXEL

	@ 35,10 BUTTON oBtn PROMPT OemToAnsi("&Adiciona") SIZE 40,10 PIXEL ACTION (lProcess := .t.,oDlg:End()) //

	@ 35,55 BUTTON oBtn PROMPT OemToAnsi("&Cancela") SIZE 40,10 PIXEL ACTION oDlg:End() //

	ACTIVATE MSDIALOG oDlg CENTERED

	If lProcess

		VldLenFilter( @cExpFil, @cTxtFil, Trim(cExpr), Trim(cExpr) )

		// Retorno correto para o Enable/Disable dos botoes.
		If Empty(cExpr)
			lProcess:= .F.
		EndIf

	EndIf
Return lProcess

//------------------------------------------------------------------------------------//
Static Function ValidFilter(cExpr, lTopFilter)
	Local lRet := .f., cRet, oErro := ErrorBlock({|e| FilterErro(e)})
	DEFAULT lTopFilter := .F.

	If ( ! Empty(cExpr) ) .And. ( ! lTopFilter )
		/*/
		#ifdef TOP						// Limpando o dToS(
		While (nAt := AT("dToS(",cExpr)) > 0
		cExpr := Subs(cExpr,1,nAT-1)+Subs(cExpr,nAt+5)
		For ni:= nAT to Len(cExpr)
		If Subs(cExpr,ni,1) == ")"
		cExpr := Subs(cExpr,1,ni-1)+Subs(cExpr,ni+1)
		Exit
		EndIf
		Next
		End
		#endif
		/*/
		BEGIN SEQUENCE
			cRet := &(cExpr)
			lRet := .t.
		End SEQUENCE
	Else
		lRet := .t.
	EndIf
	ErrorBlock(oErro)

Return lRet

//------------------------------------------------------------------------------------//
Static Function FilterErro(e)

	If e:gencode > 0
		Help(" ",1,"FILTERR")
		BREAK
	EndIf

Static ;
Function BuildTxt(cTxtFil,cCampo,cOper,xExpr,lAnd,cExpFil,aCampo,nCpo,nOper, lTopFilter)
	Local cChar := OemToAnsi(CHR(39))
	Local cType := ValType(xExpr)
	Local aOper := { "==","!=","<","<=",">",">=","..","!.","$","!x"}
	Local cTxtFilNew := cCampo+" "+cOper+" "+If(cType=="C",cChar,"")+AllTrim(cValToChar(xExpr))+If(cType=="C",cChar,"")
	Local cExpFilNew := ""
	Local cField	:= ''
	Local cExpFilVal := ""
	Local cByte := "'"

	DEFAULT lTopFilter := .F.

	If ( ! lTopFilter )

		cOper 	:= aOper [nOper]
		cField 	:= Trim(aCampo[nCpo,1])

		If cType == "C"
			#ifndef TOP
			If cOper == "!."    //  Nao Contem
				cExpFilNew += '!('+'"'+AllTrim(cValToChar(xExpr))+'"'+' $ AllTrim('+cField+'))'   // Inverte Posicoes
				VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
			ElseIf cOper == "!x"   // Nao esta contido
				cExpFilNew += '!(AllTrim('+cField+") $ " + '"'+AllTrim(cValToChar(xExpr))+'")'
				VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
			ElseIf cOper	== ".."  // Contem a Expressao
				cExpFilNew += '"'+AllTrim(cValToChar(xExpr))+'"'+" $ AllTrim("+cField +")"   // Inverte Posicoes
				VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
			ENDIF
			#else
			If  cOper == "!."    //  Nao Contem
				cExpFilNew += '!('+'"'+AllTrim(cValToChar(xExpr))+'"'+' $ '+cField+')'   // Inverte Posicoes
				VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
			ElseIf cOper == "!x"   // Nao esta contido
				cExpFilNew += '!('+cField+" $ " + '"'+AllTrim(cValToChar(xExpr))+'")'
				VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
			ElseIf cOper	== ".."  // Contem a Expressao
				cExpFilNew += '"'+AllTrim(cValToChar(xExpr))+'"'+" $ "+cField +" "   // Inverte Posicoes
				VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
			ENDIF
			#endif

			#ifndef TOP
			If (cOper=="==")
				cExpFilNew += cField + ' ' + cOper + ' '
				cExpFilNew += '"'+cValToChar(xExpr)+'"'
				VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
			Else
				cExpFilNew += 'AllTrim('+cField +') ' + cOper + ' '
				cExpFilNew += '"'+AllTrim(cValToChar(xExpr))+'"'
				VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
			EndIf
			#else
			If ( cOper == "==" )
				cExpFilNew += cField + ' ' + cOper + ' '
				cExpFilNew += '"'+cValToChar(xExpr)+'"'
				VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
			Else
				cExpFilNew += 'AllTrim('+cField +') ' +cOper + ' '
				cExpFilNew += '"'+AllTrim(cValToChar(xExpr))+'"'
				VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
			EndIf
			#endif
		ElseIf cType == "D"
			// Nao Mexer, deixar dToS pois e'a FLAG Para Limpeza do Filtro
			// 						 ____
			cExpFilNew += "dToS("+cField+") "+cOper+' "'
			cExpFilNew += Dtos(CTOD(cValToChar(xExpr),"DEFAULT"))+'"'
			VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
		Else
			cExpFilNew += cField+" "+cOper+" "
			cExpFilNew += cValToChar(xExpr)
			VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
		EndIf

	Else

		//	{ "==","!=","<","<=",">",">=","..","!.","$","!x"}
		#ifdef TOP
		cOper 	:= aOper [nOper]
		cField 	:= Trim(aCampo[nCpo,1])
		cExpFilVal := cValToChar(xExpr)

		If ( cType == 'D' )
			cExpFilVal := Dtos(CTOD(cExpFilVal,"DEFAULT"))
		ElseIf ( cType <> 'C' )
			cByte := ""
		EndIf

		If ( cOper == '==' )
			cExpFilNew += cField + '='
			cExpFilNew += cByte+cExpFilVal+cByte
		ElseIf ( cOper == '!=' )
			cExpFilNew += cField + '<>'
			cExpFilNew += cByte+cExpFilVal+cByte
		ElseIf ( cOper == '$' )						// Esta contido
			cExpFilNew += cField + " IN (" + cByte + AllTrim(cExpFilVal) + cByte + ")"
		ElseIf ( cOper == '!x' )						// Nao Esta contido
			cExpFilNew += cField + " NOT IN (" + cByte + AllTrim(cExpFilVal) + cByte + ")"
		ElseIf ( cOper == '..' )					// Contem a expressao
			cExpFilNew += cField + " LIKE " + cByte + "%" + AllTrim(cExpFilVal) + "%" + cByte
		ElseIf ( cOper == '!.' )					// Nao Contem a expressao
			cExpFilNew += cField + " NOT LIKE " + cByte + "%" + AllTrim(cExpFilVal) + "%" + cByte
		Else
			cExpFilNew += cField + cOper
			cExpFilNew += cByte+cExpFilVal+cByte
		EndIf
		VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
		#endif

	EndIf

Return cTxtFil

Static ;
Function VldLenFilter( cExpFil, cTxtFil, cExpr, cTxtExpr )
	Local cExpSave := If( cExpFil==Nil, '', cExpFil )
	Local cTxtSave := If( cTxtFil==Nil, '', cTxtFil )

	If cExpFil  != Nil
		cExpFil += cExpr
		If cTxtExpr != Nil
			cTxtFil += cTxtExpr
		EndIf
		If Len(cExpFil) > 600
			MsgAlert('Expressao de filtro nao pode conter mais de 600 caracteres!')
			cExpFil := cExpSave
			cTxtFil := cTxtSave
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT009V   บAutor  ณIVAN                บ Data ณ  02/18/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FAT009V
	Local RECNOOrc := SCJ->(RECNO())
	Local aAreaAtu := GetArea()

	A415Visual("SCJ", SCJ->(RecNo() ) ,2)

	RestArea( aAreaAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT009P   บAutor  ณIVAN                บ Data ณ  02/18/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FAT009P

	Local aAreaAtu := GetArea()
	Local oTeste


	DbSelectArea("TRB")
	DbClearIndex()

	dbSetIndex( cArqTRB+"1" + OrdBagExt() )
	dbSetIndex( cArqTRB+"2" + OrdBagExt() )

	(cArqTrab)->( dbGotop() )
	dBsetOrder(1)

	AxPesqui()

	oTeste := getobjbrow()
	oTeste:Refresh()

	RestArea( aAreaAtu )

Return
