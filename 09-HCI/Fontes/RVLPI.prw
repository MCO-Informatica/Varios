#INCLUDE "PROTHEUS.CH"
#INCLUDE "PRTOPDEF.CH"

/*                                                                                       
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �U_VL_PI   �Autor  �ROBSON BUENO        � Data �  13/03/07   ���
�������������������������������������������������������������������������͹��
���Desc1     �VALIDACAO DA ROTINA DE AMARRACAO PI X OC                    ���
���          �          .                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � HCI                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RVLPI(CProduto,cValido)
if cValido='     ' 
  lRet=.F.
else  
LRet :=.T.            
IF cPaisLoc == "BRA"
IF cProduto="               "
    ApMsgInfo("Assumindo o Codigo da Venda por Nao existir Codigo Digitado" + SC6->C6_PRODUTO,"Operacao Invalida")
    lret=.T. 
else
If CProduto <>SC6->C6_PRODUTO
    ApMsgInfo("Codigos Divergentes--> Codigo Compra:" + Cproduto + " Codigo Venda:" + SC6->C6_PRODUTO,"Operacao Invalida")
    LRet=.F.
endif
ENDIF
ENDIF
endif
Return(LRet)
