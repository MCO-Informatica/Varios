/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �nValAbpag �Autor  �Microsiga           � Data �  10/02/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valor do Titulo no CNAB a Pagar                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function nValAbpag()

Local nSE2Valor := 0
Local nAbat     := 0
Local cBusca    := ""
Local _aArea    := GetArea()            

nSE2Valor := SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE

cBusca := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA)        

DbSelectArea("SE2")
DbSetOrder(1)
dbSeek(xFilial("SE2")+cBusca)
While !Eof() .and. SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA) == cBusca
	If SE2->E2_TIPO $ MVABATIM 
		nAbat += SE2->E2_SALDO
	Endif
	SE2->(dbSkip())
EndDo

nSE2Valor := nSE2Valor - nAbat     

RestArea(_aArea)

Return(nSE2Valor)