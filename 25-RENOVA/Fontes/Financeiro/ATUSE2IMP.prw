#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ATUSE2IMP  �Autor  �                				02/10/2015���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para atualziar entidades contabeis na tabela���
��           �SE2 quando do item tiver o maior valor.                      ���
�������������������������������������������������������������������������͹��
���Uso       � Renova                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ATUSE2IMP(nRegSE2)

LOCAL _aAREA := GETAREA()
Local _nRegOri := SE2->(Recno())

SE2->(dbGoto(nRegSE2))  // Posiciono no titulo original

_cContaD  := ALLTRIM(SE2->E2_DEBITO)
_cContaC  := ALLTRIM(SE2->E2_CREDIT)
_cCustoD  := ALLTRIM(SE2->E2_CCD)
_cCustoC  := ALLTRIM(SE2->E2_CCC)
_cItemD   := ALLTRIM(SE2->E2_ITEMD)
_cItemC   := ALLTRIM(SE2->E2_ITEMC)
_cClasseD := ALLTRIM(SE2->E2_CLVLDB)
_cClasseC := ALLTRIM(SE2->E2_CLVLCR)
_Enti05B  := ALLTRIM(SE2->E2_EC05DB)
_Enti05C  := ALLTRIM(SE2->E2_EC05CR)

SE2->(dbGoto(_nRegOri))
Reclock("SE2", .F.)
	SE2->E2_DEBITO := _cContaD
	SE2->E2_CREDIT := _cContaC
	SE2->E2_CCD    := _cCustoD
	SE2->E2_CCC    := _cCustoC
	SE2->E2_ITEMD  := _cItemD
	SE2->E2_ITEMC  := _cItemC
	SE2->E2_CLVLDB := _cClasseD
	SE2->E2_CLVLCR := _cClasseC
	SE2->E2_EC05DB := _Enti05B
	SE2->E2_EC05CR := _Enti05C
Msunlock()

RESTAREA(_aAREA)

Return Nil