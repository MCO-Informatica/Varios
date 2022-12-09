#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OM010DA1  �Autor  �Darcio R. Sporl     � Data �  13/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada criado para ativar o combo pela ativacao   ���
���          �do produto na tabela de preco.                              ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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