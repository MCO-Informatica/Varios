#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F240FIL  �Autor  �  Junior Carvalho   � Data � 18/09/2019  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para     ���
�������������������������������������������������������������������������͹��
���Uso       � FINA241                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F240FIL

Local cRet := ""
Local cAliasX := GetNextAlias()
Local cFornec := ""

BeginSql Alias cAliasX

SELECT A2_COD||A2_LOJA  FORNECEDOR 
FROM %Table:SA2%
WHERE A2_DATBLO <> ' ' 
AND D_E_L_E_T_ = ' ' 

EndSql 


While (cAliasX)->(!Eof())
	
	cFornec +=(cAliasX)->FORNECEDOR+","
	
	(cAliasX)->(DbSkip())
	
Enddo

(cAliasX)->(DbCloseArea())

IF !EMPTY(cFornec)
	
	cRet := " ( !( (cAliasSE2)->E2_FORNECE + (cAliasSE2)->E2_LOJA $  '"+ cFornec  +"' ) ) "
	
Endif

Return( cRet )
