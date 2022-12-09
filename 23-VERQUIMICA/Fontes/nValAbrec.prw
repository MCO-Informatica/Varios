/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �nValAbrec �Autor  �Microsiga           � Data �  10/02/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valor do Titulo no CNAB a Receber                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function nValAbrec()

Local nSE1Valor := 0
Local nAbat     := 0
Local cBusca    := ""

_aArea:=GetArea()            

nSE1Valor := SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE

cBusca := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)        

DbSelectArea("SE1")
DbSetOrder(1)
dbSeek(xFilial("SE1")+cBusca)
While !Eof() .and. SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA) == cBusca
	If SE1->E1_TIPO $ MVABATIM 
		nAbat += SE1->E1_SALDO
	Endif
	SE1->(dbSkip())
EndDo

nSE1Valor := nSE1Valor - nAbat  


RestArea(_aArea)

Return(nSE1Valor)