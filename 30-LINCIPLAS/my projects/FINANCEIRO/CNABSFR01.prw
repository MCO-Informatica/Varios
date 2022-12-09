#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CNABSFR01 �Autor  �Rodrigo Okamoto       � Data �  29/01/10 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o c�digo da empresa para o arquivo CNAB Cobran�a   ���
���          � para o Banco Safra                                         ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10 - LINCIPLAS                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CNABSFR01                                                 

Private cRet := ""

//EXECBLOCK("CNABSFR01",.F.,.F.) --> fun��o antiga que estava no cnab                        
//cRet := STRZERO(VAL(ALLTRIM(SA6->A6_AGENCIA)),5,0)+STRZERO(VAL(ALLTRIM(SA6->A6_NUMCON)),9,0) 
cRet := "02600"+STRZERO(VAL(ALLTRIM(SA6->A6_NUMCON)),9,0) 

Return(cRet)