#include "rwmake.ch"

User Function RFATA90()

Processa({|| CUSTO()},"@IMPORTANDO SB1")
Return

Static Function CUSTO()

Local _cArquivo	:=	"GHPROD.DBF"
LOCAL aVetor := {}
PRIVATE lMsErroAuto := .F.

dbUseArea(.t.,"DBFCDXADS",_cArquivo ,"PRC",.f.,.f.)


dbSelectArea("PRC")
dbGoTop()
ProcRegua(RecCount())

While Eof() == .f.
	
	IncProc("Processando Importacao SB1...")
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If !dbSeek(xFilial("SB1")+PRC->B1_COD,.F.)

		//--- Exemplo: Inclusao --- //
		AADD(aVetor, {"B1_FILIAL", xFilial("SB1"), NIL})
		AADD(aVetor, {"B1_COD", PRC->B1_COD, NIL})
		AADD(aVetor, {"B1_DESC", UPPER(PRC->B1_DESC), NIL})
		AADD(aVetor, {"B1_TIPO", PRC->B1_TIPO, NIL})
		AADD(aVetor, {"B1_UM", PRC->B1_UM, NIL})
		AADD(aVetor, {"B1_LOCPAD", PRC->B1_LOCPAD, NIL})
		AADD(aVetor, {"B1_POSIPI", PRC->B1_POSIPI, NIL})
		AADD(aVetor, {"B1_ORIGEM", PRC->B1_ORIGEM, NIL})
		AADD(aVetor, {"B1_RASTRO", IIF(PRC->B1_TIPO$"PA/MP","L","N"), NIL})
		
		lMsErroAuto := .F.
		MSExecAuto({|x, y| Mata010(x, y)}, aVetor, 3)
		
		IF lMsErroAuto
		     MostraErro()
		ELSE
			dbSelectArea("PRC")
			aVetor := {}
		ENDIF 
	EndIf
	
	dbSelectArea("PRC")
	dbSkip()
EndDo

dbSelectArea("PRC")
dbCloseArea("PRC")

Return
