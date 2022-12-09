#Include "Protheus.ch"

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

User Function GFAT002(_cProduto,_cCliente,_cLojaCli,_lTlv,_cTipPed)

Local _cSm0 := SM0->M0_ESTCOB
Local _cTipoCli := Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLojaCli,"A1_TIPO")
Local _cEstCli  := Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLojaCli,"A1_EST")
Local _cInsCli	:= Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLojaCli,"A1_INSCR")
Local _cTes		:= SF4->F4_CODIGO

Default _lTlv 	:= .F.
Default _cProduto:= iif(_lTlv, M->UB_PRODUTO, M->C6_PRODUTO) 
Default _cTipPed := iif(_lTlv, "N", M->C5_TIPO) 


If Type("lProspect") <> "U" .and. lProspect
	_cTipoCli := Posicione("SUS",1,xFilial("SUS")+_cCliente+_cLojaCli,"US_TIPO")
	_cEstCli  := Posicione("SUS",1,xFilial("SUS")+_cCliente+_cLojaCli,"US_EST")
	_cInsCli  := Posicione("SUS",1,xFilial("SUS")+_cCliente+_cLojaCli,"US_INSCR")
EndIf

If !(_cTipPed$"B/D")
	_cTes := U_VerTes(_cProduto,_cTipoCli,_cEstCli,_cTes)
	_cCfx := Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_CF")
Else
	_cCfx := SF4->F4_CF		
endif



IF 	_cEstcli <> _cSm0
	_cCf := "6"+Substr(_cCfx,2,3)
ELSE
	_cCf := Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_CF")
Endif


Return(_cCf)