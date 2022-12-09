#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
���Programa  �MT120APV  �Autor  �Pedro Augusto      � Data �  16/02/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada na gravacao do SCR   :no momento em que     ��
���           o pedido de compra � gerado                                 ���
���Uso       � Exclusivo RENOVA                                           ���
�����������������������������������������������������������������������������
*/
User Function MT120APV
Local _aArea	:= GetArea()
Local _cGrupo	:= GetMv("MV_PCAPROV")

If !IsinCallStack("CNTA120")  // S� grava o grupo de aprova��o para pedidos gerados diretos, sem ser por medi��o.
	If FunName() =="MATA121"    // tratamento para gravar o grupo do pedido de compras - Gileno 27/08/2018
    	_cGrupo	:= Iif(Alltrim(SC7->C7_APROV)='',_cGrupo,SC7->C7_APROV)
    Else	
		_cGrupo	:= Iif(Alltrim(SC1->C1_GRAPROV)='',_cGrupo,SC1->C1_GRAPROV) 
	Endif	
	RestArea(_aArea)
Endif

Return _cGrupo
