
#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³   CpySA2   ³ Autor ³ Marcelo Iuspa       ³ Data ³ 22/05/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Replica fornecedor (SA2) para outra empresa do grupo       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Acionada pelo Ponto de Entrada MA020ROT que acrescenta     ³±±
±±³          ³ opção no menu (Ações Relacionadas) para copiar o           ³±±
±±³          ³ fornecedor posicionado para demais empresas do grupo;      ³±±
±±³          ³ Para configurar campos que não deverão ser copiados usar a ³±±
±±³          ³ variavel cNoFields;                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA020ROT
Local aRotAdic := {}

Aadd(aRotAdic,{"Replica Fornecedor", "U_CpySA2", 0 , 4})

Return(aRotAdic)

User Function CpySA2(cAlias, nReg, nOpc)
Local aFields := {}
Local aEmps   := {}
Local aLogs   := {}
Local cTexto  := ""
Local cOk     := ""
Local cErro   := ""
Local nLoop   := Nil

aEval((cAlias)->(dbStruct()), {|z,w| Aadd(aFields, {z[1], (cAlias)->(FieldGet(w)), Nil})})

cTexto += "Início da réplica do fornecedor:"                        + Chr(13) + Chr(10) + ;
          SA2->A2_COD + "-" + SA2->A2_LOJA + "  " + SA2->A2_NOME    + Chr(13) + Chr(10) + ;
          "Em " + Dtoc(Date()) + " as " + Time() + " Hs)"           + Chr(13) + Chr(10)

aEmps := U_SelEmpr("Replica de Fornecedores")

U_RnvRegua({|oSay1, oSay2, oRegua| aLogs := U__CpySA2(aEmps, aFields, oSay1, oSay2, oRegua)}, "Replicando Fornecedor")

For nLoop := 1 to Len(aLogs)
	If aLogs[nLoop, 1]
		cOk   += aLogs[nLoop, 2] + " - " + aLogs[nLoop, 3] + Chr(13) + Chr(10) + aLogs[nLoop, 4] + Chr(13) + Chr(10)
	Else
		cErro += aLogs[nLoop, 2] + " - " + aLogs[nLoop, 3] + Chr(13) + Chr(10) + aLogs[nLoop, 4] + Chr(13) + Chr(10)
	Endif
Next

If ! Empty(cOk)
	cOk     := "Réplica efetuada com sucesso nas empresas:"   + Replicate(Chr(13) + Chr(10), 2) + cOk
Endif

If ! Empty(cErro)
	cErro   := "Erro encontrado na réplica para as empresas:" + Replicate(Chr(13) + Chr(10), 2) + cErro
Endif

If Len(aEmps) == 0
	cOk   := "Nenhuma empresa marcada ou disponível para réplica"
	cErro := ""
Endif

cTexto += "Finalizado as    " + Time() + " Hs" + Replicate(Chr(13) + Chr(10), 2) + ;
           cOk + ;
           Chr(13) + Chr(10)  + ;
           cErro + ;
           Chr(13) + Chr(10)

U_RnvDlgTexto(cTexto, "Log de Processamento", "", .T.)


User Function _CpySA2(aEmps, aFields, oSay1, oSay2, oRegua)
Local cTexto
Local nLoop
Local aLogs := {}

oRegua:nTotal := 100

oSay2:SetText("Aguarde. Empresas a Processar: " + Alltrim(Str(Len(aEmps))))
SysRefresh()
ProcessMessages()

For nLoop := 1 to Len(aEmps)
	PutGlbValue("cLogProc", "")
	StartJob("U___CpySA2", GetEnvServer(),.T., aEmps[nLoop, 2], "01", aFields)
	cTexto := GetGlbValue("cLogProc")
	Aadd(aLogs, {Left(cTexto, 1) == "T", aEmps[nLoop, 2], aEmps[nLoop, 3], Substr(cTexto, 3)})
	oRegua:Set(nLoop * 100 / Len(aEmps))
	oSay1:SetText("Replicando para Empresa " + aEmps[nLoop, 2] + "-" + aEmps[nLoop, 3])
	oSay2:SetText("Processadas " + Alltrim(Str(nLoop)) + " de um total de " + Alltrim(Str(Len(aEmps))))
	SysRefresh()
	ProcessMessages()
Next
Return(aLogs)

User Function __CpySA2(cEmpresa, cCodFilial, aFields)
Local cNoFields  := "A2_FILIAL;A2_NATUREZ;A2_TRANSP;A2_COND;A2_MINIRF;A2_SUBCOD;A2_MJURIDI"  // Campos que NAO poderao ser copiados
Local aExecAuto  := {}
Local nLoop      := Nil
Local nPosCod    := Nil
Local nPosLoja   := Nil
Local nPosCnpj   := Nil
Local nPosTipo   := Nil
Local lAddLoja   := Nil

Local nSaveSX8  := Nil
Local cMsg      := ""

Private lMsErroAuto    := .F.
Private lMsHelpAuto    := .T.
Private lAutoErrNoFile := .T.

RPCSetType(3)  // Nao utilizar licenca
RpcSetEnv( cEmpresa, cCodFilial,,,,,, , , ,   )

nSaveSX8 := GetSX8Len()
lAddLoja := .F.

/*
While ( GetSX8Len() > nSaveSX8 )
	ConfirmSx8()
EndDo
*/

For nLoop := 1 to Len(aFields)
	If ! aFields[nLoop, 1] $ cNoFields
		Aadd(aExecAuto, aFields[nLoop])
	Endif
Next

If (nPosCod := aScan(aExecAuto, {|z| z[1] == "A2_COD"})) == 0
	PutGlbValue("cLogProc", "F|Campo A2_COD nao definido")
	RpcClearEnv()
	Return
Endif

If (nPosLoja := aScan(aExecAuto, {|z| z[1] == "A2_LOJA"})) == 0
	PutGlbValue("cLogProc", "F|Campo A2_LOJA nao definido")
	RpcClearEnv()
	Return
Endif

If (nPosTipo := aScan(aExecAuto, {|z| z[1] == "A2_TIPO"})) == 0
	PutGlbValue("cLogProc", "F|Campo A2_TIPO nao definido")
	RpcClearEnv()
	Return
Endif

If (nPosCnpj := aScan(aExecAuto, {|z| z[1] == "A2_CGC"})) > 0
	If ! Empty(aExecAuto[nPosCnpj, 2])
		SA2->(dbSetOrder(3)) //  A2_FILIAL+A2_CGC
		If SA2->(dbSeek(xFilial("SA2") + aExecAuto[nPosCnpj, 2]))
			PutGlbValue("cLogProc", "F|CNPJ " + aExecAuto[nPosCnpj, 2] + " ja existente")
			Return
		Endif
		If aExecAuto[nPosTipo, 2] == "J"
			If SA2->(dbSeek(xFilial("SA2") + Substr(aExecAuto[nPosCnpj, 2], 1, 8)))
				lAddLoja := .T.
				aExecAuto[nPosCod , 2] := SA2->A2_COD
				aExecAuto[nPosLoja, 2] := U_miNextCod("SA2", "A2_LOJA", " A2_COD = '" + SA2->A2_COD + "'")
			Endif
		Endif
		SA2->(dbSetOrder(1)) //  A2_FILIAL+A2_COD+A2_LOJA
	Endif
Endif

If ! lAddLoja
	aExecAuto[nPosCod, 2] := CriaVar( "A2_COD", .T. )
	aExecAuto[nPosCod, 2] := Space(Len(SA2->A2_COD)) // Vou cria-la vazia por erro no SXE/SXF


	If Empty(aExecAuto[nPosCod, 2])
	//	aExecAuto[nPosCod, 2] := GetSXENum("SA2", "A2_COD")
		aExecAuto[nPosCod, 2] := U_miNextCod("SA2", "A2_COD")
	Endif
Endif

MSExecAuto({|x,y,z| MATA020(x,y,z)},aExecAuto, 3) //Inclusao

If lMsErroAuto
	RollBackSX8()
	aEval(GetAutoGRLog(), {|z| cMsg += z + Chr(13) + Chr(10)})
	PutGlbValue("cLogProc", "F|" + cMsg)
Else
	ConfirmSX8()
	PutGlbValue("cLogProc", "T|A2_COD: " + SA2->A2_COD + " / A2_LOJA: " + SA2->A2_LOJA + " / A2_NOME: " + SA2->A2_NOME)
Endif

RpcClearEnv()

Return

User Function SelEmpr(cTitulo)
Local oDlg           := Nil
Local oList          := Nil
Local nLoop          := Nil
local lOk            := .F.
Local lChk           := .F.
Local cLine          := Nil
Local aList          := {}
Local aRet           := {}

Local oOk            := Nil
Local oNo            := Nil

Local nWidthButton   :=  32
Local nDlgWidth      := 570
Local nDlgHeight     := 480

Local nLineButton    := Nil
Local nColButton     := Nil
Local nSpaceButton   := 2
Local lMarkBrow      := .F.

Local aSavAre    := Nil
Local nScan      := Nil

aSavAre   := SaveArea1({"SM0"})

dbSelectArea("SM0")
dbGoTop()
Do While ! Eof()
	If SM0->M0_CODIGO == cEmpAnt
		dbSkip()
		Loop
	Endif
	If (nScan := aScan(aList, {|z| z[2] == SM0->M0_CODIGO})) == 0
		Aadd(aList, {.F., SM0->M0_CODIGO, SM0->M0_NOMECOM})
	Endif
	dbSkip()
Enddo
RestArea1(aSavAre)

If Len(aList) == 0
	Return(aList)
Endif

DEFINE MSDIALOG oDlg TITLE cTitulo From 0,0 to nDlgHeight, nDlgWidth /* of oMainWnd */ PIXEL

nLineButton := __DlgHeight(oDlg) - 24
nColButton  := __DlgWidth( oDlg) -  4

oList := TWBrowse():New( 03, 03, __DlgWidth(oDlg) - 6, __DlgHeight(oDlg) - 30, {|| { NoScroll } }, aCabec := {"", "Emp", "Descrição"},, oDlg,,,,,{|| oList:aArray[oList:nAt, 1] := ! oList:aArray[oList:nAt, 1] },,,,,,,.T.,,.T.,,.F.,,, )
oList:SetArray(aList)

oOk  := LoadBitmap( GetResources(), "LBOK")
oNo  := LoadBitmap( GetResources(), "LBNO")

cLine := "{ || {If(oList:aArray[oList:nAt,1], oOk, oNo)"

For nLoop := 2 to Len(aCabec)
	cLine += ", oList:aArray[oList:nAt, " + Str(nLoop, 3) + "] "
Next

cLine += "}}"
oList:bLine := &(cLine)

@ nLineButton, 03 CheckBox oChkBox Var  lChk Prompt "Marca/Desmarca Todos" Message "Marca/Desmarca Todos" Size 70, 007 Pixel Of oDlg on Click (aEval(oList:aArray, {|z,w| z[1] := lChk}), oList:Refresh())

TButton():New(nLineButton    , nColButton - (2 * (nWidthButton + nSpaceButton)), "Replica"  , oDlg,{|| lOk := .T., aList := oList:aArray, oDlg:End()},nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)
TButton():New(nLineButton    , nColButton - (1 * (nWidthButton + nSpaceButton)), "Cancela"  , oDlg,{|| lOk := .F., aList := {}          , oDlg:End()},nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)

ACTIVATE MSDIALOG oDlg CENTERED

aEval(aList, {|z,w| If(z[1], Aadd(aRet, z), Nil)})

Return(aRet)

User Function RnvDlgTexto(cTexto, cTituloJanela, cLegendaCampo, lFontFix)
Local nWidthButton   :=  35
Local oGetTexto
Local oDlg
Local oFont
Local lOk      := .F.

Default cTexto            := ""
Default cTituloJanela     := "Texto"
Default cLegendaCampo     := "Texto"
Default lFontFix          := .F.

If lFontFix
	oFont:= TFont():New("Courier New",,14,,.F.,,,,.T.,.F.)
Else
	oFont:= TFont():New("Arial"      ,,13,,.F.,,,,.T.,.F.)
Endif

Define MsDialog oDlg Title cTituloJanela From 0, 0 To 470, 660 /* Of oMainWnd */ Pixel

@  08,  05 Say   cLegendaCampo        Size  20,   6 Of oDlg Pixel
@  18,  05 Get   oTexto  Var cTexto   Size __DlgWidth(oDlg) - 10, __DlgHeight(oDlg) - 50 FONT oFont Of oDlg Pixel MULTILINE

TButton():New(__DlgHeight(oDlg) - 28, __DlgWidth(oDlg) - (nWidthButton * 1),"Fechar"  , oDlg,{||lOk := .F., oDlg:End()},nWidthButton - 2,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)

Activate MsDialog oDlg Centered

Return(lOk)


User Function RnvRegua(bBloco, cTitulo, cMsg1, cMsg2)
Local oDlg
Local oSay1
Local nRegua := 0

Default cTitulo := "Aguarde o Processamento"
Default cMsg1   := ""
Default cMsg2   := ""

DEFINE MSDIALOG oDlg TITLE cTitulo From 0,0 to 110,360 PIXEL

@ 10, 10 Say oSay1 Prompt cMsg1  SIZE 160,8 OF oDlg PIXEL
@ 24, 10 Say oSay2 Prompt cMsg2  SIZE 160,8 OF oDlg PIXEL

@ 35,010 METER oRegua VAR nRegua TOTAL 100 SIZE 150,8 OF oDlg NOPERCENTAGE PIXEL

ACTIVATE MSDIALOG oDlg CENTERED ;
ON INIT (Eval(bBloco, oSay1, oSay2, oRegua, oDlg), oDlg:End())
Return

User Function miDlgChkBox(cTitulo, cCheckBox, lCheckBox, cTextoBotao)
Local oDlg           := Nil
Local nLineButton    := Nil
Local nColButton     := Nil
Local nSpaceButton   := 2

Local nWidthButton   :=  42
Local nDlgWidth      := 380
Local nDlgHeight     := 120

Local oChkBox        := Nil

Default lCheckBox    := .F.
Default cTextoBotao  := "Fecha"

DEFINE MSDIALOG oDlg TITLE cTitulo From 0,0 to nDlgHeight, nDlgWidth  PIXEL

nLineButton := __DlgHeight(oDlg) - 24
nColButton  := __DlgWidth( oDlg) -  4

@ nLineButton - 25, 10 CheckBox oChkBox Var  lCheckBox Prompt cCheckBox Message cCheckBox Size 80, 007 Pixel Of oDlg

TButton():New(nLineButton    , nColButton - (1 * (nWidthButton + nSpaceButton)), cTextoBotao, oDlg,{|| oDlg:End()}                                                                                  ,nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)

ACTIVATE MSDIALOG oDlg CENTERED

Return(lCheckBox)


User Function miNextCod(cAlias, cField, cWhere)
Local aSavAre    := GetArea()
Local cAliasTop  := "TrbNextCod"
Local aStruAlias := (cAlias)->(dbStruct())
Local cQuery     := Nil
Local cCpoFilial := Nil
Local nCpoFilial := Nil
//Local nCpoDelet  := Nil
Local cRetCod    := ""

Default cWhere   := ""

cAlias := Upper(Alltrim(cAlias))

cCpoFilial := Substr(cAlias, 2)
nCpoFilial := aScan(aStruAlias, {|z| cCpoFilial $ z[1]})
//nCpoDelet  := aScan(aStruAlias, {|z| z[1] == "D_E_L_E_T_"})

If nCpoFilial > 0
	cCpoFilial := aStruAlias[nCpoFilial, 1]
Endif

If Select(cAliasTop) > 0
	(cAliasTop)->(dbCloseArea())
Endif

cQuery := " SELECT MAX(" + cField + ") CODIGO FROM " + RetSqlName(cAlias) + " " + cAlias + " "

cWhere += (If(Empty(cWhere), "", " AND ") + cAlias + ".D_E_L_E_T_ = ' ' ")

If nCpoFilial > 0
	cWhere += (If(Empty(cWhere), "", " AND ") + cAlias + "." + cCpoFilial + " = '" + xFilial(cAlias) + "' ")
Endif

cWhere += If(Empty(cWhere), "", " AND ") + " SUBSTRING(" + cAlias + "." + cField + ", 1, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') "

If ! Empty(cWhere)
	cQuery += " WHERE " + cWhere
Endif

cQuery := ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTop, .F., .T.)

If ! Eof()
	cRetCod := Soma1( (cAliasTop)->CODIGO)
Endif

(cAliasTop)->(dbCloseArea())
RestArea(aSavAre)

Return(cRetCod)

