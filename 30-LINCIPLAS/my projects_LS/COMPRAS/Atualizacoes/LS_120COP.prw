#include "ap5mail.ch"
#include "sigawin.ch"
#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_120COP
// Autor 		Alexandre Dalpiaz
// Data 		07/11/11
// Descricao  	Copia de pedido de compras entre filiais
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_120COP()
/////////////////////////

SY1->(DbSetOrder(3))
If !(SY1->(DbSeek(xFilial('SY1') + __cUserId,.f.)))
	MsgBox('Você não tem permissão para copiar Pedidos de Compras','ATENÇÃO!!!','ALERT')
	Return()
EndIf

_cFilAnt  := cFilAnt
_cNumEmp  := cEmpAnt

_cPedOri   := SC7->C7_NUM
_cFilOri   := SC7->C7_FILIAL
_cFilCop   := cFilAnt
_cNomCop   := SM0->M0_FILIAL
_cNomOri   := Posicione('SM0',1,cEmpAnt + SC7->C7_FILIAL,'M0_FILIAL')
_cPedCop   := space(6)
cNumEmp    := cEmpAnt + cFilAnt
                                          
_C7_NUM := GetNumSC7() 
Do While .T.
	DbSelectArea("SC7")
	DbSetOrder(1)
	If DbSeek(xFilial("SC7") + _C7_NUM,.f.)
		ConfirmSX8()
		_C7_NUM := GetNumSC7() 
	Else
		Exit
	EndIf
EndDo

Define MsDialog _oDlg Title "Cópia de pedidos de Compras entre filiais"  From 000,000 to 200,500 of oMainWnd Pixel

@ 005,010 Say 'Número do Pedido a copiar:'                                  Size 250,010 COLOR CLR_BLACK Pixel of _oDlg
@ 005,100 MsGet _oPedOri  Var _cPedOri   	Picture "999999"     			Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 020,010 Say 'Filial de Origem:'                        					Size 150,010 COLOR CLR_BLACK Pixel of _oDlg
@ 020,100 MsGet _oFilOri Var _cFilOri                            			Size 020,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 020,130 MsGet _oNomOri Var _cNomOri                            			Size 100,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 035,010 Say 'Filial de Destino:'                       					Size 150,010 COLOR CLR_BLACK Pixel of _oDlg
@ 035,100 MsGet _oFilCop Var _cFilCop                            			Size 020,010 COLOR CLR_BLACK Pixel of _oDlg when .f.  
@ 035,130 MsGet _oNomCop Var _cNomCop                            			Size 100,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 050,010 Say 'Número do Pedido a gerar:'                                  	Size 250,010 COLOR CLR_BLACK Pixel of _oDlg
@ 050,100 MsGet _oPedCop  Var _C7_NUM  	Picture "999999"     				Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.

@ 85,10 BmpButton Type 1 Action (_oDlg:End(),MsAguarde({||CopiaPC()},'Gerando PC ' + _C7_NUM + ' na loja ' + _cNomCop))
@ 85,50 BmpButton Type 2 Action (_oDlg:End())

Activate MsDialog _oDlg Centered

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function CopiaPc()
/////////////////////////

ConfirmSx8()
DbSelectArea('SC7')
DbSeek(_cFilOri + _cPedOri,.f.)

_aCabPc   := {}            

aAdd(_aCabPc, {"C7_NUM"     , _C7_NUM			, Nil})
aAdd(_aCabPc, {"C7_EMISSAO"	, dDataBase			, Nil})
aAdd(_aCabPc, {"C7_FORNECE"	, SC7->C7_FORNECE  	, Nil})
aAdd(_aCabPc, {"C7_LOJA"	, SC7->C7_LOJA    	, Nil})
aAdd(_aCabPc, {"C7_FILENT"	, _cFilCop         	, Nil})
aAdd(_aCabPc, {"C7_COND"   	, SC7->C7_COND		, Nil})
aAdd(_aCabPc, {"C7_CONTATO"	, SC7->C7_CONTATO	, Nil})

_aItensPc := {}
Do While !eof() .and. _cFilOri + _cPedOri == SC7->C7_FILIAL + SC7->C7_NUM
	
	_aItem := {}	
	aAdd(_aItem, {"C7_ITEM"		, SC7->C7_ITEM    					, Nil})
	aAdd(_aItem, {"C7_PRODUTO"	, SC7->C7_PRODUTO 					, Nil})
	aAdd(_aItem, {"C7_QUANT"	, SC7->C7_QUANT   					, Nil})
	aAdd(_aItem, {"C7_UM"    	, SC7->C7_UM       					, Nil})
	aAdd(_aItem, {"C7_QTSEGUM"	, SC7->C7_QTSEGUM 					, Nil})
	aAdd(_aItem, {'C7_PRECO'	, SC7->C7_PRECO 					, NIL})
	aAdd(_aItem, {'C7_TOTAL' 	, SC7->C7_TOTAL                    	, NIL})
	aAdd(_aItem, {"C7_DATPRF" 	, max(SC7->C7_DATPRF,date())		, Nil})
	
	aAdd(_aItensPc,aClone(_aItem))
	DbSkip()
	
EndDo

lMsErroAuto := .f.
MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},1,_aCabPc,_aItensPc,3,.f.)

If lMsErroAuto
	MostraErro()
Else
	MsgBox('Pedido de compras ' + _C7_NUM + ' gerado com sucesso para loja ' + _cNomCop,'','INFO')
EndIf

DbSelectArea('SC7')
DbSeek(cFilAnt + _C7_NUM,.f.)
cFilAnt  := _cFilAnt
cNumEmp  := _cNumEmp
SM0->(DbSeek(cEmpAnt + cFilAnt))

Return()
