#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MSE3440 Autor   � Luiz Alberto          � Data � 03/03/12 ���
�������������������������������������������������������������������������Ĵ��
���Objetivo  � Ponto de Entrada respons�vel por Ajustes na Base de Calculo
				   das comiss�es dos vendedores
�������������������������������������������������������������������������Ĵ��
���Uso       � METALACRE                                                  ���
��                                                                        ���
��                                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MSE3440()
Local aArea := GetArea()

/*If !Empty(SE1->E1_VEND1) .And. SE1->E1_VEND1 == SA3->A3_COD	// Processando Comiss�o do Primeiro Vendedor
	If SE3->E3_BASE <> SE1->E1_BASCOM1
		SE3->E3_BASE	:=	SE1->E1_BASCOM1
		SE3->E3_COMIS 	:=	ROUND((SE1->E1_BASCOM1 * SE1->E1_COMIS1)/100,2)
		SE3->E3_PORC	:=	SE1->E1_COMIS1
	Endif
ElseIf !Empty(SE1->E1_VEND2) .And. SE1->E1_VEND2 == SA3->A3_COD	// Processando Comiss�o do Segundo Vendedor
	If SE3->E3_BASE <> SE1->E1_BASCOM2
		SE3->E3_BASE	:=	SE1->E1_BASCOM2
		SE3->E3_COMIS 	:=	ROUND((SE1->E1_BASCOM2 * SE1->E1_COMIS2)/100,2)
		SE3->E3_PORC	:=	SE1->E1_COMIS2
	Endif
ElseIf !Empty(SE1->E1_VEND3) .And. SE1->E1_VEND3 == SA3->A3_COD	// Processando Comiss�o do Terceiro Vendedor
	If SE3->E3_BASE <> SE1->E1_BASCOM3
		SE3->E3_BASE	:=	SE1->E1_BASCOM3
		SE3->E3_COMIS 	:=	ROUND((SE1->E1_BASCOM3 * SE1->E1_COMIS3)/100,2)
		SE3->E3_PORC	:=	SE1->E1_COMIS3
	Endif
Endif */
RestArea(aArea)
Return .t.