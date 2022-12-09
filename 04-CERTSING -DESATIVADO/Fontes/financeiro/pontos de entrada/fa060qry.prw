#include "rwmake.ch"
#include "protheus.ch"
#include "colors.ch"
#include "font.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA060QRY  ³ Autor ³ Henio Brasil Claudino ³ Data ³ 24.06.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ponto de Entrada para Filtrar os titulos do Contas a Receber³±±
±±³          ³caso for Manual, Bpag, ou Amarelinhas                       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Financeiro.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Cliente  ³CertiSign Certificadora Digital                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA060QRY()

	Local lOk   := .F.
	Local lMark := .F.
	Local oDlg
	Local oLbx
	Local oPanelBot
	Local oPanelAll
	Local oCancel 
	Local oConfirm
	Local oOk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNo := LoadBitmap(,'NGCHECKNO.PNG')
	
	Private cCadastro := 'Filtro Origem Título [FA060QRY]'
	Private tQuery := ''
	Private aDADOS := {}
	
	aDADOS := A060Opc()
	
	If Empty( aDADOS )
		MsgInfo('Não foi possível encontrar registros para a origem, verifique.', cCadastro)
		Return( NIL )
	Endif
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 350,500 TITLE cCadastro PIXEL
		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

		@ 40,05 LISTBOX oLbx FIELDS HEADER 'x','Origem','Descrição' SIZE 350, 90 OF oPanelAll PIXEL ON ;
		dblClick(aDADOS[oLbx:nAt,1]:=!aDADOS[oLbx:nAt,1])
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray(aDADOS)
		oLbx:bLine := { || {Iif(aDADOS[oLbx:nAt,1],oOk,oNo),aDADOS[oLbx:nAt,2],aDADOS[oLbx:nAt,3]}}
		oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
		FWMsgRun(,{|| AEval(aDADOS, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todas as origens...') }
		
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM

		@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION Iif(A060Seek(aDADOS,@lOk),oDlg:End(),NIL)
		@ 1,44 BUTTON oCancel  PROMPT 'Sair'  SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
	
	If lOk
		tQuery := " E1_ORIGPV IN (" + tQuery + ") "
	Else
		tQuery := ''
	Endif
Return( If(Empty(tQuery),Nil,tQuery) )

Static Function A060Opc()
	Local cSQL	:= ''
	Local cTRB	:= ''
	Local aTRB	:= {}
	Local aArea	:= GetArea()
	
	cSQL += "SELECT X5_CHAVE," + CRLF
	cSQL += "       X5_DESCRI" + CRLF
	cSQL += "FROM " + RetSqlName('SX5') + " X5 " + CRLF
	cSQL += "WHERE  X5.D_E_L_E_T_ = ' '" + CRLF
	cSQL += "       AND X5_TABELA = 'Z4' " + CRLF
	cSQL += "ORDER  BY R_E_C_N_O_  " + CRLF
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
	
	IF .NOT. (cTRB)->( EOF() ) 
		While .NOT. (cTRB)->( EOF() )
			aADD( aTRB, { .F., Alltrim( (cTRB)->X5_CHAVE ), Alltrim( (cTRB)->X5_DESCRI ) } )
			(cTRB)->( dbSkip() )
		End
	EndIF
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
	
	RestArea( aArea )
Return( aTRB )

Static Function A060Seek( aDADOS, lOk )
	Local nPos   := 0
	Local nY     := 0
	Local lRet   := .T.
	
	nPos := AScan( aDADOS, {|X| X[1]==.T. } )
	If nPos == 0
		lRet := .F.
		MsgAlert('Não foi selecionado nenhuma origem.',cCadastro)
	Else
		For nY := 1 To Len(aDADOS)
			tQuery += Iif(aDADOS[nY,1],"'" + aDADOS[nY,2] + "',",'')
		Next
		tQuery := Substring( tQuery, 1, Len( tQuery ) - 1 )
		lOk := .T.
	Endif
Return( lRet )