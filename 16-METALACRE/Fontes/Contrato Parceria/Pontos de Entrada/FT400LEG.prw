#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch"
#INCLUDE 'COLORS.CH'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FT400LEG | Autor � Luiz Alberto        � Data � 30/04/15 ���
�������������������������������������������������������������������������Ĵ��
���Objetivo  � Ponto de Entrada Adi��o da Nova Legenda de Contrato
				Bloqueado
�������������������������������������������������������������������������Ĵ��
���Uso       � METALACRE                                        ���
��                                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FT400LEG()
Local aArea := GetArea()
Local aLegendas := {}

aLegendas := {{"BR_VIOLETA",'Contrato Bloqueado - Aprov Supervisor'},;
              {"BR_PRETO",'Contrato Encerrado'},;
              {"BR_MARROM",'Contrato Encerrado Automaticamente'}}

RestArea(aArea)
Return aLegendas