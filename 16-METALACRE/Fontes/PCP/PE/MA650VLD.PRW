#include 'Protheus.ch'
#INCLUDE "TopConn.ch"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MTA650I   ?Autor  ?Microsiga           ? Data ?  05/15/12   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?                                                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
       
User Function MA650VLD()

nRet:=0

If Inclui
	nRet:=1
Else       
	nRet:=2
Endif

Return(nRet)