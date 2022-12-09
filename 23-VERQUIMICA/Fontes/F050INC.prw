#include 'protheus.ch'
#include 'parmtype.ch'

/*
	Esse fonte est� sendo utilizado para na inclus�o de PAs estando o fornecedor presente
	no par�metro da condicional, o titulo ja nasce liberado como automaticamente
*/

user function F050INC()
Local lRet := .T.	

If SE2->E2_TIPO == 'PA ' .AND. AllTrim(SE2->(E2_FORNECE+E2_LOJA)) $ AllTrim(GetMv("VQ_LAUTPA"))
	RecLock("SE2",.F.)
		SE2->E2_USUALIB := "AUTOMATICO"
		SE2->E2_DATALIB := dDataBase 
	MsUnlock()
EndIf

return lRet