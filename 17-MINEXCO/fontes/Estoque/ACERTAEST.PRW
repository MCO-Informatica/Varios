#include "rwmake.ch"

User Function ACERTAEST()

Processa({||RunProc()},"Zera Estoque SBF")
Return

Static Function RunProc()

/*
dbSelectArea("SBF")
dbSetOrder(1)
dbGoTop()

ProcRegua(RecCount())

While !Eof()
	
	IncProc("Selecionando Produto "+SBF->BF_PRODUTO+" Registro "+StrZero(Recno(),10))
	
	If SBF->BF_QUANT <= 0
		dbSelectArea("SBF")
		dbSkip()
		Loop
	EndIf
	
	RecLock("SB7",.t.)
	SB7->B7_FILIAL		:=	xFilial("SB7")
	SB7->B7_COD			:=	SBF->BF_PRODUTO
	SB7->B7_LOCAL		:=	SBF->BF_LOCAL
	SB7->B7_TIPO		:=	Posicione("SB1",1,xFilial("SB1")+SBF->BF_PRODUTO,"B1_TIPO")
	SB7->B7_QUANT		:=	0
	SB7->B7_QTSEGUM		:=	0
	SB7->B7_DATA		:=	CTOD("31/03/2011")
	SB7->B7_LOTECTL		:=	SBF->BF_LOTECTL
	//SB7->B7_DTVALID		:=	SBF->BF_DTVALID
	SB7->B7_LOCALIZ		:=	SBF->BF_LOCALIZ
	SB7->B7_NUMSERI		:=	SBF->BF_NUMSERI
	SB7->B7_DOC	   		:=	"IV-001"
	SB7->B7_STATUS		:=	"1"
	MsUnLock()
	
	dbSelectArea("SBF")
	dbSkip()
	
EndDo

ALERT("VERIFICAR SE ZEROU TUDO")

dbSelectArea("SBF")
dbSetOrder(1)
dbGoTop()

ProcRegua(RecCount())

_cLotectl	:=	"0000000000"

While !Eof()
	
	IncProc("Selecionando Produto "+SBF->BF_PRODUTO+" Registro "+StrZero(Recno(),10))
	
	If SBF->BF_QUANT <= 0
		dbSelectArea("SBF")
		dbSkip()
		Loop
	EndIf
	
	_cLotectl	:=	Soma1(_cLotectl,1)

	RecLock("SB7",.t.)
	SB7->B7_FILIAL		:=	xFilial("SB7")
	SB7->B7_COD			:=	SBF->BF_PRODUTO
	SB7->B7_LOCAL		:=	SBF->BF_LOCAL
	SB7->B7_TIPO		:=	Posicione("SB1",1,xFilial("SB1")+SBF->BF_PRODUTO,"B1_TIPO")
	SB7->B7_QUANT		:=	SBF->BF_QTSEGUM
	SB7->B7_DATA		:=	CTOD("01/04/2011")
	SB7->B7_LOTECTL		:=	_cLotectl
	SB7->B7_DTVALID		:=	CTOD("31/12/2020")
	SB7->B7_DOC	   		:=	"IV-002"
	SB7->B7_STATUS		:=	"1"
	SB7->B7_NUMSERI		:=	SBF->BF_NUMSERI
	MsUnLock()
	
	dbSelectArea("SBF")
	dbSkip()
	
EndDo

ALERT("VERIFICAR SE GEROU OS LOTES")
*/    
dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()

ProcRegua(RecCount())

While !Eof()
	
	IncProc("Selecionando Produto "+SB1->B1_COD+" Registro "+StrZero(Recno(),10))
	
	If SB1->B1_LOCALIZ <> 'S'
		dbSelectArea("SB1")
		dbSkip()
		Loop
	EndIf
	
	RecLock("SB1",.f.)
	SB1->B1_LOCALIZ		:=	'N'
	If !Empty(SB1->B1_SEGUM)
		SB1->B1_UM		:=	SB1->B1_SEGUM
	EndIf
	MsUnLock()
	
	dbSelectArea("SB1")
	dbSkip()
	
EndDo

ALERT("TIROU A LOCALIZACAO E SEGUNDA UNIDADE")

Return()

