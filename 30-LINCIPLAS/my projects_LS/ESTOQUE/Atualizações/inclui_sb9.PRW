#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     ºAutor  ³Microsiga           º Data ³  02/26/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function INS_SB9()

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
Private cCadastro	:= "Cria SB9"

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 To 430,400 OF oMainWnd PIXEL


//Group Box de Filiais
@ 20,10  TO 190,197 LABEL "Filiais" OF oDlg PIXEL

//Grid de Filiais
DbSelectArea("SM0")
SM0->( DbGoTop() )
While SM0->( !Eof() )
	Aadd( aFilial, {.F.,M0_CODFIL,SM0->M0_FILIAL} )
	SM0->( DbSkip() )
EndDo

RestArea(aAreaSM0)

@ 30,25  LISTBOX  oLstFilial VAR cVarFil Fields HEADER "","Filial","Nome","Fechamento" SIZE 160,110 ON DBLCLICK (aFilial:=LSVTroca(oLstFilial:nAt,aFilial),oLstFilial:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstFilial,oOk,oNo,@aFilial) OF oDlg PIXEL	//"Filial" / "Descricao"
oLstFilial:SetArray(aFilial)
oLstFilial:bLine := { || {If(aFilial[oLstFilial:nAt,1],oOk,oNo),aFilial[oLstFilial:nAt,2],aFilial[oLstFilial:nAt,3]}}

//DEFINE SBUTTON FROM 200,060 TYPE 1 ACTION(LjMsgRun("Aguarde..., Alterando parametros...",, {|| AtuDados() }) )  ENABLE OF oDlg
DEFINE SBUTTON FROM 200,060 TYPE 1 ACTION( MsAguarde({|| AtuDados()},"Processamento","Aguarde a finalização do processamento..."))  ENABLE OF oDlg
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

LOCAL cCodigo:=""
local cemp:={}
local x:=0

Local aArea	:= GetArea()

DbSelectArea("SM0")
DbSetOrder(1)
DbGoTop()
While !Eof()
	aadd(cemp,SM0->M0_CODFIL)
	
	DbSkip()
EndDo

//for x:=1 to len(cemp)
for x:=1 to len(aFilial)
	
	If aFilial[x,1] == .T.
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbGoTop()
		While !Eof()
			
		   //	if SB1->B1_GRUPO $ ("0001","0002","0003","0008","0013","0016","0017","0018","0019","0029","0030","0031")
				cCodigo:=alltrim(SB1->B1_COD)
				
				MsProcTxt("Registo: "+CVALTOCHAR(aFilial[x,2])+" Campo: "+cCodigo)
				dbSelectArea("SB9")
				dbsetorder(1)//B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA)
				If !SB9->(DbSeek(ALLTRIM(aFilial[x,2])+ cCodigo))
					RecLock("SB9",.T.)
					SB9->B9_FILIAL	:= aFilial[x,2]
					SB9->B9_COD		:= cCodigo
					SB9->B9_LOCAL	:= "01"
					SB9->B9_DATA	:= CtoD("01/01/2013")
					SB9->( MsUnlock() )
				EndIf
				
			//endif
			DbSelectArea("SB1")
			DbSkip()
		EndDo
	endif
	
Next x

RETURN	
