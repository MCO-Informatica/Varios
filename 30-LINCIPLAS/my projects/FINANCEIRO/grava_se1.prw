#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GRAVA_SE1 �Autor  �Rogerio - STCH      � Data �  10/13/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para gravar o valor do juros no titulo    ���
���          � do contas a receber                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10 - LINCIPLAS                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SF2460I

aSE1 := getarea()
DBSELECTAREA("SE1")
DBSETORDER(1)
DBSEEK(XFILIAL("SE1")+SF2->F2_SERIE+SF2->F2_DOC,.T.)

DO WHILE !EOF() .AND. SE1->E1_NUM == SF2->F2_DOC

	Reclock("SE1")
	SE1->E1_PORCJUR := VAL(GETMV("MV_CONTJUR"))
	SE1->E1_PORCJUR := SE1->E1_PORCJUR/30
	SE1->E1_VALJUR  := ((SE1->E1_VALOR*SE1->E1_PORCJUR)/100)
	MSUnlock("SE1")
	DBSELECTAREA("SE1")
	DBSKIP()
ENDDO

RESTAREA(aSE1)

Return



