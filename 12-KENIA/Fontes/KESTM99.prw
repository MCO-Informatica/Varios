#include "rwmake.ch"

User Function KESTM99()

Processa({||RunProc()},"Acerta Saldos Iniciais")
Return

Static Function RunProc()

_cQuery :=	""
_cQuery +=	"SELECT BJ_COD,BJ_LOCAL,SUM(BJ_QINI) BJ_QINI "
_cQuery +=	"FROM SBJ010 "
_cQuery +=	"WHERE BJ_DATA = '20111031' "
_cQuery +=	"GROUP BY BJ_COD,BJ_LOCAL "
_cQuery +=	"ORDER BY BJ_COD,BJ_LOCAL "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.F.)

dbSelectArea("QUERY")
ProcRegua(RecCount())

While !Eof()
	
	IncProc("Processando..."+QUERY->BJ_COD)
	
	DbSelectArea("SB9")
	DbSetOrder(1)
	If dbSeek(xFilial("SB9")+QUERY->BJ_COD+QUERY->BJ_LOCAL+'20111031',.F.)
		
		RecLock("SB9",.f.)
		SB9->B9_QINI   :=  QUERY->BJ_QINI
		MsUnLock()
	
	EndIf
	

	dbSelectArea("QUERY")
	dbSkip()
	
EndDo

Return()
