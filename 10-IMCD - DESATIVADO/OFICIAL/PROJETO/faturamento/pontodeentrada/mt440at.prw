#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MT440AT   � Autor � Eneovaldo Roveri Juni � Data �19/11/2009���
�������������������������������������������������������������������������Ĵ��
���Descricao �Validar libera��o de pedido                                 ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MT440AT()
	Local _lRet := .T.

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT440AT" , __cUserID )

	if SC5->C5_X_CANC == "C"
		MsgAlert( "Pedido Cancelado!" )
		_lRet := .F.
	endif
	if SC5->C5_X_REP == "R"
		MsgAlert( "Pedido Reprovado!" )
		_lRet := .F.
	endif

Return( _lRet )