#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA520   ºAutor  ³Opvs (David)        º Data ³  06/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de Validação de VOucher de Origem                    º±±
±±º          ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VNDA520(cCodVou,lHelp,cMotivo)
Local aArea		:= GetArea()
Local lRet			:= .T.
Local aRet			:= {}
Local nRecSZF		:= 0
Local cMsgHlp		:= ""

Default lHelp := .T.

//Posiciona no Voucher
SZF->(DbSetOrder(2))
If SZF->(DbSeek(xFilial("SZF")+cCodVou))
    nRecSZF := SZF->(Recno())
    
	//Verifica se ja foi utilizado para bloquea-lo
	If SZF->ZF_SALDO < SZF->ZF_QTDVOUC
		If lHelp
			Help( ,, 'VNDA520',, 'Voucher de Origem informado ja foi utilizado e não será bloqueado', 1, 0 )
		Else
			cMsgHlp := 'Voucher de Origem informado ja foi utilizado e não será bloqueado'
		EndIf 
	Else
		//Bloqueia o voucher e transmite o mesmo ao site 
		//caso seja encontrado alguma inconsistência volta o status para ativo
		RecLock("SZF",.F.)
			SZF->ZF_ATIVO   := 'N'
			SZF->ZF_CANCELA := cMotivo
		SZF->(MsUnlock())
		
		aRet 	:=	U_VNDA440(cCodVou)
	    
		lRet	:=	aRet[1]
		
		If !lRet
			SZF->(DbGoTo(nRecSZF))
			If lHelp
				Help( , , 'VNDA520', , aRet[2], 1, 0)
			Else
				cMsgHlp := "Msg Portal: "+aRet[2]
			EndIf
			RecLock("SZF",.F.)
				SZF->ZF_ATIVO   := 'S'
				SZF->ZF_CANCELA := ''
			SZF->(MsUnlock())
		EndIf
	EndIf

Else
	If lHelp
		Help( ,, 'VNDA520',, 'Voucher de Origem informado não existe na Base de Dados', 1, 0 )
	Else
		cMsgHlp := 'Voucher de Origem informado não existe na Base de Dados'
	EndIf 
	lRet:=.F.
	
EndIf

RestArea(aArea)

Return(iif(lHelp,lRet,cMsgHlp))