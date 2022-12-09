#INCLUDE "rwmake.ch"  
#INCLUDE "Protheus.ch"  


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M440SC9I    � Autor � TOTALIT           � Data �  18/06/18  ���
�������������������������������������������������������������������������͹��
���Descricao � PE - Ajusta o Armazem da tabela SC9 para libera��o do      ���
���          � pedido de vendas.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � CARMAR - PCP MOD 1                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M440SC9I()


Local _cAlias := GetArea()


If Alltrim(SC9->C9_LOCAL) != Alltrim(SC6->C6_LOCAL)
   Reclock("SC9",.F.)
   SC9->C9_LOCAL := SC6->C6_LOCAL
   SC9->(MsUnlock())
   
EndIf   

RestArea(_cAlias)   

Return
