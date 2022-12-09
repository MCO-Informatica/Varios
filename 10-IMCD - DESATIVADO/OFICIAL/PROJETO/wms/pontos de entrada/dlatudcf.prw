#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DLATUDCF � Autor �  Daniel   Gondran  � Data �  11/05/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para gravar a descricao do produto        ���
���          � na tabela de Ordem de Servico.                             ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function DLATUDCF
	Local cProduto	:= Paramixb[8]

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "DLATUDCF" , __cUserID )

	RecLock("DCF",.F.)
	DCF->DCF_DESPRO := Posicione("SB1",1,xFilial("SB1") + cProduto,"B1_DESC")
	msUnlock()

Return