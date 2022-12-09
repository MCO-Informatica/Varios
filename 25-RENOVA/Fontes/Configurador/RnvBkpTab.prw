
#INCLUDE "RWMAKE.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "Protdef.ch"

User Function RnvBkpTab // U_RnvBkpTab()
Local cTabelas  := "SN1;SN3;SN4;SN5"
Local aTabelas  := Nil
Local aEmps     := Nil
Local cAliasTab := "RRTAB1"
Local nLoop     := Nil
Local cFolder   := "\BkpTabAtivo"
Local cBkp      := cFolder + "\" + Dtos(Date()) + "_"

If Len(Directory(cFolder + "\*.*", "D")) == 0
	MakeDir(cFolder)
Endif

aEmps := SelEmpr("Selecione as Empresas para o Backup")

U_miMsgRun("Pesquisando Tabelas no banco", , {|| aTabelas := U_RnvRetTables()})

If Select(cAliasTab) > 0
	(cAliasTab)->(dbCloseArea())
Endif

For nLoop := 1 To Len(aTabelas)
	If Left(aTabelas[nLoop], 3) $ cTabelas 
		If aScan(aEmps, {|z| z[2] == Substr(aTabelas[nLoop], 4, 2)}) > 0
			dbUseArea(.T., "TOPCONN", aTabelas[nLoop], cAliasTab, .T., .F.)
			If LastRec() > 0
				U_miMsgRun("Copiando Tabela " + aTabelas[nLoop], , {|| __dbCopy(cBkp + aTabelas[nLoop],{},,,,,.F.,"DBFCDXADS")})
			Endif
			(cAliasTab)->(dbCloseArea())
		Endif
	Endif
Next

User Function RnvRetTables
Local cAliasTop := "RRTAB1"
Local aTables   := {}
Local cTabela   := Nil

If Select(cAliasTop) > 0
	(cAliasTop)->(dbCloseArea())
Endif

DbUseArea( .T., "TOPCONN", "TOP_FILES", cAliasTop)

Do While ! Eof()
	cTabela := Alltrim(FNAMF1)
	If ! SubS(FNAMF1, 1, 4) == "TOP_"
		Aadd(aTables, cTabela)
	Endif
	dbSkip()
Enddo

(cAliasTop)->(dbCloseArea())
Return(aTables)

User Function miMsgRun( cCaption, cTitle, bAction)
Local oDlg
Local nWidth
Local oFont

DEFINE FONT oFont NAME "Arial" SIZE 6,14 BOLD

Default cCaption := "Aguarde o processamento"

If cTitle == NIL
	DEFINE DIALOG oDlg ;
	FROM 0,0 TO 3, Len( cCaption ) + 8 ;
	STYLE nOr( DS_MODALFRAME, WS_POPUP )
	oDlg:SetFont(oFont)
	nWidth := oDlg:nRight - oDlg:nLeft
	@ 2,0 Say xPadc(cCaption,nWidth) 	 of oDlg PIXEL
Else
	DEFINE DIALOG oDlg ;
	FROM 0,0 TO 4, Max( Len( cCaption ), Len( cTitle ) ) + 8 ;
	TITLE cTitle ;
	STYLE DS_MODALFRAME
	oDlg:SetFont(oFont)
	nWidth := oDlg:nRight - oDlg:nLeft
	@ 2,0 Say xPadc(cCaption,nWidth) 	 of oDlg PIXEL
EndIf

oDlg:bStart := { || Eval( bAction, oDlg ), oDlg:End()}
oDlg:cMsg	:= cCaption

ACTIVATE DIALOG oDlg CENTER

oFont:End()

Return


Static Function SelEmpr(cTitulo)
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
