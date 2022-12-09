#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VNDA420�Autor  �Darcio R. Sporl     � Data �  18/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao criada para validar usuarios com direitos de inclusao���
���          �de Voucher.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VNDA420(cUsuario)

Local aArea	:= GetArea()
Local lRet	:= .T.

DbSelectArea("SZO")
DbSetOrder(1)
If DbSeek(xFilial("SZO") + cUsuario)
	If SZO->ZO_ATIVO == "N"
//		MsgStop('Usu�rio n�o est� ativo no cadastro')
		Help( ,, 'Help',, 'Usu�rio n�o est� ativo no cadastro', 1, 0 )
		lRet := .F.
	EndIf
Else
//	MsgStop('Usu�rio n�o tem acesso a gera��o de Voucher.')
	Help( ,, 'Help',, 'Usu�rio n�o tem acesso a gera��o de Voucher.', 1, 0 )
	lRet := .F.
EndIf

RestArea(aArea)
Return(lRet)