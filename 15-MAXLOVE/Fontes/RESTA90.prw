#include "rwmake.ch"

User Function RESTA90()

Processa({|| CUSTO()},"@IMPORTANDO SB1")
Return

Static Function CUSTO()

_cArquivo	:=	"LINHA.DBF"


dbUseArea(.t.,"DBFCDX",_cArquivo ,"PRC",.f.,.f.)


dbSelectArea("PRC")
dbGoTop()
ProcRegua(RecCount())

While Eof() == .f.
	
	IncProc("Processando Importacao SB1...")
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+PRC->B1_COD,.F.)
		RecLock("SB1",.F.)
		SB1->B1_EMIN				:=	PRC->B1_EMIN
		SB1->B1_X_LINHA				:=	PRC->B1_X_LINHA
		MsUnLock()
	EndIf
	
	
	dbSelectArea("PRC")
	dbSkip()
EndDo

dbSelectArea("PRC")
dbCloseArea("PRC")

Return
