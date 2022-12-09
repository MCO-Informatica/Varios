#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � RFATE015   � Autor � Adriano Leonardo    � Data � 10/02/18 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina responsav�l por avaliar no momento da inclus�o do   ���
���Desc.     � pedido de venda, se o cliente possui t�tulos em atraso.    ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RFATE015()

Private _cRotina	:= "RFATE015"
Private _aSavArea	:= GetArea()
Private _cQuery		:= ""
Private _cAlias		:= GetNextAlias()
Private _cEnt		:= CHR(13) + CHR(10)
Private _lRet		:= .T.

If Inclui .And. !(M->C5_TIPO $ "DB") .And. !Empty(M->C5_CLIENTE) .And. !Empty(M->C5_LOJACLI)
	
	_cQuery := "SELECT ISNULL(SUM(E1_SALDO),0) [E1_SALDO] FROM " + RetSqlName("SE1") + " SE1 " + _cEnt
	_cQuery += "WHERE SE1.D_E_L_E_T_='' " + _cEnt
	_cQuery += "AND SE1.E1_FILIAL='" + xFilial("SE1") + "' " + _cEnt
	_cQuery += "AND SE1.E1_CLIENTE='" + M->C5_CLIENTE + "' " + _cEnt
	_cQuery += "AND SE1.E1_LOJA='" + M->C5_LOJACLI + "' " + _cEnt
	_cQuery += "AND (SE1.E1_SALDO+SE1.E1_SDACRES-SE1.E1_SDDECRE)>0 " + _cEnt
	_cQuery += "AND SE1.E1_VENCREA<'" + DTOS(dDataBase) + "' " + _cEnt
	_cQuery += "AND SE1.E1_TIPO <> 'NCC' " + _cEnt
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.F.)
	
	dbSelectArea(_cAlias)
	
  	If (_cAlias)->(!EOF())
		If (_cAlias)->E1_SALDO>0
			MsgAlert("Verifique a posi��o financeira do cliente, existem t�tulos em atraso!",_cRotina+"_001")
		EndIf
	EndIf
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbCloseArea())
	
EndIf

RestArea(_aSavArea)

Return(_lRet)