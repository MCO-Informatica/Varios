#INCLUDE "PROTHEUS.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FUNLPA01  �Autor  �Luiz Eduardo Fael   � Data �  02/17/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Conta Debito ou Credito Conforme Tipo de Centro de Custo   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Sitaxe    � U_LPA01('D') Para Debito e U_LPA01('C') Para Credito       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION LPA01(cTipo)

Local aAreaCTT := CTT->(GetArea())
Local aAreaSRV := SRV->(GetArea())
Local __cConta := ''
Local __cCampo := 'SRV->RV_CONT'+Alltrim(cTipo)
Local __CC	   := SRZ->RZ_CC
Local __Verba  := SRZ->RZ_PD
CTT->(dbSetOrder(1))
SRV->(dbSetOrder(1))
If Alltrim(cTipo) == 'C' .or. Alltrim(cTipo) == 'D'
	If Alltrim(SM0->M0_CODIGO) == '06' .or. Alltrim(SM0->M0_CODIGO) == '12'
		SZ0->(dbSetOrder(1))
		If SZ0->(dbSeek(XFILIAL("SZ0")+__Verba+__CC))
			If cTipo == 'D'
				__cConta := SZ0->Z0_DEB01
			ElseIf cTipo == 'C'
				__cConta := SZ0->Z0_CRED01
			EndIf
		Else
			IW_MSGBOX("Regra "+Chr(13)+chr(10)+'Contabiliza��o','Verba ou Centro de Custo n�o Cadastrado (SZ0)',"STOP")
			__cConta := ''
		EndIf
	Else
		If CTT->(dbSeek(xFilial("CTT")+__CC))
			If SRV->(dbSeek(xFilial("SRV")+__Verba))
				__cCampo += CTT->CTT_FOLHA
				__cConta := &__cCampo
			Else
				IW_MSGBOX("Cadastro "+Chr(13)+chr(10)+'Verba','Verba n�o Cadastrada',"STOP")
				__cConta := ''
			EndIf
		Else
			IW_MSGBOX("Cadastro "+Chr(13)+chr(10)+'Centro de Custo','Centro de Custo n�o Cadastrado',"STOP")
			__cConta := ''
		EndIf
	EndIf
Else
	IW_MSGBOX("Tipo "+Chr(13)+chr(10)+'N�o Informado','Informe o tipo de Lan�amento (D/C)',"STOP")
	__cConta := ''
EndIf
RestArea(aAreaCTT)
RestArea(aAreaSRV)
Return(__cConta)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LA01HIST  �Autor  �Luiz Eduardo Fael   � Data �  02/21/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna historico                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION LA01HIST()
Local __cDesc := SRZ->RZ_PD +" - "+SUBSTR(MesExtenso(Ddatabase),1,3)+"/"+Str(Year(DdataBase),4)
SRV->(dbSetOrder(1))
If SRV->(dbSeek(xFilial("SRV")+SRZ->RZ_PD))
	__cDesc := SRZ->RZ_PD +" - "+ ALLTRIM(SRV->RV_DESC) +" - "+SUBSTR(MesExtenso(Ddatabase),1,3)+"/"+Str(Year(DdataBase),4)
EndIf
Return(__cDesc)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FUNLPA01  �Autor  �Microsiga           � Data �  02/26/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION LPA01VAL(cTipo)
Local __nValor := 0
If Alltrim(SM0->M0_CODIGO) == '06' .or. Alltrim(SM0->M0_CODIGO) == '12'
	SZ0->(dbSetOrder(1))
	If SZ0->(dbSeek(XFILIAL("SZ0")+SRZ->RZ_PD+SRZ->RZ_CC))
		If cTipo == 'D'
			If !Empty(SZ0->Z0_DEB01) .and. Empty(SZ0->Z0_CRED01)
				__nValor := SRZ->RZ_VAL
			EndIf
		ElseIf cTipo == 'C'
			If !Empty(SZ0->Z0_CRED01) .and. Empty(SZ0->Z0_DEB01)
				__nValor := SRZ->RZ_VAL
			EndIf
		ElseIf cTipo == 'X'
			If !Empty(SZ0->Z0_CRED01) .and. !Empty(SZ0->Z0_DEB01)
				__nValor := SRZ->RZ_VAL
			EndIf
		EndIf
	EndIf
EndIf
Return(__nValor)