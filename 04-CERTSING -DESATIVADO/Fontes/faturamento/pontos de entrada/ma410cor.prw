#include "PROTHEUS.CH"
#include "TBICONN.CH"
#include "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410COR  �Autor  �Microsiga           � Data �  11/08/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User function MA410COR()

aCores := {	{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)","BR_VERDE","Pedido em Aberto" },;     	//Pedido em Aberto
           	{"!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,"BR_VERMELHO","Pedido Encerrado"},;     	//Pedido Encerrado
			{"!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)","BR_AMARELO","Pedido de Venda Liberado"},; 	// Pedido de Venda Liberado
           	{"C5_BLQ == '1'",'BR_AZUL',"Pedido Bloquedo por regra"},;  												//Pedido Bloquedo por regra
           	{"C5_BLQ == '2'",'BR_LARANJA',"Pedido Bloqueado por verba"},;
           	{"Empty(C5_NOTA) .and. !Empty(C5_XNPSITE) .AND. (!Empty(C5_XNFHRD) .OR. !Empty(C5_XNFSFW) .OR. !Empty(C5_XNFHRE))","BR_BRANCO","Pedido Parcialmente Faturado"}}           										//Pedido Parcialmente Faturado
                       
Return(aCores)                  
