#INCLUDE "RWMAKE.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CtoEsp    �Autor  � NADIA MAMUDE       � Data �  21/01/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fonte para selecionar qual conta sera utilizada, na        ���
���          � gera��o do arquivo sispag, para pagamento via arquivo txt  ���
�������������������������������������������������������������������������͹��
���Uso       � P12 - IMCD BRASIL                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function CtoEsp()

Local _rCtbco := ''
	
	IF cEmpAnt <> "02"
  	  _rCtbco := STRZERO(VAL(SUBSTR(ALLTRIM(SA6->A6_NUMCON),1,5)),12) + space(1) + SUBSTR(SA6->A6_NUMCON,6,1) 	
	 else
	 _rCtbco := STRZERO(VAL(SUBSTR(ALLTRIM(SA6->A6_NUMCON),1,5)),12) + space(1) + SUBSTR(SA6->A6_DVCTA,1,1) 	
	Endif

Return(_rCtbco)