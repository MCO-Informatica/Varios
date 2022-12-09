#Include "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Gfat001   �Autor  �Daniel Franciulli   � Data �  07/07/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Busca o tipo de sa�da correto em pedidos manuais            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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