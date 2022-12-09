#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVV006	�Autor  �Microsiga		     � Data �  15/08/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o do saldo do produto na desmontagem de produto     ���
���          �(Mata242)                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function PZCVV006()

	Local aArea		:= GetArea()
	local cQuery	:= ""
	Local cArqTmp	:= ""
	Local lRet		:= .T.
	Local cCod		:= "" 
	Local cArmaz	:= ""

	If IsInCallStack("MATA242")

		cCod	:= GdFieldGet("D3_COD") 
		cArmaz	:= GdFieldGet("D3_LOCAL")

		If Empty(cCod) .Or. Empty(cArmaz) 
			lRet := .F.
			Aviso("Aten��o","C�digo do produto e/ou armaz�m n�o informado.",{"Ok"},2)
		Else
			cArqTmp	:= GetNextAlias()
			cQuery	:= " SELECT B2_COD, B2_LOCAL, (B2_QATU-B2_RESERVA-B2_QACLASS) SALDO FROM "+RetSqlName("SB2")+" SB2 "
			cQuery	+= " WHERE SB2.B2_FILIAL = '"+xFilial("SB2")+"' "
			cQuery	+= " AND SB2.B2_COD = '"+cCod+"' " 
			cQuery	+= " AND SB2.B2_LOCAL = '"+cArmaz+"' "
			cQuery	+= " AND SB2.D_E_L_E_T_ = ' ' "

			DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

			If (cArqTmp)->(!Eof())
				If (cArqTmp)->SALDO > 0
					lRet := .F.
					Aviso("Aten��o","Produto com saldo existente, n�o ser� permitido � desmontagem. ",{"Ok"},2)
				EndIf
			EndIf

			If Select(cArqTmp) > 0
				(cArqTmp)->(DbCloseArea())
			EndIf
		EndIf
	EndIf

	RestArea(aArea)	
Return lRet