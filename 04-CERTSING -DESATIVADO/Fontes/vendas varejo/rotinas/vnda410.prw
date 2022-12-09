/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VNDA410�Autor  �                    � Data �  18/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida Tipos de Voucher que o usuario pode incluir          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VNDA410(cUsuario,cTipVou)
	Local aArea		:= GetArea()
	Local lRet		:= .F.
	Local lVNDA620	:= IsInCallStack("U_VNDA620")  // Rotina de emiss�o de Voucher para renova��o
	
	If !lVNDA620
		DbSelectArea("SZO")
		DbSetOrder(1)
		If DbSeek(xFilial("SZO") + cUsuario)
		
			IF AT(cTipVou,SZO->ZO_TIPOSVO) > 0
				lRet := .T.
			Endif
			
		Endif    
		
		IF !lRet
		
			Help( ,, 'Help',, 'Usu�rio n�o possui autoriza��o para gerar este tipo de Voucher.', 1, 0 )
		
		Endif
	Else
		lRet := .T.
	EndIf
	
	
	RestArea(aArea)
Return(lRet)