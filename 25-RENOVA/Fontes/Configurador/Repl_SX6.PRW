
#INCLUDE "Protheus.ch"

User Function Repl_SX6
Local lEraseTemp := .T.
Local cOption := "#SX6"
Local aCpoSX6 := {}
Local aStrSX6 := SX6->(dbStruct())

Private oExp
Private cCadastro := "Replicação de Parâmetros SX6"

aCoors := FWGetDialogSize(oMainWnd)

oExp := MsExplorer():New("Cambio",aCoors[1],aCoors[2],aCoors[3],aCoors[4])	//"Gerenciador de Base de Dados"
oExp:DefaultBar()

oExp:AddDefButton("FINAL","Sair",{|| oExp:DeActivate()})	//"Sair"
oExp:AddSearchButton({|cSearch,lSCase,lSWord| X31Search(cSearch,lSCase,lSWord)},/*{|| X31ListRefresh()},{|lFolder| If(lFolder,X31ListRefresh(),)}*/)

AEval(aStrSX6, {|x,y| If( RTrim(x[1])<>"X6_PYME", Aadd(aCpoSX6, {x[1],x[1], .T., StrZero(y,2), x[3], "", x[2], x[4]}),) } )

SX6->(DbGoTop())

nPanel  := oExp:AddItem("Parametros","BMPPARAM","#SX6") //

oExp:AddButton(nPanel,"FILTRO"    ,"Filtro"  ,&("{|| X31SetFilter('SX6',aCpoSX6,oExp:aObject["+Str(nPanel)+",1])}")) //"Filtrar..."
oExp:AddButton(nPanel,"BMPTRG"    ,"Empresas",{|| U_RepX6(SX6->X6_VAR)})

oExp:AddObject(nPanel,TWBrowse():New(00,00,oExp:nPanelWidth,oExp:nPanelHeight,{|| {SX6->X6_FIL,SX6->X6_VAR,OemToAnsi(X6Descric()),OemToAnsi(X6Desc1()),OemToAnsi(X6Desc2())}},;
									{"Filial", "Nome", "Descrição","Descr (cont 1)","Descr (cont 2)"},,oExp:GetPanel(nPanel),,,,,,,,,,,,.F.,"SX6",.T.,,.F.,,,)) //"Filial"###"Nome"###"Descriçao"
oExp:aObject[nPanel][1]:Align := CONTROL_ALIGN_ALLCLIENT

oExp:Activate()


Static Function X31Search(cSearch,lCase,lWord)
Local lSeek := .F.
Local cCargo := AllTrim(oExp:oTree:GetCargo())
Local nRecno
Local oX31Obj := oExp:GetObject(nPanel,1)

If !Empty(cSearch)
	cSearch := Trim(cSearch)
	cCargo  := Subs(cCargo,2,3)

	DbSelectArea(cCargo)
	DbSetOrder(1)
	nRecno := Recno()

	If !(lSeek := X31Seek(cCargo,cSearch))
		lSeek := X31Seek(cCargo,Upper(cSearch))
	EndIf

	If lSeek
		oX31Obj:Refresh()
	Else
		DbGoTo(nRecno)
	EndIf
EndIf
Return lSeek

Static Function X31Seek(cAlias,cSearch)
Local lSeek

lSeek := DbSeek(cSearch)
If !lSeek
	lSeek := DbSeek(cFilAnt+cSearch)
	If !lSeek
		lSeek := DbSeek(Space(FWSizeFilial())+cSearch)
	EndIf
EndIf
Return lSeek

User Function RepX6(cX6Var)
Local aDados    := {}
Local aCabec    := {"", "Empresa", "Nome", Upper(cX6Var)}
Local aEmpresas := U_SM0Empresas()
Local nLoop     := Nil
Local cFile     := Nil
Local cExt      := Nil
Local cDriver   := Nil

Private aFieldsX6 := {}

aEval(SX6->(dbStruct()), {|z,w| Aadd(aFieldsX6, SX6->(FieldGet(w)))})

cX6Var := Pad(Upper(cX6Var), Len(SX6->X6_VAR))

For nLoop := 1 to Len(aEmpresas)
	cFile := "SX6" + aEmpresas[nLoop, 1] + "0"
	If File(cFile + ".DBF")
		cDriver := "DBFCDX"
		cExt    := ".DBF"
	ElseIf File(cFile + ".DTC")
		cDriver := "CTREECDX"
		cExt    := ".DTC"
	Else
		Loop
	Endif
	/* 	01=Markbrowse
		02=Codigo da Empresa
		03=Descricao Empresa
		04=Atual
		05=Arquivo
		06=Extensao
		07=Driver arquivo
		08=Alterou?
		09=Recno SX6
	*/
	Aadd(aDados, {.F., aEmpresas[nLoop, 1], aEmpresas[nLoop, 2], Space(Len(SX6->X6_CONTEUD)), cFile, cExt, cDriver, .F., Nil})

	dbUseArea( .T., cDriver, cFile, "SX6_TMP", .T. , .T. )
	dbSetOrder(1)

	If dbSeek(Space(Len(SX6_TMP->X6_FIL)) + cX6Var)
		Atail(aDados)[4] := SX6_TMP->X6_CONTEUD
		Atail(aDados)[9] := SX6_TMP->(Recno())
	Endif	

	SX6_TMP->(dbCloseArea())
Next			

EditBrowse(aCabec, aDados, cX6Var)


Static Function EditBrowse(aCabec, aDados, cX6Var)
Local cTitulo      := "Replica de Parametros SX6"
Local oDlg         := Nil
Local oList        := Nil
Local nLoop        := Nil
local lOk          := .F.
Local lChk         := .F.

Local oOk          := LoadBitmap( GetResources(), "LBOK")
Local oNo          := LoadBitmap( GetResources(), "LBNO")

Local nLineButton  := Nil
Local nColButton   := Nil
Local nWidthButton := 32
Local nSpaceButton := 2

DEFINE MSDIALOG oDlg TITLE cTitulo From 0,0 to 440,640 of oMainWnd PIXEL

oList := TWBrowse():New( 03, 03, __DlgWidth(oDlg) - 6, __DlgHeight(oDlg) - 30, {|| { NoScroll } }, aCabec,, oDlg,,,,,{|| oList:aArray[oList:nAt, 1] := ! oList:aArray[oList:nAt, 1] },,,,,,,.T.,,.T.,,.F.,,, )
oList:SetArray(aDados)
oList:bLine := { || {If(oList:aArray[oList:nAt,1], oOk, oNo), oList:aArray[oList:nAt,2], oList:aArray[oList:nAt,3], oList:aArray[oList:nAt,4]}}

nLineButton := __DlgHeight(oDlg) - 24
nColButton  := __DlgWidth( oDlg) -  2

@ nLineButton, 03 CheckBox oChkBox Var  lChk Prompt "Marca/Desmarca Todos"  Message "Marca/Desmarca Todos" Size 70, 007 Pixel Of oDlg on Click (aEval(oList:aArray, {|z,w| z[1] := lChk}), oList:Refresh())

TButton():New(nLineButton, nColButton - (4 * (nWidthButton + nSpaceButton)), "Replicar"   , oDlg,{|| ReplPar(oList, cX6Var)}                        ,nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)
TButton():New(nLineButton, nColButton - (3 * (nWidthButton + nSpaceButton)), "Alterar"    , oDlg,{|| EditaDados(oList, cX6Var)}                     ,nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)
TButton():New(nLineButton, nColButton - (2 * (nWidthButton + nSpaceButton)), "Confirma"   , oDlg,{|| aDados := oList:aArray, lOk := .T., oDlg:End()},nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)
TButton():New(nLineButton, nColButton - (1 * (nWidthButton + nSpaceButton)), "Cancela"    , oDlg,{||                         lOk := .F., oDlg:End()},nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)

ACTIVATE MSDIALOG oDlg CENTERED 

If lOk
	dbSelectArea("SX6")
	For nLoop := 1 to Len(aDados)
		If aDados[nLoop, 8] // Alterou
			dbUseArea( .T., aDados[nLoop, 7], aDados[nLoop, 5], "SX6_TMP", .T. , .F. )
			dbSetOrder(1)
			If aDados[nLoop, 9] == Nil // Registro nao existe entao incluo
				RecLock("SX6_TMP", .T.)
				aEval(aFieldsX6, {|z,w| FieldPut(w, z)})
			Else	
				dbGoto(aDados[nLoop, 9])
				RecLock("SX6_TMP", .F.)
			Endif
			SX6_TMP->X6_CONTEUD := aDados[nLoop, 4]
			MsUnlock()
			SX6_TMP->(dbCloseArea())			
    	Endif
	Next
Endif

Return(lOk)

Static Function ReplPar(oList, cX6Var)
Local cX6Cont      := oList:aArray[oList:nAt, 4]
Local nLoop        := Nil

For nLoop := 1 to Len(oList:aArray)
	If oList:aArray[nLoop, 1]
		oList:aArray[nLoop, 4] := cX6Cont
		oList:aArray[nLoop, 8] := .T.
	Endif
Next
oList:SetFocus()
oList:Refresh()

Static Function EditaDados(oList, cX6Var, lVisual)
Local cTitulo      := "Manutenção de Parametros SX6"
Local oDlg         := Nil
local lOk          := .F.

Local nLineButton  := Nil
Local nColButton   := Nil
Local nWidthButton := 32
Local nSpaceButton := 2

Local cConteud     := oList:aArray[oList:nAt, 4]
Local cEmpresa     := oList:aArray[oList:nAt, 2] + " - " + oList:aArray[oList:nAt, 3]

Default lVisual    := .F.

DEFINE MSDIALOG oDlg TITLE cTitulo From 0,0 to 180,340 of oMainWnd PIXEL

@ 12, 06 Say "Empresa:"              SIZE  45,10 OF oDlg PIXEL
@ 11, 45 MSGET oEmpresa VAR cEmpresa SIZE 130,08 OF oDlg PIXEL When .F.

@ 32, 06 Say AllTrim(cX6Var) + ":"    SIZE  45,10 OF oDlg PIXEL
@ 31, 45 MSGET oX6Cont  VAR cConteud  SIZE  80,08 OF oDlg PIXEL When (! lVisual)

nLineButton := __DlgHeight(oDlg) - 24
nColButton  := __DlgWidth( oDlg) -  2

TButton():New(nLineButton, nColButton - (2 * (nWidthButton + nSpaceButton)), "Confirma"   , oDlg,{|| lOk := .T., oDlg:End()},nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)
TButton():New(nLineButton, nColButton - (1 * (nWidthButton + nSpaceButton)), "Cancela"    , oDlg,{|| lOk := .F., oDlg:End()},nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)

ACTIVATE MSDIALOG oDlg CENTERED 

If lOk
	oList:aArray[oList:nAt, 4] := cConteud
	oList:aArray[oList:nAt, 8] := .T.
	oList:SetFocus()
	oList:Refresh()
Endif

Return(lOk)

User Function GetMVData(cData)
Local dData := Ctod("")

Default cData := Alltrim(SX6->X6_CONTEUD)

If "/" $ cData .Or. Empty(cData)
	dData := Ctod(Alltrim(cData))
Else
	dData := Stod(Alltrim(cData))
Endif	

Return(dData)



User Function SM0Empresas()
Static aEmpresas := Nil
Local aSavAre    := Nil
Local nScan      := Nil

If aEmpresas == Nil
	aSavAre   := SaveArea1({"SM0"})
	aEmpresas := {}
	dbSelectArea("SM0")
	dbGoTop()
	Do While ! Eof()
		If (nScan := aScan(aEmpresas, {|z| z[1] == SM0->M0_CODIGO})) == 0
			Aadd(aEmpresas, {SM0->M0_CODIGO, SM0->M0_NOMECOM})
		Endif
		dbSkip()	
	Enddo
	RestArea1(aSavAre)
Endif	
Return(aEmpresas)
