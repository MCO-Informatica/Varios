
#include "protheus.ch"
#include "topconn.ch"

/*
?????????????????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????????????ͻ??
??? Programa    ?FI040MNCP ? Efetua tratamento campo ARQCNAB                              ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
??? Observa??es ? Verion                                                                  ???
?????????????????????????????????????????????????????????????????????????????????????????͹??
?????????????????????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????????????????
*/

User Function FI040GRCP()

Local aAreaSE5:=SE5->(GetArea())

If !Empty(SE5->E5_ARQCNAB)
	If At("\", SE5->E5_ARQCNAB) > 0
		SE5->(RecLock("SE5", .f.))
		SE5->E5_ARQCNAB := Substr(AllTrim(SubStr(SE5->E5_ARQCNAB,Rat("\",SE5->E5_ARQCNAB)+1)),1,12)
		SE5->(msUnLock())
	EndIf
EndIf

cNomeArq->CP_ARQCNAB := SE5->E5_ARQCNAB

RestArea(aAreaSE5)

Return (Nil)
