#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'DBTREE.CH'
#INCLUDE 'HBUTTON.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RCRME001 ³ Autor ³ Adriano Leonardo    ³ Data ³ 12/08/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para controle do forecast.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RCRME001(_cCodCli,_cLojaCli,_cCodProd)

Local	_nCont		:= 0
Default _cCodCli 	:= ""
Default _cLojaCli	:= ""
Default _cCodProd	:= ""
Private _cCliente	:= _cCodCli
Private _cLoja		:= _cLojaCli
Private _cProduto	:= _cCodProd
Private oGetCli
Private cGetCli 	:= _cCliente
Private oGetGeCome
Private cGetGeCome 	:= Space(6)
Private oGetGeCont
Private cGetGeCont 	:= Space(6)
Private oGetLoja
Private cGetLoja 	:= _cLoja
Private oGetProd
Private cGetProd 	:= _cProduto
Private oGroup1
Private oGroup2
Private oGroup3
Private oSayCliente
Private oSayProd
Private oSayStatus
Private oComboBo1
Private _cRotina	:= "RCRME001"
Private oComboBo1
Private nComboBo1 	:= Year(dDataBase)-1999
Private oPanel1
Private oPanel2
Private oSay1
Private _aSize		:= MsAdvSize()
Private oFont1		:= TFont():New("Arial",,016,,.F.,,,,,.F.,.F.)
Private	_cEnter		:= CHR(13) + CHR(10)
Private _aRecnos	:= {}
Private oButton1
Private oButton2
Private _nTamBtn	:= 060
Private _nEspPad	:= 015
Private oSay1
Private oSay2
Private oSay3
Private _nDiasEdit	:= SuperGetMV("MV_EDTFOR",,5) //Parâmetro para determinar quantos dias úteis o forecast estará aberto para edição, a contar do dia 1 de cada mês.
Private _nPrcAtu	:= 0
Private _nPrcPos	:= 0
Private _nMoeda		:= 1
Private _lAnoAtu	:= .T.
Public oMSNewGeD
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Forecast" FROM _aSize[1], _aSize[1]  TO _aSize[6], _aSize[5] COLORS 0, 16777215 FONT oFont1  PIXEL
	
    @ 005, 004 GROUP oGroup1 TO 031, 246 PROMPT "Cliente" 	OF oDlg COLOR 0, 16777215 PIXEL
    @ 005, 248 GROUP oGroup2 TO 075, 428 PROMPT "Produto" 	OF oDlg COLOR 0, 16777215 PIXEL
    @ 037, 004 GROUP oGroup3 TO 075, 245 PROMPT "Gerente" 	OF oDlg COLOR 0, 16777215 PIXEL
        
    _aAnos := {}
    
    For _nCont := 2000 To Year(dDataBase)
    	AAdd(_aAnos,AllTrim(Str(_nCont)))
    Next
    
    @ 009, 435 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS _aAnos SIZE 072, 010 OF oDlg COLORS 0, 16777215 ON CHANGE AlteraAno() PIXEL
    
    _cNomeCli	:= Posicione("SA1",1,xFilial("SA1")+_cCliente + _cLoja	,"A1_NREDUZ"	)
    _cDesProd	:= Posicione("SB1",1,xFilial("SB1")+_cProduto			,"B1_DESCINT"	)
    
    cGetGeCont	:= Posicione("SA1",1,xFilial("SA1")+_cCliente + _cLoja	,"A1_VEND"	)
    cGetGeCome	:= Posicione("SA3",1,xFilial("SA3")+cGetGeCont			,"A3_GEREN"	)
    
    cGeContBkp	:= cGetGeCont
    cGeComeBkp	:= cGetGeCome
    
    _cNomCome	:= Posicione("SA3",1,xFilial("SA3")+cGetGeCome,"A3_NOME")
    _cNomCont	:= Posicione("SA3",1,xFilial("SA3")+cGetGeCont,"A3_NOME")
	
    @ 015, 010 MSGET oGetCli 	VAR cGetCli 	SIZE 045, 010 OF oDlg COLORS 0, 16777215 F3 "SA1"  	VALID cGetCli  == _cCliente		PIXEL
    @ 015, 057 MSGET oGetLoja 	VAR cGetLoja 	SIZE 024, 010 OF oDlg COLORS 0, 16777215			VALID cGetLoja == _cLoja		PIXEL
    @ 015, 253 MSGET oGetProd 	VAR cGetProd 	SIZE 060, 010 OF oDlg COLORS 0, 16777215 F3 "SB1" 	VALID cGetProd == _cProduto		PIXEL
    @ 045, 035 MSGET oGetGeCome VAR cGetGeCome 	SIZE 045, 010 OF oDlg COLORS 0, 16777215 F3 "SA3" 	VALID cGeContBkp == cGetGeCont	PIXEL
    @ 060, 035 MSGET oGetGeCont VAR cGetGeCont 	SIZE 045, 010 OF oDlg COLORS 0, 16777215 F3 "SA3" 	VALID cGeContBkp == cGetGeCont	PIXEL
    
	@ 015, 086 SAY oSayCliente 	PROMPT _cNomeCli 	SIZE 150, 007 OF oDlg COLORS 000, 16777215 PIXEL
    @ 048, 007 SAY oSay3 		PROMPT "Comercial:" SIZE 045, 007 OF oDlg COLORS 000, 16777215 PIXEL
    @ 063, 007 SAY oSay4 		PROMPT "Conta:" 	SIZE 045, 007 OF oDlg COLORS 000, 16777215 PIXEL
    @ 048, 086 SAY oSayGerCom 	PROMPT _cNomCome 	SIZE 150, 007 OF oDlg COLORS 000, 16777215 PIXEL
    @ 063, 086 SAY oSayGerCon 	PROMPT _cNomCont 	SIZE 150, 007 OF oDlg COLORS 000, 16777215 PIXEL
    
    @ 045, 254 SAY oSayProd 	PROMPT _cDesProd 	SIZE 166, 007 OF oDlg COLORS 000, 16777215 PIXEL
    @ 030, 434 SAY oSayStatus 	PROMPT "" 			SIZE 060, 007 OF oDlg COLORS 255, 16777215 PIXEL
    
    @ 005, _aSize[3]-_nTamBtn BUTTON oButton2 PROMPT "&Sair" SIZE _nTamBtn, 012 OF oDlg ACTION Fechar()	PIXEL
    
    @ 085, 005 MSPANEL oPanel2 PROMPT "oPanel2" SIZE (_aSize[5]/2)-005, _aSize[4]-30 OF oDlg COLORS 0, 16777215 RAISED
    fWBrowse()
	
    oMSNewGeD:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
    
  ACTIVATE MSDIALOG oDlg CENTERED

Return()

Static Function fWBrowse(_nAnoBase)

	Local nX		:= 1
	Local _lCriaObj	:= .F.
	Local _nAno		:= IIF(_nAnoBase<>Nil,_nAnoBase,Year(dDataBase))
	
	_nPrcAtu := U_RCRME007(_cCliente,_cLoja,_cProduto,StrZero(_nAno  ,4),"2")  // incluir parametro preço bruto
	_nPrcPos := U_RCRME007(_cCliente,_cLoja,_cProduto,StrZero(_nAno+1,4),"2")  // incluir parametro preço bruto
	
	If _nAnoBase == Nil
		aHeaderEx 	:= {}
		aColsEx		:= {}
		aFieldFill	:= {}
		aFields 	:= {Space(10),"Total Vlr.","Total Qtd.","Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez","Última Alteração"}
		aAlterFields:= {"Z2_QTM01","Z2_QTM02","Z2_QTM03","Z2_QTM04","Z2_QTM05","Z2_QTM06","Z2_QTM07","Z2_QTM08","Z2_QTM09","Z2_QTM10","Z2_QTM11","Z2_QTM12"}
		nFreeze		:= 0
		_nAnoBase	:= Year(dDataBase)
		_lCriaObj	:= .T.
		
		// Define field properties
		DbSelectArea("SX3")
		SX3->(DbSetOrder(2))
		For nX := 1 to Len(aFields)
			If nX == 1
				If SX3->(DbSeek("Z2_TOPICO"))
					Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
				EndIf
			ElseIf nX < 4
				If SX3->(DbSeek("Z2_VLM01"))
					Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
				EndIf
			ElseIf nX < Len(aFields)
				If SX3->(DbSeek("Z2_QTM"+StrZero(nX-3,2)))
					Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
				EndIf
			Else
				If SX3->(DbSeek("Z2_DATA"))
					Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
				EndIf
			EndIf
		Next nX
	Else
		aColsEx		:= {}
		aFieldFill	:= {}
	EndIf
 	
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SZ2") + _cCliente + _cLoja + PadR(_cProduto,TamSX3("Z2_PRODUTO")[01]) + AllTrim(Str((_nAnoBase + 1))) + "F")
		Reclock("SZ2",.T.)
			SZ2->Z2_FILIAL	:= xFilial("SZ2")
			SZ2->Z2_PRODUTO	:= _cProduto
			SZ2->Z2_CLIENTE	:= _cCliente
			SZ2->Z2_LOJA	:= _cLoja
			SZ2->Z2_ANO		:= _nAnoBase + 1
			SZ2->Z2_TOPICO	:= "F" //F=Forecast | B=Budget
		SZ2->(MsUnlock())
	EndIf
	
	aFieldFill	:= {}
	
	If SZ2->Z2_STATUS == "F"
 		oSayStatus:SetText("BUDGET FECHADO")
	EndIf
	
	AAdd(aFieldFill, "Forecast Posterior")
	AAdd(aFieldFill, (SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)*_nPrcPos)
	AAdd(aFieldFill, SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)
	AAdd(aFieldFill, SZ2->Z2_QTM01)
	AAdd(aFieldFill, SZ2->Z2_QTM02)
	AAdd(aFieldFill, SZ2->Z2_QTM03)
	AAdd(aFieldFill, SZ2->Z2_QTM04)
	AAdd(aFieldFill, SZ2->Z2_QTM05)
	AAdd(aFieldFill, SZ2->Z2_QTM06)
	AAdd(aFieldFill, SZ2->Z2_QTM07)
	AAdd(aFieldFill, SZ2->Z2_QTM08)
	AAdd(aFieldFill, SZ2->Z2_QTM09)
	AAdd(aFieldFill, SZ2->Z2_QTM10)
	AAdd(aFieldFill, SZ2->Z2_QTM11)
	AAdd(aFieldFill, SZ2->Z2_QTM12)
	AAdd(aFieldFill, SZ2->Z2_DATA )
	AAdd(aFieldFill,SZ2->(Recno()))
	AAdd(_aRecnos,SZ2->(Recno()))
	Aadd(aFieldFill, .F.)
	Aadd(aColsEx, aFieldFill)
	
	_cQry := "SELECT " + _cEnter
	_cQry += "B1_COD, " + _cEnter
	_cQry += "B1_DESCINT, " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "0101 AND " + AllTrim(Str(_nAnoBase)) + "0131),0) AS [JANE], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "0201 AND " + AllTrim(Str(_nAnoBase)) + "0231),0) AS [FEVE], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "0301 AND " + AllTrim(Str(_nAnoBase)) + "0331),0) AS [MARC], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "0401 AND " + AllTrim(Str(_nAnoBase)) + "0431),0) AS [ABRI], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "0501 AND " + AllTrim(Str(_nAnoBase)) + "0531),0) AS [MAIO], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "0601 AND " + AllTrim(Str(_nAnoBase)) + "0631),0) AS [JUNH], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "0701 AND " + AllTrim(Str(_nAnoBase)) + "0731),0) AS [JULH], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "0801 AND " + AllTrim(Str(_nAnoBase)) + "0831),0) AS [AGOS], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "0901 AND " + AllTrim(Str(_nAnoBase)) + "0931),0) AS [SETE], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "1001 AND " + AllTrim(Str(_nAnoBase)) + "1031),0) AS [OUTU], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "1101 AND " + AllTrim(Str(_nAnoBase)) + "1131),0) AS [NOVE], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "1201 AND " + AllTrim(Str(_nAnoBase)) + "1231),0) AS [DEZE], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "0101 AND " + AllTrim(Str(_nAnoBase)) + "1231),0) AS [QUANT]," + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_VALBRUT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase)) + "0101 AND " + AllTrim(Str(_nAnoBase)) + "1231),0) AS [VALOR] " + _cEnter
	_cQry += "FROM " +  RetSqlName("SB1") + " SB1 " + _cEnter
	_cQry += "WHERE SB1.D_E_L_E_T_='' " + _cEnter
	_cQry += "AND SB1.B1_FILIAL='" + xFilial("SB1")+ "' " + _cEnter
	_cQry += "AND SB1.B1_COD='" + _cProduto + "' " + _cEnter
	
	_cAlias := GetNextAlias()
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAlias,.T.,.F.)
	
	dbSelectArea(_cAlias)
	                    
	aFieldFill := {}
	
	If (_cAlias)->(!EOF())
		AAdd(aFieldFill, "Realizado Atual")
		AAdd(aFieldFill, (_cAlias)->VALOR)
		AAdd(aFieldFill, (_cAlias)->QUANT)
		AAdd(aFieldFill, (_cAlias)->JANE)
		AAdd(aFieldFill, (_cAlias)->FEVE)
		AAdd(aFieldFill, (_cAlias)->MARC)
		AAdd(aFieldFill, (_cAlias)->ABRI)
		AAdd(aFieldFill, (_cAlias)->MAIO)
		AAdd(aFieldFill, (_cAlias)->JUNH)
		AAdd(aFieldFill, (_cAlias)->JULH)
		AAdd(aFieldFill, (_cAlias)->AGOS)
		AAdd(aFieldFill, (_cAlias)->SETE)
		AAdd(aFieldFill, (_cAlias)->OUTU)
		AAdd(aFieldFill, (_cAlias)->NOVE)
		AAdd(aFieldFill, (_cAlias)->DEZE) 
		AAdd(aFieldFill, STOD(""))
	Else
		AAdd(aFieldFill, "Realizado Atual")
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, STOD(""))
	EndIf
	
	AAdd(_aRecnos,0)
	Aadd(aFieldFill, .F.)
	Aadd(aColsEx, aFieldFill)
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbCloseArea())

	dbSelectArea("SZ2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SZ2") + _cCliente + _cLoja + PadR(_cProduto,TamSX3("Z2_PRODUTO")[01]) + AllTrim(Str((_nAnoBase))) + "F")
		Reclock("SZ2",.T.)
			SZ2->Z2_FILIAL	:= xFilial("SZ2")
			SZ2->Z2_PRODUTO	:= _cProduto
			SZ2->Z2_CLIENTE	:= _cCliente
			SZ2->Z2_LOJA	:= _cLoja
			SZ2->Z2_ANO		:= _nAnoBase
			SZ2->Z2_TOPICO	:= "F" //F=Forecast | B=Budget
		SZ2->(MsUnlock())
	EndIf
	
	aFieldFill := {}
	
	AAdd(aFieldFill, "Forecast Atual")
	AAdd(aFieldFill, (SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)*_nPrcAtu)
	AAdd(aFieldFill, SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)
	AAdd(aFieldFill, SZ2->Z2_QTM01)
	AAdd(aFieldFill, SZ2->Z2_QTM02)
	AAdd(aFieldFill, SZ2->Z2_QTM03)
	AAdd(aFieldFill, SZ2->Z2_QTM04)
	AAdd(aFieldFill, SZ2->Z2_QTM05)
	AAdd(aFieldFill, SZ2->Z2_QTM06)
	AAdd(aFieldFill, SZ2->Z2_QTM07)
	AAdd(aFieldFill, SZ2->Z2_QTM08)
	AAdd(aFieldFill, SZ2->Z2_QTM09)
	AAdd(aFieldFill, SZ2->Z2_QTM10)
	AAdd(aFieldFill, SZ2->Z2_QTM11)
	AAdd(aFieldFill, SZ2->Z2_QTM12)
	AAdd(aFieldFill, SZ2->Z2_DATA )	
	AAdd(aFieldFill,SZ2->(Recno()))
	
	AAdd(_aRecnos,SZ2->(Recno()))
	Aadd(aFieldFill, .F.)
	Aadd(aColsEx, aFieldFill)
	
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SZ2") + _cCliente + _cLoja + PadR(_cProduto,TamSX3("Z2_PRODUTO")[01]) + AllTrim(Str((_nAnoBase))) + "B")
		Reclock("SZ2",.T.)
			SZ2->Z2_FILIAL	:= xFilial("SZ2")
			SZ2->Z2_PRODUTO	:= _cProduto
			SZ2->Z2_CLIENTE	:= _cCliente
			SZ2->Z2_LOJA	:= _cLoja
			SZ2->Z2_ANO		:= _nAnoBase
			SZ2->Z2_TOPICO	:= "B" //F=Forecast | B=Budget
		SZ2->(MsUnlock())
	EndIf

	aFieldFill := {}
	
	AAdd(aFieldFill, "Budget")
	AAdd(aFieldFill,(SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)*_nPrcAtu)
	AAdd(aFieldFill, SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)
	AAdd(aFieldFill, SZ2->Z2_QTM01)
	AAdd(aFieldFill, SZ2->Z2_QTM02)
	AAdd(aFieldFill, SZ2->Z2_QTM03)
	AAdd(aFieldFill, SZ2->Z2_QTM04)
	AAdd(aFieldFill, SZ2->Z2_QTM05)
	AAdd(aFieldFill, SZ2->Z2_QTM06)
	AAdd(aFieldFill, SZ2->Z2_QTM07)
	AAdd(aFieldFill, SZ2->Z2_QTM08)
	AAdd(aFieldFill, SZ2->Z2_QTM09)
	AAdd(aFieldFill, SZ2->Z2_QTM10)
	AAdd(aFieldFill, SZ2->Z2_QTM11)
	AAdd(aFieldFill, SZ2->Z2_QTM12)
	AAdd(aFieldFill, SZ2->Z2_DATA )	
	
	AAdd(_aRecnos,0)
	Aadd(aFieldFill, .F.)
	Aadd(aColsEx, aFieldFill)
	
	_cQry := "SELECT " + _cEnter
	_cQry += "B1_COD, " + _cEnter
	_cQry += "B1_DESCINT, " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "0101 AND " + AllTrim(Str(_nAnoBase-1)) + "0131),0) AS [JANE], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "0201 AND " + AllTrim(Str(_nAnoBase-1)) + "0231),0) AS [FEVE], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "0301 AND " + AllTrim(Str(_nAnoBase-1)) + "0331),0) AS [MARC], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "0401 AND " + AllTrim(Str(_nAnoBase-1)) + "0431),0) AS [ABRI], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "0501 AND " + AllTrim(Str(_nAnoBase-1)) + "0531),0) AS [MAIO], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "0601 AND " + AllTrim(Str(_nAnoBase-1)) + "0631),0) AS [JUNH], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "0701 AND " + AllTrim(Str(_nAnoBase-1)) + "0731),0) AS [JULH], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "0801 AND " + AllTrim(Str(_nAnoBase-1)) + "0831),0) AS [AGOS], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "0901 AND " + AllTrim(Str(_nAnoBase-1)) + "0931),0) AS [SETE], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "1001 AND " + AllTrim(Str(_nAnoBase-1)) + "1031),0) AS [OUTU], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "1101 AND " + AllTrim(Str(_nAnoBase-1)) + "1131),0) AS [NOVE], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "1201 AND " + AllTrim(Str(_nAnoBase-1)) + "1231),0) AS [DEZE], " + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "0101 AND " + AllTrim(Str(_nAnoBase-1)) + "1231),0) AS [QUANT]," + _cEnter
	_cQry += "ISNULL((SELECT SUM(D2_VALBRUT) FROM " + RetSqlName("SD2") + " SD2 WHERE SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND D2_TIPO NOT IN ('D','B') AND SD2.D2_COD=SB1.B1_COD AND D2_CF NOT IN ('5949') AND SD2.D2_CLIENTE='" + _cCliente + "' AND SD2.D2_LOJA='" + _cLoja + "' AND D2_EMISSAO BETWEEN " + AllTrim(Str(_nAnoBase-1)) + "0101 AND " + AllTrim(Str(_nAnoBase-1)) + "1231),0) AS [VALOR] " + _cEnter
	_cQry += "FROM " +  RetSqlName("SB1") + " SB1 " + _cEnter
	_cQry += "WHERE SB1.D_E_L_E_T_='' " + _cEnter
	_cQry += "AND SB1.B1_FILIAL='" + xFilial("SB1")+ "' " + _cEnter
	_cQry += "AND SB1.B1_COD='" + _cProduto + "' " + _cEnter

	_cAlias := GetNextAlias()
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAlias,.T.,.F.)
	
	dbSelectArea(_cAlias)
	                    
	aFieldFill := {}
	
	If (_cAlias)->(!EOF())
		AAdd(aFieldFill, "Realizado Ano Anterior")
		AAdd(aFieldFill, (_cAlias)->VALOR)
		AAdd(aFieldFill, (_cAlias)->QUANT)
		AAdd(aFieldFill, (_cAlias)->JANE)
		AAdd(aFieldFill, (_cAlias)->FEVE)
		AAdd(aFieldFill, (_cAlias)->MARC)
		AAdd(aFieldFill, (_cAlias)->ABRI)
		AAdd(aFieldFill, (_cAlias)->MAIO)
		AAdd(aFieldFill, (_cAlias)->JUNH)
		AAdd(aFieldFill, (_cAlias)->JULH)
		AAdd(aFieldFill, (_cAlias)->AGOS)
		AAdd(aFieldFill, (_cAlias)->SETE)
		AAdd(aFieldFill, (_cAlias)->OUTU)
		AAdd(aFieldFill, (_cAlias)->NOVE)
		AAdd(aFieldFill, (_cAlias)->DEZE)
		AAdd(aFieldFill, STOD("") 		)		
	Else
		AAdd(aFieldFill, "Realizado Anterior")
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, 0)
		AAdd(aFieldFill, STOD(""))		
	EndIf

	AAdd(_aRecnos,0)
	Aadd(aFieldFill, .F.)
	Aadd(aColsEx, aFieldFill)
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbCloseArea())
		
	If _lCriaObj
		oMSNewGeD := MsNewGetDados():New( 000, 000, 033, (_aSize[5]/2)-008, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aAlterFields,nFreeze, Len(aColsEx), "U_RCRME01A", "", "AllwaysTrue", oPanel2, aHeaderEx, aColsEx)
		oMSNewGeD:oBrowse:lUseDefaultColors := .F.
		oMSNewGeD:oBrowse:SetBlkBackColor({|| GETDCLR(oMSNewGeD:aCols,oMSNewGeD:nAt,oMSNewGeD:aHeader)})
	Else
		oMSNewGeD:aCols := aClone(aColsEx)
		oMSNewGeD:Refresh(.T.)
	EndIf
	
Return()

Static Function GETDCLR(aLinha,nLinha,aHeader)

Local nCor1 := CLR_YELLOW	//Amarelo
Local nCor2 := CLR_WHITE	//Branco
Local nCor3 := 2551400 ///*CLR_HMAGENTA */2552040  	//Laranja
Local nCor4 := CLR_HCYAN    //Ciano claro
Local nCor5 := CLR_WHITE	//Branco

If nLinha == 1
	nRet := nCor1
ElseIf nLinha == 2 .Or. nLinha == 3
	nRet := nCor2
ElseIf nLinha == 4
	nRet := nCor3
ElseIf nLinha == 5
	nRet := nCor4
Else
	nRet := nCor5
EndIf

Return(nRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RPCPC02A ³ Autor ³ Adriano Leonardo    ³ Data ³ 15/09/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável por validar a digitação da célula e     º±±
±±º          ³ gravar os valores definidos pelo usuário.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ'ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RCRME01A()

Local _lRet			:= .T.
Local _nLin			:= oMSNewGeD:oBrowse:nAt
Local nEDTFME       := SuperGetMV("MV_EDTFME",,2) //Quantidade de meses a frente para proteger apos o 10 dia
Local cMesMaisX   := ""  
Local cMesCol     := ""  
Private _nDiasEdit	:= SuperGetMV("MV_EDTFOR",,5) //Parâmetro para determinar quantos dias úteis o forecast estará aberto para edição, a contar do dia 1 de cada mês.


Private _lDetalhe 	:= .T.  

_lBlafc:= SuperGetMv('MV_BLQALFC',,.T.) // Bloqueia ou libera a alteração do forecast     
cAprFc := SuperGetMv('MV_APROVFC',,"admin")  // usuarios que estão liberados a alterar independente do parametro MV_BLQALFC   

	If _lBlafc == .T. .and. !Upper(AllTrim(Subs(cUsuario,7,15))) $ upper(cAprFc)    // parametro que bloqueia preechimento                       
		MsgStop("Alteração bloqueada pelo Superior!",_cRotina+"_001")
		_lRet := .F.
    Else

		If !_lAnoAtu
			MsgStop("Não é permitida nenhuma alteração de anos anteriores!",_cRotina+"_002")
			_lRet := .F.
		
		ElseIf _aRecnos[_nLin]==0 //Realizado atual e anterior e budget
			_lRet := .F.
		
		ElseIf _nLin == 1 //Forecast posterior    

			If (Month(dDataBase) >= _nMesIniP .And. Month(dDataBase) <= _nMesFimP).and. !Upper(AllTrim(Subs(cUsuario,7,15))) $ upper(cAprFc) 
				dbSelectArea("SZ2")
				dbGoTo(_aRecnos[_nLin])
				
				RecLock("SZ2",.F.)
					&(Replace(ReadVar(),"M->","SZ2->")) := &(ReadVar())
					SZ2->Z2_DATA	:= dDataBase
				SZ2->(MsUnlock())
				
				oMSNewGeD:aCols[_nLin,02] := (SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)*_nPrcPos
				oMSNewGeD:aCols[_nLin,03] := (SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)
				oMSNewGeD:aCols[_nLin,16] := SZ2->Z2_DATA
				oMSNewGeD:Refresh(.T.)
			Else
				
				_nDUteis := 0
				
				_dDataVld:= Stod(StrZero(Year(dDataBase),4) + StrZero(Month(dDataBase),2) + "01")
				
				/*Modificado para pegar permitir alterar ate o 10 - nao verificar dias uteis conforme solicitad no ID0277 - Deo
				While _nDUteis < _nDiasEdit
					If DataValida(_dDataVld)==_dDataVld
						_nDUteis++
					EndIf
					_dDataVld++
				EndDo
				*/
		
				_dDataVld := _dDataVld + _nDiasEdit 
				
				_dDtlimps := SuperGetMv('MV_DTLIMPS',,31/10/2018)  // usuarios que estão liberados a alterar independente do parametro MV_BLQALFC   				
				
				If dDataBase >= _dDtlimps .AND. !Upper(AllTrim(Subs(cUsuario,7,15))) $ upper(cAprFc)
//				If dDataBase > _dDataVld .AND. !Upper(AllTrim(Subs(cUsuario,7,15))) $ upper(cAprFc)
					MsgAlert("A definição do forecast do ano posterior só é permitida até o mes de outubro ou nos primeiros " + AllTrim(Str(_nDiasEdit)) + " dias úteis de cada mês!",_cRotina+"_003")
					_lRet := .F.
				Else
					dbSelectArea("SZ2")
					dbGoTo(_aRecnos[_nLin])
					
					RecLock("SZ2",.F.)
						&(Replace(ReadVar(),"M->","SZ2->")) := &(ReadVar())
						SZ2->Z2_DATA := dDataBase
					SZ2->(MsUnlock())
					
					oMSNewGeD:aCols[_nLin,02] := (SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)*_nPrcAtu
					oMSNewGeD:aCols[_nLin,03] := SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12
					oMSNewGeD:aCols[_nLin,16] := SZ2->Z2_DATA
					oMSNewGeD:Refresh(.T.)
				EndIf
			EndIf
		ElseIf _nLin == 3 //Forecast atual
			If Val•(Replace(ReadVar(),"M->Z2_QTM","")) < Month(MonthSum((dDataBase),1)) .AND. !Upper(AllTrim(Subs(cUsuario,7,15))) $ upper(cAprFc)
				MsgAlert("Não é permitida alteração do forecast de meses anteriores!",_cRotina+"_004")
				_lRet := .F.
			Else
				
				_nDUteis := 0
				
				_dDataVld:= Stod(StrZero(Year(dDataBase),4) + StrZero(Month(dDataBase),2) + "01")
				
		
			
				_dDataVld   := _dDataVld + _nDiasEdit 
				cMesMaisX   := StrZero(Month(MonthSum(dDataBase,nEDTFME)),2)  
				cMesCol     := StrZero(Val(Replace(ReadVar(),"M->Z2_QTM","")),2)
				
				//If dDataBase >= MonthSub(Stod(StrZero(Year(dDataBase),4) + StrZero(Val(Replace(ReadVar(),"M->Z2_QTM","")),2) + "01"),2) .and. dDataBase <= _dDataVld .or.  Val(Replace(ReadVar(),"M->Z2_QTM","")) > Month(MonthSum(dDataBase,2))
				
				If Val(cMesCol) > Val(cMesMaisX) .OR.(Val(cMesCol) > (Val(cMesMaisX)-1) .and. dDataBase < _dDataVld) .or. Upper(AllTrim(Subs(cUsuario,7,15))) $ upper(cAprFc) 
				
					dbSelectArea("SZ2")
					dbGoTo(_aRecnos[_nLin])
					
					RecLock("SZ2",.F.)
						&(Replace(ReadVar(),"M->","SZ2->")) := 	&(ReadVar())
						SZ2->Z2_DATA := dDataBase
					SZ2->(MsUnlock())
					
					oMSNewGeD:aCols[_nLin,02] := (SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12)*_nPrcAtu
					oMSNewGeD:aCols[_nLin,03] := SZ2->Z2_QTM01+SZ2->Z2_QTM02+SZ2->Z2_QTM03+SZ2->Z2_QTM04+SZ2->Z2_QTM05+SZ2->Z2_QTM06+SZ2->Z2_QTM07+SZ2->Z2_QTM08+SZ2->Z2_QTM09+SZ2->Z2_QTM10+SZ2->Z2_QTM11+SZ2->Z2_QTM12
					oMSNewGeD:aCols[_nLin,16] := SZ2->Z2_DATA
					oMSNewGeD:Refresh(.T.)
				Else
					MsgAlert("A definição do forecast só é liberada para 2 meses a frente até os primeiros " + AllTrim(Str(_nDiasEdit)) + " dias do mês vigente!",_cRotina+"_005")
					_lRet := .F.
				EndIf
			EndIf
		EndIf
  	EndIf	
	
	Return(_lRet)

Static Function Fechar()
oMSNewGeD := NIL	
	Close(oDlg)
Return()

Static Function AlteraAno()
	
	oSayStatus:SetText("")
	
	fWBrowse(Val(nComboBo1))
	
	If Val(nComboBo1) == Year(dDataBase)
		_lAnoAtu := .T.
	Else
		_lAnoAtu := .F.
	EndIf
	
Return()