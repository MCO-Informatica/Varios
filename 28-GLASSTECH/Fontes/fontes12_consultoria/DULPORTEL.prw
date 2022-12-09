//Bibliotecas
#Include "TOTVS.ch"
 
/*/{Protheus.doc} User Function zPulo1
Demonstração de como usar a FWLayer
@type Function
@author Douglas Rodrigues da Silva
@since 27/09/2021
@version 2.0
/*/
 
User Function DULPORTEL()

	Local aArea := GetArea()
 
	fMontaTela()
 
	RestArea(aArea)

Return
 
 Static Function fMontaTela()

	//Objetos e componentes
	Private oDlgPulo	:= Nil
	Private oFwLayer	:= Nil
	Private oPanTitulo	:= Nil
	Private oPanGrid	:= Nil
	//Cabeçalho
	Private oSayModulo	:= Nil
	Private oSayTitulo	:= Nil
	Private oSaySubTit	:= Nil

	Private cSayModulo	:= ''
	Private cSayTitulo	:= ''
	Private cSaySubTit	:= ''

	//Tamanho da janela
	Private aSize		:= MsAdvSize(.F.)
	Private nJanLarg	:= 900
	Private nJanAltu	:= 400
	//Fontes
	Private cFontUti	:= "Tahoma"
	Private oFontMod	:= TFont():New(cFontUti, , -38)
	Private oFontSub	:= TFont():New(cFontUti, , -20)
	Private oFontSubN	:= TFont():New(cFontUti, , -20, , .T.)
	Private oFontBtn	:= TFont():New(cFontUti, , -14)
	Private oFontSay	:= TFont():New(cFontUti, , -12)
	//Grid
	Private aCampos		:= {}
	Private cAliasTmp	:= RetCodUsr()
	Private aColunas	:= {}
 
	//Campos da Temporária
	aAdd(aCampos, { "VENCI" , "D", TamSX3("E1_EMISSAO")[1]	, 0 })
	aAdd(aCampos, { "VALOR" , "N", TamSX3("E1_VALOR")[1]	, 2 })
 
	//Cria a tabela temporária
	oTempTable:= FWTemporaryTable():New(cAliasTmp)
	oTempTable:SetFields( aCampos )
	oTempTable:Create()
 
	//Busca as colunas do browse
	aColunas := fCriaCols()
 
	//Popula a tabela temporária
	fPopula()
 
	//Cria a janela
	DEFINE MSDIALOG oDlgPulo TITLE "Planilha Financeira" FROM 0, 0 TO nJanAltu, nJanLarg PIXEL
 
		//Criando a camada
		oFwLayer := FwLayer():New()
		oFwLayer:init(oDlgPulo,.F.)
 
		//Adicionando 3 linhas, a de título, a superior e a do calendário
		oFWLayer:addLine("TIT", 10, .F.)
		oFWLayer:addLine("COR", 90, .F.)
 
		//Adicionando as colunas das linhas
		oFWLayer:addCollumn("HEADERTEXT"	, 050	, .T.	, "TIT")
		oFWLayer:addCollumn("BLANKBTN"		, 040	, .T.	, "TIT")
		oFWLayer:addCollumn("BTNSAIR"		, 010	, .T.	, "TIT")
		oFWLayer:addCollumn("COLGRID"		, 100	, .T.	, "COR")
 
		//Criando os paineis
		oPanHeader := oFWLayer:GetColPanel("HEADERTEXT"	, "TIT")
		oPanSair := oFWLayer:GetColPanel("BTNSAIR"	, "TIT")
		oPanGrid := oFWLayer:GetColPanel("COLGRID"	, "COR")
 
		//Títulos e SubTítulos
		oSayModulo := TSay():New(004, 003, {|| cSayModulo}, oPanHeader, "", oFontMod, , , , .T., RGB(149, 179, 215), , 200, 30, , , , , , .F., , )
		oSayTitulo := TSay():New(004, 045, {|| cSayTitulo}, oPanHeader, "", oFontSub, , , , .T., RGB(031, 073, 125), , 200, 30, , , , , , .F., , )
		oSaySubTit := TSay():New(014, 045, {|| cSaySubTit}, oPanHeader, "", oFontSubN, , , , .T., RGB(031, 073, 125), , 300, 30, , , , , , .F., , )
 
		//Cria a grid
		oGetGrid := FWBrowse():New()
		oGetGrid:SetDataTable()
		oGetGrid:SetInsert(.F.)
		oGetGrid:SetDelete(.F., { || .F. })
		oGetGrid:SetAlias(cAliasTmp)
		oGetGrid:DisableReport()
		oGetGrid:DisableFilter()
		oGetGrid:DisableConfig()
		oGetGrid:DisableReport()
		oGetGrid:DisableSeek()
		oGetGrid:DisableSaveConfig()
		oGetGrid:SetFontBrowse(oFontSay)
		oGetGrid:SetColumns(aColunas)
		oGetGrid:SetOwner(oPanGrid)
		oGetGrid:Activate()
	Activate MsDialog oDlgPulo Centered
	oTempTable:Delete()
Return

Static Function fCriaCols()

	Local nAtual	:= 0 

	Local aColunas	:= {}
	Local aEstrut	:= {}

	Local oColumn	:= Nil

	//Adicionando campos que serão mostrados na tela
	//[1] - Campo da Temporaria
	//[2] - Titulo
	//[3] - Tipo
	//[4] - Tamanho
	//[5] - Decimais
	//[6] - Máscara
	aAdd(aEstrut, {"VENCI"	, "Vencimento"	,"D", TamSX3('E1_EMISSAO')[01]	, 0, ""})
	aAdd(aEstrut, {"VALOR"	, "Valor"		,"N", TamSX3('E1_VALOR')[01]	, 2, PesqPict("SE1","E1_VALOR")})
 
	//Percorrendo todos os campos da estrutura
	For nAtual := 1 To Len(aEstrut)
		//Cria a coluna
		oColumn := FWBrwColumn():New()
		oColumn:SetData(&("{|| (cAliasTmp)->" + aEstrut[nAtual][1] +"}"))
		oColumn:SetTitle(aEstrut[nAtual][2])
		oColumn:SetType(aEstrut[nAtual][3])
		oColumn:SetSize(aEstrut[nAtual][4])
		oColumn:SetDecimal(aEstrut[nAtual][5])
		oColumn:SetPicture(aEstrut[nAtual][6])
		oColumn:bHeaderClick := &("{|| fOrdena('" + aEstrut[nAtual][1] + "') }")
 
		//Adiciona a coluna
		aAdd(aColunas, oColumn)
	Next
Return aColunas

Static Function fPopula()

	Local nX

	For nX := 1 To Len(aDupl)
		RecLock(cAliasTmp, .T.)
			(cAliasTmp)->VENCI := aDupl[nX][1]
			(cAliasTmp)->VALOR := aDupl[nX][2]
		(cAliasTmp)->(MsUnlock())
	Next nX

Return
