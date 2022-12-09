#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch"
#INCLUDE 'COLORS.CH'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FT400COR | Autor � Luiz Alberto        � Data � 30/04/15 ���
�������������������������������������������������������������������������Ĵ��
���Objetivo  � Ponto de Entrada Inser��o de Cores Nova Legenda
				Status de Contrato Bloqueado
�������������������������������������������������������������������������Ĵ��
���Uso       � METALACRE                                        ���
��                                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FT400COR()
Local aArea := GetArea()
Local aCores := PARAMIXB

AAdd(aCores,	{ "ADA_STATUS=='X'",'BR_VIOLETA'  })		//Contrato Bloqueado
AAdd(aCores,	{ "ADA_STATUS=='@'",'BR_PRETO'  })		//Contrato Encerrado
AAdd(aCores,	{ "ADA_STATUS=='Y'",'BR_MARROM'  })		//Encerrado Automaticamente

RestArea(aArea)
Return aCores
