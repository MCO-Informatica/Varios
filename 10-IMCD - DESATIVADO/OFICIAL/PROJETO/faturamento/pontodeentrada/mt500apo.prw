#INCLUDE "rwmake.ch"
#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT500APO � Autor � Giane - ADV Brasil � Data �  27/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada apos a rotina de eliminar residuos do pedi���
���          � do, para gravar o log deste evento na tabela SZ4           ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI  - faturamento                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT500APO()    

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT500APO" , __cUserID )

	if Paramixb[1]
		U_GrvLogPd(SC6->C6_NUM,SC6->C6_CLI,SC6->C6_LOJA,'Eliminar Residuos', , SC6->C6_ITEM)
	endif   

Return