#include "rwmake.ch"

User Function Produto()

Processa({||RunProc()},"Ajusta Cadastro de Produtos")
Return


Static Function RunProc()

Local _cFlag	:=	"N"

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
ProcRegua(RecCount())

While ! Eof()
	
	IncProc("Processando...")
	
	dbSelectArea("SB2")
	dbSetOrder(1)
	If dbSeek(xFilial("SB2")+SB1->B1_COD,.f.)
		_cFlag	:=	"S"
	EndIf

	dbSelectArea("SB8")
	dbSetOrder(1)
	If dbSeek(xFilial("SB8")+SB1->B1_COD,.f.)
		_cFlag	:=	"S"
	EndIf

	dbSelectArea("SC2")
	dbSetOrder(2)
	If dbSeek(xFilial("SC2")+SB1->B1_COD,.f.)
		_cFlag	:=	"S"
	EndIf
	
	dbSelectArea("SC6")
	dbSetOrder(2)
	If dbSeek(xFilial("SC6")+SB1->B1_COD,.f.)
		_cFlag	:=	"S"
	EndIf
	
	dbSelectArea("SC7")
	dbSetOrder(2)
	If dbSeek(xFilial("SC7")+SB1->B1_COD,.f.)
		_cFlag	:=	"S"
	EndIf
	
	dbSelectArea("SC9")
	dbSetOrder(7)
	If dbSeek(xFilial("SC9")+SB1->B1_COD,.f.)
		_cFlag	:=	"S"
	EndIf

	dbSelectArea("SD1")
	dbSetOrder(2)
	If dbSeek(xFilial("SD1")+SB1->B1_COD,.f.)
		_cFlag	:=	"S"
	EndIf

	dbSelectArea("SD2")
	dbSetOrder(1)
	If dbSeek(xFilial("SD2")+SB1->B1_COD,.f.)
		_cFlag	:=	"S"
	EndIf

	dbSelectArea("SD3")
	dbSetOrder(3)
	If dbSeek(xFilial("SD3")+SB1->B1_COD,.f.)
		_cFlag	:=	"S"
	EndIf

	dbSelectArea("SD4")
	dbSetOrder(1)
	If dbSeek(xFilial("SD4")+SB1->B1_COD,.f.)
		_cFlag	:=	"S"
	EndIf

	dbSelectArea("SD5")
	dbSetOrder(2)
	If dbSeek(xFilial("SD5")+SB1->B1_COD,.f.)
		_cFlag	:=	"S"
	EndIf

	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+SB1->B1_COD,.f.)
		_cFlag	:=	"S"
	EndIf

	dbSelectArea("SG1")
	dbSetOrder(2)
	If dbSeek(xFilial("SG1")+SB1->B1_COD,.f.)
		_cFlag	:=	"S"
	EndIf

	
	If _cFlag == "N"
		dbSelectArea("SB1")
		RecLock("SB1",.f.)
		dbDelete()
		MsUnLock()
	EndIf
	
	dbSelectArea("SB1")
	dbSkip()

EndDo

Return