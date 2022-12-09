#include "PROTHEUS.CH"
#include "RWMAKE.CH"

User Function RAJUSTDA1()


Processa({||RunProc()},"Ajusta Tabela Preco")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Grava Centro de Custo")
      

Static Function RunProc()

dbSelectArea("DA1")
dbSetOrder(1)

_nItem  := 0
_cTab	:= DA1->DA1_CODTAB

ProcRegua(RecCount())

While Eof() = .f. 

	IncProc("Processando Tabela "+DA1->DA1_CODTAB+" "+DA1->DA1_CODPRO)

	_cTab	:= DA1->DA1_CODTAB

	While DA1->DA1_CODTAB == _cTab
	    
		_nItem := _nItem + 1
		
		RecLock("DA1",.F.)
		DA1->DA1_ITEM	:=	StrZero(_nItem,4)
		MsUnLock()
	
		dbSkip()
	EndDo
	
	_nItem := 0
EndDo

Return
