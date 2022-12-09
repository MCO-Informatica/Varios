#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³MT120APV  ºAutor  ³Pedro Augusto      º Data ³  16/02/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada na gravacao do SCR   :no momento em que     ±±
±±º           o pedido de compra é gerado                                 º±±
±±ºUso       ³ Exclusivo RENOVA                                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120APV
Local _aArea		:= GetArea()
Local _cGrupo	    := GetMv("MV_PCAPROV")

If !IsinCallStack("CNTA120")  // Só grava o grupo de aprovação para pedidos gerados diretos, sem ser por medição.
	_cGrupo	:= Iif(Alltrim(SC1->C1_GRAPROV)='',_cGrupo,SC1->C1_GRAPROV)
	RestArea(_aArea)
Endif
Return _cGrupo
