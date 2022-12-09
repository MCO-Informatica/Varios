#include "rwmake.ch"

User Function RFATA04()

Processa({|| AJUSTE()},"Ajuste Metas Venda")
Return

Static Function AJUSTE()

dbSelectArea("SB1")
dbSetOrder(4)
dbGoTop()
ProcRegua(RecCount())

_cSequen := "000"
_cDoc	 :=	GetSX8Num("SCT")
ConfirmSX8()


dbSelectArea("SB1")
While Eof() == .f.
	
	IncProc("Processando Metas de Venda por Grupo/Produto...")
	
	_cSequen	:=	Soma1(_cSequen)
	
	RecLock("SCT",.T.)
	SCT->CT_FILIAL	:=	xFilial("SCT")
	SCT->CT_DOC		:=	_cDoc
	SCT->CT_SEQUEN	:=	_cSequen
	SCT->CT_DESCRI	:=	"META POR PRODUTO"
	SCT->CT_DATA	:=	CTOD("01/04/2011")
	SCT->CT_GRUPO	:=	SB1->B1_GRUPO
	SCT->CT_TIPO	:=	SB1->B1_TIPO
	SCT->CT_PRODUTO	:=	SB1->B1_COD
	SCT->CT_MOEDA	:=	1
	SCT->CT_QUANT	:=	1
	SCT->CT_VALOR	:=	1
	MsUnLock()
	
	dbSelectArea("SB1")
	dbSkip()
EndDo

dbSelectArea("SX5")
dbSetOrder(1)
dbGoTop()
ProcRegua(RecCount())

_cDoc	 :=	GetSX8Num("SCT")
ConfirmSX8()

dbSelectArea("SX5")
If dbSeek(xFilial("SX5")+"A2",.f.)
	_cSequen := "000"
	
	While Eof() == .f. .and. SX5->X5_FILIAL == xFilial("SX5") .and. X5_TABELA == "A2"
		
		IncProc("Processando Metas de Venda por Região...")
		
		If Len(Alltrim(SX5->X5_CHAVE)) < 4
			dbSelectArea("SX5")
			dbSkip()
			Loop
		EndIf
		
		_cSequen	:=	Soma1(_cSequen)
		
		RecLock("SCT",.T.)
		SCT->CT_FILIAL	:=	xFilial("SCT")
		SCT->CT_DOC		:=	_cDoc
		SCT->CT_SEQUEN	:=	_cSequen
		SCT->CT_DESCRI	:=	"META POR REGIAO"
		SCT->CT_DATA	:=	CTOD("01/04/2011")
		SCT->CT_REGIAO	:=	SX5->X5_CHAVE
		SCT->CT_MOEDA	:=	1
		SCT->CT_QUANT	:=	1
		SCT->CT_VALOR	:=	1
		MsUnLock()
		
		dbSelectArea("SX5")
		dbSkip()
	EndDo
EndIf

Return
