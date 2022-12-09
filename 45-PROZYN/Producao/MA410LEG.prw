#include 'protheus.ch'
#include 'parmtype.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �MA410LEG		�Autor  �Microsiga	     � Data �  14/02/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �PE para alterar a legenda do pedido de venda				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function MA410LEG()

	Local aArea	:= GetArea()

	Local aCres := aClone(ParamIxb)

	// AAdd( aCres,  { 'BR_PINK'	, 'Blq. Faturamento Minimo'} )
	// AAdd( aCres,  { 'BR_BRANCO'	, 'Blq. Data Ciclo'} )
	AAdd( aCres,  { 'BR_PRETO'	, 'Blq. de Cr�dito'} )
	AAdd( aCres,  { 'BR_MARROM'	, 'Blq. de Estoque'} )
	// AAdd( aCres,  { 'BR_MARROM'	, 'Reprovado'} )
	AAdd( aCres,  { 'BR_VIOLETA', 'Blq. Financeiro'} )
	AAdd( aCres,  { 'BR_PINK'	, 'Blq. de Margem'} )
	AAdd( aCres,  { 'CLR_HCYAN'	, 'Blq. de Pre�o M�nimo'} )
	

	RestArea(aArea)	
Return aCres
