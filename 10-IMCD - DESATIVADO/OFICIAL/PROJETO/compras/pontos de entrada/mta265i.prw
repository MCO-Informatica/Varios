#include "PROTHEUS.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTGRVLOT  �Autor  �  LUIZ OLIVEIRA      � Data �  02/02/2015���
*/
User Function MTA265I()
	Local nLinha := ParamIxb[1]// Atualiza��o de arquivos ou campos do usu�rio ap�s a Inclus�o da Distribui��o do Produto      

	if SB8->(!eof())

		if Empty(SB8->B8_DFABRIC)
			RecLock("SB8",.F.)
			SB8->B8_DFABRIC := SD1->D1_DFABRIC   
			msUnlock()
		endif
	endif

Return Nil
