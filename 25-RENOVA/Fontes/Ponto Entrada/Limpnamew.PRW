#include "Protheus.ch"
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?Limpcham  ?Autor  ?Rafael Alencar      ? Data ?  03/04/13   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?                                                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Renova Energia                                             ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function Limpcham()
dbSelectArea("SA1")

dbSetOrder(0)
dbGoTop()
 
Do While ! Eof()
 RecLock("SA1", .F.)
 SA1->A1_NOME := Limpnamew(SA1->A1_NOME)
 SA1->A1_NREDUZ := Limpnamew(SA1->A1_NREDUZ)
 MsUnlock()
 dbSkip()
Enddo     

U_Limpnamew()

Retorn (cTxt)
