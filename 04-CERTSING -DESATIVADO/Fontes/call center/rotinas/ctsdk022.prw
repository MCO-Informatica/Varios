#Include 'Protheus.ch'


/*/{Protheus.doc} CTSDK022

Funcao personalizada para Chamada de tela de inclusão com opção de seleção de posto de atendimento

@author Totvs SM - David
@since 25/07/2014
@version P11

/*/
User Function ctsdk022()
	Local cGrpAnt 	:= ""
	Local cGrpAtd 	:= ""
	Local lRet		:= .T.
	Local cMensagem	:= ""
	Local nRecSU7	:= 0
	
	SU7->(DbSetOrder(4))
	If  SU7->(DbSeek(xFilial("SU7")+__cUserId)) .and.;
		SU7->(FieldPos("U7_XSELGRP")) > 0 .and.;
		SU7->U7_XSELGRP == "1"
	
		nRecSU7 := SU7->(Recno())
		cGrpAtd := U_CTSDK021()
			
		If Empty(cGrpAtd)
			MsgStop("Não foi selecionado nenhum grupo para atendimento. Rotina Será Encerrada!!")
			lRet := .F.
		EndIf
					
		If lRet
			RecLock("SU7",.F.)
				SU7->U7_POSTO := cGrpAtd
			SU7->(MsUnlock())
		EndIf
	Else
		lRet := .F.
	EndIf
Return(lRet)