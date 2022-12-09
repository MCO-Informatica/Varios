#INCLUDE "PROTHEUS.CH"

/*
+=========================================================+
|Programa: CTBP001| Autor: Antonio Carlos |Data: 23/09/09 |
+=========================================================+
|Descricao: Rotina responsavel pela alteração do parametro|
|MV_ULMES permitindo que determinados usuarios possam rea-|
|lizar esta operação.                                     |
+=========================================================+
|Uso: Laselva                                             |
+=========================================================+
*/

User Function CTBP001()

Local aArea		:= GetArea()
Local aAreaSM0	:= SM0->( GetArea() )

Local oOk       := LoadBitmap( GetResources(), "LBOK")
Local oNo       := LoadBitmap( GetResources(), "LBNO")

Private oData
Private oDlg

Private lInvFil		:= .F.
Private lInvGrp		:= .F.
Private aFilial		:= {}

Private _dData		:= CTOD("  /  /  ")
Private cStrFilia	:= ""
Private cStrFil		:= ""
Private cFiltrUsr	:= ""
Private cCadastro	:= "Altera Data de Fechamento - (Parametro - MV_ULMES)"

If !Alltrim(cUserName) $ GetMv("MV_USRFECH") .and. !(__cUserId $ GetMv('LA_PODER'))
	MsgStop("Usuario sem permissao para utilizar a rotina!")
	Return(.F.)	
EndIf

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 To 430,400 OF oMainWnd PIXEL

@ 10,10 SAY "Data: " OF oDlg PIXEL
@ 20,10 MSGET oData VAR _dData SIZE 50,10 OF oDlg PIXEL

//Group Box de Filiais
@ 50,10  TO 190,197 LABEL "Filiais" OF oDlg PIXEL

//Grid de Filiais
DbSelectArea("SM0")
SM0->( DbGoTop() )
While SM0->( !Eof() )
	Aadd( aFilial, {.F.,M0_CODFIL,SM0->M0_FILIAL,STOD(Alltrim(Posicione("SX6",1,SM0->M0_CODFIL+"MV_ULMES","X6_CONTEUD")))} )
	SM0->( DbSkip() )
EndDo

RestArea(aAreaSM0)

@ 70,25  LISTBOX  oLstFilial VAR cVarFil Fields HEADER "","Filial","Nome","Fechamento" SIZE 160,110 ON DBLCLICK (aFilial:=LSVTroca(oLstFilial:nAt,aFilial),oLstFilial:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstFilial,oOk,oNo,@aFilial) OF oDlg PIXEL	//"Filial" / "Descricao"
oLstFilial:SetArray(aFilial)
oLstFilial:bLine := { || {If(aFilial[oLstFilial:nAt,1],oOk,oNo),aFilial[oLstFilial:nAt,2],aFilial[oLstFilial:nAt,3],aFilial[oLstFilial:nAt,4]}}

DEFINE SBUTTON FROM 200,060 TYPE 1 ACTION(LjMsgRun("Aguarde..., Alterando parametros...",, {|| AtuDados() }) )  ENABLE OF oDlg
DEFINE SBUTTON FROM 200,110 TYPE 2 ACTION(oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED
	
RestArea(aArea)

Return

Static Function LSVTroca(nIt,aArray)

aArray[nIt,1] := !aArray[nIt,1]

Return aArray

Static Function AtuDados()

Local aArea	:= GetArea()
Local _nReg	:= 0

If Empty(_dData)
	MsgStop("Informe a data para alteracao!")
	Return(.F.)
EndIf

For _nI := 1 To Len(aFilial)
	
	If aFilial[_nI,1] == .T.
		
		DbSelectArea("SX6")
		SX6->( DbSetOrder(1) )
		
		If SX6->( DbSeek( aFilial[_nI,2]+"MV_ULMES" ) )
			
			RecLock("SX6",.F.)
			Replace SX6->X6_CONTEUD With DTOS(_dData)
			SX6->( MsUnLock() )
			
			_nReg++
			
		EndIf
		
	EndIf
	
Next _nI

If _nReg > 0
	MsgInfo("Alteracao efetuada com sucesso!")
	oDlg:End()	
Else
	MsgStop("Nao existem registros para alteracao!")		
EndIf

RestArea(aArea)

Return