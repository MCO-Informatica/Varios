#include "protheus.ch"
#include "rwmake.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MSC1110D � Autor �  Giane             � Data �  03/02/11   ���
�������������������������������������������������������������������������͹��
���Descricao � P.e. na rotina de exclusao da solicitacao de compra        ���
���          � para nao permitir excluir caso tenha sido gerada na rotina ���
���          � de Planejamento de vendas (afat050)                        ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/     
User function MSC1110D()
	Local aArea:= GetArea()
	Local lRet := .t.

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MSC1110D" , __cUserID )

	if alltrim(SC1->C1_ORIGEM) == "AFAT050"  
		MsgAlert("Solicita��o com origem no Planejamento de Vendas, N�O pode ser exclu�da! ")   
		lRet := .f.

	Endif

	RestArea(aArea)
Return lRet