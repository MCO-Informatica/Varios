#include 'Protheus.ch'
#INCLUDE "TopConn.ch"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?NOVO8     ?Autor  ?Microsiga           ? Data ?  04/27/12   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?                                                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function MA650TOK()  
Local lRet := .t.


If cEmpAnt <> '01'
	Return lRet
Endif

If M->C2_XOP=="2"
	If Empty(M->C2_CLI)
		MsgStop("Aten??o Nesta Situa??o ? Obrigat?rio o Preenchimento do Campo xCliente !")
		lRet := .f.
	Endif
Endif 

Return lRet
