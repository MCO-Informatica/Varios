#Include "Protheus.ch"
#Include "RwMake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SFATG001  �Autor  �Felipe Valenca      � Data �  28/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho para preencher Quantidade e Percentual da tabela    ���
���          �de Rateio de Metas. (SZ5)                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SFATG001        
Local nRet := 0
Local cProduto	:= M->Z5_COD
Local cRegiao	:= M->Z5_CODREG

dbSelectArea("SZ5")
dbGoTop()
dbSetOrder(1)

Do While !Eof()
	If cProduto == Z5_COD .And. cRegiao == Z5_CODREG
		nRet := Z5_QTDREG
		M->Z5_PERCREG := Z5_PERCREG
		Return nRet		
	Endif
	dbSkip()
EndDo

Return nRet