#include "rwmake.ch"
#include "protheus.ch"

User Function AJUSTCS3()

_cRevisa := "000022"
                              

dbSelectArea("CT1")
dbSetOrder(1)
dbGoTop()

ProcRegua(LastRec())

While Eof() == .f.

	IncProc("Processando...")

	dbSelectArea("CS3")
	dbSetOrder(1)
	If !dbSeek(xFilial("CS3")+_cRevisa+CT1->CT1_CONTA,.F.)
		
		ALERT("STOP")
		
		RecLock("CS3",.t.)
		CS3->CS3_FILIAL	:=	XFILIAL("CS3")
		CS3->CS3_CODREV	:=	_cRevisa
		CS3->CS3_DTALT	:=	CT1->CT1_DTEXIS
		CS3->CS3_CODNAT	:=	CT1->CT1_NTSPED
		CS3->CS3_INDCTA	:=	IIF(CT1->CT1_CLASSE$"2","A","S")
		CS3->CS3_NIVEL	:=	5
		CS3->CS3_CTASUP	:=	CT1->CT1_CTASUP
		CS3->CS3_NOMECT	:=	CT1->CT1_DESC01
		CS3->CS3_CONTA	:=	CT1->CT1_CONTA
		MsUnLock()
	
	EndIf

	dbSelectArea("CT1")
	dbSkip()

EndDo

Return