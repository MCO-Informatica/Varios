#include "totvs.ch"

&& U_ZCONDPAD('SB1',{'B1_FILIAL','B1_COD','B1_DESC','B1_TIPO'},'B1_COD')
&& U_ZCONDPAD('SA1',{'A1_COD','A1_NOME','A1_CGC'},'A1_COD')
&& U_ZCONDPAD('SX5',{'X5_TABELA','X5_CHAVE','X5_DESCRI'},'X5_CHAVE',"X5_TABELA = '21' AND SUBSTR(X5_CHAVE,1,1) IN ('C')",'A1_GRPTRIB')
User Function ZCONDPAD(cAlias,aCampo,cRet,cFilter,cCpoRet,cIndice)
	Private oBtnPesq
	Private oCBContem
	Private lCBContem := .T.
	Private oCBDifer
	Private lCBDifer := .F.
	Private oCBIgual
	Private lCBIgual := .F.
	Private oComboBo1
	Private nComboBo1 := 1
	Private oGetPesq
	Private cPesq := Space(60)
	Private olbDados
	Private nlbDados := 1
	Private aItems:= {}
	Private oDlg
	Private aList:={}
	Private aInd:={}
	Private cTabela := cAlias
	Private aCampos := AClone(aCampo)
	Private aHeadCon:= {}
	Private cNameAlias := ''
	Private aHeader := {}
	Private abLine := {}
	Private cRET := cRet
	Private nPos := 0
	Private cPerg := "ZPCOLP"
	Private oDlg
	Private oDlg2
	Private _stru:={}
	Private aCpoBro := {}
	Private lInverte := .F.
	Private cMark   := GetMark()
	Private oMark
	Private nVlrFrete := 0
	Private dDtFrete := Date()
	Private lRet := .T.
	Private aDados := {}
	Private cFiltro := ''
	Private cChave	:= ''
	Private cBanco  := AllTrim(GetSrvProfString("TopDataBase", ""))
	Default cFilter := ''
	
	Default cIndice := ''
	
	cFiltro := cFilter
	cChave  := cIndice

	DbSelectArea('SX2')
	DbSeek(cTabela)
	cNameAlias := ALLTRIM(SX2->X2_NOME)
	SX2->(DbCloseArea())

	_nPos := Ascan(aCampos, {|aVal|aVal == cRet})

	aHeadCon := GETNAME(aCampos)

	aInd:= GETINDICE(aCampos)

	DEFINE MSDIALOG oDlg TITLE "Consulta Padrão - " + cNameAlias  FROM 000, 000  TO 380, 480 COLORS 0, 16777215 PIXEL

	@ 032, 003 CHECKBOX oCBContem VAR lCBContem PROMPT "Contém" SIZE 031, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 018, 003 MSGET oGetPesq VAR cPesq SIZE 190, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 008, 198 BUTTON oBtnPesq  PROMPT "Pesquisar" SIZE 037, 012 OF oDlg action Popula(cPesq)  PIXEL
	@ 003, 003 MSCOMBOBOX oComboBo1 VAR nComboBo1 SIZE 191, 010 OF oDlg COLORS 0, 16777215 PIXEL
	oComboBo1:SetItems(aInd)
	oComboBo1:Refresh()

	Popula(cPesq)

	olbDados := TCBrowse():New(042, 003, 235, 130 ,,aHeadCon,{20,50,50,50},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)
	olbDados :SetArray(aList)
	olbDados:bLine := { || {aList[olbDados:nAt,1], aList[olbDados:nAt,2],aList[olbDados:nAt,3] } }
	olbDados:bLDblClick   := {|| CRET:=aList[olbDados:nAt,_nPos],oDlg:End() }

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| CRET:=aList[olbDados:nAt,_nPos],oDlg:End() },{|| oDlg:End()})



Return (M->&(cCpoRet) := Alltrim(CRET))

Static Function ZVCHKCON()

	If lCBContem
		lCBIgual := .F.
		lCBDifer := .F.
	EndIf

	oCBIgual:Refresh()
	oCBDifer:Refresh()

Return

Static Function ZVCHKIGU()

	If lCBIgual
		lCBContem := .F.
		lCBDifer  := .F.
	EndIf

	oCBContem:Refresh()
	oCBDifer:Refresh()

Return

Static Function ZVCHKDIF()

	If lCBDifer
		lCBContem := .F.
		lCBIgual  := .F.
	EndIf

	oCBIgual:Refresh()
	oCBContem:Refresh()

Return


Static Function Popula(cPesq)
	Local aArea:=GetArea()
	Local cQuery:= ''
	Local cCampos := ''
	Local cSinal  := ''
	Local cWhere  := ''
	Local nIndPos := 0
	Local cRetCpo := ''
	Local nX	  := 0
	 
	aList := {}

	ASIZE(aList,0)

	DbSelectArea('SIX')
	DbSeek(cTabela + cValtoChar(oComboBo1:nAt))

	nIndPos := At('+',SIX->(CHAVE))

	cWhere :=  SubStr(SIX->(CHAVE),nIndPos+1)
	
	If !Empty(cChave)
		cWhere := Alltrim(cWhere) + "+" + cChave
	EndIf

	For nX := 1 To Len(aCampos)
		cCampos+= If(Empty(cCampos),aCampos[nX],',' + aCampos[nX])

	Next nX

	If Empty(cPesq)
		cQuery:="Select " + cCampos + " FROM "+RetSqltab(cTabela)
		cQuery+= " where D_E_L_E_T_ = ' ' "
		If !Empty(cFiltro)
			cQuery+= " AND " + cFiltro
		EndIf
		cQuery+= " order by " + STRTran(cWhere,'+',',')
	Else
		IF lCBContem
			cQuery:= "Select " + cCampos + " FROM "+RetSqlName(cTabela)
			cQuery+= " where D_E_L_E_T_ = ' ' AND " + If('ORACLE' $ cBanco,StrTran(cWhere,'+','||'),cWhere) + " Like '%" + AllTrim(cPesq) + "%'"
			If !Empty(cFiltro)
				cQuery+= " AND " + cFiltro
			EndIf
			cQuery+= " order by " + STRTran(cWhere,'+',',')
			
		Else
			cQuery:= "Select " + cCampos + " FROM "+RetSqlName(cTabela)
			cQuery+= " where D_E_L_E_T_ = ' ' AND " + If('ORACLE' $ cBanco,StrTran(cWhere,'+','||'),cWhere) + " Like '" + AllTrim(cPesq) + "%'"
			If !Empty(cFiltro)
				cQuery+= " AND " + cFiltro
			EndIf
			cQuery+= " order by " + STRTran(cWhere,'+',',')
		EndIf
	EndIf

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"_ZZ",.F.,.F.)

	SX3->(DbSetOrder(2))
	While _ZZ->(!Eof())
		&&AADD(aList,{_ZZ->&(aCampos[1]),_ZZ->&(aCampos[2]),_ZZ->&(aCampos[3])})
		AADD(aList,{Transform(_ZZ->&(aCampos[1]),PesqPict(cTabela,aCampos[1])),Transform(_ZZ->&(aCampos[2]),PesqPict(cTabela,aCampos[2])),Transform(_ZZ->&(aCampos[3]),PesqPict(cTabela,aCampos[3]))})
		_ZZ->(DbSkip())
	End

	_ZZ->(DbCloseArea())

	If Type("olbDados") != 'U'
		olbDados:SetArray(aList)
		olbDados:bLine := { || {aList[olbDados:nAt,1], aList[olbDados:nAt,2],aList[olbDados:nAt,3] } }
		olbDados:Refresh()
	EndIF

	SIX->(DbCloseArea())

	RestArea(aArea)

Return

Static Function PDefaul(cPesq)
	Local aArea:=GetArea()
	Local cQuery:= ''
	Local cCampos := ''
	Local cSinal  := ''
	Local cWhere  := ''
	Local nIndPos := 0
	Local nX	  := 0

	aList := {}

	ASIZE(aList,0)

	DbSelectArea('SIX')
	DbSeek(cTabela + cValtoChar(oComboBo1:nAt))

	nIndPos := At('+',SIX->(CHAVE))

	cWhere :=  SubStr(SIX->(CHAVE),nIndPos+1)
	
	If !Empty(cChave)
		cWhere += "+" + cChave
	EndIf


	For nX := 1 To Len(aCampos)
		cCampos+= If(Empty(cCampos),aCampos[nX],',' + aCampos[nX])
	Next nX

	cQuery:="Select " + cCampos + " FROM "+RetSqltab(cTabela)+" order by " + cWhere

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"_ZZ",.F.,.F.)

	While _ZZ->(!Eof())
		AADD(aList,{_ZZ->&(aCampos[1]),_ZZ->&(aCampos[2])})
		_ZZ->(DbSkip())
	End

	_ZZ->(DbCloseArea())

	RestArea(aArea)

Return

Static Function GETINDICE()
	Local aIndice:= {}

	DbSelectArea('SIX')
	DbSeek(cTabela)

	While !Eof() .And. INDICE = ALLTRIM(cTabela)
		AADD(aIndice,DESCRICAO)
		DbSkip()
	EndDo

	SIX->(DbCloseArea())

Return aIndice

Static Function GETNAME(aCampo)
	Local aRet := {}
	Local nX	  := 0

	SX3->(DbSetOrder(2))

	For nX := 1 To Len(aCampo)
		If SX3->(DbSeek(aCampo[nX]))
			AADD(aRet,(SX3->(X3_TITULO)))
		EndIF
	Next nX

Return aRet


