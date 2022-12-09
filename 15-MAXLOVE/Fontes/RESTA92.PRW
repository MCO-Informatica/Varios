#INCLUDE "PROTHEUS.CH"

User Function RESTA92()


processa({||RunProc()},"Saldo Inventário Zerado")
return

Static Function RunProc()

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
While !Eof()
	
	IncProc("Processando o produto "+SB1->B1_COD+" - "+SB1->B1_DESC)
	
	
	dbSelectArea("SB7")
	Reclock("SB7",.t.)
	SB7->B7_FILIAL		:=	xFilial("SB7")
	SB7->B7_COD			:=	SB1->B1_COD
	SB7->B7_LOCAL		:=	SB1->B1_LOCPAD
	SB7->B7_TIPO		:=	SB1->B1_TIPO
	SB7->B7_DOC			:=	'IV-311217'
	SB7->B7_QUANT		:=	0
	SB7->B7_DATA		:=	CTOD("31/12/2017")
	SB7->B7_STATUS		:=	'2'
	SB7->B7_ORIGEM		:=	'MATA270'
	MsUnLock()
	
	dbSelectArea("SB1")
	dbSkip()
EndDo


Return
