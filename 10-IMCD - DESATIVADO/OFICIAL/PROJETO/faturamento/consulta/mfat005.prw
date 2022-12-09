/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MFAT005   �Autor  �Marcos J.           � Data �  11/30/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para manutencao do cadastro de container's          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
#include "PROTHEUS.CH"
User Function MFAT005()

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MFAT005" , __cUserID )

	Private aRotina := {}

	aAdd(aRotina, {"Hist. Movimentacao" , "U_MFAT5HIS()", 0, 3, 0, Nil})

	AxCadastro("SZ8", "Controle de Container's", "U_MFAT5DEL()", Nil, aRotina)

Return(.T.)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MFAT005   �Autor  �Microsiga           � Data �  11/30/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida a exclusao do cadastro de container's SZ8           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MFAT5DEL()
	Local cQuery := ""
	Local lRet   := .F.

	If SZ8->Z8_USADO == "1"
		Aviso("Exclus�o", "O item em quest�o est� sendo utilizado. Exclus�o n�o permitida", {"Ok"})
		lRet := .F.
	Else
		cQuery := "SELECT COUNT(*) AS TOTREG"
		cQuery += " FROM " + RetSqlName("SZ9") + " SZ9"
		cQuery += " WHERE Z9_FILIAL = '" + SZ8->Z8_FILIAL + "'"
		cQuery += "   AND Z9_PRODUTO = '" + SZ8->Z8_PRODUTO + "'"
		cQuery += "   AND Z9_NUMSER = '" + SZ8->Z8_NUMSER + "'"
		cQuery += "   AND SZ9.D_E_L_E_T_ <> '*'"
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRB1", .F., .F.)
		TRB1->(DbGoTop())
		If TRB1->TOTREG > 0
			lRet := .F.
			Aviso("Exclus�o", "O item em quest�o est� sendo utilizado. Exclus�o n�o permitida", {"Ok"})
		Else
			lRet := .T.
		EndIf
		TRB1->(DbCloseArea())
	EndIf
Return(lRet)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MFAT005   �Autor  �Microsiga           � Data �  11/30/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para visualizar o historico de movimenta��o do      ���
���          �container                                                   ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MFAT5HIS()
Return(.T.)
