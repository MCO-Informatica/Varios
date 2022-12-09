#include "protheus.ch"
#include "rwmake.ch"

User Function SD3240I()

Private _aArea	:=	GetArea()
Private _lSair	:=	.F.
Private _cProd	:=	Space(15)
Private _nCUSTO5:=	0
Private _nCusto2:=	0
Private _nCusto3:=	0
Private _nCusto4:=	0
Private _nCusto5:=	0

//----> DEVOLUCAO DE MATERIAL RE-APROVEITAVEL
If SD3->D3_TM$"013"
	While .t.
		
		@ 025,005 To 250,600 Dialog janela1 Title OemToAnsi("Busca Custo Produto Origem")
		
		@ 010,010 Say OemToAnsi("Prod Destino")				Size 050,010
		@ 010,060 Get SD3->D3_COD Picture "@!" When .f.		Size 050,010
		@ 010,110 Get Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_DESC") Picture "@!" When .f.		Size 180,010
		@ 025,010 Say OemToAnsi("Prod Origem")				Size 050,010
		@ 025,060 Get _cProd Picture "@!" F3 "SB1" Valid VldProd()	Size 050,010
		@ 025,110 Get Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_DESC") Picture "@!" When .f.			Size 180,010
		@ 040,010 Say OemToAnsi("Custo") 					Size 050,010
		@ 040,060 Get Posicione("SB2",1,xFilial("SB2")+_cProd+SD3->D3_LOCAL,"B2_CM1") Picture "@E 999.9999" When .f.	Size 100,010
		
		@ 100,260 BmpButton Type 1 Action GravaObs()
		
		Activate Dialog janela1
		
		If _lSair
			Exit
		EndIf
	EndDo
EndIf

SysRefresh()

RestArea(_aArea)

Return



Static Function VldProd()

If !Empty(_cProd)
	_lRetorno := .t.
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+_cProd,.f.)
		
		//----> VERIFICA O CUSTO NO SALDO EM ESTOQUE
		dbSelectArea("SB2")
		dbSetOrder(1)
		If dbSeek(xFilial("SB2")+_cProd+SD3->D3_LOCAL,.f.)
			_nCUSTO5:=	( SB2->B2_VATU1 / SB2->B2_QATU )
			_nCusto2:=	( SB2->B2_VATU2 / SB2->B2_QATU )
			_nCusto3:=	( SB2->B2_VATU3 / SB2->B2_QATU )
			_nCusto4:=	( SB2->B2_VATU4 / SB2->B2_QATU )
			_nCusto5:=	( SB2->B2_VATU5 / SB2->B2_QATU )
		Else
			_nCUSTO5:=	0
			_nCusto2:=	0
			_nCusto3:=	0
			_nCusto4:=	0
			_nCusto5:=	0
			MsgBox("Não existe saldo em estoque para o produto "+_cProd,"Saldo em Estoque","Stop")
		EndIf
	Else
		MsgBox("O produto "+_cProd+" não existe.","Cadastro de Produto","Stop")
		_cProd	:=	Space(15)
		_lRetorno := .f.
	EndIf
	
Else
	MsgBox("Produto origem não preenchido.","Valida Produto Origem","Stop")
	_lRetorno := .f.
EndIF

SysRefresh()

Return(_lRetorno)


Static Function GravaObs()

//----> SO ALTERA O CUSTO SE FOR MAIOR QUE ZERO
If _nCUSTO5 > 0
	Reclock("SD3",.F.)
	SD3->D3_CUSTO5	:=	(SD3->D3_QUANT * _nCUSTO5)
	SD3->D3_CUSTO2	:=	(SD3->D3_QUANT * _nCusto2)
	SD3->D3_CUSTO3	:=	(SD3->D3_QUANT * _nCusto3)
	SD3->D3_CUSTO4	:=	(SD3->D3_QUANT * _nCusto4)
	SD3->D3_CUSTO5	:=	(SD3->D3_QUANT * _nCusto5)
	MsUnLock()
EndIf

_lSair := .T.
                                                                
Close(janela1)

Return
