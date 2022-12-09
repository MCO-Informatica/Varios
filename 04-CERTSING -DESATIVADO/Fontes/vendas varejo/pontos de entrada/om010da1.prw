#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OM010DA1  ºAutor  ³Darcio R. Sporl     º Data ³  13/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada criado para ativar o combo pela ativacao   º±±
±±º          ³do produto na tabela de preco.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function OM010DA1()
Local aArea		:= GetArea()
Local _nTipo	:= ParamIXB[1]
Local _nOpcP	:= ParamIXB[2]
Local lCpAtivo	:= .T.

DbSelectArea("SX3")
DbSetOrder(2)
If !DbSeek("ZI_ATIVO")
	lCpAtivo := .F.
EndIf

If _nTipo == 1 .And. _nOpcP == 2
	If !Empty(DA1->DA1_CODCOB) .And. DA1->DA1_ATIVO == "1"
		DbSelectArea("SZI")
		DbSetOrder(1)
		If DbSeek(xFilial("SZI") + DA1->DA1_CODCOB)
			RecLock("SZI", .F.)
				If lCpAtivo
					Replace SZI->ZI_ATIVO With "1"
				Else
					Replace SZI->ZI_BLOQUE With "N"
				EndIf
			SZI->(MsUnLock())
		EndIf
	ElseIf !Empty(DA1->DA1_CODCOB) .And. DA1->DA1_ATIVO == "2"
		DbSelectArea("SZI")
		DbSetOrder(1)
		If DbSeek(xFilial("SZI") + DA1->DA1_CODCOB)
			RecLock("SZI", .F.)
				If lCpAtivo
					Replace SZI->ZI_ATIVO With "2"
				Else
					Replace SZI->ZI_BLOQUE With "S"
				EndIf
			SZI->(MsUnLock())
		EndIf
	EndIf                                 
EndIf

RestArea(aArea)
Return