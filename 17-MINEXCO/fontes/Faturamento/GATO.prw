#include "rwmake.ch"

User Function GATO()
Processa({||RunProc()},"Gera Inventario")
Return

Static Function RunProc()

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
ProcRegua(RecCount())

While Eof() == .f.

	IncProc("Processando...")
	
	dbSelectArea("SB7")
	dbSetOrder(1)
	If !dbSeek(xFilial("SB7")+"20100821"+SB1->B1_COD,.F.)

		RecLock("SB7",.t.)
		SB7->B7_FILIAL    	:= xFilial("SB7")
		SB7->B7_COD       	:= SB1->B1_COD
		SB7->B7_LOCAL		:= '01'
  		SB7->B7_LOTECTL   	:= 'INVENT'
  		SB7->B7_QUANT     	:= 0
  		SB7->B7_DOC       	:= 'GATO'
  		SB7->B7_DATA      	:= CTOD("21/08/2010")
  		SB7->B7_DTVALID   	:= CTOD("31/12/2020")
  		SB7->B7_LOCALIZ		:= '01'
  		SB7->B7_NUMSERI		:= 'INVENT'
		MsUnLock()
    EndIf
    
    dbSelectArea("SB1")
    dbSkip()
EndDo
 
Return()

