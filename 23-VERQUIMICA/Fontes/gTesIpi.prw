
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GTESIPI   �Autor  �Nelson Junior       � Data �  12/02/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho para alertar venda de produto com IPI e TES sem     ���
���          �tributa��o                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function gTesIpi(_cPrd, _cTes)

aAreaSUB := SUB->(GetArea())
aAreaSC6 := SC6->(GetArea())

_nAlqIpi := Posicione("SB1",1,xFilial("SB1")+_cPrd,"B1_IPI")
_cCrdIpi := Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_IPI")

If _nAlqIpi <> 0 .And. AllTrim(_cCrdIpi) == "N"
	MsgInfo("Produto com al�quota de IPI e TES com opera��o sem tributa��o.", "Opera��o com diverg�ncia")
EndIf

RestArea(aAreaSUB)
RestArea(aAreaSC6)

Return(_cTes)