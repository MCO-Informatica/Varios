#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � RCRME008 � Autor � Adriano Leonardo    � Data � 11/10/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de valida��o da inclus�o de nova taxa para forecast.���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RCRME008()

Local _aSavArea := GetArea()
Local _aSavSZC	:= SZC->(GetArea())
Local _cRotina	:= "RCRME008"
Local _lRet		:= .T.

If M->ZC_MOEDA == 1
	MsgStop("N�o � permitida defini��o de taxa para moeda 1!",_cRotina+"_001")
	_lRet := .F.
Else
	dbSelectArea("SZC")
	dbSetOrder(2) //Filial + Ano + Moeda
	If dbSeek(xFilial("SZC")+M->ZC_TIPO+M->ZC_ANO+PADR(M->ZC_MOEDA,TAMSX3("ZC_MOEDA")[01]))
		MsgStop("J� existe um cadastro para essa moeda e ano base!",_cRotina+"_002")
		_lRet := .F.
	EndIf
EndIf

RestArea(_aSavSZC)
RestArea(_aSavArea)

Return(_lRet)
