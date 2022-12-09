#include 'totvs.ch'
#INCLUDE "FWSMALLAPPLICATION.CH"

CLASS ctsdkwzd

	DATA oDlg

	DATA oPanelDlg
	DATA oHPanel
	DATA oMPanel
	DATA oFPanel
	
	DATA oNext
	DATA oBack
	DATA oCancel
	DATA oFinish
	
	DATA abValid
	DATA acHeader
	DATA abExecute
	
	DATA chTitle
	DATA chMsg
	
	DATA nPanel
	DATA nTPanel
	
	DATA oCHFont
	DATA oCMFont
	DATA oHFont
	DATA oMFont
	
	METHOD New( oDlg, chTitle, chMsg, cText, bNext, bFinish, bExecute,lPanel )
	METHOD Activate( )
	METHOD Navigator( nOption )
	METHOD NewPanel( cTitle, cMsg, bBack, bNext, bFinish, bExecute, lPanel)
	METHOD GetPanel(nPanel)
	METHOD SetFinish()
	METHOD SetPanel(nPanel,lExec)
	METHOD RefreshButtons()
	METHOD DisableButtons()
	METHOD EnableButtons()
	METHOD SetMessage(cMsg)
	METHOD SetHeader(cHeader)

ENDCLASS

// ----------------------------------------------------------------------

METHOD New( oUSER, chTitle, chMsg, cText, bNext, bFinish, bExecute,lPanel,lNoFirst) CLASS ctsdkwzd
Local oText

DEFAULT cText	 := ''
DEFAULT bNext 	 := {|| .T.}
DEFAULT bFinish	 := {|| .T.}
DEFAULT chTitle  := ''
DEFAULT chMsg	 := ''
DEFAULT lPanel	 := .T.
DEFAULT lNoFirst := .F.

::oMPanel	:= Array(1)
::nTPanel	:= 1
::nPanel	:= 1
::abValid	:= {}
::acHeader	:= {}
::abExecute	:= {}

Aadd( ::acHeader,	{chTitle,chMsg} )
Aadd( ::abValid,	{{|| .T.},bNext,bFinish} )
Aadd( ::abExecute,	{|| .T. } )

DEFINE FONT ::oCHFont	NAME 'FW Microsiga' SIZE 0, -8 BOLD  
DEFINE FONT ::oCMFont	NAME 'FW Microsiga' SIZE 0, -8
DEFINE FONT ::oHFont	NAME 'Arial' SIZE 008,013 BOLD //WEIGHT -12 BOLD 
DEFINE FONT ::oMFont	NAME 'Arial' SIZE 008,013 //WEIGHT -12

oUser:ReadClientCoors()
::oDlg := oUser

@ 000, 000 MSPANEL ::oHPanel OF ::oDlg SIZE 0,30
::oHPanel:Align := CONTROL_ALIGN_TOP

@ 000,010 SAY ::chTitle VAR ::acHeader[::nPanel,1] OF ::oHPanel PIXEL FONT ::oCHFont SIZE 225,017 COLOR ( RGB ( 0, 0, 0) )
::chTitle:Align := CONTROL_ALIGN_TOP

@ 000,015 SAY ::chMsg	VAR ::acHeader[::nPanel,2] OF ::oHPanel PIXEL FONT ::oCMFont SIZE 225,017 COLOR ( RGB ( 0, 0, 0) )
::chMsg:Align := CONTROL_ALIGN_TOP

If ( lPanel )
	@ 0, 0 MSPANEL ::oMPanel[1]	OF ::oDlg SIZE 0,0
Else
	@ 0, 0 SCROLLBOX ::oMPanel[1] SIZE 0,0 OF ::oDlg
EndIf
::oMPanel[1]:Align := CONTROL_ALIGN_ALLCLIENT

If !lNoFirst
	@ 0, 0 GET oText VAR cText OF ::oMPanel[1] MULTILINE SIZE 0, 0 FONT ::oMFont PIXEL WHEN .T. READONLY DESIGN NOBORDER COLOR ( RGB ( 0, 0, 0) )
	oText:Align := CONTROL_ALIGN_ALLCLIENT
EndIf
	
@ 000, 000 MSPANEL ::oFPanel OF ::oDlg  SIZE 0,10
::oFPanel:Align := CONTROL_ALIGN_BOTTOM 
 
@ 0,0      BUTTON ::oBack	  PROMPT "Voltar"	 SIZE 040, 020 OF ::oFPanel PIXEL ACTION If(Eval(::abValid[::nPanel,1]),(::nPanel-=1, ::Navigator(1),EVAL(::abExecute[::nPanel])),) 
::oBack:Align := CONTROL_ALIGN_LEFT
@ 0,0 BUTTON ::oNext	  PROMPT "Avançar" SIZE 040, 020 OF ::oFPanel PIXEL ACTION If(Eval(::abValid[::nPanel,2]),(::nPanel+=1, ::Navigator(2),EVAL(::abExecute[::nPanel])),)
::oNext:Align := CONTROL_ALIGN_LEFT 
@ 0,0 BUTTON ::oCancel PROMPT "Cancelar" SIZE 040, 020 OF ::oFPanel PIXEL ACTION If(Eval(::abValid[1,3]),::Navigator(0),)
::oCancel:Align := CONTROL_ALIGN_RIGHT
@ 0,0 BUTTON ::oFinish PROMPT "Finalizar"	SIZE 040, 020 OF ::oFPanel PIXEL ACTION If(Eval(::abValid[::nPanel,3]),::Navigator(0),)
::oFinish:Align := CONTROL_ALIGN_RIGHT

::oFinish:Hide()
::oBack:Disable()
Return

// ----------------------------------------------------------------------

METHOD Activate( ) CLASS ctsdkwzd

::oMPanel[1]:Show()
Return

// ----------------------------------------------------------------------

METHOD Navigator( nOption ) CLASS ctsdkwzd
Local nI

DEFAULT nOption := 0

If ( nOption == 0 )
	Return
EndIf

For nI := 1 To Len(::oMPanel)
	If ( nI == ::nPanel )
		::oMPanel[nI]:Show()
		::chTitle:SetText(::acHeader[nI,1])
		::chMsg:SetText(::acHeader[nI,2])
	Else
		::oMPanel[nI]:Hide()
	EndIf
Next nI

::RefreshButtons()
Return

// ----------------------------------------------------------------------

METHOD NewPanel( cTitle, cMsg, bBack, bNext, bFinish, bExecute, lPanel ) CLASS ctsdkwzd

DEFAULT cTitle   := "cTitle"
DEFAULT cMsg	 := "cMsg"
DEFAULT bBack	 := {|| .T.}
DEFAULT bNext	 := {|| .T.}
DEFAULT bFinish	 := {|| .T.}
DEFAULT lPanel	 := .T.
DEFAULT bExecute := {|| NIL }

If ( lPanel )
	Aadd( ::oMPanel, TPanel():New( 0, 0,, ::oDlg,,,,,, 0, 0,, .f. ) )
Else
	Aadd( ::oMPanel, TScrollBox():New( ::oDlg, 0, 0, 0, 0,.T.,.T.,.F.))
EndIf
::nTPanel += 1
::oMPanel[::nTPanel]:Align := CONTROL_ALIGN_ALLCLIENT
::oMPanel[::nTPanel]:Hide()

Aadd( ::abValid,	{bBack,bNext,bFinish} )
Aadd( ::acHeader,	{cTitle,cMsg} )
Aadd( ::abExecute,	bExecute )

Return

// ----------------------------------------------------------------------

METHOD GetPanel(nPanel) CLASS ctsdkwzd

DEFAULT nPanel := 0

If ( nPanel > 0 .And. nPanel <= ::nTPanel )
	Return ::oMPanel[nPanel]
EndIf
Return

// ----------------------------------------------------------------------

METHOD SetFinish() CLASS ctsdkwzd

::oNext:Disable()
::oFinish:Show()
::oCancel:Show()
Return

// ----------------------------------------------------------------------

METHOD SetPanel(nPanel,lExec) CLASS ctsdkwzd
Local nLastPanel := nPanel

DEFAULT lExec := .T.

If nPanel > 0 .and. nPanel <= Len(::oMPanel)
	::oMPanel[::nPanel]:Hide()
	::oMPanel[nPanel]:Show()
	::chTitle:SetText(::acHeader[nPanel,1])
	::chMsg:SetText(::acHeader[nPanel,2])
	::nPanel := nPanel
	::RefreshButtons()
	EVAL(::abExecute[::nPanel])
EndIf
Return nLastPanel

// ----------------------------------------------------------------------

METHOD RefreshButtons() CLASS ctsdkwzd

If ( ::nPanel == 1 .And. ::nPanel == ::nTPanel )
	::oBack:Disable()
	::oNext:Disable()
	::oFinish:Show()
	::oCancel:Show()
ElseIf ( ::nPanel == 1 .And. ::nPanel < ::nTPanel )
	::oBack:Disable()
	::oNext:Enable()
	::oFinish:Hide()
	::oCancel:Show()
ElseIf ( ::nPanel > 1 .And. ::nPanel == ::nTPanel )
	::oBack:Enable()
	::oNext:Disable()
	::oFinish:Show()
	::oCancel:Show()
ElseIf ( ::nPanel > 1 .And. ::nPanel < ::nTPanel )
	::oBack:Enable()
	::oNext:Enable()
	::oFinish:Hide()
	::oCancel:Show()
EndIf
Return

// ----------------------------------------------------------------------

METHOD DisableButtons() CLASS ctsdkwzd

::oBack:Disable()
::oNext:Disable()
::oFinish:Disable()
::oCancel:Disable()
Return

// ----------------------------------------------------------------------

METHOD EnableButtons() CLASS ctsdkwzd

::oBack:Enable()
::oNext:Enable()
::oFinish:Enable()
::oCancel:Enable()
::RefreshButtons()
Return

// ----------------------------------------------------------------------

METHOD SetMessage(cMsg,nPanel,lChange) CLASS ctsdkwzd

DEFAULT nPanel := ::nPanel
DEFAULT lChange := .T.

If nPanel > 0 .and. nPanel <= Len(::oMPanel)
	If lChange
		::acHeader[nPanel,2] := cMsg
	EndIf
	::chMsg:SetText(cMsg)
EndIf
Return

// ----------------------------------------------------------------------

METHOD SetHeader(cHeader,nPanel,lChange) CLASS ctsdkwzd

DEFAULT nPanel := ::nPanel
DEFAULT lChange := .T.

If nPanel > 0 .and. nPanel <= Len(::oMPanel)
	If lChange
		::acHeader[nPanel,1] := cHeader
	EndIf
	::chTitle:SetText(cHeader)
EndIf
Return