#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FT30Leg   �Autor  � Luiz Alberto      � Data �  25/09/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Legenda para Oportunidades com FCI Igual Restricao Financ. ���
�������������������������������������������������������������������������͹��
���OBS       � Antigo A410EXC                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FT30Leg()
Local aLegend:= PARAMIXB[1]
aAdd( aLegend,{"BR_AZUL","Restricao Financeira" } )
Return( aLegend )        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FT30COR   �Autor  � Luiz Alberto      � Data �  25/09/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Legenda para Oportunidades com FCI Igual Restricao Financ. ���
�������������������������������������������������������������������������͹��
���OBS       � Antigo A410EXC                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FT30COR()
Local aLegend:= PARAMIXB[1]
aLegend := {}
aAdd(aLegend,{"AD1->AD1_STATUS=='1' .And. AD1->AD1_FCI<>'000010'","BR_VERDE"	, 'Em Aberto'}) //Em Aberto
aAdd(aLegend,{"AD1->AD1_STATUS=='2' .And. AD1->AD1_FCI<>'000010'","BR_PRETO"	, 'Perdido'})	//Perdido
aAdd(aLegend,{"AD1->AD1_STATUS=='3' .And. AD1->AD1_FCI<>'000010'","BR_AMARELO"	, 'Suspenso'})	//Suspenso
aAdd(aLegend,{"AD1->AD1_STATUS=='9' .And. AD1->AD1_FCI<>'000010'","BR_VERMELHO"	, 'Encerrado'})	//Encerrado
aAdd(aLegend,{"AD1->AD1_STATUS$'123456789' .And. AD1->AD1_FCI=='000010'","BR_AZUL", "Restricao Financeira" } )
Return( aLegend )