#INCLUDE "PROTHEUS.CH"


User Function CN140NPla()

Public NEWPLA := 1
Public aNewPlaArray := {}

U_COGNPLAN()

NEWPLA := 0

Return





User Function COGNPLAN()

Local cAlias1  := "CNB"
Local aCampos  := {"CNB_FILIAL","CNB_NUMERO","CNB_REVISA","CNB_CODMEN","CNB_OBS","CNB_DTANIV","CNB_CONORC","CNB_CONTRA","CNB_DTCAD","CNB_DTPREV","CNB_CONTA","CNB_PERC","CNB_RATEIO","CNB_TIPO","CNB_ITSOMA","CNB_PRCORI","CNB_QTDORI","CNB_QTRDAC","CNB_QTRDRZ","CNB_PERCAL","CNB_FILHO","CNB_SLDMED","CNB_SLDREC","CNB_DTREAL","CNB_REALI","CNB_VLTOTR","CNB_QTREAD","CNB_VLREAD","CNB_VLRDGL","CNB_QTDMED"} // Campos excluidos da GetDados
Local nOpcX    := 4
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg     := Nil
Local oTPane1
Local oTPane2
Local _lRet    := .T.
Local cSXB     := Upper("RnvCNC")


Private oGetDados	:= Nil
Private aHeader		:= {}
Private _cContra	:= CN9->CN9_NUMERO
Private _cRevisa	:= CN9->CN9_REVISA
Private _cPlanil	:= CN200PlaNum(_cContra,_cRevisa)
Private _cTipo      := Space(3)

Private _Fornec     := Space(Len(CNC->CNC_CODIGO))
Private _Loja       := Space(Len(CNC->CNC_LOJA  ))
Private _Reajuste   := .F.

Private _cCronog    := GetSX8Num("CNF","CNF_NUMERO")
Private _lCron      := IIf(Posicione("CN1",1,xFilial("CN1") + CN9->CN9_TPCTO, "CN1_MEDEVE")=="1", .F., .T.)
Private aCOLS		:= {}
Private nUsado		:= 0

AtuSXB(cSXB)


dbSelectArea("SX3")
dbSeek(cAlias1)
While !EOF() .And. X3_ARQUIVO == cAlias1
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. Ascan(aCampos,{|x| x == Alltrim(SX3->X3_CAMPO)}) == 0
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               X3_CAMPO         ,;
		               X3_PICTURE       ,;
		               X3_TAMANHO       ,;
		               X3_DECIMAL       ,;
		               IIF(Empty(X3_VALID), X3_VALID, Space(15)),;
		               X3_USADO         ,;
		               X3_TIPO          ,;
		               X3_ARQUIVO       ,;
		               X3_CONTEXT       })
	Endif
	dbSkip()
End

dbSelectArea(cAlias1)
dbSetOrder(1)
dbSeek( xFilial("CNB") + _cContra + _cRevisa + _cPlanil )

While !EOF() .And. (CNB->(CNB_FILIAL + CNB_CONTRA + CNB_REVISA + CNB_NUMERO) == (xFilial("CNB") + _cContra + _cRevisa + _cPlanil))

	aAdd( aCOLS, Array(Len(aHeader)+1))

	nUsado:=0
	dbSelectArea("SX3")
	dbSeek(cAlias1)
	While !EOF() .And. X3_ARQUIVO == cAlias1
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. Ascan(aCampos,{|x| x == Alltrim(SX3->X3_CAMPO)}) == 0
			nUsado++
			cVarTemp := cAlias1+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				//aCOLS[Len(aCOLS),nUsado] := &cVarTemp
				aCOLS[Len(aCOLS),nUsado] := (cAlias1)->(FieldGet(FieldPos(SX3->X3_CAMPO)))
			ElseIF X3_CONTEXT == "V"
				aCOLS[Len(aCOLS),nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	aCOLS[Len(aCOLS),nUsado+1] := .F.
	dbSelectArea(cAlias1)
	dbSkip()
EndDo

DEFINE MSDIALOG oDlg TITLE "Inclusao de Planilha" From 8,0 To 36,140 OF oMainWnd

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP

	@ 4, 006 SAY "Contrato:"   SIZE 80,7 PIXEL OF oTPane1
	@ 4, 120 SAY "Revisao:"    SIZE 70,7 PIXEL OF oTPane1
	@ 4, 194 SAY "Planilha:"   SIZE 70,7 PIXEL OF oTPane1
	@ 4, 258 SAY "Tp.Plan.:"   SIZE 70,7 PIXEL OF oTPane1
	@ 4, 320 SAY "Fornecedor:" SIZE 70,7 PIXEL OF oTPane1
	@ 4, 426 SAY "Loja:"       SIZE 20,7 PIXEL OF oTPane1

	@ 3, 030 MSGET _cContra   When .F. SIZE 78,7 PIXEL OF oTPane1
	@ 3, 144 MSGET _cRevisa   When .F. SIZE 40,7 PIXEL OF oTPane1
	@ 3, 216 MSGET _cPlanil   When .F. SIZE 30,7 PIXEL OF oTPane1
	@ 3, 280 MSGET _cTipo     F3 "CNL" SIZE 30,7 PIXEL OF oTPane1
	@ 3, 354 MSGET _Fornec    F3 cSXB  SIZE 60,7 PIXEL OF oTPane1
	@ 3, 442 MSGET _Loja               SIZE 30,7 PIXEL OF oTPane1

	If CN9->CN9_FLGREJ == "1"
		@ 4, 500 CheckBox oChkBox Var  _Reajuste Prompt "Reajuste" Message "Indica Reajuste" Size 50, 007 Pixel Of oTPane1
	Endif

	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM

	oGetDados := MSGetDados():New(0,0,0,0,nOpcX,'U_PlLinOk','U_PlTudOk',"+CNB_ITEM",.T.)
	oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If(U_PlTudOk(),(nOpcA:=1,oDlg:End()),nOpcA:=0)},{||oDlg:End()}) CENTERED

If nOpcA == 1
	Begin Transaction
    	Mod2Grava(cAlias1)
 	End Transaction
Endif

Return



Static Function Mod2Grava(cAlias1)

Local lRet     := .T.
Local nI       := 0
Local nY       := 0
Local cVar     := ""
Local nTot     := 0
Local oEdit1
Local oEdit2
Local oEdit3

Local nPos1 := Nil
Local nPos2 := Nil

Local nCnbQuant  := 0
Local nCnbVlTot  := 0
Local nCnbVlDesc := 0
Local nValParc   := 0
Local nDifParc   := 0
Local aDadosEdit := Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava CNB, CNA novos                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado := IIf(Len(aCols) > nUsado, Len(aCols), nUsado)

dbSelectArea(cAlias1)
dbSetOrder(1)

If (nPos1 := aScan(aNewPlaArray, {|z| z[1] == _cContra .And. z[2] == _cRevisa})) == 0
	Aadd(aNewPlaArray, {_cContra, _cRevisa, {}, {}, {}})  // Contrato, Revisao, {CNA, CNB, CNF}
	nPos1 := Len(aNewPlaArray)
Endif

For nI := 1 To Len(aCols)
	If !aCols[nI][nUsado+1]
		Aadd(        aNewPlaArray[nPos1, 4], {})
		nPos2 := Len(aNewPlaArray[nPos1, 4])

		nCnbQuant  := 0
		nCnbVlTot  := 0
		nCnbVlDesc := 0

	   	For nY = 1 to Len(aHeader)
	       	If aHeader[nY][10] # "V"
	           	cVar := Trim(aHeader[nY][2])
	           	Aadd(aNewPlaArray[nPos1, 4, nPos2], {cVar, aCols[nI, nY]})
				If cVar     == "CNB_QUANT"
					nCnbQuant  += aCols[nI, nY]
				ElseIf cVar == "CNB_VLTOT"
					nCnbVlTot  += aCols[nI, nY]
				ElseIf cVar == "CNB_VLDESC"
					nCnbVlDesc += aCols[nI, nY]
				Endif
	       	Endif
	   	Next nY

		Aadd(aNewPlaArray[nPos1, 4, nPos2], {"CNB_NUMERO", _cPlanil})
		Aadd(aNewPlaArray[nPos1, 4, nPos2], {"CNB_REVISA", _cRevisa})
		Aadd(aNewPlaArray[nPos1, 4, nPos2], {"CNB_CONTRA", _cContra})
		Aadd(aNewPlaArray[nPos1, 4, nPos2], {"CNB_DTANIV", dDataBase})
		Aadd(aNewPlaArray[nPos1, 4, nPos2], {"CNB_DTCAD",  dDataBase})
		Aadd(aNewPlaArray[nPos1, 4, nPos2], {"CNB_FILIAL", xFilial("CNB")})
		Aadd(aNewPlaArray[nPos1, 4, nPos2], {"CNB_SLDMED", nCnbQuant})
		Aadd(aNewPlaArray[nPos1, 4, nPos2], {"CNB_SLDREC", nCnbQuant})
		nTot += nCnbVlTot - nCnbVlDesc
   	Endif
Next nI

Aadd(        aNewPlaArray[nPos1, 3], {})
nPos2 := Len(aNewPlaArray[nPos1, 3])

Aadd(aNewPlaArray[nPos1, 3, nPos2], {"CNA_FILIAL",  xFilial("CNA")})
Aadd(aNewPlaArray[nPos1, 3, nPos2], {"CNA_CONTRA",  _cContra})
Aadd(aNewPlaArray[nPos1, 3, nPos2], {"CNA_NUMERO",  _cPlanil})
Aadd(aNewPlaArray[nPos1, 3, nPos2], {"CNA_REVISA",  _cRevisa})
Aadd(aNewPlaArray[nPos1, 3, nPos2], {"CNA_FORNEC",  _Fornec})
Aadd(aNewPlaArray[nPos1, 3, nPos2], {"CNA_LJFORN",  _Loja})
Aadd(aNewPlaArray[nPos1, 3, nPos2], {"CNA_DTINI",   Posicione("CN9",1,xFilial("CN9") + _cContra + _cRevisa, "CN9_DTINIC")})
Aadd(aNewPlaArray[nPos1, 3, nPos2], {"CNA_CRONOG",  IIf(_lCron, _cCronog, Space(6))})
Aadd(aNewPlaArray[nPos1, 3, nPos2], {"CNA_VLTOT",   nTot})
Aadd(aNewPlaArray[nPos1, 3, nPos2], {"CNA_SALDO",   nTot})
Aadd(aNewPlaArray[nPos1, 3, nPos2], {"CNA_TIPPLA",  _cTipo})
Aadd(aNewPlaArray[nPos1, 3, nPos2], {"CNA_DTFIM",   Posicione("CN9",1,xFilial("CN9") + _cContra + _cRevisa, "CN9_DTFIM")})
Aadd(aNewPlaArray[nPos1, 3, nPos2], {"CNA_FLREAJ",  Posicione("CN9",1,xFilial("CN9") + _cContra + _cRevisa, "CN9_FLGREJ")})

If Select("TRBCNA") > 0
	RecLock("TRBCNA",.T.)
		TRBCNA->CNA_NUMERO := _cPlanil
		TRBCNA->CNA_DTINI  := Posicione("CN9",1,xFilial("CN9") + _cContra + _cRevisa, "CN9_DTINIC")
		TRBCNA->CNA_VLTOT  := nTot
		TRBCNA->CNA_DTFIM  := Posicione("CN9",1,xFilial("CN9") + _cContra + _cRevisa, "CN9_DTFIM")
		TRBCNA->CNA_FORNEC := _Fornec
		TRBCNA->CNA_LJFORN := _Loja
		TRBCNA->CNA_CRONOG := IIf(_lCron, _cCronog, Space(6))
	MsUnlock()
	If Type("oBrowse2") == "O"
		oBrowse2:Refresh()
		oBrowse2:GoTop()
	Endif
Endif

_cComp := SUBSTR(DTOC(CN9->CN9_DTINIC),4,2)+"/"+SUBSTR(DTOS(CN9->CN9_DTINIC),1,4)
_dPMed := CN9->CN9_DTINIC
_nParc := 0


If _lCron //Grava CNF novo se houver
	DEFINE MSDIALOG _oDlg1 TITLE " Inclusao de Cronograma " FROM 207,289 TO 427,560 PIXEL

		@ 010,050 MsGet oEdit1 Var _cComp Picture "99/9999" Valid NaoVazio() Size 060,009 PIXEL OF _oDlg1
		@ 010,010 Say "Competencia" Size 030,008 PIXEL OF _oDlg1

		@ 030,050 MsGet oEdit2 Var _dPmed Valid !Empty(_dPmed) Size 060,009 PIXEL OF _oDlg1
		@ 030,010 Say "1o Medição" Size 030,008 PIXEL OF _oDlg1

		@ 045,050 MsGet oEdit3 Var _nParc Picture "@e 999" Valid _nParc > 0 Size 060,009 PIXEL OF _oDlg1
		@ 045,010 Say "Parcelas" Size 030,008 PIXEL OF _oDlg1

		@ 066,058 Button "Ok" Size 037,012 PIXEL OF _oDlg1 action (_oDlg1:End())

	ACTIVATE MSDIALOG _oDlg1 CENTERED

	_nCount := 1
	_cCount := StrZero(1,TamSX3("CNF_PARCEL")[1])

	nValParc  := Round(nTot/_nParc, 2)
	nDifParc  := nTot - (nValParc * _nParc)

	Do While _nParc >= _nCount

		If _nParc == _nCount
			nValParc += nDifParc
		Endif

		Aadd(        aNewPlaArray[nPos1, 5], {})
		nPos2 := Len(aNewPlaArray[nPos1, 5])

		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_FILIAL", xFilial("CNF")})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_NUMERO", _cCronog})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_CONTRA", _cContra})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_PARCEL", _cCount})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_COMPET", _cComp})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_VLPREV", nValParc})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_VLREAL", 0})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_SALDO",  nValParc})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_DTVENC", _dPMed+30})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_PRUMED", _dPMed})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_MAXPAR", _nParc})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_REVISA", _cRevisa})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_PERANT", 0})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_TXMOED", 1})
		Aadd(aNewPlaArray[nPos1, 5, nPos2], {"CNF_DTREAL", ctod("  /  /  ")})

		If substr(_cComp,1,2) == "12"
			_cComp := "01/"+soma1(substr(_cComp,4,4))
		Else
			_cComp := soma1(substr(_cComp,1,2))+"/"+substr(_cComp,4,4)
		Endif

		_cCount := soma1(_cCount)
		_dPmed  := _dPmed + Day(LastDay(_dPmed))
		_nCount := _nCount + 1

	EndDo

	aDadosEdit := EditParc(aNewPlaArray[nPos1, 5], nTot)
	aNewPlaArray[nPos1, 5] := aClone(aDadosEdit)

EndIf

Return( lRet )



User Function PlLinOk(o)

Local lRet := .T.
Local nA := 0
Local nPosSC1   := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_NUMSC"})
Local nPosItSC1 := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_ITEMSC"})
Local nPosQuant := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_QUANT"})
Local nPosVlUni := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_VLUNIT"})
Local nPosProd  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_PRODUT"})
Local nPosUM    := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_UM"})

//Campos obrigatorios da linha
Local aPosCto := {nPosQuant,nPosVlUni,nPosProd,nPosUM}

If !aCols[o:nAt,len(aHeader)+1]
	For nA := 1 to len(aPosCto)
		if Empty(aCols[o:nAt][aPosCto[nA]])
			lRet := .F.
			exit
		EndIf
	Next nA

	If !lRet
		Help(" ",1,"CNTA200OBR")  //"Preencha os campos obrigatórios"
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida produto em relacao a solicitacao de compra³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .And. !Empty(aCols[o:nAt][nPosSC1])
		dbSelectArea("SC1")
		dbSetOrder(1)
		If dbSeek(xFilial("SC1")+aCols[o:nAt][nPosSC1]+aCols[o:nAt][nPosItSC1])
			If SC1->C1_PRODUTO != aCols[o:nAt][nPosProd]
				Help(" ",1,"CNTA200INV") //"Produto invalido para o item"
				lRet := .F.
			EndIf
		EndIf
	EndIf
EndIf

Return lRet


User Function PlTudOk(o)

Local lRet      := .T.
Local lProdFr   := .F.
Local nA        := 0
Local nI        := 0
Local cFilSA5   := xFilial("SA5")
Local cFilSC1   := xFilial("SC1")
Local cFilSAD   := xFilial("SAD")
Local cFilSB1   := xFilial("SB1")
Local nPosItem  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_ITEM"})
Local nPosSC1   := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_NUMSC"})
Local nPosItSC1 := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_ITEMSC"})
Local nPosQuant := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_QUANT"})
Local nPosVlUni := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_VLUNIT"})
Local nPosProd  := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_PRODUT"})
Local nPosUM    := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_UM"})
Local nPosVlTot := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_VLTOT"})
Local nPosVlDec := ASCAN(aHeader,{|x| AllTrim(x[2]) == "CNB_VLDESC"})

//Campos obrigatorios da linha
Local aPosCto := {nPosQuant,nPosVlUni,nPosProd,nPosUM}

Local lVldPrd := ( GetNewPar("MV_CNVLAMR","N") == "S" )

If Len(aCols) > 0
	If Empty(_Fornec)
		Alert("Código do Fornecedor deverá ser informado")
		Return(.F.)
	Endif
	If Empty(_Loja)
		Alert("Loja do Fornecedor deverá ser informada")
		Return(.F.)
	Endif
Endif

//Verifica se existem itens na planilha
If len(aCols) == 0
	Help(" ",1,"CNTA200PLA") //"Insira um item na planilha"
	lRet := .F.
Else
	nI := 1
	//Verifica itens deletados
	While nI <= len(aCols) .And. aCols[nI][len(aHeader)+1]
		nI++
	EndDo

	If nI > len(aCols)
		Help(" ",1,"CNTA200PLA")  //"Insira um item na planilha"
		lRet := .F.
	EndIf
EndIf

If lRet
	M->CNA_VLTOT := 0

	For nI := 1 to len(aCols)
		//-- Nao validar linhas deletadas do aCols
		If aCols[nI][Len(aCols[1])]
			Loop
		EndIf
		For nA := 1 to len(aPosCto)
			If Empty(aCols[nI][aPosCto[nA]])
				lRet := .F.
				Exit
			EndIf
		Next nA

		If !lRet
			Help(" ",1,"CNTA200COR")  //"Preencha corretamente todos os itens"
			Exit
		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida produto em relacao a solicitacao de compra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. !Empty(aCols[nI][nPosSC1])
			dbSelectArea("SC1")
			dbSetOrder(1)
			If dbSeek(cFilSC1+aCols[nI][nPosSC1]+aCols[nI][nPosItSC1])
				If SC1->C1_PRODUTO != aCols[nI][nPosProd]
					Help(" ",1,"CNTA200INV") //"Produto inválido para o item"
					lRet := .F.
					Exit
				EndIf
			EndIf
		EndIf

		If lRet .And. lVldPrd
			dbSelectArea("SA5")
			dbSetOrder(1)
			dbGoTop()

			lProdFr := dbSeek(cFilSA5+M->CNA_FORNEC+M->CNA_LJFORN+aCols[nI][nPosProd])
			If !lProdFr
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(cFilSB1+aCols[nI][nPosProd])
					dbSelectArea("SAD")
					dbSetOrder(1)
					lProdFr := dbSeek(cFilSAD+M->CNA_FORNEC+M->CNA_LJFORN+SB1->B1_GRUPO)
				EndIf
			EndIf

			If !lProdFr
				Aviso("U_PlTudOk","O produto informado no item "+AllTrim(aCols[nI][nPosItem])+" não está amarrado ao fornecedor informado. Verifique a amarração produto X fornecedor.",{ "OK" },2)//"O produto informado no item "###" não está amarrado ao fornecedor informado. Verifique a amarração produto X fornecedor."
				lRet := .F.
				Exit
			EndIf
		EndIf

		M->CNA_VLTOT += (aCols[nI][nPosVlTot]-aCols[nI][nPosVlDec])
	Next nI
EndIf

Return lRet

Static Function EditParc(aParcelas, nTotal)
Local aEditCell := {"CNF_PARCEL", "CNF_COMPET", "CNF_VLPREV", "CNF_DTVENC"}
Local aArrayPos := {}
Local aDados    := {}
Local aDadosNew := {}
Local nLoop     := Nil
Local nLoop2    := Nil
Local nPos      := Nil

If Len(aParcelas) == 0
	Return
Endif

For nLoop := 1 to Len(aEditCell)
	If (nPos := aScan(aParcelas[1], {|z| z[1] == aEditCell[nLoop]})) > 0
		Aadd(aArrayPos, nPos)
	Else
		Alert("Erro na estrutura dos dados da parcela")
		Return
	Endif
Next

For nLoop := 1 to Len(aParcelas)
	Aadd(aDados, {})
	For nLoop2 := 1 to Len(aArrayPos)
		Aadd(Atail(aDados), aParcelas[nLoop, aArrayPos[nLoop2], 2])
	Next
Next

aDadosNew := U_miBrwEditArray(aEditCell, aDados, nTotal)

For nLoop := 1 to Len(aParcelas)
	For nLoop2 := 1 to Len(aArrayPos)
		aParcelas[nLoop, aArrayPos[nLoop2]] := aDadosNew[nLoop, nLoop2]
	Next
Next		
Return(aParcelas)

User Function RnvCNCPesq
Local cQuery := Nil

cQuery := " SELECT CNC.R_E_C_N_O_  CNC_RECNO, CNC_CODIGO, CNC_LOJA,  A2_NOME, A2_NREDUZ FROM " + RetSqlName("CNC") + " CNC " + ;
          " INNER JOIN " + RetSqlName("SA2") + " SA2 ON  CNC.CNC_CODIGO = SA2.A2_COD AND CNC.CNC_LOJA = SA2.A2_LOJA " + ;
          " WHERE CNC_NUMERO = '" + CN9->CN9_NUMERO + "' AND " + ;
          " CNC.D_E_L_E_T_ = ' ' AND CNC.CNC_FILIAL = '" + xFilial("CNC") + "' AND " + ;
          " SA2.D_E_L_E_T_ = ' ' AND SA2.A2_FILIAL = '" + xFilial("SA2") + "'"

Return(U_UsrConPad("CNC", cQuery,, {|| CNC_CODIGO + CNC_LOJA == _Fornec + _Loja}))

Static Function AtuSXB(cAlias)
cAlias := Pad(Upper(cAlias), Len(SXB->XB_ALIAS))

SXB->(dbSetOrder(1))

If SXB->(dbSeek(cAlias))
	Return
Endif

RecLock("SXB", .T.)
XB_ALIAS     := cAlias
XB_TIPO      := "1"
XB_SEQ       := "01"
XB_COLUNA    := "RE"
XB_DESCRI    := "Fornecedores do Contrato"
XB_DESCSPA   := "Fornecedores do Contrato"
XB_DESCENG   := "Fornecedores do Contrato"
XB_CONTEM    := "CNC"
XB_WCONTEM   := ""
MsUnlock()

RecLock("SXB", .T.)
XB_ALIAS     := cAlias
XB_TIPO      := "2"
XB_SEQ       := "01"
XB_COLUNA    := "01"
XB_DESCRI    := ""
XB_DESCSPA   := ""
XB_DESCENG   := ""
XB_CONTEM    := "U_RnvCNCPesq()"
XB_WCONTEM   := ""
MsUnlock()

RecLock("SXB", .T.)
XB_ALIAS     := cAlias
XB_TIPO      := "5"
XB_SEQ       := "01"
XB_COLUNA    := ""
XB_DESCRI    := ""
XB_DESCSPA   := ""
XB_DESCENG   := ""
XB_CONTEM    := "CNC->CNC_CODIGO"
XB_WCONTEM   := ""
MsUnlock()

RecLock("SXB", .T.)
XB_ALIAS     := cAlias
XB_TIPO      := "5"
XB_SEQ       := "02"
XB_COLUNA    := ""
XB_DESCRI    := ""
XB_DESCSPA   := ""
XB_DESCENG   := ""
XB_CONTEM    := "CNC->CNC_LOJA"
XB_WCONTEM   := ""
MsUnlock()



Return



User Function UsrConPad(cAlias, cQuery, aCabecOri, bFixAtu)
Local aArea       := GetArea()
Local cAliasQry   := "QryBrw01"
Local cTitle      := Nil
Local nWidth      := 720
Local nHeight     := 400
Local nHeightTool := 0
Local nLoop       := Nil
Local aStruQry    := Nil
Local cHidden     := "R_E_C_N_O_"
Local aRecnos     := {}
Local aCabList    := {}
Local nPos        := 0
Local nLineAtu    := 1

Private aArray    := {}
Private cCadastro := ""

Default aCabecOri := {}
Default bFixAtu   := {|| .F.}

If (! "R_E_C_N_O_" $ cQuery) .And. (! "_RECNO" $ cQuery)
	Alert("Erro na consulta. Necessário campo R_E_C_N_O_")
	Return(.F.)
Endif

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .F. )
aStruQry := (cAliasQry)->(dbStruct())

dbSelectArea("SX3")
dbSetOrder(2)

For nLoop := 1 to Len(aStruQry)
	cTitle := aStruQry[nLoop, 1]
	If "_RECNO" $ cTitle
		cHidden += ";" + cTitle
	Endif
	If ! cTitle $ cHidden
		If dbSeek(cTitle)
			Aadd(aCabList, X3Titulo())
			If SX3->X3_TIPO $ "N;D"
				TcSetField(cAliasQry, SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL)
			Endif
		Else
			Aadd(aCabList, aStruQry[nLoop, 1])
		Endif
		If nLoop <= Len(aCabecOri)
			Atail(aCabList) := aCabecOri[nLoop]
		Endif
	Endif
Next

dbSetOrder(1)

dbSelectArea(cAliasQry)
Do While ! Eof()
	Aadd(aArray , {})
	Aadd(aRecnos, {})
	aEval(aStruQry, {|z,w| If(! z[1] $ cHidden, Aadd(Atail(aArray) , FieldGet(w)), Nil)})
	aEval(aStruQry, {|z,w| If(  z[1] $ cHidden, Aadd(Atail(aRecnos), FieldGet(w)), Nil)})
	If Eval(bFixAtu	)
		nLineAtu := Len(aArray)
	Endif
	dbSkip()
Enddo

(cAliasQry)->(dbCloseArea())

nHeight := Max(nHeight, nWidth / 16 * 9)

DEFINE MSDIALOG oDlg FROM 000,000 TO nHeight, nWidth PIXEL

oList := TWBrowse():New(  6, 3, __DlgWidth(oDlg) - 6, __DlgHeight(oDlg) - 40, {|| { NoScroll } }, aCabList,, oDlg,,,,,{|| .T. },,,,,,,.T.,,.T.,,.F.,,, )
oList:SetArray(aArray)
oList:bLine      := {|| aArray[oList:nAt]}
oList:blDblClick := {|| nPos := oList:nAt, lOk := .T., oDlg:End()}
oList:nAt        := nLineAtu
oList:Refresh()

TButton():New(__DlgHeight(oDlg) - 28, __DlgWidth(oDlg) - (35 * 3),"Visual"   , oDlg,{|| (cAlias)->(dbGoto(aRecnos[oList:nAt, 1])), (cAlias)->(AxVisual(cAlias, aRecnos[oList:nAt, 1], 2)), oList:SetFocus()},32,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)
TButton():New(__DlgHeight(oDlg) - 28, __DlgWidth(oDlg) - (35 * 2),"Confirma" , oDlg,{|| nPos := oList:nAt, lOk := .T., oDlg:End()},32,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)
TButton():New(__DlgHeight(oDlg) - 28, __DlgWidth(oDlg) - (35 * 1),"Cancela"  , oDlg,{||                    lOk := .F., oDlg:End()},32,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)

ACTIVATE MSDIALOG oDlg CENTERED

RestArea(aArea)

If lOk
	(cAlias)->(dbGoto(aRecnos[nPos, 1]))
Endif

Return(lOk)


/*
User Function Molla

aCabec := {"Parcela", "Vencimento", "Valor"}
aDados := {{"001", Stod("@0130430"), 12}, ;
           {"002", Stod("@0130530"), 14}, ;
           {"003", Stod("@0130630"), 16}, ;
           {"004", Stod("@0130730"), 18}}

U_miBrwEditArray(aCabec, aDados)
*/


User Function miBrwEditArray(aFields, aDados, nTotal, aBotoes, lEdit)
Local oDlg           := Nil
Local nLoop          := Nil
Local nSpaceButton   := 2
Local oBrowse        := Nil
Local lCanDel        := .F.
Local nDlgWidth      := 540
Local nDlgHeight     := 320
Local nWidthButton   :=  38
Local aDadosOri      := Nil
Local nCampoSoma     := Nil
Local aCabec         := {}
Local aGet           := Array(2)

Private nTotalParcelas := 0

Default lEdit        := .T.

If Len(aDados) == 0 .Or. Len(aFields) == 0
	Return
Endif

aEval(aFields, {|z| Aadd(aCabec, RetTitle(z))})
aDadosOri := aClone(aDados)

DEFINE MSDIALOG oDlg FROM 000,000 TO nDlgHeight, nDlgWidth PIXEL

oBrowse := MsBrGetDBase():New( 26, 3, __DlgWidth(oDlg) - 6, __DlgHeight(oDlg) - 60,,,, oDlg,,,,,,,,,,,, .F., "", .T.,, .F.,,,)
oBrowse:SetArray(aDados)
oBrowse:bChange := {|| .T.}

For nLoop := 1 To Len(aCabec)
	oBrowse:AddColumn( TCColumn():New( aCabec[nLoop] , &("{|| aDados[oBrowse:nAt, " + Alltrim(Str(nLoop)) + "]}"), "",,,,"LEFT"))
	If aFields[nLoop] == "CNF_VLPREV"
		nCampoSoma := nLoop
	Endif
Next

oBrowse:lColDrag	:= .T.
oBrowse:lLineDrag	:= .T.
oBrowse:lJustific	:= .T.
oBrowse:nColPos		:= 1

If lEdit
	oBrowse:blDblClick := {|| U_miEditCell(oBrowse)}
Endif

//oBrowse:bChange := {|| nTotalParcelas := 0, aEval(oBrowse:aArray, {|z| nTotalParcelas += z[nCampoSoma]}), aGet[2]:SetText(nTotalParcelas), aGet[2]:Refresh(), alert(Str(nTotalParcelas))}
oBrowse:bChange := {|| CalcTotal(oBrowse, nCampoSoma, aGet[2])}

@ 6, 020 SAY "Total Planilha:"       SIZE 50,7 PIXEL OF oDlg
@ 6, 145 SAY "Total das Parcelas:"   SIZE 60,7 PIXEL OF oDlg

@ 5, 055 MSGET aGet[1] VAR nTotal            When .F. Picture "@E 999,999,999.99" SIZE 50,7 PIXEL OF oDlg
@ 5, 195 MSGET aGet[2] VAR nTotalParcelas    When .F. Picture "@E 999,999,999.99" SIZE 50,7 PIXEL OF oDlg

If aBotoes <> Nil .And. ValType(aBotoes) == "A"
	For nLoop := Len(aBotoes) to 1 STEP - 1
		TButton():New(__DlgHeight(oDlg) - 28, __DlgWidth(oDlg) - ((nWidthButton + nSpaceButton) * (Len(aBotoes) - nLoop + 3)), aBotoes[nLoop, 1], oDlg, aBotoes[nLoop, 2],nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)
	Next
Endif

TButton():New(__DlgHeight(oDlg) - 28, __DlgWidth(oDlg) - ((nWidthButton + nSpaceButton) * 3),"Inicial"   , oDlg,{||aDados := aClone(aDadosOri), oBrowse:aArray := aDados, oBrowse:Refresh(), CalcTotal(oBrowse, nCampoSoma, aGet[2])},nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)
TButton():New(__DlgHeight(oDlg) - 28, __DlgWidth(oDlg) - ((nWidthButton + nSpaceButton) * 2),"Confirma"  , oDlg,{||If(CalcOk(nTotal), (lOk := .T., aDados := oBrowse:aArray   , oDlg:End()), Nil)                                                     },nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)
TButton():New(__DlgHeight(oDlg) - 28, __DlgWidth(oDlg) - ((nWidthButton + nSpaceButton) * 1),"Cancela"   , oDlg,{||lOk := .F., aDados := aClone(aDadosOri), oDlg:End()                                                     },nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)

ACTIVATE MSDIALOG oDlg CENTERED

Return(aDados)



Static Function CalcTotal(oBrowse, nCampoSoma, oGet)
nTotalParcelas := 0

aEval(oBrowse:aArray, {|z| nTotalParcelas += z[nCampoSoma]})

oGet:SetText(nTotalParcelas)
oGet:Refresh()
ProcessMessages()

Return(nTotalParcelas)

Static Function CalcOk(nTotal)
If nTotal <> nTotalParcelas
	Alert("O total das parcelas não coincide com o total da planilha")
	Return(.F.)
Endif

Return(.T.)
	
	


User Function miEditCell(oList, cField)
Local nColuna   := oList:nColPos
Local cAlias    := oList:cAlias
Local lBrwArray := Len(oList:aArray) > 0
Local cPict
Local oDlgEdit
Local oDlgGet
Local oDlgBtn
Local aDim := {}
Local oRect := tRect():New(0,0,0,0) // obtém as coordenadas da célula (lugar onde

oList:GetCellRect (nColuna,,oRect)       // a janela de edição deve ficar)
aDim := {oRect:nTop,oRect:nLeft,oRect:nBottom,oRect:nRight}

xEdit := oList:aArray[oList:nAt, nColuna]

cPict := If(ValType(xEdit) == "N", "@E 9,999,999,999.99", "")

DEFINE MSDIALOG oDlgEdit OF oList:oWnd  FROM 0, 0 TO 0, 0 STYLE nOR( WS_VISIBLE, WS_POPUP ) PIXEL
oList:lDisablePaint := .f.

@ 0,0 MSGET oDlgGet VAR xEdit SIZE 0,0 OF oDlgEdit FONT oList:oFont PICTURE cPict  PIXEL HASBUTTON  // PICTURE ""

@ 0, 0 BUTTON oDlgBtn PROMPT "Dummy" SIZE 0,0 OF oDlgEdit // o botão dummy é usado apenas para permitir a troca de foco
oDlgBtn:bGotFocus := {|| oDlgEdit:nLastKey := VK_RETURN, oDlgEdit:End(0)}

// posiciona o get
oDlgGet:Move(-2,-2, aDim[4]-aDim[2]+4 ,aDim[3]-aDim[1]+4 )

// posiciona dialogo sobre a celula
oDlgEdit:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])

ACTIVATE MSDIALOG oDlgEdit

oList:aArray[oList:nAt, nColuna] := xEdit

oList:Refresh()

oList:SetFocus()

Eval(oList:bChange)

Return(.T.)































User Function CN140BRV
Local cContra := PARAMIXB[1]
Local cRevisa := PARAMIXB[2]
Local nLoop   := Nil
Local nLoop1  := Nil
Local nLoop2  := Nil
Local nField  := Nil

If Type("aNewPlaArray") <> "A"
	Return(.T.)
Endif

If (nPos1 := aScan(aNewPlaArray, {|z| z[1] == cContra .And. z[2] == cRevisa})) == 0
	Return(.T.)
Endif

// Contrato, Revisao, {CNA, CNB, CNF}

For nLoop := 1 to Len(aNewPlaArray[nPos1, 3])  // CNA
	RecLock("CNA", .T.)
	For nLoop1 := 1 to Len(aNewPlaArray[nPos1, 3, nLoop])
		If (nField := CNA->(FieldPos(aNewPlaArray[nPos1, 3, nLoop, nLoop1, 1]))) > 0
			CNA->(FieldPut(nField, aNewPlaArray[nPos1, 3, nLoop, nLoop1, 2]))
		Endif
	Next
	MsUnlock()
Next

For nLoop := 1 to Len(aNewPlaArray[nPos1, 4])  // CNB
	RecLock("CNB", .T.)
	For nLoop1 := 1 to Len(aNewPlaArray[nPos1, 4, nLoop])
		If (nField := CNB->(FieldPos(aNewPlaArray[nPos1, 4, nLoop, nLoop1, 1]))) > 0
			CNB->(FieldPut(nField, aNewPlaArray[nPos1, 4, nLoop, nLoop1, 2]))
		Endif
	Next
	MsUnlock()
Next

For nLoop := 1 to Len(aNewPlaArray[nPos1, 5])  // CNF
	RecLock("CNF", .T.)
	For nLoop1 := 1 to Len(aNewPlaArray[nPos1, 5, nLoop])
		If (nField := CNF->(FieldPos(aNewPlaArray[nPos1, 5, nLoop, nLoop1, 1]))) > 0
			CNF->(FieldPut(nField, aNewPlaArray[nPos1, 5, nLoop, nLoop1, 2]))
		Endif
	Next
	MsUnlock()
Next

Return(.T.)
