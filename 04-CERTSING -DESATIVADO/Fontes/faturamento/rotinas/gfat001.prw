#Include "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Gfat001   ºAutor  ³Daniel Franciulli   º Data ³  07/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca o tipo de saída correto em pedidos manuais            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GFAT001(_cProduto,_cCliente,_cLojaCli,_lTlv,_cTipPed,_lCrm)

Local _cTipoCli := Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLojaCli,"A1_TIPO")
Local _cEstCli  := Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLojaCli,"A1_EST")
Local _cInsCli	:= Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLojaCli,"A1_INSCR") 
Local _cTes		:= SF4->F4_CODIGO

Default _lTlv 	:= .F.
Default _lCrm 	:= .F.
Default _cProduto:= iif(_lTlv, M->UB_PRODUTO, iiF(_lCrm,M->CK_PRODUTO,M->C6_PRODUTO)) 
Default _cTipPed := iif(_lTlv .or. _lCrm, "N", M->C5_TIPO)

If Type("lProspect") <> "U" .and. lProspect
	_cTipoCli := Posicione("SUS",1,xFilial("SUS")+_cCliente+_cLojaCli,"US_TIPO")
	_cEstCli  := Posicione("SUS",1,xFilial("SUS")+_cCliente+_cLojaCli,"US_EST")
	_cInsCli  := Posicione("SUS",1,xFilial("SUS")+_cCliente+_cLojaCli,"US_INSCR")
EndIf

If !(_cTipPed$"B/D")
	_cTes := U_VerTes(_cProduto,_cTipoCli,_cEstCli,_cTes)
Endif

Return(_cTes)