#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     �Autor  �ELVIS KINUTA        � Data �  22/09/10   ���
�������������������������������������������������������������������������͹��
���Descreicao� Ponto de Entrada- Na gravacao do Documento de Entrada      ���
���          �  gravar no campo D1_XTPPROD (Tipo do Produto) para         ���
���          �  relatorios de Compras.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP COZIL EQUIPAMENTOS                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103FIM()   

/* FUNCAO DESATIVADA EM 26/01/2013, DEVIDO A NAO UTILIZACAO
dbSelectArea("SD1")
dbSetOrder(1)
dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
While !Eof() .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
	
	RecLock("SD1",.F.)
	cTppr := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_TIPO")
	SD1->D1_XTPPROD := cTppr
	MsUnlock()
	
	DBSELECTAREA("SD1")
	dbSkip()
EndDo                                                      

*/
Return()


  
