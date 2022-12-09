#include "PRTOPDEF.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AC0007    �Autor  �Sergio Junior       � Data �  12/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o pedido utiliza fornecedor ou se � uma dev.   ���
���          � para mostrar o nome no campo correto (Browse)              ���
�������������������������������������������������������������������������͹��
���Uso       � Pedido de Compras                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AC0008()
cRet := ""
  
  if (SF1->F1_TIPO = 'B') .AND. (SF1->F1_TIPO = 'D')
    cRet := GETADVFVAL("SA1","A1_NOME",XFILIAL("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,1,"")
  else
    cRet := GETADVFVAL("SA2","A2_NOME",XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,1,"")
  endif                                            
  
Return cRet