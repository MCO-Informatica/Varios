#Include "RWMAKE.CH"
#Include "TOPCONN.CH"                                      
#Include "Protheus.Ch"
#include "TbiConn.ch" 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK271LEG  � Autor �Mateus Hengle       � Data � 03/12/2013  ���
�������������������������������������������������������������������������͹��
���Descricao     � PE que altera o texto da legenda do Call Center		  ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������Ĵ��
���Adalberto Neto�11/03/14�Alterei o nome da cor MARROM para VIOLETA      ���
�������������������������������������������������������������������������ͼ��                      	
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TK271LEG()  

Local aArea := GetArea()
Local aVetor := {}

aAdd(aVetor, {"BR_VIOLETA" 	, "Atendimento"})
aAdd(aVetor, {"BR_AZUL"		, "Orcamento"})
aAdd(aVetor, {"BR_AMARELO" 	, "Pedido Liberado"})  // criado por Mateus Hengle dia 18/01/14
aAdd(aVetor, {"BR_VERDE" 	, "Pedido Bloqueado"})
aAdd(aVetor, {"BR_VERMELHO"	, "NF. Emitida"}) 
aAdd(aVetor, {"BR_PRETO" 	, "Cancelado"})
aAdd(aVetor, {"BR_PINK"		, "OP Gerada"})    
aAdd(aVetor, {"BR_LARANJA"	, "Bloqueado Credito"})   
 
RestArea(aArea) 

Return aVetor